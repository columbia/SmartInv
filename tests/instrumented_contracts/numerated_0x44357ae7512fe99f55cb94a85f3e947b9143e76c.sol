1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that revert on error
79  */
80 library SafeMath {
81 
82     /**
83     * @dev Multiplies two numbers, reverts on overflow.
84     */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b);
95 
96         return c;
97     }
98 
99     /**
100     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
101     */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b > 0);
104         // Solidity only automatically asserts when dividing by 0
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
113     */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b <= a);
116         uint256 c = a - b;
117 
118         return c;
119     }
120 
121     /**
122     * @dev Adds two numbers, reverts on overflow.
123     */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a);
127 
128         return c;
129     }
130 
131     /**
132     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
133     * reverts when dividing by zero.
134     */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b != 0);
137         return a % b;
138     }
139 }
140 
141 contract distribution is Ownable {
142 
143     using SafeMath for uint256;
144 
145     event OnDepositeReceived(address investorAddress, uint value);
146     event OnPaymentSent(address investorAddress, uint value);
147 
148     uint public minDeposite = 10000000000000000; // 0.01 eth
149     uint public maxDeposite = 10000000000000000000000; // 10000 eth
150     uint public currentPaymentIndex = 0;
151     uint public amountForDistribution = 0;
152     uint public percent = 120;
153 
154     // migration data from old contract - 0x65dfE1db61f1AC75Ed8bCCCc18E6e90c04b95dE2
155     bool public migrationFinished = false;
156     uint public amountRaised = 3295255217937131845260;
157     uint public depositorsCount = 285;
158 
159     address distributorWallet;    // wallet for initialize distribution
160     address promoWallet;
161     address wallet1;
162     address wallet2;
163     address wallet3;
164 
165     struct Deposite {
166         address depositor;
167         uint amount;
168         uint depositeTime;
169         uint paimentTime;
170     }
171 
172     // list of all deposites
173     Deposite[] public deposites;
174     // list of deposites for 1 user
175     mapping(address => uint[]) public depositors;
176 
177     modifier onlyDistributor () {
178         require(msg.sender == distributorWallet);
179         _;
180     }
181 
182     function setDistributorAddress(address newDistributorAddress) public onlyOwner {
183         require(newDistributorAddress != address(0));
184         distributorWallet = newDistributorAddress;
185     }
186 
187     function setNewMinDeposite(uint newMinDeposite) public onlyOwner {
188         minDeposite = newMinDeposite;
189     }
190 
191     function setNewMaxDeposite(uint newMaxDeposite) public onlyOwner {
192         maxDeposite = newMaxDeposite;
193     }
194 
195     function setNewWallets(address newWallet1, address newWallet2, address newWallet3) public onlyOwner {
196         wallet1 = newWallet1;
197         wallet2 = newWallet2;
198         wallet3 = newWallet3;
199     }
200 
201     function setPromoWallet(address newPromoWallet) public onlyOwner {
202         require(newPromoWallet != address(0));
203         promoWallet = newPromoWallet;
204     }
205 
206 
207     constructor () public {
208         distributorWallet = address(0x494A7A2D0599f2447487D7fA10BaEAfCB301c41B);
209         promoWallet = address(0xFd3093a4A3bd68b46dB42B7E59e2d88c6D58A99E);
210         wallet1 = address(0xBaa2CB97B6e28ef5c0A7b957398edf7Ab5F01A1B);
211         wallet2 = address(0xFDd46866C279C90f463a08518e151bC78A1a5f38);
212         wallet3 = address(0xdFa5662B5495E34C2aA8f06Feb358A6D90A6d62e);
213 
214     }
215 
216     function() public payable {
217         require((msg.value >= minDeposite) && (msg.value <= maxDeposite));
218         Deposite memory newDeposite = Deposite(msg.sender, msg.value, now, 0);
219         deposites.push(newDeposite);
220         if (depositors[msg.sender].length == 0) depositorsCount += 1;
221         depositors[msg.sender].push(deposites.length - 1);
222         amountForDistribution = amountForDistribution.add(msg.value);
223         amountRaised = amountRaised.add(msg.value);
224 
225         emit OnDepositeReceived(msg.sender, msg.value);
226     }
227 
228     function addMigrateBalance() public payable onlyOwner {
229     }
230 
231     function migrateDeposite(address _oldContract, uint _from, uint _to) public onlyOwner {
232         require(!migrationFinished);
233         distribution oldContract = distribution(_oldContract);
234 
235         address depositor;
236         uint amount;
237         uint depositeTime;
238         uint paimentTime;
239 
240         for (uint i = _from; i <= _to; i++) {
241             (depositor, amount, depositeTime, paimentTime) = oldContract.getDeposit(i);
242             
243             Deposite memory newDeposite = Deposite(depositor, amount, depositeTime, paimentTime);
244             deposites.push(newDeposite);
245             depositors[depositor].push(deposites.length - 1);
246         }
247     }
248 
249     function finishMigration() onlyOwner public {
250         migrationFinished = true;
251     }
252 
253     function distribute(uint numIterations) public onlyDistributor {
254 
255         promoWallet.transfer(amountForDistribution.mul(6).div(100));
256         distributorWallet.transfer(amountForDistribution.mul(1).div(100));
257         wallet1.transfer(amountForDistribution.mul(1).div(100));
258         wallet2.transfer(amountForDistribution.mul(1).div(100));
259         wallet3.transfer(amountForDistribution.mul(1).div(100));
260 
261         uint i = 0;
262         uint toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);
263         // 120% of user deposite
264 
265         while ((i <= numIterations) && (address(this).balance > toSend)) {
266         	//We use send here to avoid blocking the queue by malicious contracts
267         	//It will never fail on ordinary addresses. It should not fail on valid multisigs
268         	//If it fails - it will fails on not legitimate contracts only so we will just proceed further
269             deposites[currentPaymentIndex].depositor.send(toSend);
270             deposites[currentPaymentIndex].paimentTime = now;
271             emit OnPaymentSent(deposites[currentPaymentIndex].depositor, toSend);
272 
273             //amountForDistribution = amountForDistribution.sub(toSend);
274             currentPaymentIndex = currentPaymentIndex.add(1);
275             i = i.add(1);
276             
277             //We should not go beyond the deposites boundary at any circumstances!
278             //Even if balance permits it
279             //If numIterations allow that, we will fail on the next iteration, 
280             //but it can be fixed by calling distribute with lesser numIterations
281             if(currentPaymentIndex < deposites.length)
282                 toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);
283                 // 120% of user deposite
284         }
285 
286         amountForDistribution = 0;
287     }
288 
289     // get all depositors count
290     function getAllDepositorsCount() public view returns (uint) {
291         return depositorsCount;
292     }
293 
294     function getAllDepositesCount() public view returns (uint) {
295         return deposites.length;
296     }
297 
298     function getLastDepositId() public view returns (uint) {
299         return deposites.length - 1;
300     }
301 
302     function getDeposit(uint _id) public view returns (address, uint, uint, uint){
303         return (deposites[_id].depositor, deposites[_id].amount, deposites[_id].depositeTime, deposites[_id].paimentTime);
304     }
305 
306     // get count of deposites for 1 user
307     function getDepositesCount(address depositor) public view returns (uint) {
308         return depositors[depositor].length;
309     }
310 
311     // how much raised
312     function getAmountRaised() public view returns (uint) {
313         return amountRaised;
314     }
315 
316     // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount
317     function getLastPayments(uint lastIndex) public view returns (address, uint, uint) {
318         uint depositeIndex = currentPaymentIndex.sub(lastIndex).sub(1);
319         require(depositeIndex >= 0);
320         return (deposites[depositeIndex].depositor, deposites[depositeIndex].paimentTime, deposites[depositeIndex].amount.mul(percent).div(100));
321     }
322 
323     function getUserDeposit(address depositor, uint depositeNumber) public view returns (uint, uint, uint) {
324         return (deposites[depositors[depositor][depositeNumber]].amount,
325         deposites[depositors[depositor][depositeNumber]].depositeTime,
326         deposites[depositors[depositor][depositeNumber]].paimentTime);
327     }
328 
329 
330     function getDepositeTime(address depositor, uint depositeNumber) public view returns (uint) {
331         return deposites[depositors[depositor][depositeNumber]].depositeTime;
332     }
333 
334     function getPaimentTime(address depositor, uint depositeNumber) public view returns (uint) {
335         return deposites[depositors[depositor][depositeNumber]].paimentTime;
336     }
337 
338     function getPaimentStatus(address depositor, uint depositeNumber) public view returns (bool) {
339         if (deposites[depositors[depositor][depositeNumber]].paimentTime == 0) return false;
340         else return true;
341     }
342 }
343 
344 contract Blocker {
345     bool private stop = true;
346     address private owner = msg.sender;
347     
348     function () public payable {
349         if(msg.value > 0) {
350             require(!stop, "Do not accept money");
351         }
352     }
353     
354     function Blocker_resume(bool _stop) public{
355         require(msg.sender == owner);
356         stop = _stop;
357     }
358     
359     function Blocker_send(address to) public payable {
360         address buggycontract = to;
361         require(buggycontract.call.value(msg.value).gas(gasleft())());
362     }
363     
364     function Blocker_destroy() public {
365         require(msg.sender == owner);
366         selfdestruct(owner);
367     }
368 }