1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 import "../../introspection/IERC165.sol";
7 
8 /**
9  * @dev _Available since v3.1._
10  */
11 interface IERC1155Receiver is IERC165 {
12     /**
13      * @dev Handles the receipt of a single ERC1155 token type. This function is
14      * called at the end of a `safeTransferFrom` after the balance has been updated.
15      *
16      * NOTE: To accept the transfer, this must return
17      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
18      * (i.e. 0xf23a6e61, or its own function selector).
19      *
20      * @param operator The address which initiated the transfer (i.e. msg.sender)
21      * @param from The address which previously owned the token
22      * @param id The ID of the token being transferred
23      * @param value The amount of tokens being transferred
24      * @param data Additional data with no specified format
25      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
26      */
27     function onERC1155Received(
28         address operator,
29         address from,
30         uint256 id,
31         uint256 value,
32         bytes calldata data
33     ) external returns (bytes4);
34 
35     /**
36      * @dev Handles the receipt of a multiple ERC1155 token types. This function
37      * is called at the end of a `safeBatchTransferFrom` after the balances have
38      * been updated.
39      *
40      * NOTE: To accept the transfer(s), this must return
41      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
42      * (i.e. 0xbc197c81, or its own function selector).
43      *
44      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
45      * @param from The address which previously owned the token
46      * @param ids An array containing ids of each token being transferred (order and length must match values array)
47      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
48      * @param data Additional data with no specified format
49      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
50      */
51     function onERC1155BatchReceived(
52         address operator,
53         address from,
54         uint256[] calldata ids,
55         uint256[] calldata values,
56         bytes calldata data
57     ) external returns (bytes4);
58 }