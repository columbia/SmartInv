1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
6 import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
7 
8 /**
9     @notice This contract refers to Openzeppelin's MinimalForwarder contract.
10  */
11 contract Forwarder is EIP712 {
12     using ECDSA for bytes32;
13 
14     struct ForwardRequest {
15         address from;
16         address to;
17         uint256 value;
18         uint256 gas;
19         uint256 nonce;
20         bytes data;
21     }
22 
23     bytes32 private constant _TYPEHASH =
24         keccak256("ForwardRequest(address from,address to,uint256 value,uint256 gas,uint256 nonce,bytes data)");
25 
26     mapping(address => uint256) private _nonces;
27 
28     constructor() EIP712("Forwarder", "0.0.1") public {}
29 
30     function getNonce(address from) public view returns (uint256) {
31         return _nonces[from];
32     }
33 
34     function verify(ForwardRequest calldata req, bytes calldata signature) public view returns (bool) {
35         address signer = _hashTypedDataV4(
36             keccak256(abi.encode(_TYPEHASH, req.from, req.to, req.value, req.gas, req.nonce, keccak256(req.data)))
37         ).recover(signature);
38         return _nonces[req.from] == req.nonce && signer == req.from;
39     }
40 
41     function execute(ForwardRequest calldata req, bytes calldata signature)
42         public
43         payable
44         returns (bool, bytes memory)
45     {
46         require(verify(req, signature), "MinimalForwarder: signature does not match request");
47         _nonces[req.from] = req.nonce + 1;
48 
49         (bool success, bytes memory returndata) = req.to.call{gas: req.gas, value: req.value}(
50             abi.encodePacked(req.data, req.from)
51         );
52         
53         assert(gasleft() > req.gas / 63);
54 
55         return (success, returndata);
56     }
57 }