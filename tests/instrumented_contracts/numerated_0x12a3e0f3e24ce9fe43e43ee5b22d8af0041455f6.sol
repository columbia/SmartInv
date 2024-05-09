1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Sleipnir' token contract
5 //
6 // Deployed to : 0xa015fE2a1947B23AD454E699F8CbbDa419671F5e
7 // Symbol      : SLP
8 // Name        : Sleipnir
9 // Total supply: 1000000
10 // Decimals    : 6
11 // Ing. Piotr Ivanov, HONS
12 
13 contract SafeMath {
14     function safeAdd(uint a, uint b) public pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function safeSub(uint a, uint b) public pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function safeMul(uint a, uint b) public pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function safeDiv(uint a, uint b) public pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 
33 // ----------------------------------------------------------------------------
34 // ERC Token Standard #20 Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
36 // ----------------------------------------------------------------------------
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 //
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
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract Sleipnir is ERC20Interface, Owned, SafeMath {
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
98     uint public _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     // ------------------------------------------------------------------------
105     // Constructor
106     // ------------------------------------------------------------------------
107     function Sleipnir() public {
108         symbol = "SLP";
109         name = "Sleipnir";
110         decimals = 6;
111         _totalSupply = 1000000000000;
112         balances[0xa015fE2a1947B23AD454E699F8CbbDa419671F5e] = _totalSupply;
113         Transfer(address(0), 0xa015fE2a1947B23AD454E699F8CbbDa419671F5e, _totalSupply);
114     }
115 
116 
117     function totalSupply() public constant returns (uint) {
118         return _totalSupply  - balances[address(0)];
119     }
120 
121 
122     function balanceOf(address tokenOwner) public constant returns (uint balance) {
123         return balances[tokenOwner];
124     }
125 
126 
127  
128     function transfer(address to, uint tokens) public returns (bool success) {
129         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
130         balances[to] = safeAdd(balances[to], tokens);
131         Transfer(msg.sender, to, tokens);
132         return true;
133     }
134 
135 
136   
137     function approve(address spender, uint tokens) public returns (bool success) {
138         allowed[msg.sender][spender] = tokens;
139         Approval(msg.sender, spender, tokens);
140         return true;
141     }
142 
143 
144 
145     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
146         balances[from] = safeSub(balances[from], tokens);
147         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
148         balances[to] = safeAdd(balances[to], tokens);
149         Transfer(from, to, tokens);
150         return true;
151     }
152 
153 
154 
155     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
156         return allowed[tokenOwner][spender];
157     }
158 
159 
160 
161     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         Approval(msg.sender, spender, tokens);
164         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
165         return true;
166     }
167 
168 
169    
170     function () public payable {
171         revert();
172     }
173 
174 
175     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
176         return ERC20Interface(tokenAddress).transfer(owner, tokens);
177     }
178 }