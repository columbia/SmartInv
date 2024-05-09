1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 // ----------------------------------------------------------------------------
7 // Safe maths
8 // ----------------------------------------------------------------------------
9 contract SafeMath {
10     function safeAdd(uint a, uint b) public pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14     function safeSub(uint a, uint b) public pure returns (uint c) {
15         require(b <= a);
16         c = a - b;
17     }
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22     function safeDiv(uint a, uint b) public pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
46 }
47 
48 
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner {
65         newOwner = _newOwner;
66     }
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 
76 
77 contract BOARDMYTRIP is ERC20Interface, Owned, SafeMath {
78     string public symbol;
79     string public  name;
80     uint8 public decimals;
81     uint public _totalSupply;
82 
83     mapping(address => uint) balances;
84     mapping(address => mapping(address => uint)) allowed;
85 
86 
87     // ------------------------------------------------------------------------
88     // Constructor
89     // ------------------------------------------------------------------------
90     constructor() public {
91         symbol = "BMYT";
92         name = "BOARDMYTRIP";
93         decimals = 8;
94         _totalSupply = 21000000000000000;
95         balances[0x866F4f65E16C99aEd11D470dB81B5cBBf39d88eB] = _totalSupply;
96         emit Transfer(address(0), 0x866F4f65E16C99aEd11D470dB81B5cBBf39d88eB, _totalSupply);
97     }
98 
99 
100 
101     function totalSupply() public constant returns (uint) {
102         return _totalSupply  - balances[address(0)];
103     }
104 
105 
106 
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110 
111 
112     function transfer(address to, uint tokens) public returns (bool success) {
113         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
114         balances[to] = safeAdd(balances[to], tokens);
115         emit Transfer(msg.sender, to, tokens);
116         return true;
117     }
118 
119 
120     function approve(address spender, uint tokens) public returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         emit Approval(msg.sender, spender, tokens);
123         return true;
124     }
125 
126     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
127         balances[from] = safeSub(balances[from], tokens);
128         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
129         balances[to] = safeAdd(balances[to], tokens);
130         emit Transfer(from, to, tokens);
131         return true;
132     }
133 
134 
135 
136     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
137         return allowed[tokenOwner][spender];
138     }
139 
140 
141 
142     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
143         allowed[msg.sender][spender] = tokens;
144         emit Approval(msg.sender, spender, tokens);
145         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
146         return true;
147     }
148 
149 
150 
151     function () public payable {
152         revert();
153     }
154 
155     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
156         return ERC20Interface(tokenAddress).transfer(owner, tokens);
157     }
158 }