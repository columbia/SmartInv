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
73 contract M10FanClub is ERC20Interface, Owned, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82 
83     // ------------------------------------------------------------------------
84     // Constructor
85     // ------------------------------------------------------------------------
86     function M10FanClub() public {
87         symbol = "M10";
88         name = "M10 Fan Club";
89         decimals = 18;
90         _totalSupply = 100000000000000000000000000000;
91         balances[0x0A106e8eFA3747d077844e1d985EaF6f008Fe914] = _totalSupply;
92         emit Transfer(address(0), 0x0A106e8eFA3747d077844e1d985EaF6f008Fe914, _totalSupply);
93     }
94 
95 
96     // ------------------------------------------------------------------------
97     // Total supply
98     // ------------------------------------------------------------------------
99     function totalSupply() public constant returns (uint) {
100         return _totalSupply  - balances[address(0)];
101     }
102 
103 
104     // ------------------------------------------------------------------------
105     // Get the token balance for account tokenOwner
106     // ------------------------------------------------------------------------
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Transfer the balance from token owner's account to to account
114     // - Owner's account must have sufficient balance to transfer
115     // - 0 value transfers are allowed
116     // ------------------------------------------------------------------------
117     function transfer(address to, uint tokens) public returns (bool success) {
118         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
119         balances[to] = safeAdd(balances[to], tokens);
120         emit Transfer(msg.sender, to, tokens);
121         return true;
122     }
123 
124 
125  
126     function approve(address spender, uint tokens) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         return true;
130     }
131 
132 
133 
134     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
135         balances[from] = safeSub(balances[from], tokens);
136         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
137         balances[to] = safeAdd(balances[to], tokens);
138         emit Transfer(from, to, tokens);
139         return true;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Returns the amount of tokens approved by the owner that can be
145     // transferred to the spender's account
146     // ------------------------------------------------------------------------
147     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
148         return allowed[tokenOwner][spender];
149     }
150 
151 
152     
153     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Don't accept ETH
163     // ------------------------------------------------------------------------
164     function () public payable {
165         revert();
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Owner can transfer out any accidentally sent ERC20 tokens
171     // ------------------------------------------------------------------------
172     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
173         return ERC20Interface(tokenAddress).transfer(owner, tokens);
174     }
175 }