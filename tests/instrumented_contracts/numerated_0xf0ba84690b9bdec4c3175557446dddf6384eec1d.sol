1 pragma solidity ^0.4.19;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   /**
27   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 contract ERC721Abstract
44 {
45 	function implementsERC721() public pure returns (bool);
46 	function balanceOf(address _owner) public view returns (uint256 balance);
47 	function ownerOf(uint256 _tokenId) public view returns (address owner);
48 	function approve(address _to, uint256 _tokenId) public;
49 	function transferFrom(address _from, address _to, uint256 _tokenId) public;
50 	function transfer(address _to, uint256 _tokenId) public;
51  
52 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54 
55 	// Optional
56 	// function totalSupply() public view returns (uint256 total);
57 	// function name() public view returns (string name);
58 	// function symbol() public view returns (string symbol);
59 	// function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
60 	// function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
61 }
62 contract ERC721 is ERC721Abstract
63 {
64 	string constant public   name = "NBA ONLINE";
65 	string constant public symbol = "Ticket";
66 
67 	uint256 public totalSupply;
68 	struct Token
69 	{
70 		uint256 price;			//  value of stake
71 		uint256	option;			//  [payout]96[idLottery]64[combination]32[dateBuy]0
72 	}
73 	mapping (uint256 => Token) tokens;
74 	
75 	// A mapping from tokens IDs to the address that owns them. All tokens have some valid owner address
76 	mapping (uint256 => address) public tokenIndexToOwner;
77 	
78 	// A mapping from owner address to count of tokens that address owns.	
79 	mapping (address => uint256) ownershipTokenCount; 
80 
81 	// A mapping from tokenIDs to an address that has been approved to call transferFrom().
82 	// Each token can only have one approved address for transfer at any time.
83 	// A zero value means no approval is outstanding.
84 	mapping (uint256 => address) public tokenIndexToApproved;
85 	
86 	function implementsERC721() public pure returns (bool)
87 	{
88 		return true;
89 	}
90 
91 	function balanceOf(address _owner) public view returns (uint256 count) 
92 	{
93 		return ownershipTokenCount[_owner];
94 	}
95 	
96 	function ownerOf(uint256 _tokenId) public view returns (address owner)
97 	{
98 		owner = tokenIndexToOwner[_tokenId];
99 		require(owner != address(0));
100 	}
101 	
102 	// Marks an address as being approved for transferFrom(), overwriting any previous approval. 
103 	// Setting _approved to address(0) clears all transfer approval.
104 	function _approve(uint256 _tokenId, address _approved) internal 
105 	{
106 		tokenIndexToApproved[_tokenId] = _approved;
107 	}
108 	
109 	// Checks if a given address currently has transferApproval for a particular token.
110 	// param _claimant the address we are confirming token is approved for.
111 	// param _tokenId token id, only valid when > 0
112 	function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
113 		return tokenIndexToApproved[_tokenId] == _claimant;
114 	}
115 	
116 	function approve( address _to, uint256 _tokenId ) public
117 	{
118 		// Only an owner can grant transfer approval.
119 		require(_owns(msg.sender, _tokenId));
120 
121 		// Register the approval (replacing any previous approval).
122 		_approve(_tokenId, _to);
123 
124 		// Emit approval event.
125 		emit Approval(msg.sender, _to, _tokenId);
126 	}
127 	
128 	function transferFrom( address _from, address _to, uint256 _tokenId ) public
129 	{
130 		// Check for approval and valid ownership
131 		require(_approvedFor(msg.sender, _tokenId));
132 		require(_owns(_from, _tokenId));
133 
134 		// Reassign ownership (also clears pending approvals and emits Transfer event).
135 		_transfer(_from, _to, _tokenId);
136 	}
137 	
138 	function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
139 		return tokenIndexToOwner[_tokenId] == _claimant;
140 	}
141 	
142 	function _transfer(address _from, address _to, uint256 _tokenId) internal 
143 	{
144 		ownershipTokenCount[_to]++;
145 		tokenIndexToOwner[_tokenId] = _to;
146 
147 		if (_from != address(0)) 
148 		{
149 			emit Transfer(_from, _to, _tokenId);
150 			ownershipTokenCount[_from]--;
151 			// clear any previously approved ownership exchange
152 			delete tokenIndexToApproved[_tokenId];
153 		}
154 
155 	}
156 	
157 	function transfer(address _to, uint256 _tokenId) public
158 	{
159 		require(_to != address(0));
160 		require(_owns(msg.sender, _tokenId));
161 		_transfer(msg.sender, _to, _tokenId);
162 	}
163 
164 }
165 contract Owned 
166 {
167     address private candidate;
168 	address public owner;
169 
170 	mapping(address => bool) public admins;
171 	
172     function Owned() public 
173 	{
174         owner = msg.sender;
175         admins[owner] = true;
176     }
177 
178     function changeOwner(address newOwner) public 
179 	{
180 		require(msg.sender == owner);
181         candidate = newOwner;
182     }
183 	
184 	function confirmOwner() public 
185 	{
186         require(candidate == msg.sender); // run by name=candidate
187 		owner = candidate;
188     }
189 	
190     function addAdmin(address addr) external 
191 	{
192 		require(msg.sender == owner);
193         admins[addr] = true;
194     }
195 
196     function removeAdmin(address addr) external
197 	{
198 		require(msg.sender == owner);
199         admins[addr] = false;
200     }
201 }
202 contract Functional
203 {
204 	// parseInt(parseFloat*10^_b)
205 	function parseInt(string _a, uint _b) internal pure returns (uint) 
206 	{
207 		bytes memory bresult = bytes(_a);
208 		uint mint = 0;
209 		bool decimals = false;
210 		for (uint i=0; i<bresult.length; i++){
211 			if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
212 				if (decimals){
213 				   if (_b == 0) break;
214 					else _b--;
215 				}
216 				mint *= 10;
217 				mint += uint(bresult[i]) - 48;
218 			} else if (bresult[i] == 46) decimals = true;
219 		}
220 		if (_b > 0) mint *= 10**_b;
221 		return mint;
222 	}
223 	
224 	function uint2str(uint i) internal pure returns (string)
225 	{
226 		if (i == 0) return "0";
227 		uint j = i;
228 		uint len;
229 		while (j != 0){
230 			len++;
231 			j /= 10;
232 		}
233 		bytes memory bstr = new bytes(len);
234 		uint k = len - 1;
235 		while (i != 0){
236 			bstr[k--] = byte(48 + i % 10);
237 			i /= 10;
238 		}
239 		return string(bstr);
240 	}
241 	
242 	function strConcat(string _a, string _b, string _c) internal pure returns (string)
243 	{
244 		bytes memory _ba = bytes(_a);
245 		bytes memory _bb = bytes(_b);
246 		bytes memory _bc = bytes(_c);
247 		string memory abc;
248 		uint k = 0;
249 		uint i;
250 		bytes memory babc;
251 		if (_ba.length==0)
252 		{
253 			abc = new string(_bc.length);
254 			babc = bytes(abc);
255 		}
256 		else
257 		{
258 			abc = new string(_ba.length + _bb.length+ _bc.length);
259 			babc = bytes(abc);
260 			for (i = 0; i < _ba.length; i++) babc[k++] = _ba[i];
261 			for (i = 0; i < _bb.length; i++) babc[k++] = _bb[i];
262 		}
263         for (i = 0; i < _bc.length; i++) babc[k++] = _bc[i];
264 		return string(babc);
265 	}
266 	
267 	function timenow() public view returns(uint32) { return uint32(block.timestamp); }
268 }
269 contract NBAONLINE is Functional,Owned,ERC721{
270     using SafeMath for uint256;
271     
272     enum STATUS {
273 		NOTFOUND,		//0 game not created
274 		PLAYING,		//1 buying tickets for players
275 		PROCESSING,		//2 waiting for result
276 		PAYING,	 		//3 redeeming
277 		REFUNDING		//4 canceling the game
278 	}
279     struct Game{
280         string name;                                //GameName
281         uint256 id;                                 //Game ID
282         uint256 totalPot;                           //Total Deposit 
283         uint256 totalWinnersDeposit;                //Total Winner Deposit
284         uint256 dateStopBuy;                        //Deadline of buying tickets of the game
285         STATUS status;                              //Game Status 
286         mapping(uint8=>uint256)potDetail;           //The amount of each player in a Game
287         mapping(uint8=>uint8)result;                //The results of 30 players in a game 0:Lose 1: Win
288     }
289     mapping(uint256=>Game)private games;            //id find game
290     uint256[] private gameIdList;
291     
292     uint256 private constant min_amount = 0.005 ether;
293     uint256 private constant max_amount = 1000 ether;
294     
295     function NBAONLINE () public {
296     }
297 
298     /* Modifiers */
299     modifier onlyOwner() {
300         require(owner == msg.sender);
301         _;
302     }
303     modifier onlyAdmin {
304         require(msg.sender == owner || admins[msg.sender]);
305         _;
306     }
307 
308     function addOneGame(string _name,uint256 _deadline)onlyAdmin() external{
309         uint256 _id = gameIdList.length;
310         require(games[_id].status == STATUS.NOTFOUND);
311         require( _deadline > timenow() );
312         games[_id] = Game(_name,_id,0,0,_deadline,STATUS.PLAYING);
313         gameIdList.push(_id);
314     }
315     function getGamesLength()public view returns(uint256 length){
316         return gameIdList.length;
317     }
318     function calculateDevCut (uint256 _price) public pure returns (uint256 _devCut) {
319         return _price.mul(5).div(100); // 5%
320     }
321     function generateTicketData(uint256 idLottery, uint8 combination,uint8 status) public view returns(uint256 packed){
322         packed = (uint256(status) << 12*8) + ( uint256(idLottery) << 8*8 ) + ( uint256(combination) << 4*8 ) + uint256(block.timestamp);
323     }
324     
325     function parseTicket(uint256	packed)public pure returns(uint8 payout,uint256 idLottery,uint256 combination,uint256 dateBuy){
326 		payout = uint8((packed >> (12*8)) & 0xFF);
327 		idLottery   = uint256((packed >> (8*8)) & 0xFFFFFFFF);
328 		combination = uint256((packed >> (4*8)) & 0xFFFFFFFF);
329 		dateBuy     = uint256(packed & 0xFFFFFFFF);
330     }
331     
332     function updateTicketStatus(uint256	packed,uint8 newStatus)public pure returns(uint256 npacked){
333 		uint8 payout = uint8((packed >> (12*8)) & 0xFF);
334 		npacked = packed + (uint256(newStatus-payout)<< 12*8);
335     }
336     function buyTicket(uint256 _id, uint8 _choose)payable external{
337         Game storage curGame = games[_id];
338         require(curGame.status == STATUS.PLAYING);
339         require( timenow() < curGame.dateStopBuy );
340         require(msg.value >= min_amount);
341         require(msg.value <= max_amount);
342         require(_choose < 30&&_choose >= 0);
343         uint256 dev = calculateDevCut(msg.value);
344         uint256 deposit = msg.value.sub(dev);
345         curGame.totalPot = curGame.totalPot.add(deposit);
346         curGame.potDetail[_choose] = curGame.potDetail[_choose].add(deposit);
347 
348 		Token memory _token = Token({
349 			price: deposit,
350 			option : generateTicketData(_id,_choose,0)
351 		});
352 
353 		uint256 newTokenId = totalSupply++;
354 		tokens[newTokenId] = _token;
355 		_transfer(0, msg.sender, newTokenId);
356 
357         if(dev > 0){
358             owner.transfer(dev);
359         }
360     }
361     function cancelTicket(uint256 _tid)payable external{
362         //confirm ownership
363         require(tokenIndexToOwner[_tid] == msg.sender);
364         Token storage _token = tokens[_tid];
365         uint256 gameId   = uint256((_token.option >> (8*8)) & 0xFFFFFFFF);
366         Game storage curGame = games[gameId];
367         //confirm game status
368         require(curGame.status == STATUS.PLAYING);
369         //confirm game time 
370         require( timenow() < curGame.dateStopBuy );
371         uint8 ticketStatus = uint8((_token.option >> (12*8)) & 0xFF);
372         //confirm ticket status
373         require(ticketStatus == 0);
374         uint256 refundFee = _token.price;
375         //confirm ticket price
376         require(refundFee > 0);
377         uint8 _choose = uint8((_token.option >> (4*8)) & 0xFFFFFFFF);
378         curGame.totalPot = curGame.totalPot.sub(refundFee);
379         curGame.potDetail[_choose] = curGame.potDetail[_choose].sub(refundFee);
380         _token.option = updateTicketStatus(_token.option,3);
381         msg.sender.transfer(refundFee);
382     }
383     function openResult(uint256 _id,uint8[] _result)onlyAdmin() external{
384         Game storage curGame = games[_id];
385         require(curGame.status == STATUS.PLAYING);
386         require(timenow() > curGame.dateStopBuy + 2*60*60);
387         
388         uint256 _totalWinnersDeposit = 0;
389         for(uint256 i=0; i< _result.length; i++){
390             require(_result[i]<30&&_result[i]>=0);
391             curGame.result[_result[i]] = 1;
392             _totalWinnersDeposit = _totalWinnersDeposit.add(curGame.potDetail[_result[i]]);
393         }
394         if(_totalWinnersDeposit > 0){
395             curGame.status = STATUS.PAYING;
396             curGame.totalWinnersDeposit = _totalWinnersDeposit;
397         }else{
398             curGame.status = STATUS.REFUNDING;
399         }
400     }
401 
402     
403     function getWinningPrize(uint256 _tid)payable external{
404         require(tokenIndexToOwner[_tid] == msg.sender);
405         Token storage _token = tokens[_tid];
406         uint8 _choose = uint8((_token.option >> (4*8)) & 0xFFFFFFFF);
407         uint256 gameId   = uint256((_token.option >> (8*8)) & 0xFFFFFFFF);
408         Game storage curGame = games[gameId];
409         //confirm game status
410         require(curGame.status == STATUS.PAYING);
411         require(curGame.result[_choose] == 1);
412         require(curGame.totalWinnersDeposit > 0);
413         require(curGame.totalPot > 0);
414         uint8 ticketStatus = uint8((_token.option >> (12*8)) & 0xFF);
415         //confirm ticket status
416         require(ticketStatus == 0);
417         uint256 paybase = _token.price;
418         //confirm ticket price
419         require(paybase > 0);
420         uint256 winningPrize = 0;
421         if(curGame.totalWinnersDeposit > 0){
422             winningPrize = (paybase.mul(curGame.totalPot)).div(curGame.totalWinnersDeposit);
423         }
424         if(winningPrize > 0){
425             _token.option = updateTicketStatus(_token.option,1);
426             msg.sender.transfer(winningPrize);
427         }
428     }
429     function getRefund(uint256 _tid)payable external{
430         //confirm ownership
431         require(tokenIndexToOwner[_tid] == msg.sender);
432         Token storage _token = tokens[_tid];
433         uint256 gameId   = uint256((_token.option >> (8*8)) & 0xFFFFFFFF);
434         Game storage curGame = games[gameId];
435         //confirm game status
436         require(curGame.status == STATUS.REFUNDING);
437         require(curGame.totalWinnersDeposit == 0);
438         require(curGame.totalPot > 0);
439         uint8 ticketStatus = uint8((_token.option >> (12*8)) & 0xFF);
440         //confirm ticket status
441         require(ticketStatus == 0);
442         uint256 refundFee = _token.price;
443         //confirm ticket price
444         require(refundFee > 0);
445   
446         _token.option = updateTicketStatus(_token.option,2);
447         msg.sender.transfer(refundFee);
448     }
449     function getGameInfoById(uint256 _id)public view returns(
450     uint256 _totalPot,
451     uint256 _totalWinnersDeposit,
452     uint256 _dateStopBuy,
453     uint8 _gameStatus,
454     string _potDetail, 
455     string _results,
456     string _name
457     )
458     {
459         Game storage curGame = games[_id];
460         _potDetail = "";
461         _results = "";
462         for(uint8 i=0;i<30;i++){
463             _potDetail = strConcat(_potDetail,",",uint2str(curGame.potDetail[i]));
464             _results = strConcat(_results,",",uint2str(curGame.result[i]));
465         }
466         _totalPot = curGame.totalPot;
467         _totalWinnersDeposit = curGame.totalWinnersDeposit;
468         _dateStopBuy = curGame.dateStopBuy;
469         _name = curGame.name;
470         _gameStatus = uint8(curGame.status);
471         if ( curGame.status == STATUS.PLAYING && timenow() > _dateStopBuy ) _gameStatus = uint8(STATUS.PROCESSING);
472     }
473     function getAllGames(bool onlyPlaying,uint256 from, uint256 to)public view returns(string gameInfoList){
474         gameInfoList = "";
475         uint256 counter = 0;
476         for(uint256 i=0; i<gameIdList.length; i++){
477             if(counter < from){
478                 counter++;
479                 continue;
480             }
481             if(counter > to){
482                 break;
483             }
484             if((onlyPlaying&&games[gameIdList[i]].status == STATUS.PLAYING && timenow() < games[gameIdList[i]].dateStopBuy)||onlyPlaying==false){
485                 gameInfoList = strConcat(gameInfoList,"|",uint2str(games[gameIdList[i]].id));
486                 gameInfoList = strConcat(gameInfoList,",",games[gameIdList[i]].name);
487                 gameInfoList = strConcat(gameInfoList,",",uint2str(games[gameIdList[i]].totalPot));
488                 gameInfoList = strConcat(gameInfoList,",",uint2str(games[gameIdList[i]].dateStopBuy));
489                 if(games[gameIdList[i]].status == STATUS.PLAYING && timenow() > games[gameIdList[i]].dateStopBuy){
490                     gameInfoList = strConcat(gameInfoList,",",uint2str(uint(STATUS.PROCESSING)));
491                 }else{
492                     gameInfoList = strConcat(gameInfoList,",",uint2str(uint(games[gameIdList[i]].status)));
493                 }
494                 counter++;
495             }
496         }
497     }
498         
499     function getMyTicketList(bool active,uint256 from, uint256 to)public view returns(string info){
500         info = "";
501         uint256 counter = 0;
502         if(ownershipTokenCount[msg.sender] > 0){
503             for(uint256 i=0; i<totalSupply; i++){
504                 if(tokenIndexToOwner[i] == msg.sender){
505                     if(counter < from){
506                         counter++;
507                         continue;
508                     }
509                     if(counter > to){
510                         break;
511                     }
512                     
513                     Token memory _token = tokens[i];
514                     uint256 gameId = uint256((_token.option >> (8*8)) & 0xFFFFFFFF);
515                     uint256 tStatus = uint256((_token.option >> (12*8)) & 0xFF);
516                     uint256 dateBuy = uint256(_token.option & 0xFFFFFFFF);
517                     uint256 _choose = uint256((_token.option >> (4*8)) & 0xFFFFFFFF);
518                     uint256 otherpick = getNumbersOfPick(gameId,uint8(_choose));
519                     Game storage curGame = games[gameId];
520                     if((active&&(tStatus == 0&&(curGame.status == STATUS.PLAYING||(curGame.result[uint8(_choose)] == 1&&curGame.status == STATUS.PAYING)||curGame.status == STATUS.REFUNDING)))||active == false){
521                         info = strConcat(info,"|",uint2str(i));
522                         info = strConcat(info,",",uint2str(gameId));
523                         info = strConcat(info,",",uint2str(_token.price));
524                         info = strConcat(info,",",uint2str(dateBuy));
525                         info = strConcat(info,",",uint2str(_choose));
526                         info = strConcat(info,",",uint2str(otherpick));
527                         info = strConcat(info,",",uint2str(tStatus));
528                         if(curGame.status == STATUS.PLAYING && timenow() > curGame.dateStopBuy){
529                             info = strConcat(info,",",uint2str(uint(STATUS.PROCESSING)));
530                         }else{
531                             info = strConcat(info,",",uint2str(uint(curGame.status)));
532                         }
533                         if(tStatus == 3||curGame.potDetail[uint8(_choose)]==0){
534                             info = strConcat(info,",",uint2str(0));//Canceled ticket
535                         }else{
536                             if(curGame.totalWinnersDeposit > 0){
537                                 if(curGame.result[uint8(_choose)]==1){
538                                     //Win ticket
539                                     info = strConcat(info,",",uint2str(_token.price.mul(curGame.totalPot).div(curGame.totalWinnersDeposit)));
540                                 }else{
541                                     //Lose ticket
542                                     info = strConcat(info,",",uint2str(_token.price.mul(curGame.totalPot).div(curGame.potDetail[uint8(_choose)])));
543                                 }
544                             }else{
545                                 //Pending or Processing
546                                 info = strConcat(info,",",uint2str(_token.price.mul(curGame.totalPot).div(curGame.potDetail[uint8(_choose)])));
547                             }
548                         }
549                         if(curGame.status == STATUS.PAYING&&curGame.result[uint8(_choose)] == 1){
550                             info = strConcat(info,",",uint2str(1));
551                         }else {
552                             info = strConcat(info,",",uint2str(0));
553                         }
554                         info = strConcat(info,",",uint2str(curGame.totalPot));
555                     }
556                     counter++;
557                 }
558             }
559         }
560     }
561 
562     function getNumbersOfPick(uint256 _gid, uint8 _pick)public view returns(uint256 num){
563         require(_pick < 30&&_pick >= 0);
564         Game storage curGame = games[_gid];
565         num = 0;
566         for(uint256 i=0; i<totalSupply; i++){
567             uint256 data = tokens[i].option;
568             uint256 _gameId = uint256((data >> (8*8)) & 0xFFFFFFFF);
569             if(curGame.id == _gameId){
570                 uint8 _choose = uint8((data >> (4*8)) & 0xFFFFFFFF);
571                 uint8 tStatus = uint8((data >> (12*8)) & 0xFF);
572                 if(_pick == _choose&&tStatus!=3){
573                     num++;
574                 }
575             }
576         }
577     }
578 }