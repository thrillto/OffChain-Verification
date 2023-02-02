pragma solidity ^0.8.17;

contract VerifySignature {
    function hashMessage(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function hashEthereumSignedMessage(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    function splitSignature(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function verifySignature(address _signer, string memory _message, bytes memory _sig) public pure returns (bool) {
        bytes32 messageHash = hashMessage(_message);
        bytes32 ethSignedMessageHash = hashEthereumSignedMessage(messageHash);

        return recoverSigner(ethSignedMessageHash, _sig) == _signer;
    }

    bool public isSigned;

    function signMessage(address _signer, bytes memory _sig) external {
        string memory message = "secret";

        bytes32 messageHash = hashMessage(message);
        bytes32 ethSignedMessageHash = hashEthereumSignedMessage(messageHash);

        require(recoverSigner(ethSignedMessageHash, _sig) == _signer, "invalid signature");
        isSigned = true;
    }
}
