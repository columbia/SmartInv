1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Emitted when `value` tokens are moved from one account (`from`) to
13      * another (`to`).
14      *
15      * Note that `value` may be zero.
16      */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
21      * a call to {approve}. `value` is the new allowance.
22      */
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `to`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address to, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `from` to `to` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address from, address to, uint256 amount) external returns (bool);
79 }
80 
81 // File: erc20-airdrop.sol
82 
83 
84 pragma solidity ^0.8.9;
85 
86 
87 /// @custom:security-contact official@tidalflats.studio
88 contract Erc20Airdrop {
89     address private _owner;
90     address private _targetToken;
91     uint256 private _claimAmount;
92 
93     constructor(address targetToken, uint256 claimAmount) {
94         _targetToken = targetToken;
95         _claimAmount = claimAmount;
96         _owner = msg.sender;
97     }
98 
99     function _checkOwner() private view {
100         require(msg.sender == _owner, "Caller is not owner");
101     }
102 
103     modifier onlyOwner() {
104         _checkOwner();
105         _;
106     }
107     
108     function owner() external view returns (address) {
109         return _owner;
110     }
111     
112     function transferOwnership(address newOwner) external onlyOwner {
113         _owner = newOwner;
114     }
115 
116     mapping (address => bool) private _claimed;
117 
118     function isClaimed(address target) external view onlyOwner returns (bool result){
119         return _claimed[target];
120     }
121 
122     function emptyPool() external onlyOwner returns (bool result){
123         return IERC20(_targetToken).transfer(_owner, IERC20(_targetToken).balanceOf(address(this)));
124     }
125 
126     function checkClaimAvailability() external view returns (bool result){
127         require(!_claimed[msg.sender], "You can receive token only once per wallet");
128         require(_claimAmount <= IERC20(_targetToken).balanceOf(address(this)), "Not enough token left in airdrop pool");
129         return true;
130     }
131 
132     function claimToken() external returns (bool result){
133         require(!_claimed[msg.sender], "You can receive token only once per wallet");
134         _claimed[msg.sender]=true;
135 
136         return IERC20(_targetToken).transfer(msg.sender, _claimAmount);
137     }
138 }