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
149     uint public maxDeposite = 10000000000000000000; // 10 eth
150     uint public currentPaymentIndex = 0;
151     uint public amountForDistribution = 0;
152     uint public percent = 120;
153     uint public amountRaised = 0;
154     uint public depositorsCount = 0;
155 
156     address distributorWallet;    // wallet for initialize distribution
157     address promoWallet;
158     address wallet1;
159     address wallet2;
160     address wallet3;
161 
162     struct Deposite {
163         address depositor;
164         uint amount;
165         uint depositeTime;
166         uint paimentTime;
167     }
168 
169     // list of all deposites
170     Deposite[] public deposites;
171     // list of deposites for 1 user
172     mapping(address => uint[]) public depositors;
173 
174     modifier onlyDistributor () {
175         require(msg.sender == distributorWallet);
176         _;
177     }
178 
179     function setDistributorAddress(address newDistributorAddress) public onlyOwner {
180         require(newDistributorAddress != address(0));
181         distributorWallet = newDistributorAddress;
182     }
183 
184     function setNewMinDeposite(uint newMinDeposite) public onlyOwner {
185         minDeposite = newMinDeposite;
186     }
187 
188     function setNewMaxDeposite(uint newMaxDeposite) public onlyOwner {
189         maxDeposite = newMaxDeposite;
190     }
191 
192     function setNewWallets(address newWallet1, address newWallet2, address newWallet3) public onlyOwner {
193         wallet1 = newWallet1;
194         wallet2 = newWallet2;
195         wallet3 = newWallet3;
196     }
197 
198     function setPromoWallet(address newPromoWallet) public onlyOwner {
199         require(newPromoWallet != address(0));
200         promoWallet = newPromoWallet;
201     }
202 
203 
204     constructor () public {
205         distributorWallet = address(0xcE9F27AFDd4C277c2B3895f6a9BEf580B85C0D92);
206         promoWallet = address(0xcE9F27AFDd4C277c2B3895f6a9BEf580B85C0D92);
207         wallet1 = address(0x263B6DB968A7a6518967b0e5be12F79F32686975);
208         wallet2 = address(0x1590C03F8B832c2eC7CE1cbBBc67c0302A1dFcAc);
209         wallet3 = address(0x7f1D4085a2fC8818ddA3cd582fe7E8841c6b32A1);
210 
211     }
212 
213     function() public payable {
214         require((msg.value >= minDeposite) && (msg.value <= maxDeposite));
215         Deposite memory newDeposite = Deposite(msg.sender, msg.value, now, 0);
216         deposites.push(newDeposite);
217         if (depositors[msg.sender].length == 0) depositorsCount += 1;
218         depositors[msg.sender].push(deposites.length - 1);
219         amountForDistribution = amountForDistribution.add(msg.value);
220         amountRaised = amountRaised.add(msg.value);
221 
222         emit OnDepositeReceived(msg.sender, msg.value);
223     }
224 
225 
226     function distribute(uint numIterations) public onlyDistributor {
227 
228         promoWallet.transfer(amountForDistribution.mul(6).div(100));
229         distributorWallet.transfer(amountForDistribution.mul(1).div(100));
230         wallet1.transfer(amountForDistribution.mul(1).div(100));
231         wallet2.transfer(amountForDistribution.mul(1).div(100));
232         wallet3.transfer(amountForDistribution.mul(1).div(100));
233 
234         uint i = 0;
235         uint toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);
236         // 120% of user deposite
237 
238         while ((i <= numIterations) && (address(this).balance > toSend)) {
239         	//We use send here to avoid blocking the queue by malicious contracts
240         	//It will never fail on ordinary addresses. It should not fail on valid multisigs
241         	//If it fails - it will fails on not legitimate contracts only so we will just proceed further
242             deposites[currentPaymentIndex].depositor.send(toSend);
243             deposites[currentPaymentIndex].paimentTime = now;
244             emit OnPaymentSent(deposites[currentPaymentIndex].depositor, toSend);
245 
246             //amountForDistribution = amountForDistribution.sub(toSend);
247             currentPaymentIndex = currentPaymentIndex.add(1);
248             i = i.add(1);
249             
250             //We should not go beyond the deposites boundary at any circumstances!
251             //Even if balance permits it
252             //If numIterations allow that, we will fail on the next iteration, 
253             //but it can be fixed by calling distribute with lesser numIterations
254             if(currentPaymentIndex < deposites.length)
255                 toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);
256                 // 120% of user deposite
257         }
258 
259         amountForDistribution = 0;
260     }
261 
262     // get all depositors count
263     function getAllDepositorsCount() public view returns (uint) {
264         return depositorsCount;
265     }
266 
267     function getAllDepositesCount() public view returns (uint) {
268         return deposites.length;
269     }
270 
271     function getLastDepositId() public view returns (uint) {
272         return deposites.length - 1;
273     }
274 
275     function getDeposit(uint _id) public view returns (address, uint, uint, uint){
276         return (deposites[_id].depositor, deposites[_id].amount, deposites[_id].depositeTime, deposites[_id].paimentTime);
277     }
278 
279     // get count of deposites for 1 user
280     function getDepositesCount(address depositor) public view returns (uint) {
281         return depositors[depositor].length;
282     }
283 
284     // how much raised
285     function getAmountRaised() public view returns (uint) {
286         return amountRaised;
287     }
288 
289     // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount
290     function getLastPayments(uint lastIndex) public view returns (address, uint, uint) {
291         uint depositeIndex = currentPaymentIndex.sub(lastIndex).sub(1);
292         require(depositeIndex >= 0);
293         return (deposites[depositeIndex].depositor, deposites[depositeIndex].paimentTime, deposites[depositeIndex].amount.mul(percent).div(100));
294     }
295 
296     function getUserDeposit(address depositor, uint depositeNumber) public view returns (uint, uint, uint) {
297         return (deposites[depositors[depositor][depositeNumber]].amount,
298         deposites[depositors[depositor][depositeNumber]].depositeTime,
299         deposites[depositors[depositor][depositeNumber]].paimentTime);
300     }
301 
302 
303     function getDepositeTime(address depositor, uint depositeNumber) public view returns (uint) {
304         return deposites[depositors[depositor][depositeNumber]].depositeTime;
305     }
306 
307     function getPaimentTime(address depositor, uint depositeNumber) public view returns (uint) {
308         return deposites[depositors[depositor][depositeNumber]].paimentTime;
309     }
310 
311     function getPaimentStatus(address depositor, uint depositeNumber) public view returns (bool) {
312         if (deposites[depositors[depositor][depositeNumber]].paimentTime == 0) return false;
313         else return true;
314     }
315 }
316 
317 contract Blocker {
318     bool private stop = true;
319     address private owner = msg.sender;
320     
321     function () public payable {
322         if(msg.value > 0) {
323             require(!stop, "Do not accept money");
324         }
325     }
326     
327     function Blocker_resume(bool _stop) public{
328         require(msg.sender == owner);
329         stop = _stop;
330     }
331     
332     function Blocker_send(address to) public payable {
333         address buggycontract = to;
334         require(buggycontract.call.value(msg.value).gas(gasleft())());
335     }
336     
337     function Blocker_destroy() public {
338         require(msg.sender == owner);
339         selfdestruct(owner);
340     }
341 }