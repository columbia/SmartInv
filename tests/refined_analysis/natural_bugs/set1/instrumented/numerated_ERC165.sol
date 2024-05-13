1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 import "./IERC165.sol";
6 
7 /**
8  * @dev Implementation of the {IERC165} interface.
9  *
10  * Contracts may inherit from this and call {_registerInterface} to declare
11  * their support of an interface.
12  */
13 abstract contract ERC165 is IERC165 {
14     /*
15      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
16      */
17     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
18 
19     /**
20      * @dev Mapping of interface ids to whether or not it's supported.
21      */
22     mapping(bytes4 => bool) private _supportedInterfaces;
23 
24     constructor () internal {
25         // Derived contracts need only register support for their own interfaces,
26         // we register support for ERC165 itself here
27         _registerInterface(_INTERFACE_ID_ERC165);
28     }
29 
30     /**
31      * @dev See {IERC165-supportsInterface}.
32      *
33      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
34      */
35     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
36         return _supportedInterfaces[interfaceId];
37     }
38 
39     /**
40      * @dev Registers the contract as an implementer of the interface defined by
41      * `interfaceId`. Support of the actual ERC165 interface is automatic and
42      * registering its interface id is not required.
43      *
44      * See {IERC165-supportsInterface}.
45      *
46      * Requirements:
47      *
48      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
49      */
50     function _registerInterface(bytes4 interfaceId) internal virtual {
51         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
52         _supportedInterfaces[interfaceId] = true;
53     }
54 }