1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-05
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-05
7 // -----------------------------Official website : APPLEPROTOCOL.INFO----------------
8 */
9 
10 pragma solidity ^0.5.0;
11 
12 // ----------------------------------------------------------------------------
13 // ERC Token Standard #20 Interface
14 //
15 // ----------------------------------------------------------------------------
16 contract ERC20Interface {
17     function totalSupply() public view returns (uint);
18     function balanceOf(address tokenOwner) public view returns (uint balance);
19     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
20     function transfer(address to, uint tokens) public returns (bool success);
21     function approve(address spender, uint tokens) public returns (bool success);
22     function transferFrom(address from, address to, uint tokens) public returns (bool success);
23 
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26 }
27 
28 // ----------------------------------------------------------------------------
29 // Safe Math Library 
30 // ----------------------------------------------------------------------------
31 contract SafeMath {
32     function safeAdd(uint a, uint b) public pure returns (uint c) {
33         c = a + b;
34         require(c >= a);
35     }
36     function safeSub(uint a, uint b) public pure returns (uint c) {
37         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
38         c = a / b;
39     }
40 }
41 
42 
43 contract APPLEPROTOCOL is ERC20Interface, SafeMath {
44     string public name;
45     string public symbol;
46     uint8 public decimals; 
47     
48     uint256 public _totalSupply;
49     
50     mapping(address => uint) balances;
51     mapping(address => mapping(address => uint)) allowed;
52     
53     /**
54      * Constrctor function
55      *
56      * Initializes contract with initial supply tokens to the creator of the contract
57      */
58     constructor() public {
59         name = "APPLE PROTOCOL TOKEN";
60         symbol = "AAPL";
61         decimals = 18;
62         _totalSupply = 500000000000000000000000;
63         
64         balances[msg.sender] = _totalSupply;
65         emit Transfer(address(0), msg.sender, _totalSupply);
66     }
67     
68     function totalSupply() public view returns (uint) {
69         return _totalSupply  - balances[address(0)];
70     }
71     
72     function balanceOf(address tokenOwner) public view returns (uint balance) {
73         return balances[tokenOwner];
74     }
75     
76     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
77         return allowed[tokenOwner][spender];
78     }
79     
80     function approve(address spender, uint tokens) public returns (bool success) {
81         allowed[msg.sender][spender] = tokens;
82         emit Approval(msg.sender, spender, tokens);
83         return true;
84     }
85     
86     function transfer(address to, uint tokens) public returns (bool success) {
87         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
88         balances[to] = safeAdd(balances[to], tokens);
89         emit Transfer(msg.sender, to, tokens);
90         return true;
91     }
92     
93     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
94         balances[from] = safeSub(balances[from], tokens);
95         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], tokens);
97         emit Transfer(from, to, tokens);
98         return true;
99     }
100 }