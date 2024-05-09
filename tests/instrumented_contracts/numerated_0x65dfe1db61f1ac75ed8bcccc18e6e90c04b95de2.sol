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
20   constructor() public {
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
82   /**
83   * @dev Multiplies two numbers, reverts on overflow.
84   */
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87     // benefit is lost if 'b' is also tested.
88     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
89     if (a == 0) {
90       return 0;
91     }
92 
93     uint256 c = a * b;
94     require(c / a == b);
95 
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b > 0); // Solidity only automatically asserts when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107     return c;
108   }
109 
110   /**
111   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
112   */
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     require(b <= a);
115     uint256 c = a - b;
116 
117     return c;
118   }
119 
120   /**
121   * @dev Adds two numbers, reverts on overflow.
122   */
123   function add(uint256 a, uint256 b) internal pure returns (uint256) {
124     uint256 c = a + b;
125     require(c >= a);
126 
127     return c;
128   }
129 
130   /**
131   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
132   * reverts when dividing by zero.
133   */
134   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135     require(b != 0);
136     return a % b;
137   }
138 }
139 
140 contract distribution is Ownable {
141     
142     using SafeMath for uint256;
143     
144     event OnDepositeReceived(address investorAddress, uint value);
145     event OnPaymentSent(address investorAddress, uint value);
146     
147     uint public minDeposite = 10000000000000000; // 0.01 eth
148     uint public maxDeposite = 10000000000000000000000; // 10000 eth
149     uint public currentPaymentIndex = 0;
150     uint public amountForDistribution = 0;
151     uint public amountRaised;
152     uint public depositorsCount;
153     uint public percent = 120;
154     
155     address distributorWallet;    // wallet for initialize distribution
156     address promoWallet;    
157     address wallet1;
158     address wallet2;
159     address wallet3;
160     
161     struct Deposite {
162         address depositor;
163         uint amount;
164         uint depositeTime;
165         uint paimentTime;
166     }
167     
168     // list of all deposites
169     Deposite[] public deposites;
170     // list of deposites for 1 user
171     mapping ( address => uint[]) public depositors;
172     
173     modifier onlyDistributor () {
174         require (msg.sender == distributorWallet);
175         _;
176     }
177     
178     function setDistributorAddress(address newDistributorAddress) public onlyOwner {
179         require (newDistributorAddress!=address(0));
180         distributorWallet = newDistributorAddress;
181     }
182     
183     function setNewMinDeposite(uint newMinDeposite) public onlyOwner {
184         minDeposite = newMinDeposite;
185     }
186     
187     function setNewMaxDeposite(uint newMaxDeposite) public onlyOwner {
188         maxDeposite = newMaxDeposite;
189     }
190     
191     function setNewWallets(address newWallet1, address newWallet2, address newWallet3) public onlyOwner {
192         wallet1 = newWallet1;
193         wallet2 = newWallet2;
194         wallet3 = newWallet3;
195     }
196     
197     function setPromoWallet(address newPromoWallet) public onlyOwner {
198         require (newPromoWallet != address(0));
199         promoWallet = newPromoWallet;
200     }
201     
202 
203     constructor () public {
204         distributorWallet = address(0x494A7A2D0599f2447487D7fA10BaEAfCB301c41B);
205         promoWallet = address(0xFd3093a4A3bd68b46dB42B7E59e2d88c6D58A99E);
206         wallet1 = address(0xBaa2CB97B6e28ef5c0A7b957398edf7Ab5F01A1B);
207         wallet2 = address(0xFDd46866C279C90f463a08518e151bC78A1a5f38);
208         wallet3 = address(0xdFa5662B5495E34C2aA8f06Feb358A6D90A6d62e);
209         
210     }
211 
212 
213     function () public payable {
214         require ( (msg.value >= minDeposite) && (msg.value <= maxDeposite) );
215         Deposite memory newDeposite = Deposite(msg.sender, msg.value, now, 0);
216         deposites.push(newDeposite);
217         if (depositors[msg.sender].length == 0) depositorsCount+=1;
218         depositors[msg.sender].push(deposites.length - 1);
219         amountForDistribution = amountForDistribution.add(msg.value);
220         amountRaised = amountRaised.add(msg.value);
221         
222         emit OnDepositeReceived(msg.sender,msg.value);
223     }
224     
225     function distribute (uint numIterations) public onlyDistributor {
226         
227         promoWallet.transfer(amountForDistribution.mul(6).div(100));
228         distributorWallet.transfer(amountForDistribution.mul(1).div(100));
229         wallet1.transfer(amountForDistribution.mul(1).div(100));
230         wallet2.transfer(amountForDistribution.mul(1).div(100));
231         wallet3.transfer(amountForDistribution.mul(1).div(100));
232         
233         uint i = 0;
234         uint toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);    // 120% of user deposite
235         
236         while ( (i <= numIterations) && ( address(this).balance > toSend)  ) {
237             deposites[currentPaymentIndex].depositor.transfer(toSend);
238             deposites[currentPaymentIndex].paimentTime = now;
239             emit OnPaymentSent(deposites[currentPaymentIndex].depositor,toSend);
240             
241             //amountForDistribution = amountForDistribution.sub(toSend);
242             currentPaymentIndex = currentPaymentIndex.add(1);
243             i = i.add(1);
244             toSend = deposites[currentPaymentIndex].amount.mul(percent).div(100);    // 120% of user deposite
245         }
246         
247         amountForDistribution = 0;
248     }
249     
250     // get all depositors count
251     function getAllDepositorsCount() public view returns(uint) {
252         return depositorsCount;
253     }
254     
255     function getAllDepositesCount() public view returns (uint) {
256         return deposites.length;
257     }
258 
259     function getLastDepositId() public view returns (uint) {
260         return deposites.length - 1;
261     }
262 
263     function getDeposit(uint _id) public view returns (address, uint, uint, uint){
264         return (deposites[_id].depositor, deposites[_id].amount, deposites[_id].depositeTime, deposites[_id].paimentTime);
265     }
266 
267     // get count of deposites for 1 user
268     function getDepositesCount(address depositor) public view returns (uint) {
269         return depositors[depositor].length;
270     }
271     
272     // how much raised
273     function getAmountRaised() public view returns (uint) {
274         return amountRaised;
275     }
276     
277     // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount
278     function getLastPayments(uint lastIndex) public view returns (address, uint, uint) {
279         uint depositeIndex = currentPaymentIndex.sub(lastIndex).sub(1);
280         require ( depositeIndex >= 0 );
281         return ( deposites[depositeIndex].depositor , deposites[depositeIndex].paimentTime , deposites[depositeIndex].amount.mul(percent).div(100) );
282     }
283 
284     function getUserDeposit(address depositor, uint depositeNumber) public view returns(uint, uint, uint) {
285         return (deposites[depositors[depositor][depositeNumber]].amount,
286                 deposites[depositors[depositor][depositeNumber]].depositeTime,
287                 deposites[depositors[depositor][depositeNumber]].paimentTime);
288     }
289 
290 
291     function getDepositeTime(address depositor, uint depositeNumber) public view returns(uint) {
292         return deposites[depositors[depositor][depositeNumber]].depositeTime;
293     }
294     
295     function getPaimentTime(address depositor, uint depositeNumber) public view returns(uint) {
296         return deposites[depositors[depositor][depositeNumber]].paimentTime;
297     }
298     
299     function getPaimentStatus(address depositor, uint depositeNumber) public view returns(bool) {
300         if ( deposites[depositors[depositor][depositeNumber]].paimentTime == 0 ) return false;
301         else return true;
302     }
303 }