1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Welcome To ZeroChain Network Airdrop
5 //
6 // send at least 0.0001 ETH to Smart Contract 0x7589e58B2197CA56BcD186c871D3c9aBdE35B737
7 // NOTE: do not forget to set the gas price 100,000 for the transaction to run smoothly
8 
9 
10 // Symbol      : OxCN
11 // Name        : ZeroChainNetwork
12 // Total supply: 1,000,000,000
13 // Decimals    : 18
14 
15 
16 //EXCHANGE:
17 //while for the exchange, we have contacted some exchanges and we will probably be scheduled in the stock 4 days after the first stage 1 airdrop is done, this is the list of exchanges we managed to contact
18 //1. Mercatox (negotiation)
19 //2. idax (negotiation)
20 //3. forkdelta (no response yet)
21 //4. crex24 (negotiation)
22 //5. bitebtc (negotiation)
23 //6. idex (no response)
24 //7. coinex (negotiation)
25 //8. hitbtc (unconfirmed)
26  
27 //YOUR SUPPORT:
28 //we appreciate your support, we are very excited and excited for all your support,
29 // 
30 
31 //supportive wallet:
32 
33 
34 //-myetherwallet (online)
35 //-metamask (extension)
36 //-imtoken (Android)
37 //-coinomi (Android)
38 // ----------------------------------------------------------------------------
39 
40 
41 // ----------------------------------------------------------------------------
42 // Safe maths
43 // ----------------------------------------------------------------------------
44 contract SafeMath {
45     function safeAdd(uint a, uint b) internal pure returns (uint c) {
46         c = a + b;
47         require(c >= a);
48     }
49     function safeSub(uint a, uint b) internal pure returns (uint c) {
50         require(b <= a);
51         c = a - b;
52     }
53     function safeMul(uint a, uint b) internal pure returns (uint c) {
54         c = a * b;
55         require(a == 0 || c / a == b);
56     }
57     function safeDiv(uint a, uint b) internal pure returns (uint c) {
58         require(b > 0);
59         c = a / b;
60     }
61 }
62 
63 
64 // ----------------------------------------------------------------------------
65 // ERC Token Standard #20 Interface
66 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
67 // ----------------------------------------------------------------------------
68 contract ERC20Interface {
69     function totalSupply() public constant returns (uint);
70     function balanceOf(address tokenOwner) public constant returns (uint balance);
71     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
72     function transfer(address to, uint tokens) public returns (bool success);
73     function approve(address spender, uint tokens) public returns (bool success);
74     function transferFrom(address from, address to, uint tokens) public returns (bool success);
75 
76     event Transfer(address indexed from, address indexed to, uint tokens);
77     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // Contract function to receive approval and execute function in one call
83 //
84 // Borrowed from MiniMeToken
85 // ----------------------------------------------------------------------------
86 contract ApproveAndCallFallBack {
87     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 // Owned contract
93 // ----------------------------------------------------------------------------
94 contract Owned {
95     address public owner;
96     address public newOwner;
97 
98     event OwnershipTransferred(address indexed _from, address indexed _to);
99 
100     function Owned() public {
101         owner = msg.sender;
102     }
103 
104     modifier onlyOwner {
105         require(msg.sender == owner);
106         _;
107     }
108 
109     function transferOwnership(address _newOwner) public onlyOwner {
110         newOwner = _newOwner;
111     }
112     function acceptOwnership() public {
113         require(msg.sender == newOwner);
114         OwnershipTransferred(owner, newOwner);
115         owner = newOwner;
116         newOwner = address(0);
117     }
118 }
119 
120 
121 // ----------------------------------------------------------------------------
122 // ERC20 Token, with the addition of symbol, name and decimals and assisted
123 // token transfers
124 // ----------------------------------------------------------------------------
125 contract OxChainNetwork is ERC20Interface, Owned, SafeMath {
126     string public symbol;
127     string public  name;
128     uint8 public decimals;
129     uint public _totalSupply;
130     uint public startDate;
131     uint public bonusEnds;
132     uint public endDate;
133 
134     mapping(address => uint) balances;
135     mapping(address => mapping(address => uint)) allowed;
136 
137 
138     // ------------------------------------------------------------------------
139     // Constructor
140     // ------------------------------------------------------------------------
141     function OxChainNetwork() public {
142         symbol = "OxCN";
143         name = "OxChain Network";
144         decimals = 18;
145         bonusEnds = now + 1500 weeks;
146         endDate = now + 7500 weeks;
147 
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Total supply
153     // ------------------------------------------------------------------------
154     function totalSupply() public constant returns (uint) {
155         return _totalSupply  - balances[address(0)];
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Get the token balance for account `tokenOwner`
161     // ------------------------------------------------------------------------
162     function balanceOf(address tokenOwner) public constant returns (uint balance) {
163         return balances[tokenOwner];
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Transfer the balance from token owner's account to `to` account
169     // - Owner's account must have sufficient balance to transfer
170     // - 0 value transfers are allowed
171     // ------------------------------------------------------------------------
172     function transfer(address to, uint tokens) public returns (bool success) {
173         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
174         balances[to] = safeAdd(balances[to], tokens);
175         Transfer(msg.sender, to, tokens);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for `spender` to transferFrom(...) `tokens`
182     // from the token owner's account
183     //
184     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
185     // recommends that there are no checks for the approval double-spend attack
186     // as this should be implemented in user interfaces
187     // ------------------------------------------------------------------------
188     function approve(address spender, uint tokens) public returns (bool success) {
189         allowed[msg.sender][spender] = tokens;
190         Approval(msg.sender, spender, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Transfer `tokens` from the `from` account to the `to` account
197     //
198     // The calling account must already have sufficient tokens approve(...)-d
199     // for spending from the `from` account and
200     // - From account must have sufficient balance to transfer
201     // - Spender must have sufficient allowance to transfer
202     // - 0 value transfers are allowed
203     // ------------------------------------------------------------------------
204     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
205         balances[from] = safeSub(balances[from], tokens);
206         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
207         balances[to] = safeAdd(balances[to], tokens);
208         Transfer(from, to, tokens);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Returns the amount of tokens approved by the owner that can be
215     // transferred to the spender's account
216     // ------------------------------------------------------------------------
217     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
218         return allowed[tokenOwner][spender];
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Token owner can approve for `spender` to transferFrom(...) `tokens`
224     // from the token owner's account. The `spender` contract function
225     // `receiveApproval(...)` is then executed
226     // ------------------------------------------------------------------------
227     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
228         allowed[msg.sender][spender] = tokens;
229         Approval(msg.sender, spender, tokens);
230         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
231         return true;
232     }
233 
234     // ------------------------------------------------------------------------
235     // 1,000 FWD Tokens per 1 ETH
236     // ------------------------------------------------------------------------
237     function () public payable {
238         require(now >= startDate && now <= endDate);
239         uint tokens;
240         if (now <= bonusEnds) {
241             tokens = msg.value * 50000001;
242         } else {
243             tokens = msg.value * 14000000000000000000000;
244         }
245         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
246         _totalSupply = safeAdd(_totalSupply, tokens);
247         Transfer(address(0), msg.sender, tokens);
248         owner.transfer(msg.value);
249     }
250 
251 
252 
253     // ------------------------------------------------------------------------
254     // Owner can transfer out any accidentally sent ERC20 tokens
255     // ------------------------------------------------------------------------
256     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
257         return ERC20Interface(tokenAddress).transfer(owner, tokens);
258     }
259 }