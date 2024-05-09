1 /*
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
17 gridcube.com has a unique approach to deploying Blockchain technology. Instead of focusing on the blockchain itself,
18 our breakthrough was discovering that the underlying infrastructure is just as important. Therefore,
19 we developed a “Smart Cloud Manager”, a middleware software capable of deploying a blockchain network efficiently,
20 fast, and optimized for cost. Gridcube Platform Token (GPT) Enables "Coding is Mining" Loyalty and Reward Program.
21 Also works as a way of Payment for Gridcube Services.
22 */
23 pragma solidity ^0.4.18;
24 
25 // ----------------------------------------------------------------------------
26 // 'Gridcube' CROWDSALE token contract
27 //
28 // Deployed to : 0XE600DABD95D181FE5F6EEE1B079C2B64AA5FBCC7
29 // Symbol      : GPT
30 // Name        : Gridcube Platform Token
31 // Total supply: 30 000 000
32 // Decimals    : 18
33 //
34 //
35 //
36 // ----------------------------------------------------------------------------
37 
38 
39 // ----------------------------------------------------------------------------
40 // Safe maths
41 // ----------------------------------------------------------------------------
42 contract SafeMath {
43     function safeAdd(uint a, uint b) internal pure returns (uint c) {
44         c = a + b;
45         require(c >= a);
46     }
47     function safeSub(uint a, uint b) internal pure returns (uint c) {
48         require(b <= a);
49         c = a - b;
50     }
51     function safeMul(uint a, uint b) internal pure returns (uint c) {
52         c = a * b;
53         require(a == 0 || c / a == b);
54     }
55     function safeDiv(uint a, uint b) internal pure returns (uint c) {
56         require(b > 0);
57         c = a / b;
58     }
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // ERC Token Standard #20 Interface
64 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
65 // ----------------------------------------------------------------------------
66 contract ERC20Interface {
67     function totalSupply() public constant returns (uint);
68     function balanceOf(address tokenOwner) public constant returns (uint balance);
69     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
70     function transfer(address to, uint tokens) public returns (bool success);
71     function approve(address spender, uint tokens) public returns (bool success);
72     function transferFrom(address from, address to, uint tokens) public returns (bool success);
73 
74     event Transfer(address indexed from, address indexed to, uint tokens);
75     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // Contract function to receive approval and execute function in one call
81 //
82 // Borrowed from MiniMeToken
83 // ----------------------------------------------------------------------------
84 contract ApproveAndCallFallBack {
85     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // Owned contract
91 // ----------------------------------------------------------------------------
92 contract Owned {
93     address public owner;
94     address public newOwner;
95 
96     event OwnershipTransferred(address indexed _from, address indexed _to);
97 
98     function Owned() public {
99         owner = msg.sender;
100     }
101 
102     modifier onlyOwner {
103         require(msg.sender == owner);
104         _;
105     }
106 
107     function transferOwnership(address _newOwner) public onlyOwner {
108         newOwner = _newOwner;
109     }
110     function acceptOwnership() public {
111         require(msg.sender == newOwner);
112         OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114         newOwner = address(0);
115     }
116 }
117 
118 
119 // ----------------------------------------------------------------------------
120 // ERC20 Token, with the addition of symbol, name and decimals and assisted
121 // token transfers
122 // ----------------------------------------------------------------------------
123 contract GridcubePlatformToken is ERC20Interface, Owned, SafeMath {
124     string public symbol;
125     string public  name;
126     uint8 public decimals;
127     uint public _totalSupply;
128     uint public startDate;
129     uint public bonusEnds;
130     uint public endDate;
131 
132     mapping(address => uint) balances;
133     mapping(address => mapping(address => uint)) allowed;
134 
135 
136     // ------------------------------------------------------------------------
137     // Constructor
138     // ------------------------------------------------------------------------
139     function GridcubePlatformToken() public {
140         symbol = "GPT";
141         name = "Gridcube Platform Token";
142         decimals = 18;
143         bonusEnds = now + 2 weeks;
144         endDate = now + 12 weeks;
145         _totalSupply = 30000000000000000000000000;
146       }
147 
148 
149     // ------------------------------------------------------------------------
150     // Total supply
151     // ------------------------------------------------------------------------
152     function totalSupply() public constant returns (uint) {
153         return _totalSupply  - balances[address(0)];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Get the token balance for account `tokenOwner`
159     // ------------------------------------------------------------------------
160     function balanceOf(address tokenOwner) public constant returns (uint balance) {
161         return balances[tokenOwner];
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer the balance from token owner's account to `to` account
167     // - Owner's account must have sufficient balance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transfer(address to, uint tokens) public returns (bool success) {
171         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         Transfer(msg.sender, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Token owner can approve for `spender` to transferFrom(...) `tokens`
180     // from the token owner's account
181     //
182     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
183     // recommends that there are no checks for the approval double-spend attack
184     // as this should be implemented in user interfaces
185     // ------------------------------------------------------------------------
186     function approve(address spender, uint tokens) public returns (bool success) {
187         allowed[msg.sender][spender] = tokens;
188         Approval(msg.sender, spender, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Transfer `tokens` from the `from` account to the `to` account
195     //
196     // The calling account must already have sufficient tokens approve(...)-d
197     // for spending from the `from` account and
198     // - From account must have sufficient balance to transfer
199     // - Spender must have sufficient allowance to transfer
200     // - 0 value transfers are allowed
201     // ------------------------------------------------------------------------
202     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
203         balances[from] = safeSub(balances[from], tokens);
204         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
205         balances[to] = safeAdd(balances[to], tokens);
206         Transfer(from, to, tokens);
207         return true;
208     }
209 
210 
211     // ------------------------------------------------------------------------
212     // Returns the amount of tokens approved by the owner that can be
213     // transferred to the spender's account
214     // ------------------------------------------------------------------------
215     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
216         return allowed[tokenOwner][spender];
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Token owner can approve for `spender` to transferFrom(...) `tokens`
222     // from the token owner's account. The `spender` contract function
223     // `receiveApproval(...)` is then executed
224     // ------------------------------------------------------------------------
225     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
226         allowed[msg.sender][spender] = tokens;
227         Approval(msg.sender, spender, tokens);
228         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
229         return true;
230     }
231 
232     // ------------------------------------------------------------------------
233     // 180 GRIDCUBE Tokens per 1 ETH
234     // ------------------------------------------------------------------------
235     function () public payable {
236         require(now >= startDate && now <= endDate);
237         uint tokens;
238         if (now <= bonusEnds) {
239             tokens = msg.value * 200;
240         } else {
241             tokens = msg.value * 180;
242         }
243         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
244         _totalSupply = safeSub(_totalSupply, tokens);
245         Transfer(address(0), msg.sender, tokens);
246         owner.transfer(msg.value);
247     }
248 
249 
250 
251     // ------------------------------------------------------------------------
252     // Owner can transfer out any accidentally sent ERC20 tokens
253     // ------------------------------------------------------------------------
254     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
255         return ERC20Interface(tokenAddress).transfer(owner, tokens);
256     }
257 }