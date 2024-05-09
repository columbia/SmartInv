1 pragma solidity 0.4.18;
2 
3 contract Ownable {
4 	address public owner;
5 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 	function Ownable() {
8 		owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner() {
12 		require(msg.sender == owner);
13 		_;
14 	}
15 
16 	function transferOwnership(address newOwner) onlyOwner public {
17 		require(newOwner != address(0));
18 		OwnershipTransferred(owner, newOwner);
19 		owner = newOwner;
20 	}
21 }
22 
23 library SafeMath {
24 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25 		uint256 c = a * b;
26 		assert(a == 0 || c / a == b);
27 		return c;
28 	}
29 
30 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
31 		uint256 c = a / b;
32 		return c;
33 	}
34 
35 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
41 		uint256 c = a + b;
42 		assert(c >= a);
43 		return c;
44 	}
45 }
46 
47 contract ERC20 {
48 	uint256 public totalSupply;
49 	function balanceOf(address who) public constant returns (uint256);
50 	function transfer(address to, uint256 value) public returns (bool);
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52 
53 	function allowance(address owner, address spender) public constant returns (uint256);
54 	function transferFrom(address from, address to, uint256 value) public returns (bool);
55 	function approve(address spender, uint256 value) public returns (bool);
56 	event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract StandardToken is ERC20 {
60 	using SafeMath for uint256;
61 
62 	mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 
65 	function transfer(address _to, uint256 _value) public returns (bool) {
66 		require(_to != address(0));
67 
68 		balances[msg.sender] = balances[msg.sender].sub(_value);
69 		balances[_to] = balances[_to].add(_value);
70 		Transfer(msg.sender, _to, _value);
71 		return true;
72 	}
73 
74 	function balanceOf(address _owner) public constant returns (uint256 balance) {
75 		return balances[_owner];
76 	}
77 
78 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79 		require(_to != address(0));
80 
81 		uint256 _allowance = allowed[_from][msg.sender];
82 
83 		balances[_from] = balances[_from].sub(_value);
84 		balances[_to] = balances[_to].add(_value);
85 		allowed[_from][msg.sender] = _allowance.sub(_value);
86 		Transfer(_from, _to, _value);
87 		return true;
88 	}
89 
90 	function approve(address _spender, uint256 _value) public returns (bool) {
91 		allowed[msg.sender][_spender] = _value;
92 		Approval(msg.sender, _spender, _value);
93 		return true;
94 	}
95 
96 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
97 		return allowed[_owner][_spender];
98 	}
99 }
100 
101 contract T8EXToken is StandardToken {
102 	string public constant name = "T8EX Token";
103     string public constant symbol = "T8EX";
104     uint8  public constant decimals = 18;
105 
106 	address public minter; 
107 	uint    public tokenSaleEndTime; 
108 
109 	// token lockup for cornerstone investors
110 	mapping(address=>uint) public lockedBalanceCor; 
111 	mapping(uint=>address) lockedBalanceCor_index;
112 	uint lockedBalanceCor_count;
113 
114 	// token lockup for private investors
115 	mapping(address=>uint) public lockedBalancePri; 
116 	mapping(uint=>address) lockedBalancePri_index;
117 	uint lockedBalancePri_count;
118 
119 	modifier onlyMinter {
120 		require (msg.sender == minter);
121 		_;
122 	}
123 
124 	modifier whenMintable {
125 		require (now <= tokenSaleEndTime);
126 		_;
127 	}
128 
129     modifier validDestination(address to) {
130         require(to != address(this));
131         _;
132     }
133 
134 	function T8EXToken(address _minter, uint _tokenSaleEndTime) public {
135 		minter = _minter;
136 		tokenSaleEndTime = _tokenSaleEndTime;
137     }
138 
139 	function transfer(address _to, uint _value)
140         public
141         validDestination(_to)
142         returns (bool) 
143     {
144         return super.transfer(_to, _value);
145     }
146 
147 	function transferFrom(address _from, address _to, uint _value)
148         public
149         validDestination(_to)
150         returns (bool) 
151     {
152         return super.transferFrom(_from, _to, _value);
153     }
154 
155 	function createToken(address _recipient, uint _value)
156 		whenMintable
157 		onlyMinter
158 		returns (bool)
159 	{
160 		balances[_recipient] += _value;
161 		totalSupply += _value;
162 		return true;
163 	}
164 
165 	// Create an lockedBalance which cannot be traded until admin make it liquid.
166 	// Can only be called by crowdfund contract before the end time.
167 	function createLockedTokenCor(address _recipient, uint _value)
168 		whenMintable
169 		onlyMinter
170 		returns (bool) 
171 	{
172 		lockedBalanceCor_index[lockedBalanceCor_count] = _recipient;
173 		lockedBalanceCor[_recipient] += _value;
174 		lockedBalanceCor_count++;
175 
176 		totalSupply += _value;
177 		return true;
178 	}
179 
180 	// Make sender's locked balance liquid when called after lockout period.
181 	function makeLiquidCor()
182 		onlyMinter
183 	{
184 		for (uint i=0; i<lockedBalanceCor_count; i++) {
185 			address investor = lockedBalanceCor_index[i];
186 			balances[investor] += lockedBalanceCor[investor];
187 			lockedBalanceCor[investor] = 0;
188 		}
189 	}
190 
191 	// Create an lockedBalance which cannot be traded until admin make it liquid.
192 	// Can only be called by crowdfund contract before the end time.
193 	function createLockedTokenPri(address _recipient, uint _value)
194 		whenMintable
195 		onlyMinter
196 		returns (bool) 
197 	{
198 		lockedBalancePri_index[lockedBalancePri_count] = _recipient;
199 		lockedBalancePri[_recipient] += _value;
200 		lockedBalancePri_count++;
201 
202 		totalSupply += _value;
203 		return true;
204 	}
205 
206 	// Make sender's locked balance liquid when called after lockout period.
207 	function makeLiquidPri()
208 		onlyMinter
209 	{
210 		for (uint i=0; i<lockedBalancePri_count; i++) {
211 			address investor = lockedBalancePri_index[i];
212 			balances[investor] += lockedBalancePri[investor];
213 			lockedBalancePri[investor] = 0;
214 		}
215 	}
216 }
217 
218 contract T8EXTokenSale is Ownable {
219     using SafeMath for uint256;
220 
221 	// token allocation
222 	uint public constant TOTAL_T8EXTOKEN_SUPPLY  = 540000000;
223 	uint public constant ALLOC_TEAM             = 135000000e18;
224 	uint public constant ALLOC_RESERVED         =  54000000e18;
225 	uint public constant ALLOC_COMMUNITY        = 118800000e18;
226 	uint public constant ALLOC_ADVISOR          =  16200000e18;
227 	uint public constant ALLOC_SALE_CORNERSTONE =  32500000e18; 
228 	uint public constant ALLOC_SALE_PRIVATE     = 120000000e18; 
229 	uint public constant ALLOC_SALE_GENERAL     =  63500000e18; 
230 
231 	// crowdsale stage
232 	uint public constant STAGE1_TIME_END = 4 days;
233 	uint public constant STAGE2_TIME_END = 8 days;
234 	uint public constant STAGE3_TIME_END = 13 days;
235 
236 	// Token sale rate from ETH to T8EX
237 	uint public constant RATE_CORNERSTONE  = 6500;
238 	uint public constant RATE_PRIVATE      = 6000;
239 	uint public constant RATE_CROWDSALE_S1 = 4500;
240 	uint public constant RATE_CROWDSALE_S2 = 4200;
241 	uint public constant RATE_CROWDSALE_S3 = 4000;
242 
243 	// For token transfer
244 	address public constant WALLET_T8EX_RESERVED  = 0x63cB2fB590d5eD47fBEFbBbF0CDda1c56D506f0A;
245 	address public constant WALLET_T8EX_COMMUNITY = 0x1a0E0147acF86e7bFa773e90D9465D51C1c0a594;
246 	address public constant WALLET_T8EX_TEAM      = 0x5e7658d850B1A050937ee088EB503243A345ffe6;
247 	address public constant WALLET_T8EX_ADMIN     = 0x4Db76c3F8d0169ABa7aD5795dA1253231a09a22C;
248 
249 	// For ether transfer
250 	address private constant WALLET_ETH_T8EX  = 0xEE1B6C44DBb3b0d5e46C34542dC7718325ac4095;
251 	address private constant WALLET_ETH_ADMIN = 0x782872fb9459FC0dbdf8c0EDb5fE3D5f214a6660;
252 
253     T8EXToken public t8exToken; 
254 
255 	uint256 public presaleStartTime;
256     uint256 public publicStartTime;
257     uint256 public publicEndTime;
258 	bool public halted;
259 
260 	// stat
261 	uint256 public totalT8EXSold_CORNERSTONE;
262 	uint256 public totalT8EXSold_PRIVATE;
263 	uint256 public totalT8EXSold_GENERAL;
264     uint256 public weiRaised;
265 	mapping(address=>uint256) public weiContributions;
266 
267 	// whitelisting
268 	mapping(address=>bool) public whitelisted_Private;
269 	mapping(address=>bool) public whitelisted_Cornerstone;
270 	event WhitelistedPrivateStatusChanged(address target, bool isWhitelisted);
271 	event WhitelistedCornerstoneStatusChanged(address target, bool isWhitelisted);
272 
273     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
274 
275     function T8EXTokenSale(uint256 _presaleStartTime, uint256 _publicStartTime, uint256 _publicEndTime) {
276         presaleStartTime = _presaleStartTime;
277         publicStartTime = _publicStartTime;
278 		publicEndTime = _publicEndTime;
279 
280         t8exToken = new T8EXToken(address(this), publicEndTime);
281 		t8exToken.createToken(WALLET_T8EX_RESERVED, ALLOC_RESERVED);
282 		t8exToken.createToken(WALLET_T8EX_COMMUNITY, ALLOC_COMMUNITY);
283 		t8exToken.createToken(WALLET_T8EX_TEAM, ALLOC_TEAM);
284 		t8exToken.createToken(WALLET_T8EX_ADMIN, ALLOC_ADVISOR);
285     }
286 
287 
288     function changeWhitelistPrivateStatus(address _target, bool _isWhitelisted)
289         public
290         onlyOwner
291     {
292         whitelisted_Private[_target] = _isWhitelisted;
293         WhitelistedPrivateStatusChanged(_target, _isWhitelisted);
294     }
295 
296     function changeWhitelistPrivateStatuses(address[] _targets, bool _isWhitelisted)
297         public
298         onlyOwner
299     {
300         for (uint i = 0; i < _targets.length; i++) {
301             changeWhitelistPrivateStatus(_targets[i], _isWhitelisted);
302         }
303     }
304 
305 	function changeWhitelistCornerstoneStatus(address _target, bool _isWhitelisted)
306         public
307         onlyOwner
308     {
309         whitelisted_Cornerstone[_target] = _isWhitelisted;
310         WhitelistedCornerstoneStatusChanged(_target, _isWhitelisted);
311     }
312 
313     function changeWhitelistCornerstoneStatuses(address[] _targets, bool _isWhitelisted)
314         public
315         onlyOwner
316     {
317         for (uint i = 0; i < _targets.length; i++) {
318             changeWhitelistCornerstoneStatus(_targets[i], _isWhitelisted);
319         }
320     }
321 
322     function validPurchase() 
323         internal 
324         returns(bool) 
325     {
326 		bool nonZeroPurchase = msg.value != 0;
327 		bool withinSalePeriod = now >= presaleStartTime && now <= publicEndTime;
328         bool withinPublicPeriod = now >= publicStartTime && now <= publicEndTime;
329 
330 		bool whitelisted = whitelisted_Cornerstone[msg.sender] || whitelisted_Private[msg.sender];
331 		bool whitelistedCanBuy = whitelisted && withinSalePeriod;
332         
333         return nonZeroPurchase && (whitelistedCanBuy || withinPublicPeriod);
334     }
335 
336 	function getPriceRate()
337 		constant
338 		returns (uint)
339 	{
340 		if (now <= publicStartTime + STAGE1_TIME_END) {return RATE_CROWDSALE_S1;}
341 		if (now <= publicStartTime + STAGE2_TIME_END) {return RATE_CROWDSALE_S2;}
342 		if (now <= publicStartTime + STAGE3_TIME_END) {return RATE_CROWDSALE_S3;}
343 		return 0;
344 	}
345 
346     function () 
347        payable 
348     {
349         buyTokens();
350     }
351 
352     function buyTokens() 
353        payable 
354     {
355 		require(!halted);
356         require(validPurchase());
357 
358         uint256 weiAmount = msg.value;
359 		uint256 purchaseTokens; 
360 		
361 		if (whitelisted_Cornerstone[msg.sender]) {
362 			purchaseTokens = weiAmount.mul(RATE_CORNERSTONE); 
363 			require(ALLOC_SALE_CORNERSTONE - totalT8EXSold_CORNERSTONE >= purchaseTokens); // buy only if enough supply
364 			require(t8exToken.createLockedTokenCor(msg.sender, purchaseTokens));
365 			totalT8EXSold_CORNERSTONE = totalT8EXSold_CORNERSTONE.add(purchaseTokens); 
366 		} else if (whitelisted_Private[msg.sender]) {
367 			purchaseTokens = weiAmount.mul(RATE_PRIVATE); 
368 			require(ALLOC_SALE_PRIVATE - totalT8EXSold_PRIVATE >= purchaseTokens); // buy only if enough supply
369 			require(t8exToken.createLockedTokenPri(msg.sender, purchaseTokens));
370 			totalT8EXSold_PRIVATE = totalT8EXSold_PRIVATE.add(purchaseTokens); 
371 		} else {
372         	purchaseTokens = weiAmount.mul(getPriceRate()); 
373 			require(ALLOC_SALE_GENERAL - totalT8EXSold_GENERAL >= purchaseTokens); // buy only if enough supply
374 			require(t8exToken.createToken(msg.sender, purchaseTokens));
375 			totalT8EXSold_GENERAL = totalT8EXSold_GENERAL.add(purchaseTokens); 
376 		}
377 
378 		weiRaised = weiRaised.add(weiAmount);
379 		weiContributions[msg.sender] = weiContributions[msg.sender].add(weiAmount);
380 
381 		TokenPurchase(msg.sender, weiAmount, purchaseTokens);
382 		forwardFunds();
383     }
384 
385     function forwardFunds() 
386        internal 
387     {
388         WALLET_ETH_T8EX.transfer((msg.value).mul(98).div(100));
389 		WALLET_ETH_ADMIN.transfer((msg.value).mul(2).div(100));
390     }
391 
392     function hasEnded() 
393         public 
394         constant 
395         returns(bool) 
396     {
397         return now > publicEndTime;
398     }
399 
400 	function releaseTokenCornerstone()
401 		public
402 		onlyOwner
403 	{
404 		require(hasEnded());
405 		t8exToken.makeLiquidCor();
406 	}
407 
408 	function releaseTokenPrivate()
409 		public
410 		onlyOwner
411 	{
412 		require(hasEnded());
413 		t8exToken.makeLiquidPri();
414 	}
415 
416 	function toggleHalt(bool _halted)
417 		public
418 		onlyOwner
419 	{
420 		halted = _halted;
421 	}
422 }