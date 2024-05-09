1 pragma solidity ^0.4.18;
2 
3 // modified from Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. 
4 // The MIT Licence.
5 
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
41 }
42 
43 
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     function Owned() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 contract CCLToken is ERC20Interface, Owned, SafeMath {
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint public _totalSupply;
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79 
80     function CCLToken() public {
81         symbol = "CCL";
82         name = "CyClean Token";
83         decimals = 18;
84         _totalSupply = 4000000000000000000000000000; //4,000,000,000
85         balances[0xf835bF0285c99102eaedd684b4401272eF36aF65] = _totalSupply;
86         Transfer(address(0), 0xf835bF0285c99102eaedd684b4401272eF36aF65, _totalSupply);
87     }
88 
89 
90     function totalSupply() public constant returns (uint) {
91         return _totalSupply  - balances[address(0)];
92     }
93 
94 
95     function balanceOf(address tokenOwner) public constant returns (uint balance) {
96         return balances[tokenOwner];
97     }
98 
99 
100     function transfer(address to, uint tokens) public returns (bool success) {
101         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
102         balances[to] = safeAdd(balances[to], tokens);
103         Transfer(msg.sender, to, tokens);
104         return true;
105     }
106 
107 
108     function approve(address spender, uint tokens) public returns (bool success) {
109         allowed[msg.sender][spender] = tokens;
110         Approval(msg.sender, spender, tokens);
111         return true;
112     }
113 
114 
115     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
116         balances[from] = safeSub(balances[from], tokens);
117         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
118         balances[to] = safeAdd(balances[to], tokens);
119         Transfer(from, to, tokens);
120         return true;
121     }
122 
123 
124     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
125         return allowed[tokenOwner][spender];
126     }
127 
128 
129     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
130         allowed[msg.sender][spender] = tokens;
131         Approval(msg.sender, spender, tokens);
132         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
133         return true;
134     }
135 
136 
137     function () public payable {
138         revert();
139     }
140 
141 
142     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
143         return ERC20Interface(tokenAddress).transfer(owner, tokens);
144     }
145 }