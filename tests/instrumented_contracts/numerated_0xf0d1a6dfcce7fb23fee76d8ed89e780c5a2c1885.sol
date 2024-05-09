1 pragma solidity ^0.4.18;
2 
3 /*
4 VERSION DATE: 04/06/2018
5 
6 CREATED BY: CRYPTO SPORTZ
7 ENJOY YOUR TEAM AND SPORTS AND EMAIL US IF YOU HAVE ANY QUESTIONS
8 */
9 
10 contract ERC721Abstract
11 {
12 	function implementsERC721() public pure returns (bool);
13 	function balanceOf(address _owner) public view returns (uint256 balance);
14 	function ownerOf(uint256 _tokenId) public view returns (address owner);
15 	function approve(address _to, uint256 _tokenId) public;
16 	function transferFrom(address _from, address _to, uint256 _tokenId) public;
17 	function transfer(address _to, uint256 _tokenId) public;
18  
19 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
20 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21 
22 	// Optional
23 	// function totalSupply() public view returns (uint256 total);
24 	// function name() public view returns (string name);
25 	// function symbol() public view returns (string symbol);
26 	// function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
27 	// function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
28 }
29 
30 contract ERC721 is ERC721Abstract
31 {
32 	string constant public   name = "CryptoSportZ";
33 	string constant public symbol = "CSZ";
34 
35 	uint256 public totalSupply;
36 	struct Token
37 	{
38 		uint256 price;			//  value of stake
39 		uint256	option;			//  [payout]96[idGame]64[combination]32[dateBuy]0
40 	}
41 	mapping (uint256 => Token) tokens;
42 	
43 	// A mapping from tokens IDs to the address that owns them. All tokens have some valid owner address
44 	mapping (uint256 => address) public tokenIndexToOwner;
45 	
46 	// A mapping from owner address to count of tokens that address owns.	
47 	mapping (address => uint256) ownershipTokenCount; 
48 
49 	// A mapping from tokenIDs to an address that has been approved to call transferFrom().
50 	// Each token can only have one approved address for transfer at any time.
51 	// A zero value means no approval is outstanding.
52 	mapping (uint256 => address) public tokenIndexToApproved;
53 	
54 	function implementsERC721() public pure returns (bool)
55 	{
56 		return true;
57 	}
58 
59 	function balanceOf(address _owner) public view returns (uint256 count) 
60 	{
61 		return ownershipTokenCount[_owner];
62 	}
63 	
64 	function ownerOf(uint256 _tokenId) public view returns (address owner)
65 	{
66 		owner = tokenIndexToOwner[_tokenId];
67 		require(owner != address(0));
68 	}
69 	
70 	// Marks an address as being approved for transferFrom(), overwriting any previous approval. 
71 	// Setting _approved to address(0) clears all transfer approval.
72 	function _approve(uint256 _tokenId, address _approved) internal 
73 	{
74 		tokenIndexToApproved[_tokenId] = _approved;
75 	}
76 	
77 	// Checks if a given address currently has transferApproval for a particular token.
78 	// param _claimant the address we are confirming token is approved for.
79 	// param _tokenId token id, only valid when > 0
80 	function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
81 		return tokenIndexToApproved[_tokenId] == _claimant;
82 	}
83 	
84 	function approve( address _to, uint256 _tokenId ) public
85 	{
86 		// Only an owner can grant transfer approval.
87 		require(_owns(msg.sender, _tokenId));
88 
89 		// Register the approval (replacing any previous approval).
90 		_approve(_tokenId, _to);
91 
92 		// Emit approval event.
93 		Approval(msg.sender, _to, _tokenId);
94 	}
95 	
96 	function transferFrom( address _from, address _to, uint256 _tokenId ) public
97 	{
98 		// Check for approval and valid ownership
99 		require(_approvedFor(msg.sender, _tokenId));
100 		require(_owns(_from, _tokenId));
101 
102 		// Reassign ownership (also clears pending approvals and emits Transfer event).
103 		_transfer(_from, _to, _tokenId);
104 	}
105 	
106 	function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
107 		return tokenIndexToOwner[_tokenId] == _claimant;
108 	}
109 	
110 	function _transfer(address _from, address _to, uint256 _tokenId) internal 
111 	{
112 		ownershipTokenCount[_to]++;
113 		tokenIndexToOwner[_tokenId] = _to;
114 
115 		if (_from != address(0)) 
116 		{
117 			ownershipTokenCount[_from]--;
118 			// clear any previously approved ownership exchange
119 			delete tokenIndexToApproved[_tokenId];
120 			Transfer(_from, _to, _tokenId);
121 		}
122 
123 	}
124 	
125 	function transfer(address _to, uint256 _tokenId) public
126 	{
127 		require(_to != address(0));
128 		require(_owns(msg.sender, _tokenId));
129 		_transfer(msg.sender, _to, _tokenId);
130 	}
131 
132 }
133 
134 contract Owned 
135 {
136     address private candidate;
137 	address public owner;
138 
139 	mapping(address => bool) public admins;
140 	
141     function Owned() public 
142 	{
143         owner = msg.sender;
144     }
145 
146     function changeOwner(address newOwner) public 
147 	{
148 		require(msg.sender == owner);
149         candidate = newOwner;
150     }
151 	
152 	function confirmOwner() public 
153 	{
154         require(candidate == msg.sender); // run by name=candidate
155 		owner = candidate;
156     }
157 	
158     function addAdmin(address addr) external 
159 	{
160 		require(msg.sender == owner);
161         admins[addr] = true;
162     }
163 
164     function removeAdmin(address addr) external
165 	{
166 		require(msg.sender == owner);
167         admins[addr] = false;
168     }
169 }
170 
171 contract Functional
172 {
173 	// parseInt(parseFloat*10^_b)
174 	function parseInt(string _a, uint _b) internal pure returns (uint) 
175 	{
176 		bytes memory bresult = bytes(_a);
177 		uint mint = 0;
178 		bool decimals = false;
179 		for (uint i=0; i<bresult.length; i++){
180 			if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
181 				if (decimals){
182 				   if (_b == 0) break;
183 					else _b--;
184 				}
185 				mint *= 10;
186 				mint += uint(bresult[i]) - 48;
187 			} else if (bresult[i] == 46) decimals = true;
188 		}
189 		if (_b > 0) mint *= 10**_b;
190 		return mint;
191 	}
192 	
193 	function uint2str(uint i) internal pure returns (string)
194 	{
195 		if (i == 0) return "0";
196 		uint j = i;
197 		uint len;
198 		while (j != 0){
199 			len++;
200 			j /= 10;
201 		}
202 		bytes memory bstr = new bytes(len);
203 		uint k = len - 1;
204 		while (i != 0){
205 			bstr[k--] = byte(48 + i % 10);
206 			i /= 10;
207 		}
208 		return string(bstr);
209 	}
210 	
211 	function strConcat(string _a, string _b, string _c) internal pure returns (string)
212 	{
213 		bytes memory _ba = bytes(_a);
214 		bytes memory _bb = bytes(_b);
215 		bytes memory _bc = bytes(_c);
216 		string memory abc;
217 		uint k = 0;
218 		uint i;
219 		bytes memory babc;
220 		if (_ba.length==0)
221 		{
222 			abc = new string(_bc.length);
223 			babc = bytes(abc);
224 		}
225 		else
226 		{
227 			abc = new string(_ba.length + _bb.length+ _bc.length);
228 			babc = bytes(abc);
229 			for (i = 0; i < _ba.length; i++) babc[k++] = _ba[i];
230 			for (i = 0; i < _bb.length; i++) babc[k++] = _bb[i];
231 		}
232         for (i = 0; i < _bc.length; i++) babc[k++] = _bc[i];
233 		return string(babc);
234 	}
235 	
236 	function timenow() public view returns(uint32) { return uint32(block.timestamp); }
237 }
238 
239 contract CryptoSportZ is ERC721, Functional, Owned
240 {
241 	uint256 public feeGame;
242 	
243 	enum Status {
244 		NOTFOUND,		//0 game not created
245 		PLAYING,		//1 buying tickets
246 		PROCESSING,		//2 waiting for result
247 		PAYING,	 		//3 redeeming
248 		CANCELING		//4 canceling the game
249 	}
250 	
251 	struct Game {
252 		string  nameGame;
253 		uint32  countCombinations;
254 		uint32  dateStopBuy;
255 		uint32  winCombination;
256 		uint256 betsSumIn;				// amount bets
257 		uint256 feeValue;				// amount fee
258 		Status status;					// status of game
259 		bool isFreezing;
260 	}
261 
262 	mapping (uint256 => Game) private game;
263 	uint32 public countGames;
264 	
265 	uint32 private constant shiftGame = 0;
266 	uint32 private constant FEECONTRACT = 5;
267 	
268 	struct Stake {
269 		uint256 sum;		// amount bets
270 		uint32 count;		// count bets 
271 	}
272 	mapping(uint32 => mapping (uint32 => Stake)) public betsAll; // ID-game => combination => Stake
273 	mapping(bytes32 => uint32) private queryRes;  // ID-query => ID-game
274 	
275 	event LogEvent(string _event, string nameGame, uint256 value);
276 	event LogToken(string _event, address user, uint32 idGame, uint256 idToken, uint32 combination, uint256 amount);
277 
278     modifier onlyOwner {
279         require(msg.sender == owner);
280         _;
281     }
282 	
283 	modifier onlyAdmin {
284         require(msg.sender == owner || admins[msg.sender]);
285         _;
286     }
287 
288 	function getPriceTicket() public view returns ( uint32 )
289 	{
290 		if ( timenow() >= 1531339200 ) return 8000;	// after 11.07 20:00
291 		if ( timenow() >= 1530993600 ) return 4000;	// after 07.07 20:00
292 		if ( timenow() >= 1530648000 ) return 2000;	// after 03.06 20:00
293 		if ( timenow() >= 1530302400 ) return 1000;	// after 29.06 20:00
294 		if ( timenow() >= 1529870400 ) return 500;	// after 24.06 20:00
295 		if ( timenow() >= 1529438400 ) return 400;	// after 19.06 20:00
296 		if ( timenow() >= 1529006400 ) return 300;	// after 14.06 20:00
297 		if ( timenow() >= 1528747200 ) return 200;	// after 11.06 20:00
298 		if ( timenow() >= 1528401600 ) return 100;	// after 07.06 20:00
299 		return 50;
300 	}
301 	
302 	function getGameByID(uint32 _id) public view returns (
303 		string  nameGame,
304 		uint32 countCombinations,
305 		uint32 dateStopBuy,
306 		uint32 priceTicket,
307 		uint32 winCombination,
308 		uint32 betsCount,
309 		uint256 betsSumIn,
310 		uint256 feeValue,
311 		Status status,
312 		bool isFreezing
313 	){
314 		Game storage gm = game[_id];
315 		nameGame = gm.nameGame;
316 		countCombinations = gm.countCombinations;
317 		dateStopBuy = gm.dateStopBuy;
318 		priceTicket = getPriceTicket();
319 		winCombination = gm.winCombination;
320 		betsCount = getCountTokensByGame(_id);
321 		betsSumIn = gm.betsSumIn;  
322 		if (betsSumIn==0) betsSumIn = getSumInByGame(_id);
323 		feeValue = gm.feeValue;
324 		status = gm.status;
325 		if ( status == Status.PLAYING && timenow() > dateStopBuy ) status = Status.PROCESSING;
326 		isFreezing = gm.isFreezing;
327 	}
328 	
329 	function getBetsMas(uint32 idGame) public view returns (uint32[33])
330 	{
331 		Game storage curGame = game[idGame];
332 		uint32[33] memory res;
333 		for(uint32 i=1;i<=curGame.countCombinations;i++) res[i] = betsAll[idGame][i].count;
334 		return res;
335 	}
336 	
337 	function getCountTokensByGame(uint32 idGame) internal view returns (uint32)
338 	{
339 		Game storage curGame = game[idGame];
340 		uint32 count = 0;
341 		for(uint32 i=1;i<=curGame.countCombinations;i++) count += betsAll[idGame][i].count;
342 		return count;
343 	}
344 	
345 	function getSumInByGame(uint32 idGame) internal view returns (uint256)
346 	{
347 		Game storage curGame = game[idGame];
348 		uint256 sum = 0;
349 		for(uint32 i=1;i<=curGame.countCombinations;i++) sum += betsAll[idGame][i].sum;
350 		return sum;
351 	}
352 	
353 	function getTokenByID(uint256 _id) public view returns ( 
354 			uint256 price,
355 			uint256 payment,
356 			uint32 combination,
357 			uint32 dateBuy,
358 			uint32 idGame,
359 			address ownerToken,
360 			bool payout
361 	){
362 		Token storage tkn = tokens[_id];
363 
364 		price = tkn.price;
365 		
366 		uint256 packed = tkn.option;
367 		payout 		= uint8((packed >> (12*8)) & 0xFF)==1?true:false;
368 		idGame  	= uint32((packed >> (8*8)) & 0xFFFFFFFF);
369 		combination = uint32((packed >> (4*8)) & 0xFFFFFFFF);
370 		dateBuy     = uint32(packed & 0xFFFFFFFF);
371 
372 		payment = 0;
373 		Game storage curGame = game[idGame];
374 		
375 		uint256 betsSumIn = curGame.betsSumIn;  
376 		if (betsSumIn==0) betsSumIn = getSumInByGame(idGame);
377 
378 		if (curGame.winCombination==combination) payment = betsSumIn / betsAll[idGame][ curGame.winCombination ].count;
379 		if (curGame.status == Status.CANCELING) payment = tkn.price;
380 		
381 		ownerToken = tokenIndexToOwner[_id];
382 	}
383 
384 	function getUserTokens(address user, uint32 count) public view returns ( string res )
385 	{
386 		res="";
387 		require(user!=0x0);
388 		uint32 findCount=0;
389 		for (uint256 i = totalSupply-1; i >= 0; i--)
390 		{
391 			if(i>totalSupply) break;
392 			if (user == tokenIndexToOwner[i]) 
393 			{
394 				res = strConcat( res, ",", uint2str(i) );
395 				findCount++;
396 				if (count!=0 && findCount>=count) break;
397 			}
398 		}
399 	}
400 	
401 	function getUserTokensByGame(address user, uint32 idGame) public view returns ( string res )
402 	{
403 		res="";
404 		require(user!=0x0);
405 		for(uint256 i=0;i<totalSupply;i++) 
406 		{
407 			if (user == tokenIndexToOwner[i]) 
408 			{
409 				uint256 packed = tokens[i].option;
410 				uint32 idGameToken = uint32((packed >> (8*8)) & 0xFFFFFFFF);
411 				if (idGameToken == idGame) res = strConcat( res, ",", uint2str(i) );
412 			}
413 		}
414 	}
415 	
416 	function getTokensByGame(uint32 idGame) public view returns (string res)
417 	{
418 		res="";
419 		for(uint256 i=0;i<totalSupply;i++) 
420 		{
421 			uint256 packed = tokens[i].option;
422 			uint32 idGameToken = uint32((packed >> (8*8)) & 0xFFFFFFFF);
423 			if (idGameToken == idGame) res = strConcat( res, ",", uint2str(i) );
424 		}
425 	}	
426 	
427 	function getStatGames() public view returns ( 
428 			uint32 countAll,
429 			uint32 countPlaying,
430 			uint32 countProcessing,
431 			string listPlaying,
432 			string listProcessing
433 	){
434 		countAll = countGames;
435 		countPlaying = 0;
436 		countProcessing = 0;
437 		listPlaying="";
438 		listProcessing="";
439 		uint32 curtime = timenow();
440 		for(uint32 i=shiftGame; i<countAll+shiftGame; i++)
441 		{
442 			if (game[i].status!=Status.PLAYING) continue;
443 			if (curtime <  game[i].dateStopBuy) { countPlaying++; listPlaying = strConcat( listPlaying, ",", uint2str(i) ); }
444 			if (curtime >= game[i].dateStopBuy) { countProcessing++; listProcessing = strConcat( listProcessing, ",", uint2str(i) ); }
445 		}
446 	}
447 	function CryptoSportZ() public 
448 	{
449 	}
450 
451 	function freezeGame(uint32 idGame, bool freeze) public onlyAdmin 
452 	{
453 		Game storage curGame = game[idGame];
454 		require( curGame.isFreezing != freeze );
455 		curGame.isFreezing = freeze; 
456 	}
457 	
458 	function addGame( string _nameGame ) onlyAdmin public 
459 	{
460 		require( bytes(_nameGame).length > 2 );
461 
462 		Game memory _game;
463 		_game.nameGame = _nameGame;
464 		_game.countCombinations = 32;
465 		_game.dateStopBuy = 1531666800;
466 		_game.status = Status.PLAYING;
467 
468 		uint256 newGameId = countGames + shiftGame;
469 		game[newGameId] = _game;
470 		countGames++;
471 		
472 		LogEvent( "AddGame", _nameGame, newGameId );
473 	}
474 
475 	function () payable public { require (msg.value == 0x0); }
476 	
477 	function buyToken(uint32 idGame, uint32 combination, address captainAddress) payable public
478 	{
479 		Game storage curGame = game[idGame];
480 		require( curGame.status == Status.PLAYING );
481 		require( timenow() < curGame.dateStopBuy );
482 		require( combination > 0 && combination <= curGame.countCombinations );
483 		require( curGame.isFreezing == false );
484 		
485 		uint256 userStake = msg.value;
486 		uint256 ticketPrice = uint256(getPriceTicket()) * 1 finney;
487 		
488 		// check money for stake
489 		require( userStake >= ticketPrice );
490 		
491 		if ( userStake > ticketPrice )
492 		{
493 			uint256 change = userStake - ticketPrice;
494 			userStake = userStake - change;
495 			require( userStake == ticketPrice );
496 			msg.sender.transfer(change);
497 		}
498 		
499 		uint256 feeValue = userStake * FEECONTRACT / 100;		// fee for contract
500 
501 		if (captainAddress!=0x0 && captainAddress != msg.sender) 
502 		{
503 			uint256 captainValue = feeValue * 20 / 100;		// bonus for captain = 1%
504 			feeValue = feeValue - captainValue;
505 			captainAddress.transfer(captainValue);
506 		}
507 
508 		userStake = userStake - feeValue;	
509 		curGame.feeValue  = curGame.feeValue + feeValue;
510 		
511 		betsAll[idGame][combination].sum += userStake;
512 		betsAll[idGame][combination].count += 1;
513 
514 		uint256 packed;
515 		packed = ( uint128(idGame) << 8*8 ) + ( uint128(combination) << 4*8 ) + uint128(block.timestamp);
516 
517 		Token memory _token = Token({
518 			price: userStake,
519 			option : packed
520 		});
521 
522 		uint256 newTokenId = totalSupply++;
523 		tokens[newTokenId] = _token;
524 		_transfer(0x0, msg.sender, newTokenId);
525 		LogToken( "Buy", msg.sender, idGame, newTokenId, combination, userStake);
526 	}
527 	
528 	// take win money or money for canceling game
529 	function redeemToken(uint256 _tokenId) public 
530 	{
531 		Token storage tkn = tokens[_tokenId];
532 
533 		uint256 packed = tkn.option;
534 		bool payout = uint8((packed >> (12*8)) & 0xFF)==1?true:false;
535 		uint32 idGame = uint32((packed >> (8*8)) & 0xFFFFFFFF);
536 		uint32 combination = uint32((packed >> (4*8)) & 0xFFFFFFFF);
537 
538 		Game storage curGame = game[idGame];
539 		
540 		require( curGame.status == Status.PAYING || curGame.status == Status.CANCELING);
541 
542 		require( msg.sender == tokenIndexToOwner[_tokenId] );	// only onwer`s token
543 		require( payout == false ); // has not paid
544 		require( combination == curGame.winCombination || curGame.status == Status.CANCELING );
545 
546 		uint256 sumPayment = 0;
547 		if ( curGame.status == Status.CANCELING ) sumPayment = tkn.price;
548 		if ( curGame.status == Status.PAYING ) sumPayment = curGame.betsSumIn / betsAll[idGame][curGame.winCombination].count;
549 
550 		payout = true;
551 		packed += uint128(payout?1:0) << 12*8;
552 		tkn.option = packed;
553 	
554 		msg.sender.transfer(sumPayment);
555 		
556 		LogToken( "Redeem", msg.sender, idGame, uint32(_tokenId), combination, sumPayment);
557 	}
558 	
559 	function cancelGame(uint32 idGame) public 
560 	{
561 		Game storage curGame = game[idGame];
562 		
563 		require( curGame.status == Status.PLAYING );
564 		// only owner/admin or anybody after 60 days
565 		require( msg.sender == owner || admins[msg.sender] || timenow() > curGame.dateStopBuy + 60 days );
566 
567 		curGame.status = Status.CANCELING;
568 
569 //		LogEvent( "CancelGame", curGame.nameGame, idGame );
570 		
571 		takeFee(idGame);
572 	}
573 
574 	function resolveGameByHand(uint32 idGame, uint32 combination) onlyAdmin public 
575 	{
576 		Game storage curGame = game[idGame];
577 		
578 		require( curGame.status == Status.PLAYING );
579 		require( combination <= curGame.countCombinations );
580 		require( combination != 0 );
581 
582 		require( timenow() > curGame.dateStopBuy + 2*60*60 );
583 
584 		curGame.winCombination = combination;
585 		
586 //		LogEvent( "ResolveGameByHand", curGame.nameGame, curGame.winCombination );
587 		
588 		checkWinNobody(idGame);
589 	}
590 	
591 	function checkWinNobody(uint32 idGame) internal
592 	{
593 		Game storage curGame = game[idGame];
594 		
595 		curGame.status = Status.PAYING;
596 		curGame.betsSumIn = getSumInByGame(idGame);
597 		
598 		// nobody win = send all to feeGame
599 		if ( betsAll[idGame][curGame.winCombination].count == 0 )
600 		{
601 			if (curGame.betsSumIn+curGame.feeValue!=0) feeGame = feeGame + curGame.betsSumIn + curGame.feeValue;
602 			LogEvent( "NobodyWin", curGame.nameGame, curGame.betsSumIn+curGame.feeValue );
603 		}
604 		else 
605 			takeFee(idGame);
606 	}
607 	
608 	function takeFee(uint32 idGame) internal
609 	{
610 		Game storage curGame = game[idGame];
611 		
612 		// take fee
613 		if ( curGame.feeValue > 0 )
614 		{
615 			feeGame = feeGame + curGame.feeValue;
616 			LogEvent( "TakeFee", curGame.nameGame, curGame.feeValue );
617 		}
618 	}
619 	
620 	function withdraw() onlyOwner public
621 	{
622 		require( feeGame > 0 );
623 
624 		uint256 tmpFeeGame = feeGame;
625 		feeGame = 0;
626 		
627 		owner.transfer(tmpFeeGame);
628 //		LogEvent( "Withdraw", "", tmpFeeGame);
629 	}
630 
631 }