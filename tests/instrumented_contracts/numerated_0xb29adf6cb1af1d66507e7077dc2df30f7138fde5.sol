1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * Utility library of inline functions on addresses
249  */
250 library AddressUtils {
251 
252   /**
253    * Returns whether the target address is a contract
254    * @dev This function will return false if invoked during the constructor of a contract,
255    * as the code is not actually created until after the constructor finishes.
256    * @param addr address to check
257    * @return whether the target address is a contract
258    */
259   function isContract(address addr) internal view returns (bool) {
260     uint256 size;
261     // XXX Currently there is no better way to check if there is a contract in an address
262     // than to check the size of the code at that address.
263     // See https://ethereum.stackexchange.com/a/14016/36603
264     // for more details about how this works.
265     // TODO Check this again before the Serenity release, because all addresses will be
266     // contracts then.
267     // solium-disable-next-line security/no-inline-assembly
268     assembly { size := extcodesize(addr) }
269     return size > 0;
270   }
271 
272 }
273 
274 /**
275  * @title MultiOwnable
276  * @dev 
277  */
278 contract MultiOwnable {
279     address public root;
280     mapping (address => bool) public owners;
281     
282     constructor() public {
283         root = msg.sender;
284         owners[root] = true;
285     }
286     
287     modifier onlyOwner() {
288         require(owners[msg.sender]);
289         _;
290     }
291     
292     modifier onlyRoot() {
293         require(msg.sender == root);
294         _;
295     }
296     
297     function newOwner(address owner) onlyRoot public returns (bool) {
298         require(owner != address(0));
299         
300         owners[owner] = true;
301         return true;
302     }
303     
304     function deleteOwner(address owner) onlyRoot public returns (bool) {
305         require(owner != root);
306         
307         delete owners[owner];
308         return true;
309     }
310 }
311 
312 /**
313  * @title Lockable token
314  **/
315 contract LockableToken is StandardToken, MultiOwnable {
316     bool public locked = true;
317     uint256 public constant LOCK_MAX = uint256(-1);
318     
319     /**
320      * @dev 락 상태에서도 거래 가능한 언락 계정
321      */
322     mapping(address => bool) public unlockAddrs;
323     
324     /**
325      * @dev 계정 별로 lock value 만큼 잔고가 잠김
326      * @dev - 값이 0 일 때 : 잔고가 0 이어도 되므로 제한이 없는 것임.
327      * @dev - 값이 LOCK_MAX 일 때 : 잔고가 uint256 의 최대값이므로 아예 잠긴 것임.
328      */
329     mapping(address => uint256) public lockValues;
330     
331     event Locked(bool locked, string note);
332     event LockedTo(address indexed addr, bool locked, string note);
333     event SetLockValue(address indexed addr, uint256 value, string note);
334     
335     constructor() public {
336         unlockTo(msg.sender, "");
337     }
338     
339     modifier checkUnlock (address addr, uint256 value) {
340         require(!locked || unlockAddrs[addr]);
341         require(balances[addr].sub(value) >= lockValues[addr]);
342         _;
343     }
344     
345     function lock(string note) onlyOwner public {
346         locked = true;  
347         emit Locked(locked, note);
348     }
349     
350     function unlock(string note) onlyOwner public {
351         locked = false;
352         emit Locked(locked, note);
353     }
354     
355     function lockTo(address addr, string note) onlyOwner public {
356         require(addr != root);
357         
358         setLockValue(addr, LOCK_MAX, note);
359         unlockAddrs[addr] = false;
360         
361         emit LockedTo(addr, true, note);
362     }
363     
364     function unlockTo(address addr, string note) onlyOwner public {
365         if (lockValues[addr] == LOCK_MAX)
366             setLockValue(addr, 0, note);
367         unlockAddrs[addr] = true;
368         
369         emit LockedTo(addr, false, note);
370     }
371     
372     function setLockValue(address addr, uint256 value, string note) onlyOwner public {
373         lockValues[addr] = value;
374         emit SetLockValue(addr, value, note);
375     }
376     
377     /**
378      * @dev 이체 가능 금액을 조회한다.
379      */ 
380     function getMyUnlockValue() public view returns (uint256) {
381         address addr = msg.sender;
382         if ((!locked || unlockAddrs[addr]) && balances[addr] >= lockValues[addr])
383             return balances[addr].sub(lockValues[addr]);
384         else
385             return 0;
386     }
387     
388     function transfer(address to, uint256 value) checkUnlock(msg.sender, value) public returns (bool) {
389         return super.transfer(to, value);
390     }
391     
392     function transferFrom(address from, address to, uint256 value) checkUnlock(from, value) public returns (bool) {
393         return super.transferFrom(from, to, value);
394     }
395 }
396 
397 /**
398  * @title KSCBaseToken
399  * @dev 트랜잭션 실행 시 메모를 남길 수 있도록 하였음.
400  */
401 contract KSCBaseToken is LockableToken {
402     using AddressUtils for address;
403     
404     event KSCTransfer(address indexed from, address indexed to, uint256 value, string note);
405     event KSCTransferFrom(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
406     event KSCApproval(address indexed owner, address indexed spender, uint256 value, string note);
407 
408     event KSCMintTo(address indexed controller, address indexed to, uint256 amount, string note);
409     event KSCBurnFrom(address indexed controller, address indexed from, uint256 value, string note);
410 
411     event KSCBurnWhenMoveToMainnet(address indexed controller, address indexed from, uint256 value, string note);
412     event KSCBurnWhenUseInSidechain(address indexed controller, address indexed from, uint256 value, string note);
413 
414     event KSCSell(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
415     event KSCSellByOtherCoin(address indexed owner, address indexed spender, address indexed to, uint256 value,  uint256 processIdHash, uint256 userIdHash, string note);
416 
417     event KSCTransferToEcosystem(address indexed owner, address indexed spender, address indexed to, uint256 value, uint256 processIdHash, uint256 userIdHash, string note);
418     event KSCTransferToBounty(address indexed owner, address indexed spender, address indexed to, uint256 value, uint256 processIdHash, uint256 userIdHash, string note);
419 
420     // ERC20 함수들을 오버라이딩하여 super 로 올라가지 않고 무조건 ksc~ 함수로 지나가게 한다.
421     function transfer(address to, uint256 value) public returns (bool ret) {
422         return kscTransfer(to, value, "");
423     }
424     
425     function kscTransfer(address to, uint256 value, string note) public returns (bool ret) {
426         require(to != address(this));
427         
428         ret = super.transfer(to, value);
429         emit KSCTransfer(msg.sender, to, value, note);
430     }
431     
432     function transferFrom(address from, address to, uint256 value) public returns (bool) {
433         return kscTransferFrom(from, to, value, "");
434     }
435     
436     function kscTransferFrom(address from, address to, uint256 value, string note) public returns (bool ret) {
437         require(to != address(this));
438         
439         ret = super.transferFrom(from, to, value);
440         emit KSCTransferFrom(from, msg.sender, to, value, note);
441     }
442 
443     function approve(address spender, uint256 value) public returns (bool) {
444         return kscApprove(spender, value, "");
445     }
446     
447     function kscApprove(address spender, uint256 value, string note) public returns (bool ret) {
448         ret = super.approve(spender, value);
449         emit KSCApproval(msg.sender, spender, value, note);
450     }
451 
452     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
453         return kscIncreaseApproval(spender, addedValue, "");
454     }
455 
456     function kscIncreaseApproval(address spender, uint256 addedValue, string note) public returns (bool ret) {
457         ret = super.increaseApproval(spender, addedValue);
458         emit KSCApproval(msg.sender, spender, allowed[msg.sender][spender], note);
459     }
460 
461     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
462         return kscDecreaseApproval(spender, subtractedValue, "");
463     }
464 
465     function kscDecreaseApproval(address spender, uint256 subtractedValue, string note) public returns (bool ret) {
466         ret = super.decreaseApproval(spender, subtractedValue);
467         emit KSCApproval(msg.sender, spender, allowed[msg.sender][spender], note);
468     }
469 
470     /**
471      * @dev 신규 화폐 발행. 반드시 이유를 메모로 남겨라.
472      */
473     function mintTo(address to, uint256 amount) internal returns (bool) {
474         require(to != address(0x0));
475 
476         totalSupply_ = totalSupply_.add(amount);
477         balances[to] = balances[to].add(amount);
478         
479         emit Transfer(address(0), to, amount);
480         return true;
481     }
482     
483     function kscMintTo(address to, uint256 amount, string note) onlyOwner public returns (bool ret) {
484         ret = mintTo(to, amount);
485         emit KSCMintTo(msg.sender, to, amount, note);
486     }
487 
488     /**
489      * @dev 화폐 소각. 반드시 이유를 메모로 남겨라.
490      */
491     function burnFrom(address from, uint256 value) internal returns (bool) {
492         require(value <= balances[from]);
493         
494         balances[from] = balances[from].sub(value);
495         totalSupply_ = totalSupply_.sub(value);
496         
497         emit Transfer(from, address(0), value);
498         return true;        
499     }
500     
501     function kscBurnFrom(address from, uint256 value, string note) onlyOwner public returns (bool ret) {
502         ret = burnFrom(from, value);
503         emit KSCBurnFrom(msg.sender, from, value, note);
504     }
505 
506     /**
507      * @dev 메인넷으로 이동하며 화폐 소각.
508      */
509     function kscBurnWhenMoveToMainnet(address burner, uint256 value, string note) onlyOwner public returns (bool ret) {
510         ret = burnFrom(burner, value);
511         emit KSCBurnWhenMoveToMainnet(msg.sender, burner, value, note);
512     }
513     
514     function kscBatchBurnWhenMoveToMainnet(address[] burners, uint256[] values, string note) onlyOwner public returns (bool ret) {
515         uint256 length = burners.length;
516         require(length == values.length);
517         
518         ret = true;
519         for (uint256 i = 0; i < length; i++) {
520             ret = ret && kscBurnWhenMoveToMainnet(burners[i], values[i], note);
521         }
522     }
523 
524     /**
525      * @dev 사이드체인에서 사용하여 화폐 소각.
526      */
527     function kscBurnWhenUseInSidechain(address burner, uint256 value, string note) onlyOwner public returns (bool ret) {
528         ret = burnFrom(burner, value);
529         emit KSCBurnWhenUseInSidechain(msg.sender, burner, value, note);
530     }
531 
532     function kscBatchBurnWhenUseInSidechain(address[] burners, uint256[] values, string note) onlyOwner public returns (bool ret) {
533         uint256 length = burners.length;
534         require(length == values.length);
535         
536         ret = true;
537         for (uint256 i = 0; i < length; i++) {
538             ret = ret && kscBurnWhenUseInSidechain(burners[i], values[i], note);
539         }
540     }
541 
542     /**
543      * @dev 이더로 KSC 를 구입하는 경우
544      */
545     function kscSell(address from, address to, uint256 value, string note) onlyOwner public returns (bool ret) {
546         require(to != address(this));        
547 
548         ret = super.transferFrom(from, to, value);
549         emit KSCSell(from, msg.sender, to, value, note);
550     }
551     
552     /**
553      * @dev 비트코인 등의 다른 코인으로 KSC 를 구입하는 경우
554      * @dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
555      */
556     function kscBatchSellByOtherCoin(address from, address[] to, uint256[] values, uint256 processIdHash, uint256[] userIdHash, string note) onlyOwner public returns (bool ret) {
557         uint256 length = to.length;
558         require(length == values.length);
559         require(length == userIdHash.length);
560         
561         ret = true;
562         for (uint256 i = 0; i < length; i++) {
563             require(to[i] != address(this));            
564             
565             ret = ret && super.transferFrom(from, to[i], values[i]);
566             emit KSCSellByOtherCoin(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
567         }
568     }
569     
570     /**
571      * @dev 에코시스템(커뮤니티 활동을 통한 보상 등)으로 KSC 지급
572      * @dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
573      */
574     function kscBatchTransferToEcosystem(address from, address[] to, uint256[] values, uint256 processIdHash, uint256[] userIdHash, string note) onlyOwner public returns (bool ret) {
575         uint256 length = to.length;
576         require(length == values.length);
577         require(length == userIdHash.length);
578 
579         ret = true;
580         for (uint256 i = 0; i < length; i++) {
581             require(to[i] != address(this));            
582             
583             ret = ret && super.transferFrom(from, to[i], values[i]);
584             emit KSCTransferToEcosystem(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
585         }
586     }
587 
588     /**
589      * @dev 바운티 참여자에게 KSC 지급
590      * @dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
591      */
592     function kscBatchTransferToBounty(address from, address[] to, uint256[] values, uint256 processIdHash, uint256[] userIdHash, string note) onlyOwner public returns (bool ret) {
593         uint256 length = to.length;
594         require(to.length == values.length);
595 
596         ret = true;
597         for (uint256 i = 0; i < length; i++) {
598             require(to[i] != address(this));            
599             
600             ret = ret && super.transferFrom(from, to[i], values[i]);
601             emit KSCTransferToBounty(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
602         }
603     }
604 
605     function destroy() onlyRoot public {
606         selfdestruct(root);
607     }
608 }
609 
610 /**
611  * @title KStarCoin
612  */
613 contract KStarCoin is KSCBaseToken {
614     using AddressUtils for address;
615     
616     string public constant name = "KStarCoin";
617     string public constant symbol = "KSC";
618     uint8 public constant decimals = 18;
619     
620     uint256 public constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(decimals));
621     
622     bytes4 internal constant KSC_RECEIVED = 0xe6947547; // KSCReceiver.onKSCReceived.selector
623     
624     constructor() public {
625         totalSupply_ = INITIAL_SUPPLY;
626         balances[msg.sender] = INITIAL_SUPPLY;
627         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
628     }
629     
630     function kscTransfer(address to, uint256 value, string note) public returns (bool ret) {
631         ret = super.kscTransfer(to, value, note);
632         require(postTransfer(msg.sender, msg.sender, to, value, KSCReceiver.KSCReceiveType.KSC_TRANSFER));
633     }
634     
635     function kscTransferFrom(address from, address to, uint256 value, string note) public returns (bool ret) {
636         ret = super.kscTransferFrom(from, to, value, note);
637         require(postTransfer(from, msg.sender, to, value, KSCReceiver.KSCReceiveType.KSC_TRANSFER));
638     }
639     
640     function postTransfer(address owner, address spender, address to, uint256 value, KSCReceiver.KSCReceiveType receiveType) internal returns (bool) {
641         if (!to.isContract())
642             return true;
643         
644         bytes4 retval = KSCReceiver(to).onKSCReceived(owner, spender, value, receiveType);
645         return (retval == KSC_RECEIVED);
646     }
647     
648     function kscMintTo(address to, uint256 amount, string note) onlyOwner public returns (bool ret) {
649         ret = super.kscMintTo(to, amount, note);
650         require(postTransfer(0x0, msg.sender, to, amount, KSCReceiver.KSCReceiveType.KSC_MINT));
651     }
652     
653     function kscBurnFrom(address from, uint256 value, string note) onlyOwner public returns (bool ret) {
654         ret = super.kscBurnFrom(from, value, note);
655         require(postTransfer(0x0, msg.sender, from, value, KSCReceiver.KSCReceiveType.KSC_BURN));
656     }
657 }
658 
659 
660 /**
661  * @title KStarCoin Receiver
662  */ 
663 contract KSCReceiver {
664     bytes4 internal constant KSC_RECEIVED = 0xe6947547; // this.onKSCReceived.selector
665     enum KSCReceiveType { KSC_TRANSFER, KSC_MINT, KSC_BURN }
666     
667     function onKSCReceived(address owner, address spender, uint256 value, KSCReceiveType receiveType) public returns (bytes4);
668 }
669 
670 /**
671  * @title KSCDappSample 
672  */
673 contract KSCDappSample is KSCReceiver {
674     event LogOnReceiveKSC(string message, address indexed owner, address indexed spender, uint256 value, KSCReceiveType receiveType);
675     
676     function onKSCReceived(address owner, address spender, uint256 value, KSCReceiveType receiveType) public returns (bytes4) {
677         emit LogOnReceiveKSC("I receive KstarCoin.", owner, spender, value, receiveType);
678         
679         return KSC_RECEIVED; // must return this value if successful
680     }
681 }