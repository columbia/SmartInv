1 pragma solidity ^0.4.19;
2 
3 /**
4  * This is the official Ethbet Token smart contract (EBET) - https://ethbet.io/
5  */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) constant returns (uint256);
46   function transfer(address to, uint256 value) returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) returns (bool) {
66     require(_to != address(0));
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) constant returns (uint256);
95   function transferFrom(address from, address to, uint256 value) returns (bool);
96   function approve(address spender, uint256 value) returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
120     require(_to != address(0));
121 
122     var _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) returns (bool) {
140 
141     // To change the approve amount you first have to reduce the addresses`
142     //  allowance to zero by calling `approve(_spender, 0)` if it is not
143     //  already 0 to mitigate the race condition described here:
144     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
146 
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Function to check the amount of tokens that an owner allowed to a spender.
154    * @param _owner address The address which owns the funds.
155    * @param _spender address The address which will spend the funds.
156    * @return A uint256 specifying the amount of tokens still available for the spender.
157    */
158   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
159     return allowed[_owner][_spender];
160   }
161 
162   /**
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    */
168   function increaseApproval (address _spender, uint _addedValue)
169     returns (bool success) {
170     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175   function decreaseApproval (address _spender, uint _subtractedValue)
176     returns (bool success) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187 }
188 
189 /**
190  * @title EthbetToken
191  */
192 contract EthbetToken is StandardToken {
193 
194   string public constant name = "Ethbet";
195   string public constant symbol = "EBET";
196   uint8 public constant decimals = 2; // only two deciminals, token cannot be divided past 1/100th
197 
198   uint256 public constant INITIAL_SUPPLY = 1000000000; // 10 million + 2 decimals
199 
200   /**
201    * @dev Contructor that gives msg.sender all of existing tokens.
202    */
203   function EthbetToken() {
204     totalSupply = INITIAL_SUPPLY;
205     balances[msg.sender] = INITIAL_SUPPLY;
206   }
207 }
208 
209 
210 // Import newer SafeMath version under new name to avoid conflict with the version included in EthbetToken
211 
212 // SafeMath Library https://github.com/OpenZeppelin/zeppelin-solidity/blob/49b42e86963df7192e7024e0e5bd30fa9d7ccbef/contracts/math/SafeMath.sol
213 
214 /**
215  * @title SafeMath
216  * @dev Math operations with safety checks that throw on error
217  */
218 library SafeMath2 {
219 
220   /**
221   * @dev Multiplies two numbers, throws on overflow.
222   */
223   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224     if (a == 0) {
225       return 0;
226     }
227     uint256 c = a * b;
228     assert(c / a == b);
229     return c;
230   }
231 
232   /**
233   * @dev Integer division of two numbers, truncating the quotient.
234   */
235   function div(uint256 a, uint256 b) internal pure returns (uint256) {
236     // assert(b > 0); // Solidity automatically throws when dividing by 0
237     uint256 c = a / b;
238     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239     return c;
240   }
241 
242   /**
243   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
244   */
245   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246     assert(b <= a);
247     return a - b;
248   }
249 
250   /**
251   * @dev Adds two numbers, throws on overflow.
252   */
253   function add(uint256 a, uint256 b) internal pure returns (uint256) {
254     uint256 c = a + b;
255     assert(c >= a);
256     return c;
257   }
258 }
259 
260 contract Ethbet {
261   using SafeMath2 for uint256;
262 
263   /*
264   * Events
265   */
266 
267   event Deposit(address indexed user, uint amount, uint balance);
268 
269   event Withdraw(address indexed user, uint amount, uint balance);
270 
271   event LockedBalance(address indexed user, uint amount);
272 
273   event UnlockedBalance(address indexed user, uint amount);
274 
275   event ExecutedBet(address indexed winner, address indexed loser, uint amount);
276 
277   event RelayAddressChanged(address relay);
278 
279 
280   /*
281    * Storage
282    */
283   address public relay;
284 
285   EthbetToken public token;
286 
287   mapping(address => uint256) balances;
288 
289   mapping(address => uint256) lockedBalances;
290 
291   /*
292   * Modifiers
293   */
294 
295   modifier isRelay() {
296     require(msg.sender == relay);
297     _;
298   }
299 
300   /*
301   * Public functions
302   */
303 
304   /**
305   * @dev Contract constructor
306   * @param _relay Relay Address
307   * @param _tokenAddress Ethbet Token Address
308   */
309   function Ethbet(address _relay, address _tokenAddress) public {
310     // make sure relay address set
311     require(_relay != address(0));
312 
313     relay = _relay;
314     token = EthbetToken(_tokenAddress);
315   }
316 
317   /**
318   * @dev set relay address
319   * @param _relay Relay Address
320   */
321   function setRelay(address _relay) public isRelay {
322     // make sure address not null
323     require(_relay != address(0));
324 
325     relay = _relay;
326 
327     RelayAddressChanged(_relay);
328   }
329 
330   /**
331    * @dev deposit EBET tokens into the contract
332    * @param _amount Amount to deposit
333    */
334   function deposit(uint _amount) public {
335     require(_amount > 0);
336 
337     // token.approve needs to be called beforehand
338     // transfer tokens from the user to the contract
339     require(token.transferFrom(msg.sender, this, _amount));
340 
341     // add the tokens to the user's balance
342     balances[msg.sender] = balances[msg.sender].add(_amount);
343 
344     Deposit(msg.sender, _amount, balances[msg.sender]);
345   }
346 
347   /**
348    * @dev withdraw EBET tokens from the contract
349    * @param _amount Amount to withdraw
350    */
351   function withdraw(uint _amount) public {
352     require(_amount > 0);
353     require(balances[msg.sender] >= _amount);
354 
355     // subtract the tokens from the user's balance
356     balances[msg.sender] = balances[msg.sender].sub(_amount);
357 
358     // transfer tokens from the contract to the user
359     require(token.transfer(msg.sender, _amount));
360 
361     Withdraw(msg.sender, _amount, balances[msg.sender]);
362   }
363 
364 
365   /**
366    * @dev Lock user balance to be used for bet
367    * @param _userAddress User Address
368    * @param _amount Amount to be locked
369    */
370   function lockBalance(address _userAddress, uint _amount) public isRelay {
371     require(_amount > 0);
372     require(balances[_userAddress] >= _amount);
373 
374     // subtract the tokens from the user's balance
375     balances[_userAddress] = balances[_userAddress].sub(_amount);
376 
377     // add the tokens to the user's locked balance
378     lockedBalances[_userAddress] = lockedBalances[_userAddress].add(_amount);
379 
380     LockedBalance(_userAddress, _amount);
381   }
382 
383   /**
384    * @dev Unlock user balance
385    * @param _userAddress User Address
386    * @param _amount Amount to be locked
387    */
388   function unlockBalance(address _userAddress, uint _amount) public isRelay {
389     require(_amount > 0);
390     require(lockedBalances[_userAddress] >= _amount);
391 
392     // subtract the tokens from the user's locked balance
393     lockedBalances[_userAddress] = lockedBalances[_userAddress].sub(_amount);
394 
395     // add the tokens to the user's  balance
396     balances[_userAddress] = balances[_userAddress].add(_amount);
397 
398     UnlockedBalance(_userAddress, _amount);
399   }
400 
401   /**
402   * @dev Get user balance
403   * @param _userAddress User Address
404   */
405   function balanceOf(address _userAddress) constant public returns (uint) {
406     return balances[_userAddress];
407   }
408 
409   /**
410   * @dev Get user locked balance
411   * @param _userAddress User Address
412   */
413   function lockedBalanceOf(address _userAddress) constant public returns (uint) {
414     return lockedBalances[_userAddress];
415   }
416 
417   /**
418    * @dev Execute bet
419    * @param _maker Maker Address
420    * @param _caller Caller Address
421    * @param _makerWon Did the maker win
422    * @param _amount amount
423    */
424   function executeBet(address _maker, address _caller, bool _makerWon, uint _amount) isRelay public {
425     //The caller must have enough locked balance
426     require(lockedBalances[_caller] >= _amount);
427 
428     //The maker must have enough locked balance
429     require(lockedBalances[_maker] >= _amount);
430 
431     // unlock maker balance
432     unlockBalance(_caller, _amount);
433 
434     // unlock maker balance
435     unlockBalance(_maker, _amount);
436 
437     var winner = _makerWon ? _maker : _caller;
438     var loser = _makerWon ? _caller : _maker;
439 
440     // add the tokens to the winner's balance
441     balances[winner] = balances[winner].add(_amount);
442     // remove the tokens from the loser's  balance
443     balances[loser] = balances[loser].sub(_amount);
444 
445     //Log the event
446     ExecutedBet(winner, loser, _amount);
447   }
448 
449 }