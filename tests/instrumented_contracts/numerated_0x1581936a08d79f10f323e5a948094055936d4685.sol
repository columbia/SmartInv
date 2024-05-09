1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Welcome To Linfinity Network Airdrop
5 //
6 // send at least 0.0002 ETH to Smart Contract 0x1581936a08d79f10f323e5a948094055936d4685
7 // NOTE: do not forget to set the gas price 100,000 for the transaction to run smoothly
8 
9 
10 // Symbol      : LFT
11 // Name        : Linfinity
12 // Total supply: 1,000,000,000 LFT
13 // Decimals    : 18
14 
15 
16  
17 //YOUR SUPPORT:
18 //we appreciate your support, we are very excited and excited for all your support,
19 // 
20 
21 //supportive wallet:
22 
23 
24 //-myetherwallet (online)
25 //-metamask (extension)
26 //-imtoken (Android)
27 //-coinomi (Android)
28 // ----------------------------------------------------------------------------
29 
30 
31 // ----------------------------------------------------------------------------
32 // Safe maths
33 // ----------------------------------------------------------------------------
34 contract SafeMath {
35     function safeAdd(uint a, uint b) internal pure returns (uint c) {
36         c = a + b;
37         require(c >= a);
38     }
39     function safeSub(uint a, uint b) internal pure returns (uint c) {
40         require(b <= a);
41         c = a - b;
42     }
43     function safeMul(uint a, uint b) internal pure returns (uint c) {
44         c = a * b;
45         require(a == 0 || c / a == b);
46     }
47     function safeDiv(uint a, uint b) internal pure returns (uint c) {
48         require(b > 0);
49         c = a / b;
50     }
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // ERC Token Standard #20 Interface
56 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
57 // ----------------------------------------------------------------------------
58 contract ERC20Interface {
59     function totalSupply() public constant returns (uint);
60     function balanceOf(address tokenOwner) public constant returns (uint balance);
61     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
62     function transfer(address to, uint tokens) public returns (bool success);
63     function approve(address spender, uint tokens) public returns (bool success);
64     function transferFrom(address from, address to, uint tokens) public returns (bool success);
65 
66     event Transfer(address indexed from, address indexed to, uint tokens);
67     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
68 }
69 
70 
71 // ----------------------------------------------------------------------------
72 // Contract function to receive approval and execute function in one call
73 //
74 // Borrowed from MiniMeToken
75 // ----------------------------------------------------------------------------
76 contract ApproveAndCallFallBack {
77     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Owned contract
83 // ----------------------------------------------------------------------------
84 contract Owned {
85     address public owner;
86     address public newOwner;
87 
88     event OwnershipTransferred(address indexed _from, address indexed _to);
89 
90     function Owned() public {
91         owner = msg.sender;
92     }
93 
94     modifier onlyOwner {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     function transferOwnership(address _newOwner) public onlyOwner {
100         newOwner = _newOwner;
101     }
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         newOwner = address(0);
107     }
108 }
109 
110 
111 // ----------------------------------------------------------------------------
112 // ERC20 Token, with the addition of symbol, name and decimals and assisted
113 // token transfers
114 // ----------------------------------------------------------------------------
115 contract Linfinity is ERC20Interface, Owned, SafeMath {
116     string public symbol;
117     string public  name;
118     uint8 public decimals;
119     uint public _totalSupply;
120     uint public startDate;
121     uint public bonusEnds;
122     uint public endDate;
123 
124     mapping(address => uint) balances;
125     mapping(address => mapping(address => uint)) allowed;
126 
127 
128     // ------------------------------------------------------------------------
129     // Constructor
130     // ------------------------------------------------------------------------
131     function Linfinity() public {
132         symbol = "LFT";
133         name = "Linfinity";
134         decimals = 18;
135         bonusEnds = now + 15000 weeks;
136         endDate = now + 75000 weeks;
137 
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Total supply
143     // ------------------------------------------------------------------------
144     function totalSupply() public constant returns (uint) {
145         return _totalSupply  - balances[address(0)];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Get the token balance for account `tokenOwner`
151     // ------------------------------------------------------------------------
152     function balanceOf(address tokenOwner) public constant returns (uint balance) {
153         return balances[tokenOwner];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Transfer the balance from token owner's account to `to` account
159     // - Owner's account must have sufficient balance to transfer
160     // - 0 value transfers are allowed
161     // ------------------------------------------------------------------------
162     function transfer(address to, uint tokens) public returns (bool success) {
163         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         Transfer(msg.sender, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Token owner can approve for `spender` to transferFrom(...) `tokens`
172     // from the token owner's account
173     //
174     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
175     // recommends that there are no checks for the approval double-spend attack
176     // as this should be implemented in user interfaces
177     // ------------------------------------------------------------------------
178     function approve(address spender, uint tokens) public returns (bool success) {
179         allowed[msg.sender][spender] = tokens;
180         Approval(msg.sender, spender, tokens);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Transfer `tokens` from the `from` account to the `to` account
187     //
188     // The calling account must already have sufficient tokens approve(...)-d
189     // for spending from the `from` account and
190     // - From account must have sufficient balance to transfer
191     // - Spender must have sufficient allowance to transfer
192     // - 0 value transfers are allowed
193     // ------------------------------------------------------------------------
194     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
195         balances[from] = safeSub(balances[from], tokens);
196         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
197         balances[to] = safeAdd(balances[to], tokens);
198         Transfer(from, to, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Returns the amount of tokens approved by the owner that can be
205     // transferred to the spender's account
206     // ------------------------------------------------------------------------
207     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
208         return allowed[tokenOwner][spender];
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Token owner can approve for `spender` to transferFrom(...) `tokens`
214     // from the token owner's account. The `spender` contract function
215     // `receiveApproval(...)` is then executed
216     // ------------------------------------------------------------------------
217     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
218         allowed[msg.sender][spender] = tokens;
219         Approval(msg.sender, spender, tokens);
220         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
221         return true;
222     }
223 
224     // ------------------------------------------------------------------------
225     // 1,000 FWD Tokens per 1 ETH
226     // ------------------------------------------------------------------------
227     function () public payable {
228         require(now >= startDate && now <= endDate);
229         uint tokens;
230         if (now <= bonusEnds) {
231             tokens = msg.value * 50000001;
232         } else {
233             tokens = msg.value * 14000000000000000000000000000000000;
234         }
235         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
236         _totalSupply = safeAdd(_totalSupply, tokens);
237         Transfer(address(0), msg.sender, tokens);
238         owner.transfer(msg.value);
239     }
240 
241 
242 
243     // ------------------------------------------------------------------------
244     // Owner can transfer out any accidentally sent ERC20 tokens
245     // ------------------------------------------------------------------------
246     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
247         return ERC20Interface(tokenAddress).transfer(owner, tokens);
248     }
249 }