name "openssl-version-override"

# This will override the default version of "chef"
override :openssl, version: "1.1.1q"

dependency "openssl"

version("1.1.1q") { source sha256: "d7939ce614029cdff0b6c20f0e2e5703158a489a72b2507b8bd51bf8c8fd10ca" }
