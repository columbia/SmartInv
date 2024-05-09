1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
41 }
42 
43 
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 
72 contract IBC is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82    
83     constructor() public {
84         symbol = "IBC";
85         name = "Intelligent Business Chain";
86         decimals = 8;
87         _totalSupply = 100000000000000000;
88         balances[0x045Df057790D65C9d5b5751AbfA1c56a8E5dc8B7] = _totalSupply;
89         emit Transfer(address(0), 0x045Df057790D65C9d5b5751AbfA1c56a8E5dc8B7, _totalSupply);
90     }
91 
92 
93     
94     function totalSupply() public constant returns (uint) {
95         return _totalSupply  - balances[address(0)];
96     }
97 
98 
99 
100     function balanceOf(address tokenOwner) public constant returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104 
105 
106     function transfer(address to, uint tokens) public returns (bool success) {
107         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
108         balances[to] = safeAdd(balances[to], tokens);
109         emit Transfer(msg.sender, to, tokens);
110         return true;
111     }
112 
113 
114     
115     function approve(address spender, uint tokens) public returns (bool success) {
116         allowed[msg.sender][spender] = tokens;
117         emit Approval(msg.sender, spender, tokens);
118         return true;
119     }
120 
121 
122     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
123         balances[from] = safeSub(balances[from], tokens);
124         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
125         balances[to] = safeAdd(balances[to], tokens);
126         emit Transfer(from, to, tokens);
127         return true;
128     }
129 
130 
131     
132     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
133         return allowed[tokenOwner][spender];
134     }
135 
136 
137     
138     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
139         allowed[msg.sender][spender] = tokens;
140         emit Approval(msg.sender, spender, tokens);
141         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
142         return true;
143     }
144 
145 
146     
147     function () public payable {
148         revert();
149     }
150 
151 
152     
153     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
154         return ERC20Interface(tokenAddress).transfer(owner, tokens);
155     }
156 }