1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'ProSwap' token contract
5 //
6 // Symbol       : PROS
7 // Name         : ProSwap
8 // Total supply : 10,000,000
9 // Decimals     : 6
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     function Owned() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80 
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // ProSwap
92 // ----------------------------------------------------------------------------
93 contract ProSwap is ERC20Interface, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98 
99     mapping(address => uint) balances;
100     mapping(address => mapping(address => uint)) allowed;
101 
102     function ProSwap() public {
103         symbol = "PROS";
104         name = "ProSwap";
105         decimals = 6;
106         _totalSupply = 10000000000000;
107         balances[0x66396b3C3D8446E364e805cB0E8C310dDDFF685e] = _totalSupply;
108         Transfer(address(0), 0x66396b3C3D8446E364e805cB0E8C310dDDFF685e, _totalSupply);
109     }
110 
111     function totalSupply() public constant returns (uint) {
112         return _totalSupply  - balances[address(0)];
113     }
114 
115 
116     function balanceOf(address tokenOwner) public constant returns (uint balance) {
117         return balances[tokenOwner];
118     }
119 
120     function transfer(address to, uint tokens) public returns (bool success) {
121         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
122         balances[to] = safeAdd(balances[to], tokens);
123         Transfer(msg.sender, to, tokens);
124         return true;
125     }
126 
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = safeSub(balances[from], tokens);
135         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         Transfer(from, to, tokens);
138         return true;
139     }
140 
141     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
142         return allowed[tokenOwner][spender];
143     }
144 
145     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         Approval(msg.sender, spender, tokens);
148         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
149         return true;
150     }
151 
152     function () public payable {
153         revert();
154     }
155 
156     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
157         return ERC20Interface(tokenAddress).transfer(owner, tokens);
158     }
159 }