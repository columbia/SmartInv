1 /*
2   8888888 .d8888b.   .d88888b.   .d8888b.  888                     888                 888      
3     888  d88P  Y88b d88P" "Y88b d88P  Y88b 888                     888                 888      
4     888  888    888 888     888 Y88b.      888                     888                 888      
5     888  888        888     888  "Y888b.   888888  8888b.  888d888 888888      .d8888b 88888b.  
6     888  888        888     888     "Y88b. 888        "88b 888P"   888        d88P"    888 "88b 
7     888  888    888 888     888       "888 888    .d888888 888     888        888      888  888 
8     888  Y88b  d88P Y88b. .d88P Y88b  d88P Y88b.  888  888 888     Y88b.  d8b Y88b.    888  888 
9   8888888 "Y8888P"   "Y88888P"   "Y8888P"   "Y888 "Y888888 888      "Y888 Y8P  "Y8888P 888  888 
10 
11   Rocket startup for your ICO
12 
13   The innovative platform to create your initial coin offering (ICO) simply, safely and professionally.
14   All the services your project needs: KYC, AI Audit, Smart contract wizard, Legal template,
15   Master Nodes management, on a single SaaS platform!
16 */
17 pragma solidity ^0.4.21;
18 
19 // File: contracts\zeppelin-solidity\contracts\ownership\Ownable.sol
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27   address public owner;
28 
29 
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() public {
38     owner = msg.sender;
39   }
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 // File: contracts\zeppelin-solidity\contracts\lifecycle\Pausable.sol
62 
63 /**
64  * @title Pausable
65  * @dev Base contract which allows children to implement an emergency stop mechanism.
66  */
67 contract Pausable is Ownable {
68   event Pause();
69   event Unpause();
70 
71   bool public paused = false;
72 
73 
74   /**
75    * @dev Modifier to make a function callable only when the contract is not paused.
76    */
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is paused.
84    */
85   modifier whenPaused() {
86     require(paused);
87     _;
88   }
89 
90   /**
91    * @dev called by the owner to pause, triggers stopped state
92    */
93   function pause() onlyOwner whenNotPaused public {
94     paused = true;
95     emit Pause();
96   }
97 
98   /**
99    * @dev called by the owner to unpause, returns to normal state
100    */
101   function unpause() onlyOwner whenPaused public {
102     paused = false;
103     emit Unpause();
104   }
105 }
106 
107 // File: contracts\zeppelin-solidity\contracts\math\SafeMath.sol
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114 
115   /**
116   * @dev Multiplies two numbers, throws on overflow.
117   */
118   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119     if (a == 0) {
120       return 0;
121     }
122     uint256 c = a * b;
123     assert(c / a == b);
124     return c;
125   }
126 
127   /**
128   * @dev Integer division of two numbers, truncating the quotient.
129   */
130   function div(uint256 a, uint256 b) internal pure returns (uint256) {
131     // assert(b > 0); // Solidity automatically throws when dividing by 0
132     uint256 c = a / b;
133     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134     return c;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     assert(b <= a);
142     return a - b;
143   }
144 
145   /**
146   * @dev Adds two numbers, throws on overflow.
147   */
148   function add(uint256 a, uint256 b) internal pure returns (uint256) {
149     uint256 c = a + b;
150     assert(c >= a);
151     return c;
152   }
153 }
154 
155 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
156 
157 /**
158  * @title ERC20Basic
159  * @dev Simpler version of ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/179
161  */
162 contract ERC20Basic {
163   function totalSupply() public view returns (uint256);
164   function balanceOf(address who) public view returns (uint256);
165   function transfer(address to, uint256 value) public returns (bool);
166   event Transfer(address indexed from, address indexed to, uint256 value);
167 }
168 
169 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address owner, address spender) public view returns (uint256);
177   function transferFrom(address from, address to, uint256 value) public returns (bool);
178   function approve(address spender, uint256 value) public returns (bool);
179   event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 // File: contracts\ICOStartReservation.sol
183 
184 contract ICOStartSaleInterface {
185   ERC20 public token;
186 }
187 
188 contract ICOStartReservation is Pausable {
189   using SafeMath for uint256;
190 
191   ICOStartSaleInterface public sale;
192   uint256 public cap;
193   uint8 public feePerc;
194   address public manager;
195   mapping(address => uint256) public deposits;
196   uint256 public weiCollected;
197   uint256 public tokensReceived;
198   bool public canceled;
199   bool public paid;
200 
201   event Deposited(address indexed depositor, uint256 amount);
202   event Withdrawn(address indexed beneficiary, uint256 amount);
203   event Paid(uint256 netAmount, uint256 fee);
204   event Canceled();
205 
206   function ICOStartReservation(ICOStartSaleInterface _sale, uint256 _cap, uint8 _feePerc, address _manager) public {
207     require(_sale != (address(0)));
208     require(_cap != 0);
209     require(_feePerc >= 0);
210     if (_feePerc != 0) {
211       require(_manager != 0x0);
212     }
213 
214     sale = _sale;
215     cap = _cap;
216     feePerc = _feePerc;
217     manager = _manager;
218   }
219 
220   /**
221    * @dev Modifier to make a function callable only when the contract is accepting
222    * deposits.
223    */
224   modifier whenOpen() {
225     require(isOpen());
226     _;
227   }
228 
229   /**
230    * @dev Modifier to make a function callable only if the reservation was not canceled.
231    */
232   modifier whenNotCanceled() {
233     require(!canceled);
234     _;
235   }
236 
237   /**
238    * @dev Modifier to make a function callable only if the reservation was canceled.
239    */
240   modifier whenCanceled() {
241     require(canceled);
242     _;
243   }
244 
245   /**
246    * @dev Modifier to make a function callable only if the reservation was not yet paid.
247    */
248   modifier whenNotPaid() {
249     require(!paid);
250     _;
251   }
252 
253   /**
254    * @dev Modifier to make a function callable only if the reservation was paid.
255    */
256   modifier whenPaid() {
257     require(paid);
258     _;
259   }
260 
261   /**
262    * @dev Checks whether the cap has been reached. 
263    * @return Whether the cap was reached
264    */
265   function capReached() public view returns (bool) {
266     return weiCollected >= cap;
267   }
268 
269   /**
270    * @dev A reference to the sale's token contract. 
271    * @return The token contract.
272    */
273   function getToken() public view returns (ERC20) {
274     return sale.token();
275   }
276 
277   /**
278    * @dev Modifier to make a function callable only when the contract is accepting
279    * deposits.
280    */
281   function isOpen() public view returns (bool) {
282     return !paused && !capReached() && !canceled && !paid;
283   }
284 
285   /**
286    * @dev Shortcut for deposit() and claimTokens() functions.
287    * Send 0 to claim, any other value to deposit.
288    */
289   function () external payable {
290     if (msg.value == 0) {
291       claimTokens(msg.sender);
292     } else {
293       deposit(msg.sender);
294     }
295   }
296 
297   /**
298    * @dev Deposit ethers in the contract keeping track of the sender.
299    * @param _depositor Address performing the purchase
300    */
301   function deposit(address _depositor) public whenOpen payable {
302     require(_depositor != address(0));
303     require(weiCollected.add(msg.value) <= cap);
304     deposits[_depositor] = deposits[_depositor].add(msg.value);
305     weiCollected = weiCollected.add(msg.value);
306     emit Deposited(_depositor, msg.value);
307   }
308 
309   /**
310    * @dev Allows the owner to cancel the reservation thus enabling withdraws.
311    * Contract must first be paused so we are sure we are not accepting deposits.
312    */
313   function cancel() public onlyOwner whenPaused whenNotPaid {
314     canceled = true;
315   }
316 
317   /**
318    * @dev Allows the owner to cancel the reservation thus enabling withdraws.
319    * Contract must first be paused so we are sure we are not accepting deposits.
320    */
321   function pay() public onlyOwner whenNotCanceled {
322     require(weiCollected > 0);
323   
324     uint256 fee;
325     uint256 netAmount;
326     (fee, netAmount) = _getFeeAndNetAmount(weiCollected);
327 
328     require(address(sale).call.value(netAmount)(this));
329     tokensReceived = getToken().balanceOf(this);
330 
331     if (fee != 0) {
332       manager.transfer(fee);
333     }
334 
335     paid = true;
336     emit Paid(netAmount, fee);
337   }
338 
339   /**
340    * @dev Allows a depositor to withdraw his contribution if the reservation was canceled.
341    */
342   function withdraw() public whenCanceled {
343     uint256 depositAmount = deposits[msg.sender];
344     require(depositAmount != 0);
345     deposits[msg.sender] = 0;
346     weiCollected = weiCollected.sub(depositAmount);
347     msg.sender.transfer(depositAmount);
348     emit Withdrawn(msg.sender, depositAmount);
349   }
350 
351   /**
352    * @dev After the reservation is paid, transfers tokens from the contract to the
353    * specified address (which must have deposited ethers earlier).
354    * @param _beneficiary Address that will receive the tokens.
355    */
356   function claimTokens(address _beneficiary) public whenPaid {
357     require(_beneficiary != address(0));
358     
359     uint256 depositAmount = deposits[_beneficiary];
360     if (depositAmount != 0) {
361       uint256 tokens = tokensReceived.mul(depositAmount).div(weiCollected);
362       assert(tokens != 0);
363       deposits[_beneficiary] = 0;
364       getToken().transfer(_beneficiary, tokens);
365     }
366   }
367 
368   /**
369    * @dev Emergency brake. Send all ethers and tokens to the owner.
370    */
371   function destroy() onlyOwner public {
372     uint256 myTokens = getToken().balanceOf(this);
373     if (myTokens != 0) {
374       getToken().transfer(owner, myTokens);
375     }
376     selfdestruct(owner);
377   }
378 
379   /*
380    * Internal functions
381    */
382 
383   /**
384    * @dev Returns the current period, or null.
385    */
386    function _getFeeAndNetAmount(uint256 _grossAmount) internal view returns (uint256 _fee, uint256 _netAmount) {
387       _fee = _grossAmount.div(100).mul(feePerc);
388       _netAmount = _grossAmount.sub(_fee);
389    }
390 }