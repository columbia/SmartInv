1 /*28 September 2018 v2.0
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
20 fast, and optimized for cost. Gridcube Platform Token (GPT) Enables "Coding is Mining" Loyalty and Reward Program.
21 Also works as a way of Payment for Gridcube Services. https://ito.gridcube.com
22 
23 28 September 2018 v2.0*/
24 
25 pragma solidity ^0.4.25;
26 
27 // ----------------------------------------------------------------------------
28 // 'Gridcube' CROWDSALE token contract
29 //
30 // Deployed to : 0X69A50B4989E00C1278A3135F60B4CCB49A97C465
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
100     constructor() public {
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
114         emit OwnershipTransferred(owner, newOwner);
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
125 contract GridcubePlatformToken is ERC20Interface, Owned, SafeMath {
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
141     constructor() public {
142         symbol = "GPT";
143         name = "Gridcube Platform Token";
144         decimals = 18;
145         bonusEnds = now + 2 weeks;
146         endDate = now + 12 weeks;
147         _totalSupply = 30000000000000000000000000;
148       }
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
175         emit Transfer(msg.sender, to, tokens);
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
190         emit Approval(msg.sender, spender, tokens);
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
208         emit Transfer(from, to, tokens);
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
229         emit Approval(msg.sender, spender, tokens);
230         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
231         return true;
232     }
233 
234     // ------------------------------------------------------------------------
235     // 200 GRIDCUBE Tokens per 1 ETH
236     // ------------------------------------------------------------------------
237     function () public payable {
238         require(now >= startDate && now <= endDate);
239         uint tokens;
240         if (now <= bonusEnds) {
241             tokens = msg.value * 220;
242         } else {
243             tokens = msg.value * 200;
244         }
245         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
246         _totalSupply = safeSub(_totalSupply, tokens);
247         emit Transfer(address(0), msg.sender, tokens);
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