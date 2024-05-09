1 pragma solidity ^0.4.25;
2 
3 /**
4 *
5 * «KillFish» is an economic game that provides the possibility to earn Ethereum.
6 *  
7 * The world ocean is a huge object containing many predatory fish fighting and eating each other.
8 * Every player has an in-game task to maintain his/her fish growth periodically replenishing (feeding)
9 * it or chasing after any smaller-size fish. As a matter of fact, this game is endless and a user
10 * is capable to get in or out of the game at any stage, to collect and draw out his/her earnings 
11 * using the money transfer service on the Ethereum wallet.
12 * 
13 * Every player can use 2 basic methods for earning money:
14 * 1. To collect dividends from all new fish engaged in the game and from all fish that are about
15 *     to leave the game, as well as from other actions of the players.
16 * 2. To attack smaller-size prey status assigned fish 2 or 3 times a week.  
17 *
18 * More information on the site https://killfish.io
19 * 
20 * «KillFish» - экономическая игра, предоставляющая возможность игрокам зарабатывать деньги в Ethereum.
21 * 
22 * Мировой океан огромен и в нём обитает множество хищных рыб, которые стремятся съесть друг друга.
23 * Задача игрока состоит в том, что бы поддерживать рост своей рыбы, периодически пополняя(кормя)
24 * её или охотясь на меньших по размерам рыб . Игра по сути своей бесконечная, можно на любом этапе
25 * войти и выйти из неё, получить свой доход переводом на Ethereum кошелёк.
26 *
27 * Каждый игрок имеет возможность заработать 2 основными способами в игре:
28 * 1. Получать долю от всех новых рыб в игре и всех рыб, которые покидают игру,
29 *     а также от других действий игроков.
30 * 2. 2-3 раза в неделю нападать на рыб меньшего размера, которые находятся в статусе жертвы.
31 * 
32 * Больше информации на сайте https://killfish.io
33 *
34 */
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Ownable
102  * @dev The Ownable contract has an owner address, and provides basic authorization control
103  * functions, this simplifies the implementation of "user permissions".
104  */
105 contract Ownable {
106   address private _owner;
107 
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   constructor() internal {
118     _owner = msg.sender;
119     emit OwnershipTransferred(address(0), _owner);
120   }
121 
122   /**
123    * @return the address of the owner.
124    */
125   function owner() public view returns(address) {
126     return _owner;
127   }
128 
129   /**
130    * @dev Throws if called by any account other than the owner.
131    */
132   modifier onlyOwner() {
133     require(isOwner());
134     _;
135   }
136 
137   /**
138    * @return true if `msg.sender` is the owner of the contract.
139    */
140   function isOwner() public view returns(bool) {
141     return msg.sender == _owner;
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param newOwner The address to transfer ownership to.
147    */
148   function transferOwnership(address newOwner) public onlyOwner {
149     _transferOwnership(newOwner);
150   }
151 
152   /**
153    * @dev Transfers control of the contract to a newOwner.
154    * @param newOwner The address to transfer ownership to.
155    */
156   function _transferOwnership(address newOwner) internal {
157     require(newOwner != address(0));
158     emit OwnershipTransferred(_owner, newOwner);
159     _owner = newOwner;
160   }
161 }
162 
163 contract ERC721 {
164     function implementsERC721() public pure returns (bool);
165     function totalSupply() public view returns (uint256 total);
166     function balanceOf(address _owner) public view returns (uint256 balance);
167     function ownerOf(uint256 _tokenId) public view returns (address owner);
168     function transfer(address _to, uint256 _tokenId) public returns (bool);
169     
170     event Transfer(
171         address indexed from, 
172         address indexed to, 
173         uint256 indexed tokenId
174     );
175 }
176 
177 contract KillFish is Ownable, ERC721 {
178     
179     using SafeMath for uint256;
180     using SafeMath for uint64;
181     
182     /**
183     * token structure
184     */
185     
186     struct Fish {  
187         uint64 genes;       //genes determine only the appearance 00 000 000 000-99 999 999 999
188         string nickname;    //fish nickname
189         uint64 birthTime;   //birth time
190         uint64 feedTime;    //last feeding time
191         uint64 huntTime;    //last hunting time
192         uint256 share;      //fish size (per share)
193         uint256 feedValue;  //how much fish should eat (per eth)
194         uint256 eatenValue; //how much did the fish eat (per eth)
195     }
196     
197     /**
198     * storage
199     */
200     
201     Fish[] fishes;
202     
203     mapping (uint256 => address) private _tokenOwner;
204     
205     mapping (address => uint256) private _ownedTokensCount;
206     
207     uint256 private _totalSupply;
208     
209     uint256 public totalShares;
210     
211     uint256 public balanceFishes;
212     uint256 public balanceOwner;
213     uint256 public balanceMarketing;
214     
215     uint256 public maxGasPrice;
216     
217     /**
218     * constants
219     */
220     
221     string constant public name = "KillFish.io";
222     string constant public symbol = "FISH";
223     
224     uint256 constant public minPayment = 10000 szabo;   // 10000 szabo=0.01 eth
225     uint8 constant public percentFeeFishesInput = 5;
226     uint8 constant public percentFeeFishesOutput = 5;
227     uint8 constant public percentFeeFishesBite = 20;
228     
229     uint8 constant public percentFeeMarketingInput = 5;
230     uint8 constant public percentFeeAdminOutput = 5;
231     uint8 constant public percentFeeAdminBite = 10;
232     
233     uint8 constant public percentFeed = 5;
234     
235     uint64 constant public pausePrey = 7 days;
236     uint64 constant public pauseHunter = 2 days;
237     
238     /**
239     * admin functions
240     */
241     
242     event UpdateMaxGasPrice(
243         uint256 maxGasPrice
244     );
245     event WithdrawalMarketing(
246         address indexed to, 
247         uint256 value
248     );
249     event WithdrawalOwner(
250         address indexed to, 
251         uint256 value
252     );
253     
254     function updateMaxGasPrice(uint256 _newMaxGasPrice) public onlyOwner {
255         require(_newMaxGasPrice >= 10000000000 wei); // 10000000000 wei = 10 gwei
256         
257         maxGasPrice=_newMaxGasPrice;
258         
259         emit UpdateMaxGasPrice(maxGasPrice);
260     }
261     
262     function withdrawalMarketing(address _to, uint256 _value) public onlyOwner {
263         balanceMarketing=balanceMarketing.sub(_value);
264         emit WithdrawalMarketing(_to, _value);
265         
266         _to.transfer(_value);
267     }
268     
269     function withdrawalOwner(address _to, uint256 _value) public onlyOwner {
270         balanceOwner=balanceOwner.sub(_value);
271         emit WithdrawalOwner(_to, _value);
272         
273         _to.transfer(_value);
274     }
275     
276     constructor() public {
277         
278         updateMaxGasPrice(25000000000 wei); // 25000000000 wei = 25 gwei
279         
280     }
281     
282     /**
283     * ERC721 functions
284     */
285     
286     modifier onlyOwnerOf(uint256 _tokenId) {
287         require(msg.sender == _tokenOwner[_tokenId], "not token owner");
288         _;
289     }
290     
291     function implementsERC721() public pure returns (bool) {
292         return true;
293     }
294     
295     function totalSupply() public view returns (uint256 total) {
296         return _totalSupply;
297     }
298     
299     function balanceOf(address _owner) public view returns (uint256 balance) {
300         return _ownedTokensCount[_owner];
301     }
302     
303     function ownerOf(uint256 _tokenId) public view returns (address owner) {
304         return _tokenOwner[_tokenId];
305     }
306     
307     function _transfer(address _from, address _to, uint256 _tokenId) private returns (bool) {
308         _ownedTokensCount[_to] = _ownedTokensCount[_to].add(1);
309         _ownedTokensCount[_from] = _ownedTokensCount[_from].sub(1);
310         _tokenOwner[_tokenId] = _to;
311         emit Transfer(_from, _to, _tokenId);
312         return true;
313     }
314     
315     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) returns (bool)  {
316         return _transfer(msg.sender, _to, _tokenId);
317     }
318     
319     /**
320     * refund
321     */
322     
323     function () public payable {
324         revert();
325     }
326 
327     /**
328     * fish functions
329     */
330     
331     event CreateFish(
332         uint256 indexed tokenId,
333         uint64 genes,
334         string nickname,
335         uint64 birthTime,
336         uint256 share,
337         uint256 feedValue,
338         uint256 eatenValue
339     );
340     event FeedFish(
341         uint256 indexed tokenId,
342         uint256 share,
343         uint256 feedValue,
344         uint256 eatenValue
345     );
346     event DestroyFish(
347         uint256 indexed tokenId,
348         uint256 share,
349         uint256 withdrawal
350     );    
351     event BiteFish(
352         uint256 indexed tokenId,
353         uint256 indexed preyId,
354         uint256 hunterShare,
355         uint256 hunterFeedValue,
356         uint256 preyShare,
357         uint256 preyFeedValue
358     );
359     event UpdateNickname(
360         uint256 indexed tokenId,
361         string nickname
362     );    
363     
364     modifier checkMaxGasPrice() {
365         require(tx.gasprice<=maxGasPrice, "gas price > maxGasPrice");
366         _;
367     }
368     
369     modifier checkMinPayment() {
370         require(msg.value>=minPayment, "msg.value < minPayment");
371         _;
372     }
373     
374     function createFish(string _nickname) public payable checkMinPayment checkMaxGasPrice returns(uint256) {
375         
376         uint256 feeMarketing=msg.value.mul(percentFeeMarketingInput).div(100);
377         uint256 feeFishes=msg.value.mul(percentFeeFishesInput).div(100);
378         uint256 value=msg.value.sub(feeMarketing).sub(feeFishes);
379         
380         balanceFishes=balanceFishes.add(value).add(feeFishes);
381         balanceMarketing=balanceMarketing.add(feeMarketing);
382         
383         uint256 share=_newShare(value);
384         
385         totalShares=totalShares.add(share);
386         
387         Fish memory newFish=Fish({
388             genes: _newGenes(),
389             nickname: _nickname,
390             birthTime: uint64(now),
391             feedTime: uint64(now),
392             huntTime: uint64(now), 
393             share: share,
394             feedValue: _newFeedValue(share),
395             eatenValue: value
396         });
397         uint256 newTokenId = fishes.push(newFish) - 1;
398         
399         _totalSupply=_totalSupply.add(1);
400         _ownedTokensCount[msg.sender]=_ownedTokensCount[msg.sender].add(1);
401         _tokenOwner[newTokenId]=msg.sender;
402         
403         emit CreateFish(newTokenId, fishes[newTokenId].genes, fishes[newTokenId].nickname, fishes[newTokenId].birthTime, fishes[newTokenId].share, fishes[newTokenId].feedValue, value);
404         emit Transfer(address(0), msg.sender, newTokenId);
405         
406         return newTokenId;
407     }
408     
409     function feedFish(uint256 _tokenId) public payable checkMinPayment checkMaxGasPrice returns(bool) {
410         require(statusLive(_tokenId), "fish dead");
411         
412         uint256 feeMarketing=msg.value.mul(percentFeeMarketingInput).div(100);
413         uint256 feeFishes=msg.value.mul(percentFeeFishesInput).div(100);
414         uint256 value=msg.value.sub(feeMarketing).sub(feeFishes);
415         
416         balanceFishes=balanceFishes.add(value).add(feeFishes);
417         balanceMarketing=balanceMarketing.add(feeMarketing);
418         
419         uint256 share=_newShare(value);
420         
421         totalShares=totalShares.add(share);
422         fishes[_tokenId].share=fishes[_tokenId].share.add(share);
423         fishes[_tokenId].eatenValue=fishes[_tokenId].eatenValue.add(value);
424         
425         if (value<fishes[_tokenId].feedValue) {
426             fishes[_tokenId].feedValue=fishes[_tokenId].feedValue.sub(value);
427         } else {
428             fishes[_tokenId].feedValue=_newFeedValue(fishes[_tokenId].share);
429             fishes[_tokenId].feedTime=uint64(now);
430             fishes[_tokenId].huntTime=uint64(now);
431         }
432         
433         emit FeedFish(_tokenId, share, fishes[_tokenId].feedValue, value);
434         
435         return true;
436     }
437 
438     function destroyFish(uint256 _tokenId) public onlyOwnerOf(_tokenId) checkMaxGasPrice returns(bool) {
439         
440         uint256 share=fishes[_tokenId].share;
441         uint256 withdrawal=shareToValue(share);
442         uint256 feeFishes=withdrawal.mul(percentFeeFishesOutput).div(100);
443         uint256 feeAdmin=withdrawal.mul(percentFeeAdminOutput).div(100);
444         
445         withdrawal=withdrawal.sub(feeFishes).sub(feeAdmin);
446         
447         totalShares=totalShares.sub(share);
448         fishes[_tokenId].share=0;
449         fishes[_tokenId].feedValue=0;
450         fishes[_tokenId].nickname="";
451         fishes[_tokenId].feedTime=uint64(now);
452         
453         _transfer(msg.sender, address(0), _tokenId);
454         
455         balanceOwner=balanceOwner.add(feeAdmin);
456         balanceFishes=balanceFishes.sub(withdrawal).sub(feeAdmin);
457         
458         emit DestroyFish(_tokenId, share, withdrawal);
459         
460         msg.sender.transfer(withdrawal);
461         
462         return true;   
463     }
464     
465     function biteFish(uint256 _tokenId, uint256 _preyId) public onlyOwnerOf(_tokenId) checkMaxGasPrice returns(bool) {
466         require(statusLive(_preyId), "prey dead");
467         require(statusPrey(_preyId), "not prey");
468         require(statusHunter(_tokenId), "not hunter");
469         require(fishes[_preyId].share<fishes[_tokenId].share, "too much prey");
470         
471         uint256 sharePrey;
472         uint256 shareHunter;
473         uint256 shareFishes;
474         uint256 shareAdmin;
475         uint256 value;
476         
477         if (shareToValue(fishes[_preyId].share)<minPayment.mul(2)) {
478             sharePrey=fishes[_preyId].share;
479             
480             _transfer(ownerOf(_preyId), address(0), _preyId);
481             fishes[_preyId].nickname="";
482         } else {
483             sharePrey=fishes[_preyId].share.mul(percentFeed).div(100);
484             
485             if (shareToValue(sharePrey)<minPayment) {
486                 sharePrey=valueToShare(minPayment);
487             }
488 
489         }
490         
491         shareFishes=sharePrey.mul(percentFeeFishesBite).div(100);
492         shareAdmin=sharePrey.mul(percentFeeAdminBite).div(100);
493         shareHunter=sharePrey.sub(shareFishes).sub(shareAdmin);
494         
495         fishes[_preyId].share=fishes[_preyId].share.sub(sharePrey);
496         fishes[_tokenId].share=fishes[_tokenId].share.add(shareHunter);
497         
498         fishes[_preyId].feedValue=_newFeedValue(fishes[_preyId].share);
499         fishes[_preyId].feedTime=uint64(now);
500         
501         fishes[_tokenId].huntTime=uint64(now);
502         
503         value=shareToValue(shareHunter);
504         
505         if (value<fishes[_tokenId].feedValue) {
506             fishes[_tokenId].feedValue=fishes[_tokenId].feedValue.sub(value);
507         } else {
508             fishes[_tokenId].feedValue=_newFeedValue(fishes[_tokenId].share);
509             fishes[_tokenId].feedTime=uint64(now);
510         }
511         
512         value=shareToValue(shareAdmin);
513         
514         totalShares=totalShares.sub(shareFishes).sub(shareAdmin);
515         
516         balanceOwner=balanceOwner.add(value);
517         balanceFishes=balanceFishes.sub(value);
518         
519         emit BiteFish(_tokenId, _preyId, shareHunter, fishes[_tokenId].feedValue, sharePrey, fishes[_preyId].feedValue);
520         
521         return true;        
522     }
523     
524     function updateNickname(uint256 _tokenId, string _nickname) public onlyOwnerOf(_tokenId) returns(bool) {
525         
526         fishes[_tokenId].nickname=_nickname;
527         
528         emit UpdateNickname(_tokenId, _nickname);
529         
530         return true;
531     }
532     
533     /**
534     * utilities
535     */
536     
537     function getFish(uint256 _tokenId) public view
538         returns (
539         uint64 genes,
540         string nickname,
541         uint64 birthTime,
542         uint64 feedTime,
543         uint64 huntTime,
544         uint256 share,
545         uint256 feedValue,
546         uint256 eatenValue
547     ) {
548         Fish memory fish=fishes[_tokenId];
549         
550         genes=fish.genes;
551         nickname=fish.nickname;
552         birthTime=fish.birthTime;
553         feedTime=fish.feedTime;
554         huntTime=fish.huntTime;
555         share=fish.share; 
556         feedValue=fish.feedValue; 
557         eatenValue=fish.eatenValue; 
558     }
559 
560     function statusLive(uint256 _tokenId) public view returns(bool) {
561         if (fishes[_tokenId].share==0) {return false;}
562         return true;
563     }
564     
565     function statusPrey(uint256 _tokenId) public view returns(bool) {
566         if (now<=fishes[_tokenId].feedTime.add(pausePrey)) {return false;}
567         return true;
568     }
569     
570     function statusHunter(uint256 _tokenId) public view returns(bool) {
571         if (now<=fishes[_tokenId].huntTime.add(pauseHunter)) {return false;}
572         return true;
573     }
574     
575     function shareToValue(uint256 _share) public view returns(uint256) {
576         if (totalShares == 0) {return 0;}
577         return _share.mul(balanceFishes).div(totalShares);
578     }
579     
580     function valueToShare(uint256 _value) public view returns(uint256) {
581         if (balanceFishes == 0) {return 0;}
582         return _value.mul(totalShares).div(balanceFishes);
583     }
584     
585     function _newShare(uint256 _value) private view returns(uint256) {
586         if (totalShares == 0) {return _value;}
587         return _value.mul(totalShares).div(balanceFishes.sub(_value));
588     }
589     
590     function _newFeedValue(uint256 _share) private view returns(uint256) {
591         uint256 _value=shareToValue(_share);
592         return _value.mul(percentFeed).div(100);
593     }
594     
595     function _newGenes() private view returns(uint64) {
596         return uint64(uint256(keccak256(abi.encodePacked(now, totalShares, balanceFishes)))%(10**11));
597     }
598     
599 }