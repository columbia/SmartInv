1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {ECDSA} from "@openzeppelin/contracts/cryptography/ECDSA.sol";
5 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
6 
7 interface IERC1271 {
8     function isValidSignature(bytes32 _messageHash, bytes memory _signature)
9         external
10         view
11         returns (bytes4 magicValue);
12 }
13 
14 library SignatureChecker {
15     function isValidSignature(
16         address signer,
17         bytes32 hash,
18         bytes memory signature
19     ) internal view returns (bool) {
20         if (Address.isContract(signer)) {
21             bytes4 selector = IERC1271.isValidSignature.selector;
22             (bool success, bytes memory returndata) =
23                 signer.staticcall(abi.encodeWithSelector(selector, hash, signature));
24             return success && abi.decode(returndata, (bytes4)) == selector;
25         } else {
26             return ECDSA.recover(hash, signature) == signer;
27         }
28     }
29 }
30 
31 /// @title ERC1271
32 /// @notice Module for ERC1271 compatibility
33 abstract contract ERC1271 is IERC1271 {
34     // Valid magic value bytes4(keccak256("isValidSignature(bytes32,bytes)")
35     bytes4 internal constant VALID_SIG = IERC1271.isValidSignature.selector;
36     // Invalid magic value
37     bytes4 internal constant INVALID_SIG = bytes4(0);
38 
39     modifier onlyValidSignature(bytes32 permissionHash, bytes memory signature) {
40         require(
41             isValidSignature(permissionHash, signature) == VALID_SIG,
42             "ERC1271: Invalid signature"
43         );
44         _;
45     }
46 
47     function _getOwner() internal view virtual returns (address owner);
48 
49     function isValidSignature(bytes32 permissionHash, bytes memory signature)
50         public
51         view
52         override
53         returns (bytes4)
54     {
55         return
56             SignatureChecker.isValidSignature(_getOwner(), permissionHash, signature)
57                 ? VALID_SIG
58                 : INVALID_SIG;
59     }
60 }
