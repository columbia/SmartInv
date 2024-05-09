1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
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
80 
81 contract FuIdo {
82     address public dev_address;
83     //0x6a01B4BB5B423dc371cbC66B1b44629a248a814b
84     address public token_address = 0x6a01B4BB5B423dc371cbC66B1b44629a248a814b;
85     bool public buyBool;
86     uint public  idoEtherAmount = 0.0015 ether;
87     uint public idoAmount = 25*10**4 * 10**18;
88     uint public totalEtherAmount;
89     
90   constructor() public {
91         dev_address = msg.sender;
92     }
93 
94  
95     function  setBuy(bool bools) public{
96         require(msg.sender==dev_address,"No call permission");
97         buyBool=bools;
98    }
99 
100 function setToken(address token)public{
101       require(msg.sender==dev_address,"No call permission");
102       token_address = token;
103      
104 }
105    
106 
107     function claim () public payable{
108         require(buyBool,"claim is not start");
109         require(msg.value == idoEtherAmount,"Insufficient transfer quantity");
110         IERC20(token_address).transfer(msg.sender,idoAmount);
111         totalEtherAmount = totalEtherAmount + address(this).balance;
112         //payable(dev_address).transfer(address(this).balance);
113     }
114 
115        function getToken() public  {
116         require(msg.sender==dev_address,"No call permission");
117        IERC20(token_address).transfer(msg.sender,IERC20(token_address).balanceOf(address(this)));
118     }
119 
120       function getEther() public payable {
121           require(msg.sender==dev_address,"No call permission");
122        msg.sender.transfer(address(this).balance);
123     }
124 }