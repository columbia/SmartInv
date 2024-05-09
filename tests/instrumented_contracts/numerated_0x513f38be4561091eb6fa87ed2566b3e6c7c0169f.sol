1 pragma solidity 0.5.9;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address payable public owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor () internal {
82         owner = msg.sender;
83         emit OwnershipTransferred(address(0), owner);
84     }
85 
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(isOwner());
92         _;
93     }
94 
95     /**
96      * @return true if `msg.sender` is the owner of the contract.
97      */
98     function isOwner() public view returns (bool) {
99         return msg.sender == owner;
100     }
101 
102     /**
103      * @dev Allows the current owner to transfer control of the contract to a newOwner.
104      * @param newOwner The address to transfer ownership to.
105      */
106     function transferOwnership(address payable newOwner) public onlyOwner {
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers control of the contract to a newOwner.
112      * @param newOwner The address to transfer ownership to.
113      */
114     function _transferOwnership(address payable newOwner) internal {
115         require(newOwner != address(0));
116         emit OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119 }
120 
121 contract Distripto is Ownable {
122 
123     using SafeMath for uint256;
124 
125     uint public minDeposit = 10000000000000000; // 0.01 eth
126     uint public maxDeposit = 1000000000000000000; // 1 eth
127     uint public minDistribute = 2 ether;
128     uint public currentPaymentIndex;
129     uint public amountForDistribution;
130     uint public percent = 120;
131 
132     uint public lastWinnerPeriod = 12 hours;
133 
134     uint public amountRaised;
135     uint public depositorsCount;
136 
137     address payable promoWallet;
138 
139     struct Deposit {
140         address payable depositor;
141         uint amount;
142         uint payout;
143         uint depositTime;
144         uint paymentTime;
145     }
146 
147     // list of all deposites
148     Deposit[] public deposits;
149     // list of user deposits
150     mapping (address => uint[]) public depositors;
151 
152     event OnDepositReceived(address investorAddress, uint value);
153     event OnPaymentSent(address investorAddress, uint value);
154 
155 
156     constructor () public {
157         promoWallet = msg.sender;
158     }
159 
160 
161     function () external payable {
162         if (msg.value > 0) {
163             makeDeposit();
164         } else {
165             distributeLast();
166             distribute(0);
167         }
168     }
169 
170 
171     function makeDeposit() internal {
172         require (msg.value >= minDeposit && msg.value <= maxDeposit);
173 
174         if (deposits.length > 0 && deposits[deposits.length - 1].depositTime + lastWinnerPeriod < now) {
175             distributeLast();
176         }
177 
178         Deposit memory newDeposit = Deposit(msg.sender, msg.value, msg.value.mul(percent).div(100), now, 0);
179         deposits.push(newDeposit);
180 
181         if (depositors[msg.sender].length == 0) depositorsCount += 1;
182 
183         depositors[msg.sender].push(deposits.length - 1);
184         amountForDistribution = amountForDistribution.add(msg.value);
185 
186         amountRaised = amountRaised.add(msg.value);
187 
188         emit OnDepositReceived(msg.sender, msg.value);
189     }
190 
191 
192     function distributeLast() public  {
193         if(deposits.length > 0 && deposits[deposits.length - 1].depositTime + lastWinnerPeriod < now) {
194             uint val = deposits[deposits.length - 1].amount.mul(10).div(100);
195             if (address(this).balance >= deposits[deposits.length - 1].payout + val) {
196                 if (deposits[deposits.length - 1].paymentTime == 0) {
197                     deposits[deposits.length - 1].paymentTime = now;
198                     promoWallet.transfer(val);
199                     deposits[deposits.length - 1].depositor.send(deposits[deposits.length - 1].payout);
200                     emit OnPaymentSent(deposits[deposits.length - 1].depositor, deposits[deposits.length - 1].payout);
201                 }
202             }
203         }
204     }
205 
206 
207     function distribute(uint _iterations) public  {
208         if (address(this).balance >= minDistribute) {
209             promoWallet.transfer(amountForDistribution.mul(10).div(100));
210 
211             _iterations = _iterations == 0 ? deposits.length : _iterations;
212 
213             for (uint i = currentPaymentIndex; i < _iterations && address(this).balance >= deposits[i].payout; i++) {
214                 if (deposits[i].paymentTime == 0) {
215                     deposits[i].paymentTime = now;
216                     deposits[i].depositor.send(deposits[i].payout);
217                     emit OnPaymentSent(deposits[i].depositor, deposits[i].payout);
218                 }
219 
220                 currentPaymentIndex += 1;
221             }
222 
223             amountForDistribution = 0;
224         }
225     }
226 
227 
228     function getDepositsCount() public view returns (uint) {
229         return deposits.length;
230     }
231 
232     function lastDepositId() public view returns (uint) {
233         return deposits.length - 1;
234     }
235 
236     function getDeposit(uint _id) public view returns (address, uint, uint, uint, uint){
237         return (deposits[_id].depositor, deposits[_id].amount, deposits[_id].payout,
238         deposits[_id].depositTime, deposits[_id].paymentTime);
239     }
240 
241     function getUserDepositsCount(address depositor) public view returns (uint) {
242         return depositors[depositor].length;
243     }
244 
245     // lastIndex from the end of payments lest (0 - last payment), returns: address of depositor, payment time, payment amount
246     function getLastPayments(uint lastIndex) public view returns (address, uint, uint, uint, uint) {
247         uint depositIndex = currentPaymentIndex.sub(lastIndex + 1);
248 
249         return (deposits[depositIndex].depositor,
250         deposits[depositIndex].amount,
251         deposits[depositIndex].payout,
252         deposits[depositIndex].depositTime,
253         deposits[depositIndex].paymentTime);
254     }
255 
256     function getUserDeposit(address depositor, uint depositNumber) public view returns(uint, uint, uint, uint) {
257         return (deposits[depositors[depositor][depositNumber]].amount,
258         deposits[depositors[depositor][depositNumber]].payout,
259         deposits[depositors[depositor][depositNumber]].depositTime,
260         deposits[depositors[depositor][depositNumber]].paymentTime);
261     }
262 
263 
264     function setNewMinDeposit(uint newMinDeposit) public onlyOwner {
265         minDeposit = newMinDeposit;
266     }
267 
268     function setNewMaxDeposit(uint newMaxDeposit) public onlyOwner {
269         maxDeposit = newMaxDeposit;
270     }
271 
272     function setPromoWallet(address payable newPromoWallet) public onlyOwner {
273         require (newPromoWallet != address(0));
274         promoWallet = newPromoWallet;
275     }
276 }