# OffChain-Verification

The VerifySignature contract is a smart contract that helps you verify the authenticity of digital signatures. It has a bunch of functions that help you with the process.

For example, the hashMessage function takes a message and returns its hash. The hashEthereumSignedMessage function takes the message hash and returns the hash of the signed message with the Ethereum signature prefix.

The splitSignature function helps you split a signature into its components, which you'll need later to recover the signer. The recoverSigner function takes the signed message hash and signature as input and returns the signer's address.

The verifySignature function is what you'll use to verify if a message was signed by a specific address. You give it the signer address, message, and signature and it returns a true or false to let you know if the signature is valid.

Finally, the signMessage function is a test function that checks if a signature is valid for a predefined message "secret". If the signature is valid, it sets the isSigned flag to true.
