1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 // File: zeppelin/contracts/ownership/Ownable.sol
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 // File: zeppelin/contracts/token/ERC20Basic.sol
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public constant returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 // File: zeppelin/contracts/token/BasicToken.sol
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 // File: zeppelin/contracts/token/ERC20.sol
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public constant returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 // File: zeppelin/contracts/token/StandardToken.sol
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165 
166     uint256 _allowance = allowed[_from][msg.sender];
167 
168     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
169     // require (_value <= _allowance);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = _allowance.sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    */
210   function increaseApproval (address _spender, uint _addedValue)
211     returns (bool success) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval (address _spender, uint _subtractedValue)
218     returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 // File: contracts/EpigenCareCrowdsale.sol
232 
233 contract EpigenCareCrowdsale is Ownable {
234   using SafeMath for uint256;
235 
236   StandardToken public token;
237 
238   uint256 public startTime;
239   uint256 public endTime;
240   address public wallet;
241   address public tokenPool;
242   uint256 public rate;
243   uint256 public weiRaised;
244   uint256 public weiPending;
245   uint256 public tokensPending;
246   uint256 public minimumInvestment;
247 
248   mapping (address => Transaction) transactions;
249   mapping (address => bool) approvedAddresses;
250   mapping (address => bool) verifiers;
251 
252   struct Transaction { uint weiAmount; uint tokenAmount; }
253 
254   event TokenPurchaseRequest(address indexed purchaser, address indexed beneficiary, uint256 value);
255 
256   function EpigenCareCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _tokenPool, address _token) Ownable() {
257     require(_endTime >= _startTime);
258     require(_rate > 0);
259     require(_wallet != 0x0);
260     require(_tokenPool != 0x0);
261 
262     token = StandardToken(_token);
263     startTime = _startTime;
264     endTime = _endTime;
265     wallet = _wallet;
266     tokenPool = _tokenPool;
267 
268     verifiers[msg.sender] = true;
269     rate = _rate;
270     minimumInvestment = 0.5 ether;
271   }
272 
273   function () payable {
274     requestTokens(msg.sender);
275   }
276 
277   function requestTokens(address beneficiary) sufficientApproval(msg.value) public payable {
278     require(beneficiary != 0x0);
279     require(validPurchase());
280     require(msg.value >= minimumInvestment);
281 
282     uint256 weiAmount = msg.value;
283     uint256 tokens = weiAmount.mul(rate);
284 
285     if(approvedAddresses[beneficiary]) {
286       weiRaised = weiRaised.add(weiAmount);
287 
288       token.transferFrom(tokenPool, beneficiary, tokens);
289       wallet.transfer(weiAmount);
290     } else {
291       Transaction transaction = transactions[beneficiary];
292       transaction.weiAmount = transaction.weiAmount.add(weiAmount);
293       transaction.tokenAmount = transaction.tokenAmount.add(tokens);
294 
295       weiPending = weiPending.add(weiAmount);
296       tokensPending = tokensPending.add(tokens);
297       TokenPurchaseRequest(msg.sender, beneficiary, weiAmount);
298     }
299   }
300 
301   function validateTransaction(address purchaser) onlyVerifiers(msg.sender) {
302     Transaction transaction = transactions[purchaser];
303 
304     weiRaised = weiRaised.add(transaction.weiAmount);
305     weiPending = weiPending.sub(transaction.weiAmount);
306     tokensPending = tokensPending.sub(transaction.tokenAmount);
307     approvedAddresses[purchaser] = true;
308 
309     token.transferFrom(tokenPool, purchaser, transaction.tokenAmount);
310     wallet.transfer(transaction.weiAmount);
311     transaction.weiAmount = 0;
312     transaction.tokenAmount = 0;
313   }
314 
315   function pendingTransaction(address user) returns (uint value){
316     return transactions[user].weiAmount;
317   }
318 
319   function revokeRequest() {
320     Transaction transaction = transactions[msg.sender];
321     weiPending = weiPending.sub(transaction.weiAmount);
322     tokensPending = tokensPending.sub(transaction.tokenAmount);
323     msg.sender.transfer(transaction.weiAmount);
324     transaction.weiAmount = 0;
325     transaction.tokenAmount = 0;
326   }
327 
328   modifier sufficientApproval(uint value) {
329     uint tokensNeeded = tokensPending.add(value.mul(rate));
330     uint tokensAvailable = token.allowance(tokenPool, this);
331     require(tokensAvailable >= tokensNeeded);
332     _;
333   }
334 
335   function rejectRequest(address user, uint fee) onlyVerifiers(msg.sender) {
336     Transaction transaction = transactions[user];
337     weiPending = weiPending.sub(transaction.weiAmount);
338     tokensPending = tokensPending.sub(transaction.tokenAmount);
339     if(fee > 0) {
340       transaction.weiAmount = transaction.weiAmount.sub(fee);
341       wallet.transfer(fee);
342     }
343 
344     user.transfer(transaction.weiAmount);
345     transaction.weiAmount = 0;
346     transaction.tokenAmount = 0;
347   }
348 
349   function validPurchase() internal constant returns (bool) {
350     bool withinPeriod = (now >= startTime && now <= endTime);
351     bool nonZeroPurchase = msg.value != 0;
352     return (withinPeriod && nonZeroPurchase);
353   }
354 
355   function hasEnded() public constant returns (bool) {
356     return now > endTime;
357   }
358 
359   function updateMinimumInvestment(uint _minimumInvestment) onlyOwner {
360     minimumInvestment = _minimumInvestment;
361   }
362 
363   function updateRate(uint _rate) onlyOwner {
364     rate = _rate;
365   }
366 
367   function setVerifier(address verifier, bool value) onlyOwner {
368     verifiers[verifier] = value;
369   }
370 
371   function isValidated(address user) returns (bool) {
372     return approvedAddresses[user];
373   }
374 
375   modifier onlyVerifiers(address sender) {
376     require(verifiers[sender]);
377     _;
378   }
379 }