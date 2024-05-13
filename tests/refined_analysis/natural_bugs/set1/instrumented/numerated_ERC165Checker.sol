1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.2.0/contracts/utils/introspection/ERC165.sol
7  * Modified to allow checking multiple interfaces w/o checking general 165 support.
8  */
9 
10 import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
11 
12 /**
13  * @title Library to query ERC165 support.
14  * @dev Library used to query support of an interface declared via {IERC165}.
15  *
16  * Note that these functions return the actual result of the query: they do not
17  * `revert` if an interface is not supported. It is up to the caller to decide
18  * what to do in these cases.
19  */
20 library ERC165Checker {
21   // As per the EIP-165 spec, no interface should ever match 0xffffffff
22   bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
23 
24   /**
25    * @dev Returns true if `account` supports the {IERC165} interface,
26    */
27   function supportsERC165(address account) internal view returns (bool) {
28     // Any contract that implements ERC165 must explicitly indicate support of
29     // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
30     return
31       supportsERC165Interface(account, type(IERC165).interfaceId) &&
32       !supportsERC165Interface(account, _INTERFACE_ID_INVALID);
33   }
34 
35   /**
36    * @dev Returns true if `account` supports the interface defined by
37    * `interfaceId`. Support for {IERC165} itself is queried automatically.
38    *
39    * See {IERC165-supportsInterface}.
40    */
41   function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
42     // query support of both ERC165 as per the spec and support of _interfaceId
43     return supportsERC165(account) && supportsERC165Interface(account, interfaceId);
44   }
45 
46   /**
47    * @dev Returns a boolean array where each value corresponds to the
48    * interfaces passed in and whether they're supported or not. This allows
49    * you to batch check interfaces for a contract where your expectation
50    * is that some interfaces may not be supported.
51    *
52    * See {IERC165-supportsInterface}.
53    *
54    * _Available since v3.4._
55    */
56   function getSupportedInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool[] memory) {
57     // an array of booleans corresponding to interfaceIds and whether they're supported or not
58     bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
59 
60     // query support of ERC165 itself
61     if (supportsERC165(account)) {
62       // query support of each interface in interfaceIds
63       unchecked {
64         for (uint256 i = 0; i < interfaceIds.length; ++i) {
65           interfaceIdsSupported[i] = supportsERC165Interface(account, interfaceIds[i]);
66         }
67       }
68     }
69 
70     return interfaceIdsSupported;
71   }
72 
73   /**
74    * @dev Returns true if `account` supports all the interfaces defined in
75    * `interfaceIds`. Support for {IERC165} itself is queried automatically.
76    *
77    * Batch-querying can lead to gas savings by skipping repeated checks for
78    * {IERC165} support.
79    *
80    * See {IERC165-supportsInterface}.
81    */
82   function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
83     // query support of ERC165 itself
84     if (!supportsERC165(account)) {
85       return false;
86     }
87 
88     // query support of each interface in _interfaceIds
89     unchecked {
90       for (uint256 i = 0; i < interfaceIds.length; ++i) {
91         if (!supportsERC165Interface(account, interfaceIds[i])) {
92           return false;
93         }
94       }
95     }
96 
97     // all interfaces supported
98     return true;
99   }
100 
101   /**
102    * @notice Query if a contract implements an interface, does not check ERC165 support
103    * @param account The address of the contract to query for support of an interface
104    * @param interfaceId The interface identifier, as specified in ERC-165
105    * @return true if the contract at account indicates support of the interface with
106    * identifier interfaceId, false otherwise
107    * @dev Assumes that account contains a contract that supports ERC165, otherwise
108    * the behavior of this method is undefined. This precondition can be checked
109    * with {supportsERC165}.
110    * Interface identification is specified in ERC-165.
111    */
112   function supportsERC165Interface(address account, bytes4 interfaceId) internal view returns (bool) {
113     bytes memory encodedParams = abi.encodeWithSelector(IERC165(account).supportsInterface.selector, interfaceId);
114     (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
115     if (result.length < 32) return false;
116     return success && abi.decode(result, (bool));
117   }
118 }
