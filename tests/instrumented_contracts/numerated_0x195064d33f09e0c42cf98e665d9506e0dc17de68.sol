1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.1;
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
79 /**
80  * @dev Interface contains all of the events necessary for staking Vega token
81  */
82 interface IStake {
83   event Stake_Deposited(address indexed user, uint256 amount, bytes32 indexed vega_public_key);
84   event Stake_Removed(address indexed user, uint256 amount, bytes32 indexed vega_public_key);
85   event Stake_Transferred(address indexed from, uint256 amount, address indexed to, bytes32 indexed vega_public_key);
86 
87   /// @return the address of the token that is able to be staked
88   function staking_token() external view returns (address);
89 
90   /// @param target Target address to check
91   /// @param vega_public_key Target vega public key to check
92   /// @return the number of tokens staked for that address->vega_public_key pair
93   function stake_balance(address target, bytes32 vega_public_key) external view returns (uint256);
94 
95 
96   /// @return total tokens staked on contract
97   function total_staked() external view returns (uint256);
98 }
99 
100 /// @title ERC20 Staking Bridge
101 /// @author Vega Protocol
102 /// @notice This contract manages the vesting of the Vega V2 ERC20 token
103 contract Vega_Staking_Bridge is IStake {
104   address _staking_token;
105 
106   constructor(address token) {
107     _staking_token = token;
108   }
109 
110   /// @dev user => amount staked
111   mapping(address => mapping(bytes32 => uint256)) stakes;
112 
113   /// @notice This stakes the given amount of tokens and credits them to the provided Vega public key
114   /// @param amount Token amount to stake
115   /// @param vega_public_key Target Vega public key to be credited with the stake
116   /// @dev Emits Stake_Deposited event
117   /// @dev User MUST run "approve" on token prior to running Stake
118   function stake(uint256 amount, bytes32 vega_public_key) public {
119     require(IERC20(_staking_token).transferFrom(msg.sender, address(this), amount));
120     stakes[msg.sender][vega_public_key] += amount;
121     emit Stake_Deposited(msg.sender, amount, vega_public_key);
122   }
123 
124   /// @notice This removes specified amount of stake of available to user
125   /// @dev Emits Stake_Removed event if successful
126   /// @param amount Amount of tokens to remove from staking
127   /// @param vega_public_key Target Vega public key from which to deduct stake
128   function remove_stake(uint256 amount, bytes32 vega_public_key) public {
129     stakes[msg.sender][vega_public_key] -= amount;
130     require(IERC20(_staking_token).transfer(msg.sender, amount));
131     emit Stake_Removed(msg.sender, amount, vega_public_key);
132   }
133 
134   /// @notice This transfers all stake from the sender's address to the "new_address"
135   /// @dev Emits Stake_Transfered event if successful
136   /// @param amount Stake amount to transfer
137   /// @param new_address Target ETH address to recieve the stake
138   /// @param vega_public_key Target Vega public key to be credited with the transfer
139   function transfer_stake(uint256 amount, address new_address, bytes32 vega_public_key) public {
140     stakes[msg.sender][vega_public_key] -= amount;
141     stakes[new_address][vega_public_key] += amount;
142     emit Stake_Transferred(msg.sender, amount, new_address, vega_public_key);
143   }
144 
145   /// @dev This is IStake.staking_token
146   /// @return the address of the token that is able to be staked
147   function staking_token() external override view returns (address) {
148     return _staking_token;
149   }
150 
151   /// @dev This is IStake.stake_balance
152   /// @param target Target address to check
153   /// @param vega_public_key Target vega public key to check
154   /// @return the number of tokens staked for that address->vega_public_key pair
155   function stake_balance(address target, bytes32 vega_public_key) external override view returns (uint256) {
156     return  stakes[target][vega_public_key];
157   }
158 
159   /// @dev This is IStake.total_staked
160   /// @return total tokens staked on contract
161   function total_staked() external override view returns (uint256) {
162     return IERC20(_staking_token).balanceOf(address(this));
163   }
164 }
165 
166 
167 /**
168 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
169 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
170 MMMMWEMMMMMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
171 MMMMMMLOVEMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
172 MMMMMMMMMMHIXELMMMMMMMMMMMM....................MMMMMNNMMMMMM
173 MMMMMMMMMMMMMMMMMMMMMMMMMMM....................MMMMMMMMMMMMM
174 MMMMMMMMMMMMMMMMMMMMMM88=........................+MMMMMMMMMM
175 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
176 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
177 MMMMMMMMMMMM.........................MM+..MMM....+MMMMMMMMMM
178 MMMMMMMMMNMM...................... ..MM?..MMM.. .+MMMMMMMMMM
179 MMMMNDDMM+........................+MM........MM..+MMMMMMMMMM
180 MMMMZ.............................+MM....................MMM
181 MMMMZ.............................+MM....................MMM
182 MMMMZ.............................+MM....................DDD
183 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
184 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
185 MM..............................MMZ....ZMMMMMMMMMMMMMMMMMMMM
186 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
187 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
188 MM......................ZMMMMM.......MMMMMMMMMMMMMMMMMMMMMMM
189 MM............... ......ZMMMMM.... ..MMMMMMMMMMMMMMMMMMMMMMM
190 MM...............MMMMM88~.........+MM..ZMMMMMMMMMMMMMMMMMMMM
191 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
192 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
193 MM.......ZMMMMMMM.......ZMMMMM..MMMMM..ZMMMMMMMMMMMMMMMMMMMM
194 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
195 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
196 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
197 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/