1 pragma solidity ^0.4.25;
2 
3 library Math {
4   function min(uint a, uint b) internal pure returns(uint) {
5     if (a > b) {
6       return b;
7     }
8     return a;
9   }
10   
11   function max(uint a, uint b) internal pure returns(uint) {
12     if (a > b) {
13       return a;
14     }
15     return b;
16   }
17 }
18 
19 library Percent {
20   // Solidity automatically throws when dividing by 0
21   struct percent {
22     uint num;
23     uint den;
24   }
25   
26   // storage
27   function mul(percent storage p, uint a) internal view returns (uint) {
28     if (a == 0) {
29       return 0;
30     }
31     return a*p.num/p.den;
32   }
33 
34     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
35     return Percent.percent(p.num, p.den);
36   }
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that revert on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, reverts on overflow.
47   */
48   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50     // benefit is lost if 'b' is also tested.
51     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52     if (_a == 0) {
53       return 0;
54     }
55 
56     uint256 c = _a * _b;
57     require(c / _a == _b);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Adds two numbers, reverts on overflow.
64   */
65   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     uint256 c = _a + _b;
67     require(c >= _a);
68 
69     return c;
70   }
71   
72   /**
73     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74     */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82 }
83 
84 contract Ownable {
85   address public owner;
86 
87   event OwnershipTransferred(
88     address indexed previousOwner,
89     address indexed newOwner
90   );
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   constructor() internal {
97     owner = msg.sender;
98     emit OwnershipTransferred(address(0), owner);
99   }
100 
101   /**
102    * @return the address of the owner.
103    */
104   function owner() public view returns(address) {
105     return owner;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(isOwner());
113     _;
114   }
115 
116   /**
117    * @return true if `msg.sender` is the owner of the contract.
118    */
119   function isOwner() public view returns(bool) {
120     return msg.sender == owner;
121   }
122 
123   /**
124    * @dev Allows the current owner to relinquish control of the contract.
125    * @notice Renouncing to ownership will leave the contract without an owner.
126    * It will not be possible to call the functions with the `onlyOwner`
127    * modifier anymore.
128    */
129   function renounceOwnership() public onlyOwner {
130     emit OwnershipTransferred(owner, address(0));
131     owner = address(0);
132   }
133 }
134 
135 //шаблон контракта 
136 contract distribution is Ownable {
137     using SafeMath for uint;
138     
139     uint public currentPaymentIndex = 0;
140     uint public depositorsCount;
141     uint public amountForDistribution = 0;
142     uint public amountRaised = 0;
143     
144     struct Deposite {
145         address depositor;
146         uint amount;
147         uint depositeTime;
148         uint paimentTime;
149     }
150     
151     Deposite[] public deposites;
152 
153     mapping ( address => uint[]) public depositors;
154     
155     function getAllDepositesCount() public view returns (uint) ;
156     
157     function getLastDepositId() public view returns (uint) ;
158 
159     function getDeposit(uint _id) public view returns (address, uint, uint, uint);
160 }
161 
162 contract FromResponsibleInvestors is Ownable {
163     using Percent for Percent.percent;
164     using SafeMath for uint;
165     using Math for uint;
166     
167     //Address for advertising and admins expences
168     address constant public advertisingAddress = address(0x43571AfEA3c3c6F02569bdC59325F4f95463014d); //test wallet
169     address constant public adminsAddress = address(0x8008BD6FdDF2C26382B4c19d714A1BfeA317ec57); //test wallet
170     
171     //Percent for promo expences
172     Percent.percent private m_adminsPercent = Percent.percent(3, 100);       //   3/100  *100% = 3%
173     Percent.percent private m_advertisingPercent = Percent.percent(5, 100);// 5/100  *100% = 5%
174     //How many percent for your deposit to be multiplied
175     Percent.percent public MULTIPLIER = Percent.percent(120, 100); // 120/100 * 100% = 120%
176     
177     //flag for end migration deposits from oldContract
178     bool public migrationFinished = false; 
179     
180     uint public amountRaised = 0;
181     uint public advertAmountRaised = 0; //for advertising all
182     //The deposit structure holds all the info about the deposit made
183     struct Deposit {
184         address depositor; //The depositor address
185         uint deposit;   //The deposit amount
186         uint expects;    //How much we should pay out (initially it is 120% of deposit)
187         uint paymentTime; //when payment
188     }
189 
190     Deposit[] private ImportedQueue;  //The queue for imported investments
191     Deposit[] private Queue;  //The queue for new investments
192     // list of deposites for 1 user
193     mapping(address => uint[]) public depositors;
194     
195     uint public depositorsCount = 0;
196     
197     uint public currentImportedReceiverIndex = 0; //The index of the first depositor in OldQueue. The receiver of investments!
198     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
199     
200     uint public minBalanceForDistribution = 24 ether; //первый минимально необходимый баланс должен быть достаточным для выплаты по 12 ETH из каждой очереди
201 
202     // more events for easy read from blockchain
203     event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
204     event LogImportInvestorsPartComplete(uint when, uint howmuch, uint lastIndex);
205     event LogNewInvestor(address indexed addr, uint when);
206 
207     constructor() public {
208     }
209 
210     //создаем депозит инвестора в основной очереди
211     function () public payable {
212         if(msg.value > 0){
213             require(msg.value >= 0.01 ether, "investment must be >= 0.01 ether"); //ограничение минимального депозита
214             require(msg.value <= 10 ether, "investment must be <= 10 ether"); //ограничение максимального депозита
215 
216             //к выплате 120% от депозита
217             uint expect = MULTIPLIER.mul(msg.value);
218             Queue.push(Deposit({depositor:msg.sender, deposit:msg.value, expects:expect, paymentTime:0}));
219             amountRaised += msg.value;
220             if (depositors[msg.sender].length == 0) depositorsCount += 1;
221             depositors[msg.sender].push(Queue.length - 1);
222             
223             uint advertperc = m_advertisingPercent.mul(msg.value);
224             advertisingAddress.send(advertperc);
225             adminsAddress.send(m_adminsPercent.mul(msg.value));
226             advertAmountRaised += advertperc;
227         } 
228     }
229 
230     //выплаты инвесторам
231     //в каждой транзакции выплачивается не менее 1 депозита из каждой очереди, но не более 100 выплат из каждой очереди.
232     function distribute(uint maxIterations) public {
233         require(maxIterations <= 100, "no more than 100 iterations"); //ограничение в 100 итераций максимум
234         uint money = address(this).balance;
235         require(money >= minBalanceForDistribution, "Not enough funds to pay");//на балансе недостаточно денег для выплат
236         uint ImportedQueueLen = ImportedQueue.length;
237         uint QueueLen = Queue.length;
238         uint toSend = 0;
239         maxIterations = maxIterations.max(5);//минимум 5 итераций
240         
241         for (uint i = 0; i < maxIterations; i++) {
242             if (currentImportedReceiverIndex < ImportedQueueLen){
243                 toSend = ImportedQueue[currentImportedReceiverIndex].expects;
244                 if (money >= toSend){
245                     money = money.sub(toSend);
246                     ImportedQueue[currentImportedReceiverIndex].paymentTime = now;
247                     ImportedQueue[currentImportedReceiverIndex].depositor.send(toSend);
248                     currentImportedReceiverIndex += 1;
249                 }
250             }
251             if (currentReceiverIndex < QueueLen){
252                 toSend = Queue[currentReceiverIndex].expects;
253                 if (money >= toSend){
254                     money = money.sub(toSend);
255                     Queue[currentReceiverIndex].paymentTime = now;
256                     Queue[currentReceiverIndex].depositor.send(toSend);
257                     currentReceiverIndex += 1;
258                 }
259             }
260         }
261         setMinBalanceForDistribution();
262     }
263     //пересчитываем минимально необходимый баланс для выплат по одному депозиту из каждой очереди.
264     function setMinBalanceForDistribution() private {
265         uint importedExpects = 0;
266         
267         if (currentImportedReceiverIndex < ImportedQueue.length) {
268             importedExpects = ImportedQueue[currentImportedReceiverIndex].expects;
269         } 
270         
271         if (currentReceiverIndex < Queue.length) {
272             minBalanceForDistribution = Queue[currentReceiverIndex].expects;
273         } else {
274             minBalanceForDistribution = 12 ether; //максимально возможная выплата основной очереди
275         }
276         
277         if (importedExpects > 0){
278             minBalanceForDistribution = minBalanceForDistribution.add(importedExpects);
279         }
280     }
281     
282     //перенос очереди из проекта MMM3.0Reload
283     function FromMMM30Reload(address _ImportContract, uint _from, uint _to) public onlyOwner {
284         require(!migrationFinished);
285         distribution ImportContract = distribution(_ImportContract);
286         
287         address depositor;
288         uint amount;
289         uint depositeTime;
290         uint paymentTime;
291         uint c = 0;
292         uint maxLen = ImportContract.getLastDepositId();
293         _to = _to.min(maxLen);
294         
295         for (uint i = _from; i <= _to; i++) {
296                 (depositor, amount, depositeTime, paymentTime) = ImportContract.getDeposit(i);
297                 //кошельки администрации проекта MMM3.0Reload исключаем из переноса
298                 if ((depositor != address(0x494A7A2D0599f2447487D7fA10BaEAfCB301c41B)) && 
299                     (depositor != address(0xFd3093a4A3bd68b46dB42B7E59e2d88c6D58A99E)) && 
300                     (depositor != address(0xBaa2CB97B6e28ef5c0A7b957398edf7Ab5F01A1B)) && 
301                     (depositor != address(0xFDd46866C279C90f463a08518e151bC78A1a5f38)) && 
302                     (depositor != address(0xdFa5662B5495E34C2aA8f06Feb358A6D90A6d62e))) {
303                     ImportedQueue.push(Deposit({depositor:depositor, deposit:uint(amount), expects:uint(MULTIPLIER.mul(amount)), paymentTime:0}));
304                     depositors[depositor].push(ImportedQueue.length - 1);
305                     c++;
306                 }
307         }
308         emit LogImportInvestorsPartComplete(now, c, _to);
309     }
310 
311     //после окончания переноса очереди - отказ от владения контрактом
312     function finishMigration() public onlyOwner {
313         migrationFinished = true;
314         renounceOwnership();
315     }
316 
317     //баланс контракта
318     function getBalance() public view returns (uint) {
319         return address(this).balance;
320     }
321     
322     //баланс кошелька рекламного бюджета
323     function getAdvertisingBalance() public view returns (uint) {
324         return advertisingAddress.balance;
325     }
326     
327     //Количество невыплаченных депозитов в основной очереди
328     function getDepositsCount() public view returns (uint) {
329         return Queue.length.sub(currentReceiverIndex);
330     }
331     
332     //Количество невыплаченных депозитов в перенесенной очереди
333     function getImportedDepositsCount() public view returns (uint) {
334         return ImportedQueue.length.sub(currentImportedReceiverIndex);
335     }
336     
337     //данные о депозите основной очереди по порядковому номеру 
338     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect, uint paymentTime){
339         Deposit storage dep = Queue[idx];
340         return (dep.depositor, dep.deposit, dep.expects, dep.paymentTime);
341     }
342     
343     //данные о депозите перенесенной очереди по порядковому номеру 
344     function getImportedDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect, uint paymentTime){
345         Deposit storage dep = ImportedQueue[idx];
346         return (dep.depositor, dep.deposit, dep.expects, dep.paymentTime);
347     }
348     
349     //Последний выплаченный депозит основной очереди, lastIndex - смещение номера в очереди (0 - последняя выплата, 1 - предпоследняя выплата)
350     function getLastPayments(uint lastIndex) public view returns (address, uint, uint) {
351         uint depositeIndex = currentReceiverIndex.sub(lastIndex).sub(1);
352         return (Queue[depositeIndex].depositor, Queue[depositeIndex].paymentTime, Queue[depositeIndex].expects);
353     }
354 
355     //Последний выплаченный депозит перенесенной очереди, lastIndex - смещение номера в очереди (0 - последняя выплата, 1 - предпоследняя выплата)
356     function getLastImportedPayments(uint lastIndex) public view returns (address, uint, uint) {
357         uint depositeIndex = currentImportedReceiverIndex.sub(lastIndex).sub(1);
358         return (ImportedQueue[depositeIndex].depositor, ImportedQueue[depositeIndex].paymentTime, ImportedQueue[depositeIndex].expects);
359     }
360 
361     //общее количество депозитов в основной очереди у кошелька depositor
362     function getUserDepositsCount(address depositor) public view returns (uint) {
363         uint c = 0;
364         for(uint i=0; i<Queue.length; ++i){
365             if(Queue[i].depositor == depositor)
366                 c++;
367         }
368         return c;
369     }
370     
371     //общее количество депозитов в перенесенной очереди у кошелька depositor
372     function getImportedUserDepositsCount(address depositor) public view returns (uint) {
373         uint c = 0;
374         for(uint i=0; i<ImportedQueue.length; ++i){
375             if(ImportedQueue[i].depositor == depositor)
376                 c++;
377         }
378         return c;
379     }
380 
381     //Все депозиты основной очереди кошелька depositor в виде массива
382     function getUserDeposits(address depositor) public view returns (uint[] idxs, uint[] paymentTime, uint[] amount, uint[] expects) {
383         uint c = getUserDepositsCount(depositor);
384 
385         idxs = new uint[](c);
386         paymentTime = new uint[](c);
387         expects = new uint[](c);
388         amount = new uint[](c);
389         uint num = 0;
390 
391         if(c > 0) {
392             uint j = 0;
393             for(uint i=0; i<c; ++i){
394                 num = depositors[depositor][i];
395                 Deposit storage dep = Queue[num];
396                 idxs[j] = i;
397                 paymentTime[j] = dep.paymentTime;
398                 amount[j] = dep.deposit;
399                 expects[j] = dep.expects;
400                 j++;
401             }
402         }
403     }
404     
405     //Все депозиты перенесенной очереди кошелька depositor в виде массива
406     function getImportedUserDeposits(address depositor) public view returns (uint[] idxs, uint[] paymentTime, uint[] amount, uint[] expects) {
407         uint c = getImportedUserDepositsCount(depositor);
408 
409         idxs = new uint[](c);
410         paymentTime = new uint[](c);
411         expects = new uint[](c);
412         amount = new uint[](c);
413 
414         if(c > 0) {
415             uint j = 0;
416             for(uint i=0; i<ImportedQueue.length; ++i){
417                 Deposit storage dep = ImportedQueue[i];
418                 if(dep.depositor == depositor){
419                     idxs[j] = i;
420                     paymentTime[j] = dep.paymentTime;
421                     amount[j] = dep.deposit;
422                     expects[j] = dep.expects;
423                     j++;
424                 }
425             }
426         }
427     }
428 }