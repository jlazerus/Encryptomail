require 'rubygems'
require 'gpgme'
require 'open-uri'

class KeyGenerator

	def self.generatePGPkeyGPGme(name, email, passphrase)
		puts "Attempting to create a PGP keypair via GPGme for #{name}, #{email}, #{passphrase}"
		ctx = GPGME::Ctx.new()

		fields = buildparamsblock(name, email, passphrase)

		# If pubkey and seckey are both set to nil, it stores the generated key pair into your key ring.
		# KEY IS NOT RETURNED, it is added to the Linux local keychain
		ctx.generate_key(fields, nil, nil)
	end

	def self.exportpublickeyGPGme(email)
		puts "Attempting to export public key via GPGme for #{email}"
		pub_key = GPGME::Key.find(:public, "#{email}")
		data = pub_key.first.export(:armor => true)
	end

	def self.importkey(pubkey)
		puts "Attempting to import public key #{pubkey}"
		GPGME::Key.import(pubkey)
	end

	def self.deletekey(email)
		puts "Attempting to delete public key for: #{email}"
		pub_key = GPGME::Key.find(:public, "#{email}")
		ctx = GPGME::Ctx.new()
		ctx.delete_key(pub_key[0], allow_secret = false)
	end

	def self.buildparamsblock(name, email, passphrase)
		block = []
		block << '<GnupgKeyParms format="internal">'
		block << 'Key-Type: DSA'
		block << 'Key-Length: 4096'
		block << 'Subkey-Type: ELG-E'
		block << 'Subkey-Length: 1024'
		block << "Name-Real: #{name}"
		block << 'Name-Comment: Includes passphrase'
		block << "Name-Email: #{email}"
		block << 'Expire-Date: 0'
		block << "Passphrase: #{passphrase}"
		block << '</GnupgKeyParms>'
		return block.join("\n")
	end

end