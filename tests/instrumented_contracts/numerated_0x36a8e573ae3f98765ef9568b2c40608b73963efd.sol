1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-25
3 */
4 
5 /*
6  * 컨트랙트 개요
7  * 1. 목적
8  *  메인넷 운영이 시작되기 전까지 한시적인 운영을 목적으로 하고 있다.
9  *  메인넷이 운영되면 컨트랙트의 거래는 모두 중단되며, 메인넷 코인트로 전환을 시작하며,
10  *  전환 절차를 간단하게 수행할 수 있으며, 블록체인 내 기록을 통해 신뢰도를 얻을 수 있도록 설계 되었다.
11  * 2. 용어 설명
12  *  Owner : 컨트랙트를 생성한 컨트랙트의 주인
13  *  Delegator : Owner의 Private Key를 매번 사용하기에는 보안적인 이슈가 발생할 수 있기 때문에 도입된
14  *              일부 Owner 권한을 실행할 수 있도록 임명한 대행자
15  *              특히, 컨트랙트의 거래가 중단된 상태에서 Delegator만 실행할 수 있는 전용 함수를 실행하여
16  *              컨트랙트의 토큰을 회수하고, 메인넷의 코인으로 전환해주는 핵심적인 기능을 수행
17  *  Holder : 토큰을 보유할 수 있는 Address를 가지고 있는 계정
18  * 3. 운용
19  *  3.1. TokenContainer Structure
20  *   3.1.1 Charge Amount
21  *    Charge Amount는 Holder가 구매하여 충전한 토큰량입니다.
22  *    Owner의 경우에는 컨트랙트 전체에 충전된 토큰량. 즉, Total Supply와 같습니다.
23  *   3.1.2 Unlock Amount
24  *    기본적으로 모든 토큰은 Lock 상태인 것이 기본 상태이며, Owner 또는 Delegator가 Unlock 해준 만큼 Balance로 전환됩니다.
25  *    Unlock Amount는 Charge Amount 중 Unlock 된 만큼만 표시합니다.
26  *    Unlock Amount는 Charge Amount 보다 커질 수 없습니다.
27  *   3.1.3 Balance
28  *    ERC20의 Balance와 같으며, 기본적으로는 Charge Amount - Unlock Amount 값에서 부터 시작합니다.
29  *    자유롭게 거래가 가능하므로 Balance는 더 크거나 작아질 수 있습니다.
30  * 4. 토큰 -> 코인 전환 절차
31  *  4.1. Owner 권한으로 컨트랙트의 거래를 완전히 중단 시킴(lock())
32  *  4.2. 교환을 실행하기 위한 ExchangeContract를 생성
33  *  4.3. ExchangeContract의 Address를 Owner의 권한으로 Delegator로 지정
34  *  4.4. Holder가 ExchangeContract의 exchangeSYM()을 실행하여 잔액을 ExchangeHolder에게 모두 전달
35  *  4.5. ExchangeHolder로의 입금을 확인
36  *  4.6. 요청에 대응되는 메인넷의 계정으로 해당되는 양만큼 송금
37  *  4.7. ExchangeContract의 withdraw()를 사용하여 Owner가 최종적으로 회수하는 것으로 전환절차 완료
38  */
39  /*
40   *  * Contract Overview 
41  * 1. Purpose
42  *  It is intended to operate for a limited time until mainnet launch.
43  *  When the mainnet is launched, all transactions of the contract will be suspended from that day on forward and will initiate the token swap to the mainnet.
44  * 2. Key Definitions
45  *  Owner : An entity from which smart contract is created
46  *  Delegator : The appointed agent is created to prevent from using the contract owner's private key for every transaction made, since it can cause a serious security issue.  
47  *              In particular, it performs core functons at the time of the token swap event, such as executing a dedicated, Delegator-specific function while contract transaction is under suspension and
48  *              withdraw contract's tokens. 
49  *  Holder : An account in which tokens can be stored (also referrs to all users of the contract: Owner, Delegator, Spender, ICO buyers, ect.)
50  * 3. Operation
51  *  3.1. TokenContainer Structure
52  *   3.1.1 Charge Amount
53  *    Charge Amount is the charged token amount purcahsed by Holder.
54  *    In case for the Owner, the total charged amount in the contract equates to the Total Supply.
55  *   3.1.2 Unlock Amount
56  *    Generally, all tokens are under a locked state by default and balance appears according to the amount that Owner or Delegator Unlocks.
57  *    Unlock Amount only displays tokens that are unlocked from the Charge Amount.
58  *    Unlock Amount cannot be greater than the Charge Amount.
59  *   3.1.3 Balance
60  *     Similiar to the ERC20 Balance; It starts from Charged Amount - Unlock Amount value.
61  *     You can send & receive tokens at will and it will offset the Balance amount accordingly.
62  * 4. Token Swap Process
63  *  4.1. Completely suspend trading operations from the contract address with owner privileges (lock ()).
64  *  4.2. Create an ExchangeContract contract to execute the exchange.
65  *  4.3. Owner appoints the ExchangeContract address to the Delegator.
66  *  4.4. The Holder executes an exchangeSYM() embedded in the ExchangeContract to transfer all the Balance to ExchangeHolder
67  *  4.5. Verify ExchangeHolder's deposit amount. 
68  *  4.6. Remit an appropriate amount into the mainnet account that corresponds to the request.  
69  *  4.7. By using the ExchangeContract's withdraw(), the token swap process completes as the Owner makes the final withdrawal.
70   */
71 
72 library SafeMath {
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b);
80 
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Solidity only automatically asserts when dividing by 0
86         require(b > 0);
87         uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90         return c;
91     }
92 
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b <= a);
95         uint256 c = a - b;
96 
97         return c;
98     }
99 
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a);
103 
104         return c;
105     }
106 
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b != 0);
109         return a % b;
110     }
111 }
112 
113 interface IERC20 {
114     function transfer(address to, uint256 value) external returns (bool);
115     function approve(address spender, uint256 value) external returns (bool);
116     function transferFrom(address from, address to, uint256 value) external returns (bool);
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address who) external view returns (uint256);
119     function allowance(address owner, address spender) external view returns (uint256);
120     event Transfer(address indexed from, address indexed to, uint256 value);
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 contract Ownable {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     constructor () internal {
130         _owner = msg.sender;
131         emit OwnershipTransferred(address(0), _owner);
132     }
133 
134     function owner() public view returns (address) {
135         return _owner;
136     }
137 
138     modifier onlyOwner() {
139         require(isOwner());
140         _;
141     }
142 
143     function isOwner() public view returns (bool) {
144         return msg.sender == _owner;
145     }
146 
147     /*
148      * 운용상 Owner 변경은 사용하지 않으므로 권한 변경 함수 제거하였다.
149      */
150     /*
151      * The privilege change function is removed since the Owner change isn't used during the operation.
152      */
153     /* not used
154     function renounceOwnership() public onlyOwner {
155         emit OwnershipTransferred(_owner, address(0));
156         _owner = address(0);
157     }
158 
159     function transferOwnership(address newOwner) public onlyOwner {
160         _transferOwnership(newOwner);
161     }
162 
163     function _transferOwnership(address newOwner) internal {
164         require(newOwner != address(0));
165         emit OwnershipTransferred(_owner, newOwner);
166         _owner = newOwner;
167     }
168     */
169 }
170 
171 /*
172  * Owner의 권한 중 일부를 대신 행사할 수 있도록 대행자를 지정/해제 할 수 있는 인터페이스를 정의하고 있다.
173  */
174  /*
175  * It defines an interface where the Owner can appoint / dismiss an agent that can partially excercize privileges in lieu of the Owner's 
176  */
177 contract Delegable is Ownable {
178     address private _delegator;
179     
180     event DelegateAppointed(address indexed previousDelegator, address indexed newDelegator);
181     
182     constructor () internal {
183         _delegator = address(0);
184     }
185     
186     /*
187      * delegator를 가져옴
188      */
189     /*
190      * Call-up Delegator
191      */
192     function delegator() public view returns (address) {
193         return _delegator;
194     }
195     
196     /*
197      * delegator만 실행 가능하도록 지정하는 접근 제한
198      */
199     /*
200      * Access restriction in which only appointed delegator is executable
201      */
202     modifier onlyDelegator() {
203         require(isDelegator());
204         _;
205     }
206     
207     /*
208      * owner 또는 delegator가 실행 가능하도록 지정하는 접근 제한
209      */
210     /*
211      * Access restriction in which only appointed delegator or Owner are executable
212      */
213     modifier ownerOrDelegator() {
214         require(isOwner() || isDelegator());
215         _;
216     }
217     
218     function isDelegator() public view returns (bool) {
219         return msg.sender == _delegator;
220     }
221     
222     /*
223      * delegator를 임명
224      */
225     /*
226      * Appoint the delegator
227      */
228     function appointDelegator(address delegator) public onlyOwner returns (bool) {
229         require(delegator != address(0));
230         require(delegator != owner());
231         return _appointDelegator(delegator);
232     }
233     
234     /*
235      * 지정된 delegator를 해임
236      */
237     /*
238      * Dimiss the appointed delegator
239      */
240     function dissmissDelegator() public onlyOwner returns (bool) {
241         require(_delegator != address(0));
242         return _appointDelegator(address(0));
243     }
244     
245     /*
246      * delegator를 변경하는 내부 함수
247      */
248     /*
249      * An internal function that allows delegator changes 
250      */
251     function _appointDelegator(address delegator) private returns (bool) {
252         require(_delegator != delegator);
253         emit DelegateAppointed(_delegator, delegator);
254         _delegator = delegator;
255         return true;
256     }
257 }
258 
259 /*
260  * ERC20의 기본 인터페이스는 유지하여 일반적인 토큰 전송이 가능하면서,
261  * 일부 추가 관리 기능을 구현하기 위한 Struct 및 함수가 추가되어 있습니다.
262  * 특히, 토큰 -> 코인 교환을 위한 Delegator 임명은 Owner가 직접 수행할 컨트랙트의 주소를 임명하기 때문에
263  * 외부에서 임의로 권한을 획득하기 매우 어려운 구조를 가집니다.
264  * 또한, exchange() 함수의 실행은 ExchangeContract에서 Holder가 직접 exchangeSYM() 함수를
265  * 실행한 것이 트리거가 되기 때문에 임의의 사용자가 다른 사람의 토큰을 탈취할 수 없습니다.
266  */
267  /*
268  * The basic interface of ERC20 is remained untouched therefore basic functions like token transactions will be available. 
269  * On top of that, Structs and functions have been added to implement some additional management functions.
270  * In particular, we created an additional Delegator agent to initiate the token swap so that the swap is performed by the delegator but directly from the Owner's contract address.
271  * By implementing an additional agent, it has built a difficult structure to acquire rights arbitrarily from the outside.
272  * In addition, the execution of exchange() cannot be taken by any other Holders' because the exchangeSYM() is triggered directly by the Holder's execution 
273  */
274 contract ERC20Like is IERC20, Delegable {
275     using SafeMath for uint256;
276 
277     uint256 internal _totalSupply;  // 총 발행량 // Total Supply
278     bool isLock = false;  // 계약 잠금 플래그 // Contract Lock Flag
279 
280     /*
281      * 토큰 정보(충전량, 해금량, 가용잔액) 및 Spender 정보를 저장하는 구조체
282      */
283     /*
284      * Structure that stores token information (charge, unlock, balance) as well as Spender information
285      */
286     struct TokenContainer {
287         uint256 chargeAmount; // 충전량 // charge amount
288         uint256 unlockAmount; // 해금량 // unlock amount
289         uint256 balance;  // 가용잔액 // available balance
290         mapping (address => uint256) allowed; // Spender
291     }
292 
293     mapping (address => TokenContainer) internal _tokenContainers;
294     
295     event ChangeCirculation(uint256 circulationAmount);
296     event Charge(address indexed holder, uint256 chargeAmount, uint256 unlockAmount);
297     event IncreaseUnlockAmount(address indexed holder, uint256 unlockAmount);
298     event DecreaseUnlockAmount(address indexed holder, uint256 unlockAmount);
299     event Exchange(address indexed holder, address indexed exchangeHolder, uint256 amount);
300     event Withdraw(address indexed holder, uint256 amount);
301 
302     // 총 발행량 
303     // Total token supply 
304     function totalSupply() public view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     // 가용잔액 가져오기
309     // Call-up available balance
310     function balanceOf(address holder) public view returns (uint256) {
311         return _tokenContainers[holder].balance;
312     }
313 
314     // Spender의 남은 잔액 가져오기
315     // Call-up Spender's remaining balance
316     function allowance(address holder, address spender) public view returns (uint256) {
317         return _tokenContainers[holder].allowed[spender];
318     }
319 
320     // 토큰송금
321     // Transfer token
322     function transfer(address to, uint256 value) public returns (bool) {
323         _transfer(msg.sender, to, value);
324         return true;
325     }
326 
327     // Spender 지정 및 금액 지정
328     // Appoint a Spender and set an amount 
329     function approve(address spender, uint256 value) public returns (bool) {
330         _approve(msg.sender, spender, value);
331         return true;
332     }
333 
334     // Spender 토큰송금
335     // Transfer token via Spender 
336     function transferFrom(address from, address to, uint256 value) public returns (bool) {
337         _transfer(from, to, value);
338         _approve(from, msg.sender, _tokenContainers[from].allowed[msg.sender].sub(value));
339         return true;
340     }
341 
342     // Spender가 할당 받은 양 증가
343     // Increase a Spender amount alloted by the Owner/Delegator
344     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
345         require(!isLock);
346         uint256 value = _tokenContainers[msg.sender].allowed[spender].add(addedValue);
347         if (msg.sender == owner()) {  // Sender가 계약 소유자인 경우 전체 발행량 조절
348             require(_tokenContainers[msg.sender].chargeAmount >= _tokenContainers[msg.sender].unlockAmount.add(addedValue));
349             _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.add(addedValue);
350             _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.add(addedValue);
351         }
352         _approve(msg.sender, spender, value);
353         return true;
354     }
355 
356     // Spender가 할당 받은 양 감소
357     // Decrease a Spender amount alloted by the Owner/Delegator
358     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
359         require(!isLock);
360         // 기존에 할당된 금액의 잔액보다 더 많은 금액을 줄이려고 하는 경우 할당액이 0이 되도록 처리
361         //// If you reduce more than the alloted amount in the balance, we made sure the alloted amount is set to zero instead of minus
362         if (_tokenContainers[msg.sender].allowed[spender] < subtractedValue) {
363             subtractedValue = _tokenContainers[msg.sender].allowed[spender];
364         }
365         
366         uint256 value = _tokenContainers[msg.sender].allowed[spender].sub(subtractedValue);
367         if (msg.sender == owner()) {  // Sender가 계약 소유자인 경우 전체 발행량 조절 // // Adjust the total circulation amount if the Sender equals the contract owner
368             _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.sub(subtractedValue);
369             _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.sub(subtractedValue);
370         }
371         _approve(msg.sender, spender, value);
372         return true;
373     }
374 
375     // 토큰송금 내부 실행 함수 
376     // An internal execution function for troken transfer
377     function _transfer(address from, address to, uint256 value) private {
378         require(!isLock);
379         // 3.1. Known vulnerabilities of ERC-20 token
380         // 현재 컨트랙트로는 송금할 수 없도록 예외 처리 // Exceptions were added to not allow deposits to be made in the current contract . 
381         require(to != address(this));
382         require(to != address(0));
383 
384         _tokenContainers[from].balance = _tokenContainers[from].balance.sub(value);
385         _tokenContainers[to].balance = _tokenContainers[to].balance.add(value);
386         emit Transfer(from, to, value);
387     }
388 
389     // Spender 지정 내부 실행 함수
390     // Internal execution function for assigning a Spender
391     function _approve(address holder, address spender, uint256 value) private {
392         require(!isLock);
393         require(spender != address(0));
394         require(holder != address(0));
395 
396         _tokenContainers[holder].allowed[spender] = value;
397         emit Approval(holder, spender, value);
398     }
399 
400     /* extension */
401     /**
402      * 충전량 
403      */
404     /**
405      * Charge Amount 
406      */
407     function chargeAmountOf(address holder) external view returns (uint256) {
408         return _tokenContainers[holder].chargeAmount;
409     }
410 
411     /**
412      * 해금량
413      */
414     /**
415      * Unlock Amount
416      */
417     function unlockAmountOf(address holder) external view returns (uint256) {
418         return _tokenContainers[holder].unlockAmount;
419     }
420 
421     /**
422      * 가용잔액
423      */
424     /**
425      * Available amount in the balance
426      */
427     function availableBalanceOf(address holder) external view returns (uint256) {
428         return _tokenContainers[holder].balance;
429     }
430 
431     /**
432      * Holder의 계정 잔액 요약 출력(JSON 포맷)
433      */
434     /**
435      * An output of Holder's account balance summary (JSON format)
436      */
437     function receiptAccountOf(address holder) external view returns (string memory) {
438         bytes memory blockStart = bytes("{");
439         bytes memory chargeLabel = bytes("\"chargeAmount\" : \"");
440         bytes memory charge = bytes(uint2str(_tokenContainers[holder].chargeAmount));
441         bytes memory unlockLabel = bytes("\", \"unlockAmount\" : \"");
442         bytes memory unlock = bytes(uint2str(_tokenContainers[holder].unlockAmount));
443         bytes memory balanceLabel = bytes("\", \"availableBalance\" : \"");
444         bytes memory balance = bytes(uint2str(_tokenContainers[holder].balance));
445         bytes memory blockEnd = bytes("\"}");
446 
447         string memory receipt = new string(blockStart.length + chargeLabel.length + charge.length + unlockLabel.length + unlock.length + balanceLabel.length + balance.length + blockEnd.length);
448         bytes memory receiptBytes = bytes(receipt);
449 
450         uint readIndex = 0;
451         uint writeIndex = 0;
452 
453         for (readIndex = 0; readIndex < blockStart.length; readIndex++) {
454             receiptBytes[writeIndex++] = blockStart[readIndex];
455         }
456         for (readIndex = 0; readIndex < chargeLabel.length; readIndex++) {
457             receiptBytes[writeIndex++] = chargeLabel[readIndex];
458         }
459         for (readIndex = 0; readIndex < charge.length; readIndex++) {
460             receiptBytes[writeIndex++] = charge[readIndex];
461         }
462         for (readIndex = 0; readIndex < unlockLabel.length; readIndex++) {
463             receiptBytes[writeIndex++] = unlockLabel[readIndex];
464         }
465         for (readIndex = 0; readIndex < unlock.length; readIndex++) {
466             receiptBytes[writeIndex++] = unlock[readIndex];
467         }
468         for (readIndex = 0; readIndex < balanceLabel.length; readIndex++) {
469             receiptBytes[writeIndex++] = balanceLabel[readIndex];
470         }
471         for (readIndex = 0; readIndex < balance.length; readIndex++) {
472             receiptBytes[writeIndex++] = balance[readIndex];
473         }
474         for (readIndex = 0; readIndex < blockEnd.length; readIndex++) {
475             receiptBytes[writeIndex++] = blockEnd[readIndex];
476         }
477 
478         return string(receiptBytes);
479     }
480 
481     // uint 값을 string 으로 변환하는 내부 함수
482     // An internal function that converts an uint value to a string
483     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
484         if (_i == 0) {
485             return "0";
486         }
487         uint j = _i;
488         uint len;
489         while (j != 0) {
490             len++;
491             j /= 10;
492         }
493         bytes memory bstr = new bytes(len);
494         uint k = len - 1;
495         while (_i != 0) {
496             bstr[k--] = byte(uint8(48 + _i % 10));
497             _i /= 10;
498         }
499         return string(bstr);
500     }
501 
502     // 전체 유통량 - Owner의 unlockAmount
503     // Total circulation supply, or the unlockAmount of the Owner's
504     function circulationAmount() external view returns (uint256) {
505         return _tokenContainers[owner()].unlockAmount;
506     }
507 
508     // 전체 유통량 증가
509     // Increase the token's total circulation supply 
510     /*
511      * 컨트랙트 상에 유통되는 토큰량을 증가 시킵니다.
512      * Owner가 보유한 전체 토큰량에서 Unlock 된 양 만큼이 현재 유통량이므로,
513      * Unlock Amount와 Balance 가 증가하며, Charge Amount는 변동되지 않습니다.
514      */
515     /*
516      * This function increases the amount of circulated tokens that are distributed on the contract.
517      * The circulated token is referring to the Unlock tokens out of the contract Owner's total supply, so the Charge Amount is not affected (refer back to the Balance definition above).
518      * This function increases in the Unlock Amount as well as in the Balance.
519      */
520     function increaseCirculation(uint256 amount) external onlyOwner returns (uint256) {
521         require(!isLock);
522         require(_tokenContainers[msg.sender].chargeAmount >= _tokenContainers[msg.sender].unlockAmount.add(amount));
523         _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.add(amount);
524         _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.add(amount);
525         emit ChangeCirculation(_tokenContainers[msg.sender].unlockAmount);
526         return _tokenContainers[msg.sender].unlockAmount;
527     }
528 
529     // 전체 유통량 감소
530     // Reduction of the token's total supply
531     /*
532      * 컨트랙트 상에 유통되는 토큰량을 감소 시킵니다.
533      * Owner가 보유한 전체 토큰량에서 Unlock 된 양 만큼이 현재 유통량이므로,
534      * Unlock Amount와 Balance 가 감소하며, Charge Amount는 변동되지 않습니다.
535      * Owner만 실행할 수 있으며, 정책적인 계획에 맞추어 실행되어야하므로 0보다 작아지는 값이 입력되는 경우 실행을 중단합니다.
536      */
537     /*
538      * This function decreases the amount of circulated tokens that are distributed on the contract.
539      * The circulated token is referring to the Unlock tokens out of the contract Owner's total supply, so the Charge Amount is not affected (refer back to the Balance definition above).
540      * This function decreases in the Unlock Amount as well as in the Balance.
541      */
542     function decreaseCirculation(uint256 amount) external onlyOwner returns (uint256) {
543         require(!isLock);
544         _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.sub(amount);
545         _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.sub(amount);
546         emit ChangeCirculation(_tokenContainers[msg.sender].unlockAmount);
547         return _tokenContainers[msg.sender].unlockAmount;
548     }
549 
550     /*
551      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 만큼의 충전량을 직접 입력할 때 사용합니다.
552      * 컨트랙트 내 토큰의 유통량에 맞추어 동작하므로, Owner의 Balance가 부족하면 실행을 중단힙니다.
553      * 충전한 토큰은 lock인 상태로 시작되며, charge() 함수는 충전과 동시에 Unlock하는 양을 지정하여
554      * increaseUnlockAmount() 함수의 실행 횟수를 줄일 수 있다.
555      */
556     /*
557      * This function is used to directly input the token amount that is purchased by particular Holders (ICO, Pre-sale buyers). It can be performed by the Owner or the Delegator.
558      * Since the contract operates in concurrent to the tokens in circulation, the function will fail to execute when Owner's balance is insuffient. 
559      * All charged tokens are locked amount. 
560      */
561     function charge(address holder, uint256 chargeAmount, uint256 unlockAmount) external ownerOrDelegator {
562         require(!isLock);
563         require(holder != address(0));
564         require(holder != owner());
565         require(chargeAmount > 0);
566         require(chargeAmount >= unlockAmount);
567         require(_tokenContainers[owner()].balance >= chargeAmount);
568 
569         _tokenContainers[owner()].balance = _tokenContainers[owner()].balance.sub(chargeAmount);
570 
571         _tokenContainers[holder].chargeAmount = _tokenContainers[holder].chargeAmount.add(chargeAmount);
572         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.add(unlockAmount);
573         _tokenContainers[holder].balance = _tokenContainers[holder].balance.add(unlockAmount);
574         
575         emit Charge(holder, chargeAmount, unlockAmount);
576     }
577     
578     /*
579      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 안에서 해금량을 변경할 때 사용합니다.
580      * 총 충전량 안에서 변화가 일어나므로 Unlock Amount가 Charge Amount보다 커질 수 없습니다.
581      */
582     /*
583      * This function is used to change the Unlock Amount of tokens that is purchased by particular Holders (ICO, Pre-sale buyers).
584      * Unlock Amount cannot be larger than Charge Amount because changes occur within the total charge amount.
585      */
586     function increaseUnlockAmount(address holder, uint256 unlockAmount) external ownerOrDelegator {
587         require(!isLock);
588         require(holder != address(0));
589         require(holder != owner());
590         require(_tokenContainers[holder].chargeAmount >= _tokenContainers[holder].unlockAmount.add(unlockAmount));
591 
592         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.add(unlockAmount);
593         _tokenContainers[holder].balance = _tokenContainers[holder].balance.add(unlockAmount);
594         
595         emit IncreaseUnlockAmount(holder, unlockAmount);
596     }
597     
598     /*
599      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 안에서 해금량을 변경할 때 사용합니다.
600      * Balance를 Lock 상태로 전환하는 것이므로 Lock Amount의 값은 Balance보다 커질 수 없습니다.
601      */
602     /*
603      * This function is used to change the Unlock Amount of tokens that is purchased by particular Holders (ICO, Pre-sale buyers).
604      * Since the Balance starts from a locked state, the number of locked tokens cannot be greater than the Balance.
605      */
606     function decreaseUnlockAmount(address holder, uint256 lockAmount) external ownerOrDelegator {
607         require(!isLock);
608         require(holder != address(0));
609         require(holder != owner());
610         require(_tokenContainers[holder].balance >= lockAmount);
611 
612         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.sub(lockAmount);
613         _tokenContainers[holder].balance = _tokenContainers[holder].balance.sub(lockAmount);
614         
615         emit DecreaseUnlockAmount(holder, lockAmount);
616     }
617 
618     /*
619      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 안에서 전체를 해금할 때 사용합니다.
620      * Charge Amount 중 Unlock Amount 량을 제외한 나머지 만큼을 일괄적으로 해제합니다.
621      */
622     /*
623      * This function is used to change the Unlock Amount of tokens that is purchased by particular Holders (ICO, Pre-sale buyers).
624      * It unlocks all locked tokens in the Charge Amount, other than tokens already unlocked. 
625      */
626     function unlockAmountAll(address holder) external ownerOrDelegator {
627         require(!isLock);
628         require(holder != address(0));
629         require(holder != owner());
630 
631         uint256 unlockAmount = _tokenContainers[holder].chargeAmount.sub(_tokenContainers[holder].unlockAmount);
632 
633         require(unlockAmount > 0);
634         
635         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.add(unlockAmount);
636         _tokenContainers[holder].balance = _tokenContainers[holder].balance.add(unlockAmount);
637     }
638 
639     /*
640      * 계약 잠금
641      * 계약이 잠기면 컨트랙트의 거래가 중단된 상태가 되며,
642      * 거래가 중단된 상태에서는 Owner와 Delegator를 포함한 모든 Holder는 거래를 할 수 없게 된다.
643      * 모든 거래가 중단된 상태에서 모든 Holder의 상태가 변경되지 않게 만든 후에
644      * 토큰 -> 코인 전환 절차를 진행하기 위함이다.
645      * 단, 이 상태에서는 Exchange Contract를 Owner가 직접 Delegator로 임명하여
646      * Holder의 요청을 처리하도록 하며, 이때는 토큰 -> 코인 교환회수를 위한 exchange(), withdraw() 함수 실행만 허용이 된다.
647      */
648     /*
649      * Contract lock
650      * If the contract is locked, all transactions will be suspended.
651      * All Holders including Owner and Delegator will not be able to make transaction during suspension.
652      * After all transactions have been stopped and all Holders have not changed their status
653      * This function is created primarily for the token swap event. 
654      * In this process, it's important to note that the Owner of the Exchange contract should directly appoint a delegator when handling Holders' requests.
655      * Only the exchange () and withdraw () are allowed to be executed for token swap.
656      */
657     function lock() external onlyOwner returns (bool) {
658         isLock = true;
659         return isLock;
660     }
661 
662     /*
663      * 계약 잠금 해제
664      * 잠긴 계약을 해제할 때 사용된다.
665      */
666     /*
667      * Release contract lock
668      * The function is used to revert a locked contract to a normal state. 
669      */
670     function unlock() external onlyOwner returns (bool) {
671         isLock = false;
672         return isLock;
673     }
674     
675     /*
676      * 토큰 교환 처리용 외부 호출 함수
677      * 계약 전체가 잠긴 상태일 때(교환 처리 중 계약 중단),
678      * 외부에서만 호출 가능하며, Delegator이면서 Contract인 경우에만 호출 가능하다.
679      */
680     /*
681      * It is an external call function for token exchange processing
682      * This function is used when the entire contract is locked (contract lock during the token swap),
683      * It can be called only externally. Also, it can be only called when the agent is both Delegator and Contract.
684      */
685     function exchange(address holder) external onlyDelegator returns (bool) {
686         require(isLock);    // lock state only
687         require((delegator() == msg.sender) && isContract(msg.sender));    // contract delegator only
688         
689         uint256 balance = _tokenContainers[holder].balance;
690         _tokenContainers[holder].balance = 0;
691         _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.add(balance);
692         
693         emit Exchange(holder, msg.sender, balance);
694         return true;
695     }
696     
697     /*
698      * 토큰 교환 처리 후 회수된 토큰을 Owner한테 돌려주는 함수
699      * 계약 전체가 잠긴 상태일 때(교환 처리 중 계약 중단),
700      * 외부에서만 호출 가능하며, Delegator이면서 Contract인 경우에만 호출 가능하다.
701      */
702     /*
703      * This is a function in which the Delegator returns tokens to the Owner after the token swap process
704      * This function is used when the entire contract is locked (contract lock during the token swap),
705      * It can be called only externally. Also, it can be only called when the agent is both Delegator and Contract Owner.
706      */
707     function withdraw() external onlyDelegator returns (bool) {
708         require(isLock);    // lock state only
709         require((delegator() == msg.sender) && isContract(msg.sender));    // contract delegator only
710         
711         uint256 balance = _tokenContainers[msg.sender].balance;
712         _tokenContainers[msg.sender].balance = 0;
713         _tokenContainers[owner()].balance = _tokenContainers[owner()].balance.add(balance);
714         
715         emit Withdraw(msg.sender, balance);
716     }
717     
718     /*
719      * 현재의 주소가 엔진내에 차지하고 있는 코드의 크기를 계산하여 컨트랙트인지 확인하는 도구
720      * 컨트랙트인 경우에만 저장된 코드의 크기가 존재하므로 코드의 크기가 존재한다면
721      * 컨트랙트로 판단할 수있다.
722      */
723     /*
724      * This is a tool used for confirming a contract. It determines the size of code that the current address occupies within the blockchain network.
725      * Since the size of a stored code exists only in the case of a contract, it is can be used as a validation tool.
726      */
727     function isContract(address addr) private returns (bool) {
728       uint size;
729       assembly { size := extcodesize(addr) }
730       return size > 0;
731     }
732 }
733 
734 contract NiX is ERC20Like {
735     string public name = "NiX";
736     string public symbol = "NiX";
737     uint256 public decimals = 18;
738 
739     constructor () public {
740         _totalSupply = 3000000000 * (10 ** decimals);
741         _tokenContainers[msg.sender].chargeAmount = _totalSupply;
742         emit Charge(msg.sender, _tokenContainers[msg.sender].chargeAmount, _tokenContainers[msg.sender].unlockAmount);
743     }
744 }