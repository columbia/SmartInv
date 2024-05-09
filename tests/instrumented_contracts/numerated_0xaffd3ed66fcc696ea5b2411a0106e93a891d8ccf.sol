1 {{
2   "language": "Solidity",
3   "sources": {
4     "/contracts/RightClickMyToad.sol": {
5       "content": "// SPDX-License-Identifier: MIT\npragma solidity >=0.8.0 <0.9.0;\n\nimport \"@openzeppelin/contracts/token/ERC1155/IERC1155.sol\";\n\ncontract RightClickMyToad {\n  IERC1155 nft;\n\n  constructor() {\n      nft = IERC1155(0x808b0825e51a681e62209Adb5E6B21EcE3E9C87A);\n  }\n\n  function rightClick() public {\n    nft.safeTransferFrom(address(this), msg.sender, 1, 1, \"\");\n  }\n  \n  function onERC1155Received(address, address, uint256, uint256, bytes calldata) external pure returns(bytes4) {\n    return bytes4(keccak256(\"onERC1155Received(address,address,uint256,uint256,bytes)\"));\n  }\n}"
6     },
7     "@openzeppelin/contracts/utils/introspection/IERC165.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC165 standard, as defined in the\n * https://eips.ethereum.org/EIPS/eip-165[EIP].\n *\n * Implementers can declare support of contract interfaces, which can then be\n * queried by others ({ERC165Checker}).\n *\n * For an implementation, see {ERC165}.\n */\ninterface IERC165 {\n    /**\n     * @dev Returns true if this contract implements the interface defined by\n     * `interfaceId`. See the corresponding\n     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]\n     * to learn more about how these ids are created.\n     *\n     * This function call must use less than 30 000 gas.\n     */\n    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n}\n"
9     },
10     "@openzeppelin/contracts/token/ERC1155/IERC1155.sol": {
11       "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"../../utils/introspection/IERC165.sol\";\n\n/**\n * @dev Required interface of an ERC1155 compliant contract, as defined in the\n * https://eips.ethereum.org/EIPS/eip-1155[EIP].\n *\n * _Available since v3.1._\n */\ninterface IERC1155 is IERC165 {\n    /**\n     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.\n     */\n    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);\n\n    /**\n     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all\n     * transfers.\n     */\n    event TransferBatch(\n        address indexed operator,\n        address indexed from,\n        address indexed to,\n        uint256[] ids,\n        uint256[] values\n    );\n\n    /**\n     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to\n     * `approved`.\n     */\n    event ApprovalForAll(address indexed account, address indexed operator, bool approved);\n\n    /**\n     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.\n     *\n     * If an {URI} event was emitted for `id`, the standard\n     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value\n     * returned by {IERC1155MetadataURI-uri}.\n     */\n    event URI(string value, uint256 indexed id);\n\n    /**\n     * @dev Returns the amount of tokens of token type `id` owned by `account`.\n     *\n     * Requirements:\n     *\n     * - `account` cannot be the zero address.\n     */\n    function balanceOf(address account, uint256 id) external view returns (uint256);\n\n    /**\n     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.\n     *\n     * Requirements:\n     *\n     * - `accounts` and `ids` must have the same length.\n     */\n    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)\n        external\n        view\n        returns (uint256[] memory);\n\n    /**\n     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,\n     *\n     * Emits an {ApprovalForAll} event.\n     *\n     * Requirements:\n     *\n     * - `operator` cannot be the caller.\n     */\n    function setApprovalForAll(address operator, bool approved) external;\n\n    /**\n     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.\n     *\n     * See {setApprovalForAll}.\n     */\n    function isApprovedForAll(address account, address operator) external view returns (bool);\n\n    /**\n     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.\n     *\n     * Emits a {TransferSingle} event.\n     *\n     * Requirements:\n     *\n     * - `to` cannot be the zero address.\n     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.\n     * - `from` must have a balance of tokens of type `id` of at least `amount`.\n     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the\n     * acceptance magic value.\n     */\n    function safeTransferFrom(\n        address from,\n        address to,\n        uint256 id,\n        uint256 amount,\n        bytes calldata data\n    ) external;\n\n    /**\n     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.\n     *\n     * Emits a {TransferBatch} event.\n     *\n     * Requirements:\n     *\n     * - `ids` and `amounts` must have the same length.\n     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the\n     * acceptance magic value.\n     */\n    function safeBatchTransferFrom(\n        address from,\n        address to,\n        uint256[] calldata ids,\n        uint256[] calldata amounts,\n        bytes calldata data\n    ) external;\n}\n"
12     }
13   },
14   "settings": {
15     "remappings": [],
16     "optimizer": {
17       "enabled": false,
18       "runs": 200
19     },
20     "evmVersion": "istanbul",
21     "libraries": {},
22     "outputSelection": {
23       "*": {
24         "*": [
25           "evm.bytecode",
26           "evm.deployedBytecode",
27           "devdoc",
28           "userdoc",
29           "metadata",
30           "abi"
31         ]
32       }
33     }
34   }
35 }}