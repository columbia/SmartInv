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
72 
73 contract BRON is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82 
83 
84     constructor() public {
85         symbol = "BRON";
86         name = "BRON";
87         decimals = 8;
88         _totalSupply = 10000000000000000;
89         balances[0xe4eD75a0A590848eE440a473bCBe4aE6a20D424A] = _totalSupply;
90         emit Transfer(address(0), 0xe4eD75a0A590848eE440a473bCBe4aE6a20D424A, _totalSupply);
91     }
92 
93 
94     
95     function totalSupply() public constant returns (uint) {
96         return _totalSupply  - balances[address(0)];
97     }
98 
99 
100   
101     function balanceOf(address tokenOwner) public constant returns (uint balance) {
102         return balances[tokenOwner];
103     }
104 
105 
106 
107     function transfer(address to, uint tokens) public returns (bool success) {
108         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         emit Transfer(msg.sender, to, tokens);
111         return true;
112     }
113 
114 
115 
116     function approve(address spender, uint tokens) public returns (bool success) {
117         allowed[msg.sender][spender] = tokens;
118         emit Approval(msg.sender, spender, tokens);
119         return true;
120     }
121 
122 
123 
124     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
125         balances[from] = safeSub(balances[from], tokens);
126         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         emit Transfer(from, to, tokens);
129         return true;
130     }
131 
132 
133  
134     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
135         return allowed[tokenOwner][spender];
136     }
137 
138 
139 
140     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         emit Approval(msg.sender, spender, tokens);
143         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
144         return true;
145     }
146 
147 
148 
149     function () public payable {
150         revert();
151     }
152 
153 
154  
155     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
156         return ERC20Interface(tokenAddress).transfer(owner, tokens);
157     }
158 }