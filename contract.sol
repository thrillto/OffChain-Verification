pragma solidity ^0.8.17;

contract VerifySignature {
    // Hashes the input message and returns its keccak256 hash
    function hashMessage(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    // Hashes the Ethereum signed message and returns its keccak256 hash
    function hashEthereumSignedMessage(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    // Splits the signature into its r, s, and v components
    function splitSignature(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        // Ensure the signature length is 65
        require(_sig.length == 65, "invalid signature length");

        assembly {
            // Load r component of signature
            r := mload(add(_sig, 32))
            // Load s component of signature
            s := mload(add(_sig, 64))
            // Load v component of signature
            v := byte(0, mload(add(_sig, 96)))
        }
    }

    // Recovers the signer of the message from its signature
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns (address) {
        // Split the signature into its r, s, and v components
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_sig);
        // Use ecrecover to recover the signer from the message hash and signature components
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    // Verifies the signature of a message
    function verifySignature(address _signer, string memory _message, bytes memory _sig) public pure returns (bool) {
        // Hash the input message
        bytes32 messageHash = hashMessage(_message);
        // Hash the Ethereum signed message
        bytes32 ethSignedMessageHash = hashEthereumSignedMessage(messageHash);
        // Compare the recovered signer to the expected signer to verify the signature
        return recoverSigner(ethSignedMessageHash, _sig) == _signer;
    }

    // Public variable to store the signing status
    bool public isSigned;

    // Function to sign a message
    function signMessage(address _signer, bytes memory _sig) external {
        // The message to be signed
        string memory message = "secret";

        // Hash the message
        bytes32 messageHash = hashMessage(message);
        // Hash the Ethereum signed message
        bytes32 ethSignedMessageHash = hashEthereumSignedMessage(messageHash);

        // Ensure the signature is valid by checking the recovered signer
        require(recoverSigner(ethSignedMessageHash, _sig) == _signer, "invalid signature");
        // Set the signing status to true
        isSigned = true;
    }
}
