1 pragma solidity ^0.4.18;
2 
3 contract DelegateERC20 {
4   function delegateTotalSupply() public view returns (uint256);
5   function delegateBalanceOf(address who) public view returns (uint256);
6   function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);
7   function delegateAllowance(address owner, address spender) public view returns (uint256);
8   function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);
9   function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);
10   function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);
11   function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);
12 }
13 contract Ownable {
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15   function transferOwnership(address newOwner) public;
16 }
17 contract Pausable is Ownable {
18   event Pause();
19   event Unpause();
20   function pause() public;
21   function unpause() public;
22 }
23 contract CanReclaimToken is Ownable {
24   function reclaimToken(ERC20Basic token) external;
25 }
26 contract Claimable is Ownable {
27   function transferOwnership(address newOwner) public;
28   function claimOwnership() public;
29 }
30 contract AddressList is Claimable {
31     event ChangeWhiteList(address indexed to, bool onList);
32     function changeList(address _to, bool _onList) public;
33 }
34 contract HasNoContracts is Ownable {
35   function reclaimContract(address contractAddr) external;
36 }
37 contract HasNoEther is Ownable {
38   function() external;
39   function reclaimEther() external;
40 }
41 contract HasNoTokens is CanReclaimToken {
42   function tokenFallback(address from_, uint256 value_, bytes data_) external;
43 }
44 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
45 }
46 contract AllowanceSheet is Claimable {
47     function addAllowance(address tokenHolder, address spender, uint256 value) public;
48     function subAllowance(address tokenHolder, address spender, uint256 value) public;
49     function setAllowance(address tokenHolder, address spender, uint256 value) public;
50 }
51 contract BalanceSheet is Claimable {
52     function addBalance(address addr, uint256 value) public;
53     function subBalance(address addr, uint256 value) public;
54     function setBalance(address addr, uint256 value) public;
55 }
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 contract BasicToken is ERC20Basic, Claimable {
63   function setBalanceSheet(address sheet) external;
64   function totalSupply() public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal;
67   function balanceOf(address _owner) public view returns (uint256 balance);
68 }
69 contract BurnableToken is BasicToken {
70   event Burn(address indexed burner, uint256 value);
71   function burn(uint256 _value) public;
72 }
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public view returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 library SafeERC20 {
80 }
81 contract StandardToken is ERC20, BasicToken {
82   function setAllowanceSheet(address sheet) external;
83   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
84   function transferAllArgsYesAllowance(address _from, address _to, uint256 _value, address spender) internal;
85   function approve(address _spender, uint256 _value) public returns (bool);
86   function approveAllArgs(address _spender, uint256 _value, address _tokenHolder) internal;
87   function allowance(address _owner, address _spender) public view returns (uint256);
88   function increaseApproval(address _spender, uint _addedValue) public returns (bool);
89   function increaseApprovalAllArgs(address _spender, uint _addedValue, address tokenHolder) internal;
90   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool);
91   function decreaseApprovalAllArgs(address _spender, uint _subtractedValue, address tokenHolder) internal;
92 }
93 contract CanDelegate is StandardToken {
94     event DelegatedTo(address indexed newContract);
95     function delegateToNewContract(DelegateERC20 newContract) public;
96     function transfer(address to, uint256 value) public returns (bool);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function balanceOf(address who) public view returns (uint256);
99     function approve(address spender, uint256 value) public returns (bool);
100     function allowance(address _owner, address spender) public view returns (uint256);
101     function totalSupply() public view returns (uint256);
102     function increaseApproval(address spender, uint addedValue) public returns (bool);
103     function decreaseApproval(address spender, uint subtractedValue) public returns (bool);
104 }
105 contract StandardDelegate is StandardToken, DelegateERC20 {
106     function setDelegatedFrom(address addr) public;
107     function delegateTotalSupply() public view returns (uint256);
108     function delegateBalanceOf(address who) public view returns (uint256);
109     function delegateTransfer(address to, uint256 value, address origSender) public returns (bool);
110     function delegateAllowance(address owner, address spender) public view returns (uint256);
111     function delegateTransferFrom(address from, address to, uint256 value, address origSender) public returns (bool);
112     function delegateApprove(address spender, uint256 value, address origSender) public returns (bool);
113     function delegateIncreaseApproval(address spender, uint addedValue, address origSender) public returns (bool);
114     function delegateDecreaseApproval(address spender, uint subtractedValue, address origSender) public returns (bool);
115 }
116 contract PausableToken is StandardToken, Pausable {
117   function transfer(address _to, uint256 _value) public returns (bool);
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
119   function approve(address _spender, uint256 _value) public returns (bool);
120   function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
121   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
122 }
123 contract TrueUSD is StandardDelegate, PausableToken, BurnableToken, NoOwner, CanDelegate {
124     event ChangeBurnBoundsEvent(uint256 newMin, uint256 newMax);
125     event Mint(address indexed to, uint256 amount);
126     event WipedAccount(address indexed account, uint256 balance);
127     function setLists(AddressList _canReceiveMintWhiteList, AddressList _canBurnWhiteList, AddressList _blackList, AddressList _noFeesList) public;
128     function changeName(string _name, string _symbol) public;
129     function burn(uint256 _value) public;
130     function mint(address _to, uint256 _amount) public;
131     function changeBurnBounds(uint newMin, uint newMax) public;
132     function transferAllArgsNoAllowance(address _from, address _to, uint256 _value) internal;
133     function wipeBlacklistedAccount(address account) public;
134     function payStakingFee(address payer, uint256 value, uint80 numerator, uint80 denominator, uint256 flatRate, address otherParticipant) private returns (uint256);
135     function changeStakingFees(uint80 _transferFeeNumerator, uint80 _transferFeeDenominator, uint80 _mintFeeNumerator, uint80 _mintFeeDenominator, uint256 _mintFeeFlat, uint80 _burnFeeNumerator, uint80 _burnFeeDenominator, uint256 _burnFeeFlat) public;
136     function changeStaker(address newStaker) public;
137 }
138 
139 
140 
141 /**
142  * @title SafeMath
143  * @dev Math operations with safety checks that revert on error
144  */
145 library NewSafeMath {
146 
147     /**
148     * @dev Multiplies two numbers, reverts on overflow.
149     */
150     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
154         if (_a == 0) {
155             return 0;
156         }
157 
158         uint256 c = _a * _b;
159         require(c / _a == _b);
160 
161         return c;
162     }
163 
164     /**
165     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
166     */
167     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
168         require(_b > 0); // Solidity only automatically asserts when dividing by 0
169         uint256 c = _a / _b;
170         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
171 
172         return c;
173     }
174 
175     /**
176     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
177     */
178     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
179         require(_b <= _a);
180         uint256 c = _a - _b;
181 
182         return c;
183     }
184 
185     /**
186     * @dev Adds two numbers, reverts on overflow.
187     */
188     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
189         uint256 c = _a + _b;
190         require(c >= _a);
191 
192         return c;
193     }
194 
195     /**
196     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
197     * reverts when dividing by zero.
198     */
199     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
200         require(b != 0);
201         return a % b;
202     }
203 }
204 
205 /**
206  * @title Cash311
207  * @dev The main contract of the project.
208  */
209   /**
210     * @title Cash311
211     * @dev https://311.cash/;
212     */
213     contract Cash311 {
214         // Connecting SafeMath for safe calculations.
215           // Подключает библиотеку безопасных вычислений к контракту.
216         using NewSafeMath for uint;
217 
218         // A variable for address of the owner;
219           // Переменная для хранения адреса владельца контракта;
220         address owner;
221 
222         // A variable for address of the ERC20 token;
223           // Переменная для хранения адреса токена ERC20;
224         TrueUSD public token = TrueUSD(0x8dd5fbce2f6a956c3022ba3663759011dd51e73e);
225 
226         // A variable for decimals of the token;
227           // Переменная для количества знаков после запятой у токена;
228         uint private decimals = 10**18;
229 
230         // A variable for storing deposits of investors.
231           // Переменная для хранения записей о сумме инвестиций инвесторов.
232         mapping (address => uint) deposit;
233         uint deposits;
234 
235         // A variable for storing amount of withdrawn money of investors.
236           // Переменная для хранения записей о сумме снятых средств.
237         mapping (address => uint) withdrawn;
238 
239         // A variable for storing reference point to count available money to withdraw.
240           // Переменная для хранения времени отчета для инвесторов.
241         mapping (address => uint) lastTimeWithdraw;
242 
243 
244         // RefSystem
245         mapping (address => uint) referals1;
246         mapping (address => uint) referals2;
247         mapping (address => uint) referals3;
248         mapping (address => uint) referals1m;
249         mapping (address => uint) referals2m;
250         mapping (address => uint) referals3m;
251         mapping (address => address) referers;
252         mapping (address => bool) refIsSet;
253         mapping (address => uint) refBonus;
254 
255 
256         // A constructor function for the contract. It used single time as contract is deployed.
257           // Единоразовая функция вызываемая при деплое контракта.
258         function Cash311() public {
259             // Sets an owner for the contract;
260               // Устанавливает владельца контракта;
261             owner = msg.sender;
262         }
263 
264         // A function for transferring ownership of the contract (available only for the owner).
265           // Функция для переноса права владения контракта (доступна только для владельца).
266         function transferOwnership(address _newOwner) external {
267             require(msg.sender == owner);
268             require(_newOwner != address(0));
269             owner = _newOwner;
270         }
271 
272         // RefSystem
273         function bytesToAddress1(bytes source) internal pure returns(address parsedReferer) {
274             assembly {
275                 parsedReferer := mload(add(source,0x14))
276             }
277             return parsedReferer;
278         }
279 
280         // A function for getting key info for investors.
281           // Функция для вызова ключевой информации для инвестора.
282         function getInfo(address _address) public view returns(uint Deposit, uint Withdrawn, uint AmountToWithdraw, uint Bonuses) {
283 
284             // 1) Amount of invested tokens;
285               // 1) Сумма вложенных токенов;
286             Deposit = deposit[_address].div(decimals);
287             // 2) Amount of withdrawn tokens;
288               // 3) Сумма снятых средств;
289             Withdrawn = withdrawn[_address].div(decimals);
290             // Amount of tokens which is available to withdraw.
291             // Formula without SafeMath: ((Current Time - Reference Point) / 1 period)) * (Deposit * 0.0311)
292               // Расчет количества токенов доступных к выводу;
293               // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) / 1 period)) * (Сумма депозита * 0.0311)
294             uint _a = (block.timestamp.sub(lastTimeWithdraw[_address])).div(1 days).mul(deposit[_address].mul(311).div(10000));
295             AmountToWithdraw = _a.div(decimals);
296             // RefSystem
297             Bonuses = refBonus[_address].div(decimals);
298         }
299 
300         // RefSystem
301         function getRefInfo(address _address) public view returns(uint Referals1, uint Referals1m, uint Referals2, uint Referals2m, uint Referals3, uint Referals3m) {
302             Referals1 = referals1[_address];
303             Referals1m = referals1m[_address].div(decimals);
304             Referals2 = referals2[_address];
305             Referals2m = referals2m[_address].div(decimals);
306             Referals3 = referals3[_address];
307             Referals3m = referals3m[_address].div(decimals);
308         }
309 
310         function getNumber() public view returns(uint) {
311             return deposits;
312         }
313 
314         function getTime(address _address) public view returns(uint Hours, uint Minutes) {
315             Hours = (lastTimeWithdraw[_address] % 1 days) / 1 hours;
316             Minutes = (lastTimeWithdraw[_address] % 1 days) % 1 hours / 1 minutes;
317         }
318 
319 
320 
321 
322         // A "fallback" function. It is automatically being called when anybody sends ETH to the contract. Even if the amount of ETH is ecual to 0;
323           // Функция автоматически вызываемая при получении ETH контрактом (даже если было отправлено 0 эфиров);
324         function() external payable {
325 
326             // If investor accidentally sent ETH then function send it back;
327               // Если инвестором был отправлен ETH то средства возвращаются отправителю;
328             msg.sender.transfer(msg.value);
329             // If the value of sent ETH is equal to 0 then function executes special algorithm:
330             // 1) Gets amount of intended deposit (approved tokens).
331             // 2) If there are no approved tokens then function "withdraw" is called for investors;
332               // Если было отправлено 0 эфиров то исполняется следующий алгоритм:
333               // 1) Заправшивается количество токенов для инвестирования (кол-во одобренных к выводу токенов).
334               // 2) Если одобрены токенов нет, для действующих инвесторов вызывается функция инвестирования (после этого действие функции прекращается);
335             uint _approvedTokens = token.allowance(msg.sender, address(this));
336             if (_approvedTokens == 0 && deposit[msg.sender] > 0) {
337                 withdraw();
338                 return;
339             // If there are some approved tokens to invest then function "invest" is called;
340               // Если были одобрены токены то вызывается функция инвестирования (после этого действие функции прекращается);
341             } else {
342                 if (msg.data.length == 20) {
343                     address referer = bytesToAddress1(bytes(msg.data));
344                     if (referer != msg.sender) {
345                         invest(referer);
346                         return;
347                     }
348                 }
349                 invest(0x0);
350                 return;
351             }
352         }
353 
354         // RefSystem
355         function refSystem(uint _value, address _referer) internal {
356             refBonus[_referer] = refBonus[_referer].add(_value.div(40));
357             referals1m[_referer] = referals1m[_referer].add(_value);
358             if (refIsSet[_referer]) {
359                 address ref2 = referers[_referer];
360                 refBonus[ref2] = refBonus[ref2].add(_value.div(50));
361                 referals2m[ref2] = referals2m[ref2].add(_value);
362                 if (refIsSet[referers[_referer]]) {
363                     address ref3 = referers[referers[_referer]];
364                     refBonus[ref3] = refBonus[ref3].add(_value.mul(3).div(200));
365                     referals3m[ref3] = referals3m[ref3].add(_value);
366                 }
367             }
368         }
369 
370         // RefSystem
371         function setRef(uint _value, address referer) internal {
372 
373             if (deposit[referer] > 0) {
374                 referers[msg.sender] = referer;
375                 refIsSet[msg.sender] = true;
376                 referals1[referer] = referals1[referer].add(1);
377                 if (refIsSet[referer]) {
378                     referals2[referers[referer]] = referals2[referers[referer]].add(1);
379                     if (refIsSet[referers[referer]]) {
380                         referals3[referers[referers[referer]]] = referals3[referers[referers[referer]]].add(1);
381                     }
382                 }
383                 refBonus[msg.sender] = refBonus[msg.sender].add(_value.div(50));
384                 refSystem(_value, referer);
385             }
386         }
387 
388 
389 
390         // A function which accepts tokens of investors.
391           // Функция для перевода токенов на контракт.
392         function invest(address _referer) public {
393 
394             // Gets amount of deposit (approved tokens);
395               // Заправшивает количество токенов для инвестирования (кол-во одобренных к выводу токенов);
396             uint _value = token.allowance(msg.sender, address(this));
397 
398             // Transfers approved ERC20 tokens from investors address;
399               // Переводит одобренные к выводу токены ERC20 на данный контракт;
400             token.transferFrom(msg.sender, address(this), _value);
401             // Transfers a fee to the owner of the contract. The fee is 10% of the deposit (or Deposit / 10)
402               // Начисляет комиссию владельцу (10%);
403             refBonus[owner] = refBonus[owner].add(_value.div(10));
404 
405             // The special algorithm for investors who increases their deposits:
406               // Специальный алгоритм для инвесторов увеличивающих их вклад;
407             if (deposit[msg.sender] > 0) {
408                 // Amount of tokens which is available to withdraw.
409                 // Formula without SafeMath: ((Current Time - Reference Point) / 1 period)) * (Deposit * 0.0311)
410                   // Расчет количества токенов доступных к выводу;
411                   // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) / 1 period)) * (Сумма депозита * 0.0311)
412                 uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender])).div(1 days).mul(deposit[msg.sender].mul(311).div(10000));
413                 // The additional algorithm for investors who need to withdraw available dividends:
414                   // Дополнительный алгоритм для инвесторов которые имеют средства к снятию;
415                 if (amountToWithdraw != 0) {
416                     // Increasing the withdrawn tokens by the investor.
417                       // Увеличение количества выведенных средств инвестором;
418                     withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);
419                     // Transferring available dividends to the investor.
420                       // Перевод доступных к выводу средств на кошелек инвестора;
421                     token.transfer(msg.sender, amountToWithdraw);
422 
423                     // RefSystem
424                     uint _bonus = refBonus[msg.sender];
425                     if (_bonus != 0) {
426                         refBonus[msg.sender] = 0;
427                         token.transfer(msg.sender, _bonus);
428                         withdrawn[msg.sender] = withdrawn[msg.sender].add(_bonus);
429                     }
430 
431                 }
432                 // Setting the reference point to the current time.
433                   // Установка нового отчетного времени для инвестора;
434                 lastTimeWithdraw[msg.sender] = block.timestamp;
435                 // Increasing of the deposit of the investor.
436                   // Увеличение Суммы депозита инвестора;
437                 deposit[msg.sender] = deposit[msg.sender].add(_value);
438                 // End of the function for investors who increases their deposits.
439                   // Конец функции для инвесторов увеличивающих свои депозиты;
440 
441                 // RefSystem
442                 if (refIsSet[msg.sender]) {
443                       refSystem(_value, referers[msg.sender]);
444                   } else if (_referer != 0x0 && _referer != msg.sender) {
445                       setRef(_value, _referer);
446                   }
447                 return;
448             }
449             // The algorithm for new investors:
450             // Setting the reference point to the current time.
451               // Алгоритм для новых инвесторов:
452               // Установка нового отчетного времени для инвестора;
453             lastTimeWithdraw[msg.sender] = block.timestamp;
454             // Storing the amount of the deposit for new investors.
455             // Установка суммы внесенного депозита;
456             deposit[msg.sender] = (_value);
457             deposits += 1;
458 
459             // RefSystem
460             if (refIsSet[msg.sender]) {
461                 refSystem(_value, referers[msg.sender]);
462             } else if (_referer != 0x0 && _referer != msg.sender) {
463                 setRef(_value, _referer);
464             }
465         }
466 
467         // A function for getting available dividends of the investor.
468           // Функция для вывода средств доступных к снятию;
469         function withdraw() public {
470 
471             // Amount of tokens which is available to withdraw.
472             // Formula without SafeMath: ((Current Time - Reference Point) / 1 period)) * (Deposit * 0.0311)
473               // Расчет количества токенов доступных к выводу;
474               // Формула без библиотеки безопасных вычислений: ((Текущее время - Отчетное время) / 1 period)) * (Сумма депозита * 0.0311)
475             uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender])).div(1 days).mul(deposit[msg.sender].mul(311).div(10000));
476             // Reverting the whole function for investors who got nothing to withdraw yet.
477               // В случае если к выводу нет средств то функция отменяется;
478             if (amountToWithdraw == 0) {
479                 revert();
480             }
481             // Increasing the withdrawn tokens by the investor.
482               // Увеличение количества выведенных средств инвестором;
483             withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);
484             // Updating the reference point.
485             // Formula without SafeMath: Current Time - ((Current Time - Previous Reference Point) % 1 period)
486               // Обновление отчетного времени инвестора;
487               // Формула без библиотеки безопасных вычислений: Текущее время - ((Текущее время - Предыдущее отчетное время) % 1 period)
488             lastTimeWithdraw[msg.sender] = block.timestamp.sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days));
489             // Transferring the available dividends to the investor.
490               // Перевод выведенных средств;
491             token.transfer(msg.sender, amountToWithdraw);
492 
493             // RefSystem
494             uint _bonus = refBonus[msg.sender];
495             if (_bonus != 0) {
496                 refBonus[msg.sender] = 0;
497                 token.transfer(msg.sender, _bonus);
498                 withdrawn[msg.sender] = withdrawn[msg.sender].add(_bonus);
499             }
500 
501         }
502     }