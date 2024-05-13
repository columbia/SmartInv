1 /*
2 Original work taken from https://gist.github.com/rstormsf/7cfb0c6b7a835c0c67b4a394b4fd9383
3 Simplified VestingVault for one grant per address implementation from https://github.com/tapmydata/tap-protocol/blob/main/contracts/VestingVault.sol
4 
5 This version improves on the implementation in the following ways:
6 - Vesting has been made to support per-month instead of per-day
7 - All time calculations now use SafeMath to solve issues comparing execution time with lock time. SafeMath and primitive operators cannot be compared properly.
8 */
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.7.0;
11 
12 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
13 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
14 import "@openzeppelin/contracts/math/SafeMath.sol";
15 import "@openzeppelin/contracts/access/Ownable.sol";
16 
17 contract VestingVault is Ownable {
18     using SafeMath for uint256;
19     using SafeERC20 for IERC20;
20 
21     struct Grant {
22         uint256 startTime;
23         uint256 amount;
24         uint256 vestingDuration;
25         uint256 monthsClaimed;
26         uint256 totalClaimed;
27         address recipient;
28     }
29 
30     event GrantAdded(address indexed recipient);
31     event GrantTokensClaimed(address indexed recipient, uint256 amountClaimed);
32     event GrantRevoked(address recipient, uint256 amountVested, uint256 amountNotVested);
33 
34     IERC20 immutable public token;
35     
36     mapping (address => Grant) private tokenGrants;
37 
38     uint256 public totalVestingCount;
39 
40     constructor(IERC20 _token) public {
41         require(address(_token) != address(0));
42         token = _token;
43     }
44     
45     function addTokenGrant(
46         address _recipient,
47         uint256 _amount,
48         uint256 _vestingDurationInMonths,
49         uint256 _lockDurationInMonths    
50     ) 
51         external
52         onlyOwner
53     {
54         require(tokenGrants[_recipient].amount == 0, "Grant already exists, must revoke first.");
55         require(_vestingDurationInMonths <= 25*12, "Duration greater than 25 years");
56         require(_lockDurationInMonths <= 10*12, "Lock greater than 10 years");
57         require(_amount != 0, "Grant amount cannot be 0");
58         uint256 amountVestedPerMonth = _amount.div(_vestingDurationInMonths);
59         require(amountVestedPerMonth > 0, "amountVestedPerMonth > 0");
60 
61         Grant memory grant = Grant({
62             startTime: currentTime().add(_lockDurationInMonths.mul(30 days)),
63             amount: _amount,
64             vestingDuration: _vestingDurationInMonths,
65             monthsClaimed: 0,
66             totalClaimed: 0,
67             recipient: _recipient
68         });
69         tokenGrants[_recipient] = grant;
70         emit GrantAdded(_recipient);
71 
72         // Transfer the grant tokens under the control of the vesting contract
73         token.safeTransferFrom(owner(), address(this), _amount);
74     }
75 
76     /// @notice Allows a grant recipient to claim their vested tokens. Errors if no tokens have vested
77     function claimVestedTokens() external {
78         uint256 monthsVested;
79         uint256 amountVested;
80         (monthsVested, amountVested) = calculateGrantClaim(msg.sender);
81         require(amountVested > 0, "Vested is 0");
82 
83         Grant storage tokenGrant = tokenGrants[msg.sender];
84         tokenGrant.monthsClaimed = uint256(tokenGrant.monthsClaimed.add(monthsVested));
85         tokenGrant.totalClaimed = uint256(tokenGrant.totalClaimed.add(amountVested));
86         
87         emit GrantTokensClaimed(tokenGrant.recipient, amountVested);
88         token.safeTransfer(tokenGrant.recipient, amountVested);
89     }
90 
91     /// @notice Terminate token grant transferring all vested tokens to the `_recipient`
92     /// and returning all non-vested tokens to the contract owner
93     /// Secured to the contract owner only
94     /// @param _recipient address of the token grant recipient
95     function revokeTokenGrant(address _recipient) 
96         external 
97         onlyOwner
98     {
99         Grant storage tokenGrant = tokenGrants[_recipient];
100         uint256 monthsVested;
101         uint256 amountVested;
102         (monthsVested, amountVested) = calculateGrantClaim(_recipient);
103 
104         uint256 amountNotVested = (tokenGrant.amount.sub(tokenGrant.totalClaimed)).sub(amountVested);
105 
106         delete tokenGrants[_recipient];
107 
108         emit GrantRevoked(_recipient, amountVested, amountNotVested);
109 
110         // only transfer tokens if amounts are non-zero.
111         // Negative cases are covered by upperbound check in addTokenGrant and overflow protection using SafeMath
112         if (amountNotVested > 0) {
113           token.safeTransfer(owner(), amountNotVested);
114         }
115         if (amountVested > 0) {
116           token.safeTransfer(_recipient, amountVested);
117         }
118     }
119 
120     function getGrantStartTime(address _recipient) public view returns(uint256) {
121         Grant storage tokenGrant = tokenGrants[_recipient];
122         return tokenGrant.startTime;
123     }
124 
125     function getGrantAmount(address _recipient) public view returns(uint256) {
126         Grant storage tokenGrant = tokenGrants[_recipient];
127         return tokenGrant.amount;
128     }
129 
130     /// @notice Calculate the vested and unclaimed months and tokens available for `_grantId` to claim
131     /// Due to rounding errors once grant duration is reached, returns the entire left grant amount
132     /// Returns (0, 0) if lock duration has not been reached
133     function calculateGrantClaim(address _recipient) private view returns (uint256, uint256) {
134         Grant storage tokenGrant = tokenGrants[_recipient];
135 
136         require(tokenGrant.totalClaimed < tokenGrant.amount, "Grant fully claimed");
137 
138         // Check if lock duration was reached by comparing the current time with the startTime. If lock duration hasn't been reached, return 0, 0
139         if (currentTime() < tokenGrant.startTime) {
140             return (0, 0);
141         }
142 
143         // Elapsed months is the number of months since the startTime (after lock duration is complete)
144         // We add 1 to the calculation as any time after the unlock timestamp counts as the first elapsed month.
145         // For example: lock duration of 0 and current time at day 1, counts as elapsed month of 1
146         // Lock duration of 1 month and current time at day 31, counts as elapsed month of 2
147         // This is to accomplish the design that the first batch of vested tokens are claimable immediately after unlock.
148         uint256 elapsedMonths = currentTime().sub(tokenGrant.startTime).div(30 days).add(1); 
149      
150         // If over vesting duration, all tokens vested
151         if (elapsedMonths >= tokenGrant.vestingDuration) {
152             uint256 remainingGrant = tokenGrant.amount.sub(tokenGrant.totalClaimed);
153             return (tokenGrant.vestingDuration, remainingGrant);
154         } else {
155             uint256 monthsVested = uint256(elapsedMonths.sub(tokenGrant.monthsClaimed));
156             uint256 amountVestedPerMonth = tokenGrant.amount.div(uint256(tokenGrant.vestingDuration));
157             uint256 amountVested = uint256(monthsVested.mul(amountVestedPerMonth));
158             return (monthsVested, amountVested);
159         }
160     }
161 
162     function currentTime() private view returns(uint256) {
163         return block.timestamp;
164     }
165 }