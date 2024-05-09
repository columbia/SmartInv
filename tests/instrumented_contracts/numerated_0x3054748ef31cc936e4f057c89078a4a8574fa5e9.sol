1 pragma solidity ^0.5.8;
2 
3 /*
4  * 컨트랙트 개요
5  * 1. 목적
6  *  메인넷 운영이 시작되기 전까지 한시적인 운영을 목적으로 하고 있다.
7  *  메인넷이 운영되면 컨트랙트의 거래는 모두 중단되며, 메인넷 코인트로 전환을 시작하며,
8  *  전환 절차를 간단하게 수행할 수 있으며, 블록체인 내 기록을 통해 신뢰도를 얻을 수 있도록 설계 되었다.
9  * 2. 용어 설명
10  *  Owner : 컨트랙트를 생성한 컨트랙트의 주인
11  *  Delegator : Owner의 Private Key를 매번 사용하기에는 보안적인 이슈가 발생할 수 있기 때문에 도입된
12  *              일부 Owner 권한을 실행할 수 있도록 임명한 대행자
13  *              특히, 컨트랙트의 거래가 중단된 상태에서 Delegator만 실행할 수 있는 전용 함수를 실행하여
14  *              컨트랙트의 토큰을 회수하고, 메인넷의 코인으로 전환해주는 핵심적인 기능을 수행
15  *  Holder : 토큰을 보유할 수 있는 Address를 가지고 있는 계정
16  * 3. 운용
17  *  3.1. TokenContainer Structure
18  *   3.1.1 Charge Amount
19  *    Charge Amount는 Holder가 구매하여 충전한 토큰량입니다.
20  *    Owner의 경우에는 컨트랙트 전체에 충전된 토큰량. 즉, Total Supply와 같습니다.
21  *   3.1.2 Unlock Amount
22  *    기본적으로 모든 토큰은 Lock 상태인 것이 기본 상태이며, Owner 또는 Delegator가 Unlock 해준 만큼 Balance로 전환됩니다.
23  *    Unlock Amount는 Charge Amount 중 Unlock 된 만큼만 표시합니다.
24  *    Unlock Amount는 Charge Amount 보다 커질 수 없습니다.
25  *   3.1.3 Balance
26  *    ERC20의 Balance와 같으며, 기본적으로는 Charge Amount - Unlock Amount 값에서 부터 시작합니다.
27  *    자유롭게 거래가 가능하므로 Balance는 더 크거나 작아질 수 있습니다.
28  * 4. 토큰 -> 코인 전환 절차
29  *  4.1. Owner 권한으로 컨트랙트의 거래를 완전히 중단 시킴(lock())
30  *  4.2. 교환을 실행하기 위한 ExchangeContract를 생성
31  *  4.3. ExchangeContract의 Address를 Owner의 권한으로 Delegator로 지정
32  *  4.4. Holder가 ExchangeContract의 exchangeSYM()을 실행하여 잔액을 ExchangeHolder에게 모두 전달
33  *  4.5. ExchangeHolder로의 입금을 확인
34  *  4.6. 요청에 대응되는 메인넷의 계정으로 해당되는 양만큼 송금
35  *  4.7. ExchangeContract의 withdraw()를 사용하여 Owner가 최종적으로 회수하는 것으로 전환절차 완료
36  */
37  /*
38   *  * Contract Overview 
39  * 1. Purpose
40  *  It is intended to operate for a limited time until mainnet launch.
41  *  When the mainnet is launched, all transactions of the contract will be suspended from that day on forward and will initiate the token swap to the mainnet.
42  * 2. Key Definitions
43  *  Owner : An entity from which smart contract is created
44  *  Delegator : The appointed agent is created to prevent from using the contract owner's private key for every transaction made, since it can cause a serious security issue.  
45  *              In particular, it performs core functons at the time of the token swap event, such as executing a dedicated, Delegator-specific function while contract transaction is under suspension and
46  *              withdraw contract's tokens. 
47  *  Holder : An account in which tokens can be stored (also referrs to all users of the contract: Owner, Delegator, Spender, ICO buyers, ect.)
48  * 3. Operation
49  *  3.1. TokenContainer Structure
50  *   3.1.1 Charge Amount
51  *    Charge Amount is the charged token amount purcahsed by Holder.
52  *    In case for the Owner, the total charged amount in the contract equates to the Total Supply.
53  *   3.1.2 Unlock Amount
54  *    Generally, all tokens are under a locked state by default and balance appears according to the amount that Owner or Delegator Unlocks.
55  *    Unlock Amount only displays tokens that are unlocked from the Charge Amount.
56  *    Unlock Amount cannot be greater than the Charge Amount.
57  *   3.1.3 Balance
58  *     Similiar to the ERC20 Balance; It starts from Charged Amount - Unlock Amount value.
59  *     You can send & receive tokens at will and it will offset the Balance amount accordingly.
60  * 4. Token Swap Process
61  *  4.1. Completely suspend trading operations from the contract address with owner privileges (lock ()).
62  *  4.2. Create an ExchangeContract contract to execute the exchange.
63  *  4.3. Owner appoints the ExchangeContract address to the Delegator.
64  *  4.4. The Holder executes an exchangeSYM() embedded in the ExchangeContract to transfer all the Balance to ExchangeHolder
65  *  4.5. Verify ExchangeHolder's deposit amount. 
66  *  4.6. Remit an appropriate amount into the mainnet account that corresponds to the request.  
67  *  4.7. By using the ExchangeContract's withdraw(), the token swap process completes as the Owner makes the final withdrawal.
68   */
69 
70 library SafeMath {
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b);
78 
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Solidity only automatically asserts when dividing by 0
84         require(b > 0);
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90 
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b <= a);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a);
101 
102         return c;
103     }
104 
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0);
107         return a % b;
108     }
109 }
110 
111 interface IERC20 {
112     function transfer(address to, uint256 value) external returns (bool);
113     function approve(address spender, uint256 value) external returns (bool);
114     function transferFrom(address from, address to, uint256 value) external returns (bool);
115     function totalSupply() external view returns (uint256);
116     function balanceOf(address who) external view returns (uint256);
117     function allowance(address owner, address spender) external view returns (uint256);
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 contract Ownable {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     constructor () internal {
128         _owner = msg.sender;
129         emit OwnershipTransferred(address(0), _owner);
130     }
131 
132     function owner() public view returns (address) {
133         return _owner;
134     }
135 
136     modifier onlyOwner() {
137         require(isOwner());
138         _;
139     }
140 
141     function isOwner() public view returns (bool) {
142         return msg.sender == _owner;
143     }
144 
145     /*
146      * 운용상 Owner 변경은 사용하지 않으므로 권한 변경 함수 제거하였다.
147      */
148     /*
149      * The privilege change function is removed since the Owner change isn't used during the operation.
150      */
151     /* not used
152     function renounceOwnership() public onlyOwner {
153         emit OwnershipTransferred(_owner, address(0));
154         _owner = address(0);
155     }
156 
157     function transferOwnership(address newOwner) public onlyOwner {
158         _transferOwnership(newOwner);
159     }
160 
161     function _transferOwnership(address newOwner) internal {
162         require(newOwner != address(0));
163         emit OwnershipTransferred(_owner, newOwner);
164         _owner = newOwner;
165     }
166     */
167 }
168 
169 /*
170  * Owner의 권한 중 일부를 대신 행사할 수 있도록 대행자를 지정/해제 할 수 있는 인터페이스를 정의하고 있다.
171  */
172  /*
173  * It defines an interface where the Owner can appoint / dismiss an agent that can partially excercize privileges in lieu of the Owner's 
174  */
175 contract Delegable is Ownable {
176     address private _delegator;
177     
178     event DelegateAppointed(address indexed previousDelegator, address indexed newDelegator);
179     
180     constructor () internal {
181         _delegator = address(0);
182     }
183     
184     /*
185      * delegator를 가져옴
186      */
187     /*
188      * Call-up Delegator
189      */
190     function delegator() public view returns (address) {
191         return _delegator;
192     }
193     
194     /*
195      * delegator만 실행 가능하도록 지정하는 접근 제한
196      */
197     /*
198      * Access restriction in which only appointed delegator is executable
199      */
200     modifier onlyDelegator() {
201         require(isDelegator());
202         _;
203     }
204     
205     /*
206      * owner 또는 delegator가 실행 가능하도록 지정하는 접근 제한
207      */
208     /*
209      * Access restriction in which only appointed delegator or Owner are executable
210      */
211     modifier ownerOrDelegator() {
212         require(isOwner() || isDelegator());
213         _;
214     }
215     
216     function isDelegator() public view returns (bool) {
217         return msg.sender == _delegator;
218     }
219     
220     /*
221      * delegator를 임명
222      */
223     /*
224      * Appoint the delegator
225      */
226     function appointDelegator(address delegator) public onlyOwner returns (bool) {
227         require(delegator != address(0));
228         require(delegator != owner());
229         return _appointDelegator(delegator);
230     }
231     
232     /*
233      * 지정된 delegator를 해임
234      */
235     /*
236      * Dimiss the appointed delegator
237      */
238     function dissmissDelegator() public onlyOwner returns (bool) {
239         require(_delegator != address(0));
240         return _appointDelegator(address(0));
241     }
242     
243     /*
244      * delegator를 변경하는 내부 함수
245      */
246     /*
247      * An internal function that allows delegator changes 
248      */
249     function _appointDelegator(address delegator) private returns (bool) {
250         require(_delegator != delegator);
251         emit DelegateAppointed(_delegator, delegator);
252         _delegator = delegator;
253         return true;
254     }
255 }
256 
257 /*
258  * ERC20의 기본 인터페이스는 유지하여 일반적인 토큰 전송이 가능하면서,
259  * 일부 추가 관리 기능을 구현하기 위한 Struct 및 함수가 추가되어 있습니다.
260  * 특히, 토큰 -> 코인 교환을 위한 Delegator 임명은 Owner가 직접 수행할 컨트랙트의 주소를 임명하기 때문에
261  * 외부에서 임의로 권한을 획득하기 매우 어려운 구조를 가집니다.
262  * 또한, exchange() 함수의 실행은 ExchangeContract에서 Holder가 직접 exchangeSYM() 함수를
263  * 실행한 것이 트리거가 되기 때문에 임의의 사용자가 다른 사람의 토큰을 탈취할 수 없습니다.
264  */
265  /*
266  * The basic interface of ERC20 is remained untouched therefore basic functions like token transactions will be available. 
267  * On top of that, Structs and functions have been added to implement some additional management functions.
268  * In particular, we created an additional Delegator agent to initiate the token swap so that the swap is performed by the delegator but directly from the Owner's contract address.
269  * By implementing an additional agent, it has built a difficult structure to acquire rights arbitrarily from the outside.
270  * In addition, the execution of exchange() cannot be taken by any other Holders' because the exchangeSYM() is triggered directly by the Holder's execution 
271  */
272 contract ERC20Like is IERC20, Delegable {
273     using SafeMath for uint256;
274 
275     uint256 internal _totalSupply;  // 총 발행량 // Total Supply
276     bool isLock = false;  // 계약 잠금 플래그 // Contract Lock Flag
277 
278     /*
279      * 토큰 정보(충전량, 해금량, 가용잔액) 및 Spender 정보를 저장하는 구조체
280      */
281     /*
282      * Structure that stores token information (charge, unlock, balance) as well as Spender information
283      */
284     struct TokenContainer {
285         uint256 chargeAmount; // 충전량 // charge amount
286         uint256 unlockAmount; // 해금량 // unlock amount
287         uint256 balance;  // 가용잔액 // available balance
288         mapping (address => uint256) allowed; // Spender
289     }
290 
291     mapping (address => TokenContainer) internal _tokenContainers;
292     
293     event ChangeCirculation(uint256 circulationAmount);
294     event Charge(address indexed holder, uint256 chargeAmount, uint256 unlockAmount);
295     event IncreaseUnlockAmount(address indexed holder, uint256 unlockAmount);
296     event DecreaseUnlockAmount(address indexed holder, uint256 unlockAmount);
297     event Exchange(address indexed holder, address indexed exchangeHolder, uint256 amount);
298     event Withdraw(address indexed holder, uint256 amount);
299 
300     // 총 발행량 
301     // Total token supply 
302     function totalSupply() public view returns (uint256) {
303         return _totalSupply;
304     }
305 
306     // 가용잔액 가져오기
307     // Call-up available balance
308     function balanceOf(address holder) public view returns (uint256) {
309         return _tokenContainers[holder].balance;
310     }
311 
312     // Spender의 남은 잔액 가져오기
313     // Call-up Spender's remaining balance
314     function allowance(address holder, address spender) public view returns (uint256) {
315         return _tokenContainers[holder].allowed[spender];
316     }
317 
318     // 토큰송금
319     // Transfer token
320     function transfer(address to, uint256 value) public returns (bool) {
321         _transfer(msg.sender, to, value);
322         return true;
323     }
324 
325     // Spender 지정 및 금액 지정
326     // Appoint a Spender and set an amount 
327     function approve(address spender, uint256 value) public returns (bool) {
328         _approve(msg.sender, spender, value);
329         return true;
330     }
331 
332     // Spender 토큰송금
333     // Transfer token via Spender 
334     function transferFrom(address from, address to, uint256 value) public returns (bool) {
335         _transfer(from, to, value);
336         _approve(from, msg.sender, _tokenContainers[from].allowed[msg.sender].sub(value));
337         return true;
338     }
339 
340     // Spender가 할당 받은 양 증가
341     // Increase a Spender amount alloted by the Owner/Delegator
342     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
343         require(!isLock);
344         uint256 value = _tokenContainers[msg.sender].allowed[spender].add(addedValue);
345         if (msg.sender == owner()) {  // Sender가 계약 소유자인 경우 전체 발행량 조절
346             require(_tokenContainers[msg.sender].chargeAmount >= _tokenContainers[msg.sender].unlockAmount.add(addedValue));
347             _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.add(addedValue);
348             _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.add(addedValue);
349         }
350         _approve(msg.sender, spender, value);
351         return true;
352     }
353 
354     // Spender가 할당 받은 양 감소
355     // Decrease a Spender amount alloted by the Owner/Delegator
356     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
357         require(!isLock);
358         // 기존에 할당된 금액의 잔액보다 더 많은 금액을 줄이려고 하는 경우 할당액이 0이 되도록 처리
359         //// If you reduce more than the alloted amount in the balance, we made sure the alloted amount is set to zero instead of minus
360         if (_tokenContainers[msg.sender].allowed[spender] < subtractedValue) {
361             subtractedValue = _tokenContainers[msg.sender].allowed[spender];
362         }
363         
364         uint256 value = _tokenContainers[msg.sender].allowed[spender].sub(subtractedValue);
365         if (msg.sender == owner()) {  // Sender가 계약 소유자인 경우 전체 발행량 조절 // // Adjust the total circulation amount if the Sender equals the contract owner
366             _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.sub(subtractedValue);
367             _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.sub(subtractedValue);
368         }
369         _approve(msg.sender, spender, value);
370         return true;
371     }
372 
373     // 토큰송금 내부 실행 함수 
374     // An internal execution function for troken transfer
375     function _transfer(address from, address to, uint256 value) private {
376         require(!isLock);
377         // 3.1. Known vulnerabilities of ERC-20 token
378         // 현재 컨트랙트로는 송금할 수 없도록 예외 처리 // Exceptions were added to not allow deposits to be made in the current contract . 
379         require(to != address(this));
380         require(to != address(0));
381 
382         _tokenContainers[from].balance = _tokenContainers[from].balance.sub(value);
383         _tokenContainers[to].balance = _tokenContainers[to].balance.add(value);
384         emit Transfer(from, to, value);
385     }
386 
387     // Spender 지정 내부 실행 함수
388     // Internal execution function for assigning a Spender
389     function _approve(address holder, address spender, uint256 value) private {
390         require(!isLock);
391         require(spender != address(0));
392         require(holder != address(0));
393 
394         _tokenContainers[holder].allowed[spender] = value;
395         emit Approval(holder, spender, value);
396     }
397 
398     /* extension */
399     /**
400      * 충전량 
401      */
402     /**
403      * Charge Amount 
404      */
405     function chargeAmountOf(address holder) external view returns (uint256) {
406         return _tokenContainers[holder].chargeAmount;
407     }
408 
409     /**
410      * 해금량
411      */
412     /**
413      * Unlock Amount
414      */
415     function unlockAmountOf(address holder) external view returns (uint256) {
416         return _tokenContainers[holder].unlockAmount;
417     }
418 
419     /**
420      * 가용잔액
421      */
422     /**
423      * Available amount in the balance
424      */
425     function availableBalanceOf(address holder) external view returns (uint256) {
426         return _tokenContainers[holder].balance;
427     }
428 
429     /**
430      * Holder의 계정 잔액 요약 출력(JSON 포맷)
431      */
432     /**
433      * An output of Holder's account balance summary (JSON format)
434      */
435     function receiptAccountOf(address holder) external view returns (string memory) {
436         bytes memory blockStart = bytes("{");
437         bytes memory chargeLabel = bytes("\"chargeAmount\" : \"");
438         bytes memory charge = bytes(uint2str(_tokenContainers[holder].chargeAmount));
439         bytes memory unlockLabel = bytes("\", \"unlockAmount\" : \"");
440         bytes memory unlock = bytes(uint2str(_tokenContainers[holder].unlockAmount));
441         bytes memory balanceLabel = bytes("\", \"availableBalance\" : \"");
442         bytes memory balance = bytes(uint2str(_tokenContainers[holder].balance));
443         bytes memory blockEnd = bytes("\"}");
444 
445         string memory receipt = new string(blockStart.length + chargeLabel.length + charge.length + unlockLabel.length + unlock.length + balanceLabel.length + balance.length + blockEnd.length);
446         bytes memory receiptBytes = bytes(receipt);
447 
448         uint readIndex = 0;
449         uint writeIndex = 0;
450 
451         for (readIndex = 0; readIndex < blockStart.length; readIndex++) {
452             receiptBytes[writeIndex++] = blockStart[readIndex];
453         }
454         for (readIndex = 0; readIndex < chargeLabel.length; readIndex++) {
455             receiptBytes[writeIndex++] = chargeLabel[readIndex];
456         }
457         for (readIndex = 0; readIndex < charge.length; readIndex++) {
458             receiptBytes[writeIndex++] = charge[readIndex];
459         }
460         for (readIndex = 0; readIndex < unlockLabel.length; readIndex++) {
461             receiptBytes[writeIndex++] = unlockLabel[readIndex];
462         }
463         for (readIndex = 0; readIndex < unlock.length; readIndex++) {
464             receiptBytes[writeIndex++] = unlock[readIndex];
465         }
466         for (readIndex = 0; readIndex < balanceLabel.length; readIndex++) {
467             receiptBytes[writeIndex++] = balanceLabel[readIndex];
468         }
469         for (readIndex = 0; readIndex < balance.length; readIndex++) {
470             receiptBytes[writeIndex++] = balance[readIndex];
471         }
472         for (readIndex = 0; readIndex < blockEnd.length; readIndex++) {
473             receiptBytes[writeIndex++] = blockEnd[readIndex];
474         }
475 
476         return string(receiptBytes);
477     }
478 
479     // uint 값을 string 으로 변환하는 내부 함수
480     // An internal function that converts an uint value to a string
481     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
482         if (_i == 0) {
483             return "0";
484         }
485         uint j = _i;
486         uint len;
487         while (j != 0) {
488             len++;
489             j /= 10;
490         }
491         bytes memory bstr = new bytes(len);
492         uint k = len - 1;
493         while (_i != 0) {
494             bstr[k--] = byte(uint8(48 + _i % 10));
495             _i /= 10;
496         }
497         return string(bstr);
498     }
499 
500     // 전체 유통량 - Owner의 unlockAmount
501     // Total circulation supply, or the unlockAmount of the Owner's
502     function circulationAmount() external view returns (uint256) {
503         return _tokenContainers[owner()].unlockAmount;
504     }
505 
506     // 전체 유통량 증가
507     // Increase the token's total circulation supply 
508     /*
509      * 컨트랙트 상에 유통되는 토큰량을 증가 시킵니다.
510      * Owner가 보유한 전체 토큰량에서 Unlock 된 양 만큼이 현재 유통량이므로,
511      * Unlock Amount와 Balance 가 증가하며, Charge Amount는 변동되지 않습니다.
512      */
513     /*
514      * This function increases the amount of circulated tokens that are distributed on the contract.
515      * The circulated token is referring to the Unlock tokens out of the contract Owner's total supply, so the Charge Amount is not affected (refer back to the Balance definition above).
516      * This function increases in the Unlock Amount as well as in the Balance.
517      */
518     function increaseCirculation(uint256 amount) external onlyOwner returns (uint256) {
519         require(!isLock);
520         require(_tokenContainers[msg.sender].chargeAmount >= _tokenContainers[msg.sender].unlockAmount.add(amount));
521         _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.add(amount);
522         _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.add(amount);
523         emit ChangeCirculation(_tokenContainers[msg.sender].unlockAmount);
524         return _tokenContainers[msg.sender].unlockAmount;
525     }
526 
527     // 전체 유통량 감소
528     // Reduction of the token's total supply
529     /*
530      * 컨트랙트 상에 유통되는 토큰량을 감소 시킵니다.
531      * Owner가 보유한 전체 토큰량에서 Unlock 된 양 만큼이 현재 유통량이므로,
532      * Unlock Amount와 Balance 가 감소하며, Charge Amount는 변동되지 않습니다.
533      * Owner만 실행할 수 있으며, 정책적인 계획에 맞추어 실행되어야하므로 0보다 작아지는 값이 입력되는 경우 실행을 중단합니다.
534      */
535     /*
536      * This function decreases the amount of circulated tokens that are distributed on the contract.
537      * The circulated token is referring to the Unlock tokens out of the contract Owner's total supply, so the Charge Amount is not affected (refer back to the Balance definition above).
538      * This function decreases in the Unlock Amount as well as in the Balance.
539      */
540     function decreaseCirculation(uint256 amount) external onlyOwner returns (uint256) {
541         require(!isLock);
542         _tokenContainers[msg.sender].unlockAmount = _tokenContainers[msg.sender].unlockAmount.sub(amount);
543         _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.sub(amount);
544         emit ChangeCirculation(_tokenContainers[msg.sender].unlockAmount);
545         return _tokenContainers[msg.sender].unlockAmount;
546     }
547 
548     /*
549      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 만큼의 충전량을 직접 입력할 때 사용합니다.
550      * 컨트랙트 내 토큰의 유통량에 맞추어 동작하므로, Owner의 Balance가 부족하면 실행을 중단힙니다.
551      * 충전한 토큰은 lock인 상태로 시작되며, charge() 함수는 충전과 동시에 Unlock하는 양을 지정하여
552      * increaseUnlockAmount() 함수의 실행 횟수를 줄일 수 있다.
553      */
554     /*
555      * This function is used to directly input the token amount that is purchased by particular Holders (ICO, Pre-sale buyers). It can be performed by the Owner or the Delegator.
556      * Since the contract operates in concurrent to the tokens in circulation, the function will fail to execute when Owner's balance is insuffient. 
557      * All charged tokens are locked amount. 
558      */
559     function charge(address holder, uint256 chargeAmount, uint256 unlockAmount) external ownerOrDelegator {
560         require(!isLock);
561         require(holder != address(0));
562         require(holder != owner());
563         require(chargeAmount > 0);
564         require(chargeAmount >= unlockAmount);
565         require(_tokenContainers[owner()].balance >= chargeAmount);
566 
567         _tokenContainers[owner()].balance = _tokenContainers[owner()].balance.sub(chargeAmount);
568 
569         _tokenContainers[holder].chargeAmount = _tokenContainers[holder].chargeAmount.add(chargeAmount);
570         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.add(unlockAmount);
571         _tokenContainers[holder].balance = _tokenContainers[holder].balance.add(unlockAmount);
572         
573         emit Charge(holder, chargeAmount, unlockAmount);
574     }
575     
576     /*
577      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 안에서 해금량을 변경할 때 사용합니다.
578      * 총 충전량 안에서 변화가 일어나므로 Unlock Amount가 Charge Amount보다 커질 수 없습니다.
579      */
580     /*
581      * This function is used to change the Unlock Amount of tokens that is purchased by particular Holders (ICO, Pre-sale buyers).
582      * Unlock Amount cannot be larger than Charge Amount because changes occur within the total charge amount.
583      */
584     function increaseUnlockAmount(address holder, uint256 unlockAmount) external ownerOrDelegator {
585         require(!isLock);
586         require(holder != address(0));
587         require(holder != owner());
588         require(_tokenContainers[holder].chargeAmount >= _tokenContainers[holder].unlockAmount.add(unlockAmount));
589 
590         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.add(unlockAmount);
591         _tokenContainers[holder].balance = _tokenContainers[holder].balance.add(unlockAmount);
592         
593         emit IncreaseUnlockAmount(holder, unlockAmount);
594     }
595     
596     /*
597      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 안에서 해금량을 변경할 때 사용합니다.
598      * Balance를 Lock 상태로 전환하는 것이므로 Lock Amount의 값은 Balance보다 커질 수 없습니다.
599      */
600     /*
601      * This function is used to change the Unlock Amount of tokens that is purchased by particular Holders (ICO, Pre-sale buyers).
602      * Since the Balance starts from a locked state, the number of locked tokens cannot be greater than the Balance.
603      */
604     function decreaseUnlockAmount(address holder, uint256 lockAmount) external ownerOrDelegator {
605         require(!isLock);
606         require(holder != address(0));
607         require(holder != owner());
608         require(_tokenContainers[holder].balance >= lockAmount);
609 
610         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.sub(lockAmount);
611         _tokenContainers[holder].balance = _tokenContainers[holder].balance.sub(lockAmount);
612         
613         emit DecreaseUnlockAmount(holder, lockAmount);
614     }
615 
616     /*
617      * 특정 사용자(ICO, PreSale 구매자)가 구매한 금액 안에서 전체를 해금할 때 사용합니다.
618      * Charge Amount 중 Unlock Amount 량을 제외한 나머지 만큼을 일괄적으로 해제합니다.
619      */
620     /*
621      * This function is used to change the Unlock Amount of tokens that is purchased by particular Holders (ICO, Pre-sale buyers).
622      * It unlocks all locked tokens in the Charge Amount, other than tokens already unlocked. 
623      */
624     function unlockAmountAll(address holder) external ownerOrDelegator {
625         require(!isLock);
626         require(holder != address(0));
627         require(holder != owner());
628 
629         uint256 unlockAmount = _tokenContainers[holder].chargeAmount.sub(_tokenContainers[holder].unlockAmount);
630 
631         require(unlockAmount > 0);
632         
633         _tokenContainers[holder].unlockAmount = _tokenContainers[holder].unlockAmount.add(unlockAmount);
634         _tokenContainers[holder].balance = _tokenContainers[holder].balance.add(unlockAmount);
635     }
636 
637     /*
638      * 계약 잠금
639      * 계약이 잠기면 컨트랙트의 거래가 중단된 상태가 되며,
640      * 거래가 중단된 상태에서는 Owner와 Delegator를 포함한 모든 Holder는 거래를 할 수 없게 된다.
641      * 모든 거래가 중단된 상태에서 모든 Holder의 상태가 변경되지 않게 만든 후에
642      * 토큰 -> 코인 전환 절차를 진행하기 위함이다.
643      * 단, 이 상태에서는 Exchange Contract를 Owner가 직접 Delegator로 임명하여
644      * Holder의 요청을 처리하도록 하며, 이때는 토큰 -> 코인 교환회수를 위한 exchange(), withdraw() 함수 실행만 허용이 된다.
645      */
646     /*
647      * Contract lock
648      * If the contract is locked, all transactions will be suspended.
649      * All Holders including Owner and Delegator will not be able to make transaction during suspension.
650      * After all transactions have been stopped and all Holders have not changed their status
651      * This function is created primarily for the token swap event. 
652      * In this process, it's important to note that the Owner of the Exchange contract should directly appoint a delegator when handling Holders' requests.
653      * Only the exchange () and withdraw () are allowed to be executed for token swap.
654      */
655     function lock() external onlyOwner returns (bool) {
656         isLock = true;
657         return isLock;
658     }
659 
660     /*
661      * 계약 잠금 해제
662      * 잠긴 계약을 해제할 때 사용된다.
663      */
664     /*
665      * Release contract lock
666      * The function is used to revert a locked contract to a normal state. 
667      */
668     function unlock() external onlyOwner returns (bool) {
669         isLock = false;
670         return isLock;
671     }
672     
673     /*
674      * 토큰 교환 처리용 외부 호출 함수
675      * 계약 전체가 잠긴 상태일 때(교환 처리 중 계약 중단),
676      * 외부에서만 호출 가능하며, Delegator이면서 Contract인 경우에만 호출 가능하다.
677      */
678     /*
679      * It is an external call function for token exchange processing
680      * This function is used when the entire contract is locked (contract lock during the token swap),
681      * It can be called only externally. Also, it can be only called when the agent is both Delegator and Contract.
682      */
683     function exchange(address holder) external onlyDelegator returns (bool) {
684         require(isLock);    // lock state only
685         require((delegator() == msg.sender) && isContract(msg.sender));    // contract delegator only
686         
687         uint256 balance = _tokenContainers[holder].balance;
688         _tokenContainers[holder].balance = 0;
689         _tokenContainers[msg.sender].balance = _tokenContainers[msg.sender].balance.add(balance);
690         
691         emit Exchange(holder, msg.sender, balance);
692         return true;
693     }
694     
695     /*
696      * 토큰 교환 처리 후 회수된 토큰을 Owner한테 돌려주는 함수
697      * 계약 전체가 잠긴 상태일 때(교환 처리 중 계약 중단),
698      * 외부에서만 호출 가능하며, Delegator이면서 Contract인 경우에만 호출 가능하다.
699      */
700     /*
701      * This is a function in which the Delegator returns tokens to the Owner after the token swap process
702      * This function is used when the entire contract is locked (contract lock during the token swap),
703      * It can be called only externally. Also, it can be only called when the agent is both Delegator and Contract Owner.
704      */
705     function withdraw() external onlyDelegator returns (bool) {
706         require(isLock);    // lock state only
707         require((delegator() == msg.sender) && isContract(msg.sender));    // contract delegator only
708         
709         uint256 balance = _tokenContainers[msg.sender].balance;
710         _tokenContainers[msg.sender].balance = 0;
711         _tokenContainers[owner()].balance = _tokenContainers[owner()].balance.add(balance);
712         
713         emit Withdraw(msg.sender, balance);
714     }
715     
716     /*
717      * 현재의 주소가 엔진내에 차지하고 있는 코드의 크기를 계산하여 컨트랙트인지 확인하는 도구
718      * 컨트랙트인 경우에만 저장된 코드의 크기가 존재하므로 코드의 크기가 존재한다면
719      * 컨트랙트로 판단할 수있다.
720      */
721     /*
722      * This is a tool used for confirming a contract. It determines the size of code that the current address occupies within the blockchain network.
723      * Since the size of a stored code exists only in the case of a contract, it is can be used as a validation tool.
724      */
725     function isContract(address addr) private returns (bool) {
726       uint size;
727       assembly { size := extcodesize(addr) }
728       return size > 0;
729     }
730 }
731 
732 contract SymToken is ERC20Like {
733     string public name = "SymVerse";
734     string public symbol = "SYM";
735     uint256 public decimals = 18;
736 
737     constructor () public {
738         _totalSupply = 900000000 * (10 ** decimals);
739         _tokenContainers[msg.sender].chargeAmount = _totalSupply;
740         emit Charge(msg.sender, _tokenContainers[msg.sender].chargeAmount, _tokenContainers[msg.sender].unlockAmount);
741     }
742 }