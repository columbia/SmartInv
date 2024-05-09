1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CATCOIN' token contract
5 //
6 // Deployed to : 0x8293bbd92c42608b20af588620a76128a33e4de9
7 // Symbol      : CATS
8 // Name        : CATCOIN
9 // Total supply: 200,000,000,000
10 // Decimals    : 6
11 //
12 //
13 // (c) by ERC20Developer with CATCOIN [CATS] Symbol 2019. The MIT Licence. Developed By: ERC20 TOKEN DEVELOPER
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 contract SafeMath {
21     function safeAdd(uint a, uint b) public pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function safeSub(uint a, uint b) public pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function safeMul(uint a, uint b) public pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function safeDiv(uint a, uint b) public pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Developed By ERC20Developer
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 contract Owned {
68     address public owner;
69     address public newOwner;
70 
71     event OwnershipTransferred(address indexed _from, address indexed _to);
72 
73     function Owned() public {
74         owner = msg.sender;
75     }
76 
77     modifier onlyOwner {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public onlyOwner {
83         newOwner = _newOwner;
84     }
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 
94 contract CATCOIN is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     function CATCOIN() public {
105         symbol = "CATS";
106         name = "CATCOIN";
107         decimals = 6;
108         _totalSupply = 200000000000000000;
109         balances[0xEDA5EE344AFB55c13317ef6C34A1983DCD0a7769] = _totalSupply;
110         Transfer(address(0), 0xEDA5EE344AFB55c13317ef6C34A1983DCD0a7769, _totalSupply);
111     }
112 
113 
114     function totalSupply() public constant returns (uint) {
115         return _totalSupply  - balances[address(0)];
116     }
117 
118 
119     function balanceOf(address tokenOwner) public constant returns (uint balance) {
120         return balances[tokenOwner];
121     }
122 
123 
124     function transfer(address to, uint tokens) public returns (bool success) {
125         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
126         balances[to] = safeAdd(balances[to], tokens);
127         Transfer(msg.sender, to, tokens);
128         return true;
129     }
130 
131 
132     function approve(address spender, uint tokens) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         Approval(msg.sender, spender, tokens);
135         return true;
136     }
137 
138 
139     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
140         balances[from] = safeSub(balances[from], tokens);
141         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         Transfer(from, to, tokens);
144         return true;
145     }
146 
147 
148     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
149         return allowed[tokenOwner][spender];
150     }
151 
152 
153     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         Approval(msg.sender, spender, tokens);
156         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
157         return true;
158     }
159 
160 
161     function () public payable {
162         revert();
163     }
164 
165 
166     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
167         return ERC20Interface(tokenAddress).transfer(owner, tokens);
168     }
169 }