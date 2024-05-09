1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * @dev https://github.com/ethereum/EIPs/issues/20
104  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
105  */
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * @dev Increase the amount of tokens that an owner allowed to a spender.
157    *
158    * approve should be called when allowed[_spender] == 0. To increment
159    * allowed value is better to use this function to avoid 2 calls (and wait until
160    * the first transaction is mined)
161    * From MonolithDAO Token.sol
162    * @param _spender The address which will spend the funds.
163    * @param _addedValue The amount of tokens to increase the allowance by.
164    */
165   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   /**
172    * @dev Decrease the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To decrement
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _subtractedValue The amount of tokens to decrease the allowance by.
180    */
181   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
182     uint oldValue = allowed[msg.sender][_spender];
183     if (_subtractedValue > oldValue) {
184       allowed[msg.sender][_spender] = 0;
185     } else {
186       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
187     }
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192 }
193 
194 
195 /**
196  * @title Ownable
197  * @dev The Ownable contract has an owner address, and provides basic authorization control
198  * functions, this simplifies the implementation of "user permissions".
199  */
200 contract Ownable {
201     address public owner;
202     address public newOwner;
203 
204 
205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207 
208     /**
209      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
210      * account.
211      */
212     function Ownable() public {
213         owner = msg.sender;
214     }
215 
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(msg.sender == owner);
222         _;
223     }
224 
225 
226     /**
227      * @dev Allows the current owner to transfer control of the contract to a newOwner.
228      * @param _newOwner The address to transfer ownership to.
229      */
230     function transferOwnership(address _newOwner) public onlyOwner {
231         require(_newOwner != address(0));
232         OwnershipTransferred(owner, _newOwner);
233         newOwner = _newOwner;
234     }
235 
236     /**
237      * @dev 새로운 관리자가 승인해야만 소유권이 이전된다
238      */
239     function acceptOwnership() public {
240         require(msg.sender == newOwner);
241         
242         OwnershipTransferred(owner, newOwner);
243         owner = newOwner;
244         newOwner = address(0);
245     }
246 }
247 
248 
249 /**
250  * @title APIS Token
251  * @dev APIS 토큰을 생성한다
252  */
253 contract ApisToken is StandardToken, Ownable {
254     // 토큰의 이름
255     string public constant name = "APIS";
256     
257     // 토큰의 단위
258     string public constant symbol = "APIS";
259     
260     // 소수점 자리수. ETH 18자리에 맞춘다
261     uint8 public constant decimals = 18;
262     
263     // 지갑별로 송금/수금 기능의 잠긴 여부를 저장
264     mapping (address => LockedInfo) public lockedWalletInfo;
265     
266     /**
267      * @dev 플랫폼에서 운영하는 마스터노드 스마트 컨트렉트 주소
268      */
269     mapping (address => bool) public manoContracts;
270     
271     
272     /**
273      * @dev 토큰 지갑의 잠김 속성을 정의
274      * 
275      * @param timeLockUpEnd timeLockUpEnd 시간까지 송/수금에 대한 제한이 적용된다. 이후에는 제한이 풀린다
276      * @param sendLock 출금 잠김 여부(true : 잠김, false : 풀림)
277      * @param receiveLock 입금 잠김 여부 (true : 잠김, false : 풀림)
278      */
279     struct LockedInfo {
280         uint timeLockUpEnd;
281         bool sendLock;
282         bool receiveLock;
283     } 
284     
285     
286     /**
287      * @dev 토큰이 송금됐을 때 발생하는 이벤트
288      * @param from 토큰을 보내는 지갑 주소
289      * @param to 토큰을 받는 지갑 주소
290      * @param value 전달되는 토큰의 양 (Satoshi)
291      */
292     event Transfer (address indexed from, address indexed to, uint256 value);
293     
294     /**
295      * @dev 토큰 지갑의 송금/입금 기능이 제한되었을 때 발생하는 이벤트
296      * @param target 제한 대상 지갑 주소
297      * @param timeLockUpEnd 제한이 종료되는 시간(UnixTimestamp)
298      * @param sendLock 지갑에서의 송금을 제한하는지 여부(true : 제한, false : 해제)
299      * @param receiveLock 지갑으로의 입금을 제한하는지 여부 (true : 제한, false : 해제)
300      */
301     event Locked (address indexed target, uint timeLockUpEnd, bool sendLock, bool receiveLock);
302     
303     /**
304      * @dev 지갑에 대한 송금/입금 제한을 해제했을 때 발생하는 이벤트
305      * @param target 해제 대상 지갑 주소
306      */
307     event Unlocked (address indexed target);
308     
309     /**
310      * @dev 송금 받는 지갑의 입금이 제한되어있어서 송금이 거절되었을 때 발생하는 이벤트
311      * @param from 토큰을 보내는 지갑 주소
312      * @param to (입금이 제한된) 토큰을 받는 지갑 주소
313      * @param value 전송하려고 한 토큰의 양(Satoshi)
314      */
315     event RejectedPaymentToLockedUpWallet (address indexed from, address indexed to, uint256 value);
316     
317     /**
318      * @dev 송금하는 지갑의 출금이 제한되어있어서 송금이 거절되었을 때 발생하는 이벤트
319      * @param from (출금이 제한된) 토큰을 보내는 지갑 주소
320      * @param to 토큰을 받는 지갑 주소
321      * @param value 전송하려고 한 토큰의 양(Satoshi)
322      */
323     event RejectedPaymentFromLockedUpWallet (address indexed from, address indexed to, uint256 value);
324     
325     /**
326      * @dev 토큰을 소각한다. 
327      * @param burner 토큰을 소각하는 지갑 주소
328      * @param value 소각하는 토큰의 양(Satoshi)
329      */
330     event Burn (address indexed burner, uint256 value);
331     
332     /**
333      * @dev 아피스 플랫폼에 마스터노드 스마트 컨트렉트가 등록되거나 해제될 때 발생하는 이벤트
334      */
335     event ManoContractRegistered (address manoContract, bool registered);
336     
337     /**
338      * @dev 컨트랙트가 생성될 때 실행. 컨트렉트 소유자 지갑에 모든 토큰을 할당한다.
339      * 발행량이나 이름은 소스코드에서 확인할 수 있도록 변경하였음
340      */
341     function ApisToken() public {
342         // 총 APIS 발행량 (95억 2천만)
343         uint256 supplyApis = 9520000000;
344         
345         // wei 단위로 토큰 총량을 생성한다.
346         totalSupply = supplyApis * 10 ** uint256(decimals);
347         
348         balances[msg.sender] = totalSupply;
349         
350         Transfer(0x0, msg.sender, totalSupply);
351     }
352     
353     
354     /**
355      * @dev 지갑을 지정된 시간까지 제한시키거나 해제시킨다. 제한 시간이 경과하면 모든 제한이 해제된다.
356      * @param _targetWallet 제한을 적용할 지갑 주소
357      * @param _timeLockEnd 제한이 종료되는 시간(UnixTimestamp)
358      * @param _sendLock (true : 지갑에서 토큰을 출금하는 기능을 제한한다.) (false : 제한을 해제한다)
359      * @param _receiveLock (true : 지갑으로 토큰을 입금받는 기능을 제한한다.) (false : 제한을 해제한다)
360      */
361     function walletLock(address _targetWallet, uint _timeLockEnd, bool _sendLock, bool _receiveLock) onlyOwner public {
362         require(_targetWallet != 0x0);
363         
364         // If all locks are unlocked, set the _timeLockEnd to zero.
365         if(_sendLock == false && _receiveLock == false) {
366             _timeLockEnd = 0;
367         }
368         
369         lockedWalletInfo[_targetWallet].timeLockUpEnd = _timeLockEnd;
370         lockedWalletInfo[_targetWallet].sendLock = _sendLock;
371         lockedWalletInfo[_targetWallet].receiveLock = _receiveLock;
372         
373         if(_timeLockEnd > 0) {
374             Locked(_targetWallet, _timeLockEnd, _sendLock, _receiveLock);
375         } else {
376             Unlocked(_targetWallet);
377         }
378     }
379     
380     /**
381      * @dev 지갑의 입급/출금을 지정된 시간까지 제한시킨다. 제한 시간이 경과하면 모든 제한이 해제된다.
382      * @param _targetWallet 제한을 적용할 지갑 주소
383      * @param _timeLockUpEnd 제한이 종료되는 시간(UnixTimestamp)
384      */
385     function walletLockBoth(address _targetWallet, uint _timeLockUpEnd) onlyOwner public {
386         walletLock(_targetWallet, _timeLockUpEnd, true, true);
387     }
388     
389     /**
390      * @dev 지갑의 입급/출금을 영원히(33658-9-27 01:46:39+00) 제한시킨다.
391      * @param _targetWallet 제한을 적용할 지갑 주소
392      */
393     function walletLockBothForever(address _targetWallet) onlyOwner public {
394         walletLock(_targetWallet, 999999999999, true, true);
395     }
396     
397     
398     /**
399      * @dev 지갑에 설정된 입출금 제한을 해제한다
400      * @param _targetWallet 제한을 해제하고자 하는 지갑 주소
401      */
402     function walletUnlock(address _targetWallet) onlyOwner public {
403         walletLock(_targetWallet, 0, false, false);
404     }
405     
406     /**
407      * @dev 지갑의 송금 기능이 제한되어있는지 확인한다.
408      * @param _addr 송금 제한 여부를 확인하려는 지갑의 주소
409      * @return isSendLocked (true : 제한되어 있음, 토큰을 보낼 수 없음) (false : 제한 없음, 토큰을 보낼 수 있음)
410      * @return until 잠겨있는 시간, UnixTimestamp
411      */
412     function isWalletLocked_Send(address _addr) public constant returns (bool isSendLocked, uint until) {
413         require(_addr != 0x0);
414         
415         isSendLocked = (lockedWalletInfo[_addr].timeLockUpEnd > now && lockedWalletInfo[_addr].sendLock == true);
416         
417         if(isSendLocked) {
418             until = lockedWalletInfo[_addr].timeLockUpEnd;
419         } else {
420             until = 0;
421         }
422     }
423     
424     /**
425      * @dev 지갑의 입금 기능이 제한되어있는지 확인한다.
426      * @param _addr 입금 제한 여부를 확인하려는 지갑의 주소
427      * @return (true : 제한되어 있음, 토큰을 받을 수 없음) (false : 제한 없음, 토큰을 받을 수 있음)
428      */
429     function isWalletLocked_Receive(address _addr) public constant returns (bool isReceiveLocked, uint until) {
430         require(_addr != 0x0);
431         
432         isReceiveLocked = (lockedWalletInfo[_addr].timeLockUpEnd > now && lockedWalletInfo[_addr].receiveLock == true);
433         
434         if(isReceiveLocked) {
435             until = lockedWalletInfo[_addr].timeLockUpEnd;
436         } else {
437             until = 0;
438         }
439     }
440     
441     /**
442      * @dev 요청자의 지갑에 송금 기능이 제한되어있는지 확인한다.
443      * @return (true : 제한되어 있음, 토큰을 보낼 수 없음) (false : 제한 없음, 토큰을 보낼 수 있음)
444      */
445     function isMyWalletLocked_Send() public constant returns (bool isSendLocked, uint until) {
446         return isWalletLocked_Send(msg.sender);
447     }
448     
449     /**
450      * @dev 요청자의 지갑에 입금 기능이 제한되어있는지 확인한다.
451      * @return (true : 제한되어 있음, 토큰을 보낼 수 없음) (false : 제한 없음, 토큰을 보낼 수 있음)
452      */
453     function isMyWalletLocked_Receive() public constant returns (bool isReceiveLocked, uint until) {
454         return isWalletLocked_Receive(msg.sender);
455     }
456     
457     
458     /**
459      * @dev 아피스 플랫폼에서 운영하는 스마트 컨트렉트 주소를 등록하거나 해제한다.
460      * @param manoAddr 마스터노드 스마트 컨트렉컨트렉트
461      * @param registered true : 등록, false : 해제
462      */
463     function registerManoContract(address manoAddr, bool registered) onlyOwner public {
464         manoContracts[manoAddr] = registered;
465         
466         ManoContractRegistered(manoAddr, registered);
467     }
468     
469     
470     /**
471      * @dev _to 지갑으로 _apisWei 만큼의 토큰을 송금한다.
472      * @param _to 토큰을 받는 지갑 주소
473      * @param _apisWei 전송되는 토큰의 양
474      */
475     function transfer(address _to, uint256 _apisWei) public returns (bool) {
476         // 자신에게 송금하는 것을 방지한다
477         require(_to != address(this));
478         
479         // 마스터노드 컨트렉트일 경우, APIS 송수신에 제한을 두지 않는다
480         if(manoContracts[msg.sender] || manoContracts[_to]) {
481             return super.transfer(_to, _apisWei);
482         }
483         
484         // 송금 기능이 잠긴 지갑인지 확인한다.
485         if(lockedWalletInfo[msg.sender].timeLockUpEnd > now && lockedWalletInfo[msg.sender].sendLock == true) {
486             RejectedPaymentFromLockedUpWallet(msg.sender, _to, _apisWei);
487             return false;
488         } 
489         // 입금 받는 기능이 잠긴 지갑인지 확인한다
490         else if(lockedWalletInfo[_to].timeLockUpEnd > now && lockedWalletInfo[_to].receiveLock == true) {
491             RejectedPaymentToLockedUpWallet(msg.sender, _to, _apisWei);
492             return false;
493         } 
494         // 제한이 없는 경우, 송금을 진행한다.
495         else {
496             return super.transfer(_to, _apisWei);
497         }
498     }
499     
500     /**
501      * @dev _to 지갑으로 _apisWei 만큼의 APIS를 송금하고 _timeLockUpEnd 시간만큼 지갑을 잠근다
502      * @param _to 토큰을 받는 지갑 주소
503      * @param _apisWei 전송되는 토큰의 양(wei)
504      * @param _timeLockUpEnd 잠금이 해제되는 시간
505      */
506     function transferAndLockUntil(address _to, uint256 _apisWei, uint _timeLockUpEnd) onlyOwner public {
507         require(transfer(_to, _apisWei));
508         
509         walletLockBoth(_to, _timeLockUpEnd);
510     }
511     
512     /**
513      * @dev _to 지갑으로 _apisWei 만큼의 APIS를 송금하고영원히 지갑을 잠근다
514      * @param _to 토큰을 받는 지갑 주소
515      * @param _apisWei 전송되는 토큰의 양(wei)
516      */
517     function transferAndLockForever(address _to, uint256 _apisWei) onlyOwner public {
518         require(transfer(_to, _apisWei));
519         
520         walletLockBothForever(_to);
521     }
522     
523     
524     /**
525      * @dev 함수를 호출하는 지갑의 토큰을 소각한다.
526      * 
527      * zeppelin-solidity/contracts/token/BurnableToken.sol 참조
528      * @param _value 소각하려는 토큰의 양(Satoshi)
529      */
530     function burn(uint256 _value) public {
531         require(_value <= balances[msg.sender]);
532         require(_value <= totalSupply);
533         
534         address burner = msg.sender;
535         balances[burner] -= _value;
536         totalSupply -= _value;
537         
538         Burn(burner, _value);
539     }
540     
541     
542     /**
543      * @dev Eth은 받을 수 없도록 한다.
544      */
545     function () public payable {
546         revert();
547     }
548 }
549 
550 
551 
552 
553 
554 
555 
556 
557 /**
558  * @title WhiteList
559  * @dev ICO 참여가 가능한 화이트 리스트를 관리한다
560  */
561 contract WhiteList is Ownable {
562     
563     mapping (address => uint8) internal list;
564     
565     /**
566      * @dev 화이트리스트에 변동이 발생했을 때 이벤트
567      * @param backer 화이트리스트에 등재하려는 지갑 주소
568      * @param allowed (true : 화이트리스트에 추가) (false : 제거)
569      */
570     event WhiteBacker(address indexed backer, bool allowed);
571     
572     
573     /**
574      * @dev 화이트리스트에 등록하거나 해제한다.
575      * @param _target 화이트리스트에 등재하려는 지갑 주소
576      * @param _allowed (true : 화이트리스트에 추가) (false : 제거) 
577      */
578     function setWhiteBacker(address _target, bool _allowed) onlyOwner public {
579         require(_target != 0x0);
580         
581         if(_allowed == true) {
582             list[_target] = 1;
583         } else {
584             list[_target] = 0;
585         }
586         
587         WhiteBacker(_target, _allowed);
588     }
589     
590     /**
591      * @dev 화이트 리스트에 등록(추가)한다
592      * @param _target 추가할 지갑 주소
593      */
594     function addWhiteBacker(address _target) onlyOwner public {
595         setWhiteBacker(_target, true);
596     }
597     
598     /**
599      * @dev 화이트리스트에 여러 지갑 주소를 동시에 등재하거나 제거한다.
600      * 
601      * 가스 소모를 줄여보기 위함
602      * @param _backers 대상이 되는 지갑들의 리스트
603      * @param _allows 대상이 되는 지갑들의 추가 여부 리스트 (true : 추가) (false : 제거)
604      */
605     function setWhiteBackersByList(address[] _backers, bool[] _allows) onlyOwner public {
606         require(_backers.length > 0);
607         require(_backers.length == _allows.length);
608         
609         for(uint backerIndex = 0; backerIndex < _backers.length; backerIndex++) {
610             setWhiteBacker(_backers[backerIndex], _allows[backerIndex]);
611         }
612     }
613     
614     /**
615      * @dev 화이트리스트에 여러 지갑 주소를 등재한다.
616      * 
617      * 모든 주소들은 화이트리스트에 추가된다.
618      * @param _backers 대상이 되는 지갑들의 리스트
619      */
620     function addWhiteBackersByList(address[] _backers) onlyOwner public {
621         for(uint backerIndex = 0; backerIndex < _backers.length; backerIndex++) {
622             setWhiteBacker(_backers[backerIndex], true);
623         }
624     }
625     
626     
627     /**
628      * @dev 해당 지갑 주소가 화이트 리스트에 등록되어있는지 확인한다
629      * @param _addr 등재 여부를 확인하려는 지갑의 주소
630      * @return (true : 등록되어있음) (false : 등록되어있지 않음)
631      */
632     function isInWhiteList(address _addr) public constant returns (bool) {
633         require(_addr != 0x0);
634         return list[_addr] > 0;
635     }
636     
637     /**
638      * @dev 요청하는 지갑이 화이트리스트에 등록되어있는지 확인한다.
639      * @return (true : 등록되어있음) (false : 등록되어있지 않음)
640      */
641     function isMeInWhiteList() public constant returns (bool isWhiteBacker) {
642         return list[msg.sender] > 0;
643     }
644 }
645 
646 
647 
648 /**
649  * @title APIS Crowd Pre-Sale
650  * @dev 토큰의 프리세일을 수행하기 위한 컨트랙트
651  */
652 contract ApisCrowdSale is Ownable {
653     
654     // 소수점 자리수. Eth 18자리에 맞춘다
655     uint8 public constant decimals = 18;
656     
657     
658     // 크라우드 세일의 판매 목표량(APIS)
659     uint256 public fundingGoal;
660     
661     // 현재 진행하는 판매 목표량 
662     // QTUM과 공동으로 판매가 진행되기 때문에,  QTUM 쪽 컨트렉트와 합산한 판매량이 총 판매목표를 넘지 않도록 하기 위함
663     uint256 public fundingGoalCurrent;
664     
665     // 1 ETH으로 살 수 있는 APIS의 갯수
666     uint256 public priceOfApisPerFund;
667     
668 
669     // 발급된 Apis 갯수 (예약 + 발행)
670     //uint256 public totalSoldApis;
671     
672     // 발행 대기중인 APIS 갯수
673     //uint256 public totalReservedApis;
674     
675     // 발행되서 출금된 APIS 갯수
676     //uint256 public totalWithdrawedApis;
677     
678     
679     // 입금된 투자금의 총액 (예약 + 발행)
680     //uint256 public totalReceivedFunds;
681     
682     // 구매 확정 전 투자금의 총액
683     //uint256 public totalReservedFunds;
684     
685     // 구매 확정된 투자금의 총액
686     //uint256 public totalPaidFunds;
687 
688     
689     // 판매가 시작되는 시간
690     uint public startTime;
691     
692     // 판매가 종료되는 시간
693     uint public endTime;
694 
695     // 판매가 조기에 종료될 경우를 대비하기 위함
696     bool closed = false;
697     
698 	SaleStatus public saleStatus;
699     
700     // APIS 토큰 컨트렉트
701     ApisToken internal tokenReward;
702     
703     // 화이트리스트 컨트렉트
704     WhiteList internal whiteList;
705 
706     
707     
708     mapping (address => Property) public fundersProperty;
709     
710     /**
711      * @dev APIS 토큰 구매자의 자산 현황을 정리하기 위한 구조체
712      */
713     struct Property {
714         uint256 reservedFunds;   // 입금했지만 아직 APIS로 변환되지 않은 Eth (환불 가능)
715         uint256 paidFunds;    	// APIS로 변환된 Eth (환불 불가)
716         uint256 reservedApis;   // 받을 예정인 토큰
717         uint256 withdrawedApis; // 이미 받은 토큰
718         uint purchaseTime;      // 구입한 시간
719     }
720 	
721 	
722 	/**
723 	 * @dev 현재 세일의 진행 현황을 확인할 수 있다.
724 	 * totalSoldApis 발급된 Apis 갯수 (예약 + 발행)
725 	 * totalReservedApis 발행 대기 중인 Apis
726 	 * totalWithdrawedApis 발행되서 출금된 APIS 갯수
727 	 * 
728 	 * totalReceivedFunds 입금된 투자금의 총액 (예약 + 발행)
729 	 * totalReservedFunds 구매 확정 전 투자금의 총액
730 	 * ttotalPaidFunds 구매 확정된 투자금의 총액
731 	 */
732 	struct SaleStatus {
733 		uint256 totalReservedFunds;
734 		uint256 totalPaidFunds;
735 		uint256 totalReceivedFunds;
736 		
737 		uint256 totalReservedApis;
738 		uint256 totalWithdrawedApis;
739 		uint256 totalSoldApis;
740 	}
741     
742     
743     
744     /**
745      * @dev APIS를 구입하기 위한 Eth을 입금했을 때 발생하는 이벤트
746      * @param beneficiary APIS를 구매하고자 하는 지갑의 주소
747      * @param amountOfFunds 입금한 Eth의 양 (wei)
748      * @param amountOfApis 투자금에 상응하는 APIS 토큰의 양 (wei)
749      */
750     event ReservedApis(address beneficiary, uint256 amountOfFunds, uint256 amountOfApis);
751     
752     /**
753      * @dev 크라우드 세일 컨트렉트에서 Eth이 인출되었을 때 발생하는 이벤트
754      * @param addr 받는 지갑의 주소
755      * @param amount 송금되는 양(wei)
756      */
757     event WithdrawalFunds(address addr, uint256 amount);
758     
759     /**
760      * @dev 구매자에게 토큰이 발급되었을 때 발생하는 이벤트
761      * @param funder 토큰을 받는 지갑의 주소
762      * @param amountOfFunds 입금한 투자금의 양 (wei)
763      * @param amountOfApis 발급 받는 토큰의 양 (wei)
764      */
765     event WithdrawalApis(address funder, uint256 amountOfFunds, uint256 amountOfApis);
766     
767     
768     /**
769      * @dev 투자금 입금 후, 아직 토큰을 발급받지 않은 상태에서, 환불 처리를 했을 때 발생하는 이벤트
770      * @param _backer 환불 처리를 진행하는 지갑의 주소
771      * @param _amountFunds 환불하는 투자금의 양
772      * @param _amountApis 취소되는 APIS 양
773      */
774     event Refund(address _backer, uint256 _amountFunds, uint256 _amountApis);
775     
776     
777     /**
778      * @dev 크라우드 세일 진행 중에만 동작하도록 제한하고, APIS의 가격도 설정되어야만 한다.
779      */
780     modifier onSale() {
781         require(now >= startTime);
782         require(now < endTime);
783         require(closed == false);
784         require(priceOfApisPerFund > 0);
785         require(fundingGoalCurrent > 0);
786         _;
787     }
788     
789     /**
790      * @dev 크라우드 세일 종료 후에만 동작하도록 제한
791      */
792     modifier onFinished() {
793         require(now >= endTime || closed == true);
794         _;
795     }
796     
797     /**
798      * @dev 화이트리스트에 등록되어있어야하고 아직 구매완료 되지 않은 투자금이 있어야만 한다.
799      */
800     modifier claimable() {
801         require(whiteList.isInWhiteList(msg.sender) == true);
802         require(fundersProperty[msg.sender].reservedFunds > 0);
803         _;
804     }
805     
806     
807     /**
808      * @dev 크라우드 세일 컨트렉트를 생성한다.
809      * @param _fundingGoalApis 판매하는 토큰의 양 (APIS 단위)
810      * @param _startTime 크라우드 세일을 시작하는 시간
811      * @param _endTime 크라우드 세일을 종료하는 시간
812      * @param _addressOfApisTokenUsedAsReward APIS 토큰의 컨트렉트 주소
813      * @param _addressOfWhiteList WhiteList 컨트렉트 주소
814      */
815     function ApisCrowdSale (
816         uint256 _fundingGoalApis,
817         uint _startTime,
818         uint _endTime,
819         address _addressOfApisTokenUsedAsReward,
820         address _addressOfWhiteList
821     ) public {
822         require (_fundingGoalApis > 0);
823         require (_startTime > now);
824         require (_endTime > _startTime);
825         require (_addressOfApisTokenUsedAsReward != 0x0);
826         require (_addressOfWhiteList != 0x0);
827         
828         fundingGoal = _fundingGoalApis * 10 ** uint256(decimals);
829         
830         startTime = _startTime;
831         endTime = _endTime;
832         
833         // 토큰 스마트컨트렉트를 불러온다
834         tokenReward = ApisToken(_addressOfApisTokenUsedAsReward);
835         
836         // 화이트 리스트를 가져온다
837         whiteList = WhiteList(_addressOfWhiteList);
838     }
839     
840     /**
841      * @dev 판매 종료는 1회만 가능하도록 제약한다. 종료 후 다시 판매 중으로 변경할 수 없다
842      */
843     function closeSale(bool _closed) onlyOwner public {
844         require (closed == false);
845         
846         closed = _closed;
847     }
848     
849     /**
850      * @dev 크라우드 세일 시작 전에 1Eth에 해당하는 APIS 량을 설정한다.
851      */
852     function setPriceOfApis(uint256 price) onlyOwner public {
853         require(priceOfApisPerFund == 0);
854         
855         priceOfApisPerFund = price;
856     }
857     
858     /**
859      * @dev 현 시점에서 판매 가능한 목표량을 수정한다.
860      * @param _currentFundingGoalAPIS 현 시점의 판매 목표량은 총 판매된 양 이상이어야만 한다.
861      */
862     function setCurrentFundingGoal(uint256 _currentFundingGoalAPIS) onlyOwner public {
863         uint256 fundingGoalCurrentWei = _currentFundingGoalAPIS * 10 ** uint256(decimals);
864         require(fundingGoalCurrentWei >= saleStatus.totalSoldApis);
865         
866         fundingGoalCurrent = fundingGoalCurrentWei;
867     }
868     
869     
870     /**
871      * @dev APIS 잔고를 확인한다
872      * @param _addr 잔고를 확인하려는 지갑의 주소
873      * @return balance 지갑에 들은 APIS 잔고 (wei)
874      */
875     function balanceOf(address _addr) public view returns (uint256 balance) {
876         return tokenReward.balanceOf(_addr);
877     }
878     
879     /**
880      * @dev 화이트리스트 등록 여부를 확인한다
881      * @param _addr 등록 여부를 확인하려는 주소
882      * @return addrIsInWhiteList true : 등록되있음, false : 등록되어있지 않음
883      */
884     function whiteListOf(address _addr) public view returns (string message) {
885         if(whiteList.isInWhiteList(_addr) == true) {
886             return "The address is in whitelist.";
887         } else {
888             return "The address is *NOT* in whitelist.";
889         }
890     }
891     
892     
893     /**
894      * @dev 전달받은 지갑이 APIS 지급 요청이 가능한지 확인한다.
895      * @param _addr 확인하는 주소
896      * @return message 결과 메시지
897      */
898     function isClaimable(address _addr) public view returns (string message) {
899         if(fundersProperty[_addr].reservedFunds == 0) {
900             return "The address has no claimable balance.";
901         }
902         
903         if(whiteList.isInWhiteList(_addr) == false) {
904             return "The address must be registered with KYC and Whitelist";
905         }
906         
907         else {
908             return "The address can claim APIS!";
909         }
910     }
911     
912     
913     /**
914      * @dev 크라우드 세일 컨트렉트로 바로 투자금을 송금하는 경우, buyToken으로 연결한다
915      */
916     function () onSale public payable {
917         buyToken(msg.sender);
918     }
919     
920     /**
921      * @dev 토큰을 구입하기 위해 Qtum을 입금받는다.
922      * @param _beneficiary 토큰을 받게 될 지갑의 주소
923      */
924     function buyToken(address _beneficiary) onSale public payable {
925         // 주소 확인
926         require(_beneficiary != 0x0);
927         
928         // 크라우드 세일 컨트렉트의 토큰 송금 기능이 정지되어있으면 판매하지 않는다
929         bool isLocked = false;
930         uint timeLock = 0;
931         (isLocked, timeLock) = tokenReward.isWalletLocked_Send(this);
932         
933         require(isLocked == false);
934         
935         
936         uint256 amountFunds = msg.value;
937         uint256 reservedApis = amountFunds * priceOfApisPerFund;
938         
939         
940         // 목표 금액을 넘어서지 못하도록 한다
941         require(saleStatus.totalSoldApis + reservedApis <= fundingGoalCurrent);
942         require(saleStatus.totalSoldApis + reservedApis <= fundingGoal);
943         
944         // 투자자의 자산을 업데이트한다
945         fundersProperty[_beneficiary].reservedFunds += amountFunds;
946         fundersProperty[_beneficiary].reservedApis += reservedApis;
947         fundersProperty[_beneficiary].purchaseTime = now;
948         
949         // 총액들을 업데이트한다
950         saleStatus.totalReceivedFunds += amountFunds;
951         saleStatus.totalReservedFunds += amountFunds;
952         
953         saleStatus.totalSoldApis += reservedApis;
954         saleStatus.totalReservedApis += reservedApis;
955         
956         
957         // 화이트리스트에 등록되어있으면 바로 출금한다
958         if(whiteList.isInWhiteList(_beneficiary) == true) {
959             withdrawal(_beneficiary);
960         }
961         else {
962             // 토큰 발행 예약 이벤트 발생
963             ReservedApis(_beneficiary, amountFunds, reservedApis);
964         }
965     }
966     
967     
968     
969     /**
970      * @dev 관리자에 의해서 토큰을 발급한다. 하지만 기본 요건은 갖춰야만 가능하다
971      * 
972      * @param _target 토큰 발급을 청구하려는 지갑 주소
973      */
974     function claimApis(address _target) public {
975         // 화이트 리스트에 있어야만 하고
976         require(whiteList.isInWhiteList(_target) == true);
977         // 예약된 투자금이 있어야만 한다.
978         require(fundersProperty[_target].reservedFunds > 0);
979         
980         withdrawal(_target);
981     }
982     
983     /**
984      * @dev 예약한 토큰의 실제 지급을 요청하도록 한다.
985      * 
986      * APIS를 구매하기 위해 Qtum을 입금할 경우, 관리자의 검토를 위한 7일의 유예기간이 존재한다.
987      * 유예기간이 지나면 토큰 지급을 요구할 수 있다.
988      */
989     function claimMyApis() claimable public {
990         withdrawal(msg.sender);
991     }
992     
993     
994     /**
995      * @dev 구매자에게 토큰을 지급한다.
996      * @param funder 토큰을 지급할 지갑의 주소
997      */
998     function withdrawal(address funder) internal {
999         // 구매자 지갑으로 토큰을 전달한다
1000         assert(tokenReward.transferFrom(owner, funder, fundersProperty[funder].reservedApis));
1001         
1002         fundersProperty[funder].withdrawedApis += fundersProperty[funder].reservedApis;
1003         fundersProperty[funder].paidFunds += fundersProperty[funder].reservedFunds;
1004         
1005         // 총액에 반영
1006         saleStatus.totalReservedFunds -= fundersProperty[funder].reservedFunds;
1007         saleStatus.totalPaidFunds += fundersProperty[funder].reservedFunds;
1008         
1009         saleStatus.totalReservedApis -= fundersProperty[funder].reservedApis;
1010         saleStatus.totalWithdrawedApis += fundersProperty[funder].reservedApis;
1011         
1012         // APIS가 출금 되었음을 알리는 이벤트
1013         WithdrawalApis(funder, fundersProperty[funder].reservedFunds, fundersProperty[funder].reservedApis);
1014         
1015         // 인출하지 않은 APIS 잔고를 0으로 변경해서, Qtum 재입금 시 이미 출금한 토큰이 다시 출금되지 않게 한다.
1016         fundersProperty[funder].reservedFunds = 0;
1017         fundersProperty[funder].reservedApis = 0;
1018     }
1019     
1020     
1021     /**
1022      * @dev 아직 토큰을 발급받지 않은 지갑을 대상으로, 환불을 진행할 수 있다.
1023      * @param _funder 환불을 진행하려는 지갑의 주소
1024      */
1025     function refundByOwner(address _funder) onlyOwner public {
1026         require(fundersProperty[_funder].reservedFunds > 0);
1027         
1028         uint256 amountFunds = fundersProperty[_funder].reservedFunds;
1029         uint256 amountApis = fundersProperty[_funder].reservedApis;
1030         
1031         // Eth을 환불한다
1032         _funder.transfer(amountFunds);
1033         
1034         saleStatus.totalReceivedFunds -= amountFunds;
1035         saleStatus.totalReservedFunds -= amountFunds;
1036         
1037         saleStatus.totalSoldApis -= amountApis;
1038         saleStatus.totalReservedApis -= amountApis;
1039         
1040         fundersProperty[_funder].reservedFunds = 0;
1041         fundersProperty[_funder].reservedApis = 0;
1042         
1043         Refund(_funder, amountFunds, amountApis);
1044     }
1045     
1046     
1047     /**
1048      * @dev 펀딩이 종료된 이후면, 적립된 투자금을 반환한다.
1049      * @param remainRefundable true : 환불할 수 있는 금액은 남기고 반환한다. false : 모두 반환한다
1050      */
1051     function withdrawalFunds(bool remainRefundable) onlyOwner public {
1052         require(now > endTime || closed == true);
1053         
1054         uint256 amount = 0;
1055         if(remainRefundable) {
1056             amount = this.balance - saleStatus.totalReservedFunds;
1057         } else {
1058             amount = this.balance;
1059         }
1060         
1061         if(amount > 0) {
1062             msg.sender.transfer(amount);
1063             
1064             WithdrawalFunds(msg.sender, amount);
1065         }
1066     }
1067     
1068     /**
1069 	 * @dev 크라우드 세일이 진행 중인지 여부를 반환한다.
1070 	 * @return isOpened true: 진행 중 false : 진행 중이 아님(참여 불가)
1071 	 */
1072     function isOpened() public view returns (bool isOpend) {
1073         if(now < startTime) return false;
1074         if(now >= endTime) return false;
1075         if(closed == true) return false;
1076         
1077         return true;
1078     }
1079 }