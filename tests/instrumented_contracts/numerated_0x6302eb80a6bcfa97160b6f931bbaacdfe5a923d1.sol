1 pragma solidity ^0.4.26;
2 
3 // ----------------------------------------------------------------------------
4 // 'FASTPAY' token contract
5 
6 // Deployed to : 0x30500c6a3f7D86802dCb1393dde28098F8054258
7 // Symbol      : FASTPAY
8 // Name        : FASTPAY
9 // Total supply: 1000000
10 // Decimals    : 18
11 // https://fastpaytoken.com/
12 // Enjoy.
13 //
14 // (c) by BU 2020. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function safeDiv(uint a, uint b) public pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 
40 
41 contract ERC20Interface {
42     function totalSupply() public constant returns (uint);
43     function balanceOf(address tokenOwner) public constant returns (uint balance);
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64 
65     constructor() public {
66         owner = msg.sender;
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // ERC20 Token, with the addition of symbol, name and decimals and assisted
88 // token transfers
89 // ----------------------------------------------------------------------------
90 contract FASTPAY is ERC20Interface, Owned, SafeMath {
91     string public symbol;
92     string public  name;
93     uint8 public decimals;
94     uint public _totalSupply;
95 
96     mapping(address => uint) balances;
97     mapping(address => mapping(address => uint)) allowed;
98 
99 
100     // ------------------------------------------------------------------------
101     // Constructor
102     // ------------------------------------------------------------------------
103     constructor() public {
104         symbol = "FASTPAY";
105         name = "FASTPAY";
106         decimals = 18;
107         _totalSupply = 1000000000000000000000000;
108         balances[0x30500c6a3f7D86802dCb1393dde28098F8054258] = _totalSupply;
109         emit Transfer(address(0), 0x30500c6a3f7D86802dCb1393dde28098F8054258, _totalSupply);
110     }
111 
112 
113     // ------------------------------------------------------------------------
114     // Total supply
115     // ------------------------------------------------------------------------
116     function totalSupply() public constant returns (uint) {
117         return _totalSupply  - balances[address(0)];
118     }
119 
120 
121     function balanceOf(address tokenOwner) public constant returns (uint balance) {
122         return balances[tokenOwner];
123     }
124 
125 
126     function transfer(address to, uint tokens) public returns (bool success) {
127         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
128         balances[to] = safeAdd(balances[to], tokens);
129         emit Transfer(msg.sender, to, tokens);
130         return true;
131     }
132 
133 
134     function approve(address spender, uint tokens) public returns (bool success) {
135         allowed[msg.sender][spender] = tokens;
136         emit Approval(msg.sender, spender, tokens);
137         return true;
138     }
139 
140 
141     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
142         balances[from] = safeSub(balances[from], tokens);
143         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
144         balances[to] = safeAdd(balances[to], tokens);
145         emit Transfer(from, to, tokens);
146         return true;
147     }
148 
149 
150     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
151         return allowed[tokenOwner][spender];
152     }
153 
154 
155     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
159         return true;
160     }
161 
162 
163     function () public payable {
164         revert();
165     }
166 
167     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
168         return ERC20Interface(tokenAddress).transfer(owner, tokens);
169     }
170 }