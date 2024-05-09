1 /*03 October 2018 v4.0
2 
3                          -+/-           +oo/                             .ooo`
4                         -NNNN.          hNNy                             :NNN.
5                          +ss/           hNNy                             :NNN.
6   `:+o+/.`//-  .//.`:+o. ://:    `:+o+/.hNNy     -/+o+/-  `///.    ://:  :NNN-:+o+/.       -/+++:`
7 `omNNNNNNmNNs  +NNdmNNN: hNNy   omNNNNNNNNNy   +dNNNNNNN+ .NNN:    hNNs  :NNNNNNNNNNy.   omNNmdmNms`
8 yNNm/. .+NNNs  +NNNy:..` hNNy  sNNm+. .+mNNy  sNNm+.``-:  .NNN:    hNNs  :NNNy-``:dNNd` yNNd-``.yNNy
9 NNNo     yNNs  +NNN      hNNy  mNNs     yNNy  mNNs        .NNN:    dNNs  :NNm     :NNN- mNNNNNNNNNNN
10 yNNm/` .+NNNs  +NNN      hNNy  sNNm/` `/mNNy  sNNm+. `.-  `mNNh:.-oNNNs  :NNNs. `:hNNd` yNNd:`  `/.
11 `sNNNNNNNNNNs  +NNN      hNNy   omNNNNNNmNNy   +mNNNNNNN+  -dNNNNNNmNNs  :NNmNNNNNNNy.   omNNNmmNNd`
12   `:+o+/-mNN+  -++/      :++:    `:+oo/-`++:     -/+o+/-     -/oo+-`++:  .++-`/+o+/.       -/++++:`
13   smyoooymNNh`
14   .oydmNNmds:
15 
16 
17 https://gridcube.com has a unique approach to deploying Blockchain technology. Instead of focusing on the blockchain itself,
18 our breakthrough was discovering that the underlying infrastructure is just as important. Therefore,
19 we developed a “Smart Cloud Manager”, a middleware software capable of deploying a blockchain network efficiently,
20 fast, and optimized for cost. Gridcube Platform Token (GPT) Enables "Coding is Mining" Loyalty and Reward Program
21 https://ito.gridcube.com. Also works as a way of Payment for Gridcube Services.
22 
23 03 October 2018 v4.0*/
24 
25 pragma solidity ^0.4.18;
26 
27 // ----------------------------------------------------------------------------
28 // 'Gridcube' token contract
29 //
30 // Deployed to : 0X1E867D04FBB7434093071237813DF00B3DF6EE77
31 // Symbol      : GPT
32 // Name        : Gridcube Platform Token
33 // Total supply: 30 000 000
34 // Decimals    : 18
35 //
36 //
37 //
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
70     function currentSupply() public constant returns (uint);
71     function balanceOf(address tokenOwner) public constant returns (uint balance);
72     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
73     function transfer(address to, uint tokens) public returns (bool success);
74     function approve(address spender, uint tokens) public returns (bool success);
75     function transferFrom(address from, address to, uint tokens) public returns (bool success);
76 
77     event Transfer(address indexed from, address indexed to, uint tokens);
78     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // Contract function to receive approval and execute function in one call
84 //
85 // Borrowed from MiniMeToken
86 // ----------------------------------------------------------------------------
87 contract ApproveAndCallFallBack {
88     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // Owned contract
94 // ----------------------------------------------------------------------------
95 contract Owned {
96     address public owner;
97     address public newOwner;
98 
99     event OwnershipTransferred(address indexed _from, address indexed _to);
100 
101     function Owned() public {
102         owner = msg.sender;
103     }
104 
105     modifier onlyOwner {
106         require(msg.sender == owner);
107         _;
108     }
109 
110     function transferOwnership(address _newOwner) public onlyOwner {
111         newOwner = _newOwner;
112     }
113     function acceptOwnership() public {
114         require(msg.sender == newOwner);
115         OwnershipTransferred(owner, newOwner);
116         owner = newOwner;
117         newOwner = address(0);
118     }
119 }
120 
121 
122 // ----------------------------------------------------------------------------
123 // ERC20 Token, with the addition of symbol, name and decimals and assisted
124 // token transfers
125 // ----------------------------------------------------------------------------
126 contract GridcubePlatformToken is ERC20Interface, Owned, SafeMath {
127     string public symbol;
128     string public  name;
129     uint8 public decimals;
130     uint public _totalSupply;
131     uint public _currentSupply;
132     uint public startDate;
133     uint public bonusEnds;
134     uint public endDate;
135 
136     mapping(address => uint) balances;
137     mapping(address => mapping(address => uint)) allowed;
138 
139 
140     // ------------------------------------------------------------------------
141     // Constructor
142     // ------------------------------------------------------------------------
143     function GridcubePlatformToken() public {
144         symbol = "GPT";
145         name = "Gridcube Platform Token";
146         decimals = 18;
147         bonusEnds = now + 2 weeks;
148         endDate = now + 12 weeks;
149         _totalSupply = 30000000000000000000000000;
150         address OwnerAdd = 0xb917cd85b61813ac1cd29ba0a8c37e0cd9f11162;
151         uint256 CommunityTokens = 10000000000000000000000000;
152         uint256 ProjectTokens = 10000000000000000000000000;
153         uint256 HoldTokens = CommunityTokens + ProjectTokens;
154         uint256 SaleTokens = safeSub(_totalSupply, HoldTokens);
155         balances[OwnerAdd] = HoldTokens;
156         Transfer(address(0), OwnerAdd, HoldTokens);
157         _currentSupply = SaleTokens;
158 
159       }
160 
161 
162     // ------------------------------------------------------------------------
163     // Total supply
164     // ------------------------------------------------------------------------
165     function totalSupply() public constant returns (uint) {
166         return _totalSupply;
167     }
168 
169     // ------------------------------------------------------------------------
170     // Current supply
171     // ------------------------------------------------------------------------
172     function currentSupply() public constant returns (uint) {
173         return _currentSupply  - balances[address(0)];
174     }
175 
176     // ------------------------------------------------------------------------
177     // Get the token balance for account `tokenOwner`
178     // ------------------------------------------------------------------------
179     function balanceOf(address tokenOwner) public constant returns (uint balance) {
180         return balances[tokenOwner];
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Transfer the balance from token owner's account to `to` account
186     // - Owner's account must have sufficient balance to transfer
187     // - 0 value transfers are allowed
188     // ------------------------------------------------------------------------
189     function transfer(address to, uint tokens) public returns (bool success) {
190         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
191         balances[to] = safeAdd(balances[to], tokens);
192         Transfer(msg.sender, to, tokens);
193         return true;
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Token owner can approve for `spender` to transferFrom(...) `tokens`
199     // from the token owner's account
200     //
201     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
202     // recommends that there are no checks for the approval double-spend attack
203     // as this should be implemented in user interfaces
204     // ------------------------------------------------------------------------
205     function approve(address spender, uint tokens) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         Approval(msg.sender, spender, tokens);
208         return true;
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Transfer `tokens` from the `from` account to the `to` account
214     //
215     // The calling account must already have sufficient tokens approve(...)-d
216     // for spending from the `from` account and
217     // - From account must have sufficient balance to transfer
218     // - Spender must have sufficient allowance to transfer
219     // - 0 value transfers are allowed
220     // ------------------------------------------------------------------------
221     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
222         balances[from] = safeSub(balances[from], tokens);
223         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
224         balances[to] = safeAdd(balances[to], tokens);
225         Transfer(from, to, tokens);
226         return true;
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Returns the amount of tokens approved by the owner that can be
232     // transferred to the spender's account
233     // ------------------------------------------------------------------------
234     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
235         return allowed[tokenOwner][spender];
236     }
237 
238 
239     // ------------------------------------------------------------------------
240     // Token owner can approve for `spender` to transferFrom(...) `tokens`
241     // from the token owner's account. The `spender` contract function
242     // `receiveApproval(...)` is then executed
243     // ------------------------------------------------------------------------
244     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
245         allowed[msg.sender][spender] = tokens;
246         Approval(msg.sender, spender, tokens);
247         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
248         return true;
249     }
250 
251     // ------------------------------------------------------------------------
252     // 180 GRIDCUBE Tokens per 1 ETH
253     // ------------------------------------------------------------------------
254     function () public payable {
255         require(now >= startDate && now <= endDate);
256         uint tokens;
257         if (now <= bonusEnds) {
258             tokens = msg.value * 200;
259         } else {
260             tokens = msg.value * 180;
261         }
262         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
263         _currentSupply = safeSub(_currentSupply, tokens);
264         Transfer(address(0), msg.sender, tokens);
265         owner.transfer(msg.value);
266     }
267 
268 
269 
270     // ------------------------------------------------------------------------
271     // Owner can transfer out any accidentally sent ERC20 tokens
272     // ------------------------------------------------------------------------
273     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
274         return ERC20Interface(tokenAddress).transfer(owner, tokens);
275     }
276 }