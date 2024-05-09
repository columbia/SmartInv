1 pragma solidity ^0.4.18;
2 
3 /*
4 VERSION DATE: 23/03/2018
5 
6 CREATED BY: CRYPTO SPORTZ
7 UNJOY YOUR TEAM AND SPORTS AND EMAIL US IF YOU HAVE ANY QUESTIONS
8 */
9 
10 contract OraclizeI {
11 	address public cbAddress;
12 	function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
13 	function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
14 	function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
15 	function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
16 	function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
17 	function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
18 	function getPrice(string _datasource) public returns (uint _dsprice);
19 	function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
20 	function setProofType(byte _proofType) external;
21 	function setCustomGasPrice(uint _gasPrice) external;
22 	function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
23 }
24 contract OraclizeAddrResolverI {
25 	function getAddress() public returns (address _addr);
26 }
27 contract usingOraclize {
28 	
29 	uint8 constant networkID_auto = 0;
30 	uint8 constant networkID_mainnet = 1;
31 	uint8 constant networkID_testnet = 2;
32 	uint8 constant networkID_morden = 2;
33 	uint8 constant networkID_consensys = 161;
34 
35 	OraclizeAddrResolverI OAR;
36 
37 	OraclizeI oraclize;
38 	modifier oraclizeAPI 
39 	{
40 		if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
41 			oraclize_setNetwork(networkID_auto);
42 
43 		if(address(oraclize) != OAR.getAddress())
44 			oraclize = OraclizeI(OAR.getAddress());
45 
46 		_;
47 	}
48 	modifier coupon(string code){
49 		oraclize = OraclizeI(OAR.getAddress());
50 		_;
51 	}
52 
53 	function oraclize_setNetwork(uint8 networkID) internal returns(bool)
54 	{
55 		return oraclize_setNetwork();
56 		networkID; // silence the warning and remain backwards compatible
57 	}
58 	
59 	function oraclize_setNetwork() internal returns(bool)
60 	{
61 		if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
62 			OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
63 			return true;
64 		}
65 
66 		if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
67 			OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
68 			return true;
69 		}
70 
71 		return false;
72 	}
73 	
74 	function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
75 		uint price = oraclize.getPrice(datasource, gaslimit);
76 		if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
77 		return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
78 	}
79 
80     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
81         uint price = oraclize.getPrice(datasource, gaslimit);
82         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
83         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
84 	}
85 	
86 	function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
87 		return oraclize.getPrice(datasource);
88 	}
89 
90 	function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
91 		return oraclize.getPrice(datasource, gaslimit);
92 	}
93 
94     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
95         return oraclize.setCustomGasPrice(gasPrice);
96     }
97 	
98 	function oraclize_cbAddress() oraclizeAPI internal returns (address){
99 		return oraclize.cbAddress();
100 	}
101 
102 	function getCodeSize(address _addr) constant internal returns(uint _size) {
103 		assembly {
104 			_size := extcodesize(_addr)
105 		}
106 	}
107 
108 }
109 
110 contract ERC721Abstract
111 {
112 	function implementsERC721() public pure returns (bool);
113 	function balanceOf(address _owner) public view returns (uint256 balance);
114 	function ownerOf(uint256 _tokenId) public view returns (address owner);
115 	function approve(address _to, uint256 _tokenId) public;
116 	function transferFrom(address _from, address _to, uint256 _tokenId) public;
117 	function transfer(address _to, uint256 _tokenId) public;
118  
119 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
120 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122 	// Optional
123 	// function totalSupply() public view returns (uint256 total);
124 	// function name() public view returns (string name);
125 	// function symbol() public view returns (string symbol);
126 	// function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
127 	// function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
128 }
129 
130 contract ERC721 is ERC721Abstract
131 {
132 	string constant public   name = "CryptoSport";
133 	string constant public symbol = "CS";
134 
135 	uint256 public totalSupply;
136 	struct Token
137 	{
138 		uint256 price;			//  value of stake
139 		uint256	option;			//  [payout]96[idLottery]64[combination]32[dateBuy]0
140 	}
141 	mapping (uint256 => Token) tokens;
142 	
143 	// A mapping from tokens IDs to the address that owns them. All tokens have some valid owner address
144 	mapping (uint256 => address) public tokenIndexToOwner;
145 	
146 	// A mapping from owner address to count of tokens that address owns.	
147 	mapping (address => uint256) ownershipTokenCount; 
148 
149 	// A mapping from tokenIDs to an address that has been approved to call transferFrom().
150 	// Each token can only have one approved address for transfer at any time.
151 	// A zero value means no approval is outstanding.
152 	mapping (uint256 => address) public tokenIndexToApproved;
153 	
154 	function implementsERC721() public pure returns (bool)
155 	{
156 		return true;
157 	}
158 
159 	function balanceOf(address _owner) public view returns (uint256 count) 
160 	{
161 		return ownershipTokenCount[_owner];
162 	}
163 	
164 	function ownerOf(uint256 _tokenId) public view returns (address owner)
165 	{
166 		owner = tokenIndexToOwner[_tokenId];
167 		require(owner != address(0));
168 	}
169 	
170 	// Marks an address as being approved for transferFrom(), overwriting any previous approval. 
171 	// Setting _approved to address(0) clears all transfer approval.
172 	function _approve(uint256 _tokenId, address _approved) internal 
173 	{
174 		tokenIndexToApproved[_tokenId] = _approved;
175 	}
176 	
177 	// Checks if a given address currently has transferApproval for a particular token.
178 	// param _claimant the address we are confirming token is approved for.
179 	// param _tokenId token id, only valid when > 0
180 	function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
181 		return tokenIndexToApproved[_tokenId] == _claimant;
182 	}
183 	
184 	function approve( address _to, uint256 _tokenId ) public
185 	{
186 		// Only an owner can grant transfer approval.
187 		require(_owns(msg.sender, _tokenId));
188 
189 		// Register the approval (replacing any previous approval).
190 		_approve(_tokenId, _to);
191 
192 		// Emit approval event.
193 		Approval(msg.sender, _to, _tokenId);
194 	}
195 	
196 	function transferFrom( address _from, address _to, uint256 _tokenId ) public
197 	{
198 		// Check for approval and valid ownership
199 		require(_approvedFor(msg.sender, _tokenId));
200 		require(_owns(_from, _tokenId));
201 
202 		// Reassign ownership (also clears pending approvals and emits Transfer event).
203 		_transfer(_from, _to, _tokenId);
204 	}
205 	
206 	function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
207 		return tokenIndexToOwner[_tokenId] == _claimant;
208 	}
209 	
210 	function _transfer(address _from, address _to, uint256 _tokenId) internal 
211 	{
212 		ownershipTokenCount[_to]++;
213 		tokenIndexToOwner[_tokenId] = _to;
214 
215 		if (_from != address(0)) 
216 		{
217 			Transfer(_from, _to, _tokenId);
218 			ownershipTokenCount[_from]--;
219 			// clear any previously approved ownership exchange
220 			delete tokenIndexToApproved[_tokenId];
221 		}
222 
223 	}
224 	
225 	function transfer(address _to, uint256 _tokenId) public
226 	{
227 		require(_to != address(0));
228 		require(_owns(msg.sender, _tokenId));
229 		_transfer(msg.sender, _to, _tokenId);
230 	}
231 
232 }
233 
234 contract Owned 
235 {
236     address private candidate;
237 	address public owner;
238 
239 	mapping(address => bool) public admins;
240 	
241     function Owned() public 
242 	{
243         owner = msg.sender;
244     }
245 
246     function changeOwner(address newOwner) public 
247 	{
248 		require(msg.sender == owner);
249         candidate = newOwner;
250     }
251 	
252 	function confirmOwner() public 
253 	{
254         require(candidate == msg.sender); // run by name=candidate
255 		owner = candidate;
256     }
257 	
258     function addAdmin(address addr) external 
259 	{
260 		require(msg.sender == owner);
261         admins[addr] = true;
262     }
263 
264     function removeAdmin(address addr) external
265 	{
266 		require(msg.sender == owner);
267         admins[addr] = false;
268     }
269 }
270 
271 contract Functional
272 {
273 	// parseInt(parseFloat*10^_b)
274 	function parseInt(string _a, uint _b) internal pure returns (uint) 
275 	{
276 		bytes memory bresult = bytes(_a);
277 		uint mint = 0;
278 		bool decimals = false;
279 		for (uint i=0; i<bresult.length; i++){
280 			if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
281 				if (decimals){
282 				   if (_b == 0) break;
283 					else _b--;
284 				}
285 				mint *= 10;
286 				mint += uint(bresult[i]) - 48;
287 			} else if (bresult[i] == 46) decimals = true;
288 		}
289 		if (_b > 0) mint *= 10**_b;
290 		return mint;
291 	}
292 	
293 	function uint2str(uint i) internal pure returns (string)
294 	{
295 		if (i == 0) return "0";
296 		uint j = i;
297 		uint len;
298 		while (j != 0){
299 			len++;
300 			j /= 10;
301 		}
302 		bytes memory bstr = new bytes(len);
303 		uint k = len - 1;
304 		while (i != 0){
305 			bstr[k--] = byte(48 + i % 10);
306 			i /= 10;
307 		}
308 		return string(bstr);
309 	}
310 	
311 	function strConcat(string _a, string _b, string _c) internal pure returns (string)
312 	{
313 		bytes memory _ba = bytes(_a);
314 		bytes memory _bb = bytes(_b);
315 		bytes memory _bc = bytes(_c);
316 		string memory abc;
317 		uint k = 0;
318 		uint i;
319 		bytes memory babc;
320 		if (_ba.length==0)
321 		{
322 			abc = new string(_bc.length);
323 			babc = bytes(abc);
324 		}
325 		else
326 		{
327 			abc = new string(_ba.length + _bb.length+ _bc.length);
328 			babc = bytes(abc);
329 			for (i = 0; i < _ba.length; i++) babc[k++] = _ba[i];
330 			for (i = 0; i < _bb.length; i++) babc[k++] = _bb[i];
331 		}
332         for (i = 0; i < _bc.length; i++) babc[k++] = _bc[i];
333 		return string(babc);
334 	}
335 	
336 	function timenow() public view returns(uint32) { return uint32(block.timestamp); }
337 }
338 
339 contract CSLottery is ERC721, usingOraclize, Functional, Owned
340 {
341 	uint256 public feeLottery;
342 	
343 	enum Status {
344 		NOTFOUND,		//0 game not created
345 		PLAYING,		//1 buying tickets
346 		PROCESSING,		//2 waiting for result
347 		PAYING,	 		//3 redeeming
348 		CANCELING		//4 canceling the game
349 	}
350 	
351 	struct Game {
352 		string  nameLottery;
353 		uint32  countCombinations;
354 		uint32  dateStopBuy;
355 		uint32  minStake;				// per finney = 0.001E
356 		uint32  winCombination;
357 		uint256 betsSumIn;				// amount bets
358 		uint256 feeValue;				// amount fee
359 		Status status;					// status of game
360 		bool isFreezing;
361 	}
362 	Game[] private game;
363 	
364 	struct Stake {
365 		uint256 sum;		// amount bets
366 		uint32 count;		// count bets 
367 	}
368 	mapping(uint32 => mapping (uint32 => Stake)) public betsAll; // ID-lottery => combination => Stake
369 	mapping(bytes32 => uint32) private queryRes;  // ID-query => ID-lottery
370 	
371 	uint256 public ORACLIZE_GAS_LIMIT = 200000;
372 	uint256 public ORACLIZE_GASPRICE_GWEY = 40; // 40Gwey
373 
374 	event LogEvent(string _event, string nameLottery, uint256 value);
375 	event LogToken(string _event, address user, uint32 idLottery, uint32 idToken, uint32 combination, uint256 amount);
376 
377     modifier onlyOwner {
378         require(msg.sender == owner);
379         _;
380     }
381 	
382 	modifier onlyAdmin {
383         require(msg.sender == owner || admins[msg.sender]);
384         _;
385     }
386 
387 	modifier onlyOraclize {
388         require (msg.sender == oraclize_cbAddress());
389         _;
390     }
391 
392 	function getLotteryByID(uint32 _id) public view returns (
393 		string  nameLottery,
394 		uint32 countCombinations,
395 		uint32 dateStopBuy,
396 		uint32 minStake,
397 		uint32 winCombination,
398 		uint32 betsCount,
399 		uint256 betsSumIn,
400 		uint256 feeValue,
401 		Status status,
402 		bool isFreezing
403 	){
404 		Game storage gm = game[_id];
405 		nameLottery = gm.nameLottery;
406 		countCombinations = gm.countCombinations;
407 		dateStopBuy = gm.dateStopBuy;
408 		minStake = gm.minStake;
409 		winCombination = gm.winCombination;
410 		betsCount = getCountTokensByLottery(_id);
411 		betsSumIn = gm.betsSumIn;  
412 		if (betsSumIn==0) betsSumIn = getSumInByLottery(_id);
413 		feeValue = gm.feeValue;
414 		status = gm.status;
415 		if ( status == Status.PLAYING && timenow() > dateStopBuy ) status = Status.PROCESSING;
416 		isFreezing = gm.isFreezing;
417 	}
418 	
419 	function getCountTokensByLottery(uint32 idLottery) internal view returns (uint32)
420 	{
421 		Game storage curGame = game[idLottery];
422 		uint32 count = 0;
423 		for(uint32 i=1;i<=curGame.countCombinations;i++) count += betsAll[idLottery][i].count;
424 		return count;
425 	}
426 	
427 	function getSumInByLottery(uint32 idLottery) internal view returns (uint256)
428 	{
429 		Game storage curGame = game[idLottery];
430 		uint256 sum = 0;
431 		for(uint32 i=1;i<=curGame.countCombinations;i++) sum += betsAll[idLottery][i].sum;
432 		return sum;
433 	}
434 	
435 	function getTokenByID(uint256 _id) public view returns ( 
436 			uint256 price,
437 			uint256 payment,
438 			uint32 combination,
439 			uint32 dateBuy,
440 			uint32 idLottery,
441 			address ownerToken,
442 			bool payout
443 	){
444 		Token storage tkn = tokens[_id];
445 
446 		price = tkn.price;
447 		
448 		uint256 packed = tkn.option;
449 		payout = uint8((packed >> (12*8)) & 0xFF)==1?true:false;
450 		idLottery   = uint32((packed >> (8*8)) & 0xFFFFFFFF);
451 		combination = uint32((packed >> (4*8)) & 0xFFFFFFFF);
452 		dateBuy     = uint32(packed & 0xFFFFFFFF);
453 
454 		payment = 0;
455 		Game storage curGame = game[idLottery];
456 		
457 		uint256 betsSumIn = curGame.betsSumIn;  
458 		if (betsSumIn==0) betsSumIn = getSumInByLottery(idLottery);
459 
460 		if (curGame.winCombination==combination) payment = betsSumIn * tkn.price / betsAll[idLottery][ curGame.winCombination ].sum;
461 		if (curGame.status == Status.CANCELING) payment = tkn.price;
462 		
463 		ownerToken = tokenIndexToOwner[_id];
464 	}
465 
466 	function getUserTokens(address user, uint32 count) public view returns ( string res ) 
467 	{
468 		res="";
469 		require(user!=0x0);
470 		uint32 findCount=0;
471 		for (uint256 i = totalSupply-1; i >= 0; i--)
472 		{
473 			if(i>totalSupply) break;
474 			if (user == tokenIndexToOwner[i]) 
475 			{
476 				res = strConcat( res, ",", uint2str(i) );
477 				findCount++;
478 				if (count!=0 && findCount>=count) break;
479 			}
480 		}
481 	}
482 
483 	function getStatLotteries() public view returns ( 
484 			uint32 countAll,
485 			uint32 countPlaying,
486 			uint32 countProcessing,
487 			string listPlaying,
488 			string listProcessing
489 	){
490 		countAll = uint32(game.length);
491 		countPlaying = 0;
492 		countProcessing = 0;
493 		listPlaying="";
494 		listProcessing="";
495 		uint32 curtime = timenow();
496 		for (uint32 i = 0; i < countAll; i++)
497 		{
498 			if (game[i].status!=Status.PLAYING) continue;
499 			if (curtime <  game[i].dateStopBuy) { countPlaying++; listPlaying = strConcat( listPlaying, ",", uint2str(i) ); }
500 			if (curtime >= game[i].dateStopBuy) { countProcessing++; listProcessing = strConcat( listProcessing, ",", uint2str(i) ); }
501 		}
502 		
503 	}
504 
505 	function CSLottery() public 
506 	{
507 	}
508 
509 	function setOraclizeGasPrice(uint256 priceGwey, uint256 limit) onlyAdmin public
510 	{
511 		ORACLIZE_GASPRICE_GWEY = priceGwey;
512 		ORACLIZE_GAS_LIMIT = limit;
513 		oraclize_setCustomGasPrice( uint256(ORACLIZE_GASPRICE_GWEY) * 10**9 );
514 	}
515 
516 	function freezeLottery(uint32 idLottery, bool freeze) public onlyAdmin 
517 	{ 
518 		Game storage curGame = game[idLottery];
519 		require( curGame.isFreezing != freeze );
520 		curGame.isFreezing = freeze; 
521 	}
522 
523 	function addLottery( string _nameLottery, uint32 _dateStopBuy, uint32 _countCombinations, uint32 _minStakeFinney ) onlyAdmin public 
524 	{
525 		require( bytes(_nameLottery).length > 2 );
526 		require( _countCombinations > 1 );
527 		require( _minStakeFinney > 0 );
528 		require( _dateStopBuy > timenow() );
529 
530 		Game memory _game;
531 		_game.nameLottery = _nameLottery;
532 		_game.countCombinations = _countCombinations;
533 		_game.dateStopBuy = _dateStopBuy;
534 		_game.minStake 	= _minStakeFinney;
535 		_game.status = Status.PLAYING;
536 
537 		uint256 newGameId = game.push(_game) - 1;
538 		
539 		LogEvent( "AddGame", _nameLottery, newGameId );
540 	}
541 
542 	function () payable public { require (msg.value == 0x0); }
543 	
544 	function buyToken(uint32 idLottery, uint32 combination, address captainAddress) payable public
545 	{
546 		Game storage curGame = game[idLottery];
547 		require( curGame.status == Status.PLAYING );
548 		require( timenow() < curGame.dateStopBuy );
549 		require( combination > 0 && combination <= curGame.countCombinations );
550 		require( captainAddress != msg.sender );
551 		require( curGame.isFreezing == false );
552 		
553 		// check money for stake
554 		require( msg.value >= curGame.minStake * 1 finney );
555 		
556 		uint256 userStake = msg.value;
557 		uint256 feeValue = userStake * 5 / 100;		// 5% fee for contract
558 		userStake = userStake - feeValue;
559 		
560 		if (captainAddress!=0x0) 
561 		{
562 			uint256 captainValue = feeValue * 20 / 100;		// bonus for captain = 1%
563 			feeValue = feeValue - captainValue;
564 			require(feeValue + captainValue + userStake == msg.value);
565 			captainAddress.transfer(captainValue);
566 		}
567 
568 		curGame.feeValue  = curGame.feeValue + feeValue;
569 		betsAll[idLottery][combination].sum += userStake;
570 		betsAll[idLottery][combination].count += 1;
571 
572 		uint128 packed;
573 		packed = ( uint128(idLottery) << 8*8 ) + ( uint128(combination) << 4*8 ) + uint128(block.timestamp);
574 
575 		Token memory _token = Token({
576 			price: userStake,
577 			option : packed
578 		});
579 
580 		uint256 newTokenId = totalSupply++;
581 		tokens[newTokenId] = _token;
582 		_transfer(0, msg.sender, newTokenId);
583 		LogToken( "Buy", msg.sender, idLottery, uint32(newTokenId), combination, userStake);
584 	}
585 	
586 	// take win money or money for canceling lottery
587 	function redeemToken(uint256 _tokenId) public 
588 	{
589 		Token storage tkn = tokens[_tokenId];
590 
591 		uint256 packed = tkn.option;
592 		bool payout = uint8((packed >> (12*8)) & 0xFF)==1?true:false;
593 		uint32 idLottery = uint32((packed >> (8*8)) & 0xFFFFFFFF);
594 		uint32 combination = uint32((packed >> (4*8)) & 0xFFFFFFFF);
595 
596 		Game storage curGame = game[idLottery];
597 		
598 		require( curGame.status == Status.PAYING || curGame.status == Status.CANCELING);
599 
600 		require( msg.sender == tokenIndexToOwner[_tokenId] );	// only onwer`s token
601 		require( payout == false ); // has not paid
602 		require( combination == curGame.winCombination || curGame.status == Status.CANCELING );
603 
604 		uint256 sumPayment = 0;
605 		if ( curGame.status == Status.CANCELING ) sumPayment = tkn.price;
606 		if ( curGame.status == Status.PAYING ) sumPayment = curGame.betsSumIn * tkn.price / betsAll[idLottery][curGame.winCombination].sum;
607 
608 		payout = true;
609 		packed += uint128(payout?1:0) << 12*8;
610 		tkn.option = packed;
611 	
612 		msg.sender.transfer(sumPayment);
613 		
614 		LogToken( "Redeem", msg.sender, idLottery, uint32(_tokenId), combination, sumPayment);
615 	}
616 	
617 	function cancelLottery(uint32 idLottery) public 
618 	{
619 		Game storage curGame = game[idLottery];
620 		
621 		require( curGame.status == Status.PLAYING );
622 		// only owner/admin or anybody after 7 days
623 		require( msg.sender == owner || admins[msg.sender] || timenow() > curGame.dateStopBuy + 7 * 24*60*60 );
624 
625 		curGame.status = Status.CANCELING;
626 
627 		LogEvent( "CancelLottery", curGame.nameLottery, idLottery );
628 		
629 		takeFee(idLottery);
630 	}
631 
632 	function __callback(bytes32 queryId, string _result) onlyOraclize public
633 	{
634 		uint32 idLottery = queryRes[queryId];
635 		require( idLottery != 0 );
636 
637 		Game storage curGame = game[idLottery];
638 		
639 		require( curGame.status == Status.PLAYING );
640 		require( timenow() > curGame.dateStopBuy );
641 		
642 		uint32 tmpCombination = uint32(parseInt(_result,0));
643 		
644 		string memory error = "callback";
645 		if ( tmpCombination==0 ) error = "callback_result_not_found";
646 		if ( tmpCombination > curGame.countCombinations ) { tmpCombination = 0; error = "callback_result_limit"; }
647 
648 		LogEvent( error, curGame.nameLottery, tmpCombination );
649 
650 		if (tmpCombination!=0) 
651 		{
652 			curGame.winCombination = tmpCombination;
653 			checkWinNobody(idLottery);
654 		}
655 	}
656 
657 	function resolveLotteryByOraclize(uint32 idLottery, uint32 delaySec) onlyAdmin public payable
658 	{
659 		Game storage curGame = game[idLottery];
660 		
661 		uint oraclizeFee = oraclize_getPrice( "URL", ORACLIZE_GAS_LIMIT );
662 		require(msg.value + curGame.feeValue > oraclizeFee); // if contract has not enought money to do query
663 		
664 		curGame.feeValue = curGame.feeValue + msg.value - oraclizeFee;
665 
666 		LogEvent( "ResolveLotteryByOraclize", curGame.nameLottery, delaySec );
667 		
668 		string memory tmpQuery;
669 		tmpQuery = strConcat( "json(https://cryptosportz.com/api/v2/game/", uint2str(idLottery), "/result).result" );
670 	
671 		uint32 delay;
672 		if ( timenow() < curGame.dateStopBuy ) delay = curGame.dateStopBuy - timenow() + delaySec;
673 										  else delay = delaySec;
674 	
675 		bytes32 queryId = oraclize_query(delay, "URL", tmpQuery, ORACLIZE_GAS_LIMIT);
676 		queryRes[queryId] = idLottery;
677 	}
678 
679 	function resolveLotteryByHand(uint32 idLottery, uint32 combination) onlyAdmin public 
680 	{
681 		Game storage curGame = game[idLottery];
682 		
683 		require( curGame.status == Status.PLAYING );
684 		require( combination <= curGame.countCombinations );
685 		require( combination != 0 );
686 
687 		require( timenow() > curGame.dateStopBuy + 2*60*60 );
688 
689 		curGame.winCombination = combination;
690 		
691 		LogEvent( "ResolveLotteryByHand", curGame.nameLottery, curGame.winCombination );
692 		
693 		checkWinNobody(idLottery);
694 	}
695 	
696 	function checkWinNobody(uint32 idLottery) internal
697 	{
698 		Game storage curGame = game[idLottery];
699 		
700 		curGame.status = Status.PAYING;
701 		curGame.betsSumIn = getSumInByLottery(idLottery);
702 		
703 		// nobody win = send all to feeLottery
704 		if ( betsAll[idLottery][curGame.winCombination].count == 0 )
705 		{
706 			if (curGame.betsSumIn+curGame.feeValue!=0) feeLottery = feeLottery + curGame.betsSumIn + curGame.feeValue;
707 			LogEvent( "NOBODYWIN", curGame.nameLottery, curGame.betsSumIn+curGame.feeValue );
708 		}
709 		else 
710 			takeFee(idLottery);
711 	}
712 	
713 	function takeFee(uint32 idLottery) internal
714 	{
715 		Game storage curGame = game[idLottery];
716 		
717 		// take fee
718 		if ( curGame.feeValue > 0 )
719 		{
720 			feeLottery = feeLottery + curGame.feeValue;
721 			LogEvent( "TakeFee", curGame.nameLottery, curGame.feeValue );
722 		}
723 	}
724 	
725 	function withdraw() onlyOwner public
726 	{
727 		require( feeLottery > 0 );
728 
729 		uint256 tmpFeeLottery = feeLottery;
730 		feeLottery = 0;
731 		
732 		owner.transfer(tmpFeeLottery);
733 		LogEvent( "WITHDRAW", "", tmpFeeLottery);
734 	}
735 
736 }