1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 import "../interfaces/IGenericHandler.sol";
6 
7 /**
8     @title Handles generic deposits and deposit executions.
9     @author ChainSafe Systems.
10     @notice This contract is intended to be used with the Bridge contract.
11  */
12 contract GenericHandler is IGenericHandler {
13     address public immutable _bridgeAddress;
14 
15     // resourceID => contract address
16     mapping (bytes32 => address) public _resourceIDToContractAddress;
17 
18     // contract address => resourceID
19     mapping (address => bytes32) public _contractAddressToResourceID;
20 
21     // contract address => deposit function signature
22     mapping (address => bytes4) public _contractAddressToDepositFunctionSignature;
23 
24     // contract address => depositer address position offset in the metadata
25     mapping (address => uint256) public _contractAddressToDepositFunctionDepositerOffset;
26 
27     // contract address => execute proposal function signature
28     mapping (address => bytes4) public _contractAddressToExecuteFunctionSignature;
29 
30     // token contract address => is whitelisted
31     mapping (address => bool) public _contractWhitelist;
32 
33     modifier onlyBridge() {
34         _onlyBridge();
35         _;
36     }
37 
38     function _onlyBridge() private view {
39         require(msg.sender == _bridgeAddress, "sender must be bridge contract");
40     }
41 
42     /**
43         @param bridgeAddress Contract address of previously deployed Bridge.
44      */
45     constructor(
46         address          bridgeAddress
47     ) public {
48         _bridgeAddress = bridgeAddress;
49     }
50 
51     /**
52         @notice First verifies {_resourceIDToContractAddress}[{resourceID}] and
53         {_contractAddressToResourceID}[{contractAddress}] are not already set,
54         then sets {_resourceIDToContractAddress} with {contractAddress},
55         {_contractAddressToResourceID} with {resourceID},
56         {_contractAddressToDepositFunctionSignature} with {depositFunctionSig},
57         {_contractAddressToDepositFunctionDepositerOffset} with {depositFunctionDepositerOffset},
58         {_contractAddressToExecuteFunctionSignature} with {executeFunctionSig},
59         and {_contractWhitelist} to true for {contractAddress}.
60         @param resourceID ResourceID to be used when making deposits.
61         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
62         @param depositFunctionSig Function signature of method to be called in {contractAddress} when a deposit is made.
63         @param depositFunctionDepositerOffset Depositer address position offset in the metadata, in bytes.
64         @param executeFunctionSig Function signature of method to be called in {contractAddress} when a deposit is executed.
65      */
66     function setResource(
67         bytes32 resourceID,
68         address contractAddress,
69         bytes4 depositFunctionSig,
70         uint256 depositFunctionDepositerOffset,
71         bytes4 executeFunctionSig
72     ) external onlyBridge override {
73 
74         _setResource(resourceID, contractAddress, depositFunctionSig, depositFunctionDepositerOffset, executeFunctionSig);
75     }
76 
77     /**
78         @notice A deposit is initiatied by making a deposit in the Bridge contract.
79         @param resourceID ResourceID used to find address of contract to be used for deposit.
80         @param depositer Address of the account making deposit in the Bridge contract.
81         @param data Consists of: {resourceID}, {lenMetaData}, and {metaData} all padded to 32 bytes.
82         @notice Data passed into the function should be constructed as follows:
83         len(data)                              uint256     bytes  0  - 32
84         data                                   bytes       bytes  64 - END
85         @notice {contractAddress} is required to be whitelisted
86         @notice If {_contractAddressToDepositFunctionSignature}[{contractAddress}] is set,
87         {metaData} is expected to consist of needed function arguments.
88         @return Returns the raw bytes returned from the call to {contractAddress}.
89      */
90     function deposit(bytes32 resourceID, address depositer, bytes calldata data) external onlyBridge returns (bytes memory) {
91         uint256      lenMetadata;
92         bytes memory metadata;
93 
94         lenMetadata = abi.decode(data, (uint256));
95         metadata = bytes(data[32:32 + lenMetadata]);
96 
97         address contractAddress = _resourceIDToContractAddress[resourceID];
98         uint256 depositerOffset = _contractAddressToDepositFunctionDepositerOffset[contractAddress];
99         if (depositerOffset > 0) {
100             uint256 metadataDepositer;
101             // Skipping 32 bytes of length prefix and depositerOffset bytes.
102             assembly {
103                 metadataDepositer := mload(add(add(metadata, 32), depositerOffset))
104             }
105             // metadataDepositer contains 0xdepositerAddressdepositerAddressdeposite************************
106             // Shift it 12 bytes right:   0x000000000000000000000000depositerAddressdepositerAddressdeposite
107             require(depositer == address(uint160(metadataDepositer >> 96)), 'incorrect depositer in the data');
108         }
109 
110         require(_contractWhitelist[contractAddress], "provided contractAddress is not whitelisted");
111 
112         bytes4 sig = _contractAddressToDepositFunctionSignature[contractAddress];
113         if (sig != bytes4(0)) {
114             bytes memory callData = abi.encodePacked(sig, metadata);
115             (bool success, bytes memory handlerResponse) = contractAddress.call(callData);
116             require(success, "call to contractAddress failed");
117             return handlerResponse;
118         }
119     }
120 
121     /**
122         @notice Proposal execution should be initiated when a proposal is finalized in the Bridge contract.
123         @param data Consists of {resourceID}, {lenMetaData}, and {metaData}.
124         @notice Data passed into the function should be constructed as follows:
125         len(data)                              uint256     bytes  0  - 32
126         data                                   bytes       bytes  32 - END
127         @notice {contractAddress} is required to be whitelisted
128         @notice If {_contractAddressToExecuteFunctionSignature}[{contractAddress}] is set,
129         {metaData} is expected to consist of needed function arguments.
130      */
131     function executeProposal(bytes32 resourceID, bytes calldata data) external onlyBridge {
132         uint256      lenMetadata;
133         bytes memory metaData;
134 
135         lenMetadata = abi.decode(data, (uint256));
136         metaData = bytes(data[32:32 + lenMetadata]);
137 
138         address contractAddress = _resourceIDToContractAddress[resourceID];
139         require(_contractWhitelist[contractAddress], "provided contractAddress is not whitelisted");
140 
141         bytes4 sig = _contractAddressToExecuteFunctionSignature[contractAddress];
142         if (sig != bytes4(0)) {
143             bytes memory callData = abi.encodePacked(sig, metaData);
144             (bool success,) = contractAddress.call(callData);
145             require(success, "delegatecall to contractAddress failed");
146         }
147     }
148 
149     function _setResource(
150         bytes32 resourceID,
151         address contractAddress,
152         bytes4 depositFunctionSig,
153         uint256 depositFunctionDepositerOffset,
154         bytes4 executeFunctionSig
155     ) internal {
156         _resourceIDToContractAddress[resourceID] = contractAddress;
157         _contractAddressToResourceID[contractAddress] = resourceID;
158         _contractAddressToDepositFunctionSignature[contractAddress] = depositFunctionSig;
159         _contractAddressToDepositFunctionDepositerOffset[contractAddress] = depositFunctionDepositerOffset;
160         _contractAddressToExecuteFunctionSignature[contractAddress] = executeFunctionSig;
161 
162         _contractWhitelist[contractAddress] = true;
163     }
164 }
