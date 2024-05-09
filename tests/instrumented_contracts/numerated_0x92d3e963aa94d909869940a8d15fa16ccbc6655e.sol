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
50 
51 function kill() onlyOwner public {
52     if (msg.sender == owner) selfdestruct(owner);
53 }
54 }
55 
56 contract ERC20Basic {
57 uint256 public totalSupply;
58 function balanceOf(address who) public view returns (uint256);
59 function transfer(address to, uint256 value) public returns (bool);
60 event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 contract ERC20 is ERC20Basic {
65 function allowance(address owner, address spender) public view returns (uint256);
66 function transferFrom(address from, address to, uint256 value) public returns (bool);
67 function approve(address spender, uint256 value) public returns (bool);
68 event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 library SafeMath {
72 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73 if (a == 0) {
74 return 0;
75 }
76 uint256 c = a * b;
77 assert(c / a == b);
78 return c;
79 }
80 
81 function div(uint256 a, uint256 b) internal pure returns (uint256) {
82 uint256 c = a / b;
83 return c;
84 }
85 
86 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87 assert(b <= a);
88 return a - b;
89 }
90 
91 function add(uint256 a, uint256 b) internal pure returns (uint256) {
92 uint256 c = a + b;
93 assert(c >= a);
94 return c;
95 }
96 }
97 
98 
99 contract BasicToken is ERC20Basic {
100 using SafeMath for uint256;
101 
102 mapping(address => uint256) balances;
103 
104 function transfer(address _to, uint256 _value) public returns (bool) {
105 require(_to != address(0));
106 require(_value <= balances[msg.sender]);
107 
108 balances[msg.sender] = balances[msg.sender].sub(_value);
109 balances[_to] = balances[_to].add(_value);
110 Transfer(msg.sender, _to, _value);
111 return true;
112 }
113 
114 function balanceOf(address _owner) public view returns (uint256 balance) {
115 return balances[_owner];
116 }
117 }
118 
119 contract StandardToken is ERC20, BasicToken {
120 
121 mapping (address => mapping (address => uint256)) internal allowed;
122 
123 function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124 require(_to != address(0));
125 require(_value <= balances[_from]);
126 require(_value <= allowed[_from][msg.sender]);
127 
128 balances[_from] = balances[_from].sub(_value);
129 balances[_to] = balances[_to].add(_value);
130 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131 Transfer(_from, _to, _value);
132 return true;
133 }
134 
135 function approve(address _spender, uint256 _value) public returns (bool) {
136 allowed[msg.sender][_spender] = _value;
137 Approval(msg.sender, _spender, _value);
138 return true;
139 }
140 
141 function allowance(address _owner, address _spender) public view returns (uint256) {
142 return allowed[_owner][_spender];
143 }
144 
145 function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
146 allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
147 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148 return true;
149 }
150 
151 function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
152 uint oldValue = allowed[msg.sender][_spender];
153 if (_subtractedValue > oldValue) {
154 allowed[msg.sender][_spender] = 0;
155 } else {
156 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157 }
158 Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159 return true;
160 }
161 }
162 
163 contract MintableToken is StandardToken, Ownable {
164 event Mint(address indexed to, uint256 amount);
165 event MintFinished();
166 
167 bool public mintingFinished = false;
168 
169 
170 modifier canMint() {
171 require(!mintingFinished);
172 _;
173 }
174 
175 function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
176 totalSupply = totalSupply.add(_amount);
177 balances[_to] = balances[_to].add(_amount);
178 Mint(_to, _amount);
179 Transfer(address(0), _to, _amount);
180 return true;
181 }
182 
183 function finishMinting() onlyOwner canMint public returns (bool) {
184 mintingFinished = true;
185 MintFinished();
186 return true;
187 }
188 }
189 
190 contract TokenConfig {
191 
192 string  public constant TOKEN_SYMBOL   = "GYM";
193 string  public constant TOKEN_NAME     = "GYM Rewards";
194 uint8   public constant TOKEN_DECIMALS = 18;
195 
196 uint256 public constant DECIMALSFACTOR = 10**uint256(TOKEN_DECIMALS);
197 }
198 
199 contract TokenSaleConfig is TokenConfig {
200 
201 uint256 public constant START_TIME                = 1519689601; 
202 uint256 public constant PHASE2_START_TIME         = 1519862401;
203 uint256 public constant PHASE3_START_TIME         = 1522540801; 
204 uint256 public constant PHASE4_START_TIME         = 1523750401;
205 uint256 public constant PHASE5_START_TIME         = 1525046401; 
206 uint256 public constant END_TIME                  = 1526428799; 
207 
208 uint256 public constant TIER1_RATE                  =  16000;
209 uint256 public constant TIER2_RATE                  =  15000;
210 uint256 public constant TIER3_RATE                  =  14000;
211 uint256 public constant TIER4_RATE                  =  12000;
212 uint256 public constant TIER5_RATE                  =  10000;
213 
214 
215 uint256 public constant CONTRIBUTION_MIN          = 1 * 10 ** 16; 
216 uint256 public constant CONTRIBUTION_MAX          = 100000 ether;
217 
218 uint256 public constant MAX_TOKENS_SALE               = 1660000000  * DECIMALSFACTOR;  
219 uint256 public constant MAX_TOKENS_FOUNDERS           =  100000000  * DECIMALSFACTOR; 
220 uint256 public constant MAX_TOKENS_RESERVE	      =  100000000  * DECIMALSFACTOR; 
221 uint256 public constant MAX_TOKENS_AIRDROPS_BOUNTIES  =   80000000  * DECIMALSFACTOR; 
222 uint256 public constant MAX_TOKENS_ADVISORS_PARTNERS  =   60000000  * DECIMALSFACTOR; 
223 
224 }
225 
226 
227 
228 contract GYMRewardsToken is MintableToken, TokenConfig {
229 	string public constant name = TOKEN_NAME;
230 	string public constant symbol = TOKEN_SYMBOL;
231 	uint8 public constant decimals = TOKEN_DECIMALS;
232 }
233 
234 contract GYMRewardsCrowdsale is Pausable, TokenSaleConfig {
235 	using SafeMath for uint256;
236 
237 	GYMRewardsToken public token;
238 
239 	uint256 public startTime;
240 	uint256 public tier2Time;
241 	uint256 public tier3Time;
242 	uint256 public tier4Time;
243 	uint256 public tier5Time;
244 	uint256 public endTime;
245 
246 	address public wallet = 0xE38cc3F48b4F98Cb3577aC75bB96DBBc87bc57d6;
247 	address public airdrop_wallet = 0x5Fec898d08801Efd884A1162Fd159474757D422F;
248 	address public reserve_wallet = 0x2A0Fc31cDE12a74143D7B9642423a2D8a3453b07;
249 	address public founders_wallet = 0x5C11b5aF9f1b4CDEeab9f6BebEd4EdbAe67900C3;
250 	address public advisors_wallet = 0xD8A1a54DcECe365C56B98EbDb9078Bdb2FA609da;
251 
252 	uint256 public weiRaised;
253 
254 	uint256 public tokensMintedForSale;
255 	uint256 public tokensMintedForOperations;
256 	bool public isFinalized = false;
257 	bool public opMinted = false;
258 
259 
260 	event Finalized();
261 
262 	modifier onlyDuringSale() {
263 		require(hasStarted() && !hasEnded());
264 		_;
265 	}
266 
267 	modifier onlyAfterSale() {
268 		require(hasEnded());
269 		_;
270 	}
271 
272 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
273 	event BountiesMinted(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
274 	event LongTermReserveMinted(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
275 	event CoreTeamMinted(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
276 	event AdvisorsAndPartnersMinted(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
277 
278 
279 	function GYMRewardsCrowdsale() public {
280 	
281 		token = createTokenContract();
282 		startTime = START_TIME;
283 		tier2Time = PHASE2_START_TIME;
284 		tier3Time = PHASE3_START_TIME;
285 		tier4Time = PHASE4_START_TIME;
286 		tier5Time = PHASE5_START_TIME;
287 		endTime = END_TIME;
288 
289 		mintBounties();
290 	}
291 
292 	function createTokenContract() internal returns (GYMRewardsToken) {
293 		return new GYMRewardsToken();
294 	}
295 
296 	function () public payable whenNotPaused onlyDuringSale {
297 		buyTokens(msg.sender);
298 	}
299 
300 	function mintBounties() public onlyOwner{
301 		if (opMinted == false)
302 		{
303 			opMinted = true;
304 			tokensMintedForOperations = tokensMintedForOperations.add(MAX_TOKENS_AIRDROPS_BOUNTIES);
305 			token.mint(airdrop_wallet, MAX_TOKENS_AIRDROPS_BOUNTIES);
306 
307 			tokensMintedForOperations = tokensMintedForOperations.add(MAX_TOKENS_RESERVE);
308 			token.mint(reserve_wallet, MAX_TOKENS_RESERVE);
309 
310 			tokensMintedForOperations = tokensMintedForOperations.add(MAX_TOKENS_FOUNDERS);
311 			token.mint(founders_wallet, MAX_TOKENS_FOUNDERS);
312 
313 			tokensMintedForOperations = tokensMintedForOperations.add(MAX_TOKENS_ADVISORS_PARTNERS);
314 			token.mint(advisors_wallet, MAX_TOKENS_ADVISORS_PARTNERS);
315 
316 			BountiesMinted(owner, airdrop_wallet, MAX_TOKENS_AIRDROPS_BOUNTIES, MAX_TOKENS_AIRDROPS_BOUNTIES);
317 			LongTermReserveMinted(owner, reserve_wallet, MAX_TOKENS_RESERVE, MAX_TOKENS_RESERVE);
318 			CoreTeamMinted(owner, founders_wallet, MAX_TOKENS_FOUNDERS, MAX_TOKENS_FOUNDERS);
319 			AdvisorsAndPartnersMinted(owner, advisors_wallet, MAX_TOKENS_ADVISORS_PARTNERS, MAX_TOKENS_ADVISORS_PARTNERS);
320 		}
321 	}
322 
323 	function buyTokens(address beneficiary) public payable whenNotPaused onlyDuringSale {
324 		require(beneficiary != address(0));
325 		require(msg.value > 0); 
326 
327 
328 		uint256 weiAmount = msg.value;
329 
330 		uint256 exchangeRate = calculateTierBonus();
331 		uint256 tokens = weiAmount.mul(exchangeRate);
332 
333 		require (tokensMintedForSale <= MAX_TOKENS_SALE);
334 
335 
336 		weiRaised = weiRaised.add(weiAmount); 
337 		tokensMintedForSale = tokensMintedForSale.add(tokens); 
338 
339 		token.mint(beneficiary, tokens);
340 
341 		TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
342 
343 		if (tokensMintedForSale >= MAX_TOKENS_SALE) {
344 			finalizeInternal();
345 		}
346 
347 		forwardFunds();
348 	}
349 
350 	function calculateTierBonus() public view returns (uint256){
351 			if(now >= startTime && now < tier2Time){
352 			return TIER1_RATE;
353 			}
354 
355 			if(now >= tier2Time && now < tier3Time){
356 			return TIER2_RATE;
357 			}
358 
359 			if(now >= tier3Time && now <= tier4Time){
360 			return TIER3_RATE;
361 			}
362 
363 			if(now >= tier4Time && now <= tier5Time){
364 			return TIER4_RATE;
365 			}
366 
367 			if(now >= tier5Time && now <= endTime){
368 			return TIER5_RATE;
369 			}
370 	}
371 
372 	function finalizeInternal() internal returns (bool) {
373 		require(!isFinalized);
374 
375 		isFinalized = true;
376 		Finalized();
377 		return true;
378 	}
379 
380 	function forwardFunds() internal {
381 		wallet.transfer(msg.value);
382 	}
383 
384 	function hasEnded() public constant returns (bool) {
385 		bool _saleIsOver = now > endTime;
386 		return _saleIsOver || isFinalized;
387 	}
388 
389 	function hasStarted() public constant returns (bool) {
390 		return now >= startTime;
391 	}
392 
393 	function tellTime() public constant returns (uint) {
394 		return now;
395 	}
396 
397 	function totalSupply() public constant returns(uint256)
398 	{
399 		return tokensMintedForSale + tokensMintedForOperations;
400 	}
401 }