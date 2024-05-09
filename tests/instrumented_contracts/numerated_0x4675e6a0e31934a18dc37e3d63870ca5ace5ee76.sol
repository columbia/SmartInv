1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract Ownable {
4     address payable public owner;
5     address payable public developer;
6 
7 
8     event OwnershipRenounced(address indexed previousOwner);
9     event OwnershipTransferred(
10         address indexed previousOwner,
11         address indexed newOwner
12     );
13 
14 
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     constructor() public {
20         // owner = msg.sender;
21         owner = msg.sender;
22         developer = 0x67264cB47c717838Ae684F22E686d6f35dA90981;
23     }
24 
25     /**
26     * @dev Throws if called by any account other than the owner.
27     */
28     modifier onlyOwner() {
29         require(msg.sender == owner, "Only Owner Can Do This");
30         _;
31     }
32 
33     modifier onlyDeveloper() {
34         require(msg.sender == developer, "Only Developer Can Do This");
35         _;
36     }
37 
38     /**
39     * @dev Allows the current owner to relinquish control of the contract.
40     * @notice Renouncing to ownership will leave the contract without an owner.
41     * It will not be possible to call the functions with the `onlyOwner`
42     * modifier anymore.
43     */
44     function renounceOwnership() public onlyOwner {
45         emit OwnershipRenounced(owner);
46         owner = address(0);
47     }
48 
49     function renounceDevelopership() public onlyDeveloper {
50         // emit OwnershipRenounced(owner);
51         developer = address(0);
52     }
53 
54     /**
55     * @dev Allows the current owner to transfer control of the contract to a newOwner.
56     * @param _newOwner The address to transfer ownership to.
57     */
58     function transferOwnership(address payable _newOwner) public onlyOwner {
59         _transferOwnership(_newOwner);
60     }
61 
62     function transferDevelopership(address payable _newDeveloper) public onlyDeveloper {
63         require(_newDeveloper != address(0), "New Developer's Address is Required");
64         // emit OwnershipTransferred(owner, _newOwner);
65         developer = _newDeveloper;
66     }
67 
68     /**
69     * @dev Transfers control of the contract to a newOwner.
70     * @param _newOwner The address to transfer ownership to.
71     */
72     function _transferOwnership(address payable _newOwner) internal {
73         require(_newOwner != address(0), "New Owner's Address is Required");
74         emit OwnershipTransferred(owner, _newOwner);
75         owner = _newOwner;
76     }
77 }
78 
79 contract Pausable is Ownable {
80     event Pause();
81     event Unpause();
82 
83     bool public paused = false;
84 
85 
86     /**
87     * @dev Modifier to make a function callable only when the contract is not paused.
88     */
89     modifier whenNotPaused() {
90         require(!paused);
91         _;
92     }
93 
94     /**
95     * @dev Modifier to make a function callable only when the contract is paused.
96     */
97     modifier whenPaused() {
98         require(paused);
99         _;
100     }
101 
102     /**
103     * @dev called by the owner to pause, triggers stopped state
104     */
105     function pause() public onlyOwner whenNotPaused {
106         paused = true;
107         emit Pause();
108     }
109 
110     /**
111     * @dev called by the owner to unpause, returns to normal state
112     */
113     function unpause() public onlyOwner whenPaused {
114         paused = false;
115         emit Unpause();
116     }
117 }
118 
119 library SafeMath {
120     int256 constant private INT256_MIN = -2**255;
121 
122     /**
123     * @dev Multiplies two unsigned integers, reverts on overflow.
124     */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127         // benefit is lost if 'b' is also tested.
128         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129         if (a == 0) {
130             return 0;
131         }
132 
133         uint256 c = a * b;
134         require(c / a == b);
135 
136         return c;
137     }
138 
139     /**
140     * @dev Multiplies two signed integers, reverts on overflow.
141     */
142     function mul(int256 a, int256 b) internal pure returns (int256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
151 
152         int256 c = a * b;
153         require(c / a == b);
154 
155         return c;
156     }
157 
158     /**
159     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
160     */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b > 0);
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     /**
171     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
172     */
173     function div(int256 a, int256 b) internal pure returns (int256) {
174         require(b != 0); // Solidity only automatically asserts when dividing by 0
175         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
176 
177         int256 c = a / b;
178 
179         return c;
180     }
181 
182     /**
183     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
184     */
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         require(b <= a);
187         uint256 c = a - b;
188 
189         return c;
190     }
191 
192     /**
193     * @dev Subtracts two signed integers, reverts on overflow.
194     */
195     function sub(int256 a, int256 b) internal pure returns (int256) {
196         int256 c = a - b;
197         require((b >= 0 && c <= a) || (b < 0 && c > a));
198 
199         return c;
200     }
201 
202     /**
203     * @dev Adds two unsigned integers, reverts on overflow.
204     */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a);
208 
209         return c;
210     }
211 
212     /**
213     * @dev Adds two signed integers, reverts on overflow.
214     */
215     function add(int256 a, int256 b) internal pure returns (int256) {
216         int256 c = a + b;
217         require((b >= 0 && c >= a) || (b < 0 && c < a));
218 
219         return c;
220     }
221 
222     /**
223     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
224     * reverts when dividing by zero.
225     */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         require(b != 0);
228         return a % b;
229     }
230 }
231 
232 contract Fishbowl is Ownable ,Pausable{
233 
234     using SafeMath for uint;
235 
236     uint[9] fishBowlSize = [0,2000,3000,4000,7000,9000,10000,14000,17000]; //等級、尺寸轉換表
237     uint[9] fishBowlLevelByAmount = [0,1,5,10,30,50,100,150,200]; //魚數、魚缸等級對照表
238     address private playerBookAddress;
239 
240     event setPlayerBookAddrEvent(address _newPlayerBookAddr, uint _time);
241 
242     constructor(address _playerBookAddress) public{
243         playerBookAddress = _playerBookAddress;
244     }
245 
246     /* @dev only transaction system can call */
247     modifier onlyForPlayerBook(){
248         // require(msg.sender == playerBookAddress, "Only for palyerBook contract!");
249         _;
250     }
251 
252     /* @dev
253         (魚缸升級(lv8前)、新魚缸)
254         將購魚數量與魚價傳入，回傳玩家專屬魚缸資訊(新購入及升級) -> 呼叫player函數設定值 -> return 給player使用
255         uint level; //等級
256         uint fodderFee; //需支付的飼料費用(魚價*購魚數)
257         uint fishbowlSize; //魚缸倍數
258         uint admissionPrice; //基礎入場價格(魚價*購魚數*2)
259         uint amountToSale; //可銷售總額(基礎入場價格*魚缸倍數)
260     */
261     function fishBowl(uint _totalFishPrice, uint _fishAmount)
262     public view onlyForPlayerBook returns(uint fishbowlLevel, uint fishbowlSize, uint admissionPrice, uint amountToSale)
263     {
264         uint _fishbowlLevel = getFishBowlLevel(_fishAmount);
265         uint _fishbowlSize = getFishbowlSize(_fishbowlLevel);
266         uint _admissionPrice = getAdmissionPrice(_totalFishPrice);
267         uint _amountToSale = getAmountToSale(_fishbowlLevel, _admissionPrice);
268 
269         return (_fishbowlLevel, _fishbowlSize, _admissionPrice, _amountToSale);
270     }
271 
272     /* @dev
273         (多重購魚(lv8後))將原先的基礎入場價格及可購買總額、這次多重購魚購買魚數及魚價傳入，回傳多重購魚後基礎入場價格及可銷售總額
274         @notice 魚價單位轉換
275     */
276     function multipleBuy(uint _totalFishPrice, uint _oldAdmissionPrice, uint _oldAmountToSale)
277     public view onlyForPlayerBook returns(uint newAdmissionPrice, uint newAmountToSale)
278     {
279         uint _admissionPrice = getAdmissionPrice(_totalFishPrice);
280         uint _newAdmissionPrice = _admissionPrice.add(_oldAdmissionPrice);
281         uint _newAmountToSale = getAmountToSale(8, _admissionPrice).add(_oldAmountToSale);
282 
283         return (_newAdmissionPrice, _newAmountToSale);
284     }
285 
286     /*@dev 將購魚數量傳入，回傳魚缸等級 */
287     function getFishBowlLevel(uint _fishAmount) public view onlyForPlayerBook returns(uint fishbowlLevel){
288         for(uint i = 0; i < 9; i++){
289             if( _fishAmount == fishBowlLevelByAmount[i]){
290                 return i;
291             }
292         }
293     }
294 
295     /*@dev 將購魚數量與魚價傳入，回傳飼料費(魚價*購魚數) */
296     function getFodderFee(uint _fishPrice, uint _fishAmount) public pure onlyForPlayerBook returns(uint fodderFee){
297         return _fishPrice.mul(_fishAmount);
298     }
299 
300     /*@dev 將魚缸等級傳入，回傳魚缸尺寸 */
301     function getFishbowlSize(uint _fishbowlLevel) public view onlyForPlayerBook returns(uint fishbowlSize){
302         return fishBowlSize[_fishbowlLevel];
303     }
304 
305     /*@dev 將購魚總價傳入，回傳基礎入場價格(購魚總價*2)*/
306     function getAdmissionPrice(uint _totalFishPrice) public pure onlyForPlayerBook returns(uint admissionPrice){
307         return _totalFishPrice.mul(2);
308     }
309 
310     /*@dev 將魚缸等級、基礎入場價格傳入，回傳可銷售總額(基礎入場價格*魚缸倍數) */
311     function getAmountToSale(uint _fishbowlLevel, uint _admissionPrice)
312     public view onlyForPlayerBook returns(uint amountToSale)
313     {
314         return _admissionPrice.mul(getFishbowlSize(_fishbowlLevel));
315     }
316 
317     /*@dev set playerbookAddr */
318     function setPlayerBookAddr(address _newPlayerBookAddr) public onlyOwner{
319         playerBookAddress = _newPlayerBookAddr;
320 
321         emit setPlayerBookAddrEvent(_newPlayerBookAddr, now);
322     }
323 
324     /*@dev get playerbookAddr */
325     function getPlayerBookAddr() public view returns(address _playerBookAddress){
326         return playerBookAddress;
327     }
328 
329 }
330 
331 contract TransactionSystem is Ownable{
332 	using SafeMath for uint;
333 	using SafeMath for int;
334 
335 	struct GlobalData {
336 		uint fishAmount; // -> still alive fishAmount
337 		uint fishPrice;
338 		uint systemTotalFishAmount; //掛新單子用 
339 		uint selledAmount; //累積銷售魚數
340 		uint[7] priceInterval;
341 	}
342 
343 	struct PlayerSellOrderData {
344 		address payable owner;
345 		uint fishAmount;
346 		uint fishPrice;
347 		uint round;
348 	}
349 
350 	struct Queue{
351 		uint[] idList;
352 		uint front;
353 	}
354 
355 	/* Config public variables */
356 	uint constant public INIT_FISHAMOUNT = 10000;
357 	uint constant public INIT_FISHPRICE = 50 finney; // 50 * (10 ** 15) = 0.05ETH
358 	// uint constant public INIT_FISHPRICE = 91 finney; // 50 * (10 ** 15) = 0.05ETH
359 	
360 	/* Global data for the entire game */
361 	GlobalData globalData;
362 
363 	/* Player book inplement*/
364 	PlayerBook playerBook = PlayerBook(0x0);
365 	address payable public playerBookAddress;
366 
367 	/* order data */
368 	mapping(uint => uint) private priceTotalFishAmount; //每個價位玩家總共幾條魚(只有賣單)
369 	mapping(uint => Queue) public sellOrderSequence; // [價格] 單子[] (賣單)
370 
371 	/* address query */
372 	mapping(address => uint) private personSellOrders; //每個人還在的賣單紀錄
373 
374 	// Order Stored
375 	PlayerSellOrderData[] private sellOrders; //全部的賣單
376 
377 	/* 系統坊賣單 */
378 	mapping(uint => uint) systemFishAmount; //價格 對應的魚數
379 	uint systemFishPriceCumulativeCount;
380 
381 	// 長肉模式用
382 	bool public isFleshUp; //是否為長肉的 flag，true 代表是
383 	uint public fleshUpCount; //長肉模式總共會賣出的魚數
384 	bool public haveFish; //區間還有多少魚
385 
386 	// 紀錄繁殖區塊
387 	uint[] private reproductionBlockNumbers;
388 
389 	event changePriceEvent(address indexed _contract, uint indexed _price, uint _timestamp);
390 	event orderEvent(address indexed _from, uint _amount, uint _timestamp);
391 	event fleshUpEvent(uint _price, uint fleshUpCount, uint _timestamp);
392 
393 	/* contructor */
394 	constructor() public {
395 		globalData = GlobalData({
396 			fishAmount: INIT_FISHAMOUNT,
397 			fishPrice: INIT_FISHPRICE,
398 			systemTotalFishAmount: 0,
399 			selledAmount: 0,
400 			priceInterval: [uint256(50 finney), uint256(51 finney), uint256(52 finney), uint256(53 finney), uint256(54 finney), uint256(55 finney), uint256(56 finney)]
401 			// priceInterval: [uint256(93 finney), uint256(94 finney), uint256(95 finney), uint256(96 finney), uint256(97 finney), uint256(98 finney), uint256(99 finney)]
402 		});
403 		isFleshUp = false;
404 		/* Initial order setup */
405 		/* @dev
406 			1.初始系統庫存魚數:10000 
407 			2.交易系統中已顯示的 7 個價位,第一優先掛賣庫存魚數的 2% 取整數計算(無條件捨去)。 
408 			3.交易系統中出現新價位(高價格)時, 第一優先掛賣庫存魚數的 2%, 取整數計算(無條件捨去)。 
409 		*/
410 		globalData.systemTotalFishAmount = INIT_FISHAMOUNT;
411 		// globalData.systemTotalFishAmount = 6000;
412 		for (uint orderPrice = INIT_FISHPRICE; orderPrice < INIT_FISHPRICE.add(7 finney); orderPrice = orderPrice.add(1 finney)) {
413 			systemFishAmount[orderPrice] = 200;
414 		}/*
415 		systemFishAmount[97 finney] = 200;
416 		systemFishAmount[98 finney] = 39;
417 		systemFishAmount[99 finney] = 123;
418 		fleshUpCount = 700;
419 		isFleshUp = true;*/
420 		reproductionBlockNumbers.push(0);
421 		systemFishPriceCumulativeCount = 56 finney; //初始累進最高價位為 56
422 		// systemFishPriceCumulativeCount = 99 finney; //初始累進最高價位為 56
423 	}
424 
425 	//only call from playerbook is allowed
426 	modifier onlyPlayerBook() {
427 		require(msg.sender == playerBookAddress);
428 		_;
429 	}
430 
431 	//if u want to make a donation... <3
432 	function() payable external{
433 		playerBookAddress.transfer(msg.value);
434 	}
435 
436 	
437 	/* @dev
438 		0. need setup playerBookAddress first
439 		1. all call should from playerBook (this contract should not get any ETH)
440 		2. price should been preprocess from playerBook
441 	*/
442 	//買魚並記錄金額。
443 	function addNewBuyOrder(address payable _buyer, uint _fishAmount, uint _balance, bool _isRebuy)
444 		public
445 		onlyPlayerBook()
446 	{
447 		//require(_fishAmount <= 200); //max value //或是 playerbook 檢查
448 		/* @dev
449 			魚價範圍 0.05~0.1ETH ，以 0.001 為一個檔位做跳動. -> 50~100
450 			每個檔位最高可掛賣數量為總可交易魚數的 5%, 
451 		*/
452 
453 		//addFishAmount -> 處理買家飼料費
454 		//sellerProcessProfit -> 處理賣家獲利
455 		//交易總共投入金額
456 		uint totalCost = 0; //處理跨價購買的問題
457 		uint _addFishAmount = 0; //總共要增加的魚數
458 		uint _tempRound = playerBook.reproductionRound();
459 
460 		Queue storage Q = sellOrderSequence[globalData.fishPrice];
461 		while(_fishAmount > 0){ 
462 			//系統還有魚 -> 進入系統單
463 			if(systemFishAmount[globalData.fishPrice] > 0){ 
464 				//系統能賣夠
465 				if(_fishAmount <= systemFishAmount[globalData.fishPrice]){
466 					//最終要新增的魚數量
467 					_addFishAmount = _addFishAmount.add(_fishAmount);
468 					//扣掉花費
469 					_balance = _balance.sub(_fishAmount.mul(globalData.fishPrice));
470 					totalCost = totalCost.add(_fishAmount.mul(globalData.fishPrice));
471 						
472 					//更新 player 狀態 //totalCost , isBuy
473 					playerBook.addFishAmount(_buyer, _addFishAmount, totalCost, true);
474 					//更新全域賣出魚數
475 					globalData.selledAmount = globalData.selledAmount.add(_fishAmount);
476 					//更新賣家
477 					playerBook.sellerProcessProfit(playerBookAddress, _fishAmount.mul(globalData.fishPrice));
478 					//更新系統該價位魚的資訊
479 					systemFishAmount[globalData.fishPrice] = systemFishAmount[globalData.fishPrice].sub(_fishAmount);
480 					globalData.systemTotalFishAmount = globalData.systemTotalFishAmount.sub(_fishAmount);
481 					//減少要購買的數量
482 					_fishAmount = 0;
483 
484 					//找零
485 					if(_balance > 0 && _isRebuy == false){ 
486 						uint temp = _balance;
487 						_balance = 0;
488 						playerBook.buyOrderRefund(_buyer, temp);
489 					}
490 
491 					if( priceTotalFishAmount[globalData.fishPrice] == 0 && systemFishAmount[globalData.fishPrice] == 0 ){
492 						changePriceInterval();
493 						Q = sellOrderSequence[globalData.fishPrice]; //To-Notice: 不知道這樣會不會 work
494 					}
495 					break;
496 				}else{
497 					//要新增的魚數量
498 					_addFishAmount = _addFishAmount.add(systemFishAmount[globalData.fishPrice]);
499 					//減少要購買的數量
500 					_fishAmount = _fishAmount.sub(systemFishAmount[globalData.fishPrice]);
501 					//扣掉花費
502 					_balance = _balance.sub(systemFishAmount[globalData.fishPrice].mul(globalData.fishPrice));
503 					totalCost = totalCost.add(systemFishAmount[globalData.fishPrice].mul(globalData.fishPrice));
504 					//不能更新 player 狀態，因為沒買完
505 					//更新全域賣出魚數
506 					globalData.selledAmount = globalData.selledAmount.add(systemFishAmount[globalData.fishPrice]);
507 					//更新賣家
508 					playerBook.sellerProcessProfit(playerBookAddress, systemFishAmount[globalData.fishPrice].mul(globalData.fishPrice));
509 					//更新系統該價位魚的資訊
510 					globalData.systemTotalFishAmount = globalData.systemTotalFishAmount.sub(systemFishAmount[globalData.fishPrice]);
511 					systemFishAmount[globalData.fishPrice] = 0;
512 				}
513 			}
514 
515 			//系統處理完還有魚(不會 break) -> 進入玩家賣單
516 			
517 			//當玩家沒有賣單 -> 跳價格
518 			if( priceTotalFishAmount[globalData.fishPrice] == 0 ){
519 				changePriceInterval();
520 				Q = sellOrderSequence[globalData.fishPrice]; //To-Notice: 不知道這樣會不會 work
521 				if ( playerBook.reproductionRound() > _tempRound ) {
522 					_addFishAmount = _addFishAmount.mul(2);
523 					_tempRound = playerBook.reproductionRound();
524 				}
525 				continue; //或可以把整個 if 放到迴圈末端
526 			}
527 
528 			//檢查單子是否存在
529 			if(sellOrders[ Q.idList[Q.front] ].fishAmount <= 0){
530 				Q.front++;
531 				continue;
532 			}
533 
534 			//處理繁殖次數 (amount = amount * 2**(globalRound - localRound))
535 			uint realAmount = sellOrders[ Q.idList[Q.front] ].fishAmount.mul( 2 **(playerBook.reproductionRound().sub(sellOrders[ Q.idList[Q.front] ].round)) );
536 			//魚的數量 overflow 可能另外檢查(?) (To-Notice)
537 
538 			if(_fishAmount >= realAmount){
539 				//買的完，不用改賣單
540 
541 				//要新增的魚數量
542 				_addFishAmount = _addFishAmount.add(realAmount);
543 				//減少要購買的數量
544 				_fishAmount = _fishAmount.sub(realAmount);
545 				//扣掉花費
546 				_balance = _balance.sub(realAmount.mul(globalData.fishPrice));
547 				totalCost = totalCost.add(realAmount.mul(globalData.fishPrice));
548 
549 				//不能更新 player 狀態，因為沒買完
550 				//更新全域賣出魚數
551 				globalData.selledAmount = globalData.selledAmount.add(realAmount);
552 				//更新賣家
553 				playerBook.sellerProcessProfit(sellOrders[ Q.idList[Q.front] ].owner, realAmount.mul(globalData.fishPrice));
554 				delete sellOrders[ Q.idList[Q.front] ]; //刪除該筆賣單
555 				delete Q.idList[Q.front]; //刪除該筆排序
556 				//更新該價位魚的總量
557 				priceTotalFishAmount[globalData.fishPrice] = priceTotalFishAmount[globalData.fishPrice].sub(realAmount);
558 				//下一筆賣單
559 				Q.front++;
560 			}else{ 
561 				//剩下要購買的魚數量 < 賣單的
562 				//買完了，但買不完賣單，修改賣單魚數
563 				//注意 realFishAmount (To-Notice)
564 
565 				//要新增的魚數量 
566 				_addFishAmount = _addFishAmount.add(_fishAmount);
567 					
568 				//扣掉花費
569 				_balance = _balance.sub(_fishAmount.mul(globalData.fishPrice));
570 				totalCost = totalCost.add(_fishAmount.mul(globalData.fishPrice));
571 					
572 				//更新 player 狀態 //isBuy
573 				playerBook.addFishAmount(_buyer, _addFishAmount, totalCost, true);
574 				//更新全域賣出魚數
575 				globalData.selledAmount = globalData.selledAmount.add(_fishAmount);
576 				//更新賣家
577 				playerBook.sellerProcessProfit(sellOrders[ Q.idList[Q.front] ].owner, _fishAmount.mul(globalData.fishPrice));
578 				//更新賣單的狀態
579 				sellOrders[ Q.idList[Q.front] ].fishAmount = realAmount.sub(_fishAmount);
580 				sellOrders[ Q.idList[Q.front] ].round = playerBook.reproductionRound();
581 
582 				//更新該價位魚的總量
583 				priceTotalFishAmount[globalData.fishPrice] = priceTotalFishAmount[globalData.fishPrice].sub(_fishAmount);
584 					
585 				//減少要購買的數量
586 				_fishAmount = 0;
587 
588 				//找零
589 				if(_balance > 0 && _isRebuy == false){ 
590 					uint temp = _balance;
591 					_balance = 0;
592 					playerBook.buyOrderRefund(_buyer, temp);
593 				}
594 				break;
595 			}
596 		}
597 		
598 		emit orderEvent(_buyer, _addFishAmount, now);
599 	}
600 
601 	function getEstimateFishPrice(uint _fishAmount) external view returns(uint){
602 		uint tempBalance = 0;
603 		uint tempFishPrice = globalData.fishPrice;
604 		uint tempFishAmount = _fishAmount;
605 		bool tempJumpPrice = isFleshUp;
606 		uint tempfleshUpCount = fleshUpCount;
607 		while(tempFishAmount > 0){
608 			//To-Notice 跳價格後的價格區間
609 			//價格往下跳不管
610 			if(systemFishAmount[tempFishPrice] >= tempFishAmount || tempFishPrice > globalData.priceInterval[6]){//99->100 100
611 				// > priceInterval[6] 代表跑到最新的系統單去了
612 				tempBalance = tempBalance.add(tempFishAmount.mul(tempFishPrice));
613 				tempFishAmount = 0;
614 				break;		
615 			}else{
616 				tempFishAmount = tempFishAmount.sub(systemFishAmount[tempFishPrice]);//減掉該價位所有魚
617 				tempBalance = tempBalance.add(systemFishAmount[tempFishPrice].mul(tempFishPrice));//花費增加
618 				if(priceTotalFishAmount[tempFishPrice] > tempFishAmount){
619 					tempBalance = tempBalance.add(tempFishAmount.mul(tempFishPrice));
620 					tempFishAmount = 0;
621 					break;	
622 				}else{
623 					tempFishAmount = tempFishAmount.sub(priceTotalFishAmount[tempFishPrice]);
624 					tempBalance = tempBalance.add(priceTotalFishAmount[tempFishPrice].mul(tempFishPrice));
625 				}	
626 			}
627 
628 			//價格變動方向
629 			if(tempJumpPrice == false){//不是長肉就正常跳價
630 				//跑完所有顯示過的價位後沒變動的話，目前價位 + 1
631 				tempFishPrice = tempFishPrice.add(1 finney);
632 				for(uint i = tempFishPrice; i < 100 finney; i = i.add(1 finney)){
633 					if(priceTotalFishAmount[i] > 0 || systemFishAmount[i] > 0){
634 						tempFishPrice = i; 
635 						break;
636 					}
637 				}
638 
639 			}else if(tempFishPrice == globalData.priceInterval[6]){ //長肉結束，跳到新的價位 -> 不一定超過 globalData.priceInterval[6]
640 				//會進到 else 代表 isFleshUp == true
641 				tempJumpPrice = false;
642 				//清空累計銷售
643 				//globalData.selledAmount = 0;
644 				// 678 * 100 / 10000 = 6.78
645 				if(tempFishPrice == 99 finney){//如果為準繁殖 -> 下一輪
646 					tempFishPrice = 100 finney;
647 				}else{
648 					tempFishPrice = tempFishPrice.add( tempfleshUpCount.mul(100).div(globalData.fishAmount).mul(1 finney) ); //要加的價位
649 					if(tempfleshUpCount.mul(100) % globalData.fishAmount > 0){ //無條件進位
650 						tempFishPrice = tempFishPrice.add(1 finney);
651 					}
652 					if(tempFishPrice > 99 finney){ //估價的部分可以多估
653 						tempFishPrice = 101 finney;
654 					}
655 				}
656 			}else if(tempJumpPrice == true || globalData.selledAmount.add(_fishAmount - tempFishAmount).mul(50) >= globalData.fishAmount){ //這邊處理到新價位後，達到長肉 2% 的狀況
657 				if(tempJumpPrice == false){
658 					tempfleshUpCount = 0; //第一次進入，把凍結區間的總魚數歸零
659 				}
660 
661 				for(uint i = globalData.priceInterval[0]; i <= globalData.priceInterval[6] && tempJumpPrice == false; i += 1 finney){
662 					//第一次進入，紀錄凍結後的總魚數
663 					tempfleshUpCount += priceTotalFishAmount[i];
664 					tempfleshUpCount += systemFishAmount[i];
665 				}
666 				tempJumpPrice = true; //鎖住掛賣
667 				tempFishPrice = tempFishPrice.add(1 finney);
668 				//7檔位不動
669 			}
670 		} 
671 		tempBalance = tempBalance.mul(110);
672 		tempBalance = tempBalance.div(100);
673 		return tempBalance;
674 	}
675 
676 	/* Add new order to the contract */
677 	function addNewSellOrder(address payable _seller, uint _fishAmount, uint _fishPrice) 
678 		public 
679 		onlyPlayerBook()
680 	{
681 		/*
682 			每個檔位最高可掛賣數量為總可交易魚數的 2%
683 			玩家只能掛 10% -> PB 檢查
684 		*/
685 		//長肉不可掛單
686 		require(isFleshUp == false, "isFleshUp");
687 
688 		//check is legal price interval
689 		if(_fishPrice == globalData.fishPrice
690 			|| _fishPrice < globalData.priceInterval[0] 
691 			|| (_fishPrice > globalData.priceInterval[6] && _fishPrice != 100 finney)
692 		){
693 			revert("out of range");
694 		}
695 
696 		/*
697 			當魚的時價來到 0.099 時進入準繁殖狀態, 所有<0.99價位不可掛賣
698 			系統只會出現 0.099 跟 0.1  這 2 個價位   
699 			0.1 價位為預掛單 <- ,總掛賣量上限為總可交易魚數的 3% 
700 		*/
701 		// only price=99 then allow price=100 orders
702 		if(globalData.fishPrice < 99 finney && _fishPrice > 99 finney){
703 			revert("out of range");
704 		}
705 		// if global price>=99 only 0.1 ETH orders is allowed
706 		if(globalData.fishPrice >= 99 finney && _fishPrice != 100 finney){
707 			revert("0.099 only allowed 0.1 eth");
708 		}
709 
710 		//not current price legal amount (2% allowed)
711 		if( priceTotalFishAmount[_fishPrice].add(systemFishAmount[_fishPrice]).add(_fishAmount).mul(50) > globalData.fishAmount ){
712 			revert("no more than 2% total fishAmount");
713 		}
714 		if(globalData.fishPrice == 99 finney && priceTotalFishAmount[50 finney].add(systemFishAmount[50 finney]).add(_fishAmount).mul(25) > globalData.fishAmount ){
715 			revert("no more than 2% total fishAmount");
716 		}
717 
718 		require(_fishAmount > 0, "no zero fish"); //不能掛 0 條
719 
720 		require(_fishPrice % (1 finney) == 0, "illegal price");
721 
722 		//檢查是否已有掛單
723 		require(sellOrders.length == 0 || sellOrders[ personSellOrders[_seller] ].owner != _seller, "already exist");
724 
725 		//reduce _seller fishAmount
726 		playerBook.minusFishAmount(_seller, _fishAmount);
727 		
728 		//add Order
729 		uint sellOrdersCount = sellOrders.length;
730 		if(_fishPrice == 100 finney){ //100 的玩家單其實為下一輪 50 的玩家掛單
731 			_fishAmount = _fishAmount.mul(2);
732 			_fishPrice = 50 finney;
733 			sellOrders.push( PlayerSellOrderData({
734 				owner: _seller,
735 				fishAmount: _fishAmount,
736 				fishPrice: _fishPrice,
737 				//要記錄繁殖階段
738 				round: playerBook.reproductionRound().add(1)
739 			}) );
740 		}else{
741 			sellOrders.push( PlayerSellOrderData({
742 				owner: _seller,
743 				fishAmount: _fishAmount,
744 				fishPrice: _fishPrice,
745 				//要記錄繁殖階段
746 				round: playerBook.reproductionRound()
747 			}) );
748 		}
749 
750 		//更新該價位整體魚數
751 		priceTotalFishAmount[_fishPrice] = priceTotalFishAmount[_fishPrice].add(_fishAmount);
752 		// Can improve by double-linked-list (or Not?)
753 		personSellOrders[_seller] = sellOrdersCount; //owner
754 		sellOrderSequence[_fishPrice].idList.push(sellOrdersCount); //system
755 
756 		emit orderEvent(_seller, _fishAmount, now);
757 	}
758 
759 
760 	// Cancel sell order 
761 	function cancelSellOrder(address payable _caller, uint _orderId)
762 		public
763 		onlyPlayerBook()
764 	{
765 		if(sellOrders.length <= _orderId){
766 			revert("id error");
767 		}
768 
769 		if(sellOrders[_orderId].owner != _caller){ //less gas cost, since cancel probably fail
770 			revert("only owner");
771 		}
772 
773 		if(globalData.fishPrice == 99 finney && sellOrders[_orderId].fishPrice == 50 finney){ //避免被在價位 99 用來洗 50 的魚數
774 			revert("0.099 not allowed cancel 0.1 eth order");
775 		}
776 
777 		require(isFleshUp == false, "isFleshUp");
778 
779 		//處理魚繁殖問題
780 		uint tempFishAmount = sellOrders[_orderId].fishAmount.mul(2 **(playerBook.reproductionRound().sub(sellOrders[_orderId].round)) );
781         uint _fishPrice = sellOrders[_orderId].fishPrice;
782 		delete sellOrders[_orderId];
783 
784 		//return fish Amount to _caller
785 		playerBook.addFishAmount(_caller, tempFishAmount, 0, false);
786 
787 		//更新該價位整體魚數
788 		priceTotalFishAmount[_fishPrice] = priceTotalFishAmount[_fishPrice].sub(tempFishAmount);
789 
790 		personSellOrders[_caller] = 0; //清空 owner 掛單
791 
792 		emit orderEvent(_caller, tempFishAmount, now);
793 	}
794 
795 
796 	/* reproduce */
797 	function reproductionStage()
798 		private
799 	{
800 		//魚變兩倍 & 更新價位 & 累進計數器
801 		globalData.fishAmount = globalData.fishAmount.mul(2);
802 		globalData.systemTotalFishAmount = globalData.systemTotalFishAmount.mul(2);
803 		globalData.fishPrice = 50 finney;
804 		globalData.selledAmount = 0;
805 		systemFishPriceCumulativeCount = 56 finney;
806 		isFleshUp = false;
807 
808 		//更新個別價位 總魚數
809 		uint _addSystemFishAmount = globalData.systemTotalFishAmount.div(50);
810 		uint j=1;
811 		globalData.priceInterval[0] = 50 finney; //50 其他在跳價格處理
812 		for(uint i = 51 finney; i <= 98 finney; i += 1 finney){ //只更新到 98 (99賣完 -> 回到 50)
813 			priceTotalFishAmount[i] = priceTotalFishAmount[i].mul(2); //殘存玩家單
814 			systemFishAmount[i] = systemFishAmount[i].mul(2); //殘存系統單
815 			//systemFishAmount 直接加新的的
816 			if(i <= 56 finney){
817 				globalData.priceInterval[j] = i;
818 				j++;
819 				systemFishAmount[i] = systemFishAmount[i].add(_addSystemFishAmount);
820 			}
821 		}
822 
823 		//告知 playerBook 更新 round 資訊
824 		playerBook.addReproductionRound();
825 		reproductionBlockNumbers.push(block.number);
826 	}
827 
828 
829 	function changePriceInterval() 
830 		private
831 	{
832 		/*
833 			檢查是否長肉:
834 				每個檔位銷售完後, 每當累計銷售量大於等於到總可交易魚數的 2%
835 		*/
836 		
837 		
838 		if( isFleshUp == true || globalData.selledAmount.mul(50) >= globalData.fishAmount ){//長肉模式
839 			if(isFleshUp == false){
840 				fleshUpCount = 0; //第一次進入，把凍結區間的總魚數歸零
841 			}
842 
843 			haveFish = false;// 長肉的正常跳價
844 			for(uint i = globalData.priceInterval[0]; i <= globalData.priceInterval[6]; i += 1 finney){
845 				if(haveFish == false &&(priceTotalFishAmount[i] > 0 || systemFishAmount[i] > 0)){
846 					globalData.fishPrice = i;
847 					haveFish = true;
848 				}
849 				if(isFleshUp == false){ //第一次進入，紀錄凍結後的總魚數
850 					fleshUpCount += priceTotalFishAmount[i];
851 					fleshUpCount += systemFishAmount[i];
852 				}
853 			}
854 			isFleshUp = true; //鎖住掛賣
855 			//7檔位不動
856 			//清空累計銷售
857 			globalData.selledAmount = 0;
858 
859 			if(fleshUpCount == 0){ //避免進入長肉，結果區間沒有魚
860 				//變回正常跳價
861 				//檢查價位往哪 (下3 or 上最多變成 0.099 eth 價位)
862 				for(uint i = globalData.priceInterval[0]; i < 100 finney; i = i.add(1 finney)){
863 					if(priceTotalFishAmount[i] > 0 || systemFishAmount[i] > 0){
864 						globalData.fishPrice = i; //99 一定有魚，沒魚就長肉了
865 						break;
866 					} //          98 -> 95 -> 92 -> *89 -> 94* -> 99
867 				}
868 				isFleshUp = false;
869 			}else if(haveFish == false){//長肉結束，跳到新的價位
870 				//會進到 else 代表 isFleshUp == true
871 				isFleshUp = false;
872 				//清空累計銷售
873 				globalData.selledAmount = 0;
874 				// 678 * 100 / 10000 = 6.78
875 				if(globalData.fishPrice == 99 finney){//如果為準繁殖 -> 下一輪
876 					globalData.fishPrice = 100 finney;
877 				}else{
878 					globalData.fishPrice = globalData.fishPrice.add( fleshUpCount.mul(100).div(globalData.fishAmount).mul(1 finney) ); //要加的價位
879 					if(fleshUpCount.mul(100) % globalData.fishAmount > 0){ //無條件進位
880 						globalData.fishPrice = globalData.fishPrice.add(1 finney);
881 					}
882 					if(globalData.fishPrice > 99 finney){
883 						globalData.fishPrice = 99 finney;
884 					}
885 				}
886 				//跳完價格後，跳到無魚的地方由 line 629 開始處裡
887 			}
888 
889 			emit fleshUpEvent(globalData.fishPrice, fleshUpCount, now);
890 		}else{
891 			//不是長肉就正常跳價
892 			if(globalData.fishPrice == 99 finney){//如果為準繁殖 -> 下一輪
893 				globalData.fishPrice = 100 finney;
894 			}else{
895 				//檢查價位往哪 (下3 or 上最多變成 0.099 eth 價位)
896 				for(uint i = globalData.priceInterval[0]; i < 100 finney; i = i.add(1 finney)){
897 					if(priceTotalFishAmount[i] > 0 || systemFishAmount[i] > 0){
898 						globalData.fishPrice = i; //99 一定有魚，沒魚就長肉了
899 						break;
900 					} //          98 -> 95 -> 92 -> *89 -> 94* -> 99
901 				}
902 			}
903 		}
904 
905 		//如果繁殖 -> 由繁殖修改資訊
906 		if(globalData.fishPrice > 99 finney){
907 			reproductionStage();
908 			return;
909 		}
910 		
911 		// 94 [95] 96 97 |98| 99
912 		// 97 -> 98 cumulativecount = 99
913 		// 93-> 99 確實會進入這邊，但因為只會更新到 99 價位，所以不會動到 100
914 		if(globalData.fishPrice.add(3 finney) > systemFishPriceCumulativeCount && systemFishPriceCumulativeCount < 99 finney && isFleshUp == false){//讓 99 , 而且不是長肉
915 			// 交易系統中出現新價位(高價格)時, 第一優先掛賣庫存魚數的 2%, 取整數計算(無條件捨去)。 
916 			uint _addSystemFishAmount = globalData.systemTotalFishAmount.div(50);
917 			uint newPrice = globalData.fishPrice.add(3 finney); 
918 			if(newPrice > 99 finney){
919 				newPrice = 99 finney;
920 			}
921 			//更新 systemFishAmount
922 			for(uint i = globalData.fishPrice; i <= newPrice; i = i.add(1 finney)){ //從當前價位更新魚數，而不用管前面的價位(就算是新的)
923 				if(systemFishAmount[i] == 0){ //沒有掛過魚 (舊的價位不該進到這個判斷，systemFishPriceCumulativeCount 不會讓舊的價位部署上去)
924 					systemFishAmount[i] = systemFishAmount[i].add(_addSystemFishAmount);
925 				}
926 			}
927 			systemFishPriceCumulativeCount = newPrice;
928 			//由價位更新 priceInterval
929 			// for(uint i = 6; i >= 0; i--){
930 			// 	globalData.priceInterval[i] = newPrice.sub( (6-i).mul(1 finney));
931 			// }
932 			globalData.priceInterval[0] = newPrice.sub(6 finney);
933 			globalData.priceInterval[1] = newPrice.sub(5 finney);
934 			globalData.priceInterval[2] = newPrice.sub(4 finney);
935 			globalData.priceInterval[3] = newPrice.sub(3 finney);
936 			globalData.priceInterval[4] = newPrice.sub(2 finney);
937 			globalData.priceInterval[5] = newPrice.sub(1 finney);
938 			globalData.priceInterval[6] = newPrice;
939 		}else if(globalData.fishPrice < 96 finney && globalData.fishPrice.sub(3 finney) >= 50 finney && isFleshUp == false){ //加上不是長肉
940 			//|96| 97 98 99  
941 			//50 51 52 |53|<-54
942 			globalData.priceInterval[0] = globalData.fishPrice.sub(3 finney);
943 			globalData.priceInterval[1] = globalData.fishPrice.sub(2 finney);
944 			globalData.priceInterval[2] = globalData.fishPrice.sub(1 finney);
945 			globalData.priceInterval[3] = globalData.fishPrice;
946 			globalData.priceInterval[4] = globalData.fishPrice.add(1 finney);
947 			globalData.priceInterval[5] = globalData.fishPrice.add(2 finney);
948 			globalData.priceInterval[6] = globalData.fishPrice.add(3 finney);
949 		}
950 
951 		if(priceTotalFishAmount[globalData.fishPrice] == 0 && systemFishAmount[globalData.fishPrice] == 0){//避免跳到一個沒魚的舊價位
952 			for(uint i = globalData.priceInterval[0]; i < 100 finney; i = i.add(1 finney)){
953 				if(priceTotalFishAmount[i] > 0 || systemFishAmount[i] > 0){
954 					globalData.fishPrice = i; //99 一定有魚，沒魚就長肉了
955 					break;
956 				} //          98 -> 95 -> 92 -> *89 -> 94* -> 99
957 			}
958 		}
959 
960 		if(globalData.fishPrice == 99 finney){ //新的價位為 99 的話，繁殖的問題系統單
961 			priceTotalFishAmount[50 finney] = priceTotalFishAmount[50 finney].mul(2); //先繁殖下一輪的 50 價位
962 			uint _addSystemFishAmount = globalData.systemTotalFishAmount.div(50); //2%
963 			systemFishAmount[50 finney] = systemFishAmount[50 finney].add(_addSystemFishAmount).mul(2);
964 
965 			//如果還是要讓 100 顯示 100，而不是下一輪的 50
966 			uint newPrice = 100 finney;
967 			globalData.priceInterval[0] = newPrice.sub(6 finney);
968 			globalData.priceInterval[1] = newPrice.sub(5 finney);
969 			globalData.priceInterval[2] = newPrice.sub(4 finney);
970 			globalData.priceInterval[3] = newPrice.sub(3 finney);
971 			globalData.priceInterval[4] = newPrice.sub(2 finney);
972 			globalData.priceInterval[5] = newPrice.sub(1 finney);
973 			globalData.priceInterval[6] = newPrice;
974 		}
975 
976 		emit changePriceEvent(address(this), globalData.fishPrice, now);
977 	}
978 
979 	//@dev 減少可交易魚數
980 	function deadFish(uint _fishAmount) 
981 		external
982 		onlyPlayerBook
983 	{
984 		globalData.fishAmount = globalData.fishAmount.sub(_fishAmount);
985 	}
986 
987 
988 	function setPlayerBookAddress(address payable _PBaddress) 
989 		external
990 		onlyOwner
991 	{
992 		playerBookAddress = _PBaddress;
993 		playerBook = PlayerBook(_PBaddress);
994 	}
995 
996 
997 
998 	function getPersonSellOrders()
999 		external
1000 		view
1001 		returns(uint)
1002 	{
1003 		return(personSellOrders[msg.sender]);
1004 	}
1005 
1006 
1007 	function getSellOrderData(uint _orderId)
1008 		external
1009 		view
1010 		returns(address, uint, uint)
1011 	{
1012 		return(sellOrders[_orderId].owner, sellOrders[_orderId].fishAmount, sellOrders[_orderId].fishPrice);
1013 	}
1014 
1015 
1016 	function showGlobalData() 
1017 		public
1018 		view
1019 		returns( uint _fishAmount, uint _fishPrice, uint _selledAmount )
1020 	{
1021 		return( 
1022 			globalData.fishAmount,
1023 			globalData.fishPrice,
1024 			globalData.selledAmount
1025 		);
1026 	}
1027 
1028 
1029 	function showAvaliablePriceInterval() 
1030 		public 
1031 		view
1032 		returns (uint256 [7] memory) 
1033 	{
1034 		return globalData.priceInterval;
1035 	}
1036 
1037 
1038 	function showPriceIntervalFishAmount()
1039 		public 
1040 		view
1041 		returns (uint256 [7] memory) 
1042 	{
1043 		uint[7] memory temp;
1044 		for(uint i = 0; i < 7; i++){
1045 			uint tempPrice = globalData.priceInterval[i];
1046 			if(tempPrice == 100 finney){
1047 				temp[i] += priceTotalFishAmount[50 finney];
1048 				temp[i] += systemFishAmount[50 finney];
1049 				temp[i] /= 2;
1050 			}else{
1051 				temp[i] += priceTotalFishAmount[tempPrice];
1052 				temp[i] += systemFishAmount[tempPrice];
1053 			}
1054 		}
1055 		return temp;
1056 	}
1057 
1058 	function showFish()
1059 		public 
1060 		view
1061 		returns (uint256) 
1062 	{
1063 		return globalData.systemTotalFishAmount;
1064 	}
1065 
1066 	function getRepoBlockNumbers() 
1067 		external
1068 		view
1069 		returns(uint[] memory)
1070 	{
1071 		return reproductionBlockNumbers;
1072 	}
1073 }
1074 
1075 contract Commission is Ownable ,Pausable{
1076     using SafeMath for uint;
1077 
1078     /* @dev 魚缸等級 => 影響推薦獎金趴數、魚缸尺寸倍增多寡
1079         @notice 小數點位數處理(3位)
1080     */
1081     uint[9] levelToCommission = [100,400,400,500,500,600,600,700,700]; //千分比
1082     // uint[9] levelToCommission = [100,400,400,500,500,600,600,700,700]; //千分比
1083     uint[9] fishbowlGrow = [0,0,0,0,0,0,0,0,1000]; //千分比
1084     address private playerBookAddress;
1085 
1086 
1087     /* @dev Generation model */
1088     struct Generation{
1089         /*false => 普通玩家, true=> 第一代玩家*/ //用ancestorList.length 判斷？
1090         //bool firstGeneration;
1091 
1092         /*向上，分發獎金用 => 10代 建立時檢查*/
1093         address[] ancestorList; //往上延伸，需要分發獎金的人 => push
1094 
1095         /*向下，擴增魚缸尺寸用*/
1096         address[] inviteesList; //邀請者列表
1097     }
1098     mapping (address => Generation) generations; //用每個使用者的address 對應出自己的上下線
1099 
1100 
1101 
1102     constructor(address _playerBookAddress) public{
1103         playerBookAddress = _playerBookAddress;
1104     }
1105 
1106     event firstGenerationJoinGameEvent(address _newUser, uint _time);
1107     event joinGameEvent(address _newUser, address invitedBy, uint _time);
1108     event distributeCommissionEvent(uint[] _commission, uint _bonusPool, uint _ghostComission, uint _time);
1109     event setPlayerBookAddrEvent(address _newPlayerBookAddr, uint _time);
1110 
1111 
1112     /* @dev only transaction system can call */
1113     modifier onlyForPlayerBook(){
1114         require(msg.sender == playerBookAddress, "Only for palyerBook contract!");
1115         _;
1116     }
1117 
1118     /* @dev 第一代加入遊戲 */
1119     function firstGenerationJoinGame(address _newUser) public onlyForPlayerBook{
1120         //generations[_newUser].firstGeneration = true;
1121 
1122         emit firstGenerationJoinGameEvent(_newUser, now);
1123     }
1124 
1125     /* @dev 輸入新用戶跟他的邀請人，幫他建立好他的上線列表*/
1126     function joinGame(address _newUser, address _inviter) public onlyForPlayerBook{
1127 
1128         if(generations[_inviter].ancestorList.length == 10){
1129             generations[_newUser].ancestorList.push(_inviter);
1130             for (uint i = 0; i < 9; i++) {
1131                 generations[_newUser].ancestorList.push(generations[_inviter].ancestorList[i]);
1132             }
1133             //generations[_newUser].firstGeneration = false;
1134         }
1135         else if(generations[_inviter].ancestorList.length == 0){
1136             generations[_newUser].ancestorList.push(_inviter);
1137         }
1138         else{
1139             generations[_newUser].ancestorList.push(_inviter);
1140             for (uint j = 0; j < generations[_inviter].ancestorList.length; j++) {
1141                 generations[_newUser].ancestorList.push(generations[_inviter].ancestorList[j]);
1142             }
1143             //generations[_newUser].firstGeneration = false;
1144         }
1145 
1146         emit joinGameEvent(_newUser, _inviter, now);
1147     }
1148 
1149     /* @dev
1150         輸入用戶地址、此次購魚的飼料費、上線目前等級，依據ancestorList、fishbowlSize來分配每一個上限的金額，剩餘的錢轉入開發者地址
1151         @notice 千分比 + 標準單位位移 => 總共6位
1152     *//*
1153     function distributeCommission(address _user, uint _fodderFee, uint _fishbowlLevel)
1154 
1155     public onlyForPlayerBook returns(uint[] memory commission, uint bonusPool, uint ghostComission)
1156     {
1157         uint[] memory _commission = new uint[](generations[_user].ancestorList.length);
1158         uint _bonusPool;
1159         uint _ghostComission = _fodderFee;
1160         for(uint i = 0; i < generations[_user].ancestorList.length; i++){
1161             if(i==0){
1162                 _commission[i] = _fodderFee.mul(levelToCommission[_fishbowlLevel]).div(1000);
1163                 _ghostComission = _ghostComission.sub(_commission[i]);
1164             }
1165             else{
1166                 _commission[i] = _fodderFee.mul(20).div(1000);
1167                 _ghostComission = _ghostComission.sub(_commission[i]);
1168             }
1169         }
1170         _bonusPool = _fodderFee.mul(20).div(1000);
1171         _ghostComission = _ghostComission.sub(_bonusPool);
1172 
1173         emit distributeCommissionEvent(_commission, _bonusPool, _ghostComission, now);
1174         return (_commission, _bonusPool, _ghostComission);
1175     }*/
1176  
1177     /* @dev
1178         輸入邀請人地址及魚缸尺寸、受邀者地址及首次購魚後魚缸等級，幫邀請人將下線列表更新並回傳新的魚缸尺寸
1179     */
1180     function inviteNewUser(address _inviter, uint _inviterFishBowlSize, address _invitee, uint _inviteeFishbowlLevel)
1181     public onlyForPlayerBook returns(uint newFishbowlSize)
1182     {
1183         generations[_inviter].inviteesList.push(_invitee);
1184         uint _newFishbowlSize = _inviterFishBowlSize.add(fishbowlGrow[_inviteeFishbowlLevel]);
1185 
1186         return _newFishbowlSize;
1187     }
1188 
1189     /* @dev 回傳ancestorList */
1190     function getAncestorList(address _user) public view returns(address[] memory ancestorList){
1191         require(generations[_user].ancestorList.length != 0, "你是第一代");
1192 
1193         address[] memory _ancestorList = new address[](generations[_user].ancestorList.length);
1194         for(uint i = 0; i < generations[_user].ancestorList.length; i++){
1195             _ancestorList[i] = generations[_user].ancestorList[i];
1196         }
1197 
1198         return _ancestorList;
1199     }
1200 
1201     /* @dev 回傳上一代 */
1202     function getMotherGeneration(address _user) public view returns(address motherGeneration){
1203         require(generations[_user].ancestorList.length != 0, "你是第一代");
1204 
1205         return generations[_user].ancestorList[0];
1206     }
1207 
1208     /* @dev 回傳inviteesList */
1209     function getInviteesList(address _user) public view returns(address[] memory inviteesList){
1210         require(generations[_user].inviteesList.length != 0, "你沒有下線");
1211 
1212         address[] memory _inviteesList = new address[](generations[_user].inviteesList.length);
1213         for(uint i = 0; i < generations[_user].inviteesList.length; i++){
1214             _inviteesList[i] = generations[_user].inviteesList[i];
1215         }
1216 
1217         return _inviteesList;
1218     }
1219 
1220     /* @dev 回傳inviteesCount */
1221     function getInviteesCount(address _user) public view returns(uint inviteesCount){
1222         //require(generations[_user].inviteesList.length != 0, "你沒有下線");
1223 
1224         return generations[_user].inviteesList.length;
1225     }
1226 
1227     /*@dev set playerbookAddr */
1228     function setPlayerBookAddr(address _newPlayerBookAddr) public onlyOwner{
1229         playerBookAddress = _newPlayerBookAddr;
1230 
1231         emit setPlayerBookAddrEvent(_newPlayerBookAddr, now);
1232     }
1233 
1234     /*@dev get playerbookAddr */
1235     function getPlayerBookAddr() public view returns(address _playerBookAddress){
1236         return playerBookAddress;
1237     }
1238 }
1239 
1240 contract PlayerBook is Ownable, Pausable {
1241 
1242     using SafeMath for uint;
1243 
1244     uint public reproductionRound;
1245     uint public weekRound;
1246 
1247     uint constant public BONUS_TIMEOUT_NO_USER = 33200;
1248     uint constant public BONUS_TIMEOUT_WEEK = 46500;
1249 
1250     uint private _ghostProfit;
1251 
1252     uint[9] public avaliableFishAmountList = [0,1,5,10,30,50,100,150,200];
1253 
1254     event LogBuyOrderRefund( address indexed _refunder, uint _refundValue, uint _now);
1255     event LogSellerProcessProfit( address indexed _seller, uint _totalValue, uint _now);
1256     event LogAddNewSellOrder( address indexed _player, uint _fishAmount, uint _cPrice, uint _now);
1257     event LogAddFishAmount( address indexed _buyer, uint _successBuyFishAmount, uint _totalCost, bool _isBuy, uint _now ); 
1258     event LogDistributeCommission( address indexed _user, uint _fodderFee, address[] _ancestorList, uint bonusPool, uint _now);
1259     event LogFirstGenerationJoinGame( address indexed _user, uint _initFishAmount, uint _value, uint _now);
1260     event LogJoinGame( address indexed _newUser, uint _initFishAmount, uint _value, address _inviter, uint _now);
1261 
1262     event LogIncreseFishbowlSize( address indexed _newUser, uint _initFishAmount, uint _value, uint _now);
1263     event LogWithdrawProfit( address indexed _user, uint _profit, uint _recomandBonus, uint _now);
1264     event LogWithdrawRecommandBonus( address indexed _user, uint _recommandBonus, uint _now);
1265 
1266     event LogGetWeekBonusPool( address indexed _user, uint _bonus, uint _now);
1267     event LogGetBonusPool( address indexed _user, uint _bonus, uint _now);
1268 
1269     event LogWithdrawOwnerProfit( address indexed _owner, uint _profit );
1270 
1271     /* @dev Player model */
1272     struct Player {
1273         /* pricing data */
1274         uint admissionPrice;
1275         uint accumulatedSellPrice;
1276         uint amountToSale;
1277         uint recomandBonus;
1278         uint profit; 
1279         uint rebuy;
1280         /* fish data of the player */
1281         uint fishbowlLevel;
1282         uint fishbowlSize;
1283         uint fishAmount;
1284         /* status of player */
1285         PlayerStatus status;
1286         /* reproduction round */
1287         uint round;
1288         /* weekly data */
1289         uint playerWeekRound;
1290         uint playerWeekCount;
1291         /* is first generation */
1292         bool isFirstGeneration;
1293         // 限制多重購魚
1294         uint joinRound;
1295     }
1296 
1297     /* @dev week data tracking */
1298     // struct WeekData {
1299     //     address payable currentWinner;
1300     //     uint count;
1301     //     uint round;
1302     // }
1303 
1304     address payable[3] private weekData; //0 < 1 < 2
1305 
1306     /*
1307     struct WeekNode {
1308         address payable player;
1309         uint count;
1310         bytes32 _next;
1311     }
1312 
1313     bytes32 private WEEK_HEAD = keccak256("WEEK_HEAD");
1314 
1315     mapping (bytes32=>WeekNode) weekPlayerNodeList;*/
1316 
1317     struct BonusPool {
1318         uint totalAmount;
1319         uint bonusWeekBlock;
1320         address weekBonusUser;
1321         uint bonusWeekBlockWithoutUser;
1322         address lastBonusUser;
1323     }
1324 
1325     BonusPool bonusPool;
1326     // WeekData weekData;
1327 
1328     /* @dev outer contracts */
1329     TransactionSystem transactionSystem;
1330     Fishbowl fishbowl;
1331     Commission commission; 
1332 
1333     /* @dev mark the current status of a player */
1334     enum PlayerStatus { NOT_JOINED, NORMAL, EXCEEDED }
1335     
1336     address payable public TransactionSystemAddress;
1337     address payable public FishbowlAddress;
1338     address payable public CommissionAddress;
1339     
1340     /* @dev game books datastructure */
1341     mapping (address=>Player) playerBook;
1342     mapping (address=>uint) internal playerLastTotalCost;
1343 
1344     mapping (address=>bool) whiteList;
1345     
1346 
1347     /* @dev player not exceeding can call */
1348     modifier PlayerIsAlive() {
1349         require(playerBook[msg.sender].status == PlayerStatus.NORMAL, "Exceed or not Join");
1350         _;
1351     }
1352 
1353     /* @dev only transaction system can call */
1354     modifier OnlyForTxContract() {
1355         require( msg.sender == TransactionSystemAddress, "Only for tx contract!");
1356         _; 
1357     }
1358 
1359     /* @dev contract address is not allowed */
1360     modifier isHuman() {
1361         address _addr = msg.sender;
1362         uint256 _codeLength;
1363         
1364         assembly {_codeLength := extcodesize(_addr)}
1365         require(_codeLength == 0, "Addresses not owned by human are forbidden");
1366         _;
1367     }
1368 
1369     /* @dev check that the fish amount is in valid range */
1370     modifier isValidFishAmount (uint _fishAmount) {
1371         require(
1372             _fishAmount == avaliableFishAmountList[0] ||
1373             _fishAmount == avaliableFishAmountList[1] ||
1374             _fishAmount == avaliableFishAmountList[2] ||
1375             _fishAmount == avaliableFishAmountList[3] ||
1376             _fishAmount == avaliableFishAmountList[4] ||
1377             _fishAmount == avaliableFishAmountList[5] ||
1378             _fishAmount == avaliableFishAmountList[6] ||
1379             _fishAmount == avaliableFishAmountList[7] ||
1380             _fishAmount == avaliableFishAmountList[8] ,
1381             "Invalid fish amount!"
1382         );
1383         _;
1384     }
1385 
1386     constructor() public payable {
1387 
1388         reproductionRound = 1;
1389         weekRound = 1;
1390         
1391         bonusPool = BonusPool(0, block.number, address(0), block.number, address(0));
1392         // weekData = WeekData(address(0), 0, 1);
1393 
1394         _ghostProfit = 0;
1395         whiteList[owner] = true;
1396         whiteList[0x83b73144939e81236C8d5561509CC50e7A30D0F7] = true;//客戶初代
1397     }
1398 
1399     /* @dev a function that allows owner to add */
1400     function firstGenerationJoinGame(uint _initFishAmount) public payable isHuman() isValidFishAmount(_initFishAmount) {      
1401         address payable _user = msg.sender;
1402         uint _value = msg.value;
1403 
1404         require(whiteList[_user], "Invalid user");
1405         require(playerBook[_user].status == PlayerStatus.NOT_JOINED, "Player has joined!");
1406 
1407         playerBook[_user].isFirstGeneration = true;
1408         emit LogFirstGenerationJoinGame( _user, _initFishAmount, _value, now);
1409 
1410         // flow of paticipation on first generation
1411         // 3. add buyer in consultant's first, add consultant to buyer's consultant list (Commission)
1412         commission.firstGenerationJoinGame(_user);
1413         // 2. init player data
1414         initFishData(_user, _initFishAmount);
1415         // 1. add buy order.
1416         transactionSystem.addNewBuyOrder(_user, _initFishAmount, _value, false);
1417         initPriceData(_user, playerLastTotalCost[_user]);
1418     }
1419 
1420     /* @dev Player join the game at first time
1421       * @param _initFishAmount _inviter
1422 `    */
1423     function joinGame (uint _initFishAmount, address payable _inviter) public payable isHuman() isValidFishAmount(_initFishAmount) {    
1424         address payable _newUser = msg.sender;
1425         uint _value = msg.value;
1426 
1427         require(_inviter != address(0x0) && playerBook[_inviter].status > PlayerStatus.NOT_JOINED, "No such inviter!");
1428         require(playerBook[_newUser].status == PlayerStatus.NOT_JOINED, "Player has joined!");
1429 
1430         playerBook[_newUser].isFirstGeneration = false;
1431         emit LogJoinGame (_newUser, _initFishAmount, _value, _inviter,  now);
1432 
1433         uint _balance = _value.div(2);
1434         // uint _fodderFee = _value.div(2);
1435 
1436         // flow of paticipation
1437         // 3. add buyer in consultant's first, add consultant to buyer's consultant list (Commission)
1438         commission.joinGame(_newUser, _inviter);
1439         // 1. init player data
1440         initFishData(_newUser, _initFishAmount);
1441         // 2. reset consultant fishbowl data (Fishbowler, playerBook[_inviter].fishbowlSize, _newUser, playerBook[_newUser].fishbowl) -> return
1442         playerBook[_inviter].fishbowlSize = commission.inviteNewUser(_inviter, playerBook[_inviter].fishbowlSize, _newUser, playerBook[_newUser].fishbowlLevel);
1443         playerBook[_inviter].amountToSale = playerBook[_inviter].fishbowlSize.mul(playerBook[_inviter].admissionPrice);
1444         // 3. renew weekly data
1445         // if (playerBook[_inviter].playerWeekRound != weekData.round) 
1446         if (playerBook[_inviter].playerWeekRound != weekRound) {
1447             playerBook[_inviter].playerWeekRound = weekRound;
1448             playerBook[_inviter].playerWeekCount = 0;
1449         }
1450 
1451         // playerBook[_inviter].playerWeekCount = playerBook[_inviter].playerWeekCount.add(1);
1452         playerBook[_inviter].playerWeekCount = playerBook[_inviter].playerWeekCount.add(_initFishAmount);
1453         // 4. set week bonus data and sort list
1454         bool tempJudge = false;
1455         int index = -1;
1456         for(uint i = 0; i < 3; i++){
1457             if(playerBook[_inviter].playerWeekCount > playerBook[ weekData[i] ].playerWeekCount){
1458                 index = int(i); //紀錄當前使用者大過的排名
1459                 if(tempJudge){ //當前使用者有在榜上，直接更動排名
1460                     address payable temp = weekData[i];
1461                     weekData[i] = _inviter;
1462                     weekData[i-1] = temp;
1463                 }
1464             }
1465             if (_inviter == weekData[i]) { //檢查當前使用者有無上榜
1466                 tempJudge = true;
1467             }
1468         }
1469         if(tempJudge == false){ //當前使用者沒在榜上
1470             for(uint i = 0; int(i) <= index; i++){
1471                 address payable temp = weekData[i];
1472                 weekData[i] = _inviter;
1473                 if(i != 0){
1474                     weekData[i-1] = temp;
1475                 }
1476             }
1477         }
1478         /*
1479         bytes32 _startID = WEEK_HEAD;
1480         for (uint i = 0; i < 3; i++) {
1481             bytes32 _nextID = weekPlayerNodeList[_startID]._next;
1482 
1483             if (playerBook[_inviter].playerWeekCount <= weekPlayerNodeList[_startID].count && playerBook[_inviter].playerWeekCount > weekPlayerNodeList[_nextID].count) {
1484                 if (weekPlayerNodeList[_nextID].player == _inviter) {
1485                     weekPlayerNodeList[_nextID].count = playerBook[_inviter].playerWeekCount;
1486                     break;
1487                 }
1488                 bytes32 _insertID = keccak256(abi.encodePacked(_inviter, playerBook[_inviter].playerWeekCount));
1489                 weekPlayerNodeList[_insertID] = WeekNode(_inviter, playerBook[_inviter].playerWeekCount, _nextID);
1490                 weekPlayerNodeList[_startID]._next = _insertID;
1491                 break;
1492 
1493             } else if (playerBook[_inviter].playerWeekCount > weekPlayerNodeList[_startID].count) {
1494                 if (weekPlayerNodeList[_startID].player == _inviter) {
1495                     weekPlayerNodeList[_startID].count = playerBook[_inviter].playerWeekCount;
1496                     break;
1497                 }
1498                 bytes32 _insertID = keccak256(abi.encodePacked(_inviter, playerBook[_inviter].playerWeekCount));
1499                 weekPlayerNodeList[_insertID] = WeekNode(_inviter, playerBook[_inviter].playerWeekCount, _startID);
1500 
1501                 WEEK_HEAD = _insertID;
1502                 break;
1503 
1504             } else {
1505                 _startID = _nextID;
1506                 continue;
1507             }
1508         }*/
1509         // 5. add buy order.
1510         transactionSystem.addNewBuyOrder(_newUser, _initFishAmount, _balance, false);
1511         initPriceData(_newUser, playerLastTotalCost[_newUser]);
1512         // 5. distribute fodder fee(Commission) -> (playerbook profit setter)
1513         // distributeCommission(_newUser, _fodderFee);
1514     }
1515 
1516 
1517      /* @dev Update bowl size kobe control
1518        * @notice Need to buy larger than current size
1519        * @param _fishAmount _fishPrice
1520     */
1521     function increseFishbowlSizeByMoney (uint _fishAmount) public payable isHuman() PlayerIsAlive() isValidFishAmount(_fishAmount){   
1522         address payable _player = msg.sender;
1523         uint _value = msg.value;
1524         require (playerBook[_player].fishbowlLevel <= 8 && playerBook[_player].fishbowlLevel >= 0, "Invalid fish level!");
1525         require (fishbowl.getFishBowlLevel(_fishAmount) >= playerBook[_player].fishbowlLevel, "Should buy more fish to upgrade!");
1526         
1527         /* normalize fish amount */
1528         // normalizeFishAmount(_player);
1529 
1530         uint _balance = playerBook[_player].isFirstGeneration ? _value : _value.div(2);
1531         
1532         // uint _fodderFee = playerLastTotalCost[_player];
1533         uint _beforeFishbowlSize = playerBook[_player].fishbowlSize;
1534 
1535         if (playerBook[_player].fishbowlLevel < 8 && playerBook[_player].fishbowlLevel != 0) {
1536             transactionSystem.addNewBuyOrder(_player, _fishAmount, _balance, false);
1537             (playerBook[_player].fishbowlLevel, playerBook[_player].fishbowlSize, playerBook[_player].admissionPrice, playerBook[_player].amountToSale) = fishbowl.fishBowl(playerLastTotalCost[_player], _fishAmount);
1538         
1539         } else if (playerBook[_player].fishbowlLevel == 8 && playerBook[_player].joinRound == reproductionRound) {
1540             transactionSystem.addNewBuyOrder(_player, _fishAmount, _balance, false);
1541             (playerBook[_player].admissionPrice, playerBook[_player].amountToSale) = fishbowl.multipleBuy(playerLastTotalCost[_player], playerBook[_player].admissionPrice, playerBook[_player].amountToSale);
1542             
1543             if(playerBook[_player].isFirstGeneration == false){ //不是第一代才有直一
1544                 address temp = commission.getMotherGeneration(_player);
1545                 address payable _inviter = address(uint160(temp));
1546                 if (playerBook[_inviter].playerWeekRound != weekRound) {
1547                     playerBook[_inviter].playerWeekRound = weekRound;
1548                     playerBook[_inviter].playerWeekCount = 0;
1549                 }
1550 
1551                 playerBook[_inviter].playerWeekCount = playerBook[_inviter].playerWeekCount.add(_fishAmount);
1552                 // 4. set week bonus data and sort list
1553                 bool tempJudge = false;
1554                 int index = -1;
1555                 for(uint i = 0; i < 3; i++){
1556                     if(playerBook[_inviter].playerWeekCount > playerBook[ weekData[i] ].playerWeekCount){
1557                         index = int(i); //紀錄當前使用者大過的排名
1558                         if(tempJudge){ //當前使用者有在榜上，直接更動排名
1559                             address payable _temp = weekData[i];
1560                             weekData[i] = _inviter;
1561                             weekData[i-1] = _temp;
1562                         }
1563                     }
1564                     if (_inviter == weekData[i]) { //檢查當前使用者有無上榜
1565                         tempJudge = true;
1566                     }
1567                 }
1568                 if(tempJudge == false){ //當前使用者沒在榜上
1569                     for(uint i = 0; int(i) <= index; i++){
1570                         address payable _temp = weekData[i];
1571                         weekData[i] = _inviter;
1572                         if(i != 0){
1573                             weekData[i-1] = _temp;
1574                         }
1575                     }
1576                 }
1577             }
1578 
1579         } else{
1580             revert("out of join round");
1581         }
1582 
1583         if ( playerBook[_player].fishbowlSize <= _beforeFishbowlSize) {
1584             playerBook[_player].fishbowlSize = _beforeFishbowlSize;
1585             playerBook[_player].amountToSale = playerBook[_player].admissionPrice.mul(playerBook[_player].fishbowlSize);
1586         }
1587 
1588         
1589         emit LogIncreseFishbowlSize( _player, _fishAmount, _value, now);
1590 
1591     }
1592 
1593 
1594     /* @dev user buy fish order via playerbook */
1595     function rebuyAddNewBuyOrder(uint _fishAmount, uint _rebuy) public isHuman() PlayerIsAlive() {
1596         address payable _player = msg.sender;
1597         /* check rebuy value */
1598         require(playerBook[_player].rebuy >= _rebuy, "Invalid rebuy value!");
1599 
1600         /* normalize fish amount */
1601         // normalizeFishAmount(_player);
1602        
1603         uint _balance = playerBook[_player].isFirstGeneration ? _rebuy : _rebuy.div(2);
1604         /* new buy-order process */
1605         transactionSystem.addNewBuyOrder(_player, _fishAmount, _balance, true);
1606         uint _actualRebuy = playerBook[_player].isFirstGeneration ? playerLastTotalCost[_player] : playerLastTotalCost[_player].mul(2);
1607         playerBook[_player].rebuy = (playerBook[_player].rebuy).sub(_actualRebuy);
1608     }
1609 
1610 
1611     /* 
1612       * @dev player setup.
1613       * Init fishbowl level, fishbowl size, player status
1614       * @param _newUser _initFishAmount 
1615     */
1616     function initFishData(address _newUser, uint _initFishAmount) internal {
1617         // addFishAmount(_newUser, _initFishAmount);
1618         playerBook[_newUser].fishbowlLevel = fishbowl.getFishBowlLevel(_initFishAmount); 
1619         playerBook[_newUser].fishbowlSize = fishbowl.getFishbowlSize(playerBook[_newUser].fishbowlLevel);
1620         playerBook[_newUser].status = PlayerStatus.NORMAL;
1621         playerBook[_newUser].round = reproductionRound;
1622         // playerBook[_newUser].playerWeekRound = weekData.round;
1623         playerBook[_newUser].playerWeekRound = weekRound;
1624         playerBook[_newUser].playerWeekCount = 0;
1625         playerBook[_newUser].joinRound = reproductionRound;
1626     }
1627 
1628     /* 
1629       * @dev Player price data initialization
1630       * Init selled price, admission price, maximum sellable price, recommandation bonus, profit, and rebuy amount.
1631       * @param _newUser _initFishAmount
1632     */
1633     function initPriceData(address _newUser, uint _totalFishPrice) internal {    
1634         playerBook[_newUser].accumulatedSellPrice = 0;
1635         playerBook[_newUser].admissionPrice = fishbowl.getAdmissionPrice(_totalFishPrice);
1636         playerBook[_newUser].amountToSale = fishbowl.getAmountToSale(playerBook[_newUser].fishbowlLevel, playerBook[_newUser].admissionPrice);
1637         playerBook[_newUser].recomandBonus = 0;
1638         playerBook[_newUser].profit = 0;
1639         playerBook[_newUser].rebuy = 0;
1640     }
1641 
1642     /* @dev user sell fish order via playerbook
1643      */
1644     function addNewSellOrder(uint _fishAmount, uint _fishPrice)  public isHuman() PlayerIsAlive() {
1645         require(_fishAmount != 0, "not allowd zero fish amount");
1646         address payable _player = msg.sender;
1647         /* normalize fish amount */
1648         normalizeFishAmount(_player);
1649         (uint _quo, uint _rem) = getDivided(playerBook[msg.sender].fishAmount, 10);
1650         if ( _rem != 0 ) {
1651             _quo = _quo.add(1);
1652         }
1653 
1654         require(
1655             playerBook[msg.sender].fishAmount >= _fishAmount &&
1656             _fishAmount <= _quo,
1657             "Unmatched avaliable sell fish amount!"
1658         );
1659 
1660         uint accumulated = playerBook[_player].accumulatedSellPrice;
1661         accumulated = accumulated.add(_fishAmount * _fishPrice);
1662         require( playerBook[_player].amountToSale.div(1000) >= accumulated , "exceed amount to sale");
1663             
1664         /* new sell-order process */
1665         transactionSystem.addNewSellOrder(_player, _fishAmount, _fishPrice);
1666 
1667         emit LogAddNewSellOrder( _player, _fishAmount, _fishPrice, now);
1668     }
1669 
1670 
1671     /* @dev cancel sell order
1672      */
1673     function cancelSellOrder(uint _orderId) public payable isHuman()  PlayerIsAlive() {
1674         // normalizeFishAmount(msg.sender);
1675         transactionSystem.cancelSellOrder(msg.sender, _orderId);
1676     }
1677 
1678     /* 
1679       * @dev Add fish amount(called from transaction system or fishbowl)
1680       * @notice Cases of adding fish to a player
1681       * 1. Buy fish at current price (TransactionSystem.buyFishAtCurrentPrice())
1682       * 2. Reproduction
1683       * 3. player cancel order (TransactionSystem.cancelSellOrder())
1684       * @param _buyer _fushAmount
1685     */
1686     function addFishAmount (address payable _buyer, uint _successBuyFishAmount, uint _totalCost, bool _isBuy ) external OnlyForTxContract() {
1687         
1688         //要正規化要加的對象的魚數
1689         normalizeFishAmount(_buyer);
1690         
1691         playerBook[_buyer].fishAmount = (playerBook[_buyer].fishAmount).add(_successBuyFishAmount);
1692         playerLastTotalCost[_buyer] = _totalCost;
1693         emit LogAddFishAmount( _buyer, _successBuyFishAmount, _totalCost, _isBuy, now);
1694         
1695         
1696         // if it's a cancel order or buyed
1697         if (_isBuy && !playerBook[_buyer].isFirstGeneration) {
1698             // distribute commission
1699             distributeCommission(_buyer, _totalCost);
1700         }
1701     }
1702 
1703 
1704     /* @dev profit setting, including 60% profit and 40% rebuy amount (70%+18% 12%) (100%) (100% -> 60% 40% )
1705       * when a non-system seller gets profit, it need to be distributed.
1706       * @param _seller _totalRevenue
1707     */ 
1708     function sellerProcessProfit (address _seller, uint _totalRevenue) external OnlyForTxContract() {
1709         emit LogSellerProcessProfit( _seller, _totalRevenue, now);
1710 
1711         if (_seller != address(this) ) {
1712             addAccumulatedValue (_seller, _totalRevenue);
1713 
1714             uint _profit = _totalRevenue.mul(60).div(100);
1715             playerBook[_seller].profit = (playerBook[_seller].profit).add(_profit);
1716 
1717             uint _rebuy = _totalRevenue.mul(40).div(100);
1718             if (playerBook[_seller].status == PlayerStatus.EXCEEDED) {
1719                 _ghostProfit = _ghostProfit.add(_rebuy);
1720             } else {
1721                 playerBook[_seller].rebuy = (playerBook[_seller].rebuy).add(_rebuy); 
1722             }
1723         } else {
1724             _ghostProfit = _ghostProfit.add(_totalRevenue);
1725         }
1726     }
1727 
1728 
1729     /* @dev buy order refunding setting
1730       * @param _refunder _refundValue
1731     */ 
1732     function buyOrderRefund (address payable _refunder, uint _refundValue) external OnlyForTxContract() {   
1733         uint _tmpRefundValue = _refundValue;
1734         if ( !playerBook[_refunder].isFirstGeneration) 
1735             _tmpRefundValue = _tmpRefundValue.mul(2);
1736 
1737         emit LogBuyOrderRefund( _refunder, _refundValue, now);
1738 
1739         _refunder.transfer(_tmpRefundValue);
1740     }
1741 
1742 
1743     /* @dev Minus fish amount(called from transaction system or fishbowl)
1744       * @notice Only when MAKING ORDER that minus fish amount (TransactionSystem.addNewSellOrder())
1745       * @param _seller _fishAmount
1746     */
1747     function minusFishAmount (address _seller, uint _fishAmount) external OnlyForTxContract() {
1748         playerBook[_seller].fishAmount = (playerBook[_seller].fishAmount).sub(_fishAmount);
1749     }
1750 
1751 
1752     /* @dev Set reproduction round */
1753     function addReproductionRound () external OnlyForTxContract() {
1754         reproductionRound = reproductionRound.add(1);
1755     }
1756     
1757 
1758     /* @dev check if the player is exceed maximum sell price 
1759       * @param _player _profit
1760     */
1761     function addAccumulatedValue (address _player, uint _profit) internal {
1762         playerBook[_player].accumulatedSellPrice = (playerBook[_player].accumulatedSellPrice).add(_profit);
1763         if ( (playerBook[_player].amountToSale.div(1000) < playerBook[_player].accumulatedSellPrice) && (playerBook[_player].status != PlayerStatus.EXCEEDED) ) {
1764             playerBook[_player].status = PlayerStatus.EXCEEDED;
1765             transactionSystem.deadFish(playerBook[_player].fishAmount);
1766 
1767             uint _tempRebuy = playerBook[_player].rebuy;
1768             playerBook[_player].rebuy = 0;
1769 
1770             _ghostProfit = _ghostProfit.add(_tempRebuy);
1771         }
1772     }
1773 
1774     /* @dev normalize fish amount by reproduction round
1775      * @parem _player
1776      */
1777     function normalizeFishAmount (address _player) internal {
1778         if( reproductionRound != playerBook[_player].round ) {
1779             playerBook[_player].fishAmount = playerBook[_player].fishAmount.mul( 2 **  (reproductionRound.sub(playerBook[_player].round)) );
1780             playerBook[_player].round = reproductionRound;
1781         }
1782     }
1783     /* @dev get week bonus condition when there's no user amoung this week */
1784     function checkBonusPoolBlockNoUser () internal returns(bool) {
1785         uint lastBonusBlock = bonusPool.bonusWeekBlockWithoutUser;
1786         bonusPool.bonusWeekBlockWithoutUser = block.number;
1787 
1788         if (bonusPool.bonusWeekBlockWithoutUser.sub(lastBonusBlock) > BONUS_TIMEOUT_NO_USER) 
1789             return true;
1790         
1791         return false;
1792     }
1793     /* @dev get week bonus condition */
1794     function checkBonusPoolBlockWeek () internal returns(bool) {
1795         uint lastBonusBlock = bonusPool.bonusWeekBlock;
1796         uint _nowBlock = block.number;
1797 
1798         if (_nowBlock.sub(lastBonusBlock) > BONUS_TIMEOUT_WEEK)  {
1799             bonusPool.bonusWeekBlock = _nowBlock;
1800             return true;
1801         }
1802         return false;
1803     }
1804 
1805     function resetWeekData() internal {
1806         // weekData.round = weekData.round.add(1);
1807         // weekData.count = 0;
1808         weekRound = weekRound.add(1);
1809 
1810         delete weekData;
1811 
1812         /*
1813         bytes32 _startID = WEEK_HEAD;
1814         for (uint i = 0; i < 3; i++) {
1815             bytes32 _nextID = weekPlayerNodeList[_startID]._next;
1816             delete weekPlayerNodeList[_startID];
1817 
1818             _startID = _nextID;
1819         }*/
1820     }
1821 
1822 
1823     /* @dev distribute commission when buy fish
1824         @param _user _fodderFee
1825     */
1826     uint[9] levelToCommission = [100,400,400,500,500,600,600,700,700]; //千分比
1827     function distributeCommission(address payable _user, uint _fodderFee) internal {
1828         uint _ghostCommission;
1829         uint _bonusPool;
1830         address[] memory _ancestorList = commission.getAncestorList(_user);
1831         uint[] memory _commissionList = new uint[](_ancestorList.length);
1832 
1833         _ghostCommission = _fodderFee;
1834         for(uint i = 0; i < _ancestorList.length; i++){
1835             if(i==0){
1836                 _commissionList[i] = _fodderFee.mul(levelToCommission[playerBook[_ancestorList[i]].fishbowlLevel]).div(1000);
1837                 _ghostCommission = _ghostCommission.sub(_commissionList[i]);
1838             }else if(playerBook[_ancestorList[i]].fishbowlLevel != 0){
1839                 _commissionList[i] = _fodderFee.mul(20).div(1000); //實際上的1%
1840                 _ghostCommission = _ghostCommission.sub(_commissionList[i]);
1841             }
1842         }
1843         _bonusPool = _fodderFee.mul(20).div(1000);
1844         _ghostCommission = _ghostCommission.sub(_bonusPool);
1845 
1846         require(_commissionList.length == _ancestorList.length, "Unmatched commission length!");
1847         /* transfer admin commission */
1848         _ghostProfit = _ghostProfit.add(_ghostCommission);
1849         // owner.transfer(_ghostCommission);
1850         /* add to bonus pool */
1851         bonusPool.totalAmount = bonusPool.totalAmount.add(_bonusPool);
1852         /* update bonus pool time */
1853         if( checkBonusPoolBlockWeek() ) {
1854             uint _weekBonus = bonusPool.totalAmount.div(10);
1855             bonusPool.totalAmount = bonusPool.totalAmount.sub(_weekBonus);
1856             bonusPool.weekBonusUser = weekData[2];
1857             //bonusPool.weekBonusUser = weekPlayerNodeList[WEEK_HEAD].player;
1858 
1859             weekData[2].transfer(_weekBonus);
1860             //weekPlayerNodeList[WEEK_HEAD].player.transfer(_weekBonus);
1861             resetWeekData();
1862             emit LogGetWeekBonusPool(bonusPool.weekBonusUser, _weekBonus, now);
1863         }
1864 
1865         if( checkBonusPoolBlockNoUser() ) {
1866             uint _finalBonus = bonusPool.totalAmount;
1867             bonusPool.totalAmount = 0;
1868             bonusPool.lastBonusUser = _user;
1869             _user.transfer(_finalBonus);
1870             emit LogGetBonusPool(_user, _finalBonus, now);
1871         }
1872 
1873         emit LogDistributeCommission(_user, _fodderFee, _ancestorList, bonusPool.totalAmount, now);
1874 
1875         for (uint i = 0; i < _ancestorList.length; i++) {
1876             /* normalize fish amount */
1877             /* add to accumulated value */
1878             addAccumulatedValue(_ancestorList[i], _commissionList[i]);
1879             /* add 60% to recommand bonus */
1880             uint _rBonus = _commissionList[i].mul(60).div(100);
1881             playerBook[_ancestorList[i]].recomandBonus = (playerBook[_ancestorList[i]].recomandBonus).add(_rBonus);
1882             /* add 40% to rebuy value */
1883             uint _rebuy = _commissionList[i].mul(40).div(100);
1884             if (playerBook[_ancestorList[i]].status == PlayerStatus.EXCEEDED) {
1885                 _ghostProfit = _ghostProfit.add(_rebuy);
1886             } else {
1887                 playerBook[_ancestorList[i]].rebuy = (playerBook[_ancestorList[i]].rebuy).add(_rebuy);
1888             }
1889         }
1890     }
1891 
1892 
1893     /* @dev check player status */
1894     function getPlayerStatusAndExceeded () public view returns (PlayerStatus, bool) {
1895         return (playerBook[msg.sender].status, playerBook[msg.sender].status == PlayerStatus.EXCEEDED);
1896     }
1897 
1898     /* @dev return player fish count by its client */
1899     function getPlayerWeekCount () public view returns (uint) {
1900         return (playerBook[msg.sender].playerWeekCount);
1901     }
1902 
1903 
1904     /* @dev owner function, set transaction system contract address */
1905     function setTransactionSystemAddr(address payable _newAddr) public onlyOwner() {
1906         TransactionSystemAddress = _newAddr;
1907         transactionSystem = TransactionSystem(_newAddr);
1908     }
1909 
1910 
1911     /* @dev owner function, set fishbowl contract address */
1912     function setFishbowlAddr(address payable _newAddr) public onlyOwner() {
1913         FishbowlAddress = _newAddr;
1914         fishbowl = Fishbowl(_newAddr);
1915     }
1916 
1917 
1918     /* @dev owner function, set commission contract address */
1919     function setCommissionAddr(address payable _newAddr) public onlyOwner() {
1920         CommissionAddress = _newAddr;
1921         commission = Commission(_newAddr);
1922     }
1923 
1924 
1925     /* @dev util */
1926     function getDivided(uint numerator, uint denominator) internal pure returns(uint quotient, uint remainder) {
1927         quotient  = numerator / denominator;
1928         remainder = numerator - denominator * quotient;
1929     }
1930     /* @dev get player data */
1931     function getPlayerData() 
1932         public 
1933         view  
1934     returns (uint _admission, uint _accumulatedSellPrice, uint _amountToSale, uint _fishbowlLevel, uint _fishbowlSize, uint _fishAmount, uint _recomandBonus, uint _profit, uint _rebuy, uint _playerWeekRound, uint _playerWeekCount, uint _reproductionRound, uint _joinRound) 
1935     {   
1936         address _user = msg.sender;
1937         _admission = playerBook[_user].admissionPrice;
1938         _accumulatedSellPrice = playerBook[_user].accumulatedSellPrice;
1939         _amountToSale = playerBook[_user].amountToSale;
1940         _fishbowlLevel = playerBook[_user].fishbowlLevel;
1941         _fishbowlSize = playerBook[_user].fishbowlSize;
1942         _fishAmount = playerBook[_user].fishAmount.mul(2 ** (reproductionRound.sub(playerBook[_user].round)));
1943         _recomandBonus = playerBook[_user].recomandBonus;
1944         _profit = playerBook[_user].profit;
1945         _rebuy = playerBook[_user].rebuy;
1946         _playerWeekRound = playerBook[_user].playerWeekRound;
1947         _playerWeekCount = playerBook[_user].playerWeekCount;
1948         _reproductionRound = playerBook[_user].round;
1949         _joinRound = playerBook[_user].joinRound;
1950     }
1951     /* @dev get bonus pool data */
1952     function getBonusPool () public view returns (uint _totalAmount, uint _bonusWeekBlock, address _weekUser, address _lastUser, int _blockCountDown, int _lastCountDown) {
1953         _totalAmount = bonusPool.totalAmount;
1954         _bonusWeekBlock = bonusPool.bonusWeekBlock;
1955         _weekUser = bonusPool.weekBonusUser;
1956         _lastUser = bonusPool.lastBonusUser;
1957         //_blockCountDown = int256 (BONUS_TIMEOUT_WEEK - (block.number - (bonusPool.bonusWeekBlock)));
1958         _blockCountDown = int256(bonusPool.bonusWeekBlock) + int256(BONUS_TIMEOUT_WEEK) - int256(block.number);
1959         _lastCountDown = int256(bonusPool.bonusWeekBlockWithoutUser) + int256(BONUS_TIMEOUT_NO_USER) - int256(block.number);
1960     }
1961     /* @dev get week data */
1962     // function getWeekData() public view returns (address _currentWinner, uint _count, uint _round) {
1963     function getWeekData() public view returns (address[] memory, uint[] memory ) {
1964         // _currentWinner = weekData.currentWinner;
1965         // _count = weekData.count;
1966         // _round = weekData.round;
1967         address[] memory _playerList = new address[](3);
1968         uint[] memory _playerCount = new uint[](3);
1969 
1970         /*bytes32 _startID = WEEK_HEAD;
1971         for (uint i = 0; i < 3; i++) {
1972             bytes32 _nextID = weekPlayerNodeList[_startID]._next;
1973 
1974             _playerList[i] = (weekPlayerNodeList[_startID].player);
1975             _playerCount[i] = (weekPlayerNodeList[_startID].count);
1976 
1977             _startID = _nextID;
1978         }*/
1979         for (uint i = 0; i < 3; i++) {
1980             
1981             _playerList[i] = weekData[2 - i];
1982             _playerCount[i] = playerBook[_playerList[i]].playerWeekCount;
1983         }
1984 
1985         return (_playerList, _playerCount);
1986     }
1987 
1988     /* @dev withdraw pofit value && recommand bonus*/
1989     function withdrawProfit() public {
1990         address payable _user = msg.sender;
1991 
1992         uint tempProfit = playerBook[_user].profit;
1993         playerBook[_user].profit = 0;
1994         uint tempRecommandBonus = playerBook[_user].recomandBonus;
1995         playerBook[_user].recomandBonus = 0;
1996 
1997         _user.transfer(tempProfit);
1998         _user.transfer(tempRecommandBonus);
1999 
2000         emit LogWithdrawProfit (_user, tempProfit, tempRecommandBonus, now);
2001     }
2002 
2003 
2004 
2005     function setWhiteList (address _user, bool _val) external onlyOwner() {
2006         whiteList[_user] = _val;
2007     }
2008 
2009     function getWhiteList() external view returns (bool) {
2010         return whiteList[msg.sender];
2011     }
2012 
2013     function getOwnerProfit() external view returns (uint) {
2014         // check if it's client itself
2015         require(msg.sender == 0xa977c1A3AFBDCe730B337921965C2e8146a115Ec || msg.sender == owner, "not client!");
2016         return _ghostProfit;
2017     }
2018 
2019     function withdrawOwnerProfit() external {
2020 
2021         // check if it's client itself
2022         require(msg.sender == 0xa977c1A3AFBDCe730B337921965C2e8146a115Ec, "not client!");
2023 
2024         uint _tmpProfit = _ghostProfit;
2025         _ghostProfit = 0;
2026         // owner.transfer(_tmpProfit.mul(88).div(100));
2027         developer.transfer(_tmpProfit.mul(120).div(1000));//in ownerable
2028 
2029         0x53B29e5946EF1dC0Eb3874f6c2937352C9C6860B.transfer(_tmpProfit.mul(35).div(1000));
2030         0x21ef21b77d2E707D695E7147CFCee3D10f828B99.transfer(_tmpProfit.mul(20).div(1000));
2031         0xa977c1A3AFBDCe730B337921965C2e8146a115Ec.transfer(_tmpProfit.mul(7).div(1000));
2032         0xD8e8fc1Fba7B4e265b1B8C01c4B8C59c91CBFE7f.transfer(_tmpProfit.mul(7).div(1000));
2033         0x428155a346C333EB902874c2eD5c14BC83deca6e.transfer(_tmpProfit.mul(138).div(1000));
2034         0xf9a749aD0379F00d33d3EAAAE1b9af9F1C163A8b.transfer(_tmpProfit.mul(138).div(1000));
2035 
2036         0x2C66893DdbEc0f1a1c3FE4722f75Bd522635c1b1.transfer(_tmpProfit.mul(42).div(1000));
2037         0x0093De1e58FE074df7eFCbf02b70a5442758f7E4.transfer(_tmpProfit.mul(28).div(1000));
2038         0x0e887B5428677A18016594d7C08C9Ff4D0Cea68C.transfer(_tmpProfit.mul(21).div(1000));
2039         0xe25A30c3b0D27110B8A6Bab1bc0892520188044d.transfer(_tmpProfit.mul(14).div(1000));
2040         0x6F1A7E003A2196791141458Cf268b36789e6402c.transfer(_tmpProfit.mul(7).div(1000));
2041         0xD2FcB5d457486cfb91F54183F423238264556297.transfer(_tmpProfit.mul(7).div(1000));
2042         
2043         0x56421540046f15e01F28a1b9BB57868Fb69E8cb5.transfer(_tmpProfit.mul(14).div(1000));
2044         0x7032D5d8C152e92588CA7B1Cf960f8689A2A29c5.transfer(_tmpProfit.mul(7).div(1000));
2045         0x1b51C606fb38961525F45C4b7d09D30c5099bE2B.transfer(_tmpProfit.mul(7).div(1000));
2046         0x66419f617614e4d09173aA58Cf1D5A14A620866D.transfer(_tmpProfit.mul(7).div(1000));
2047         0x7c6e7BB22AAC6D1b1536bbD12f151800Bc81058b.transfer(_tmpProfit.mul(21).div(1000));
2048         0x4eEd6897Bf36dF119E091346171402F6dC3b718D.transfer(_tmpProfit.mul(20).div(1000));
2049         0x5198D696091160942817e4a9D882BF9316F9d550.transfer(_tmpProfit.mul(70).div(1000));
2050         0xAEB6a7c1aBa40cd82e4E1A0F856E8183392F9345.transfer(_tmpProfit.mul(21).div(1000));
2051         0x3B8e84621fd452275D187129E4A3b0a586f8522C.transfer(_tmpProfit.mul(175).div(10000));//1.75
2052 
2053         0x2EEB261D9efE5450A16ee5ee766F700EB7422338.transfer(_tmpProfit.mul(21).div(1000));
2054         0xeA1D5877d4fBBbf296253beCd0c7BCd810D562ad.transfer(_tmpProfit.mul(7).div(1000));
2055         0x22E4DD2D289143e76ac75C4e8d932a81c2Afd1A7.transfer(_tmpProfit.mul(7).div(1000));
2056         0x8C46F2554035fab7c15a8bb21eaAc84B51F4A1ea.transfer(_tmpProfit.mul(14).div(1000));
2057         0xA89a904D80F7b4E10194c6D412D8b03E5c7076c8.transfer(_tmpProfit.mul(7).div(1000));
2058         0xd462EbD49749e36c1Ca71cded0cE90beC5046530.transfer(_tmpProfit.mul(7).div(1000));
2059         0xaD5019575E66010199Ae53E221693Ac938Fb4C23.transfer(_tmpProfit.mul(7).div(1000));
2060         0x58a54afE966e2D30C4fb8242173a2c6D68B53b7C.transfer(_tmpProfit.mul(7).div(1000));
2061         0xd77e1941E6FC1936096BD755bf15C77bcd9a3979.transfer(_tmpProfit.mul(14).div(1000));
2062         0x9f7404d8Daf4Ecb28a65251489d94f75AFC9B5d6.transfer(_tmpProfit.mul(14).div(1000));
2063         0x425B1314d3E85e5Cfc1cAF4839AaB8ad578cc5D2.transfer(_tmpProfit.mul(14).div(1000));
2064         0x9BB9FA17ee5c4d4943794deAF7bA033Abb64863F.transfer(_tmpProfit.mul(14).div(1000));
2065         0x80169b7782EAe698D3049cE791a69de7A547d0f8.transfer(_tmpProfit.mul(7).div(1000));
2066         0x904fedEcd2cdbE7B609aD33695d9e9eB55025537.transfer(_tmpProfit.mul(7).div(1000));
2067         0x7959872789e5d52A3775C52B29D6F48fF8405331.transfer(_tmpProfit.mul(7).div(1000));
2068         0xC4fd6b055E281e43a2efDF5DfbB654B64939068d.transfer(_tmpProfit.mul(7).div(1000));
2069         0x5788e3bdd1FE961a354B9640a87594F6dd013930.transfer(_tmpProfit.mul(10).div(1000));
2070         0x83129ca07f4c5df17C609559D70F63A8E8AC4E00.transfer(_tmpProfit.mul(35).div(10000));//0.35
2071         0x452929C2E67865cd81fCbe1B8fB63CE169d47d27.transfer(_tmpProfit.mul(7).div(1000));
2072         0xd1E0206242A382bE0FaE34fe9787fcfa45bc7ea5.transfer(_tmpProfit.mul(25).div(1000));
2073         0xdF7e30bBCA56D83F019B067bE48953991Ae1C4F8.transfer(_tmpProfit.mul(25).div(1000));
2074 
2075         emit LogWithdrawOwnerProfit(owner, _tmpProfit);
2076     }
2077 
2078     function () external payable  { owner.transfer(msg.value); }
2079 }