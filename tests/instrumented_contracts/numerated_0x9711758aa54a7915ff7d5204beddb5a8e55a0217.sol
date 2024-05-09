1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender)
73     public view returns (uint256);
74 
75   function transferFrom(address from, address to, uint256 value)
76     public returns (bool);
77 
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(
80     address indexed owner,
81     address indexed spender,
82     uint256 value
83   );
84 }
85 
86 contract Erc20Wallet {
87   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
88 
89   event Deposit(address token, address user, uint amount, uint balance);
90   event Withdraw(address token, address user, uint amount, uint balance);
91 
92   mapping (address => uint) public totalDeposited;
93 
94   function() public {
95     revert();
96   }
97 
98   modifier onlyToken (address token) {
99     require( token != 0);
100     _;
101   }
102 
103   function commonDeposit(address token, uint value) internal {
104     tokens[token][msg.sender] += value;
105     totalDeposited[token] += value;
106     emit Deposit(
107       token,
108       msg.sender,
109       value,
110       tokens[token][msg.sender]);
111   }
112   function commonWithdraw(address token, uint value) internal {
113     require (tokens[token][msg.sender] >= value);
114     tokens[token][msg.sender] -= value;
115     totalDeposited[token] -= value;
116     require((token != 0)?
117       ERC20(token).transfer(msg.sender, value):
118       // solium-disable-next-line security/no-call-value
119       msg.sender.call.value(value)()
120     );
121     emit Withdraw(
122       token,
123       msg.sender,
124       value,
125       tokens[token][msg.sender]);
126   }
127 
128   function deposit() public payable {
129     commonDeposit(0, msg.value);
130   }
131   function withdraw(uint amount) public {
132     commonWithdraw(0, amount);
133   }
134 
135 
136   function depositToken(address token, uint amount) public onlyToken(token){
137     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
138     require (ERC20(token).transferFrom(msg.sender, this, amount));
139     commonDeposit(token, amount);
140   }
141   function withdrawToken(address token, uint amount) public {
142     commonWithdraw(token, amount);
143   }
144 
145   function balanceOf(address token, address user) public constant returns (uint) {
146     return tokens[token][user];
147   }
148 }
149 
150 
151 /**
152  * @title SplitERC20Payment
153  * @dev Base contract that supports multiple payees claiming funds sent to this contract
154  * according to the proportion they own.
155  */
156 contract SplitErc20Payment is Erc20Wallet{
157   using SafeMath for uint256;
158 
159   mapping (address => uint) public totalShares;
160   mapping (address => uint) public totalReleased;
161 
162   mapping (address => mapping (address => uint)) public shares; //mapping of token addresses to mapping of account balances (token=0 means Ether)
163   mapping (address => mapping (address => uint)) public released; //mapping of token addresses to mapping of account balances (token=0 means Ether)
164   address[] public payees;
165 
166   function withdrawToken(address, uint) public{
167     revert();
168   }
169   function withdraw(uint) public {
170     revert();
171   }
172 
173   function computePayeeBalance (address token, address payer, uint value) internal {
174     if (shares[token][payer] == 0)
175       addPayee(token, payer, value);
176     else
177       addToPayeeBalance(token, payer, value);
178   }
179 
180   function deposit() public payable{
181     super.deposit();
182     computePayeeBalance(0, msg.sender, msg.value);
183   }
184 
185   function depositToken(address token, uint amount) public{
186      super.depositToken(token, amount);
187      computePayeeBalance(token, msg.sender, amount);
188   }
189 
190   function executeClaim(address token, address payee, uint payment) internal {
191     require(payment != 0);
192     require(totalDeposited[token] >= payment);
193 
194     released[token][payee] += payment;
195     totalReleased[token] += payment;
196 
197     super.withdrawToken(token, payment);
198   }
199 
200   function calculateMaximumPayment(address token, address payee)view internal returns(uint){
201     require(shares[token][payee] > 0);
202     uint totalReceived = totalDeposited[token] + totalReleased[token];
203     return (totalReceived * shares[token][payee] / totalShares[token]) - released[token][payee];
204   }
205 
206   /**
207    * @dev Claim your share of the balance.
208    */
209   function claim(address token) public {
210     executeClaim(token, msg.sender, calculateMaximumPayment(token, msg.sender));
211   }
212 
213   /**
214    * @dev Claim part of your share of the balance.
215    */
216   function partialClaim(address token, uint payment) public {
217     uint maximumPayment = calculateMaximumPayment(token, msg.sender);
218 
219     require (payment <= maximumPayment);
220 
221     executeClaim(token, msg.sender, payment);
222   }
223 
224   /**
225    * @dev Add a new payee to the contract.
226    * @param _payee The address of the payee to add.
227    * @param _shares The number of shares owned by the payee.
228    */
229   function addPayee(address token, address _payee, uint256 _shares) internal {
230     require(_payee != address(0));
231     require(_shares > 0);
232     require(shares[token][_payee] == 0);
233 
234     payees.push(_payee);
235     shares[token][_payee] = _shares;
236     totalShares[token] += _shares;
237   }
238   /**
239    * @dev Add to payee balance
240    * @param _payee The address of the payee to add.
241    * @param _shares The number of shares to add to the payee.
242    */
243   function addToPayeeBalance(address token, address _payee, uint256 _shares) internal {
244     require(_payee != address(0));
245     require(_shares > 0);
246     require(shares[token][_payee] > 0);
247 
248     shares[token][_payee] += _shares;
249     totalShares[token] += _shares;
250   }
251 }
252 
253 /**
254  * @title Ownable
255  * @dev The Ownable contract has an owner address, and provides basic authorization control
256  * functions, this simplifies the implementation of "user permissions".
257  */
258 contract Ownable {
259   address public owner;
260 
261 
262   event OwnershipRenounced(address indexed previousOwner);
263   event OwnershipTransferred(
264     address indexed previousOwner,
265     address indexed newOwner
266   );
267 
268 
269   /**
270    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
271    * account.
272    */
273   constructor() public {
274     owner = msg.sender;
275   }
276 
277   /**
278    * @dev Throws if called by any account other than the owner.
279    */
280   modifier onlyOwner() {
281     require(msg.sender == owner);
282     _;
283   }
284 
285   /**
286    * @dev Allows the current owner to relinquish control of the contract.
287    */
288   function renounceOwnership() public onlyOwner {
289     emit OwnershipRenounced(owner);
290     owner = address(0);
291   }
292 
293   /**
294    * @dev Allows the current owner to transfer control of the contract to a newOwner.
295    * @param _newOwner The address to transfer ownership to.
296    */
297   function transferOwnership(address _newOwner) public onlyOwner {
298     _transferOwnership(_newOwner);
299   }
300 
301   /**
302    * @dev Transfers control of the contract to a newOwner.
303    * @param _newOwner The address to transfer ownership to.
304    */
305   function _transferOwnership(address _newOwner) internal {
306     require(_newOwner != address(0));
307     emit OwnershipTransferred(owner, _newOwner);
308     owner = _newOwner;
309   }
310 }
311 
312 
313 contract InvestmentRecordList is Ownable{
314     event NoRecordFound(InvestmentRecord _investmentRecord);
315 
316     InvestmentRecord[] internal investmentRecords;
317 
318     function getInvestmentRecord (uint index) public view returns (InvestmentRecord){
319         return investmentRecords[index];
320     }
321     function getInvestmentRecordListLength () public view returns (uint){
322         return investmentRecords.length;
323     }
324 
325     function pushRecord (InvestmentRecord _investmentRecord) onlyOwner public{
326         investmentRecords.push(_investmentRecord);
327     }
328 
329     function popRecord (InvestmentRecord _investmentRecord) onlyOwner public{
330         uint index;
331         bool foundRecord;
332         (index, foundRecord) = getIndex(_investmentRecord);
333         if (! foundRecord){
334             emit NoRecordFound(_investmentRecord);
335             revert();
336         }
337         InvestmentRecord recordToDelete = investmentRecords[investmentRecords.length-1];
338         investmentRecords[index] = recordToDelete;
339         delete recordToDelete;
340         investmentRecords.length--;
341     }
342 
343     function getIndex (InvestmentRecord _investmentRecord) public view returns (uint index, bool foundRecord){
344         foundRecord = false;
345         for (index = 0; index < investmentRecords.length; index++){
346             if (investmentRecords[index] == _investmentRecord){
347                 foundRecord = true;
348                 break;
349             }
350         }
351     }
352 }
353 
354 contract InvestmentRecord {
355     using SafeMath for uint256;
356 
357     address public token;
358     uint public timeStamp;
359     uint public lockPeriod;
360     uint public value;
361 
362     constructor (address _token, uint _timeStamp, uint _lockPeriod, uint _value) public{
363         token = _token;
364         timeStamp = _timeStamp;
365         lockPeriod = _lockPeriod;
366         value = _value;
367     }
368 
369     function expiredLockPeriod () public view returns (bool){
370         return now >= timeStamp + lockPeriod;
371     }
372 
373     function getValue () public view returns (uint){
374         return value;
375     }
376     
377     function getToken () public view returns (address){
378         return token;
379     }    
380 }
381 
382 
383 contract ERC20Vault is SplitErc20Payment{
384   using SafeMath for uint256;
385   mapping (address => InvestmentRecordList) public pendingInvestments;
386 
387   function withdrawToken(address, uint) public {
388     revert();
389   }
390 
391   function getLockedValue (address token) public returns (uint){
392     InvestmentRecordList investmentRecordList = pendingInvestments[msg.sender];
393     if (investmentRecordList == address(0x0))
394       return 0;
395 
396     uint lockedValue = 0;
397     for(uint8 i = 0; i < investmentRecordList.getInvestmentRecordListLength(); i++){
398       InvestmentRecord investmentRecord = investmentRecordList.getInvestmentRecord(i);
399       if (investmentRecord.getToken() == token){
400         if (investmentRecord.expiredLockPeriod()){
401             investmentRecordList.popRecord(investmentRecord);
402         }else{
403           uint valueToAdd = investmentRecord.getValue();
404           lockedValue += valueToAdd;
405         }
406       }
407     }
408     return lockedValue;
409   }
410   function claim(address token) public{
411     uint lockedValue = getLockedValue(token);
412     uint actualBalance = this.balanceOf(token, msg.sender);
413     require(actualBalance > lockedValue);
414 
415     super.partialClaim(token, actualBalance - lockedValue);
416   }
417 
418   function partialClaim(address token, uint payment) public{
419     uint lockedValue = getLockedValue(token);
420     uint actualBalance = this.balanceOf(token, msg.sender);
421     require(actualBalance - lockedValue >= payment);
422 
423     super.partialClaim(token, payment);
424   }
425 
426   function depositTokenToVault(address token, uint amount, uint lockPeriod) public{
427     if (pendingInvestments[msg.sender] == address(0x0)){
428       pendingInvestments[msg.sender] = new InvestmentRecordList();
429     }
430     super.depositToken(token, amount);
431     pendingInvestments[msg.sender].pushRecord(new InvestmentRecord(token, now, lockPeriod, amount));
432   }
433 }