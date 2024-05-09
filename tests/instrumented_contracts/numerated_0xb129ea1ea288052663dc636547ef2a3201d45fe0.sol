1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'OMIVIA' token contract
5 //
6 // Deployed to : 0x1e7FAA7b4a62f2F5844c3d5823b70350DEb3C824
7 // Symbol      : OVA
8 // Name        : OMIVIA
9 // Total supply: 100000000
10 // Decimals    : 8
11 //
12 // Enjoy.
13 //
14 // (c) by Argamonte Alan David with Steiner Jose Maria.
15 // ----------------------------------------------------------------------------
16 
17 
18 contract SafeMath {
19     function safeAdd(uint a, uint b) public pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) public pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) public pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) public pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint);
41     
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     
44     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
45     
46     function transfer(address to, uint tokens) public returns (bool success);
47     
48     function approve(address spender, uint tokens) public returns (bool success);
49     
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     
54     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     function Owned() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 contract OMIVIA is ERC20Interface, Owned, SafeMath {
93     string public symbol;
94     string public  name;
95     uint8 public decimals;
96     uint public _totalSupply;
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping(address => uint)) allowed;
100 
101 
102    
103     function OMIVIA() public {
104         symbol = "OVA";
105         name = "OMIVIA";
106         decimals = 8;
107         _totalSupply = 10000000000000000;
108         balances[0x1e7FAA7b4a62f2F5844c3d5823b70350DEb3C824] = _totalSupply;
109         Transfer(address(0), 0x1e7FAA7b4a62f2F5844c3d5823b70350DEb3C824, _totalSupply);
110     }
111 
112 
113     
114     function totalSupply() public constant returns (uint) {
115         return _totalSupply  - balances[address(0)];
116     }
117 
118 
119     
120     function balanceOf(address tokenOwner) public constant returns (uint balance) {
121         return balances[tokenOwner];
122     }
123 
124 
125   
126     function transfer(address to, uint tokens) public returns (bool success) {
127         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
128         balances[to] = safeAdd(balances[to], tokens);
129         Transfer(msg.sender, to, tokens);
130         return true;
131     }
132 
133 
134    
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         Approval(msg.sender, spender, tokens);
138         return true;
139     }
140 
141 
142   
143     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
144         balances[from] = safeSub(balances[from], tokens);
145         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         Transfer(from, to, tokens);
148         return true;
149     }
150 
151 
152    
153     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
154         return allowed[tokenOwner][spender];
155     }
156 
157 
158    
159     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
160         allowed[msg.sender][spender] = tokens;
161         Approval(msg.sender, spender, tokens);
162         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
163         return true;
164     }
165 
166 
167    
168     function () public payable {
169         revert();
170     }
171 
172 
173    
174     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
175         return ERC20Interface(tokenAddress).transfer(owner, tokens);
176     }
177 }