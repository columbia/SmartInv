1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'MedicalVEDA' token contract
5 //
6 // Deployed to  : 0x06AE7E82F5f06e830cB74835755E8453e2327758
7 // Symbol       : MVEDA
8 // Name         : MedicalVEDA
9 // Total supply : 88,000,000
10 // Decimals     : 8
11 // ----------------------------------------------------------------------------
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) public pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) public pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) public pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) public pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 // Borrowed from MiniMeToken
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // Owned contract
62 // ----------------------------------------------------------------------------
63 contract Owned {
64     address public owner;
65     address public newOwner;
66 
67     event OwnershipTransferred(address indexed _from, address indexed _to);
68 
69     function Owned() public {
70         owner = msg.sender;
71     }
72 
73     modifier onlyOwner {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81 
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // MVEDA
93 // ----------------------------------------------------------------------------
94 contract MVEDA is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103     function MVEDA() public {
104         symbol = "MVEDA";
105         name = "MedicalVEDA";
106         decimals = 8;
107         _totalSupply = 8800000000000000;
108         balances[0x66396b3C3D8446E364e805cB0E8C310dDDFF685e] = _totalSupply;
109         Transfer(address(0), 0x66396b3C3D8446E364e805cB0E8C310dDDFF685e, _totalSupply);
110     }
111 
112     function totalSupply() public constant returns (uint) {
113         return _totalSupply  - balances[address(0)];
114     }
115 
116 
117     function balanceOf(address tokenOwner) public constant returns (uint balance) {
118         return balances[tokenOwner];
119     }
120 
121     function transfer(address to, uint tokens) public returns (bool success) {
122         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
123         balances[to] = safeAdd(balances[to], tokens);
124         Transfer(msg.sender, to, tokens);
125         return true;
126     }
127 
128     function approve(address spender, uint tokens) public returns (bool success) {
129         allowed[msg.sender][spender] = tokens;
130         Approval(msg.sender, spender, tokens);
131         return true;
132     }
133 
134     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
135         balances[from] = safeSub(balances[from], tokens);
136         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
137         balances[to] = safeAdd(balances[to], tokens);
138         Transfer(from, to, tokens);
139         return true;
140     }
141 
142     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
143         return allowed[tokenOwner][spender];
144     }
145 
146     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         Approval(msg.sender, spender, tokens);
149         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
150         return true;
151     }
152 
153     function () public payable {
154         revert();
155     }
156 
157     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
158         return ERC20Interface(tokenAddress).transfer(owner, tokens);
159     }
160 }