1 pragma solidity ^0.4.13;
2 
3 /**
4 * Ton Token Contract
5 */
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) constant returns (uint256);
15   function transfer(address to, uint256 value) returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) constant returns (uint256);
25   function transferFrom(address from, address to, uint256 value) returns (bool);
26   function approve(address spender, uint256 value) returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title Basic token
32  * @dev Basic version of StandardToken, with no allowances. 
33  */
34 contract BasicToken is ERC20Basic {
35   using SafeMath for uint256;
36 
37   mapping(address => uint256) balances;
38 
39   /**
40   * @dev transfer token for a specified address
41   * @param _to The address to transfer to.
42   * @param _value The amount to be transferred.
43   */
44   function transfer(address _to, uint256 _value) returns (bool) {
45     require(_to != address(0));
46 
47     // SafeMath.sub will throw if there is not enough balance.
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   /**
55   * @dev Gets the balance of the specified address.
56   * @param _owner The address to query the the balance of. 
57   * @return An uint256 representing the amount owned by the passed address.
58   */
59   function balanceOf(address _owner) constant returns (uint256 balance) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 
66 /**
67  * @title Standard ERC20 token
68  *
69  * @dev Implementation of the basic standard token.
70  * @dev https://github.com/ethereum/EIPs/issues/20
71  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
72  */
73 contract StandardToken is ERC20, BasicToken {
74 
75   mapping (address => mapping (address => uint256)) allowed;
76 
77 
78   /**
79    * @dev Transfer tokens from one address to another
80    * @param _from address The address which you want to send tokens from
81    * @param _to address The address which you want to transfer to
82    * @param _value uint256 the amount of tokens to be transferred
83    */
84   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
85     require(_to != address(0));
86 
87     var _allowance = allowed[_from][msg.sender];
88 
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // require (_value <= _allowance);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    * @param _spender The address which will spend the funds.
102    * @param _value The amount of tokens to be spent.
103    */
104   function approve(address _spender, uint256 _value) returns (bool) {
105 
106     // To change the approve amount you first have to reduce the addresses`
107     //  allowance to zero by calling `approve(_spender, 0)` if it is not
108     //  already 0 to mitigate the race condition described here:
109     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
111 
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126   
127   /**
128    * approve should be called when allowed[_spender] == 0. To increment
129    * allowed value is better to use this function to avoid 2 calls (and wait until 
130    * the first transaction is mined)
131    * From MonolithDAO Token.sol
132    */
133   function increaseApproval (address _spender, uint _addedValue) 
134     returns (bool success) {
135     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140   function decreaseApproval (address _spender, uint _subtractedValue) 
141     returns (bool success) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152 }
153 
154 
155 
156 
157 /**
158  * @title Ownable
159  * @dev The Ownable contract has an owner address, and provides basic authorization control
160  * functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163   address public owner;
164 
165 
166   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168 
169   /**
170    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
171    * account.
172    */
173   function Ownable() {
174     owner = msg.sender;
175   }
176 
177 
178   /**
179    * @dev Throws if called by any account other than the owner.
180    */
181   modifier onlyOwner() {
182     require(msg.sender == owner);
183     _;
184   }
185 
186 
187   /**
188    * @dev Allows the current owner to transfer control of the contract to a newOwner.
189    * @param newOwner The address to transfer ownership to.
190    */
191   function transferOwnership(address newOwner) onlyOwner {
192     require(newOwner != address(0));      
193     OwnershipTransferred(owner, newOwner);
194     owner = newOwner;
195   }
196 
197 }
198 
199 /**
200  * @title SafeMath
201  * @dev Math operations with safety checks that throw on error
202  */
203 library SafeMath {
204   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
205     uint256 c = a * b;
206     assert(a == 0 || c / a == b);
207     return c;
208   }
209 
210   function div(uint256 a, uint256 b) internal constant returns (uint256) {
211     // assert(b > 0); // Solidity automatically throws when dividing by 0
212     uint256 c = a / b;
213     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214     return c;
215   }
216 
217   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
218     assert(b <= a);
219     return a - b;
220   }
221 
222   function add(uint256 a, uint256 b) internal constant returns (uint256) {
223     uint256 c = a + b;
224     assert(c >= a);
225     return c;
226   }
227 }
228 
229 
230 /**
231  * @title Pausable
232  * @dev Base contract which allows children to implement an emergency stop mechanism.
233  */
234 contract Pausable is Ownable {
235   event Pause();
236   event Unpause();
237 
238   bool public paused = false;
239 
240 
241   /**
242    * @dev Modifier to make a function callable only when the contract is not paused.
243    */
244   modifier whenNotPaused() {
245     require(!paused);
246     _;
247   }
248 
249   /**
250    * @dev Modifier to make a function callable only when the contract is paused.
251    */
252   modifier whenPaused() {
253     require(paused);
254     _;
255   }
256 
257   /**
258    * @dev called by the owner to pause, triggers stopped state
259    */
260   function pause() onlyOwner whenNotPaused {
261     paused = true;
262     Pause();
263   }
264 
265   /**
266    * @dev called by the owner to unpause, returns to normal state
267    */
268   function unpause() onlyOwner whenPaused {
269     paused = false;
270     Unpause();
271   }
272 }
273 
274 
275 
276 /**
277  * @title tonOwnable
278  * @dev The tonOwnable contract has an owner address, and provides basic authorization control
279  * functions, this simplifies the implementation of "user permissions".
280  */
281 contract tonOwnable is Ownable {
282 
283   address public newOwner;
284 
285   /**
286    * @dev Allows the current owner to transfer control of the contract to an otherOwner.
287    * @param otherOwner The address to transfer ownership to.
288    */
289   function transferOwnership(address otherOwner) onlyOwner {
290     require(otherOwner != address(0));      
291     newOwner = otherOwner;
292   }
293 
294   /**
295    * @dev Finish ownership transfer.
296    */
297   function approveOwnership() {
298     require(msg.sender == newOwner);
299     OwnershipTransferred(owner, newOwner);
300     owner = newOwner;
301     newOwner = address(0);
302   }
303 }
304 
305 
306 /**
307  * @title Moderated
308  * @dev Moderator can make transfers from and to any account (including frozen).
309  */
310 contract tonModerated is tonOwnable {
311 
312   address public moderator;
313   address public newModerator;
314 
315   /**
316    * @dev Throws if called by any account other than the moderator.
317    */
318   modifier onlyModerator() {
319     require(msg.sender == moderator);
320     _;
321   }
322 
323   /**
324    * @dev Throws if called by any account other than the owner or moderator.
325    */
326   modifier onlyOwnerOrModerator() {
327     require((msg.sender == moderator) || (msg.sender == owner));
328     _;
329   }
330 
331   /**
332    * @dev Moderator same as owner
333    */
334   function tonModerated(){
335     moderator = msg.sender;
336   }
337 
338   /**
339    * @dev Allows the current moderator to transfer control of the contract to an otherModerator.
340    * @param otherModerator The address to transfer moderatorship to.
341    */
342   function transferModeratorship(address otherModerator) onlyModerator {
343     newModerator = otherModerator;
344   }
345 
346   /**
347    * @dev Complete moderatorship transfer.
348    */
349   function approveModeratorship() {
350     require(msg.sender == newModerator);
351     moderator = newModerator;
352     newModerator = address(0);
353   }
354 
355   /**
356    * @dev Removes moderator from the contract.
357    * After this point, moderator role will be eliminated completly.
358    */
359   function removeModeratorship() onlyOwner {
360       moderator = address(0);
361   }
362 
363   function hasModerator() constant returns(bool) {
364       return (moderator != address(0));
365   }
366 }
367 
368 
369 /**
370  * @title tonPausable
371  * @dev Slightly modified implementation of an emergency stop mechanism.
372  */
373 contract tonPausable is Pausable, tonModerated {
374   /**
375    * @dev called by the owner or moderator to pause, triggers stopped state
376    */
377   function pause() onlyOwnerOrModerator whenNotPaused {
378     paused = true;
379     Pause();
380   }
381 
382   /**
383    * @dev called by the owner or moderator to unpause, returns to normal state
384    */
385   function unpause() onlyOwnerOrModerator whenPaused {
386     paused = false;
387     Unpause();
388   }
389 }
390 
391 
392 /**
393  * Pausable token with moderator role and freeze address implementation
394  *
395  **/
396 contract tonModeratedToken is StandardToken, tonPausable {
397 
398   mapping(address => bool) frozen;
399 
400   /**
401    * @dev Check if given address is frozen. Freeze works only if moderator role is active
402    * @param _addr address Address to check
403    */
404   function isFrozen(address _addr) constant returns (bool){
405       return frozen[_addr] && hasModerator();
406   }
407 
408   /**
409    * @dev Freezes address (no transfer can be made from or to this address).
410    * @param _addr address Address to be frozen
411    */
412   function freeze(address _addr) onlyModerator {
413       frozen[_addr] = true;
414   }
415 
416   /**
417    * @dev Unfreezes frozen address.
418    * @param _addr address Address to be unfrozen
419    */
420   function unfreeze(address _addr) onlyModerator {
421       frozen[_addr] = false;
422   }
423 
424   /**
425    * @dev Declines transfers from/to frozen addresses.
426    * @param _to address The address which you want to transfer to
427    * @param _value uint256 the amout of tokens to be transfered
428    */
429   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
430     require(!isFrozen(msg.sender));
431     require(!isFrozen(_to));
432     return super.transfer(_to, _value);
433   }
434 
435   /**
436    * @dev Declines transfers from/to/by frozen addresses.
437    * @param _from address The address which you want to send tokens from
438    * @param _to address The address which you want to transfer to
439    * @param _value uint256 the amout of tokens to be transfered
440    */
441   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
442     require(!isFrozen(msg.sender));
443     require(!isFrozen(_from));
444     require(!isFrozen(_to));
445     return super.transferFrom(_from, _to, _value);
446   }
447 
448   /**
449    * @dev Allows moderator to transfer tokens from one address to another.
450    * @param _from address The address which you want to send tokens from
451    * @param _to address The address which you want to transfer to
452    * @param _value uint256 the amout of tokens to be transfered
453    */
454   function moderatorTransferFrom(address _from, address _to, uint256 _value) onlyModerator returns (bool) {
455     balances[_to] = balances[_to].add(_value);
456     balances[_from] = balances[_from].sub(_value);
457     Transfer(_from, _to, _value);
458     return true;
459   }
460 }
461 /**
462  * TONToken
463  **/
464 contract TONToken is tonModeratedToken {
465   string public constant version = "1";
466   string public constant name = "TonToken";
467   string public constant symbol = "TON";
468   uint256 public constant decimals = 5;
469 
470   /**
471    * @dev Constructor that gives msg.sender all of existing tokens. 
472    */
473   function TONToken(uint256 _initialSupply) {   
474     totalSupply = _initialSupply;
475     balances[msg.sender] = _initialSupply;
476   }
477 }