1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 import "../../introspection/IERC165.sol";
7 
8 /**
9  * @dev Required interface of an ERC1155 compliant contract, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
11  *
12  * _Available since v3.1._
13  */
14 interface IERC1155 is IERC165 {
15     /**
16      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
17      */
18     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
19 
20     /**
21      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
22      * transfers.
23      */
24     event TransferBatch(
25         address indexed operator,
26         address indexed from,
27         address indexed to,
28         uint256[] ids,
29         uint256[] values
30     );
31 
32     /**
33      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
34      * `approved`.
35      */
36     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
37 
38     /**
39      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
40      *
41      * If an {URI} event was emitted for `id`, the standard
42      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
43      * returned by {IERC1155MetadataURI-uri}.
44      */
45     event URI(string value, uint256 indexed id);
46 
47     /**
48      * @dev Returns the amount of tokens of token type `id` owned by `account`.
49      *
50      * Requirements:
51      *
52      * - `account` cannot be the zero address.
53      */
54     function balanceOf(address account, uint256 id) external view returns (uint256);
55 
56     /**
57      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
58      *
59      * Requirements:
60      *
61      * - `accounts` and `ids` must have the same length.
62      */
63     function balanceOfBatch(
64         address[] calldata accounts,
65         uint256[] calldata ids
66     ) external view returns (uint256[] memory);
67 
68     /**
69      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
70      *
71      * Emits an {ApprovalForAll} event.
72      *
73      * Requirements:
74      *
75      * - `operator` cannot be the caller.
76      */
77     function setApprovalForAll(address operator, bool approved) external;
78 
79     /**
80      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
81      *
82      * See {setApprovalForAll}.
83      */
84     function isApprovedForAll(address account, address operator) external view returns (bool);
85 
86     /**
87      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
88      *
89      * Emits a {TransferSingle} event.
90      *
91      * Requirements:
92      *
93      * - `to` cannot be the zero address.
94      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
95      * - `from` must have a balance of tokens of type `id` of at least `amount`.
96      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
97      * acceptance magic value.
98      */
99     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
100 
101     /**
102      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
103      *
104      * Emits a {TransferBatch} event.
105      *
106      * Requirements:
107      *
108      * - `ids` and `amounts` must have the same length.
109      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
110      * acceptance magic value.
111      */
112     function safeBatchTransferFrom(
113         address from,
114         address to,
115         uint256[] calldata ids,
116         uint256[] calldata amounts,
117         bytes calldata data
118     ) external;
119 }