1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 import "../interfaces/IDepositExecute.sol";
6 import "./HandlerHelpers.sol";
7 import "../ERC1155Safe.sol";
8 import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
9 import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
10 import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
11 
12 contract ERC1155Handler is IDepositExecute, HandlerHelpers, ERC1155Safe, ERC1155Holder {
13     using ERC165Checker for address;
14 
15     bytes4 private constant _INTERFACE_ERC1155_METADATA = 0x0e89341c;
16     bytes private constant EMPTY_BYTES = "";
17 
18     /**
19         @param bridgeAddress Contract address of previously deployed Bridge.
20      */
21     constructor(
22         address bridgeAddress
23     ) public HandlerHelpers(bridgeAddress) {
24     }
25 
26     /**
27         @notice A deposit is initiatied by making a deposit in the Bridge contract.
28         @param resourceID ResourceID used to find address of token to be used for deposit.
29         @param depositer Address of account making the deposit in the Bridge contract.
30         @param data Consists of ABI-encoded arrays of tokenIDs and amounts.
31      */
32     function deposit(bytes32 resourceID, address depositer, bytes calldata data) external override onlyBridge returns (bytes memory metaData) {
33         uint[] memory tokenIDs;
34         uint[] memory amounts;
35 
36         (tokenIDs, amounts) = abi.decode(data, (uint[], uint[]));
37 
38         address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
39         require(tokenAddress != address(0), "provided resourceID does not exist");
40 
41         if (_burnList[tokenAddress]) {
42             burnBatchERC1155(tokenAddress, depositer, tokenIDs, amounts);
43         } else {
44             lockBatchERC1155(tokenAddress, depositer, address(this), tokenIDs, amounts, EMPTY_BYTES);
45         }
46     }
47 
48     /**
49         @notice Proposal execution should be initiated when a proposal is finalized in the Bridge contract.
50         by a relayer on the deposit's destination chain.
51         @param data Consists of ABI-encoded {tokenIDs}, {amounts}, {recipient},
52         and {transferData} of types uint[], uint[], bytes, bytes.
53      */
54     function executeProposal(bytes32 resourceID, bytes calldata data) external override onlyBridge {
55         uint[] memory tokenIDs;
56         uint[] memory amounts;
57         bytes memory recipient;
58         bytes memory transferData;
59 
60         (tokenIDs, amounts, recipient, transferData) = abi.decode(data, (uint[], uint[], bytes, bytes));
61 
62         bytes20 recipientAddress;
63 
64         assembly {
65             recipientAddress := mload(add(recipient, 0x20))
66         }
67 
68         address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
69         require(_contractWhitelist[address(tokenAddress)], "provided tokenAddress is not whitelisted");
70 
71         if (_burnList[tokenAddress]) {
72             mintBatchERC1155(tokenAddress, address(recipientAddress), tokenIDs, amounts, transferData);
73         } else {
74             releaseBatchERC1155(tokenAddress, address(this), address(recipientAddress), tokenIDs, amounts, transferData);
75         }
76     }
77 
78     /**
79         @notice Used to manually release ERC1155 tokens from ERC1155Safe.
80         @param data Consists of ABI-encoded {tokenAddress}, {recipient}, {tokenIDs}, 
81         {amounts}, and {transferData} of types address, address, uint[], uint[], bytes.
82      */
83     function withdraw(bytes memory data) external override onlyBridge {
84         address tokenAddress;
85         address recipient;
86         uint[] memory tokenIDs;
87         uint[] memory amounts;
88         bytes memory transferData;
89 
90         (tokenAddress, recipient, tokenIDs, amounts, transferData) = abi.decode(data, (address, address, uint[], uint[], bytes));
91 
92         releaseBatchERC1155(tokenAddress, address(this), recipient, tokenIDs, amounts, transferData);
93     }
94 }
