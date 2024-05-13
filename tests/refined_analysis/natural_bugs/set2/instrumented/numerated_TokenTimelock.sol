1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 // Inspired by OpenZeppelin TokenTimelock contract
5 // Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/TokenTimelock.sol
6 
7 import "../utils/Timed.sol";
8 import "./ITokenTimelock.sol";
9 
10 abstract contract TokenTimelock is ITokenTimelock, Timed {
11     /// @notice ERC20 basic token contract being held in timelock
12     IERC20 public override lockedToken;
13 
14     /// @notice beneficiary of tokens after they are released
15     address public override beneficiary;
16 
17     /// @notice pending beneficiary appointed by current beneficiary
18     address public override pendingBeneficiary;
19 
20     /// @notice initial balance of lockedToken
21     uint256 public override initialBalance;
22 
23     uint256 internal lastBalance;
24 
25     /// @notice number of seconds before releasing is allowed
26     uint256 public immutable cliffSeconds;
27 
28     address public immutable clawbackAdmin;
29 
30     constructor(
31         address _beneficiary,
32         uint256 _duration,
33         uint256 _cliffSeconds,
34         address _lockedToken,
35         address _clawbackAdmin
36     ) Timed(_duration) {
37         require(_duration != 0, "TokenTimelock: duration is 0");
38         require(_beneficiary != address(0), "TokenTimelock: Beneficiary must not be 0 address");
39 
40         beneficiary = _beneficiary;
41         _initTimed();
42 
43         _setLockedToken(_lockedToken);
44 
45         cliffSeconds = _cliffSeconds;
46 
47         clawbackAdmin = _clawbackAdmin;
48     }
49 
50     // Prevents incoming LP tokens from messing up calculations
51     modifier balanceCheck() {
52         if (totalToken() > lastBalance) {
53             uint256 delta = totalToken() - lastBalance;
54             initialBalance = initialBalance + delta;
55         }
56         _;
57         lastBalance = totalToken();
58     }
59 
60     modifier onlyBeneficiary() {
61         require(msg.sender == beneficiary, "TokenTimelock: Caller is not a beneficiary");
62         _;
63     }
64 
65     /// @notice releases `amount` unlocked tokens to address `to`
66     function release(address to, uint256 amount) external override onlyBeneficiary balanceCheck {
67         require(amount != 0, "TokenTimelock: no amount desired");
68         require(passedCliff(), "TokenTimelock: Cliff not passed");
69 
70         uint256 available = availableForRelease();
71         require(amount <= available, "TokenTimelock: not enough released tokens");
72 
73         _release(to, amount);
74     }
75 
76     /// @notice releases maximum unlocked tokens to address `to`
77     function releaseMax(address to) external override onlyBeneficiary balanceCheck {
78         require(passedCliff(), "TokenTimelock: Cliff not passed");
79         _release(to, availableForRelease());
80     }
81 
82     /// @notice the total amount of tokens held by timelock
83     function totalToken() public view virtual override returns (uint256) {
84         return lockedToken.balanceOf(address(this));
85     }
86 
87     /// @notice amount of tokens released to beneficiary
88     function alreadyReleasedAmount() public view override returns (uint256) {
89         return initialBalance - totalToken();
90     }
91 
92     /// @notice amount of held tokens unlocked and available for release
93     function availableForRelease() public view override returns (uint256) {
94         uint256 elapsed = timeSinceStart();
95 
96         uint256 totalAvailable = _proportionAvailable(initialBalance, elapsed, duration);
97         uint256 netAvailable = totalAvailable - alreadyReleasedAmount();
98         return netAvailable;
99     }
100 
101     /// @notice current beneficiary can appoint new beneficiary, which must be accepted
102     function setPendingBeneficiary(address _pendingBeneficiary) public override onlyBeneficiary {
103         pendingBeneficiary = _pendingBeneficiary;
104         emit PendingBeneficiaryUpdate(_pendingBeneficiary);
105     }
106 
107     /// @notice pending beneficiary accepts new beneficiary
108     function acceptBeneficiary() public virtual override {
109         _setBeneficiary(msg.sender);
110     }
111 
112     function clawback() public balanceCheck {
113         require(msg.sender == clawbackAdmin, "TokenTimelock: Only clawbackAdmin");
114         if (passedCliff()) {
115             _release(beneficiary, availableForRelease());
116         }
117         _release(clawbackAdmin, totalToken());
118     }
119 
120     function passedCliff() public view returns (bool) {
121         return timeSinceStart() >= cliffSeconds;
122     }
123 
124     function _proportionAvailable(
125         uint256 initialBalance,
126         uint256 elapsed,
127         uint256 duration
128     ) internal pure virtual returns (uint256);
129 
130     function _setBeneficiary(address newBeneficiary) internal {
131         require(newBeneficiary == pendingBeneficiary, "TokenTimelock: Caller is not pending beneficiary");
132         beneficiary = newBeneficiary;
133         emit BeneficiaryUpdate(newBeneficiary);
134         pendingBeneficiary = address(0);
135     }
136 
137     function _setLockedToken(address tokenAddress) internal {
138         lockedToken = IERC20(tokenAddress);
139     }
140 
141     function _release(address to, uint256 amount) internal {
142         lockedToken.transfer(to, amount);
143         emit Release(beneficiary, to, amount);
144     }
145 }
