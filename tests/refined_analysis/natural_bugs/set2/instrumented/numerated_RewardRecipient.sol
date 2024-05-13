1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
5 import {DataTypes} from "./libraries/DataTypes.sol";
6 import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";
7 import {IPirexEth} from "./interfaces/IPirexEth.sol";
8 import {Errors} from "./libraries/Errors.sol";
9 
10 /**
11  * @title RewardRecipient
12  * @notice Manages rewards for validators and handles associated functionalities.
13  * @dev Inherits from AccessControlDefaultAdminRules to control access to critical functions.
14  * @author redactedcartel.finance
15  */
16 contract RewardRecipient is AccessControlDefaultAdminRules {
17     /**
18      * @notice The role assigned to external keepers responsible for specific protocol functions.
19      * @dev This constant represents the keccak256 hash of the string "KEEPER_ROLE".
20      */
21     bytes32 private constant KEEPER_ROLE = keccak256("KEEPER_ROLE");
22 
23     /**
24      * @notice The role assigned to governance entities responsible for managing protocol parameters.
25      * @dev This constant represents the keccak256 hash of the string "GOVERNANCE_ROLE".
26      */
27     bytes32 private constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");
28 
29     // Pirex contracts
30     /**
31      * @notice The IPirexEth interface for interacting with the PirexEth contract.
32      * @dev This interface defines the methods available for communication with the PirexEth contract.
33      */
34     IPirexEth public pirexEth;
35 
36     /**
37      * @notice The OracleAdapter contract responsible for interfacing with the oracle for protocol data.
38      * @dev This contract provides receives update when validator is dissolved.
39      */
40     IOracleAdapter public oracleAdapter;
41 
42     // Events
43     /**
44      * @notice Emitted when a contract address is set.
45      * @dev Signals changes to contract addresses, indicating updates to PirexEth or OracleAdapter.
46      * @param c               DataTypes.Contract Enum indicating the contract type.
47      * @param contractAddress address            The new address of the contract.
48      */
49     event SetContract(DataTypes.Contract indexed c, address contractAddress);
50 
51     // Modifiers
52     /**
53      * @notice Modifier to restrict access to the function only to the Oracle Adapter.
54      * @dev Reverts with an error if the caller is not the Oracle Adapter.
55      */
56     modifier onlyOracleAdapter() {
57         if (msg.sender != address(oracleAdapter))
58             revert Errors.NotOracleAdapter();
59         _;
60     }
61 
62     /**
63      * @notice Constructor to set the admin and initial delay for access control transfer.
64      * @dev Initializes the contract with the specified admin address and initial delay for access control transfer.
65      * @param _admin        address Admin address.
66      * @param _initialDelay uint48  Initial delay required for the acceptance of an access control transfer.
67      */
68     constructor(
69         address _admin,
70         uint48 _initialDelay
71     ) AccessControlDefaultAdminRules(_initialDelay, _admin) {}
72 
73     /**
74      * @notice Set a contract address.
75      * @dev Allows a contract address to be set by the governance role.
76      * @param _contract       enum    Contract.
77      * @param contractAddress address Contract address.
78      */
79     function setContract(
80         DataTypes.Contract _contract,
81         address contractAddress
82     ) external onlyRole(GOVERNANCE_ROLE) {
83         if (contractAddress == address(0)) revert Errors.ZeroAddress();
84 
85         emit SetContract(_contract, contractAddress);
86 
87         if (_contract == DataTypes.Contract.PirexEth) {
88             pirexEth = IPirexEth(contractAddress);
89         } else if (_contract == DataTypes.Contract.OracleAdapter) {
90             oracleAdapter = IOracleAdapter(contractAddress);
91         } else {
92             revert Errors.UnrecorgnisedContract();
93         }
94     }
95 
96     /**
97      * @notice Dissolve a validator.
98      * @dev Allows the dissolution of a validator by the OracleAdapter.
99      * @param _pubKey bytes   Key of the validator.
100      * @param _amount uint256 ETH amount.
101      */
102     function dissolveValidator(
103         bytes calldata _pubKey,
104         uint256 _amount
105     ) external onlyOracleAdapter {
106         pirexEth.dissolveValidator{value: _amount}(_pubKey);
107     }
108 
109     /**
110      * @notice Slash a validator.
111      * @dev Allows the slashing of a validator by a Keeper, potentially using a buffer for penalty compensation.
112      * @param _pubKey         bytes                     Key of the validator.
113      * @param _removeIndex    uint256                   Validator public key index.
114      * @param _amount         uint256                   ETH amount released from Beacon chain.
115      * @param _unordered      bool                      Removed in a gas-efficient way or not.
116      * @param _useBuffer      bool                      Whether to use a buffer to compensate for the penalty.
117      * @param _burnerAccounts DataTypes.BurnerAccount[] Burner accounts.
118      */
119     function slashValidator(
120         bytes calldata _pubKey,
121         uint256 _removeIndex,
122         uint256 _amount,
123         bool _unordered,
124         bool _useBuffer,
125         DataTypes.BurnerAccount[] calldata _burnerAccounts
126     ) external payable onlyRole(KEEPER_ROLE) {
127         if (_useBuffer && msg.value > 0) {
128             revert Errors.NoETHAllowed();
129         }
130         pirexEth.slashValidator{value: _amount + msg.value}(
131             _pubKey,
132             _removeIndex,
133             _amount,
134             _unordered,
135             _useBuffer,
136             _burnerAccounts
137         );
138     }
139 
140     /**
141      * @notice Harvest and mint staking rewards.
142      * @dev Allows a Keeper to trigger the harvest of staking rewards and mint the corresponding amount of ETH.
143      * @param _amount   uint256 Amount of ETH to be harvested.
144      * @param _endBlock uint256 Block until which ETH rewards are computed.
145      */
146     function harvest(
147         uint256 _amount,
148         uint256 _endBlock
149     ) external onlyRole(KEEPER_ROLE) {
150         pirexEth.harvest{value: _amount}(_endBlock);
151     }
152 
153     /**
154      * @notice Receive MEV rewards.
155      * @dev Allows the contract to receive MEV rewards in the form of ETH.
156      */
157     receive() external payable {}
158 }
