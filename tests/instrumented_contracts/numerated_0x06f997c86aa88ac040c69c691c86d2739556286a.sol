1 pragma solidity ^0.5.2;
2 contract ERC20 {
3 function totalSupply() public returns (uint);
4 function balanceOf(address tokenOwner) public view returns (uint balance);
5 function allowance(address tokenOwner, address spender) public returns (uint remaining);
6 function transfer(address to, uint tokens) public returns (bool success);
7 function approve(address spender, uint tokens) public returns (bool success);
8 function transferFrom(address from, address to, uint tokens) public returns (bool success);
9 event Transfer(address indexed from, address indexed to, uint tokens);
10 event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
11 }
12 
13 contract future1
14  {
15 address public escrow;
16 address public useraddr;
17 mapping (address => mapping(address => uint256)) public dep_token;
18 mapping (address => uint256) public dep_ETH;
19 
20  
21 constructor() public
22 {
23 escrow = msg.sender;
24 }
25 
26 function safeAdd(uint crtbal, uint depbal) public pure returns (uint)
27 {
28 uint totalbal = crtbal + depbal;
29 return totalbal;
30 }
31 
32 function safeSub(uint crtbal, uint depbal) public pure returns (uint)
33 {
34 uint totalbal = crtbal - depbal;
35 return totalbal;
36 }
37 
38 function balanceOf(address token,address user) public view returns(uint256) // show bal of perticular token in user add
39 {
40 return ERC20(token).balanceOf(user);
41 }
42 
43 function transfer(address token, uint256 tokens)public payable // deposit perticular token balance to contract address (site address), can depoit multiple token
44 {
45 ERC20(token).transferFrom(msg.sender, address(this), tokens);
46 dep_token[msg.sender][token] = safeAdd(dep_token[msg.sender][token] , tokens);
47 
48 }
49 
50 function admin_token_withdraw(address token, address to, uint256 tokens)public payable // withdraw perticular token balance from contract to user
51 {
52 if(escrow==msg.sender)
53 { // here only admin can withdraw token
54 if(dep_token[to][token]>=tokens)
55 {
56 dep_token[to][token] = safeSub(dep_token[to][token] , tokens) ;
57 ERC20(token).transfer(to, tokens);
58 }
59 }
60 }
61 
62 function tok_bal_contract(address token) public view returns(uint256) // show balance of contract address
63 {
64 return ERC20(token).balanceOf(address(this));
65 }
66 
67  
68 function depositETH() payable external // this function deposit eth in contract address
69  
70 {
71 dep_ETH[msg.sender] = safeAdd(dep_ETH[msg.sender] , msg.value);
72 }
73 
74 function admin_withdrawETH(address payable to, uint256 value) public payable returns (bool) // this will withdraw eth from contract to address(to)
75 {
76     require(escrow==msg.sender);
77     if(escrow==msg.sender)
78     { // only admin can withdraw ETH from user
79         if(dep_ETH[to]>=value)
80         {
81             dep_ETH[to]= safeSub(dep_ETH[to] ,value);
82             to.transfer(value);
83             return true;
84         }
85     }
86 }
87 
88 function find_Cont_ETH() public view returns(uint256) 
89 {
90     return address(this).balance;
91 }
92 
93 // function getAllContETH() public payable returns(uint256) 
94 // {
95 //     if(escrow==msg.sender)
96 //     { 
97 //         msg.sender.transfer(address(this).balance);
98 //     }
99 // }
100 
101 }