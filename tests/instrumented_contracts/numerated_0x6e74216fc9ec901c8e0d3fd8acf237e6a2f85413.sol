1 pragma solidity ^0.4.13;
2 
3 /**
4 * Everex Token Contract
5 * Copyright © 2017 by Everex https://everex.io
6 */
7 
8 /**
9  * @title ERC20Basic
10  * @dev Simpler version of ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) constant returns (uint256);
16   function transfer(address to, uint256 value) returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   function approve(address spender, uint256 value) returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * @title Basic token
33  * @dev Basic version of StandardToken, with no allowances.
34  */
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37 
38   mapping(address => uint256) balances;
39 
40   /**
41   * @dev transfer token for a specified address
42   * @param _to The address to transfer to.
43   * @param _value The amount to be transferred.
44   */
45   function transfer(address _to, uint256 _value) returns (bool) {
46     require(_to != address(0));
47 
48     // SafeMath.sub will throw if there is not enough balance.
49     balances[msg.sender] = balances[msg.sender].sub(_value);
50     balances[_to] = balances[_to].add(_value);
51     Transfer(msg.sender, _to, _value);
52     return true;
53   }
54 
55   /**
56   * @dev Gets the balance of the specified address.
57   * @param _owner The address to query the the balance of.
58   * @return An uint256 representing the amount owned by the passed address.
59   */
60   function balanceOf(address _owner) constant returns (uint256 balance) {
61     return balances[_owner];
62   }
63 
64 }
65 
66 
67 /**
68  * @title Standard ERC20 token
69  *
70  * @dev Implementation of the basic standard token.
71  * @dev https://github.com/ethereum/EIPs/issues/20
72  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
73  */
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) allowed;
77 
78 
79   /**
80    * @dev Transfer tokens from one address to another
81    * @param _from address The address which you want to send tokens from
82    * @param _to address The address which you want to transfer to
83    * @param _value uint256 the amount of tokens to be transferred
84    */
85   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
86     require(_to != address(0));
87 
88     var _allowance = allowed[_from][msg.sender];
89 
90     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91     // require (_value <= _allowance);
92 
93     balances[_from] = balances[_from].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     allowed[_from][msg.sender] = _allowance.sub(_value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   /**
101    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) returns (bool) {
106 
107     // To change the approve amount you first have to reduce the addresses`
108     //  allowance to zero by calling `approve(_spender, 0)` if it is not
109     //  already 0 to mitigate the race condition described here:
110     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   /**
119    * @dev Function to check the amount of tokens that an owner allowed to a spender.
120    * @param _owner address The address which owns the funds.
121    * @param _spender address The address which will spend the funds.
122    * @return A uint256 specifying the amount of tokens still available for the spender.
123    */
124   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
125     return allowed[_owner][_spender];
126   }
127 
128   /**
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    */
134   function increaseApproval (address _spender, uint _addedValue)
135     returns (bool success) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval (address _spender, uint _subtractedValue)
142     returns (bool success) {
143     uint oldValue = allowed[msg.sender][_spender];
144     if (_subtractedValue > oldValue) {
145       allowed[msg.sender][_spender] = 0;
146     } else {
147       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148     }
149     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150     return true;
151   }
152 
153 }
154 
155 
156 
157 
158 /**
159  * @title Ownable
160  * @dev The Ownable contract has an owner address, and provides basic authorization control
161  * functions, this simplifies the implementation of "user permissions".
162  */
163 contract Ownable {
164   address public owner;
165 
166 
167   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169 
170   /**
171    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
172    * account.
173    */
174   function Ownable() {
175     owner = msg.sender;
176   }
177 
178 
179   /**
180    * @dev Throws if called by any account other than the owner.
181    */
182   modifier onlyOwner() {
183     require(msg.sender == owner);
184     _;
185   }
186 
187 
188   /**
189    * @dev Allows the current owner to transfer control of the contract to a newOwner.
190    * @param newOwner The address to transfer ownership to.
191    */
192   function transferOwnership(address newOwner) onlyOwner {
193     require(newOwner != address(0));
194     OwnershipTransferred(owner, newOwner);
195     owner = newOwner;
196   }
197 
198 }
199 
200 /**
201  * @title SafeMath
202  * @dev Math operations with safety checks that throw on error
203  */
204 library SafeMath {
205   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
206     uint256 c = a * b;
207     assert(a == 0 || c / a == b);
208     return c;
209   }
210 
211   function div(uint256 a, uint256 b) internal constant returns (uint256) {
212     // assert(b > 0); // Solidity automatically throws when dividing by 0
213     uint256 c = a / b;
214     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215     return c;
216   }
217 
218   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
219     assert(b <= a);
220     return a - b;
221   }
222 
223   function add(uint256 a, uint256 b) internal constant returns (uint256) {
224     uint256 c = a + b;
225     assert(c >= a);
226     return c;
227   }
228 }
229 
230 
231 /**
232  * @title Pausable
233  * @dev Base contract which allows children to implement an emergency stop mechanism.
234  */
235 contract Pausable is Ownable {
236   event Pause();
237   event Unpause();
238 
239   bool public paused = false;
240 
241 
242   /**
243    * @dev Modifier to make a function callable only when the contract is not paused.
244    */
245   modifier whenNotPaused() {
246     require(!paused);
247     _;
248   }
249 
250   /**
251    * @dev Modifier to make a function callable only when the contract is paused.
252    */
253   modifier whenPaused() {
254     require(paused);
255     _;
256   }
257 
258   /**
259    * @dev called by the owner to pause, triggers stopped state
260    */
261   function pause() onlyOwner whenNotPaused {
262     paused = true;
263     Pause();
264   }
265 
266   /**
267    * @dev called by the owner to unpause, returns to normal state
268    */
269   function unpause() onlyOwner whenPaused {
270     paused = false;
271     Unpause();
272   }
273 }
274 
275 
276 
277 /**
278  * @title evxOwnable
279  * @dev The evxOwnable contract has an owner address, and provides basic authorization control
280  * functions, this simplifies the implementation of "user permissions".
281  */
282 contract evxOwnable is Ownable {
283 
284   address public newOwner;
285 
286   /**
287    * @dev Allows the current owner to transfer control of the contract to an otherOwner.
288    * @param otherOwner The address to transfer ownership to.
289    */
290   function transferOwnership(address otherOwner) onlyOwner {
291     require(otherOwner != address(0));
292     newOwner = otherOwner;
293   }
294 
295   /**
296    * @dev Finish ownership transfer.
297    */
298   function approveOwnership() {
299     require(msg.sender == newOwner);
300     OwnershipTransferred(owner, newOwner);
301     owner = newOwner;
302     newOwner = address(0);
303   }
304 }
305 
306 
307 /**
308  * @title Moderated
309  * @dev Moderator can make transfers from and to any account (including frozen).
310  */
311 contract evxModerated is evxOwnable {
312 
313   address public moderator;
314   address public newModerator;
315 
316   /**
317    * @dev Throws if called by any account other than the moderator.
318    */
319   modifier onlyModerator() {
320     require(msg.sender == moderator);
321     _;
322   }
323 
324   /**
325    * @dev Throws if called by any account other than the owner or moderator.
326    */
327   modifier onlyOwnerOrModerator() {
328     require((msg.sender == moderator) || (msg.sender == owner));
329     _;
330   }
331 
332   /**
333    * @dev Moderator same as owner
334    */
335   function evxModerated(){
336     moderator = msg.sender;
337   }
338 
339   /**
340    * @dev Allows the current moderator to transfer control of the contract to an otherModerator.
341    * @param otherModerator The address to transfer moderatorship to.
342    */
343   function transferModeratorship(address otherModerator) onlyModerator {
344     newModerator = otherModerator;
345   }
346 
347   /**
348    * @dev Complete moderatorship transfer.
349    */
350   function approveModeratorship() {
351     require(msg.sender == newModerator);
352     moderator = newModerator;
353     newModerator = address(0);
354   }
355 
356   /**
357    * @dev Removes moderator from the contract.
358    * After this point, moderator role will be eliminated completly.
359    */
360   function removeModeratorship() onlyOwner {
361       moderator = address(0);
362   }
363 
364   function hasModerator() constant returns(bool) {
365       return (moderator != address(0));
366   }
367 }
368 
369 
370 /**
371  * @title evxPausable
372  * @dev Slightly modified implementation of an emergency stop mechanism.
373  */
374 contract evxPausable is Pausable, evxModerated {
375   /**
376    * @dev called by the owner or moderator to pause, triggers stopped state
377    */
378   function pause() onlyOwnerOrModerator whenNotPaused {
379     paused = true;
380     Pause();
381   }
382 
383   /**
384    * @dev called by the owner or moderator to unpause, returns to normal state
385    */
386   function unpause() onlyOwnerOrModerator whenPaused {
387     paused = false;
388     Unpause();
389   }
390 }
391 
392 
393 /**
394  * Pausable token with moderator role and freeze address implementation
395  *
396  **/
397 contract evxModeratedToken is StandardToken, evxPausable {
398 
399   mapping(address => bool) frozen;
400 
401   /**
402    * @dev Check if given address is frozen. Freeze works only if moderator role is active
403    * @param _addr address Address to check
404    */
405   function isFrozen(address _addr) constant returns (bool){
406       return frozen[_addr] && hasModerator();
407   }
408 
409   /**
410    * @dev Freezes address (no transfer can be made from or to this address).
411    * @param _addr address Address to be frozen
412    */
413   function freeze(address _addr) onlyModerator {
414       frozen[_addr] = true;
415   }
416 
417   /**
418    * @dev Unfreezes frozen address.
419    * @param _addr address Address to be unfrozen
420    */
421   function unfreeze(address _addr) onlyModerator {
422       frozen[_addr] = false;
423   }
424 
425   /**
426    * @dev Declines transfers from/to frozen addresses.
427    * @param _to address The address which you want to transfer to
428    * @param _value uint256 the amout of tokens to be transfered
429    */
430   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
431     require(!isFrozen(msg.sender));
432     require(!isFrozen(_to));
433     return super.transfer(_to, _value);
434   }
435 
436   /**
437    * @dev Declines transfers from/to/by frozen addresses.
438    * @param _from address The address which you want to send tokens from
439    * @param _to address The address which you want to transfer to
440    * @param _value uint256 the amout of tokens to be transfered
441    */
442   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
443     require(!isFrozen(msg.sender));
444     require(!isFrozen(_from));
445     require(!isFrozen(_to));
446     return super.transferFrom(_from, _to, _value);
447   }
448 
449   /**
450    * @dev Allows moderator to transfer tokens from one address to another.
451    * @param _from address The address which you want to send tokens from
452    * @param _to address The address which you want to transfer to
453    * @param _value uint256 the amout of tokens to be transfered
454    */
455   function moderatorTransferFrom(address _from, address _to, uint256 _value) onlyModerator returns (bool) {
456     balances[_to] = balances[_to].add(_value);
457     balances[_from] = balances[_from].sub(_value);
458     Transfer(_from, _to, _value);
459     return true;
460   }
461 }
462 /**
463  * EVXTestToken
464  **/
465 contract EVXTestToken is evxModeratedToken {
466   string public constant version = "0.0.1";
467   string public constant name = "TestTokenSmartContract";
468   string public constant symbol = "xTEST";
469   uint256 public constant decimals = 4;
470 
471   /**
472    * @dev Contructor that gives msg.sender all of existing tokens.
473    */
474   function EVXTestToken(uint256 _initialSupply) {
475     totalSupply = _initialSupply;
476     balances[msg.sender] = _initialSupply;
477   }
478 }