1 pragma solidity ^0.4.19;
2 
3 // LeeSungCoin Made By PinkCherry - insanityskan@gmail.com
4 // LeeSungCoin Request Question - koreacoinsolution@gmail.com
5 
6 library SafeMath
7 {
8   	function mul(uint256 a, uint256 b) internal pure returns (uint256)
9     {
10 		uint256 c = a * b;
11 		assert(a == 0 || c / a == b);
12 
13 		return c;
14   	}
15 
16   	function div(uint256 a, uint256 b) internal pure returns (uint256)
17 	{
18 		uint256 c = a / b;
19 
20 		return c;
21   	}
22 
23   	function sub(uint256 a, uint256 b) internal pure returns (uint256)
24 	{
25 		assert(b <= a);
26 
27 		return a - b;
28   	}
29 
30   	function add(uint256 a, uint256 b) internal pure returns (uint256)
31 	{
32 		uint256 c = a + b;
33 		assert(c >= a);
34 
35 		return c;
36   	}
37 }
38 
39 
40 contract OwnerHelper
41 {
42   	address public owner;
43 
44   	event OwnerTransferPropose(address indexed _from, address indexed _to);
45 
46   	modifier onlyOwner
47 	{
48 		require(msg.sender == owner);
49 		_;
50   	}
51 
52   	function OwnerHelper() public
53 	{
54 		owner = msg.sender;
55   	}
56 
57   	function transferOwnership(address _to) onlyOwner public
58 	{
59             require(_to != owner);
60     		require(_to != address(0x0));
61     		owner = _to;
62     		OwnerTransferPropose(owner, _to);
63   	}
64 
65 }
66 
67 
68 contract ERC20Interface
69 {
70   	event Transfer(address indexed _from, address indexed _to, uint _value);
71   	event Approval(address indexed _owner, address indexed _spender, uint _value);
72 	event Burned(address indexed _burner, uint _value);
73 
74   	function totalSupply() public constant returns (uint);
75   	function balanceOf(address _owner) public constant returns (uint balance);
76   	function transfer(address _to, uint _value) public returns (bool success);
77   	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
78   	function approve(address _spender, uint _value) public returns (bool success);
79   	function allowance(address _owner, address _spender) public constant returns (uint remaining);
80 	function burn(uint _burnAmount) public returns (bool success);
81 }
82 
83 
84 contract ERC20Token is ERC20Interface, OwnerHelper
85 {
86   	using SafeMath for uint;
87 
88   	uint public tokensIssuedTotal = 0;
89   	address public constant burnAddress = 0;
90 
91   	mapping(address => uint) balances;
92   	mapping(address => mapping (address => uint)) allowed;
93 
94   	function totalSupply() public constant returns (uint)
95 	{
96 		return tokensIssuedTotal;
97   	}
98 
99   	function balanceOf(address _owner) public constant returns (uint balance)
100 	{
101 		return balances[_owner];
102   	}
103 
104 	function transfer(address _to, uint _amount) public returns (bool success)
105 	{
106 		require( balances[msg.sender] >= _amount );
107 
108 	    balances[msg.sender] = balances[msg.sender].sub(_amount);
109 		balances[_to]        = balances[_to].add(_amount);
110 
111 		Transfer(msg.sender, _to, _amount);
112     
113 		return true;
114   	}
115 
116   	function approve(address _spender, uint _amount) public returns (bool success)
117 	{
118 		require ( balances[msg.sender] >= _amount );
119 
120 		allowed[msg.sender][_spender] = _amount;
121     		
122 		Approval(msg.sender, _spender, _amount);
123 
124 		return true;
125 	}
126 
127   	function transferFrom(address _from, address _to, uint _amount) public returns (bool success)
128 	{
129 		require( balances[_from] >= _amount );
130 		require( allowed[_from][msg.sender] >= _amount );
131 		balances[_from]            = balances[_from].sub(_amount);
132 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
133 		balances[_to]              = balances[_to].add(_amount);
134 
135 		Transfer(_from, _to, _amount);
136 		return true;
137   	}
138 
139   	function allowance(address _owner, address _spender) public constant returns (uint remaining)
140 	{
141 		return allowed[_owner][_spender];
142   	}
143 
144 	function burn(uint _burnAmount) public returns (bool success)
145 	{
146 		address burner = msg.sender;
147 		balances[burner] = balances[burner].sub(_burnAmount);
148 		tokensIssuedTotal = tokensIssuedTotal.sub(_burnAmount);
149 		Burned(burner, _burnAmount);
150 		Transfer(burner, burnAddress, _burnAmount);
151 
152 		return true;
153 	}
154 }
155 
156 contract LeeSungCoin is ERC20Token
157 {
158 	uint constant E18 = 10**18;
159 
160   	string public constant name 	= "LeeSungCoin";
161   	string public constant symbol 	= "LSC";
162   	uint public constant decimals 	= 18;
163 
164 	address public wallet;
165 	address public adminWallet;
166 	address public IcoContract;
167 
168 	uint public constant totalCoinCap   = 2000000000 * E18;
169 	uint public constant icoCoinCap     = 1400000000 * E18;
170 	uint public constant mktCoinCap     =  600000000 * E18;
171 	uint public constant preSaleCoinCap =  480000000 * E18;
172 
173 	uint public coinPerEth = 20000 * E18;
174 
175 	uint public constant privateSaleBonus	 = 30;
176 	uint public constant preSaleFirstBonus	 = 20;
177 	uint public constant preSaleSecondBonus  = 15;
178 	uint public constant mainSaleFirstBonus	 = 5;
179 	uint public constant mainSaleSecondBonus = 0;
180 
181   	uint public constant preSaleFirstStartDate = 1517788800; // 2018-02-05 00:00 UTC
182   	uint public constant preSaleFirstEndDate   = 1518307200; // 2018-02-11 00:00 UTC
183 
184   	uint public constant preSaleSecondStartDate = 1518393600; // 2018-02-12 00:00 UTC
185   	uint public constant preSaleSecondEndDate   = 1518912000; // 2018-02-18 00:00 UTC
186 
187 
188   	uint public constant mainSaleFirstStartDate = 1519603200; // 2018-02-26 00:00 UTC
189   	uint public constant mainSaleFirstEndDate   = 1520121600; // 2018-03-04 00:00 UTC
190 
191   	uint public constant mainSaleSecondStartDate = 1520208000; // 2018-03-05 00:00 UTC
192   	uint public constant mainSaleSecondEndDate   = 1520726400; // 2018-03-11 00:00 UTC
193 
194 	uint public constant transferCooldown = 2 days;
195 
196 	uint public constant preSaleMinEth  = 1 ether;
197 	uint public constant mainSaleMinEth =  1 ether / 2; // 0.5 Ether
198 
199   	uint public priEtherReceived = 0; // Ether actually received by the contract
200   	uint public icoEtherReceived = 0; // Ether actually received by the contract
201 
202     uint public coinIssuedTotal     = 0;
203   	uint public coinIssuedIco       = 0;
204   	uint public coinIssuedMkt       = 0;
205 	
206 	uint public coinBurnIco = 0;
207 	uint public coinBurnMkt = 0;
208 
209   	mapping(address => uint) public icoEtherContributed;
210   	mapping(address => uint) public icoCoinReceived;
211   	mapping(address => bool) public refundClaimed;
212   	mapping(address => bool) public coinLocked;
213   	
214  	event WalletChange(address _newWallet);
215   	event AdminWalletChange(address _newAdminWallet);
216   	event CoinMinted(address indexed _owner, uint _tokens, uint _balance);
217   	event CoinIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
218   	event Refund(address indexed _owner, uint _amount, uint _tokens);
219   	event LockRemove(address indexed _participant);
220 	event WithDraw(address indexed _to, uint _amount);
221 	event OwnerReclaim(address indexed _from, address indexed _owner, uint _amount);
222 
223   	function LeeSungCoin() public
224 	{
225 		require( icoCoinCap + mktCoinCap == totalCoinCap );
226 		wallet = owner;
227 		adminWallet = owner;
228 		
229 		IcoContract = 0x6E5B3dBFB6a85D11e5d0d4A5618C53838Da63900;
230 		priEtherReceived = 517 ether;
231 		icoEtherReceived = 112260255293000000000;
232   	}
233 
234   	function () payable public
235 	{
236     	buyCoin();
237   	}
238   	
239   	function atNow() public constant returns (uint)
240 	{
241 		return now;
242   	}
243 
244   	function buyCoin() private
245 	{
246 		uint nowTime = atNow();
247 
248 		uint saleTime = 0; // 1 : preSaleFirst, 2 : preSaleSecond, 3 : mainSaleFirst, 4 : mainSaleSecond
249 
250 		uint minEth = 0;
251 		uint maxEth = 300 ether;
252 
253 		uint coins = 0;
254 		uint coinBonus = 0;
255 		uint coinCap = 0;
256 
257 		if (nowTime > preSaleFirstStartDate && nowTime < preSaleFirstEndDate)
258 		{
259 			saleTime = 1;
260 			minEth = preSaleMinEth;
261 			coinBonus = preSaleFirstBonus;
262 			coinCap = preSaleCoinCap;
263 		}
264 
265 		if (nowTime > preSaleSecondStartDate && nowTime < preSaleSecondEndDate)
266 		{
267 			saleTime = 2;
268 			minEth = preSaleMinEth;
269 			coinBonus = preSaleSecondBonus;
270 			coinCap = preSaleCoinCap;
271 		}
272 
273 		if (nowTime > mainSaleFirstStartDate && nowTime < mainSaleFirstEndDate)
274 		{
275 			saleTime = 3;
276 			minEth = mainSaleMinEth;
277 			coinBonus = mainSaleFirstBonus;
278 			coinCap = icoCoinCap;
279 		}
280 
281 		if (nowTime > mainSaleSecondStartDate && nowTime < mainSaleSecondEndDate)
282 		{
283 			saleTime = 4;
284 			minEth = mainSaleMinEth;
285 			coinBonus = mainSaleSecondBonus;
286 			coinCap = icoCoinCap;
287 		}
288 		
289 		require( saleTime >= 1 && saleTime <= 4 );
290 		require( msg.value >= minEth );
291 		require( icoEtherContributed[msg.sender].add(msg.value) <= maxEth );
292 
293 		coins = coinPerEth.mul(msg.value) / 1 ether;
294       	coins = coins.mul(100 + coinBonus) / 100;
295 
296 		require( coinIssuedIco.add(coins) <= coinCap );
297 
298 		balances[msg.sender]        = balances[msg.sender].add(coins);
299 	    icoCoinReceived[msg.sender] = icoCoinReceived[msg.sender].add(coins);
300 		coinIssuedIco               = coinIssuedIco.add(coins);
301 		tokensIssuedTotal           = tokensIssuedTotal.add(coins);
302     
303 		icoEtherReceived                = icoEtherReceived.add(msg.value);
304 		icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
305     
306 		coinLocked[msg.sender] = true;
307     
308 		Transfer(0x0, msg.sender, coins);
309 		CoinIssued(msg.sender, coins, balances[msg.sender], msg.value);
310 
311 		wallet.transfer(this.balance);
312   	}
313 
314  	function isTransferable() public constant returns (bool transferable)
315 	{
316 		if ( atNow() < mainSaleSecondEndDate + transferCooldown )
317 		{
318 			return false;
319 		}
320 
321 		return true;
322   	}
323 
324 	function coinLockRemove(address _participant) public
325 	{
326 		require( msg.sender == adminWallet || msg.sender == owner );
327 		coinLocked[_participant] = false;
328 		LockRemove(_participant);
329   	}
330 
331 	function coinLockRmoveMultiple(address[] _participants) public
332 	{
333 		require( msg.sender == adminWallet || msg.sender == owner );
334     		
335 		for (uint i = 0; i < _participants.length; i++)
336 		{
337   			coinLocked[_participants[i]] = false;
338   			LockRemove(_participants[i]);
339 		}
340   	}
341 
342   	function changeWallet(address _wallet) onlyOwner public
343 	{
344     		require( _wallet != address(0x0) );
345     		wallet = _wallet;
346     		WalletChange(wallet);
347   	}
348 
349   	function changeAdminWallet(address _wallet) onlyOwner public
350 	{
351     		require( _wallet != address(0x0) );
352     		adminWallet = _wallet;
353     		AdminWalletChange(adminWallet);
354   	}
355 
356   	function mintMarketing(address _participant, uint _amount) onlyOwner public
357 	{
358 		uint coins = _amount * E18;
359 		
360 		require( coins <= mktCoinCap.sub(coinIssuedMkt) );
361 		
362 		balances[_participant] = balances[_participant].add(coins);
363 		
364 		coinIssuedMkt   = coinIssuedMkt.add(coins);
365 		coinIssuedTotal = coinIssuedTotal.add(coins);
366 		tokensIssuedTotal = tokensIssuedTotal.add(coins);
367 		
368 		coinLocked[_participant] = true;
369 		
370 		Transfer(0x0, _participant, coins);
371 		CoinMinted(_participant, coins, balances[_participant]);
372   	}
373   	
374   	function mintIcoTokenMultiple(address[] _addresses, uint[] _amounts) onlyOwner public
375   	{
376 		uint coins = 0;
377 		
378 		for (uint i = 0; i < _addresses.length; i++)
379 		{
380 		    coins = _amounts[i] * E18;
381 		    
382 		    balances[_addresses[i]] = balances[_addresses[i]].add(coins);
383     
384 		    coinIssuedIco       = coinIssuedIco.add(coins);
385 		    coinIssuedTotal     = coinIssuedTotal.add(coins);
386 		    tokensIssuedTotal   = tokensIssuedTotal.add(coins);
387     
388 		    coinLocked[_addresses[i]] = true;
389 		    Transfer(0x0, _addresses[i], coins);
390 	        CoinMinted(_addresses[i], coins, balances[_addresses[i]]);
391 		}
392   	}
393   	
394   	function ownerWithdraw() external onlyOwner
395 	{
396 		uint amount = this.balance;
397 		wallet.transfer(amount);
398 		WithDraw(msg.sender, amount);
399   	}
400   	
401   	function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner public returns (bool success)
402 	{
403   		return ERC20Interface(tokenAddress).transfer(owner, amount);
404   	}
405   	
406   	function transfer(address _to, uint _amount) public returns (bool success)
407 	{
408 		require( isTransferable() );
409 		require( coinLocked[msg.sender] == false );
410 		require( coinLocked[_to] == false );
411 		return super.transfer(_to, _amount);
412   	}
413   	
414   	function transferFrom(address _from, address _to, uint _amount) public returns (bool success)
415 	{
416 		require( isTransferable() );
417 		require( coinLocked[_from] == false );
418 		require( coinLocked[_to] == false );
419 		return super.transferFrom(_from, _to, _amount);
420   	}
421 
422   	function transferMultiple(address[] _addresses, uint[] _amounts) external
423   	{
424 		require( isTransferable() );
425 		require( coinLocked[msg.sender] == false );
426 		require( _addresses.length == _amounts.length );
427 		
428 		for (uint i = 0; i < _addresses.length; i++)
429 		{
430   			if (coinLocked[_addresses[i]] == false) 
431 			{
432 				super.transfer(_addresses[i], _amounts[i]);
433 			}
434 		}
435   	}
436 
437   	function reclaimFunds() external
438 	{
439 		uint coins;
440 		uint amount;
441 
442 		require( atNow() > mainSaleSecondEndDate );
443 		require( !refundClaimed[msg.sender] );
444 		require( icoEtherContributed[msg.sender] > 0 );
445 
446 		coins = icoCoinReceived[msg.sender];
447 		amount = icoEtherContributed[msg.sender];
448 
449 		balances[msg.sender] = balances[msg.sender].sub(coins);
450 		tokensIssuedTotal    = tokensIssuedTotal.sub(coins);
451 
452 		refundClaimed[msg.sender] = true;
453 
454 		msg.sender.transfer(amount);
455 
456 		Transfer(msg.sender, 0x0, coins);
457 		Refund(msg.sender, amount, coins);
458   	}
459   	
460     function transferToOwner(address _from) onlyOwner public
461     {
462 		require( coinLocked[_from] == false );
463         uint amount = balanceOf(_from);
464         
465         balances[_from] = balances[_from].sub(amount);
466         balances[owner] = balances[owner].add(amount);
467         
468         Transfer(_from, owner, amount);
469         OwnerReclaim(_from, owner, amount);
470     }
471 
472 	function burnIcoCoins() onlyOwner public returns (bool success)
473 	{
474 	    uint coins = 1400000000 * E18;
475 	    coins = coins.sub(coinIssuedIco);
476 	    
477 	    address burner = msg.sender;
478 	    
479 		balances[burner] = balances[burner].add(coins);
480 		
481 		coinIssuedTotal = coinIssuedTotal.add(coins);
482 		coinIssuedIco   = coinIssuedIco.add(coins);
483 		tokensIssuedTotal = tokensIssuedTotal.add(coins);
484 		
485 		Transfer(0x0, burner, coins);
486 		
487         coinIssuedTotal = coinIssuedTotal.sub(coins);
488         coinIssuedIco = coinIssuedIco.sub(coins);
489         coinBurnIco = coinBurnIco.add(coins);
490 		
491 		return super.burn(coins);
492 	}
493 
494 	function burnMktCoins() onlyOwner public returns (bool success)
495 	{
496 	    uint coins = 600000000 * E18;
497 	    coins = coins.sub(coinIssuedMkt);
498 	    
499 	    address burner = msg.sender;
500 	    
501 		balances[burner] = balances[burner].add(coins);
502 		
503 		coinIssuedTotal = coinIssuedTotal.add(coins);
504 		coinIssuedIco   = coinIssuedIco.add(coins);
505 		tokensIssuedTotal = tokensIssuedTotal.add(coins);
506 		
507 		Transfer(0x0, burner, coins);
508 		
509         coinIssuedTotal = coinIssuedTotal.sub(coins);
510         coinIssuedMkt = coinIssuedMkt.sub(coins);
511         coinBurnMkt = coinBurnMkt.add(coins);
512 		
513 		return super.burn(coins);
514 	}
515 
516 }