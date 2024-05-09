1 pragma solidity ^0.4.19;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) constant returns (uint256);
45   function transfer(address to, uint256 value) returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) returns (bool) {
65     require(_to != address(0));
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value) returns (bool);
95   function approve(address spender, uint256 value) returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
119     require(_to != address(0));
120 
121     var _allowance = allowed[_from][msg.sender];
122 
123     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
124     // require (_value <= _allowance);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = _allowance.sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) returns (bool) {
139 
140     // To change the approve amount you first have to reduce the addresses`
141     //  allowance to zero by calling `approve(_spender, 0)` if it is not
142     //  already 0 to mitigate the race condition described here:
143     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
145 
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
158     return allowed[_owner][_spender];
159   }
160 
161   /**
162    * approve should be called when allowed[_spender] == 0. To increment
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    */
167   function increaseApproval (address _spender, uint _addedValue)
168     returns (bool success) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval (address _spender, uint _subtractedValue)
175     returns (bool success) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 /**
189  * @title EthbetToken
190  */
191 contract EthbetToken is StandardToken {
192 
193   string public constant name = "Ethbet";
194   string public constant symbol = "EBET";
195   uint8 public constant decimals = 2; // only two deciminals, token cannot be divided past 1/100th
196 
197   uint256 public constant INITIAL_SUPPLY = 1000000000; // 10 million + 2 decimals
198 
199   /**
200    * @dev Contructor that gives msg.sender all of existing tokens.
201    */
202   function EthbetToken() {
203     totalSupply = INITIAL_SUPPLY;
204     balances[msg.sender] = INITIAL_SUPPLY;
205   }
206 }
207 
208 
209 // Import newer SafeMath version under new name to avoid conflict with the version included in EthbetToken
210 
211 // SafeMath Library https://github.com/OpenZeppelin/zeppelin-solidity/blob/49b42e86963df7192e7024e0e5bd30fa9d7ccbef/contracts/math/SafeMath.sol
212 
213 
214 library SafeMath2 {
215 
216   /**
217   * @dev Multiplies two numbers, throws on overflow.
218   */
219   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220     if (a == 0) {
221       return 0;
222     }
223     uint256 c = a * b;
224     assert(c / a == b);
225     return c;
226   }
227 
228   /**
229   * @dev Integer division of two numbers, truncating the quotient.
230   */
231   function div(uint256 a, uint256 b) internal pure returns (uint256) {
232     // assert(b > 0); // Solidity automatically throws when dividing by 0
233     uint256 c = a / b;
234     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235     return c;
236   }
237 
238   /**
239   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
240   */
241   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242     assert(b <= a);
243     return a - b;
244   }
245 
246   /**
247   * @dev Adds two numbers, throws on overflow.
248   */
249   function add(uint256 a, uint256 b) internal pure returns (uint256) {
250     uint256 c = a + b;
251     assert(c >= a);
252     return c;
253   }
254 }
255 
256 contract Ethbet {
257   using SafeMath2 for uint256;
258 
259   /*
260   * Events
261   */
262 
263   event Deposit(address indexed user, uint amount, uint balance);
264 
265   event Withdraw(address indexed user, uint amount, uint balance);
266 
267   event LockedBalance(address indexed user, uint amount);
268 
269   event UnlockedBalance(address indexed user, uint amount);
270 
271   event ExecutedBet(address indexed winner, address indexed loser, uint amount);
272 
273   event RelayAddressChanged(address relay);
274 
275 
276   /*
277    * Storage
278    */
279   address public relay;
280 
281   EthbetToken public token;
282 
283   mapping(address => uint256) balances;
284 
285   mapping(address => uint256) lockedBalances;
286 
287   /*
288   * Modifiers
289   */
290 
291   modifier isRelay() {
292     require(msg.sender == relay);
293     _;
294   }
295 
296   /*
297   * Public functions
298   */
299 
300   /**
301   * @dev Contract constructor
302   * @param _relay Relay Address
303   * @param _tokenAddress Ethbet Token Address
304   */
305   function Ethbet(address _relay, address _tokenAddress) public {
306     // make sure relay address set
307     require(_relay != address(0));
308 
309     relay = _relay;
310     token = EthbetToken(_tokenAddress);
311   }
312 
313   /**
314   * @dev set relay address
315   * @param _relay Relay Address
316   */
317   function setRelay(address _relay) public isRelay {
318     // make sure address not null
319     require(_relay != address(0));
320 
321     relay = _relay;
322 
323     RelayAddressChanged(_relay);
324   }
325 
326   /**
327    * @dev deposit EBET tokens into the contract
328    * @param _amount Amount to deposit
329    */
330   function deposit(uint _amount) public {
331     require(_amount > 0);
332 
333     // token.approve needs to be called beforehand
334     // transfer tokens from the user to the contract
335     require(token.transferFrom(msg.sender, this, _amount));
336 
337     // add the tokens to the user's balance
338     balances[msg.sender] = balances[msg.sender].add(_amount);
339 
340     Deposit(msg.sender, _amount, balances[msg.sender]);
341   }
342 
343   /**
344    * @dev withdraw EBET tokens from the contract
345    * @param _amount Amount to withdraw
346    */
347   function withdraw(uint _amount) public {
348     require(_amount > 0);
349     require(balances[msg.sender] >= _amount);
350 
351     // subtract the tokens from the user's balance
352     balances[msg.sender] = balances[msg.sender].sub(_amount);
353 
354     // transfer tokens from the contract to the user
355     require(token.transfer(msg.sender, _amount));
356 
357     Withdraw(msg.sender, _amount, balances[msg.sender]);
358   }
359 
360 
361   /**
362    * @dev Lock user balance to be used for bet
363    * @param _userAddress User Address
364    * @param _amount Amount to be locked
365    */
366   function lockBalance(address _userAddress, uint _amount) public isRelay {
367     require(_amount > 0);
368     require(balances[_userAddress] >= _amount);
369 
370     // subtract the tokens from the user's balance
371     balances[_userAddress] = balances[_userAddress].sub(_amount);
372 
373     // add the tokens to the user's locked balance
374     lockedBalances[_userAddress] = lockedBalances[_userAddress].add(_amount);
375 
376     LockedBalance(_userAddress, _amount);
377   }
378 
379   /**
380    * @dev Unlock user balance
381    * @param _userAddress User Address
382    * @param _amount Amount to be locked
383    */
384   function unlockBalance(address _userAddress, uint _amount) public isRelay {
385     require(_amount > 0);
386     require(lockedBalances[_userAddress] >= _amount);
387 
388     // subtract the tokens from the user's locked balance
389     lockedBalances[_userAddress] = lockedBalances[_userAddress].sub(_amount);
390 
391     // add the tokens to the user's  balance
392     balances[_userAddress] = balances[_userAddress].add(_amount);
393 
394     UnlockedBalance(_userAddress, _amount);
395   }
396 
397   /**
398   * @dev Get user balance
399   * @param _userAddress User Address
400   */
401   function balanceOf(address _userAddress) constant public returns (uint) {
402     return balances[_userAddress];
403   }
404 
405   /**
406   * @dev Get user locked balance
407   * @param _userAddress User Address
408   */
409   function lockedBalanceOf(address _userAddress) constant public returns (uint) {
410     return lockedBalances[_userAddress];
411   }
412 
413   /**
414    * @dev Execute bet
415    * @param _maker Maker Address
416    * @param _caller Caller Address
417    * @param _makerWon Did the maker win
418    * @param _amount amount
419    */
420   function executeBet(address _maker, address _caller, bool _makerWon, uint _amount) isRelay public {
421     //The caller must have enough balance
422     require(balances[_caller] >= _amount);
423 
424     //The maker must have enough locked balance
425     require(lockedBalances[_maker] >= _amount);
426 
427     // unlock maker balance
428     unlockBalance(_maker, _amount);
429 
430     var winner = _makerWon ? _maker : _caller;
431     var loser = _makerWon ? _caller : _maker;
432 
433     // add the tokens to the winner's balance
434     balances[winner] = balances[winner].add(_amount);
435     // remove the tokens from the loser's  balance
436     balances[loser] = balances[loser].sub(_amount);
437 
438     //Log the event
439     ExecutedBet(winner, loser, _amount);
440   }
441 
442 }