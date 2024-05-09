1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4 address public owner;
5 
6 
7 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 function Ownable() public {
10 owner = msg.sender;
11 }
12 
13 modifier onlyOwner() {
14 require(msg.sender == owner);
15 _;
16 }
17 
18 function transferOwnership(address newOwner) public onlyOwner {
19 require(newOwner != address(0));
20 OwnershipTransferred(owner, newOwner);
21 owner = newOwner;
22 }
23 }
24 
25 contract Pausable is Ownable {
26 event Pause();
27 event Unpause();
28 
29 bool public paused = false;
30 
31 modifier whenNotPaused() {
32 require(!paused);
33 _;
34 }
35 
36 modifier whenPaused() {
37 require(paused);
38 _;
39 }
40 
41 function pause() onlyOwner whenNotPaused public {
42 paused = true;
43 Pause();
44 }
45 
46 function unpause() onlyOwner whenPaused public {
47 paused = false;
48 Unpause();
49 }
50 }
51 
52 contract ERC20Basic {
53 uint256 public totalSupply;
54 function balanceOf(address who) public view returns (uint256);
55 function transfer(address to, uint256 value) public returns (bool);
56 event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 
60 contract ERC20 is ERC20Basic {
61 function allowance(address owner, address spender) public view returns (uint256);
62 function transferFrom(address from, address to, uint256 value) public returns (bool);
63 function approve(address spender, uint256 value) public returns (bool);
64 event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 library SafeMath {
68 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69 if (a == 0) {
70 return 0;
71 }
72 uint256 c = a * b;
73 assert(c / a == b);
74 return c;
75 }
76 
77 function div(uint256 a, uint256 b) internal pure returns (uint256) {
78 uint256 c = a / b;
79 return c;
80 }
81 
82 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83 assert(b <= a);
84 return a - b;
85 }
86 
87 function add(uint256 a, uint256 b) internal pure returns (uint256) {
88 uint256 c = a + b;
89 assert(c >= a);
90 return c;
91 }
92 }
93 
94 
95 contract BasicToken is ERC20Basic {
96 using SafeMath for uint256;
97 
98 mapping(address => uint256) balances;
99 
100 function transfer(address _to, uint256 _value) public returns (bool) {
101 require(_to != address(0));
102 require(_value <= balances[msg.sender]);
103 
104 balances[msg.sender] = balances[msg.sender].sub(_value);
105 balances[_to] = balances[_to].add(_value);
106 Transfer(msg.sender, _to, _value);
107 return true;
108 }
109 
110 function balanceOf(address _owner) public view returns (uint256 balance) {
111 return balances[_owner];
112 }
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117 mapping (address => mapping (address => uint256)) internal allowed;
118 
119 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120 require(_to != address(0));
121 require(_value <= balances[_from]);
122 require(_value <= allowed[_from][msg.sender]);
123 
124 balances[_from] = balances[_from].sub(_value);
125 balances[_to] = balances[_to].add(_value);
126 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127 Transfer(_from, _to, _value);
128 return true;
129 }
130 
131 function approve(address _spender, uint256 _value) public returns (bool) {
132 allowed[msg.sender][_spender] = _value;
133 Approval(msg.sender, _spender, _value);
134 return true;
135 }
136 
137 function allowance(address _owner, address _spender) public view returns (uint256) {
138 return allowed[_owner][_spender];
139 }
140 
141 function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144 return true;
145 }
146 
147 function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
148 uint oldValue = allowed[msg.sender][_spender];
149 if (_subtractedValue > oldValue) {
150 allowed[msg.sender][_spender] = 0;
151 } else {
152 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
153 }
154 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155 return true;
156 }
157 }
158 
159 contract MintableToken is StandardToken, Ownable {
160 event Mint(address indexed to, uint256 amount);
161 event MintFinished();
162 
163 bool public mintingFinished = false;
164 
165 
166 modifier canMint() {
167 require(!mintingFinished);
168 _;
169 }
170 
171 function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
172 totalSupply = totalSupply.add(_amount);
173 balances[_to] = balances[_to].add(_amount);
174 Mint(_to, _amount);
175 Transfer(address(0), _to, _amount);
176 return true;
177 }
178 
179 function finishMinting() onlyOwner canMint public returns (bool) {
180 mintingFinished = true;
181 MintFinished();
182 return true;
183 }
184 }
185 
186 contract TokenConfig {
187 
188 string  public constant TOKEN_SYMBOL   = "GYM";
189 string  public constant TOKEN_NAME     = "GYM Rewards";
190 uint8   public constant TOKEN_DECIMALS = 18;
191 
192 uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
193 }
194 
195 contract TokenSaleConfig is TokenConfig {
196 
197 uint256 public constant START_TIME                = 1516406400; 
198 uint256 public constant PHASE2_START_TIME         = 1517443200; 
199 uint256 public constant PHASE3_START_TIME         = 1518739200; 
200 uint256 public constant PHASE4_START_TIME         = 1519862400; 
201 uint256 public constant PHASE5_START_TIME         = 1521158400; 
202 uint256 public constant END_TIME                  = 1522540800; 
203 
204 uint256 public constant TIER1_RATE                  =  160000;
205 uint256 public constant TIER2_RATE                  =  150000;
206 uint256 public constant TIER3_RATE                  =  125000;
207 uint256 public constant TIER4_RATE                  =  115000;
208 uint256 public constant TIER5_RATE                  =  100000;
209 
210 
211 uint256 public constant CONTRIBUTION_MIN          = 1 * 10 ** 16; // 0.01 ether
212 uint256 public constant CONTRIBUTION_MAX          = 100000 ether;
213 
214 uint256 public constant MAX_TOKENS_SALE               = 2000000000  * DECIMALSFACTOR;  // 13,500 ETH HARDCAP
215 uint256 public constant MAX_TOKENS_FOUNDERS           =  100000000  * DECIMALSFACTOR; // 10%
216 uint256 public constant MAX_TOKENS_ADVISORS           =  150000000  * DECIMALSFACTOR; // 15%
217 uint256 public constant MAX_TOKENS_EARLY_INVESTORS    =  150000000  * DECIMALSFACTOR; // 15%
218 uint256 public constant MAX_TOKENS_AIRDROPS_BOUNTIES  =    5000000  * DECIMALSFACTOR; // 3.125 Airdrops/Bounties
219 //uint256 public constant TOKENS_ACCELERATOR_MAX    = 257558034 * DECIMALSFACTOR;
220 //uint256 public constant TOKENS_FUTURE             = 120000000 * DECIMALSFACTOR;
221 }
222 
223 
224 
225 contract GYMRewardsToken is MintableToken, TokenConfig {
226 
227 string public constant name = TOKEN_NAME;
228 string public constant symbol = TOKEN_SYMBOL;
229 uint8 public constant decimals = TOKEN_DECIMALS;
230 }
231 
232 contract GYMRewardsCrowdsale is Pausable, TokenSaleConfig {
233 using SafeMath for uint256;
234 
235 GYMRewardsToken public token;
236 
237 uint256 public startTime;
238 uint256 public tier2Time;
239 uint256 public tier3Time;
240 uint256 public tier4Time;
241 uint256 public tier5Time;
242 uint256 public endTime;
243 
244 address public wallet;
245 
246 uint256 public weiRaised;
247 
248 uint256 public tokensMintedForSale;
249 uint256 public tokensMintedForOperations;
250 
251 bool public isFinalized = false;
252 bool public bountiesMinted = false;
253 bool public opMinted = false;
254 
255 
256 event Finalized();
257 
258 modifier onlyDuringSale() {
259 require(hasStarted() && !hasEnded());
260 _;
261 }
262 
263 modifier onlyAfterSale() {
264 require(hasEnded());
265 _;
266 }
267 
268 event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
269 event BountiesMinted(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
270 
271 
272 function GYMRewardsCrowdsale(address _wallet) public {
273 
274 require(_wallet != address(0));
275 
276 
277 token = createTokenContract();
278 startTime = START_TIME;
279 tier2Time = PHASE2_START_TIME;
280 tier3Time = PHASE3_START_TIME;
281 tier4Time = PHASE4_START_TIME;
282 tier5Time = PHASE5_START_TIME;
283 endTime = END_TIME;
284 wallet = _wallet;
285 mintBounties(wallet);
286 }
287 
288 function createTokenContract() internal returns (GYMRewardsToken) {
289 return new GYMRewardsToken();
290 }
291 
292 function () public payable whenNotPaused onlyDuringSale {
293 buyTokens(msg.sender);
294 }
295 
296 function mintBounties(address beneficiary) public onlyOwner{
297 	if (opMinted == false)
298 	{
299 		opMinted = true;
300 		tokensMintedForOperations.add(MAX_TOKENS_AIRDROPS_BOUNTIES);
301 		token.mint(beneficiary, MAX_TOKENS_AIRDROPS_BOUNTIES);
302 
303 		BountiesMinted(owner, beneficiary, MAX_TOKENS_AIRDROPS_BOUNTIES, MAX_TOKENS_AIRDROPS_BOUNTIES);
304 	}
305 }
306 
307 function buyTokens(address beneficiary) public payable whenNotPaused onlyDuringSale {
308 require(beneficiary != address(0));
309 require(msg.value > 0); 
310 
311 uint256 weiAmount = msg.value;
312 
313 uint256 exchangeRate = calculateTierBonus();
314 uint256 tokens = weiAmount.mul(exchangeRate);
315 
316 // Debe cambiar si se quiere vender mas del 100% de los tokens
317 require (tokensMintedForSale.add(tokens) <= MAX_TOKENS_SALE);
318 
319 
320 weiRaised = weiRaised.add(weiAmount); 
321 tokensMintedForSale = tokensMintedForSale.add(tokens); 
322 
323 token.mint(beneficiary, tokens);
324 
325 TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
326 
327 if (tokensMintedForSale == MAX_TOKENS_SALE) {
328 finalizeInternal();
329 }
330 
331 forwardFunds();
332 }
333 
334 function calculateTierBonus() public view returns (uint256){
335 
336 if(now >= startTime && now < tier2Time){
337 return TIER1_RATE;
338 }
339 
340 if(now >= tier2Time && now < tier3Time){
341 return TIER2_RATE;
342 }
343 
344 if(now >= tier3Time && now <= tier4Time){
345 return TIER3_RATE;
346 }
347 
348 if(now >= tier4Time && now <= tier5Time){
349 return TIER4_RATE;
350 }
351 
352 if(now >= tier5Time && now <= endTime){
353 return TIER5_RATE;
354 }
355 
356 
357 }
358 
359 function finalizeInternal() internal returns (bool) {
360 require(!isFinalized);
361 
362 isFinalized = true;
363 Finalized();
364 return true;
365 }
366 
367 function forwardFunds() internal {
368 wallet.transfer(msg.value);
369 }
370 
371 function hasEnded() public constant returns (bool) {
372 bool _saleIsOver = now > endTime;
373 return _saleIsOver || isFinalized;
374 }
375 
376 function hasStarted() public constant returns (bool) {
377 return now >= startTime;
378 }
379 
380 function tellTime() public constant returns (uint) {
381 return now;
382 }
383 }