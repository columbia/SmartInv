1 {{
2   "language": "Solidity",
3   "sources": {
4     "bridge_minter.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.10;\n\nimport \"minter.sol\";\n\ncontract BridgeMinter{\n    address private notary;\n    address private approver;\n    address private tokenAddress;\n    bool private bridging;\n    uint256 private chainId;\n    bytes32 private domainSeparator;\n\n    mapping(bytes32 => bool) private nonces;\n\n    event Bridged(address receiver, uint256 amount);\n    event TransferOwnership(address indexed owner, bool indexed confirmed);\n\n    constructor(address _approver, address _notary, address _tokenAddress, uint256 _chainId){\n        require(_approver != address(0));     // dev: invalid approver\n        require(_notary != address(0));       // dev: invalid notary\n        require(_tokenAddress != address(0)); // dev: invalid notary\n        approver = _approver;\n        notary = _notary;\n        tokenAddress = _tokenAddress;\n        chainId = _chainId;\n\n        domainSeparator = keccak256(\n            abi.encode(\n                keccak256(\"EIP712Domain(string name,string version,uint256 chainId)\"),\n                keccak256(\"Neptune Bridge\"), \n                keccak256(\"0.0.1\"), \n                _chainId\n            )\n        );\n    }\n\n    modifier checkNonce(bytes32 nonce) {\n        require(nonces[nonce]==false); // dev: already processed\n        _;\n    }\n\n    function bridge(address sender, uint256 bridgedAmount, bytes32 nonce, bytes32 messageHash, bytes calldata approvedMessage, bytes calldata notarizedMessage) \n    external checkNonce(nonce){\n        require(bridging == false);                                                //dev: re-entrancy guard\n        bridging = true;\n        bytes32 hashToVerify = keccak256(\n            abi.encode(keccak256(\"SignedMessage(bytes32 key,address sender,uint256 amount)\"),nonce,sender,bridgedAmount)\n        );\n\n        require(checkEncoding(approvedMessage,messageHash,hashToVerify,approver)); //dev: invalid signature\n        require(checkEncoding(notarizedMessage,messageHash,hashToVerify,notary));  //dev: invalid signature\n        nonces[nonce]=true;\n\n        IMinter(tokenAddress).mint(sender, bridgedAmount);\n\n        emit Bridged(sender, bridgedAmount);\n        bridging = false;\n    }\n\n    function checkEncoding(bytes memory signedMessage,bytes32 messageHash, bytes32 hashToVerify, address signer) \n    internal view returns(bool){\n\n        bytes32 domainSeparatorHash = keccak256(abi.encodePacked(\"\\x19\\x01\", domainSeparator, hashToVerify));\n        require(messageHash == domainSeparatorHash); //dev: values do not match\n\n        return signer == recoverSigner(messageHash, signedMessage);\n    }\n\n    function splitSignature(bytes memory sig)\n    internal pure returns (uint8 v, bytes32 r, bytes32 s){\n        require(sig.length == 65); // dev: signature invalid\n\n        assembly {\n            // first 32 bytes, after the length prefix.\n            r := mload(add(sig, 32))\n            // second 32 bytes.\n            s := mload(add(sig, 64))\n            // final byte (first byte of the next 32 bytes).\n            v := byte(0, mload(add(sig, 96)))\n        }\n\n        return (v, r, s);\n    }\n\n    function recoverSigner(bytes32 message, bytes memory sig)\n    internal pure returns (address){\n        uint8 v;\n        bytes32 r;\n        bytes32 s;\n\n        (v, r, s) = splitSignature(sig);\n\n        return tryRecover(message, v, r, s);\n    }\n\n    function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)\n    internal \n    pure \n    returns (address) {\n        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {\n            return address(0);\n        } else if (v != 27 && v != 28) {\n            return address(0);\n        }\n\n        // If the signature is valid (and not malleable), return the signer address\n        address signer = ecrecover(hash, v, r, s);\n        if (signer == address(0)) {\n            return address(0);\n        }\n\n        return signer;\n    }\n}"
6     },
7     "minter.sol": {
8       "content": "// SPDX-License-Identifier: Unlicensed\npragma solidity ^0.8.10;\n\n/**\n * @dev Interface of to mint ERC20 tokens.\n */\ninterface IMinter {\n    function mint(address to, uint256 value) external;\n}"
9     }
10   },
11   "settings": {
12     "evmVersion": "istanbul",
13     "optimizer": {
14       "enabled": true,
15       "runs": 1000
16     },
17     "libraries": {
18       "bridge_minter.sol": {}
19     },
20     "outputSelection": {
21       "*": {
22         "*": [
23           "evm.bytecode",
24           "evm.deployedBytecode",
25           "devdoc",
26           "userdoc",
27           "metadata",
28           "abi"
29         ]
30       }
31     }
32   }
33 }}