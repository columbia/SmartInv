1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // -----Yearn Finance Protocol------
5 // 
6 // ----YFVPROTOCOL.FINANCE-----
7 // ----------------------------------------------------------------------------
8 contract ERC20Interface {
9     function totalSupply() public view returns (uint);
10     function balanceOf(address tokenOwner) public view returns (uint balance);
11     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
12     function transfer(address to, uint tokens) public returns (bool success);
13     function approve(address spender, uint tokens) public returns (bool success);
14     function transferFrom(address from, address to, uint tokens) public returns (bool success);
15 
16     event Transfer(address indexed from, address indexed to, uint tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 }
19 
20 // ----------------------------------------------------------------------------
21 // Safe Math Library 
22 // ----------------------------------------------------------------------------
23 contract SafeMath {
24     function safeAdd(uint a, uint b) public pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function safeSub(uint a, uint b) public pure returns (uint c) {
29         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 contract YearnFinanceProtocolToken is ERC20Interface, SafeMath {
36     string public name;
37     string public symbol;
38     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
39     
40     uint256 public _totalSupply;
41     
42     mapping(address => uint) balances;
43     mapping(address => mapping(address => uint)) allowed;
44     
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     constructor() public {
51         name = "Yearn Finance Protocol";
52         symbol = "YFP";
53         decimals = 18;
54         _totalSupply = 500000000000000000000000;
55         
56         balances[msg.sender] = 350000000000000000000000;
57         emit Transfer(address(0), msg.sender, _totalSupply);
58     }
59     
60     function totalSupply() public view returns (uint) {
61         return _totalSupply  - balances[address(0)];
62     }
63     
64     function balanceOf(address tokenOwner) public view returns (uint balance) {
65         return balances[tokenOwner];
66     }
67     
68     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
69         return allowed[tokenOwner][spender];
70     }
71     
72     function approve(address spender, uint tokens) public returns (bool success) {
73         allowed[msg.sender][spender] = tokens;
74         emit Approval(msg.sender, spender, tokens);
75         return true;
76     }
77     
78     function transfer(address to, uint tokens) public returns (bool success) {
79         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
80         balances[to] = safeAdd(balances[to], tokens);
81         emit Transfer(msg.sender, to, tokens);
82         return true;
83     }
84     
85     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
86         balances[from] = safeSub(balances[from], tokens);
87         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
88         balances[to] = safeAdd(balances[to], tokens);
89         emit Transfer(from, to, tokens);
90         return true;
91     }
92 }