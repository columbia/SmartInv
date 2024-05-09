1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-09
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 // ----------------------------------------------------------------------------
8 // -----Protocol Finance ------
9 // 
10 // ----ProtocolFinance-----
11 // ----------------------------------------------------------------------------
12 contract ERC20Interface {
13     function totalSupply() public view returns (uint);
14     function balanceOf(address tokenOwner) public view returns (uint balance);
15     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
16     function transfer(address to, uint tokens) public returns (bool success);
17     function approve(address spender, uint tokens) public returns (bool success);
18     function transferFrom(address from, address to, uint tokens) public returns (bool success);
19 
20     event Transfer(address indexed from, address indexed to, uint tokens);
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22 }
23 
24 // ----------------------------------------------------------------------------
25 // Safe Math Library 
26 // ----------------------------------------------------------------------------
27 contract SafeMath {
28     function safeAdd(uint a, uint b) public pure returns (uint c) {
29         c = a + b;
30         require(c >= a);
31     }
32     function safeSub(uint a, uint b) public pure returns (uint c) {
33         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 contract ProtocolFinance is ERC20Interface, SafeMath {
40     string public name;
41     string public symbol;
42     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
43     
44     uint256 public _totalSupply;
45     
46     mapping(address => uint) balances;
47     mapping(address => mapping(address => uint)) allowed;
48     
49     /**
50      * Constrctor function
51      *
52      * Initializes contract with initial supply tokens to the creator of the contract
53      */
54     constructor() public {
55         name = "Protocol Finance";
56         symbol = "PFI";
57         decimals = 18;
58         _totalSupply = 20000000000000000000000;
59         
60         balances[msg.sender] =20000000000000000000000 ;
61         emit Transfer(address(0), msg.sender, _totalSupply);
62     }
63     
64     function totalSupply() public view returns (uint) {
65         return _totalSupply  - balances[address(0)];
66     }
67     
68     function balanceOf(address tokenOwner) public view returns (uint balance) {
69         return balances[tokenOwner];
70     }
71     
72     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
73         return allowed[tokenOwner][spender];
74     }
75     
76     function approve(address spender, uint tokens) public returns (bool success) {
77         allowed[msg.sender][spender] = tokens;
78         emit Approval(msg.sender, spender, tokens);
79         return true;
80     }
81     
82     function transfer(address to, uint tokens) public returns (bool success) {
83         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
84         balances[to] = safeAdd(balances[to], tokens);
85         emit Transfer(msg.sender, to, tokens);
86         return true;
87     }
88     
89     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
90         balances[from] = safeSub(balances[from], tokens);
91         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
92         balances[to] = safeAdd(balances[to], tokens);
93         emit Transfer(from, to, tokens);
94         return true;
95     }
96 }