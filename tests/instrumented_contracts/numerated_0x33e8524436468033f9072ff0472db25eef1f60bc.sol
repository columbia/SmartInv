1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'Alibabacoin' token contract
5 //
6 // Website: https://abbcfoundation.com/
7 
8 // Symbol      : ABBC
9 // Name        : Alibaacoin
10 // Total supply: 1000000000
11 // Decimals    : 18
12 //
13 // Enjoy.
14 //
15 // (c) ALIBABACOIN Foundation 
16 //
17 // support@alibabacoinfoundation.com
18 // sales@alibabacoinfoundation.com 
19 // info@alibabacoinfoundation.com
20 //
21 // ----------------------------------------------------------------------------
22 
23 
24 // ----------------------------------------------------------------------------
25 // Safe maths
26 // ----------------------------------------------------------------------------
27 contract SafeMath {
28     function safeAdd(uint a, uint b) public pure returns (uint c) {
29         c = a + b;
30         require(c >= a);
31     }
32     function safeSub(uint a, uint b) public pure returns (uint c) {
33         require(b <= a);
34         c = a - b;
35     }
36     function safeMul(uint a, uint b) public pure returns (uint c) {
37         c = a * b;
38         require(a == 0 || c / a == b);
39     }
40     function safeDiv(uint a, uint b) public pure returns (uint c) {
41         require(b > 0);
42         c = a / b;
43     }
44 }
45 
46 
47 
48 contract ERC20Interface {
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 
61 
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     constructor() public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         emit OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and assisted
99 // token transfers
100 // ----------------------------------------------------------------------------
101 contract Alibabacoin is ERC20Interface, Owned, SafeMath {
102     string public symbol;
103     string public  name;
104     uint8 public decimals;
105     uint public _totalSupply;
106 
107     mapping(address => uint) balances;
108     mapping(address => mapping(address => uint)) allowed;
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     constructor() public {
115         symbol = "ABBC";
116         name = "Alibabacoin";
117         decimals = 18;
118         _totalSupply = 1000000000000000000000000000;
119         balances[0x8cc5c482CBB0cAED38918760465894297023D0A3] = _totalSupply;
120         emit Transfer(address(0), 0x8cc5c482CBB0cAED38918760465894297023D0A3, _totalSupply);
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Total supply
126     // ------------------------------------------------------------------------
127     function totalSupply() public constant returns (uint) {
128         return _totalSupply  - balances[address(0)];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account tokenOwner
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to to account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         emit Transfer(msg.sender, to, tokens);
149         return true;
150     }
151 
152 
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160 
161     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
162         balances[from] = safeSub(balances[from], tokens);
163         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         emit Transfer(from, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Returns the amount of tokens approved by the owner that can be
172     // transferred to the spender's account
173     // ------------------------------------------------------------------------
174     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
175         return allowed[tokenOwner][spender];
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for spender to transferFrom(...) tokens
181     // from the token owner's account. The spender contract function
182     // receiveApproval(...) is then executed
183     // ------------------------------------------------------------------------
184     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Don't accept ETH
194     // ------------------------------------------------------------------------
195     function () public payable {
196         revert();
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Owner can transfer out any accidentally sent ERC20 tokens
202     // ------------------------------------------------------------------------
203     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
204         return ERC20Interface(tokenAddress).transfer(owner, tokens);
205     }
206 }