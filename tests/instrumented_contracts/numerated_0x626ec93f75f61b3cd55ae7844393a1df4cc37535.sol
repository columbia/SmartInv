1 // ----------------------------------------------------------------------------
2 // 'OPN' token contract
3 //
4 // Deployed to : 0xd21B0C87fc63a876E5eE2dC82D777aFBA9d4a5e5
5 // Symbol      : OPN
6 // Name        : OpnMind
7 // Total supply: 33428795
8 // Decimals    : 2  
9 //
10 // Enjoy.
11 //
12 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Safe maths
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24     function safeSub(uint a, uint b) public pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28     function safeMul(uint a, uint b) public pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32     function safeDiv(uint a, uint b) public pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // ERC Token Standard #20 Interface
41 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
42 // ----------------------------------------------------------------------------
43 contract ERC20Interface {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 
56 // ----------------------------------------------------------------------------
57 // Contract function to receive approval and execute function in one call
58 //
59 // Borrowed from MiniMeToken
60 // ----------------------------------------------------------------------------
61 contract ApproveAndCallFallBack {
62     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74 
75     function Owned() public {
76         owner = msg.sender;
77     }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and assisted
98 // token transfers
99 // ----------------------------------------------------------------------------
100 contract OpnMind is ERC20Interface, Owned, SafeMath {
101     string public symbol;
102     string public  name;
103     uint8 public decimals;
104     uint public _totalSupply;
105 
106     mapping(address => uint) balances;
107     mapping(address => mapping(address => uint)) allowed;
108 
109 
110     // ------------------------------------------------------------------------
111     // Constructor
112     // ------------------------------------------------------------------------
113     function OpnMind() public {
114         symbol = "OPN";
115         name = "OpnMind";
116         decimals = 2;
117         _totalSupply = 3342879500;
118         balances[0xd21B0C87fc63a876E5eE2dC82D777aFBA9d4a5e5] = _totalSupply;
119         Transfer(address(0), 0xd21B0C87fc63a876E5eE2dC82D777aFBA9d4a5e5, _totalSupply);
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply  - balances[address(0)];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account tokenOwner
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to to account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for spender to transferFrom(...) tokens
154     // from the token owner's account
155     //
156     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
157     // recommends that there are no checks for the approval double-spend attack
158     // as this should be implemented in user interfaces 
159     // ------------------------------------------------------------------------
160     function approve(address spender, uint tokens) public returns (bool success) {
161         allowed[msg.sender][spender] = tokens;
162         Approval(msg.sender, spender, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer tokens from the from account to the to account
169     // 
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the from account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
177         balances[from] = safeSub(balances[from], tokens);
178         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
179         balances[to] = safeAdd(balances[to], tokens);
180         Transfer(from, to, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Returns the amount of tokens approved by the owner that can be
187     // transferred to the spender's account
188     // ------------------------------------------------------------------------
189     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
190         return allowed[tokenOwner][spender];
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Token owner can approve for spender to transferFrom(...) tokens
196     // from the token owner's account. The spender contract function
197     // receiveApproval(...) is then executed
198     // ------------------------------------------------------------------------
199     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
200         allowed[msg.sender][spender] = tokens;
201         Approval(msg.sender, spender, tokens);
202         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Don't accept ETH
209     // ------------------------------------------------------------------------
210     function () public payable {
211         revert();
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Owner can transfer out any accidentally sent ERC20 tokens
217     // ------------------------------------------------------------------------
218     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
219         return ERC20Interface(tokenAddress).transfer(owner, tokens);
220     }
221 }