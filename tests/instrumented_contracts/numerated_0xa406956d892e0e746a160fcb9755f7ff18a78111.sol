1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-06
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 contract SafeMath {
8 
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13 
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18 
19     function safeMul(uint a, uint b) public pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23 
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 
31 
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 
45 
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 
51 contract FISUToken is ERC20Interface, SafeMath {
52     string public symbol;
53     string public  name;
54     uint8 public decimals;
55     uint public _totalSupply;
56 
57     mapping(address => uint) balances;
58     mapping(address => mapping(address => uint)) allowed;
59 
60 
61    
62     constructor() public {
63         symbol = "FISU";
64         name = "FIRST SPORT SHOES TOKEN UNION";
65         decimals = 18;
66         _totalSupply = 10000000000* (10 ** 18);
67         balances[0x73c6d8C460791D9C749988e889f04b414D85DCeE] = _totalSupply;
68         emit Transfer(address(0), 0x73c6d8C460791D9C749988e889f04b414D85DCeE, _totalSupply);
69     }
70 
71 
72     function totalSupply() public constant returns (uint) {
73         return _totalSupply  - balances[address(0)];
74     }
75 
76 
77     function balanceOf(address tokenOwner) public constant returns (uint balance) {
78         return balances[tokenOwner];
79     }
80 
81 
82    
83     function transfer(address to, uint tokens) public returns (bool success) {
84         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
85         balances[to] = safeAdd(balances[to], tokens);
86         emit Transfer(msg.sender, to, tokens);
87         return true;
88     }
89 
90 
91     
92     function approve(address spender, uint tokens) public returns (bool success) {
93         allowed[msg.sender][spender] = tokens;
94         emit Approval(msg.sender, spender, tokens);
95         return true;
96     }
97 
98 
99    
100     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
101         balances[from] = safeSub(balances[from], tokens);
102         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
103         balances[to] = safeAdd(balances[to], tokens);
104         emit Transfer(from, to, tokens);
105         return true;
106     }
107 
108 
109     
110     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
111         return allowed[tokenOwner][spender];
112     }
113 
114 
115     
116     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         emit Approval(msg.sender, spender, tokens);
119         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
120         return true;
121     }
122 
123 
124     
125     function () public payable {
126         revert();
127     }
128 }