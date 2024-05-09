1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'CRTIV' CROWDSALE token contract
5 //
6 // Deployed to : 0xcb803CCd153E07374F5c3c047A6137022374aAd9
7 // Symbol      : CRTIV
8 // Name        : CryptoTrustInvest
9 // Total supply: Gazillion
10 // Decimals    : 18
11 //
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
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
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 //
57 // Borrowed from MiniMeToken
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
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
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and assisted
96 // token transfers
97 // ----------------------------------------------------------------------------
98 contract CRTIV is ERC20Interface, Owned, SafeMath {
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint public _totalSupply;
103     uint public startDate;
104     uint public bonusEnds;
105     uint public endDate;
106 
107     mapping(address => uint) balances;
108     mapping(address => mapping(address => uint)) allowed;
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     function CRTIV() public {
115         symbol = "CRTIV";
116         name = "CryptoTrustInvest";
117         decimals = 18;
118         bonusEnds = now + 8 weeks;
119         endDate = now + 30 weeks;
120 
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
133     // Get the token balance for account `tokenOwner`
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public constant returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer the balance from token owner's account to `to` account
142     // - Owner's account must have sufficient balance to transfer
143     // - 0 value transfers are allowed
144     // ------------------------------------------------------------------------
145     function transfer(address to, uint tokens) public returns (bool success) {
146         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         Transfer(msg.sender, to, tokens);
149         return true;
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for `spender` to transferFrom(...) `tokens`
155     // from the token owner's account
156     //
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer `tokens` from the `from` account to the `to` account
170     //
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the `from` account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
178         balances[from] = safeSub(balances[from], tokens);
179         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
180         balances[to] = safeAdd(balances[to], tokens);
181         Transfer(from, to, tokens);
182         return true;
183     }
184 
185 
186     // ------------------------------------------------------------------------
187     // Returns the amount of tokens approved by the owner that can be
188     // transferred to the spender's account
189     // ------------------------------------------------------------------------
190     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
191         return allowed[tokenOwner][spender];
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Token owner can approve for `spender` to transferFrom(...) `tokens`
197     // from the token owner's account. The `spender` contract function
198     // `receiveApproval(...)` is then executed
199     // ------------------------------------------------------------------------
200     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
201         allowed[msg.sender][spender] = tokens;
202         Approval(msg.sender, spender, tokens);
203         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
204         return true;
205     }
206 
207     // ------------------------------------------------------------------------
208     // 1,000 CRTIV per 1 ETH
209     // ------------------------------------------------------------------------
210     function () public payable {
211         require(now >= startDate && now <= endDate);
212         uint tokens;
213         if (now <= bonusEnds) {
214             tokens = msg.value * 1200;
215         } else {
216             tokens = msg.value * 1000;
217         }
218         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
219         _totalSupply = safeAdd(_totalSupply, tokens);
220         Transfer(address(0), msg.sender, tokens);
221         owner.transfer(msg.value);
222     }
223 
224 
225 
226     // ------------------------------------------------------------------------
227     // Owner can transfer out any accidentally sent ERC20 tokens
228     // ------------------------------------------------------------------------
229     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
230         return ERC20Interface(tokenAddress).transfer(owner, tokens);
231     }
232 }