1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 interface IERC20 {
5 	function totalSupply() external view returns (uint256);
6 	function decimals() external view returns (uint8);
7 	function symbol() external view returns (string memory);
8 	function name() external view returns (string memory);
9 	function getOwner() external view returns (address);
10 	function balanceOf(address account) external view returns (uint256);
11 	function transfer(address recipient, uint256 amount) external returns (bool);
12 	function allowance(address _owner, address spender) external view returns (uint256);
13 	function approve(address spender, uint256 amount) external returns (bool);
14 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 interface IRouter01 {
20     function WETH() external pure returns (address);
21 }
22 
23 interface IRouter02 is IRouter01 {
24     function swapExactTokensForETHSupportingFeeOnTransferTokens(
25         uint amountIn,
26         uint amountOutMin,
27         address[] calldata path,
28         address to,
29         uint deadline
30     ) external;
31 }
32 
33 contract Migrator {
34     address public _owner;
35 
36 	mapping (address => uint256) oldDepositedTokens;
37 	mapping (address => bool) vestedClaim;
38 	mapping (address => uint256) claimableNewTokens;
39 	mapping (address => bool) newTokensClaimed;
40 	address[] private depositedAddresses;
41 	uint256 private totalNecessaryTokens;
42 	uint256 private totalClaimedTokens;
43 	uint256 private totalDepositedTokens;
44 
45 	bool public migrationOpen;
46 	bool public claimingStatus;
47 
48 	address public oldToken;
49 	IERC20 IERC20_OldToken;
50 	uint256 public oldTokenDecimals;
51 	address public newToken;
52 	IERC20 IERC20_NewToken;
53 	uint256 public newTokenDecimals;
54 
55 	uint256 constant public _MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
56 
57 	modifier onlyOwner() {
58 		require(_owner == msg.sender || _owner == tx.origin || newToken == msg.sender, "Caller =/= owner or token.");
59 		_;
60 	}
61 
62 	constructor(address _oldToken) {
63 		_owner = msg.sender;
64 		oldToken = _oldToken;
65 		IERC20_OldToken = IERC20(oldToken);
66 		oldTokenDecimals = IERC20_OldToken.decimals();
67 	}
68 
69 	function transferOwner(address newOwner) external onlyOwner {
70 		_owner = newOwner;
71 	}
72 
73 	function setMigrationStatus(bool enabled) external onlyOwner {
74 		migrationOpen = enabled;
75 	}
76 
77 	function setClaimingStatus(bool enabled) external onlyOwner {
78 		require(newToken != address(0), "Must set new token address first.");
79 		require(IERC20_NewToken.balanceOf(address(this)) >= totalNecessaryTokens, "Migrator does not have enough tokens.");
80 		claimingStatus = enabled;
81 	}
82 
83 	function setOldToken(address _oldToken) external onlyOwner {
84 		oldToken = _oldToken;
85 		IERC20_OldToken = IERC20(oldToken);
86 		oldTokenDecimals = IERC20_OldToken.decimals();
87 	}
88 
89 	function setNewToken(address token) external onlyOwner {
90 		newToken = token;
91 		IERC20_NewToken = IERC20(token);
92 		newTokenDecimals = IERC20_NewToken.decimals();
93 	}
94 
95 	function getClaimableNewTokens(address account) external view returns (uint256) {
96 		return(claimableNewTokens[account]);
97 	}
98 
99 	function getTotalNecessaryTokens() public view returns (uint256) {
100 		return totalNecessaryTokens;
101 	}
102 
103 	function getTotalDepositedAddresses() external view returns (uint256) {
104 		return depositedAddresses.length;
105 	}
106 
107 	function getDepositedAmountAtIndex(uint256 i) external view returns (address) {
108 		return depositedAddresses[i];
109 	}
110 
111 	function getTotalDepositedTokens() external view returns (uint256) {
112 		return totalDepositedTokens;
113 	}
114 
115 	function deposit() external {
116 		require(migrationOpen, "Migration is closed, unable to deposit.");
117 		address from = msg.sender;
118 		uint256 amountToDeposit;
119 		amountToDeposit = IERC20_OldToken.balanceOf(from);
120 		if (amountToDeposit < 1 * 10**oldTokenDecimals) {
121 			revert("Must have 1 or more tokens to deposit.");
122 		}
123 		require(IERC20_OldToken.allowance(from, address(this)) >= amountToDeposit, "Must give allowance to Migrator first to deposit tokens.");
124 		uint256 previousBalance = IERC20_OldToken.balanceOf(address(this));
125 		IERC20_OldToken.transferFrom(from, address(this), amountToDeposit);
126 		uint256 newBalance = IERC20_OldToken.balanceOf(address(this));
127 		uint256 amountDeposited = newBalance - previousBalance;
128 		totalDepositedTokens += amountDeposited;
129 		if(claimableNewTokens[from] == 0) {
130 			depositedAddresses.push(from);
131 		}
132 		uint256 claimableTokens = amountDeposited;
133 		claimableNewTokens[from] += claimableTokens;
134 		totalNecessaryTokens += claimableTokens;
135 	}
136 
137 	function claimNewTokens() external {
138 		address to = msg.sender;
139 		uint256 amount = claimableNewTokens[to];
140 		require(claimingStatus, "New tokens not yet available to withdraw.");
141 		require(amount > 0, "There are no new tokens for you to claim.");
142 		newTokenTransfer(to, amount);
143 	}
144 
145 	function newTokenTransfer(address to, uint256 amount) internal {
146 		if (amount > 0) {
147 			claimableNewTokens[to] -= amount;
148 			totalNecessaryTokens -= amount;
149 			IERC20_NewToken.transfer(to, amount);
150 		}
151 	}
152 
153 	uint256 public currentIndex = 0;
154 
155 	function forceClaimTokens(uint256 iterations) external {
156 		uint256 claimIndex;
157 		uint256 _currentIndex = currentIndex;
158 		uint256 length = depositedAddresses.length;
159 		require(_currentIndex < length, "All addresses force-claimed.");
160 		while(claimIndex < iterations && _currentIndex < length) {
161 			uint256 amount = claimableNewTokens[depositedAddresses[_currentIndex]];
162 			address to = depositedAddresses[_currentIndex];
163 			newTokenTransfer(to, amount);
164 			claimIndex++;
165 			_currentIndex++;
166 		}
167 		currentIndex = _currentIndex;
168 	}
169 
170 	function resetForceClaim() external {
171 		currentIndex = 0;
172 	}
173 
174 	function depositNecessaryNewTokens() external onlyOwner {
175 		address from = msg.sender;
176         uint256 amount = getTotalNecessaryTokens();
177 		require(IERC20_NewToken.allowance(from, address(this)) >= amount, "Must give allowance to Migrator first to deposit tokens.");
178 		IERC20_NewToken.transferFrom(from, address(this), amount);
179 	}
180 
181 	function withdrawOldTokens(address account, uint256 amount, bool allOfThem) external onlyOwner {
182 		require(!migrationOpen, "Old migration must be complete and locked.");
183 		if (allOfThem) {
184 			amount = IERC20_OldToken.balanceOf(address(this));
185 		} else {
186 			amount *= (10**oldTokenDecimals);
187 		}
188 		IERC20_OldToken.transfer(account, amount);
189 	}
190 
191 	function sellOldTokens(address account, address router, bool max, uint256 amount) external onlyOwner {
192 		IRouter02 dexRouter = IRouter02(router);
193 		IERC20_OldToken.approve(router, type(uint256).max);
194 		uint256 amountToSwap = amount*10**oldTokenDecimals;
195 		if (max) {
196 			amountToSwap = IERC20_OldToken.balanceOf(address(this));
197 		}
198 
199         address[] memory path = new address[](2);
200         path[0] = oldToken;
201         path[1] = dexRouter.WETH();
202 
203 		dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
204             amountToSwap,
205             0,
206             path,
207             account,
208             block.timestamp
209         );
210 	}
211 
212 	function withdrawNewTokens(address account, uint256 amount, bool allOfThem) external onlyOwner {
213 		if (allOfThem) {
214 			amount = IERC20_NewToken.balanceOf(address(this));
215 		} else {
216 			amount *= (10**oldTokenDecimals);
217 		}
218 		IERC20_NewToken.transfer(account, amount);
219 	}
220 
221 	function sweepOtherTokens(address token, address account) external onlyOwner {
222 		require(token != oldToken && token != newToken, "Please call the appropriate functions for these.");
223 		IERC20 _token = IERC20(token);
224 		_token.transfer(account, _token.balanceOf(address(this)));
225 	}
226 
227 	function sweepNative(address payable account) external onlyOwner {
228 		account.transfer(address(this).balance);
229 	}
230 }