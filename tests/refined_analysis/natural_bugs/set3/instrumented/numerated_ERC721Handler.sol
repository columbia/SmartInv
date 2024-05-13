1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 import "../interfaces/IDepositExecute.sol";
6 import "./HandlerHelpers.sol";
7 import "../ERC721Safe.sol";
8 import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
9 import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
10 
11 
12 /**
13     @title Handles ERC721 deposits and deposit executions.
14     @author ChainSafe Systems.
15     @notice This contract is intended to be used with the Bridge contract.
16  */
17 contract ERC721Handler is IDepositExecute, HandlerHelpers, ERC721Safe {
18     using ERC165Checker for address;
19 
20     bytes4 private constant _INTERFACE_ERC721_METADATA = 0x5b5e139f;
21 
22     /**
23         @param bridgeAddress Contract address of previously deployed Bridge.
24      */
25     constructor(
26         address bridgeAddress
27     ) public HandlerHelpers(bridgeAddress) {
28     }
29 
30     /**
31         @notice A deposit is initiatied by making a deposit in the Bridge contract.
32         @param resourceID ResourceID used to find address of token to be used for deposit.
33         @param depositer Address of account making the deposit in the Bridge contract.
34         @param data Consists of {tokenID} padded to 32 bytes.
35         @notice Data passed into the function should be constructed as follows:
36         tokenID                                     uint256    bytes    0  - 32
37         @notice If the corresponding {tokenAddress} for the parsed {resourceID} supports {_INTERFACE_ERC721_METADATA},
38         then {metaData} will be set according to the {tokenURI} method in the token contract.
39         @dev Depending if the corresponding {tokenAddress} for the parsed {resourceID} is
40         marked true in {_burnList}, deposited tokens will be burned, if not, they will be locked.
41         @return metaData : the deposited token metadata acquired by calling a {tokenURI} method in the token contract.
42      */
43     function deposit(bytes32    resourceID,
44                     address     depositer,
45                     bytes       calldata data
46                     ) external override onlyBridge returns (bytes memory metaData) {
47         uint         tokenID;
48 
49         (tokenID) = abi.decode(data, (uint));
50 
51         address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
52         require(_contractWhitelist[tokenAddress], "provided tokenAddress is not whitelisted");
53 
54         // Check if the contract supports metadata, fetch it if it does
55         if (tokenAddress.supportsInterface(_INTERFACE_ERC721_METADATA)) {
56             IERC721Metadata erc721 = IERC721Metadata(tokenAddress);
57             metaData = bytes(erc721.tokenURI(tokenID));
58         }
59 
60         if (_burnList[tokenAddress]) {
61             burnERC721(tokenAddress, depositer, tokenID);
62         } else {
63             lockERC721(tokenAddress, depositer, address(this), tokenID);
64         }
65     }
66 
67     /**
68         @notice Proposal execution should be initiated when a proposal is finalized in the Bridge contract.
69         by a relayer on the deposit's destination chain.
70         @param data Consists of {tokenID}, {resourceID}, {lenDestinationRecipientAddress},
71         {destinationRecipientAddress}, {lenMeta}, and {metaData} all padded to 32 bytes.
72         @notice Data passed into the function should be constructed as follows:
73         tokenID                                     uint256    bytes    0  - 32
74         destinationRecipientAddress     length      uint256    bytes    32 - 64
75         destinationRecipientAddress                   bytes    bytes    64 - (64 + len(destinationRecipientAddress))
76         metadata                        length      uint256    bytes    (64 + len(destinationRecipientAddress)) - (64 + len(destinationRecipientAddress) + 32)
77         metadata                                      bytes    bytes    (64 + len(destinationRecipientAddress) + 32) - END
78      */
79     function executeProposal(bytes32 resourceID, bytes calldata data) external override onlyBridge {
80         uint         tokenID;
81         uint         lenDestinationRecipientAddress;
82         bytes memory destinationRecipientAddress;
83         uint         offsetMetaData;
84         uint         lenMetaData;
85         bytes memory metaData;
86 
87         (tokenID, lenDestinationRecipientAddress) = abi.decode(data, (uint, uint));
88         offsetMetaData = 64 + lenDestinationRecipientAddress;
89         destinationRecipientAddress = bytes(data[64:offsetMetaData]);
90         lenMetaData = abi.decode(data[offsetMetaData:], (uint));
91         metaData = bytes(data[offsetMetaData + 32:offsetMetaData + 32 + lenMetaData]);
92 
93         bytes20 recipientAddress;
94 
95         assembly {
96             recipientAddress := mload(add(destinationRecipientAddress, 0x20))
97         }
98 
99         address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
100         require(_contractWhitelist[address(tokenAddress)], "provided tokenAddress is not whitelisted");
101 
102         if (_burnList[tokenAddress]) {
103             mintERC721(tokenAddress, address(recipientAddress), tokenID, metaData);
104         } else {
105             releaseERC721(tokenAddress, address(this), address(recipientAddress), tokenID);
106         }
107     }
108 
109     /**
110         @notice Used to manually release ERC721 tokens from ERC721Safe.
111         @param data Consists of {tokenAddress}, {recipient}, and {tokenID} all padded to 32 bytes.
112         @notice Data passed into the function should be constructed as follows:
113         tokenAddress                           address     bytes  0 - 32
114         recipient                              address     bytes  32 - 64
115         tokenID                                uint        bytes  64 - 96
116      */
117     function withdraw(bytes memory data) external override onlyBridge {
118         address tokenAddress;
119         address recipient;
120         uint tokenID;
121 
122         (tokenAddress, recipient, tokenID) = abi.decode(data, (address, address, uint));
123 
124         releaseERC721(tokenAddress, address(this), recipient, tokenID);
125     }
126 }
