1 pragma solidity ^0.4.10;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Important information
6 //
7 // For details about the Sikoba continuous token sale, and in particular to find 
8 // out about risks and limitations, please visit:
9 //
10 // http://www.sikoba.com/www/presale/index.html
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 //
17 // Owned contract
18 //
19 // ----------------------------------------------------------------------------
20 contract Owned {
21     address public owner;
22     address public newOwner;
23     event OwnershipTransferred(address indexed _from, address indexed _to);
24 
25     function Owned() {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         if (msg.sender != owner) throw;
31         _;
32     }
33 
34     function transferOwnership(address _newOwner) onlyOwner {
35         newOwner = _newOwner;
36     }
37  
38     function acceptOwnership() {
39         if (msg.sender != newOwner) throw;
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 }
44 
45 
46 // ----------------------------------------------------------------------------
47 //
48 // ERC Token Standard #20 Interface
49 // https://github.com/ethereum/EIPs/issues/20
50 //
51 // ----------------------------------------------------------------------------
52 contract ERC20Interface {
53     function totalSupply() constant returns (uint256 totalSupply);
54     function balanceOf(address _owner) constant returns (uint256 balance);
55     function transfer(address _to, uint256 _value) returns (bool success);
56     function transferFrom(address _from, address _to, uint256 _value) 
57         returns (bool success);
58     function approve(address _spender, uint256 _value) returns (bool success);
59     function allowance(address _owner, address _spender) constant 
60         returns (uint256 remaining);
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, 
63         uint256 _value);
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 //
69 // ERC Token Standard #20
70 //
71 // ----------------------------------------------------------------------------
72 contract ERC20Token is Owned, ERC20Interface {
73     uint256 _totalSupply = 0;
74 
75     // ------------------------------------------------------------------------
76     // Balances for each account
77     // ------------------------------------------------------------------------
78     mapping(address => uint256) balances;
79 
80     // ------------------------------------------------------------------------
81     // Owner of account approves the transfer of an amount to another account
82     // ------------------------------------------------------------------------
83     mapping(address => mapping (address => uint256)) allowed;
84 
85     // ------------------------------------------------------------------------
86     // Get the total token supply
87     // ------------------------------------------------------------------------
88     function totalSupply() constant returns (uint256 totalSupply) {
89         totalSupply = _totalSupply;
90     }
91 
92     // ------------------------------------------------------------------------
93     // Get the account balance of another account with address _owner
94     // ------------------------------------------------------------------------
95     function balanceOf(address _owner) constant returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     // ------------------------------------------------------------------------
100     // Transfer the balance from owner's account to another account
101     // ------------------------------------------------------------------------
102     function transfer(
103         address _to,
104         uint256 _amount
105     ) returns (bool success) {
106         if (balances[msg.sender] >= _amount             // User has balance
107             && _amount > 0                              // Non-zero transfer
108             && balances[_to] + _amount > balances[_to]  // Overflow check
109         ) {
110             balances[msg.sender] -= _amount;
111             balances[_to] += _amount;
112             Transfer(msg.sender, _to, _amount);
113             return true;
114         } else {
115             return false;
116         }
117     }
118 
119     // ------------------------------------------------------------------------
120     // Allow _spender to withdraw from your account, multiple times, up to the
121     // _value amount. If this function is called again it overwrites the
122     // current allowance with _value.
123     // ------------------------------------------------------------------------
124     function approve(
125         address _spender,
126         uint256 _amount
127     ) returns (bool success) {
128         allowed[msg.sender][_spender] = _amount;
129         Approval(msg.sender, _spender, _amount);
130         return true;
131     }
132 
133     // ------------------------------------------------------------------------
134     // Spender of tokens transfer an amount of tokens from the token owner's
135     // balance to another account. The owner of the tokens must already
136     // have approve(...)-d this transfer
137     // ------------------------------------------------------------------------
138     function transferFrom(
139         address _from,
140         address _to,
141         uint256 _amount
142     ) returns (bool success) {
143         if (balances[_from] >= _amount                  // From a/c has balance
144             && allowed[_from][msg.sender] >= _amount    // Transfer approved
145             && _amount > 0                              // Non-zero transfer
146             && balances[_to] + _amount > balances[_to]  // Overflow check
147         ) {
148             balances[_from] -= _amount;
149             allowed[_from][msg.sender] -= _amount;
150             balances[_to] += _amount;
151             Transfer(_from, _to, _amount);
152             return true;
153         } else {
154             return false;
155         }
156     }
157 
158     // ------------------------------------------------------------------------
159     // Returns the amount of tokens approved by the owner that can be
160     // transferred to the spender's account
161     // ------------------------------------------------------------------------
162     function allowance(
163         address _owner, 
164         address _spender
165     ) constant returns (uint256 remaining) {
166         return allowed[_owner][_spender];
167     }
168 }
169 
170 
171 // ----------------------------------------------------------------------------
172 //
173 // Accept funds and mint tokens
174 //
175 // ----------------------------------------------------------------------------
176 contract SikobaContinuousSale is ERC20Token {
177 
178     // ------------------------------------------------------------------------
179     // Token information
180     // ------------------------------------------------------------------------
181     string public constant symbol = "SKO1";
182     string public constant name = "Sikoba Continuous Sale";
183     uint8 public constant decimals = 18;
184 
185     // Thursday, 01-Jun-17 00:00:00 UTC
186     uint256 public constant START_DATE = 1496275200;
187 
188     // Tuesday, 31-Oct-17 23:59:59 UTC
189     uint256 public constant END_DATE = 1509494399;
190 
191     // Number of SKO1 units per ETH at beginning and end
192     uint256 public constant START_SKO1_UNITS = 1650;
193     uint256 public constant END_SKO1_UNITS = 1200;
194 
195     // Minimum contribution amount is 0.01 ETH
196     uint256 public constant MIN_CONTRIBUTION = 10**16;
197 
198     // One day soft time limit if max contribution reached
199     uint256 public constant ONE_DAY = 24*60*60;
200 
201     // Max funding and soft end date
202     uint256 public constant MAX_USD_FUNDING = 400000;
203     uint256 public totalUsdFunding;
204     bool public maxUsdFundingReached = false;
205     uint256 public usdPerHundredEth;
206     uint256 public softEndDate = END_DATE;
207 
208     // Ethers contributed and withdrawn
209     uint256 public ethersContributed = 0;
210 
211     // Status variables
212     bool public mintingCompleted = false;
213     bool public fundingPaused = false;
214 
215     // Multiplication factor for extra integer multiplication precision
216     uint256 public constant MULT_FACTOR = 10**18;
217 
218     // ------------------------------------------------------------------------
219     // Events
220     // ------------------------------------------------------------------------
221     event UsdRateSet(uint256 _usdPerHundredEth);
222     event TokensBought(address indexed buyer, uint256 ethers, uint256 tokens, 
223           uint256 newTotalSupply, uint256 unitsPerEth);
224 
225     // ------------------------------------------------------------------------
226     // Constructor
227     // ------------------------------------------------------------------------
228     function SikobaContinuousSale(uint256 _usdPerHundredEth) {
229         setUsdPerHundredEth(_usdPerHundredEth);
230     }
231 
232     // ------------------------------------------------------------------------
233     // Owner sets the USD rate per 100 ETH - used to determine the funding cap
234     // If coinmarketcap $131.14 then set 13114
235     // ------------------------------------------------------------------------
236     function setUsdPerHundredEth(uint256 _usdPerHundredEth) onlyOwner {
237         usdPerHundredEth = _usdPerHundredEth;
238         UsdRateSet(_usdPerHundredEth);
239     }
240 
241     // ------------------------------------------------------------------------
242     // Calculate the number of tokens per ETH contributed
243     // Linear (START_DATE, START_SKO1_UNITS) -> (END_DATE, END_SKO1_UNITS)
244     // ------------------------------------------------------------------------
245     function unitsPerEth() constant returns (uint256) {
246         return unitsPerEthAt(now);
247     }
248 
249     function unitsPerEthAt(uint256 at) constant returns (uint256) {
250         if (at < START_DATE) {
251             return START_SKO1_UNITS * MULT_FACTOR;
252         } else if (at > END_DATE) {
253             return END_SKO1_UNITS * MULT_FACTOR;
254         } else {
255             return START_SKO1_UNITS * MULT_FACTOR
256                 - ((START_SKO1_UNITS - END_SKO1_UNITS) * MULT_FACTOR 
257                    * (at - START_DATE)) / (END_DATE - START_DATE);
258         }
259     }
260 
261     // ------------------------------------------------------------------------
262     // Buy tokens from the contract
263     // ------------------------------------------------------------------------
264     function () payable {
265         buyTokens();
266     }
267 
268     function buyTokens() payable {
269         // Check conditions
270         if (fundingPaused) throw;
271         if (now < START_DATE) throw;
272         if (now > END_DATE) throw;
273         if (now > softEndDate) throw;
274         if (msg.value < MIN_CONTRIBUTION) throw;
275 
276         // Issue tokens
277         uint256 _unitsPerEth = unitsPerEth();
278         uint256 tokens = msg.value * _unitsPerEth / MULT_FACTOR;
279         _totalSupply += tokens;
280         balances[msg.sender] += tokens;
281         Transfer(0x0, msg.sender, tokens);
282 
283         // Approximative funding in USD
284         totalUsdFunding += msg.value * usdPerHundredEth / 10**20;
285         if (!maxUsdFundingReached && totalUsdFunding > MAX_USD_FUNDING) {
286             softEndDate = now + ONE_DAY;
287             maxUsdFundingReached = true;
288         }
289 
290         ethersContributed += msg.value;
291         TokensBought(msg.sender, msg.value, tokens, _totalSupply, _unitsPerEth);
292 
293         // Send balance to owner
294         if (!owner.send(this.balance)) throw;
295     }
296 
297     // ------------------------------------------------------------------------
298     // Pause and restart funding
299     // ------------------------------------------------------------------------
300     function pause() external onlyOwner {
301         fundingPaused = true;
302     }
303 
304     function restart() external onlyOwner {
305         fundingPaused = false;
306     }
307 
308 
309     // ------------------------------------------------------------------------
310     // Owner can mint tokens for contributions made outside the ETH contributed
311     // to this token contract. This can only occur until mintingCompleted is
312     // true
313     // ------------------------------------------------------------------------
314     function mint(address participant, uint256 tokens) onlyOwner {
315         if (mintingCompleted) throw;
316         balances[participant] += tokens;
317         _totalSupply += tokens;
318         Transfer(0x0, participant, tokens);
319     }
320 
321     function setMintingCompleted() onlyOwner {
322         mintingCompleted = true;
323     }
324 
325     // ------------------------------------------------------------------------
326     // Transfer out any accidentally sent ERC20 tokens
327     // ------------------------------------------------------------------------
328     function transferAnyERC20Token(
329         address tokenAddress, 
330         uint256 amount
331     ) onlyOwner returns (bool success) {
332         return ERC20Interface(tokenAddress).transfer(owner, amount);
333     }
334 }