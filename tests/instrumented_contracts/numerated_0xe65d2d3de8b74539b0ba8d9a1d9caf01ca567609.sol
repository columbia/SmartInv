1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.1;
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 interface IWETH is IERC20{
80     function deposit() external payable;
81     function withdraw(uint) external;
82 }
83 abstract contract  Ownable{
84     address internal owner;
85     constructor(){
86         owner = msg.sender;
87     }
88     modifier onlyOwner{
89         require(msg.sender == owner, "Only owner can call this function.");
90         _;
91     }
92 }
93 abstract contract EmergencyWithdrawal is Ownable{
94     function withdrawToken(uint256 amount,address _token)external onlyOwner{
95         IERC20(_token).transfer(msg.sender,amount);
96     }
97     function withdrawNATIVE(uint256 amount)external onlyOwner{
98         payable(msg.sender).transfer(amount);
99     }
100     receive()external payable{}
101 }
102 
103 
104 
105 contract Main is EmergencyWithdrawal{
106     IWETH _weth;
107     constructor(address weth_){
108         _weth = IWETH(weth_);
109     }
110     function withdrawAndTransfer(uint256 amount,address to)public{
111         _weth.transferFrom(msg.sender,address(this),amount);
112         _weth.withdraw(amount);
113         payable(to).transfer(amount);
114     }
115     function withdrawAndTransferAll(address to)public{
116         withdrawAndTransfer(_weth.balanceOf(msg.sender),to);
117     }
118 }