1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 import "@openzeppelin/contracts/utils/math/SafeMath.sol";
5 import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
6 import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
7 import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";
8 
9 /**
10     @title Manages deposited ERC1155s.
11     @author ChainSafe Systems.
12     @notice This contract is intended to be used with ERC1155Handler contract.
13  */
14 contract ERC1155Safe {
15     using SafeMath for uint256;
16 
17     /**
18         @notice Used to gain custoday of deposited token with batching.
19         @param tokenAddress Address of ERC1155 to transfer.
20         @param owner Address of current token owner.
21         @param recipient Address to transfer token to.
22         @param tokenIDs IDs of tokens to transfer.
23         @param amounts Amounts of tokens to transfer.
24         @param data Additional data.
25      */
26     function lockBatchERC1155(address tokenAddress, address owner, address recipient, uint[] memory tokenIDs, uint[] memory amounts, bytes memory data) internal {
27         IERC1155 erc1155 = IERC1155(tokenAddress);
28         erc1155.safeBatchTransferFrom(owner, recipient, tokenIDs, amounts, data);
29     }
30 
31     /**
32         @notice Transfers custody of token to recipient with batching.
33         @param tokenAddress Address of ERC1155 to transfer.
34         @param owner Address of current token owner.
35         @param recipient Address to transfer token to.
36         @param tokenIDs IDs of tokens to transfer.
37         @param amounts Amounts of tokens to transfer.
38         @param data Additional data.
39      */
40     function releaseBatchERC1155(address tokenAddress, address owner, address recipient, uint256[] memory tokenIDs, uint[] memory amounts, bytes memory data) internal {
41         IERC1155 erc1155 = IERC1155(tokenAddress);
42         erc1155.safeBatchTransferFrom(owner, recipient, tokenIDs, amounts, data);
43     }
44 
45     /**
46         @notice Used to create new ERC1155s with batching.
47         @param tokenAddress Address of ERC1155 to mint.
48         @param recipient Address to mint token to.
49         @param tokenIDs IDs of tokens to mint.
50         @param amounts Amounts of token to mint.
51         @param data Additional data.
52      */
53     function mintBatchERC1155(address tokenAddress, address recipient, uint[] memory tokenIDs, uint[] memory amounts, bytes memory data) internal {
54         ERC1155PresetMinterPauser erc1155 = ERC1155PresetMinterPauser(tokenAddress);
55         erc1155.mintBatch(recipient, tokenIDs, amounts, data);
56     }
57 
58     /**
59         @notice Used to burn ERC1155s with batching.
60         @param tokenAddress Address of ERC1155 to burn.
61         @param tokenIDs IDs of tokens to burn.
62         @param amounts Amounts of tokens to burn.
63      */
64     function burnBatchERC1155(address tokenAddress, address owner, uint[] memory tokenIDs, uint[] memory amounts) internal {
65         ERC1155Burnable erc1155 = ERC1155Burnable(tokenAddress);
66         erc1155.burnBatch(owner, tokenIDs, amounts);
67     }
68 }
