1 pragma solidity ^0.4.16;
2 
3 
4 // ----------------------------------------------------------------------------
5 // contract WhiteListAccess
6 // ----------------------------------------------------------------------------
7 contract WhiteListAccess {
8     
9     function WhiteListAccess() public {
10         owner = msg.sender;
11         whitelist[owner] = true;
12         whitelist[address(this)] = true;
13     }
14     
15     address public owner;
16     mapping (address => bool) whitelist;
17 
18     modifier onlyOwner {require(msg.sender == owner); _;}
19     modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}
20 
21     function addToWhiteList(address trusted) public onlyOwner() {
22         whitelist[trusted] = true;
23     }
24 
25     function removeFromWhiteList(address untrusted) public onlyOwner() {
26         whitelist[untrusted] = false;
27     }
28 
29 }
30 // ----------------------------------------------------------------------------
31 // Safe maths
32 // ----------------------------------------------------------------------------
33 library SafeMath {
34     function add(uint a, uint b) internal pure returns (uint c) {
35         c = a + b;
36         require(c >= a);
37     }
38     function sub(uint a, uint b) internal pure returns (uint c) {
39         require(b <= a);
40         c = a - b;
41     }
42     function mul(uint a, uint b) internal pure returns (uint c) {
43         c = a * b;
44         require(a == 0 || c / a == b);
45     }
46     function div(uint a, uint b) internal pure returns (uint c) {
47         require(b > 0);
48         c = a / b;
49     }
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // ERC Token Standard #20 Interface
55 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
56 // ----------------------------------------------------------------------------
57 contract ERC20Interface {
58     function totalSupply() public constant returns (uint);
59     function balanceOf(address tokenOwner) public constant returns (uint balance);
60     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
61     function transfer(address to, uint tokens) public returns (bool success);
62     function approve(address spender, uint tokens) public returns (bool success);
63     function transferFrom(address from, address to, uint tokens) public returns (bool success);
64 
65     event Transfer(address indexed from, address indexed to, uint tokens);
66     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // Contract function to receive approval and execute function in one call
72 //
73 // Borrowed from MiniMeToken
74 // ----------------------------------------------------------------------------
75 contract ApproveAndCallFallBack {
76     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
77 }
78 
79 
80 
81 // ----------------------------------------------------------------------------
82 // CNT_Common contract
83 // ----------------------------------------------------------------------------
84 contract CNT_Common is WhiteListAccess {
85     string  public name;
86     
87     function CNT_Common() public {  }
88 
89     // Deployment
90     address public SALE_address;   // CNT_Crowdsale
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and an
96 // initial fixed supply
97 // ----------------------------------------------------------------------------
98 contract Token is ERC20Interface, CNT_Common {
99     using SafeMath for uint;
100 
101     bool    public   freezed;
102     bool    public   initialized;
103     uint8   public   decimals;
104     uint    public   totSupply;
105     string  public   symbol;
106 
107     mapping(address => uint) public balances;
108     mapping(address => mapping(address => uint)) public allowed;
109 
110     address public ICO_PRE_SALE = address(0x1);
111     address public ICO_TEAM = address(0x2);
112     address public ICO_PROMO_REWARDS = address(0x3);
113     address public ICO_EOS_AIRDROP = address(0x4);
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     
119     function Token(uint8 _decimals, uint _thousands, string _name, string _sym) public {
120         owner = msg.sender;
121         symbol = _sym;
122         name = _name;
123         decimals = _decimals;
124         totSupply = _thousands * 10**3 * 10**uint(decimals);
125     }
126 
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public constant returns (uint) {
131         return totSupply;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public constant returns (uint balance) {
139         return balances[tokenOwner];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transfer(address to, uint tokens) public returns (bool success) {
149         require(!freezed);
150         require(initialized);
151         balances[msg.sender] = balances[msg.sender].sub(tokens);
152         balances[to] = balances[to].add(tokens);
153         Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces 
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172     function desapprove(address spender) public returns (bool success) {
173         allowed[msg.sender][spender] = 0;
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Transfer `tokens` from the `from` account to the `to` account
180     // 
181     // The calling account must already have sufficient tokens approve(...)-d
182     // for spending from the `from` account and
183     // - From account must have sufficient balance to transfer
184     // - Spender must have sufficient allowance to transfer
185     // - 0 value transfers are allowed
186     // ------------------------------------------------------------------------
187     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
188         require(!freezed);
189         require(initialized);
190         balances[from] = balances[from].sub(tokens);
191         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
192         balances[to] = balances[to].add(tokens);
193         Transfer(from, to, tokens);
194         return true;
195     }
196 
197 
198     // ------------------------------------------------------------------------
199     // Returns the amount of tokens approved by the owner that can be
200     // transferred to the spender's account
201     // ------------------------------------------------------------------------
202     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
203         return allowed[tokenOwner][spender];
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Token owner can approve for `spender` to transferFrom(...) `tokens`
209     // from the token owner's account. The `spender` contract function
210     // `receiveApproval(...)` is then executed
211     // ------------------------------------------------------------------------
212     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
213         allowed[msg.sender][spender] = tokens;
214         Approval(msg.sender, spender, tokens);
215         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
216         return true;
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Don't accept ETH
222     // ------------------------------------------------------------------------
223     function () public payable {
224         revert();
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Owner can transfer out any accidentally sent ERC20 tokens
230     // ------------------------------------------------------------------------
231     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
232         return ERC20Interface(tokenAddress).transfer(owner, tokens);
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // 
238     function init(address _sale) public {
239         require(!initialized);
240         // we need to know the CNTTokenSale and NewRichOnTheBlock Contract address before distribute to them
241         SALE_address = _sale;
242         whitelist[SALE_address] = true;
243         initialized = true;
244         freezed = true;
245     }
246 
247     function ico_distribution(address to, uint tokens) public onlyWhitelisted() {
248         require(initialized);
249         balances[ICO_PRE_SALE] = balances[ICO_PRE_SALE].sub(tokens);
250         balances[to] = balances[to].add(tokens);
251         Transfer(ICO_PRE_SALE, to, tokens);
252     }
253 
254     function ico_promo_reward(address to, uint tokens) public onlyWhitelisted() {
255         require(initialized);
256         balances[ICO_PROMO_REWARDS] = balances[ICO_PROMO_REWARDS].sub(tokens);
257         balances[to] = balances[to].add(tokens);
258         Transfer(ICO_PROMO_REWARDS, to, tokens);
259     }
260 
261     function balanceOfMine() constant public returns (uint) {
262         return balances[msg.sender];
263     }
264 
265     function rename(string _name) public onlyOwner() {
266         name = _name;
267     }    
268 
269     function unfreeze() public onlyOwner() {
270         freezed = false;
271     }
272 
273     function refreeze() public onlyOwner() {
274         freezed = true;
275     }
276     
277 }
278 
279 contract CNT_Token is Token(18, 500000, "Chip", "CNT") {
280     function CNT_Token() public {
281         uint _millons = 10**6 * 10**18;
282         balances[ICO_PRE_SALE]       = 300 * _millons; // 60% - PRE-SALE / DA-ICO
283         balances[ICO_TEAM]           =  90 * _millons; // 18% - reserved for the TEAM
284         balances[ICO_PROMO_REWARDS]  =  10 * _millons; //  2% - project promotion (Steem followers rewards and influencers sponsorship)
285         balances[ICO_EOS_AIRDROP]    = 100 * _millons; // 20% - AIRDROP over EOS token holders
286         balances[address(this)]      = 0;
287         Transfer(address(this), ICO_PRE_SALE, balances[ICO_PRE_SALE]);
288         Transfer(address(this), ICO_TEAM, balances[ICO_TEAM]);
289         Transfer(address(this), ICO_PROMO_REWARDS, balances[ICO_PROMO_REWARDS]);
290         Transfer(address(this), ICO_EOS_AIRDROP, balances[ICO_EOS_AIRDROP]);
291     }
292 }
293 
294 contract BGB_Token is Token(18, 500000, "BG-Coin", "BGB") {
295     function BGB_Token() public {
296         uint _millons = 10**6 * 10**18;
297         balances[ICO_PRE_SALE]      = 250 * _millons; // 50% - PRE-SALE
298         balances[ICO_TEAM]          = 200 * _millons; // 40% - reserved for the TEAM
299         balances[ICO_PROMO_REWARDS] =  50 * _millons; // 10% - project promotion (Steem followers rewards and influencers sponsorship)
300         balances[address(this)] =   0;
301         Transfer(address(this), ICO_PRE_SALE, balances[ICO_PRE_SALE]);
302         Transfer(address(this), ICO_TEAM, balances[ICO_TEAM]);
303         Transfer(address(this), ICO_PROMO_REWARDS, balances[ICO_PROMO_REWARDS]);
304     }
305 }
306 
307 contract VPE_Token is Token(18, 1000, "Vapaee", "VPE") {
308     function VPE_Token() public {
309         uint _thousands = 10**3 * 10**18;
310         balances[ICO_PRE_SALE]  = 500 * _thousands; // 50% - PRE-SALE
311         balances[ICO_TEAM]      = 500 * _thousands; // 50% - reserved for the TEAM
312         balances[address(this)] =   0;
313         Transfer(address(this), ICO_PRE_SALE, balances[ICO_PRE_SALE]);
314         Transfer(address(this), ICO_TEAM, balances[ICO_TEAM]);
315     }
316 }
317 
318 contract GVPE_Token is Token(18, 100, "Golden Vapaee", "GVPE") {
319     function GVPE_Token() public {
320         uint _thousands = 10**3 * 10**18;
321         balances[ICO_PRE_SALE]  = 100 * _thousands; // 100% - PRE-SALE
322         balances[address(this)] = 0;
323         Transfer(address(this), ICO_PRE_SALE, balances[ICO_PRE_SALE]);
324     }
325 }