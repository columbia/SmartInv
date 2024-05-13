1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 import "../interfaces/IDepositExecute.sol";
6 import "./HandlerHelpers.sol";
7 import "../ERC20Safe.sol";
8 
9 /**
10     @title Handles ERC20 deposits and deposit executions.
11     @author ChainSafe Systems.
12     @notice This contract is intended to be used with the Bridge contract.
13  */
14 contract ERC20Handler is IDepositExecute, HandlerHelpers, ERC20Safe {
15     /**
16         @param bridgeAddress Contract address of previously deployed Bridge.
17      */
18     constructor(
19         address          bridgeAddress
20     ) public HandlerHelpers(bridgeAddress) {
21     }
22 
23     /**
24         @notice A deposit is initiatied by making a deposit in the Bridge contract.
25         @param resourceID ResourceID used to find address of token to be used for deposit.
26         @param depositer Address of account making the deposit in the Bridge contract.
27         @param data Consists of {amount} padded to 32 bytes.
28         @notice Data passed into the function should be constructed as follows:
29         amount                      uint256     bytes   0 - 32
30         @dev Depending if the corresponding {tokenAddress} for the parsed {resourceID} is
31         marked true in {_burnList}, deposited tokens will be burned, if not, they will be locked.
32         @return an empty data.
33      */
34     function deposit(
35         bytes32 resourceID,
36         address depositer,
37         bytes   calldata data
38     ) external override onlyBridge returns (bytes memory) {
39         uint256        amount;
40         (amount) = abi.decode(data, (uint));
41 
42         address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
43         require(_contractWhitelist[tokenAddress], "provided tokenAddress is not whitelisted");
44 
45         if (_burnList[tokenAddress]) {
46             burnERC20(tokenAddress, depositer, amount);
47         } else {
48             lockERC20(tokenAddress, depositer, address(this), amount);
49         }
50     }
51 
52     /**
53         @notice Proposal execution should be initiated when a proposal is finalized in the Bridge contract.
54         by a relayer on the deposit's destination chain.
55         @param data Consists of {resourceID}, {amount}, {lenDestinationRecipientAddress},
56         and {destinationRecipientAddress} all padded to 32 bytes.
57         @notice Data passed into the function should be constructed as follows:
58         amount                                 uint256     bytes  0 - 32
59         destinationRecipientAddress length     uint256     bytes  32 - 64
60         destinationRecipientAddress            bytes       bytes  64 - END
61      */
62     function executeProposal(bytes32 resourceID, bytes calldata data) external override onlyBridge {
63         uint256       amount;
64         uint256       lenDestinationRecipientAddress;
65         bytes  memory destinationRecipientAddress;
66 
67         (amount, lenDestinationRecipientAddress) = abi.decode(data, (uint, uint));
68         destinationRecipientAddress = bytes(data[64:64 + lenDestinationRecipientAddress]);
69 
70         bytes20 recipientAddress;
71         address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
72 
73         assembly {
74             recipientAddress := mload(add(destinationRecipientAddress, 0x20))
75         }
76 
77         require(_contractWhitelist[tokenAddress], "provided tokenAddress is not whitelisted");
78 
79         if (_burnList[tokenAddress]) {
80             mintERC20(tokenAddress, address(recipientAddress), amount);
81         } else {
82             releaseERC20(tokenAddress, address(recipientAddress), amount);
83         }
84     }
85 
86     /**
87         @notice Used to manually release ERC20 tokens from ERC20Safe.
88         @param data Consists of {tokenAddress}, {recipient}, and {amount} all padded to 32 bytes.
89         @notice Data passed into the function should be constructed as follows:
90         tokenAddress                           address     bytes  0 - 32
91         recipient                              address     bytes  32 - 64
92         amount                                 uint        bytes  64 - 96
93      */
94     function withdraw(bytes memory data) external override onlyBridge {
95         address tokenAddress;
96         address recipient;
97         uint amount;
98 
99         (tokenAddress, recipient, amount) = abi.decode(data, (address, address, uint));
100 
101         releaseERC20(tokenAddress, recipient, amount);
102     }
103 }
