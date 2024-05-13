1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {AccessControl} from "openzeppelin-contracts/contracts/access/AccessControl.sol";
5 import {Functions, FunctionsClient} from "./vendor/chainlink/functions/FunctionsClient.sol";
6 import {Errors} from "./libraries/Errors.sol";
7 import {IPirexEth} from "./interfaces/IPirexEth.sol";
8 import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";
9 
10 /**
11  * @title ChainlinkFunctionsOracleAdapter
12  * @dev An Oracle Adapter using Chainlink FunctionsClient to interact with Chainlink Oracle.
13  * @author redactedcartel.finance
14  */
15 contract ChainlinkFunctionsOracleAdapter is
16     IOracleAdapter,
17     FunctionsClient,
18     AccessControl
19 {
20     using Functions for Functions.Request;
21 
22     // General state variables
23 
24     /**
25      * @notice Instance of the PirexEth contract.
26      */
27     IPirexEth public pirexEth;
28 
29     /**
30      * @notice Unique identifier for the subscription.
31      */
32     uint64 public subscriptionId;
33 
34     /**
35      * @notice Gas limit for transactions.
36      */
37     uint32 public gasLimit;
38 
39     /**
40      * @notice Mapping to store the relationship between request ID and validator public key.
41      */
42     mapping(bytes32 => bytes) public requestIdToValidatorPubKey;
43 
44     /**
45      * @notice Source code information.
46      */
47     string public source;
48 
49     // Events
50 
51     /**
52      * @notice Emits when the PirexEth contract is set.
53      * @dev This event signals that the address of the PirexEth contract has been updated.
54      * @param pirexEth address The address of the PirexEth contract.
55      */
56     event SetPirexEth(address pirexEth);
57 
58     /**
59      * @notice Emitted when a validator requests to exit.
60      * @dev This event signals that a validator with a specific public key has requested to exit.
61      * @param validatorPubKey bytes The public key of the exiting validator.
62      */
63     event RequestValidatorExit(bytes validatorPubKey);
64 
65     /**
66      * @notice Emitted when the source code is set.
67      * @dev This event indicates that the source code string has been updated.
68      * @param source string The source code string.
69      */
70     event SetSourceCode(string source);
71 
72     /**
73      * @notice Emitted when the subscription ID is set.
74      * @dev This event signals that the subscription ID has been updated.
75      * @param subscriptionId uint64 The new subscription ID.
76      */
77     event SetSubscriptionId(uint64 subscriptionId);
78 
79     /**
80      * @notice Emitted when the gas limit is set.
81      * @dev This event signals that the gas limit has been updated.
82      * @param gasLimit uint32 The new gas limit.
83      */
84     event SetGasLimit(uint32 gasLimit);
85 
86     /**
87      * @notice Constructor to set the Oracle address and initialize access control.
88      * @param oracle address Oracle address.
89      */
90     constructor(address oracle) FunctionsClient(oracle) {
91         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
92     }
93 
94     /**
95      * @notice Set source code for Chainlink request.
96      * @dev Only callable by the admin role.
97      * @param _source string Source code to be set.
98      */
99     function setSourceCode(
100         string calldata _source
101     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
102         source = _source;
103         emit SetSourceCode(_source);
104     }
105 
106     /**
107      * @notice Set subscription identifier for Chainlink request.
108      * @dev Only callable by the admin role.
109      * @param _subscriptionId uint64 Subscription identifier to be set.
110      */
111     function setSubscriptionId(
112         uint64 _subscriptionId
113     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
114         subscriptionId = _subscriptionId;
115         emit SetSubscriptionId(_subscriptionId);
116     }
117 
118     /**
119      * @notice Set gas limit for Chainlink request.
120      * @dev Only callable by the admin role.
121      * @param _gasLimit uint32 Gas limit to be set.
122      */
123     function setGasLimit(
124         uint32 _gasLimit
125     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
126         gasLimit = _gasLimit;
127         emit SetGasLimit(_gasLimit);
128     }
129 
130     /**
131      * @notice Send the request for voluntary exit.
132      * @dev Only callable by the PirexEth contract.
133      * @param _pubKey bytes Validator public key.
134      */
135     function requestVoluntaryExit(bytes calldata _pubKey) external override {
136         if (msg.sender != address(pirexEth)) revert Errors.NotPirexEth();
137 
138         Functions.Request memory req;
139 
140         // Get pubKey
141         string[] memory args = new string[](1);
142         args[0] = string(_pubKey);
143 
144         req.initializeRequest(
145             Functions.Location.Inline,
146             Functions.CodeLanguage.JavaScript,
147             source
148         );
149         req.addArgs(args);
150 
151         bytes32 assignedReqID = sendRequest(req, subscriptionId, gasLimit);
152         requestIdToValidatorPubKey[assignedReqID] = _pubKey;
153         emit RequestValidatorExit(_pubKey);
154     }
155 
156     /**
157      * @inheritdoc FunctionsClient
158      * @dev Internal function to fulfill the Chainlink request and dissolve the validator.
159      */
160     function fulfillRequest(
161         bytes32 requestId,
162         bytes memory response,
163         bytes memory
164     ) internal override {
165         assert(
166             keccak256(response) ==
167                 keccak256(requestIdToValidatorPubKey[requestId])
168         );
169 
170         // dissolve validator
171         pirexEth.dissolveValidator(response);
172     }
173 
174     /**
175      * @notice Set the PirexEth contract address.
176      * @dev Only callable by the admin role.
177      * @param _pirexEth address  PirexEth contract address.
178      */
179     function setPirexEth(
180         address _pirexEth
181     ) external onlyRole(DEFAULT_ADMIN_ROLE) {
182         if (_pirexEth == address(0)) revert Errors.ZeroAddress();
183 
184         emit SetPirexEth(_pirexEth);
185 
186         pirexEth = IPirexEth(_pirexEth);
187     }
188 }
