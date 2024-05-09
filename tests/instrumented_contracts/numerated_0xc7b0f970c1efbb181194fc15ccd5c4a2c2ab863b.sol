1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 contract TwoWeeksNotice {
81     
82     struct StakeState {
83         uint64 balance;
84         uint64 unlockPeriod; // time it takes from requesting withdraw to being able to withdraw
85         uint64 lockedUntil; // 0 if withdraw is not requested
86         uint64 since;
87         uint128 accumulated; // token-days staked
88         uint128 accumulatedStrict; // token-days staked sans withdraw periods
89     }
90     
91     event StakeUpdate(address indexed from, uint64 balance);
92     event WithdrawRequest(address indexed from, uint64 until);
93     
94     mapping(address => StakeState) private _states;
95     
96     IERC20 private token;
97     
98     constructor (IERC20 _token) public {
99         token = _token;
100     }
101 
102     function getStakeState(address account) external view returns (uint64, uint64, uint64, uint64) {
103         StakeState storage ss = _states[account];
104         return (ss.balance, ss.unlockPeriod, ss.lockedUntil, ss.since);
105     }
106     
107     function getAccumulated(address account) external view returns (uint128, uint128) {
108         StakeState storage ss = _states[account];
109         return (ss.accumulated, ss.accumulatedStrict);
110     }
111 
112     function estimateAccumulated(address account) external view returns (uint128, uint128) {
113         StakeState storage ss = _states[account];
114         uint128 sum = ss.accumulated;
115         uint128 sumStrict = ss.accumulatedStrict;
116         if (ss.balance > 0) {
117             uint256 until = block.timestamp;
118             if (ss.lockedUntil > 0 && ss.lockedUntil < block.timestamp) {
119                 until = ss.lockedUntil;
120             }
121             if (until > ss.since) {
122                 uint128 delta = uint128( (uint256(ss.balance) * (until - ss.since))/86400 );
123                 sum += delta;
124                 if (ss.lockedUntil == 0) {
125                     sumStrict += delta;
126                 }
127             }
128         }
129         return (sum, sumStrict);
130     }
131     
132     
133     function updateAccumulated(StakeState storage ss) private {
134         if (ss.balance > 0) {
135             uint256 until = block.timestamp;
136             if (ss.lockedUntil > 0 && ss.lockedUntil < block.timestamp) {
137                 until = ss.lockedUntil;
138             }
139             if (until > ss.since) {
140                 uint128 delta = uint128( (uint256(ss.balance) * (until - ss.since))/86400 );
141                 ss.accumulated += delta;
142                 if (ss.lockedUntil == 0) {
143                     ss.accumulatedStrict += delta;
144                 }
145             }
146         }
147     }
148 
149     function stake(uint64 amount, uint64 unlockPeriod) external {
150         StakeState storage ss = _states[msg.sender];
151         require(amount > 0, "amount must be positive");
152         require(ss.balance <= amount, "cannot decrease balance");
153         require(unlockPeriod <= 1000 days, "unlockPeriod cannot be higher than 1000 days");
154         require(ss.unlockPeriod <= unlockPeriod, "cannot decrease unlock period");
155         require(unlockPeriod >= 2 weeks, "unlock period can't be less than 2 weeks");
156         
157         updateAccumulated(ss);
158         
159         uint128 delta = amount - ss.balance;
160         if (delta > 0) {
161             require(token.transferFrom(msg.sender, address(this), delta), "transfer unsuccessful");
162         }
163 
164         ss.balance = amount;
165         ss.unlockPeriod = unlockPeriod;
166         ss.lockedUntil = 0;
167         ss.since = uint64(block.timestamp);
168         emit StakeUpdate(msg.sender, amount);
169     }
170     
171     function requestWithdraw() external {
172          StakeState storage ss = _states[msg.sender];
173          require(ss.balance > 0);
174          updateAccumulated(ss);
175          ss.since = uint64(block.timestamp);
176          ss.lockedUntil = uint64(block.timestamp + ss.unlockPeriod);
177     }
178 
179     function withdraw(address to) external {
180         StakeState storage ss = _states[msg.sender];
181         require(ss.balance > 0, "must have tokens to withdraw");
182         require(ss.lockedUntil != 0, "unlock not requested");
183         require(ss.lockedUntil < block.timestamp, "still locked");
184         updateAccumulated(ss);
185         uint128 balance = ss.balance;
186         ss.balance = 0;
187         ss.unlockPeriod = 0;
188         ss.lockedUntil = 0;
189         ss.since = 0;
190         require(token.transfer(to, balance), "transfer unsuccessful");
191         emit StakeUpdate(msg.sender, 0);
192     }
193 }