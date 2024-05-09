1 pragma solidity ^0.4.18;
2 // ----------------------------------------------------------------------------
3 // Symbol      : GTH
4 // Name        : GlowEther
5 // Total supply: 15000000
6 // Decimals    : 18
7 // ----------------------------------------------------------------------------
8 contract SafeMath {
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint a, uint b) public pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint a, uint b) public pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint a, uint b) public pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public constant returns (uint);
31     function balanceOf(address tokenOwner) public constant returns (uint balance);
32     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 
42 // ----------------------------------------------------------------------------
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // Owned contract
50 // ----------------------------------------------------------------------------
51 contract Owned {
52     address public owner;
53     address public newOwner;
54 
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     function Owned() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 // ----------------------------------------------------------------------------
78 contract GlowEther is ERC20Interface, Owned, SafeMath {
79     string public symbol;
80     string public  name;
81     uint8 public decimals;
82     uint public _totalSupply;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87 
88     // ------------------------------------------------------------------------
89     // Constructor
90     // ------------------------------------------------------------------------
91     function GlowEther() public {
92         symbol = "GTH";
93         name = "GlowEther";
94         decimals = 18;
95         _totalSupply = 15000000000000000000000000;
96         balances[0x1b9266B9dA4d0a72A45c13666D8aA307135eF37B] = _totalSupply;
97         Transfer(address(0), 0x1b9266B9dA4d0a72A45c13666D8aA307135eF37B, _totalSupply);
98     }
99 
100 
101 
102     // ------------------------------------------------------------------------
103     function totalSupply() public constant returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107 
108 
109     // ------------------------------------------------------------------------
110     function balanceOf(address tokenOwner) public constant returns (uint balance) {
111         return balances[tokenOwner];
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     function transfer(address to, uint tokens) public returns (bool success) {
117         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
118         balances[to] = safeAdd(balances[to], tokens);
119         Transfer(msg.sender, to, tokens);
120         return true;
121     }
122 
123 
124      // ------------------------------------------------------------------------
125     function approve(address spender, uint tokens) public returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         Approval(msg.sender, spender, tokens);
128         return true;
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = safeSub(balances[from], tokens);
135         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         Transfer(from, to, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
144         return allowed[tokenOwner][spender];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
150         allowed[msg.sender][spender] = tokens;
151         Approval(msg.sender, spender, tokens);
152         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     function () public payable {
159         revert();
160     }
161 
162     // ------------------------------------------------------------------------
163     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
164         return ERC20Interface(tokenAddress).transfer(owner, tokens);
165     }
166 }