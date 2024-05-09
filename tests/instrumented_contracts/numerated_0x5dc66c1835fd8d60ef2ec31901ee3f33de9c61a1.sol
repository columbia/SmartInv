1 pragma solidity ^0.4.18;
2 
3 /*
4 VERSION DATE: 23/03/2018
5 
6 CREATED BY: CRYPTO SPORTZ
7 UNJOY YOUR TEAM AND SPORTS AND EMAIL US IF YOU HAVE ANY QUESTIONS
8 */
9 
10 library SafeMathLib {
11 
12   function times(uint a, uint b) internal pure returns (uint) {
13     uint c = a * b;
14     require(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function minus(uint a, uint b) internal pure returns (uint) {
19     require(b <= a);
20     return a - b;
21   }
22 
23   function plus(uint a, uint b) internal pure returns (uint) {
24     uint c = a + b;
25     require(c>=a);
26     return c;
27   }
28   function mul(uint a, uint b) internal pure returns (uint) {
29     uint c = a * b;
30     require(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function div(uint a, uint b) internal pure returns (uint) {
35     require(b > 0);
36     uint c = a / b;
37     require(a == b * c + a % b);
38     return c;
39   }
40 
41   function sub(uint a, uint b) internal pure returns (uint) {
42     require(b <= a);
43     return a - b;
44   }
45 
46   function add(uint a, uint b) internal pure returns (uint) {
47     uint c = a + b;
48     require(c>=a && c>=b);
49     return c;
50   }
51 
52 }
53 
54 contract OraclizeI {
55 	address public cbAddress;
56 	function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
57 	function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
58 	function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
59 	function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
60 	function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
61 	function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
62 	function getPrice(string _datasource) public returns (uint _dsprice);
63 	function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
64 	function setProofType(byte _proofType) external;
65 	function setCustomGasPrice(uint _gasPrice) external;
66 	function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
67 }
68 contract OraclizeAddrResolverI {
69 	function getAddress() public returns (address _addr);
70 }
71 contract usingOraclize {
72 	
73 	uint8 constant networkID_auto = 0;
74 	uint8 constant networkID_mainnet = 1;
75 	uint8 constant networkID_testnet = 2;
76 	uint8 constant networkID_morden = 2;
77 	uint8 constant networkID_consensys = 161;
78 
79 	OraclizeAddrResolverI OAR;
80 
81 	OraclizeI oraclize;
82 	modifier oraclizeAPI 
83 	{
84 		if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
85 			oraclize_setNetwork(networkID_auto);
86 
87 		if(address(oraclize) != OAR.getAddress())
88 			oraclize = OraclizeI(OAR.getAddress());
89 
90 		_;
91 	}
92 	modifier coupon(string code){
93 		oraclize = OraclizeI(OAR.getAddress());
94 		_;
95 	}
96 
97 	function oraclize_setNetwork(uint8 networkID) internal returns(bool)
98 	{
99 		return oraclize_setNetwork();
100 		networkID; // silence the warning and remain backwards compatible
101 	}
102 	
103 	function oraclize_setNetwork() internal returns(bool)
104 	{
105 		if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
106 			OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
107 			return true;
108 		}
109 
110 		if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
111 			OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
112 			return true;
113 		}
114 
115 		return false;
116 	}
117 	
118 	function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
119 		uint price = oraclize.getPrice(datasource, gaslimit);
120 		if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
121 		return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
122 	}
123 
124     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
125         uint price = oraclize.getPrice(datasource, gaslimit);
126         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
127         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
128 	}
129 	
130 	function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
131 		return oraclize.getPrice(datasource);
132 	}
133 
134 	function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
135 		return oraclize.getPrice(datasource, gaslimit);
136 	}
137 
138     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
139         return oraclize.setCustomGasPrice(gasPrice);
140     }
141 	
142 	function oraclize_cbAddress() oraclizeAPI internal returns (address){
143 		return oraclize.cbAddress();
144 	}
145 
146 	function getCodeSize(address _addr) constant internal returns(uint _size) {
147 		assembly {
148 			_size := extcodesize(_addr)
149 		}
150 	}
151 
152 }
153 
154 contract ERC721Abstract
155 {
156 	function implementsERC721() public pure returns (bool);
157 	function balanceOf(address _owner) public view returns (uint256 balance);
158 	function ownerOf(uint256 _tokenId) public view returns (address owner);
159 	function approve(address _to, uint256 _tokenId) public;
160 	function transferFrom(address _from, address _to, uint256 _tokenId) public;
161 	function transfer(address _to, uint256 _tokenId) public;
162  
163 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
164 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
165 
166 	// Optional
167 	// function totalSupply() public view returns (uint256 total);
168 	// function name() public view returns (string name);
169 	// function symbol() public view returns (string symbol);
170 	// function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
171 	// function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
172 }
173 
174 contract ERC721 is ERC721Abstract
175 {
176 	string constant public   name = "TotalGameOracle";
177 	string constant public symbol = "TTGO";
178 
179 	uint256 public totalSupply;
180 	struct Token
181 	{
182 		uint256 price;			//  value of stake
183 		uint256	option;			//  [payout]96[idLottery]64[combination]32[dateBuy]0
184 	}
185 	mapping (uint256 => Token) tokens;
186 	
187 	// A mapping from tokens IDs to the address that owns them. All tokens have some valid owner address
188 	mapping (uint256 => address) public tokenIndexToOwner;
189 	
190 	// A mapping from owner address to count of tokens that address owns.	
191 	mapping (address => uint256) ownershipTokenCount; 
192 
193 	// A mapping from tokenIDs to an address that has been approved to call transferFrom().
194 	// Each token can only have one approved address for transfer at any time.
195 	// A zero value means no approval is outstanding.
196 	mapping (uint256 => address) public tokenIndexToApproved;
197 	
198 	function implementsERC721() public pure returns (bool)
199 	{
200 		return true;
201 	}
202 
203 	function balanceOf(address _owner) public view returns (uint256 count) 
204 	{
205 		return ownershipTokenCount[_owner];
206 	}
207 	
208 	function ownerOf(uint256 _tokenId) public view returns (address owner)
209 	{
210 		owner = tokenIndexToOwner[_tokenId];
211 		require(owner != address(0));
212 	}
213 	
214 	// Marks an address as being approved for transferFrom(), overwriting any previous approval. 
215 	// Setting _approved to address(0) clears all transfer approval.
216 	function _approve(uint256 _tokenId, address _approved) internal 
217 	{
218 		tokenIndexToApproved[_tokenId] = _approved;
219 	}
220 	
221 	// Checks if a given address currently has transferApproval for a particular token.
222 	// param _claimant the address we are confirming token is approved for.
223 	// param _tokenId token id, only valid when > 0
224 	function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
225 		return tokenIndexToApproved[_tokenId] == _claimant;
226 	}
227 	
228 	function approve( address _to, uint256 _tokenId ) public
229 	{
230 		// Only an owner can grant transfer approval.
231 		require(_owns(msg.sender, _tokenId));
232 
233 		// Register the approval (replacing any previous approval).
234 		_approve(_tokenId, _to);
235 
236 		// Emit approval event.
237 		Approval(msg.sender, _to, _tokenId);
238 	}
239 	
240 	function transferFrom( address _from, address _to, uint256 _tokenId ) public
241 	{
242 		// Check for approval and valid ownership
243 		require(_approvedFor(msg.sender, _tokenId));
244 		require(_owns(_from, _tokenId));
245 
246 		// Reassign ownership (also clears pending approvals and emits Transfer event).
247 		_transfer(_from, _to, _tokenId);
248 	}
249 	
250 	function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
251 		return tokenIndexToOwner[_tokenId] == _claimant;
252 	}
253 	
254 	function _transfer(address _from, address _to, uint256 _tokenId) internal 
255 	{
256 		ownershipTokenCount[_to]++;
257 		tokenIndexToOwner[_tokenId] = _to;
258 
259 		if (_from != address(0)) 
260 		{
261 			Transfer(_from, _to, _tokenId);
262 			ownershipTokenCount[_from]--;
263 			// clear any previously approved ownership exchange
264 			delete tokenIndexToApproved[_tokenId];
265 		}
266 
267 	}
268 	
269 	function transfer(address _to, uint256 _tokenId) public
270 	{
271 		require(_to != address(0));
272 		require(_owns(msg.sender, _tokenId));
273 		_transfer(msg.sender, _to, _tokenId);
274 	}
275 
276 }
277 
278 contract Owned 
279 {
280     address private candidate;
281 	address public owner;
282 
283 	mapping(address => bool) public admins;
284 	
285     function Owned() public 
286 	{
287         owner = msg.sender;
288     }
289 
290     function changeOwner(address newOwner) public 
291 	{
292 		require(msg.sender == owner);
293         candidate = newOwner;
294     }
295 	
296 	function confirmOwner() public 
297 	{
298         require(candidate == msg.sender); // run by name=candidate
299 		owner = candidate;
300     }
301 	
302     function addAdmin(address addr) external 
303 	{
304 		require(msg.sender == owner);
305         admins[addr] = true;
306     }
307 
308     function removeAdmin(address addr) external
309 	{
310 		require(msg.sender == owner);
311         admins[addr] = false;
312     }
313 }
314 
315 contract Functional
316 {
317 	// parseInt(parseFloat*10^_b)
318 	function parseInt(string _a, uint _b) internal pure returns (uint) 
319 	{
320 		bytes memory bresult = bytes(_a);
321 		uint mint = 0;
322 		bool decimals = false;
323 		for (uint i=0; i<bresult.length; i++){
324 			if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
325 				if (decimals){
326 				   if (_b == 0) break;
327 					else _b--;
328 				}
329 				mint *= 10;
330 				mint += uint(bresult[i]) - 48;
331 			} else if (bresult[i] == 46) decimals = true;
332 		}
333 		if (_b > 0) mint *= 10**_b;
334 		return mint;
335 	}
336 	
337 	function uint2str(uint i) internal pure returns (string)
338 	{
339 		if (i == 0) return "0";
340 		uint j = i;
341 		uint len;
342 		while (j != 0){
343 			len++;
344 			j /= 10;
345 		}
346 		bytes memory bstr = new bytes(len);
347 		uint k = len - 1;
348 		while (i != 0){
349 			bstr[k--] = byte(48 + i % 10);
350 			i /= 10;
351 		}
352 		return string(bstr);
353 	}
354 	
355 	function strConcat(string _a, string _b, string _c) internal pure returns (string)
356 	{
357 		bytes memory _ba = bytes(_a);
358 		bytes memory _bb = bytes(_b);
359 		bytes memory _bc = bytes(_c);
360 		string memory abc;
361 		uint k = 0;
362 		uint i;
363 		bytes memory babc;
364 		if (_ba.length==0)
365 		{
366 			abc = new string(_bc.length);
367 			babc = bytes(abc);
368 		}
369 		else
370 		{
371 			abc = new string(_ba.length + _bb.length+ _bc.length);
372 			babc = bytes(abc);
373 			for (i = 0; i < _ba.length; i++) babc[k++] = _ba[i];
374 			for (i = 0; i < _bb.length; i++) babc[k++] = _bb[i];
375 		}
376         for (i = 0; i < _bc.length; i++) babc[k++] = _bc[i];
377 		return string(babc);
378 	}
379 	
380 	function timenow() public view returns(uint32) { return uint32(block.timestamp); }
381 }
382 
383 contract TTGOracle is ERC721, usingOraclize, Functional, Owned
384 {
385 	using SafeMathLib for uint32;
386 	using SafeMathLib for uint256;
387 	uint256 public feeLottery;
388 	
389 	enum Status {
390 		NOTFOUND,		//0 game not created
391 		PLAYING,		//1 buying tickets
392 		PROCESSING,		//2 waiting for result
393 		PAYING,	 		//3 redeeming
394 		CANCELING		//4 canceling the game
395 	}
396 	
397 	struct Game {
398 		string  nameLottery;
399 		uint32  countCombinations;
400 		uint32  gameID;
401 		uint32  teamAID;
402 		uint32  teamBID;		
403 		uint32  dateStopBuy;
404 		uint32  minStake;				// per finney = 0.001E
405 		uint32  winCombination;
406 		uint256 betsSumIn;				// amount bets
407 		uint256 feeValue;				// amount fee
408 		Status status;					// status of game
409 		bool isFreezing;
410 	}
411 	Game[] private game;
412 	ITTGCoin private ttgCoin;
413 	IItemToken private itemToken;
414 	uint32 private userAirDropRate = 1000;
415 	uint32 private ownerAirDropRate = 100;
416 
417 	struct Stake {
418 		uint256 sum;		// amount bets
419 		uint32 count;		// count bets 
420 	}
421 	mapping(uint32 => mapping (uint32 => Stake)) public betsAll; // ID-lottery => combination => Stake
422 	mapping(bytes32 => uint32) private queryRes;  // ID-query => ID-lottery
423 	
424 	uint256 public ORACLIZE_GAS_LIMIT = 2000000;
425 	uint256 public ORACLIZE_GASPRICE_GWEY = 40; // 40Gwey
426 
427 	event LogEvent(string _event, string nameLottery, uint256 value);
428 	event LogToken(string _event, address user, uint32 idLottery, uint32 idToken, uint32 combination, uint256 amount);
429 
430     modifier onlyOwner {
431         require(msg.sender == owner);
432         _;
433     }
434 	
435 	modifier onlyAdmin {
436         require(msg.sender == owner || admins[msg.sender]);
437         _;
438     }
439 
440 	modifier onlyOraclize {
441         require (msg.sender == oraclize_cbAddress());
442         _;
443     }
444 
445    function setTTGCoin (address _ttgCoin) onlyOwner() public {
446     ttgCoin = ITTGCoin(_ttgCoin);
447    }
448 
449    function setItemToken (address _itemToken) onlyOwner() public {
450     itemToken = IItemToken(_itemToken);
451    }
452 
453 
454 	function getLotteryByID(uint32 _id) public view returns (
455 		string  nameLottery,
456 		uint32 countCombinations,
457 		uint32 dateStopBuy,
458 		uint32 gameID,
459 		uint32 teamAID,
460 		uint32 teamBID,		
461 		uint32 minStake,
462 		uint32 winCombination,
463 		uint32 betsCount,
464 		uint256 betsSumIn,
465 		uint256 feeValue,
466 		Status status,
467 		bool isFreezing
468 	){
469 		Game storage gm = game[_id];
470 		nameLottery = gm.nameLottery;
471 		countCombinations = gm.countCombinations;
472 		dateStopBuy = gm.dateStopBuy;
473 		gameID = gm.gameID;
474 		teamAID = gm.teamAID;
475 		teamBID = gm.teamBID;
476 		minStake = gm.minStake;
477 		winCombination = gm.winCombination;
478 		betsCount = getCountTokensByLottery(_id);
479 		betsSumIn = gm.betsSumIn;  
480 		if (betsSumIn==0) betsSumIn = getSumInByLottery(_id);
481 		feeValue = gm.feeValue;
482 		status = gm.status;
483 		if ( status == Status.PLAYING && timenow() > dateStopBuy ) status = Status.PROCESSING;
484 		isFreezing = gm.isFreezing;
485 	}
486 	
487 	function getCountTokensByLottery(uint32 idLottery) internal view returns (uint32)
488 	{
489 		Game storage curGame = game[idLottery];
490 		uint32 count = 0;
491 		for(uint32 i=1;i<=curGame.countCombinations;i++) count += betsAll[idLottery][i].count;
492 		return count;
493 	}
494 	
495 	function getSumInByLottery(uint32 idLottery) internal view returns (uint256)
496 	{
497 		Game storage curGame = game[idLottery];
498 		uint256 sum = 0;
499 		for(uint32 i=1;i<=curGame.countCombinations;i++) sum += betsAll[idLottery][i].sum;
500 		return sum;
501 	}
502 	
503 	function getTokenByID(uint256 _id) public view returns ( 
504 			uint256 price,
505 			uint256 payment,
506 			uint32 combination,
507 			uint32 dateBuy,
508 			uint32 idLottery,
509 			address ownerToken,
510 			bool payout,
511 			uint256 sameComboAmount,
512 			uint256 tokenID
513 	){
514 		Token storage tkn = tokens[_id];
515 
516 		price = tkn.price;
517 		
518 		uint256 packed = tkn.option;
519 		payout = uint8((packed >> (12*8)) & 0xFF)==1?true:false;
520 		idLottery   = uint32((packed >> (8*8)) & 0xFFFFFFFF);
521 		combination = uint32((packed >> (4*8)) & 0xFFFFFFFF);
522 		dateBuy     = uint32(packed & 0xFFFFFFFF);
523 		sameComboAmount = betsAll[idLottery][combination].sum;
524 		tokenID = _id;
525 
526 		payment = 0;
527 		Game storage curGame = game[idLottery];
528 		
529 		uint256 betsSumIn = curGame.betsSumIn;  
530 		if (betsSumIn==0) betsSumIn = getSumInByLottery(idLottery);
531 
532 		if (curGame.winCombination==combination) payment = betsSumIn * tkn.price / betsAll[idLottery][ curGame.winCombination ].sum;
533 		if (curGame.status == Status.CANCELING) payment = tkn.price;
534 		
535 		ownerToken = tokenIndexToOwner[_id];
536 	}
537 
538 	function getUserTokens(address user, uint32 count) public view returns ( string res ) 
539 	{
540 		res="";
541 		require(user!=0x0);
542 		uint32 findCount=0;
543 		for (uint256 i = totalSupply-1; i >= 0; i--)
544 		{
545 			if(i>totalSupply) break;
546 			if (user == tokenIndexToOwner[i]) 
547 			{
548 				res = strConcat( res, ",", uint2str(i) );
549 				findCount++;
550 				if (count!=0 && findCount>=count) break;
551 			}
552 		}
553 	}
554 
555 	function getUserTokensByMatch(address user, uint32 matchID) public view returns ( string res ) 
556 	{
557 		res="";
558 		require(user!=0x0);
559 		uint32 findCount=0;
560 		for (uint256 i = totalSupply-1; i >= 0; i--)
561 		{
562 			if(i>totalSupply) break;
563 			if (user == tokenIndexToOwner[i]) 
564 			{
565 				Token storage tkn = tokens[i];
566 				uint256 packed = tkn.option;
567 				uint32 idStored   = uint32((packed >> (8*8)) & 0xFFFFFFFF);
568 				if(idStored == matchID){
569 					res = strConcat( res, ",", uint2str(i) );
570 					findCount++;
571 				}
572 				
573 			}
574 		}
575 	}	
576 
577 	function getStatLotteries() public view returns ( 
578 			uint32 countAll,
579 			uint32 countPlaying,
580 			uint32 countProcessing,
581 			string listPlaying,
582 			string listProcessing
583 	){
584 		countAll = uint32(game.length);
585 		countPlaying = 0;
586 		countProcessing = 0;
587 		listPlaying="";
588 		listProcessing="";
589 		uint32 curtime = timenow();
590 		for (uint32 i = 0; i < countAll; i++)
591 		{
592 			if (game[i].status!=Status.PLAYING) continue;
593 			if (curtime <  game[i].dateStopBuy) { countPlaying++; listPlaying = strConcat( listPlaying, ",", uint2str(i) ); }
594 			if (curtime >= game[i].dateStopBuy) { countProcessing++; listProcessing = strConcat( listProcessing, ",", uint2str(i) ); }
595 		}
596 		
597 	}
598 
599 	function TTGOracle() public 
600 	{
601 	}
602 
603 	function setOraclizeGasPrice(uint256 priceGwey, uint256 limit) onlyAdmin public
604 	{
605 		ORACLIZE_GASPRICE_GWEY = priceGwey;
606 		ORACLIZE_GAS_LIMIT = limit;
607 		oraclize_setCustomGasPrice( uint256(ORACLIZE_GASPRICE_GWEY) * 10**9 );
608 	}
609 
610 	function freezeLottery(uint32 idLottery, bool freeze) public onlyAdmin 
611 	{ 
612 		Game storage curGame = game[idLottery];
613 		require( curGame.isFreezing != freeze );
614 		curGame.isFreezing = freeze; 
615 	}
616 
617 	function addLottery( string _nameLottery, uint32 _dateStopBuy, uint32 _countCombinations, uint32 gameID, uint32 teamAID, uint32 teamBID, uint32 _minStakeFinney ) onlyAdmin public 
618 	{
619 
620 		require( bytes(_nameLottery).length > 2 );
621 		require( _countCombinations > 1 );
622 		require( _minStakeFinney > 0 );
623 		require( _dateStopBuy > timenow() );
624 
625 		Game memory _game;
626 		_game.nameLottery = _nameLottery;
627 		_game.countCombinations = _countCombinations;
628 		_game.dateStopBuy = _dateStopBuy;
629 		_game.gameID = gameID;
630 		_game.minStake 	= _minStakeFinney;
631 		_game.status = Status.PLAYING;
632 		_game.teamAID = teamAID;
633 		_game.teamBID = teamBID;
634 		
635 
636 		uint256 newGameId = game.push(_game) - 1;
637 		
638 		
639 		LogEvent( "AddGame", _nameLottery, newGameId );
640 	}
641 
642 	function () payable public { require (msg.value == 0x0); }
643 
644 	function setUserAirDropRate(uint32 rate) onlyAdmin public{
645 		userAirDropRate = rate;
646 	}
647 
648 	function setOwnerAirDropRate(uint32 rate) onlyAdmin public{
649 		ownerAirDropRate = rate;
650 	}	
651 	
652 	function buyToken(uint32 idLottery, uint32 teamID, uint32 combination, address captainAddress) payable public
653 	{
654 		Game storage curGame = game[idLottery];
655 		require( curGame.status == Status.PLAYING );
656 		require( timenow() < curGame.dateStopBuy );
657 		require( combination > 0 && combination <= curGame.countCombinations );
658 		require( captainAddress != msg.sender );
659 		require( curGame.isFreezing == false );
660 		
661 		// check money for stake
662 		require( msg.value >= curGame.minStake * 1 finney );
663 		
664 		uint256 userStake = msg.value;
665 		uint256 airDropAmountUser = userStake.mul(userAirDropRate); 
666 		if(airDropAmountUser > 1000*10**18) airDropAmountUser = 1000*10**18;
667 		ttgCoin.airDrop(this, msg.sender, airDropAmountUser);
668 		address teamOwner = itemToken.ownerOf(teamID);
669 		if(teamOwner!=0x0){
670 			uint256 airDropAmountOwner = userStake.mul(ownerAirDropRate); 	
671 			if(airDropAmountOwner > 1000*10**18) airDropAmountOwner = 1000*10**18;			
672 			ttgCoin.airDrop(this, teamOwner, airDropAmountOwner);   //for team owner 
673 		}
674 		uint256 feeValue = userStake.mul(4).div(100);		// 4% fee for contract
675 		userStake = userStake.minus(feeValue);
676 		
677 		if (captainAddress!=0x0) 
678 		{
679 			//uint256 captainValue = feeValue.mul(20).div(100);		// bonus for captain = 1%
680 			// feeValue = feeValue - captainValue;
681 			// require(feeValue + captainValue + userStake == msg.value);
682 			// captainAddress.transfer(captainValue);
683 			ttgCoin.airDrop(this, captainAddress, airDropAmountOwner);   //team owner 
684 		}
685 
686 		curGame.feeValue  = curGame.feeValue.add(feeValue);
687 		betsAll[idLottery][combination].sum += userStake;
688 		betsAll[idLottery][combination].count++;
689 
690 		uint128 packed;
691 		packed = ( uint128(idLottery) << 64 ) + ( uint128(combination) << 32 ) + uint128(block.timestamp);
692 
693 		Token memory _token = Token({
694 			price: userStake,
695 			option : packed
696 		});
697 
698 		uint256 newTokenId = totalSupply++;
699 		tokens[newTokenId] = _token;
700 		_transfer(0, msg.sender, newTokenId);
701 		
702 		LogToken( "Buy", msg.sender, idLottery, uint32(newTokenId), combination, userStake);
703 	}
704 	
705 	// take win money or money for canceling lottery
706 	function redeemToken(uint256 _tokenId, uint32 teamID) public 
707 	{
708 		Token storage tkn = tokens[_tokenId];
709 
710 		uint256 packed = tkn.option;
711 		bool payout = uint8((packed >> (96)) & 0xFF)==1?true:false;
712 		uint32 idLottery = uint32((packed >> (64)) & 0xFFFFFFFF);
713 		uint32 combination = uint32((packed >> (32)) & 0xFFFFFFFF);
714 
715 		Game storage curGame = game[idLottery];
716 		
717 		require( curGame.status == Status.PAYING || curGame.status == Status.CANCELING);
718 
719 		require( msg.sender == tokenIndexToOwner[_tokenId] );	// only onwer`s token
720 		require( payout == false ); // has not paid
721 		require( combination == curGame.winCombination || curGame.status == Status.CANCELING );
722 
723 		uint256 sumPayment = 0;
724 		if ( curGame.status == Status.CANCELING ) sumPayment = tkn.price;
725 		if ( curGame.status == Status.PAYING ){			
726 			sumPayment = curGame.betsSumIn * tkn.price / betsAll[idLottery][curGame.winCombination].sum;
727 			address teamOwner = itemToken.ownerOf(teamID);
728 				if(teamOwner!=0x0){					
729 					teamOwner.transfer(sumPayment.div(100));
730 					sumPayment = sumPayment.mul(99).div(100);
731 				}
732 		}
733 
734 		payout = true;
735 		packed += uint128(payout?1:0) << 96;
736 		tkn.option = packed;
737 	
738 		msg.sender.transfer(sumPayment);
739 		
740 		LogToken( "Redeem", msg.sender, idLottery, uint32(_tokenId), combination, sumPayment);
741 	}
742 	
743 	function cancelLottery(uint32 idLottery) public 
744 	{
745 		Game storage curGame = game[idLottery];
746 		
747 		require( curGame.status == Status.PLAYING );
748 		// only owner/admin or anybody after 7 days
749 		require( msg.sender == owner || admins[msg.sender] || timenow() > curGame.dateStopBuy.add(7 * 24*60*60) );
750 
751 		curGame.status = Status.CANCELING;
752 
753 		LogEvent( "CancelLottery", curGame.nameLottery, idLottery );
754 		
755 		takeFee(idLottery);
756 	}
757 
758 	function __callback(bytes32 queryId, string _result) onlyOraclize public
759 	{
760 		uint32 idLottery = queryRes[queryId];
761 		require( idLottery != 0 );
762 
763 		Game storage curGame = game[idLottery];
764 		
765 		require( curGame.status == Status.PLAYING );
766 		require( timenow() > curGame.dateStopBuy );
767 		
768 		uint32 tmpCombination = uint32(parseInt(_result,0));
769 		
770 		string memory error = "callback";
771 		if ( tmpCombination==0 ) error = "callback_result_not_found";
772 		if ( tmpCombination > curGame.countCombinations ) { tmpCombination = 0; error = "callback_result_limit"; }
773 
774 		LogEvent( error, curGame.nameLottery, tmpCombination );
775 
776 		if (tmpCombination!=0) 
777 		{
778 			curGame.winCombination = tmpCombination;
779 			checkWinNobody(idLottery);
780 		}
781 	}
782 
783 	function resolveLotteryByOraclize(uint32 idLottery, uint32 delaySec) onlyAdmin public payable
784 	{
785 		Game storage curGame = game[idLottery];
786 		
787 		uint oraclizeFee = oraclize_getPrice( "URL", ORACLIZE_GAS_LIMIT );
788 		require(msg.value + curGame.feeValue > oraclizeFee); // if contract has not enought money to do query
789 		
790 		curGame.feeValue = curGame.feeValue + msg.value - oraclizeFee;
791 
792 		LogEvent( "ResolveLotteryByOraclize", curGame.nameLottery, delaySec );
793 		
794 		string memory tmpQuery;
795 		tmpQuery = strConcat( "json(https://totalgame.io/api/v2/game/", uint2str(idLottery), "/result.json).result" );
796 	
797 		uint32 delay;
798 		if ( timenow() < curGame.dateStopBuy ) delay = curGame.dateStopBuy - timenow() + delaySec; //TODO:need to convert to safe math
799 										  else delay = delaySec;
800 	
801 		bytes32 queryId = oraclize_query(delay, "URL", tmpQuery, ORACLIZE_GAS_LIMIT);
802 		queryRes[queryId] = idLottery;
803 	}
804 
805 	function resolveLotteryByHand(uint32 idLottery, uint32 combination) onlyAdmin public 
806 	{
807 		Game storage curGame = game[idLottery];
808 		
809 		require( curGame.status == Status.PLAYING );
810 		require( combination <= curGame.countCombinations );
811 		require( combination != 0 );
812 
813 		//require( timenow() > curGame.dateStopBuy + 2*60*60 ); //TODO: remove comment
814 
815 		curGame.winCombination = combination;
816 		
817 		LogEvent( "ResolveLotteryByHand", curGame.nameLottery, curGame.winCombination );
818 		
819 		checkWinNobody(idLottery);
820 	}
821 	
822 	function checkWinNobody(uint32 idLottery) internal
823 	{
824 		Game storage curGame = game[idLottery];
825 		
826 		curGame.status = Status.PAYING;
827 		curGame.betsSumIn = getSumInByLottery(idLottery);
828 		
829 		// nobody win = send all to feeLottery
830 		if ( betsAll[idLottery][curGame.winCombination].count == 0 )
831 		{
832 			if (curGame.betsSumIn+curGame.feeValue!=0) feeLottery = feeLottery.add(curGame.betsSumIn).add(curGame.feeValue);
833 			LogEvent( "NOBODYWIN", curGame.nameLottery, curGame.betsSumIn+curGame.feeValue );
834 		}
835 		else 
836 			takeFee(idLottery);
837 	}
838 	
839 	function takeFee(uint32 idLottery) internal
840 	{
841 		Game storage curGame = game[idLottery];
842 		
843 		// take fee
844 		if ( curGame.feeValue > 0 )
845 		{
846 			feeLottery = feeLottery + curGame.feeValue;
847 			LogEvent( "TakeFee", curGame.nameLottery, curGame.feeValue );
848 		}
849 	}
850 	
851 	function withdraw() onlyOwner public
852 	{
853 		require( feeLottery > 0 );
854 
855 		uint256 tmpFeeLottery = feeLottery;
856 		feeLottery = 0;
857 		
858 		owner.transfer(tmpFeeLottery);
859 		LogEvent( "WITHDRAW", "", tmpFeeLottery);
860 	}
861 
862 }
863 
864 
865 interface ITTGCoin {
866   function airDrop(address transmitter, address receiver, uint amount) public  returns (uint actual);  
867 }
868 
869 interface IItemToken {
870     function ownerOf (uint256 _itemId) public view returns (address _owner);  
871 }