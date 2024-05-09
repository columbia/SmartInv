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
160   	string public constant name 	= "Lee Sung Coin";
161   	string public constant symbol 	= "LSC";
162   	uint public constant decimals 	= 18;
163 
164 	address public wallet;
165 	address public adminWallet;
166 
167 	uint public constant totalCoinCap   = 200000000 * E18;
168 	uint public constant icoCoinCap     = 140000000 * E18;
169 	uint public constant mktCoinCap     =  60000000 * E18;
170 	uint public constant preSaleCoinCap =  48000000 * E18;
171 
172 	uint public coinPerEth = 20000 * E18;
173 
174 	uint public constant privateSaleBonus	 = 30;
175 	uint public constant preSaleFirstBonus	 = 20;
176 	uint public constant preSaleSecondBonus  = 15;
177 	uint public constant mainSaleFirstBonus	 = 5;
178 	uint public constant mainSaleSecondBonus = 0;
179 
180   	uint public constant preSaleFirstStartDate = 1517788800; // 2018-02-05 00:00 UTC
181   	uint public constant preSaleFirstEndDate   = 1518307200; // 2018-02-11 00:00 UTC
182 
183   	uint public constant preSaleSecondStartDate = 1518393600; // 2018-02-12 00:00 UTC
184   	uint public constant preSaleSecondEndDate   = 1518912000; // 2018-02-18 00:00 UTC
185 
186 
187   	uint public constant mainSaleFirstStartDate = 1519603200; // 2018-02-26 00:00 UTC
188   	uint public constant mainSaleFirstEndDate   = 1520121600; // 2018-03-04 00:00 UTC
189 
190   	uint public constant mainSaleSecondStartDate = 1520208000; // 2018-03-05 00:00 UTC
191   	uint public constant mainSaleSecondEndDate   = 1520726400; // 2018-03-11 00:00 UTC
192 
193 	uint public constant transferCooldown = 2 days;
194 
195 	uint public constant preSaleMinEth  = 1 ether;
196 	uint public constant mainSaleMinEth =  1 ether / 2; // 0.5 Ether
197 
198   	uint public icoEtherReceived = 0; // Ether actually received by the contract
199 
200     uint public coinIssuedTotal     = 0;
201   	uint public coinIssuedIco       = 0;
202   	uint public coinIssuedMkt       = 0;
203 	uint public coinIssuedPrivate   = 0;
204 	
205 	uint public coinBurnIco = 0;
206 	uint public coinBurnMkt = 0;
207 
208   	mapping(address => uint) public icoEtherContributed;
209   	mapping(address => uint) public icoCoinReceived;
210   	mapping(address => bool) public refundClaimed;
211   	mapping(address => bool) public coinLocked;
212   	
213  	event WalletChange(address _newWallet);
214   	event AdminWalletChange(address _newAdminWallet);
215   	event CoinMinted(address indexed _owner, uint _tokens, uint _balance);
216   	event CoinIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
217   	event Refund(address indexed _owner, uint _amount, uint _tokens);
218   	event LockRemove(address indexed _participant);
219 	event WithDraw(address indexed _to, uint _amount);
220 	event OwnerReclaim(address indexed _from, address indexed _owner, uint _amount);
221 
222   	function LeeSungCoin() public
223 	{
224 		require( icoCoinCap + mktCoinCap == totalCoinCap );
225 		wallet = owner;
226 		adminWallet = owner;
227   	}
228 
229   	function () payable public
230 	{
231     	buyCoin();
232   	}
233   	
234   	function atNow() public constant returns (uint)
235 	{
236 		return now;
237   	}
238 
239   	function buyCoin() private
240 	{
241 		uint nowTime = atNow();
242 
243 		uint saleTime = 0; // 1 : preSaleFirst, 2 : preSaleSecond, 3 : mainSaleFirst, 4 : mainSaleSecond
244 
245 		uint minEth = 0;
246 		uint maxEth = 300 ether;
247 
248 		uint coins = 0;
249 		uint coinBonus = 0;
250 		uint coinCap = 0;
251 
252 		if (nowTime > preSaleFirstStartDate && nowTime < preSaleFirstEndDate)
253 		{
254 			saleTime = 1;
255 			minEth = preSaleMinEth;
256 			coinBonus = preSaleFirstBonus;
257 			coinCap = preSaleCoinCap;
258 		}
259 
260 		if (nowTime > preSaleSecondStartDate && nowTime < preSaleSecondEndDate)
261 		{
262 			saleTime = 2;
263 			minEth = preSaleMinEth;
264 			coinBonus = preSaleSecondBonus;
265 			coinCap = preSaleCoinCap;
266 		}
267 
268 		if (nowTime > mainSaleFirstStartDate && nowTime < mainSaleFirstEndDate)
269 		{
270 			saleTime = 3;
271 			minEth = mainSaleMinEth;
272 			coinBonus = mainSaleFirstBonus;
273 			coinCap = icoCoinCap;
274 		}
275 
276 		if (nowTime > mainSaleSecondStartDate && nowTime < mainSaleSecondEndDate)
277 		{
278 			saleTime = 4;
279 			minEth = mainSaleMinEth;
280 			coinBonus = mainSaleSecondBonus;
281 			coinCap = icoCoinCap;
282 		}
283 		
284 		require( saleTime >= 1 && saleTime <= 4 );
285 		require( msg.value >= minEth );
286 		require( icoEtherContributed[msg.sender].add(msg.value) <= maxEth );
287 
288 		coins = coinPerEth.mul(msg.value) / 1 ether;
289       	coins = coins.mul(100 + coinBonus) / 100;
290 
291 		require( coinIssuedIco.add(coins) <= coinCap );
292 
293 		balances[msg.sender]        = balances[msg.sender].add(coins);
294 	    icoCoinReceived[msg.sender] = icoCoinReceived[msg.sender].add(coins);
295 		coinIssuedIco               = coinIssuedIco.add(coins);
296 		tokensIssuedTotal           = tokensIssuedTotal.add(coins);
297     
298 		icoEtherReceived                = icoEtherReceived.add(msg.value);
299 		icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
300     
301 		coinLocked[msg.sender] = true;
302     
303 		Transfer(0x0, msg.sender, coins);
304 		CoinIssued(msg.sender, coins, balances[msg.sender], msg.value);
305 
306 		wallet.transfer(this.balance);
307   	}
308 
309  	function isTransferable() public constant returns (bool transferable)
310 	{
311 		if ( atNow() < mainSaleSecondEndDate + transferCooldown )
312 		{
313 			return false;
314 		}
315 
316 		return true;
317   	}
318 
319 	function coinLockRemove(address _participant) public
320 	{
321 		require( msg.sender == adminWallet || msg.sender == owner );
322 		coinLocked[_participant] = false;
323 		LockRemove(_participant);
324   	}
325 
326 	function coinLockRmoveMultiple(address[] _participants) public
327 	{
328 		require( msg.sender == adminWallet || msg.sender == owner );
329     		
330 		for (uint i = 0; i < _participants.length; i++)
331 		{
332   			coinLocked[_participants[i]] = false;
333   			LockRemove(_participants[i]);
334 		}
335   	}
336 
337   	function changeWallet(address _wallet) onlyOwner public
338 	{
339     		require( _wallet != address(0x0) );
340     		wallet = _wallet;
341     		WalletChange(wallet);
342   	}
343 
344   	function changeAdminWallet(address _wallet) onlyOwner public
345 	{
346     		require( _wallet != address(0x0) );
347     		adminWallet = _wallet;
348     		AdminWalletChange(adminWallet);
349   	}
350 
351   	function mintMarketing(address _participant, uint _amount) onlyOwner public
352 	{
353 		uint coins = _amount * E18;
354 		
355 		require( coins <= mktCoinCap.sub(coinIssuedMkt) );
356 		
357 		balances[_participant] = balances[_participant].add(coins);
358 		
359 		coinIssuedMkt   = coinIssuedMkt.add(coins);
360 		coinIssuedTotal = coinIssuedTotal.add(coins);
361 		
362 		coinLocked[_participant] = true;
363 		
364 		Transfer(0x0, _participant, coins);
365 		CoinMinted(_participant, coins, balances[_participant]);
366   	}
367 
368   	function mintPrivate(address _participant, uint _etherValue) onlyOwner public
369 	{
370 		uint coins = coinPerEth.mul(_etherValue);
371       	coins = coins.mul(100 + privateSaleBonus) / 100;
372 
373 		require( coins <= icoCoinCap.sub(coinIssuedIco) );
374 		require( atNow() < preSaleFirstStartDate );
375 
376 		balances[_participant] = balances[_participant].add(coins);
377 
378 		coinIssuedPrivate   = coinIssuedPrivate.add(coins);
379 		coinIssuedIco       = coinIssuedIco.add(coins);
380 		coinIssuedTotal     = coinIssuedTotal.add(coins);
381 
382 		coinLocked[_participant] = true;
383 		Transfer(0x0, _participant, coins);
384 		CoinMinted(_participant, coins, balances[_participant]);
385   	}
386   	
387   	function ownerWithdraw() external onlyOwner
388 	{
389 		uint amount = this.balance;
390 		wallet.transfer(amount);
391 		WithDraw(msg.sender, amount);
392   	}
393   	
394   	function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner public returns (bool success)
395 	{
396   		return ERC20Interface(tokenAddress).transfer(owner, amount);
397   	}
398   	
399   	function transfer(address _to, uint _amount) public returns (bool success)
400 	{
401 		require( isTransferable() );
402 		require( coinLocked[msg.sender] == false );
403 		require( coinLocked[_to] == false );
404 		return super.transfer(_to, _amount);
405   	}
406   	
407   	function transferFrom(address _from, address _to, uint _amount) public returns (bool success)
408 	{
409 		require( isTransferable() );
410 		require( coinLocked[_from] == false );
411 		require( coinLocked[_to] == false );
412 		return super.transferFrom(_from, _to, _amount);
413   	}
414 
415   	function transferMultiple(address[] _addresses, uint[] _amounts) external
416   	{
417 		require( isTransferable() );
418 		require( coinLocked[msg.sender] == false );
419 		require( _addresses.length == _amounts.length );
420 		
421 		for (uint i = 0; i < _addresses.length; i++)
422 		{
423   			if (coinLocked[_addresses[i]] == false) 
424 			{
425 				super.transfer(_addresses[i], _amounts[i]);
426 			}
427 		}
428   	}
429 
430   	function reclaimFunds() external
431 	{
432 		uint coins;
433 		uint amount;
434 
435 		require( atNow() > mainSaleSecondEndDate );
436 		require( !refundClaimed[msg.sender] );
437 		require( icoEtherContributed[msg.sender] > 0 );
438 
439 		coins = icoCoinReceived[msg.sender];
440 		amount = icoEtherContributed[msg.sender];
441 
442 		balances[msg.sender] = balances[msg.sender].sub(coins);
443 		tokensIssuedTotal    = tokensIssuedTotal.sub(coins);
444 
445 		refundClaimed[msg.sender] = true;
446 
447 		msg.sender.transfer(amount);
448 
449 		Transfer(msg.sender, 0x0, coins);
450 		Refund(msg.sender, amount, coins);
451   	}
452   	
453     function transferToOwner(address _from) onlyOwner public
454     {
455 		require( coinLocked[_from] == false );
456         uint amount = balanceOf(_from);
457         
458         balances[_from] = balances[_from].sub(amount);
459         balances[owner] = balances[owner].add(amount);
460         
461         Transfer(_from, owner, amount);
462         OwnerReclaim(_from, owner, amount);
463     }
464 
465 	function burnCoins(uint _icoAmount, uint _mktAmount) onlyOwner public returns (bool success)
466 	{
467 	    uint icoCoins = _icoAmount * E18;
468 	    uint mktCoins = _mktAmount * E18;
469 	    
470 	    uint totalBurnCoins = 0;
471 	    totalBurnCoins = totalBurnCoins.add(icoCoins);
472 	    totalBurnCoins = totalBurnCoins.add(mktCoins);
473 	    
474 	    coinBurnIco = coinBurnIco.add(icoCoins);
475 	    coinBurnMkt = coinBurnMkt.add(mktCoins);
476 	    
477 		return super.burn(totalBurnCoins);
478 	}
479 
480 }