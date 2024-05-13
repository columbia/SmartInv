1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {AccessControlDefaultAdminRules} from "openzeppelin-contracts/contracts/access/AccessControlDefaultAdminRules.sol";
5 import {IRewardRecipient} from "./interfaces/IRewardRecipient.sol";
6 import {IOracleAdapter} from "./interfaces/IOracleAdapter.sol";
7 import {Errors} from "./libraries/Errors.sol";
8 import {DataTypes} from "./libraries/DataTypes.sol";
9 
10 /**
11  * @title OracleAdapter
12  * @notice An oracle adapter contract for handling voluntary exits and dissolving validators.
13  * @dev This contract facilitates interactions between PirexEth, the reward recipient, and oracles for managing validators.
14  * @author redactedcartel.finance
15  */
16 contract OracleAdapter is IOracleAdapter, AccessControlDefaultAdminRules {
17     // General state variables
18     /**
19      * @notice Address of the PirexEth contract.
20      * @dev This variable holds the address of the PirexEth contract, which is utilized for handling voluntary exits and dissolving validators.
21      */
22     address public pirexEth;
23 
24     /**
25      * @notice Instance of the reward recipient contract.
26      * @dev This variable represents the instance of the reward recipient contract, which manages the distribution of rewards to validators.
27      */
28     IRewardRecipient public rewardRecipient;
29 
30     /**
31      * @notice Role identifier for the oracle role.
32      * @dev This constant defines the role identifier for the oracle role, which is required for initiating certain operations related to oracles.
33      */
34     bytes32 private constant ORACLE_ROLE = keccak256("ORACLE_ROLE");
35 
36     /**
37      * @notice Role identifier for the governance role.
38      * @dev This constant defines the role identifier for the governance role, which has the authority to set contract addresses and perform other governance-related actions.
39      */
40     bytes32 private constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");
41 
42     // Events
43     /**
44      * @notice Emitted when a contract address is set.
45      * @dev This event signals that a contract address has been updated.
46      * @param c               DataTypes.Contract indexed Contract.
47      * @param contractAddress address                    Contract address.
48      */
49     event SetContract(DataTypes.Contract indexed c, address contractAddress);
50 
51     /**
52      * @notice Emitted when a request for voluntary exit is sent.
53      * @dev This event signals that a request for a validator's voluntary exit has been initiated.
54      * @param pubKey bytes Key.
55      */
56     event RequestValidatorExit(bytes pubKey);
57 
58     /**
59      * @notice Constructor to set the initial delay for access control.
60      * @param _initialDelay uint48 Delay required to schedule the acceptance.
61      */
62     constructor(
63         uint48 _initialDelay
64     ) AccessControlDefaultAdminRules(_initialDelay, msg.sender) {}
65 
66     /**
67      * @notice Set a contract address.
68      * @dev Only callable by addresses with the GOVERNANCE_ROLE.
69      * @param _contract       enum    Contract.
70      * @param contractAddress address Contract address.
71      */
72     function setContract(
73         DataTypes.Contract _contract,
74         address contractAddress
75     ) external onlyRole(GOVERNANCE_ROLE) {
76         if (contractAddress == address(0)) revert Errors.ZeroAddress();
77 
78         emit SetContract(_contract, contractAddress);
79 
80         if (_contract == DataTypes.Contract.PirexEth) {
81             pirexEth = contractAddress;
82         } else if (_contract == DataTypes.Contract.RewardRecipient) {
83             rewardRecipient = IRewardRecipient(contractAddress);
84         } else {
85             revert Errors.UnrecorgnisedContract();
86         }
87     }
88 
89     /**
90      * @notice Send the request for voluntary exit.
91      * @dev Only callable by the PirexEth contract.
92      * @param _pubKey bytes Key.
93      */
94     function requestVoluntaryExit(bytes calldata _pubKey) external override {
95         if (msg.sender != address(pirexEth)) revert Errors.NotPirexEth();
96 
97         emit RequestValidatorExit(_pubKey);
98     }
99 
100     /**
101      * @notice Dissolve validator.
102      * @dev Only callable by the oracle role.
103      * @param _pubKey bytes   Key.
104      * @param _amount uint256 ETH amount.
105      */
106     function dissolveValidator(
107         bytes calldata _pubKey,
108         uint256 _amount
109     ) external onlyRole(ORACLE_ROLE) {
110         rewardRecipient.dissolveValidator(_pubKey, _amount);
111     }
112 }
