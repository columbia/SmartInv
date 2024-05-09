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
21  *   3.1.2 Balance
22  *    ERC20의 Balance와 같습니다.
23  */
24 /*
25  * Contract Overview 
26  * 1. Purpose
27  *  It is intended to operate for a limited time until mainnet launch.
28  *  When the mainnet is launched, all transactions of the contract will be suspended from that day on forward and will initiate the token swap to the mainnet.
29  * 2. Key Definitions
30  *  Owner : An entity from which smart contract is created
31  *  Delegator : The appointed agent is created to prevent from using the contract owner's private key for every transaction made, since it can cause a serious security issue.  
32  *              In particular, it performs core functons at the time of the token swap event, such as executing a dedicated, Delegator-specific function while contract transaction is under suspension and
33  *              withdraw contract's tokens. 
34  *  Holder : An account in which tokens can be stored (also referrs to all users of the contract: Owner, Delegator, Spender, ICO buyers, ect.)
35  * 3. Operation
36  *  3.1. TokenContainer Structure
37  *   3.1.1 Charge Amount
38  *    Charge Amount is the charged token amount purcahsed by Holder.
39  *    In case for the Owner, the total charged amount in the contract equates to the Total Supply.
40  *   3.1.2 Balance
41  *     Similiar to the ERC20 Balance.
42  */
43 library SafeMath {
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a);
74 
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b != 0);
80         return a % b;
81     }
82 }
83 
84 interface IERC20 {
85     function transfer(address to, uint256 value) external returns (bool);
86     function approve(address spender, uint256 value) external returns (bool);
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88     function totalSupply() external view returns (uint256);
89     function balanceOf(address who) external view returns (uint256);
90     function allowance(address owner, address spender) external view returns (uint256);
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 contract Ownable {
96     address private _owner;
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     constructor () internal {
101         _owner = msg.sender;
102         emit OwnershipTransferred(address(0), _owner);
103     }
104 
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     modifier onlyOwner() {
110         require(isOwner());
111         _;
112     }
113 
114     function isOwner() public view returns (bool) {
115         return msg.sender == _owner;
116     }
117 }
118 
119 /*
120  * Owner의 권한 중 일부를 대신 행사할 수 있도록 대행자를 지정/해제 할 수 있는 인터페이스를 정의하고 있다.
121  */
122  /*
123  * It defines an interface where the Owner can appoint / dismiss an agent that can partially excercize privileges in lieu of the Owner's 
124  */
125 contract Delegable is Ownable {
126     address private _delegator;
127     
128     event DelegateAppointed(address indexed previousDelegator, address indexed newDelegator);
129     
130     constructor () internal {
131         _delegator = address(0);
132     }
133     
134     /*
135      * delegator를 가져옴
136      */
137     /*
138      * Call-up Delegator
139      */
140     function delegator() public view returns (address) {
141         return _delegator;
142     }
143     
144     /*
145      * delegator만 실행 가능하도록 지정하는 접근 제한
146      */
147     /*
148      * Access restriction in which only appointed delegator is executable
149      */
150     modifier onlyDelegator() {
151         require(isDelegator());
152         _;
153     }
154     
155     /*
156      * owner 또는 delegator가 실행 가능하도록 지정하는 접근 제한
157      */
158     /*
159      * Access restriction in which only appointed delegator or Owner are executable
160      */
161     modifier ownerOrDelegator() {
162         require(isOwner() || isDelegator());
163         _;
164     }
165     
166     function isDelegator() public view returns (bool) {
167         return msg.sender == _delegator;
168     }
169     
170     /*
171      * delegator를 임명
172      */
173     /*
174      * Appoint the delegator
175      */
176     function appointDelegator(address delegator_) public onlyOwner returns (bool) {
177         require(delegator_ != address(0));
178         require(delegator_ != owner());
179         return _appointDelegator(delegator_);
180     }
181     
182     /*
183      * 지정된 delegator를 해임
184      */
185     /*
186      * Dimiss the appointed delegator
187      */
188     function dissmissDelegator() public onlyOwner returns (bool) {
189         require(_delegator != address(0));
190         return _appointDelegator(address(0));
191     }
192     
193     /*
194      * delegator를 변경하는 내부 함수
195      */
196     /*
197      * An internal function that allows delegator changes 
198      */
199     function _appointDelegator(address delegator_) private returns (bool) {
200         require(_delegator != delegator_);
201         emit DelegateAppointed(_delegator, delegator_);
202         _delegator = delegator_;
203         return true;
204     }
205 }
206 
207 /*
208  * ERC20의 기본 인터페이스는 유지하여 일반적인 토큰 전송이 가능하면서,
209  * 일부 추가 관리 기능을 구현하기 위한 Struct 및 함수가 추가되어 있습니다.
210  */
211 /*
212  * The basic interface of ERC20 is remained untouched therefore basic functions like token transactions will be available. 
213  * On top of that, Structs and functions have been added to implement some additional management functions.
214  */
215 contract ERC20Like is IERC20, Delegable {
216     using SafeMath for uint256;
217 
218     uint256 internal _totalSupply;  // 총 발행량 // Total Supply
219     bool isLock = false;  // 계약 잠금 플래그 // Contract Lock Flag
220 
221     /*
222      * 토큰 정보(충전량, 해금량, 가용잔액) 및 Spender 정보를 저장하는 구조체
223      */
224     /*
225      * Structure that stores token information (charge, unlock, balance) as well as Spender information
226      */
227     struct TokenContainer {
228         uint256 balance;  // 가용잔액 // available balance
229         mapping (address => uint256) allowed; // Spender
230     }
231 
232     mapping (address => TokenContainer) internal _tokenContainers;
233     
234     // 총 발행량 
235     // Total token supply 
236     function totalSupply() public view returns (uint256) {
237         return _totalSupply;
238     }
239 
240     // 가용잔액 가져오기
241     // Call-up available balance
242     function balanceOf(address holder) public view returns (uint256) {
243         return _tokenContainers[holder].balance;
244     }
245 
246     // Spender의 남은 잔액 가져오기
247     // Call-up Spender's remaining balance
248     function allowance(address holder, address spender) public view returns (uint256) {
249         return _tokenContainers[holder].allowed[spender];
250     }
251 
252     // 토큰송금
253     // Transfer token
254     function transfer(address to, uint256 value) public returns (bool) {
255         _transfer(msg.sender, to, value);
256         return true;
257     }
258 
259     // Spender 지정 및 금액 지정
260     // Appoint a Spender and set an amount 
261     function approve(address spender, uint256 value) public returns (bool) {
262         _approve(msg.sender, spender, value);
263         return true;
264     }
265     
266     function approveDelegator(address spender, uint256 value) public onlyDelegator returns (bool) {
267         require(msg.sender == delegator());
268         _approve(owner(), spender, value);
269         return true;
270     }
271 
272     // Spender 토큰송금
273     // Transfer token via Spender 
274     function transferFrom(address from, address to, uint256 value) public returns (bool) {
275         _transfer(from, to, value);
276         _approve(from, msg.sender, _tokenContainers[from].allowed[msg.sender].sub(value));
277         return true;
278     }
279     
280     // delegator인 경우에는 owner의 잔액을 대신 보낼 수 있음.
281     function transferDelegator(address to, uint256 value) public onlyDelegator returns (bool) {
282         require(msg.sender == delegator());
283         _transfer(owner(), to, value);
284         return true;
285     }
286 
287     // Spender가 할당 받은 양 증가
288     // Increase a Spender amount alloted by the Owner/Delegator
289     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
290         require(!isLock);
291         uint256 value = _tokenContainers[msg.sender].allowed[spender].add(addedValue);
292         _approve(msg.sender, spender, value);
293         return true;
294     }
295     
296     function increaseAllowanceDelegator(address spender, uint256 addedValue) public onlyDelegator returns (bool) {
297         require(msg.sender == delegator());
298         require(!isLock);
299         uint256 value = _tokenContainers[owner()].allowed[spender].add(addedValue);
300         _approve(owner(), spender, value);
301         return true;
302     }
303 
304     // Spender가 할당 받은 양 감소
305     // Decrease a Spender amount alloted by the Owner/Delegator
306     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
307         require(!isLock);
308         // 기존에 할당된 금액의 잔액보다 더 많은 금액을 줄이려고 하는 경우 할당액이 0이 되도록 처리
309         //// If you reduce more than the alloted amount in the balance, we made sure the alloted amount is set to zero instead of minus
310         if (_tokenContainers[msg.sender].allowed[spender] < subtractedValue) {
311             subtractedValue = _tokenContainers[msg.sender].allowed[spender];
312         }
313         
314         uint256 value = _tokenContainers[msg.sender].allowed[spender].sub(subtractedValue);
315         _approve(msg.sender, spender, value);
316         return true;
317     }
318     
319     function decreaseAllowanceDelegator(address spender, uint256 subtractedValue) public onlyDelegator returns (bool) {
320         require(msg.sender == delegator());
321         require(!isLock);
322         // 기존에 할당된 금액의 잔액보다 더 많은 금액을 줄이려고 하는 경우 할당액이 0이 되도록 처리
323         //// If you reduce more than the alloted amount in the balance, we made sure the alloted amount is set to zero instead of minus
324         if (_tokenContainers[owner()].allowed[spender] < subtractedValue) {
325             subtractedValue = _tokenContainers[owner()].allowed[spender];
326         }
327         
328         uint256 value = _tokenContainers[owner()].allowed[spender].sub(subtractedValue);
329         _approve(owner(), spender, value);
330         return true;
331     }
332 
333     // 토큰송금 내부 실행 함수 
334     // An internal execution function for troken transfer
335     function _transfer(address from, address to, uint256 value) private {
336         require(!isLock);
337         // 3.1. Known vulnerabilities of ERC-20 token
338         // 현재 컨트랙트로는 송금할 수 없도록 예외 처리 // Exceptions were added to not allow deposits to be made in the current contract . 
339         require(to != address(this));
340         require(to != address(0));
341 
342         _tokenContainers[from].balance = _tokenContainers[from].balance.sub(value);
343         _tokenContainers[to].balance = _tokenContainers[to].balance.add(value);
344         emit Transfer(from, to, value);
345     }
346 
347     // Spender 지정 내부 실행 함수
348     // Internal execution function for assigning a Spender
349     function _approve(address holder, address spender, uint256 value) private {
350         require(!isLock);
351         require(spender != address(0));
352         require(holder != address(0));
353 
354         _tokenContainers[holder].allowed[spender] = value;
355         emit Approval(holder, spender, value);
356     }
357 
358     // 전체 유통량 - Owner의 unlockAmount
359     // Total circulation supply, or the unlockAmount of the Owner's
360     function circulationAmount() external view returns (uint256) {
361         return _totalSupply.sub(_tokenContainers[owner()].balance);
362     }
363 
364     /*
365      * 계약 잠금
366      * 계약이 잠기면 컨트랙트의 거래가 중단된 상태가 되며,
367      * 거래가 중단된 상태에서는 Owner와 Delegator를 포함한 모든 Holder는 거래를 할 수 없게 된다.
368      */
369     /*
370      * Contract lock
371      * If the contract is locked, all transactions will be suspended.
372      * All Holders including Owner and Delegator will not be able to make transaction during suspension.
373      */
374     function lock() external onlyOwner returns (bool) {
375         isLock = true;
376         return isLock;
377     }
378 
379     /*
380      * 계약 잠금 해제
381      * 잠긴 계약을 해제할 때 사용된다.
382      */
383     /*
384      * Release contract lock
385      * The function is used to revert a locked contract to a normal state. 
386      */
387     function unlock() external onlyOwner returns (bool) {
388         isLock = false;
389         return isLock;
390     }
391 }
392 
393 contract SymToken is ERC20Like {
394     string public constant name = "SymVerse";
395     string public constant symbol = "SYM";
396     uint256 public constant decimals = 18;
397     
398     event CreateToken(address indexed c_owner, string c_name, string c_symbol, uint256 c_totalSupply);
399 
400     constructor () public {
401         _totalSupply = 1000000000 * (10 ** decimals);
402         _tokenContainers[msg.sender].balance = _totalSupply;
403         emit CreateToken(msg.sender, name, symbol, _tokenContainers[msg.sender].balance);
404     }
405 }