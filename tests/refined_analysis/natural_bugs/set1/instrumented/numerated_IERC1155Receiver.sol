1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 /**
7  * _Available since v3.1._
8  * @dev omits the IERC165 interface, 
9  * as it is included within the diamondLoupeFacet. 
10  */
11 interface IERC1155Receiver  {
12 
13     /**
14         @dev Handles the receipt of a single ERC1155 token type. This function is
15         called at the end of a `safeTransferFrom` after the balance has been updated.
16         To accept the transfer, this must return
17         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
18         (i.e. 0xf23a6e61, or its own function selector).
19         @param operator The address which initiated the transfer (i.e. msg.sender)
20         @param from The address which previously owned the token
21         @param id The ID of the token being transferred
22         @param value The amount of tokens being transferred
23         @param data Additional data with no specified format
24         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
25     */
26     function onERC1155Received(
27         address operator,
28         address from,
29         uint256 id,
30         uint256 value,
31         bytes calldata data
32     )
33         external
34         returns(bytes4);
35 
36     /**
37         @dev Handles the receipt of a multiple ERC1155 token types. This function
38         is called at the end of a `safeBatchTransferFrom` after the balances have
39         been updated. To accept the transfer(s), this must return
40         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
41         (i.e. 0xbc197c81, or its own function selector).
42         @param operator The address which initiated the batch transfer (i.e. msg.sender)
43         @param from The address which previously owned the token
44         @param ids An array containing ids of each token being transferred (order and length must match values array)
45         @param values An array containing amounts of each token being transferred (order and length must match ids array)
46         @param data Additional data with no specified format
47         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
48     */
49     function onERC1155BatchReceived(
50         address operator,
51         address from,
52         uint256[] calldata ids,
53         uint256[] calldata values,
54         bytes calldata data
55     )
56         external
57         returns(bytes4);
58 }
