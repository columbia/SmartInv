1 /**
2    ______                      __  ____  _      __       _ __          __            
3   / ____/___ _______________  / /_/ __ \(_)____/ /______(_) /_  __  __/ /_____  _____
4  / /   / __ `/ ___/ ___/ __ \/ __/ / / / / ___/ __/ ___/ / __ \/ / / / __/ __ \/ ___/
5 / /___/ /_/ / /  / /  / /_/ / /_/ /_/ / (__  ) /_/ /  / / /_/ / /_/ / /_/ /_/ / /    
6 \____/\__,_/_/  /_/   \____/\__/_____/_/____/\__/_/  /_/_.___/\__,_/\__/\____/_/  
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity =0.6.11;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // Allows anyone to claim a token if they exist in a merkle root.
90 interface IMerkleDistributor {
91     // Returns the address of the token distributed by this contract.
92     function token() external view returns (address);
93     // Returns true if the index has been marked claimed.
94     function isClaimed(uint256 index) external view returns (bool);
95     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
96     function claim(uint256 index, address account) external;
97     // This event is triggered whenever a call to #claim succeeds.
98     event Claimed(uint256 index, address account);
99 }
100 
101 contract CarrotDistributor is IMerkleDistributor {
102     address public immutable override token;
103     
104     // This is a packed array of booleans.
105     mapping(uint256 => uint256) private claimedBitMap;
106 
107     constructor(address token_) public {
108         token = token_;
109         
110     }
111 
112     function isClaimed(uint256 index) public view override returns (bool) {
113         uint256 claimedWordIndex = index / 256;
114         uint256 claimedBitIndex = index % 256;
115         uint256 claimedWord = claimedBitMap[claimedWordIndex];
116         uint256 mask = (1 << claimedBitIndex);
117         return claimedWord & mask == mask;
118     }
119 
120     function _setClaimed(uint256 index) private {
121         uint256 claimedWordIndex = index / 256;
122         uint256 claimedBitIndex = index % 256;
123         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
124     }
125 
126     function claim(uint256 index, address account) external override {
127         uint256 amount = 24986666666e10;
128         require(!isClaimed(index), 'CarrotDistributor: Drop already claimed.');
129 
130 
131         // Mark it claimed and send the token.
132         _setClaimed(index);
133         require(IERC20(token).transfer(account, amount), 'CarrotDistributor: Transfer failed.');
134 
135         emit Claimed(index, account);
136     }
137 }