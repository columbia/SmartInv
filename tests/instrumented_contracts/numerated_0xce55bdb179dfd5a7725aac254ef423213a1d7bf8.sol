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
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that revert on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, reverts on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     uint256 c = a * b;
95     require(c / a == b);
96 
97     return c;
98   }
99 
100   /**
101   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
102   */
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b > 0); // Solidity only automatically asserts when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108     return c;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     require(b <= a);
116     uint256 c = a - b;
117 
118     return c;
119   }
120 
121   /**
122   * @dev Adds two numbers, reverts on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     require(c >= a);
127 
128     return c;
129   }
130 
131   /**
132   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
133   * reverts when dividing by zero.
134   */
135   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136     require(b != 0);
137     return a % b;
138   }
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
175     mapping ( address => uint[]) public depositors;
176     
177     modifier onlyDistributor () {
178         require (msg.sender == distributorWallet);
179         _;
180     }
181     
182     function setDistributorAddress(address newDistributorAddress) public onlyOwner {
183         require (newDistributorAddress!=address(0));
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
202         require (newPromoWallet != address(0));
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
216     function isContract(address addr) public view returns (bool) {
217         uint size;
218         assembly { size := extcodesize(addr) }
219         return size > 0;
220     }
221 
222 
223     function () public payable {
224         require ( (msg.value >= minDeposite) && (msg.value <= maxDeposite) );
225         require ( !isContract(msg.sender) );
226         Deposite memory newDeposite = Deposite(msg.sender, msg.value, now, 0);
227         deposites.push(newDeposite);
228         if (depositors[msg.sender].length == 0) depositorsCount+=1;
229         depositors[msg.sender].push(deposites.length - 1);
230         amountForDistribution = amountForDistribution.add(msg.value);
231         amountRaised = amountRaised.add(msg.value);
232         
233         emit OnDepositeReceived(msg.sender,msg.value);
234     }
235     
236     function addMigrateBalance() public payable onlyOwner {
237     }
238     
239     function migrateDeposite (address _oldContract, uint _from, uint _to) public onlyOwner {
240         require(!migrationFinished);
241         distribution oldContract = distribution(_oldContract);
242 
243         address depositor;
244         uint amount;
245         uint depositeTime;
246         uint paimentTime;
247 
248         for (uint i = _from; i <= _to; i++) {
249             (depositor, amount, depositeTime, paimentTime) = oldContract.getDeposit(i);
250             if (!isContract(depositor)) {
251                 Deposite memory newDeposite = Deposite(depositor, amount, depositeTime, paimentTime);
252                 deposites.push(newDeposite);
253                 depositors[msg.sender].push(deposites.length - 1);
254             }
255         }
256     }
257     
258     function finishMigration() onlyOwner public {
259         migrationFinished = true;
260     }
261     
262     function distribute (uint numIterations) public onlyDistributor {
263         
264         promoWallet.transfer(amountForDistribution.mul(6).div(100));
265         distributorWallet.transfer(amountForDistribution.mul(1).div(100));
266         wallet1.transfer(amountForDistribution.mul(1).div(100));
267         wallet2.transfer(amountForDistribution.mul(1).div(100));
268         wallet3.transfer(amountForDistribution.mul(1).div(100));
269         
270         uint i = 0;
271         uint toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);    // 120% of user deposite
272         
273         while ( (i <= numIterations) && ( address(this).balance > toSend)  ) {
274             deposites[currentPaymentIndex].depositor.transfer(toSend);
275             deposites[currentPaymentIndex].paimentTime = now;
276             emit OnPaymentSent(deposites[currentPaymentIndex].depositor,toSend);
277             
278             //amountForDistribution = amountForDistribution.sub(toSend);
279             currentPaymentIndex = currentPaymentIndex.add(1);
280             i = i.add(1);
281             toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);    // 120% of user deposite
282         }
283         
284         amountForDistribution = 0;
285     }
286     
287     // get all depositors count
288     function getAllDepositorsCount() public view returns(uint) {
289         return depositorsCount;
290     }
291     
292     function getAllDepositesCount() public view returns (uint) {
293         return deposites.length;
294     }
295 
296     function getLastDepositId() public view returns (uint) {
297         return deposites.length - 1;
298     }
299 
300     function getDeposit(uint _id) public view returns (address, uint, uint, uint){
301         return (deposites[_id].depositor, deposites[_id].amount, deposites[_id].depositeTime, deposites[_id].paimentTime);
302     }
303 
304     // get count of deposites for 1 user
305     function getDepositesCount(address depositor) public view returns (uint) {
306         return depositors[depositor].length;
307     }
308     
309     // how much raised
310     function getAmountRaised() public view returns (uint) {
311         return amountRaised;
312     }
313     
314     // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount
315     function getLastPayments(uint lastIndex) public view returns (address, uint, uint) {
316         uint depositeIndex = currentPaymentIndex.sub(lastIndex).sub(1);
317         require ( depositeIndex >= 0 );
318         return ( deposites[depositeIndex].depositor , deposites[depositeIndex].paimentTime , deposites[depositeIndex].amount.mul(percent).div(100) );
319     }
320 
321     function getUserDeposit(address depositor, uint depositeNumber) public view returns(uint, uint, uint) {
322         return (deposites[depositors[depositor][depositeNumber]].amount,
323                 deposites[depositors[depositor][depositeNumber]].depositeTime,
324                 deposites[depositors[depositor][depositeNumber]].paimentTime);
325     }
326 
327 
328     function getDepositeTime(address depositor, uint depositeNumber) public view returns(uint) {
329         return deposites[depositors[depositor][depositeNumber]].depositeTime;
330     }
331     
332     function getPaimentTime(address depositor, uint depositeNumber) public view returns(uint) {
333         return deposites[depositors[depositor][depositeNumber]].paimentTime;
334     }
335     
336     function getPaimentStatus(address depositor, uint depositeNumber) public view returns(bool) {
337         if ( deposites[depositors[depositor][depositeNumber]].paimentTime == 0 ) return false;
338         else return true;
339     }
340 }