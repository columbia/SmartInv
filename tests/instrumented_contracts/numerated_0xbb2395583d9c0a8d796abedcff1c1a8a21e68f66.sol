1 pragma solidity ^0.4.20;
2 
3 // JohnVerToken Made By PinkCherry - insanityskan@gmail.com
4 // JohnVerToken Request Question - koreacoinsolution@gmail.com
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
59         require(_to != owner);
60 		require(_to != address(0x0));
61 		owner = _to;
62 		OwnerTransferPropose(owner, _to);
63   	}
64 
65 }
66 
67 
68 contract ERC20Interface
69 {
70   	event Transfer(address indexed _from, address indexed _to, uint _value);
71   	event Approval(address indexed _owner, address indexed _spender, uint _value);
72 
73   	function totalSupply() public constant returns (uint);
74   	function balanceOf(address _owner) public constant returns (uint balance);
75   	function transfer(address _to, uint _value) public returns (bool success);
76   	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
77   	function approve(address _spender, uint _value) public returns (bool success);
78   	function allowance(address _owner, address _spender) public constant returns (uint remaining);
79 }
80 
81 
82 contract ERC20Token is ERC20Interface, OwnerHelper
83 {
84   	using SafeMath for uint;
85 
86   	uint public tokensIssuedTotal = 0;
87   	address public constant burnAddress = 0;
88 
89   	mapping(address => uint) balances;
90   	mapping(address => mapping (address => uint)) allowed;
91 
92   	function totalSupply() public constant returns (uint)
93 	{
94 		return tokensIssuedTotal;
95   	}
96 
97   	function balanceOf(address _owner) public constant returns (uint balance)
98 	{
99 		return balances[_owner];
100   	}
101 
102 	function transfer(address _to, uint _amount) public returns (bool success)
103 	{
104 		require( balances[msg.sender] >= _amount );
105 
106 	    balances[msg.sender] = balances[msg.sender].sub(_amount);
107 		balances[_to]        = balances[_to].add(_amount);
108 
109 		Transfer(msg.sender, _to, _amount);
110     
111 		return true;
112   	}
113 
114   	function approve(address _spender, uint _amount) public returns (bool success)
115 	{
116 		require ( balances[msg.sender] >= _amount );
117 
118 		allowed[msg.sender][_spender] = _amount;
119     		
120 		Approval(msg.sender, _spender, _amount);
121 
122 		return true;
123 	}
124 
125   	function transferFrom(address _from, address _to, uint _amount) public returns (bool success)
126 	{
127 		require( balances[_from] >= _amount );
128 		require( allowed[_from][msg.sender] >= _amount );
129 		balances[_from]            = balances[_from].sub(_amount);
130 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
131 		balances[_to]              = balances[_to].add(_amount);
132 
133 		Transfer(_from, _to, _amount);
134 		return true;
135   	}
136 
137   	function allowance(address _owner, address _spender) public constant returns (uint remaining)
138 	{
139 		return allowed[_owner][_spender];
140   	}
141 }
142 
143 contract JohnVerToken is ERC20Token
144 {
145 	uint constant E18 = 10**18;
146 
147   	string public constant name 	= "JohnVerToken";
148   	string public constant symbol 	= "JVT";
149   	uint public constant decimals 	= 18;
150 
151 	address public wallet;
152 	address public adminWallet;
153 
154 	uint public constant totalTokenCap   = 7600000000 * E18;
155 	uint public constant icoTokenCap     = 4006662000 * E18;
156 	uint public constant mktTokenCap     = 3593338000 * E18;
157 
158 	uint public tokenPerEth = 3000000 * E18;
159 
160 	uint public constant privateSaleBonus	 = 50;
161 	uint public constant preSaleFirstBonus	 = 20;
162 	uint public constant preSaleSecondBonus  = 15;
163 	uint public constant mainSaleBonus  = 0;
164 	
165   	uint public constant privateSaleEtherCap = 100 ether;
166   	uint public constant preSaleFirstEtherCap = 200 ether;
167   	uint public constant preSaleSecondEtherCap = 200 ether;
168   	uint public constant mainSaleEtherCap = 7 ether;
169   	
170   	uint public constant dayToMinusToken = 3000 * E18;
171 	uint public constant dayToDate = 86400;
172 
173   	uint public constant privateSaleStartDate = 1519344000; // 2018-02-23 00:00 UTC
174   	uint public constant privateSaleEndDate   = 1519862400; // 2018-03-01 00:00 UTC
175 
176   	uint public constant preSaleFirstStartDate = 1520208000; // 2018-03-05 00:00 UTC
177   	uint public constant preSaleFirstEndDate   = 1520726400; // 2018-03-11 00:00 UTC
178 
179   	uint public constant preSaleSecondStartDate = 1521158400; // 2018-03-16 00:00 UTC
180   	uint public constant preSaleSecondEndDate   = 1521676800; // 2018-03-22 00:00 UTC
181 
182   	uint public constant mainSaleStartDate = 1522022400; // 2018-03-26 00:00 UTC
183   	uint public constant mainSaleEndDate   = 1531353600; // 2018-07-11 00:00 UTC
184 
185 	uint public constant privateSaleMinEth  = 3 ether / 10; // 0.3 Ether
186 	uint public constant preSaleMinEth      = 2 ether / 10; // 0.2 Ether
187 	uint public constant mainSaleMinEth     = 1 ether / 10; // 0.1 Ether
188 
189   	uint public icoEtherReceivedTotal = 0;
190   	uint public icoEtherReceivedPrivateSale = 0;
191   	uint public icoEtherReceivedPreFirstSale = 0;
192   	uint public icoEtherReceivedPreSecondSale = 0;
193   	uint public icoEtherReceivedMainSale = 0;
194 	uint public icoEtherReceivedMainSaleDay = 0;
195 	
196 	uint public tokenIssuedToday = 0;
197 	
198     uint public tokenIssuedTotal        = 0;
199   	uint public tokenIssuedPrivateIco   = 0;
200   	uint public tokenIssuedPreFirstIco  = 0;
201   	uint public tokenIssuedPreSecondIco = 0;
202   	uint public tokenIssuedMainSaleIco  = 0;
203   	uint public tokenIssuedMkt          = 0;
204 	uint public tokenIssuedAirDrop      = 0;
205 	uint public tokenIssuedLockUp       = 0;
206 
207   	mapping(address => uint) public icoEtherContributed;
208   	mapping(address => uint) public icoTokenReceived;
209   	mapping(address => bool) public refundClaimed;
210   	
211  	event WalletChange(address _newWallet);
212   	event AdminWalletChange(address _newAdminWallet);
213   	event TokenMinted(address indexed _owner, uint _tokens, uint _balance);
214   	event TokenAirDroped(address indexed _owner, uint _tokens, uint _balance);
215   	event TokenIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
216   	event Refund(address indexed _owner, uint _amount, uint _tokens);
217   	event LockRemove(address indexed _participant);
218 	event WithDraw(address indexed _to, uint _amount);
219 	event OwnerReclaim(address indexed _from, address indexed _owner, uint _amount);
220 
221   	function JohnVerToken() public
222 	{
223 		require( icoTokenCap + mktTokenCap == totalTokenCap );
224 		wallet = owner;
225 		adminWallet = owner;
226   	}
227 
228   	function () payable public
229 	{
230     	buyToken();
231   	}
232   	
233   	function atNow() public constant returns (uint)
234 	{
235 		return now;
236   	}
237 
238   	function buyToken() private
239 	{
240 		uint nowTime = atNow();
241 
242 		uint saleTime = 0; // 1 : privateSale, 2 : preSaleFirst, 3 : preSaleSecond, 4 : mainSale
243 
244 		uint minEth = 0;
245 		uint maxEth = 0;
246 
247 		uint tokens = 0;
248 		uint tokenBonus = 0;
249 		uint tokenMinusPerEther = 0;
250 		uint etherCap = 0;
251 
252 		uint mainSaleDay = 0;
253 		
254 		if (nowTime > privateSaleStartDate && nowTime < privateSaleEndDate)
255 		{
256 			saleTime = 1;
257 			minEth = privateSaleMinEth;
258 			tokenBonus = privateSaleBonus;
259 			etherCap = privateSaleEtherCap;
260 			maxEth = privateSaleEtherCap;
261 		}
262 
263 		if (nowTime > preSaleFirstStartDate && nowTime < preSaleFirstEndDate)
264 		{
265 			saleTime = 2;
266 			minEth = preSaleMinEth;
267 			tokenBonus = preSaleFirstBonus;
268 			etherCap = preSaleFirstEtherCap;
269 			maxEth = preSaleFirstEtherCap;
270 		}
271 
272 		if (nowTime > preSaleSecondStartDate && nowTime < preSaleSecondEndDate)
273 		{
274 			saleTime = 3;
275 			minEth = preSaleMinEth;
276 			tokenBonus = preSaleSecondBonus;
277 			etherCap = preSaleSecondEtherCap;
278 			maxEth = preSaleSecondEtherCap;
279 		}
280 
281 		if (nowTime > mainSaleStartDate && nowTime < mainSaleEndDate)
282 		{
283 			saleTime = 4;
284 			minEth = mainSaleMinEth;
285 			uint dateStartTime = 0;
286 			uint dateEndTime = 0;
287 			
288 		    for (uint i = 1; i <= 108; i++)
289 		    {
290 		        dateStartTime = 0;
291 		        dateStartTime = dateStartTime.add(i.sub(1));
292 		        dateStartTime = dateStartTime.mul(dayToDate);
293 		        dateStartTime = dateStartTime.add(mainSaleStartDate);
294 		        
295 		        dateEndTime = 0;
296 		        dateEndTime = dateEndTime.add(i.sub(1));
297 		        dateEndTime = dateEndTime.mul(dayToDate);
298 		        dateEndTime = dateEndTime.add(mainSaleEndDate);
299 		        
300   			    if (nowTime > dateStartTime && nowTime < dateEndTime) 
301 			    {
302 			    	mainSaleDay = i;
303 			    }
304 		    }
305 		    
306 		    require( mainSaleDay != 0 );
307 		    
308 		    etherCap = mainSaleEtherCap;
309 		    maxEth = mainSaleEtherCap;
310 		    tokenMinusPerEther = tokenMinusPerEther.add(dayToMinusToken);
311 		    tokenMinusPerEther = tokenMinusPerEther.mul(mainSaleDay.sub(1));
312 		}
313 		
314 		require( saleTime >= 1 && saleTime <= 4 );
315 		require( msg.value >= minEth );
316 		require( icoEtherContributed[msg.sender].add(msg.value) <= maxEth );
317 
318 		tokens = tokenPerEth.mul(msg.value) / 1 ether;
319 		tokenMinusPerEther = tokenMinusPerEther.mul(msg.value) / 1 ether;
320       	tokens = tokens.mul(100 + tokenBonus) / 100;
321       	tokens = tokens.sub(tokenMinusPerEther);
322 
323 		if(saleTime == 1)
324 		{
325 		    require( icoEtherReceivedPrivateSale.add(msg.value) <= etherCap );
326     
327 		    icoEtherReceivedPrivateSale = icoEtherReceivedPrivateSale.add(msg.value);
328 		    tokenIssuedPrivateIco = tokenIssuedPrivateIco.add(tokens);
329 		}
330 		else if(saleTime == 2)
331 		{
332 		    require( icoEtherReceivedPreFirstSale.add(msg.value) <= etherCap );
333     
334 		    icoEtherReceivedPreFirstSale = icoEtherReceivedPreFirstSale.add(msg.value);
335 		    tokenIssuedPreFirstIco = tokenIssuedPreFirstIco.add(tokens);
336 		}
337 		else if(saleTime == 3)
338 		{
339 		    require( icoEtherReceivedPreSecondSale.add(msg.value) <= etherCap );
340     
341 		    icoEtherReceivedPreSecondSale = icoEtherReceivedPreSecondSale.add(msg.value);
342 		    tokenIssuedPreSecondIco = tokenIssuedPreSecondIco.add(tokens);
343 		}
344 		else if(saleTime == 4)
345 		{
346 		    require( msg.value <= etherCap );
347 		    
348 		    if(tokenIssuedToday < mainSaleDay)
349 		    {
350 		        tokenIssuedToday = mainSaleDay;
351 		        icoEtherReceivedMainSaleDay = 0;
352 		    }
353 		    
354 		    require( icoEtherReceivedMainSaleDay.add(msg.value) <= etherCap );
355     
356 		    icoEtherReceivedMainSale = icoEtherReceivedMainSale.add(msg.value);
357 		    icoEtherReceivedMainSaleDay = icoEtherReceivedMainSaleDay.add(msg.value);
358 		    tokenIssuedMainSaleIco = tokenIssuedMainSaleIco.add(tokens);
359 		}
360 		
361 		balances[msg.sender]         = balances[msg.sender].add(tokens);
362 	    icoTokenReceived[msg.sender] = icoTokenReceived[msg.sender].add(tokens);
363 		tokensIssuedTotal            = tokensIssuedTotal.add(tokens);
364 		icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
365     
366 		Transfer(0x0, msg.sender, tokens);
367 		TokenIssued(msg.sender, tokens, balances[msg.sender], msg.value);
368 
369 		wallet.transfer(this.balance);
370   	}
371 
372  	function isTransferable() public constant returns (bool transferable)
373 	{
374 		if ( atNow() < preSaleSecondEndDate )
375 		{
376 			return false;
377 		}
378 
379 		return true;
380   	}
381 
382   	function changeWallet(address _wallet) onlyOwner public
383 	{
384     		require( _wallet != address(0x0) );
385     		wallet = _wallet;
386     		WalletChange(wallet);
387   	}
388 
389   	function changeAdminWallet(address _wallet) onlyOwner public
390 	{
391     		require( _wallet != address(0x0) );
392     		adminWallet = _wallet;
393     		AdminWalletChange(adminWallet);
394   	}
395 
396   	function mintMarketing(address _participant) onlyOwner public
397 	{
398 		uint tokens = mktTokenCap.sub(tokenIssuedAirDrop);
399 		
400 		balances[_participant] = balances[_participant].add(tokens);
401 		
402 		tokenIssuedMkt   = tokenIssuedMkt.add(tokens);
403 		tokenIssuedTotal = tokenIssuedTotal.add(tokens);
404 		
405 		Transfer(0x0, _participant, tokens);
406 		TokenMinted(_participant, tokens, balances[_participant]);
407   	}
408 
409   	function mintLockUpTokens(address _participant) onlyOwner public
410 	{
411 		require ( atNow() >= mainSaleEndDate );
412 		
413 		uint tokens = totalTokenCap.sub(tokenIssuedTotal);
414 		
415 		balances[_participant] = balances[_participant].add(tokens);
416 		
417 		tokenIssuedLockUp = tokenIssuedLockUp.add(tokens);
418 		tokenIssuedTotal = tokenIssuedTotal.add(tokens);
419 		
420 		Transfer(0x0, _participant, tokens);
421 		TokenMinted(_participant, tokens, balances[_participant]);
422   	}
423 
424   	function airDropOne(address _address, uint _amount) onlyOwner public
425   	{
426   	    uint tokens = _amount * E18;
427 		       
428 		balances[_address] = balances[_address].add(tokens);
429 		
430 		tokenIssuedAirDrop = tokenIssuedAirDrop.add(tokens);
431         tokenIssuedTotal = tokenIssuedTotal.add(tokens);
432 		
433         Transfer(0x0, _address, tokens);
434         TokenAirDroped(_address, tokens, balances[_address]);
435   	}
436 
437   	function airDropMultiple(address[] _addresses, uint[] _amounts) onlyOwner public
438   	{
439 		require( _addresses.length == _amounts.length );
440 		
441   	    uint tokens = 0;
442   	    
443 		for (uint i = 0; i < _addresses.length; i++)
444 		{
445 		        tokens = _amounts[i] * E18;
446 				
447 		        balances[_addresses[i]] = balances[_addresses[i]].add(tokens);
448 		
449 				tokenIssuedAirDrop = tokenIssuedAirDrop.add(tokens);
450 		        tokenIssuedTotal = tokenIssuedTotal.add(tokens);
451 		
452 		        Transfer(0x0, _addresses[i], tokens);
453 		        TokenAirDroped(_addresses[i], tokens, balances[_addresses[i]]);
454 		}
455   	}
456 
457   	function airDropMultipleSame(address[] _addresses, uint _amount) onlyOwner public
458   	{
459   	    uint tokens = _amount * E18;
460   	    
461 		for (uint i = 0; i < _addresses.length; i++)
462 		{
463 		        balances[_addresses[i]] = balances[_addresses[i]].add(tokens);
464 		
465 				tokenIssuedAirDrop = tokenIssuedAirDrop.add(tokens);
466 		        tokenIssuedTotal = tokenIssuedTotal.add(tokens);
467 		
468 		        Transfer(0x0, _addresses[i], tokens);
469 		        TokenAirDroped(_addresses[i], tokens, balances[_addresses[i]]);
470 		}
471   	}
472   	
473   	function ownerWithdraw() external onlyOwner
474 	{
475 		uint amount = this.balance;
476 		wallet.transfer(amount);
477 		WithDraw(msg.sender, amount);
478   	}
479   	
480   	function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner public returns (bool success)
481 	{
482   		return ERC20Interface(tokenAddress).transfer(owner, amount);
483   	}
484   	
485   	function transfer(address _to, uint _amount) public returns (bool success)
486 	{
487 		require( isTransferable() );
488 		
489 		return super.transfer(_to, _amount);
490   	}
491   	
492   	function transferFrom(address _from, address _to, uint _amount) public returns (bool success)
493 	{
494 		require( isTransferable() );
495 		
496 		return super.transferFrom(_from, _to, _amount);
497   	}
498 
499   	function transferMultiple(address[] _addresses, uint[] _amounts) external
500   	{
501 		require( isTransferable() );
502 		require( _addresses.length == _amounts.length );
503 		
504 		for (uint i = 0; i < _addresses.length; i++)
505 		{
506 			super.transfer(_addresses[i], _amounts[i]);
507 		}
508   	}
509 
510   	function reclaimFunds() external
511 	{
512 		uint tokens;
513 		uint amount;
514 
515 		require( atNow() > preSaleSecondEndDate );
516 		require( !refundClaimed[msg.sender] );
517 		require( icoEtherContributed[msg.sender] > 0 );
518 
519 		tokens = icoTokenReceived[msg.sender];
520 		amount = icoEtherContributed[msg.sender];
521 
522 		balances[msg.sender] = balances[msg.sender].sub(tokens);
523 		tokensIssuedTotal    = tokensIssuedTotal.sub(tokens);
524 
525 		refundClaimed[msg.sender] = true;
526 
527 		msg.sender.transfer(amount);
528 
529 		Transfer(msg.sender, 0x0, tokens);
530 		Refund(msg.sender, amount, tokens);
531   	}
532   	
533     function transferToOwner(address _from) onlyOwner public
534     {
535         uint amount = balanceOf(_from);
536         
537         balances[_from] = balances[_from].sub(amount);
538         balances[owner] = balances[owner].add(amount);
539         
540         Transfer(_from, owner, amount);
541         OwnerReclaim(_from, owner, amount);
542     }
543 }