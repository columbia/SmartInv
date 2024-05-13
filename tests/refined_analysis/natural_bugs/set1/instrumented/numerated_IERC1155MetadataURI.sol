1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 import "./IERC1155.sol";
6 
7 /**
8  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
9  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
10  *
11  * _Available since v3.1._
12  */
13 interface IERC1155MetadataURI is IERC1155 {
14     /**
15      * @dev Returns the URI for token type `id`.
16      *
17      * If the `\{id\}` substring is present in the URI, it must be replaced by
18      * clients with the actual token type ID.
19      */
20     function uri(uint256 id) external view returns (string memory);
21 }