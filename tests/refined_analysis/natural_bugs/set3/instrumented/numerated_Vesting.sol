1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.6;
4 
5 import "@openzeppelin/contracts-4.2.0/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts-4.2.0/utils/math/Math.sol";
7 import "@openzeppelin/contracts-upgradeable-4.2.0/proxy/utils/Initializable.sol";
8 import "@openzeppelin/contracts-4.2.0/utils/Context.sol";
9 import "./SimpleGovernance.sol";
10 
11 /**
12  * @title Vesting
13  * @dev A token holder contract that can release its token balance gradually like a
14  * typical vesting scheme, with a cliff and vesting period. Owner has the power
15  * to change the beneficiary who receives the vested tokens.
16  */
17 contract Vesting is Initializable, Context {
18     using SafeERC20 for IERC20;
19 
20     event Released(uint256 amount);
21     event VestingInitialized(
22         address indexed beneficiary,
23         uint256 startTimestamp,
24         uint256 cliff,
25         uint256 duration
26     );
27     event SetBeneficiary(address indexed beneficiary);
28 
29     // beneficiary of tokens after they are released
30     address public beneficiary;
31     IERC20 public token;
32 
33     uint256 public cliffInSeconds;
34     uint256 public durationInSeconds;
35     uint256 public startTimestamp;
36     uint256 public released;
37 
38     /**
39      * @dev Sets the beneficiary to _msgSender() on deploying this contract. This prevents others from
40      * initializing the logic contract.
41      */
42     constructor() public {
43         beneficiary = _msgSender();
44     }
45 
46     /**
47      * @dev Limits certain functions to be called by governance
48      */
49     modifier onlyGovernance() {
50         require(
51             _msgSender() == governance(),
52             "only governance can perform this action"
53         );
54         _;
55     }
56 
57     /**
58      * @dev Initializes a vesting contract that vests its balance of any ERC20 token to the
59      * _beneficiary, monthly in a linear fashion until duration has passed. By then all
60      * of the balance will have vested.
61      * @param _token address of the token that is subject to vesting
62      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
63      * @param _cliffInSeconds duration in months of the cliff in which tokens will begin to vest
64      * @param _durationInSeconds duration in months of the period in which the tokens will vest
65      * @param _startTimestamp start timestamp when the cliff and vesting should start to count
66      */
67     function initialize(
68         address _token,
69         address _beneficiary,
70         uint256 _startTimestamp,
71         uint256 _cliffInSeconds,
72         uint256 _durationInSeconds
73     ) external initializer {
74         require(_token != address(0), "_token cannot be empty");
75         // dev: beneficiary is set to msg.sender on logic contracts during deployment
76         require(beneficiary == address(0), "cannot initialize logic contract");
77         require(_beneficiary != address(0), "_beneficiary cannot be empty");
78         require(_startTimestamp != 0, "startTimestamp cannot be 0");
79         require(
80             _startTimestamp <= block.timestamp,
81             "startTimestamp cannot be from the future"
82         );
83         require(_durationInSeconds != 0, "duration cannot be 0");
84         require(
85             _cliffInSeconds <= _durationInSeconds,
86             "cliff is greater than duration"
87         );
88 
89         token = IERC20(_token);
90         beneficiary = _beneficiary;
91         startTimestamp = _startTimestamp;
92         durationInSeconds = _durationInSeconds;
93         cliffInSeconds = _cliffInSeconds;
94 
95         emit VestingInitialized(
96             _beneficiary,
97             _startTimestamp,
98             _cliffInSeconds,
99             _durationInSeconds
100         );
101     }
102 
103     /**
104      * @notice Transfers vested tokens to beneficiary.
105      */
106     function release() external {
107         uint256 vested = vestedAmount();
108         require(vested > 0, "No tokens to release");
109 
110         released = released + vested;
111         emit Released(vested);
112         token.safeTransfer(beneficiary, vested);
113     }
114 
115     /**
116      * @notice Calculates the amount that has already vested but hasn't been released yet.
117      */
118     function vestedAmount() public view returns (uint256) {
119         uint256 blockTimestamp = block.timestamp;
120         uint256 _durationInSeconds = durationInSeconds;
121 
122         uint256 elapsedTime = blockTimestamp - startTimestamp; // @dev startTimestamp is always less than blockTimestamp
123 
124         if (elapsedTime < cliffInSeconds) {
125             return 0;
126         }
127 
128         // If over vesting duration, all tokens vested
129         if (elapsedTime >= _durationInSeconds) {
130             return token.balanceOf(address(this));
131         } else {
132             uint256 currentBalance = token.balanceOf(address(this));
133 
134             // If there are no tokens in this contract yet, return 0.
135             if (currentBalance == 0) {
136                 return 0;
137             }
138 
139             uint256 totalBalance = currentBalance + released;
140             uint256 vested = (totalBalance * elapsedTime) / _durationInSeconds;
141             uint256 unreleased = vested - released;
142 
143             return unreleased;
144         }
145     }
146 
147     /**
148      * @notice Changes beneficiary who receives the vested token.
149      * @dev Only governance can call this function. This is to be used in case the target address
150      * needs to be updated. If the previous beneficiary has any unclaimed tokens, the new beneficiary
151      * will be able to claim them and the rest of the vested tokens.
152      * @param newBeneficiary new address to become the beneficiary
153      */
154     function changeBeneficiary(address newBeneficiary) external onlyGovernance {
155         require(
156             newBeneficiary != beneficiary,
157             "beneficiary must be different from current one"
158         );
159         require(newBeneficiary != address(0), "beneficiary cannot be empty");
160         beneficiary = newBeneficiary;
161         emit SetBeneficiary(newBeneficiary);
162     }
163 
164     /**
165      * @notice Governance who owns this contract.
166      * @dev Governance of the token contract also owns this vesting contract.
167      */
168     function governance() public view returns (address) {
169         return SimpleGovernance(address(token)).governance();
170     }
171 }
