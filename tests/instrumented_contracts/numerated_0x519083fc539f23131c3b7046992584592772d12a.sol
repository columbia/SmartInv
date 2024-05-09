1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-03
7 */
8 
9 pragma solidity ^0.5.0;
10 
11 // ----------------------------------------------------------------------------
12 // ERC Token Standard #20 Interface
13 //
14 // ----------------------------------------------------------------------------
15 contract ERC20Interface {
16     function totalSupply() public view returns (uint);
17     function balanceOf(address tokenOwner) public view returns (uint balance);
18     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
19     function transfer(address to, uint tokens) public returns (bool success);
20     function approve(address spender, uint tokens) public returns (bool success);
21     function transferFrom(address from, address to, uint tokens) public returns (bool success);
22 
23     event Transfer(address indexed from, address indexed to, uint tokens);
24     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Safe Math Library 
29 // ----------------------------------------------------------------------------
30 contract SafeMath {
31     function safeAdd(uint a, uint b) public pure returns (uint c) {
32         c = a + b;
33         require(c >= a);
34     }
35     function safeSub(uint a, uint b) public pure returns (uint c) {
36         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 contract YFIVFINANCE is ERC20Interface, SafeMath {
43     string public name;
44     string public symbol;
45     uint8 public decimals; 
46     
47     uint256 public _totalSupply;
48     
49     mapping(address => uint) balances;
50     mapping(address => mapping(address => uint)) allowed;
51     
52     /**
53      * Constrctor function
54      *
55      * Initializes contract with initial supply tokens to the creator of the contract
56      */
57     constructor() public {
58         name = "YEARN FINANCE VALUE";
59         symbol = "YFIV";
60         decimals = 18;
61         _totalSupply = 100000000000000000000000;
62         
63         balances[msg.sender] = _totalSupply;
64         emit Transfer(address(0), msg.sender, _totalSupply);
65     }
66     
67     function totalSupply() public view returns (uint) {
68         return _totalSupply  - balances[address(0)];
69     }
70     
71     function balanceOf(address tokenOwner) public view returns (uint balance) {
72         return balances[tokenOwner];
73     }
74     
75     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
76         return allowed[tokenOwner][spender];
77     }
78     
79     function approve(address spender, uint tokens) public returns (bool success) {
80         allowed[msg.sender][spender] = tokens;
81         emit Approval(msg.sender, spender, tokens);
82         return true;
83     }
84     
85     function transfer(address to, uint tokens) public returns (bool success) {
86         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
87         balances[to] = safeAdd(balances[to], tokens);
88         emit Transfer(msg.sender, to, tokens);
89         return true;
90     }
91     
92     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
93         balances[from] = safeSub(balances[from], tokens);
94         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
95         balances[to] = safeAdd(balances[to], tokens);
96         emit Transfer(from, to, tokens);
97         return true;
98     }
99 }