1 /**
2  * HELLO KITTY
3  */
4 pragma solidity ^0.4.13;
5 
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) constant returns (uint256);
9   function transfer(address to, uint256 value) returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal constant returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) returns (bool) {
50     require(_to != address(0));
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) constant returns (uint256);
72   function transferFrom(address from, address to, uint256 value) returns (bool);
73   function approve(address spender, uint256 value) returns (bool);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract StandardToken is ERC20, BasicToken {
78 
79   mapping (address => mapping (address => uint256)) allowed;
80 
81 
82   /**
83    * @dev Transfer tokens from one address to another
84    * @param _from address The address which you want to send tokens from
85    * @param _to address The address which you want to transfer to
86    * @param _value uint256 the amount of tokens to be transferred
87    */
88   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
89     require(_to != address(0));
90 
91     var _allowance = allowed[_from][msg.sender];
92 
93     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
94     // require (_value <= _allowance);
95 
96     balances[_from] = balances[_from].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     allowed[_from][msg.sender] = _allowance.sub(_value);
99     Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   /**
104    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
105    * @param _spender The address which will spend the funds.
106    * @param _value The amount of tokens to be spent.
107    */
108   function approve(address _spender, uint256 _value) returns (bool) {
109 
110     // To change the approve amount you first have to reduce the addresses`
111     //  allowance to zero by calling `approve(_spender, 0)` if it is not
112     //  already 0 to mitigate the race condition described here:
113     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
115 
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Function to check the amount of tokens that an owner allowed to a spender.
123    * @param _owner address The address which owns the funds.
124    * @param _spender address The address which will spend the funds.
125    * @return A uint256 specifying the amount of tokens still available for the spender.
126    */
127   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128     return allowed[_owner][_spender];
129   }
130 
131   /**
132    * approve should be called when allowed[_spender] == 0. To increment
133    * allowed value is better to use this function to avoid 2 calls (and wait until
134    * the first transaction is mined)
135    * From MonolithDAO Token.sol
136    */
137   function increaseApproval (address _spender, uint _addedValue)
138     returns (bool success) {
139     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
140     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141     return true;
142   }
143 
144   function decreaseApproval (address _spender, uint _subtractedValue)
145     returns (bool success) {
146     uint oldValue = allowed[msg.sender][_spender];
147     if (_subtractedValue > oldValue) {
148       allowed[msg.sender][_spender] = 0;
149     } else {
150       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
151     }
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156 }
157 
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address newOwner) onlyOwner {
188     require(newOwner != address(0));
189     OwnershipTransferred(owner, newOwner);
190     owner = newOwner;
191   }
192 
193 }
194 
195 contract Pausable is Ownable {
196   event Pause();
197   event Unpause();
198 
199   bool public paused = false;
200 
201 
202   /**
203    * @dev Modifier to make a function callable only when the contract is not paused.
204    */
205   modifier whenNotPaused() {
206     require(!paused);
207     _;
208   }
209 
210   /**
211    * @dev Modifier to make a function callable only when the contract is paused.
212    */
213   modifier whenPaused() {
214     require(paused);
215     _;
216   }
217 
218   /**
219    * @dev called by the owner to pause, triggers stopped state
220    */
221   function pause() onlyOwner whenNotPaused {
222     paused = true;
223     Pause();
224   }
225 
226   /**
227    * @dev called by the owner to unpause, returns to normal state
228    */
229   function unpause() onlyOwner whenPaused {
230     paused = false;
231     Unpause();
232   }
233 }
234 
235 contract evxOwnable is Ownable {
236 
237   address public newOwner;
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to an otherOwner.
241    * @param otherOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address otherOwner) onlyOwner {
244     require(otherOwner != address(0));
245     newOwner = otherOwner;
246   }
247 
248   /**
249    * @dev Finish ownership transfer.
250    */
251   function approveOwnership() {
252     require(msg.sender == newOwner);
253     OwnershipTransferred(owner, newOwner);
254     owner = newOwner;
255     newOwner = address(0);
256   }
257 }
258 
259 contract evxModerated is evxOwnable {
260 
261   address public moderator;
262   address public newModerator;
263 
264   /**
265    * @dev Throws if called by any account other than the moderator.
266    */
267   modifier onlyModerator() {
268     require(msg.sender == moderator);
269     _;
270   }
271 
272   /**
273    * @dev Throws if called by any account other than the owner or moderator.
274    */
275   modifier onlyOwnerOrModerator() {
276     require((msg.sender == moderator) || (msg.sender == owner));
277     _;
278   }
279 
280   /**
281    * @dev Moderator same as owner
282    */
283   function evxModerated(){
284     moderator = msg.sender;
285   }
286 
287   /**
288    * @dev Allows the current moderator to transfer control of the contract to an otherModerator.
289    * @param otherModerator The address to transfer moderatorship to.
290    */
291   function transferModeratorship(address otherModerator) onlyModerator {
292     newModerator = otherModerator;
293   }
294 
295   /**
296    * @dev Complete moderatorship transfer.
297    */
298   function approveModeratorship() {
299     require(msg.sender == newModerator);
300     moderator = newModerator;
301     newModerator = address(0);
302   }
303 
304   /**
305    * @dev Removes moderator from the contract.
306    * After this point, moderator role will be eliminated completly.
307    */
308   function removeModeratorship() onlyOwner {
309       moderator = address(0);
310   }
311 
312   function hasModerator() constant returns(bool) {
313       return (moderator != address(0));
314   }
315 }
316 
317 contract evxPausable is Pausable, evxModerated {
318   /**
319    * @dev called by the owner or moderator to pause, triggers stopped state
320    */
321   function pause() onlyOwnerOrModerator whenNotPaused {
322     paused = true;
323     Pause();
324   }
325 
326   /**
327    * @dev called by the owner or moderator to unpause, returns to normal state
328    */
329   function unpause() onlyOwnerOrModerator whenPaused {
330     paused = false;
331     Unpause();
332   }
333 }
334 
335 contract evxModeratedToken is StandardToken, evxPausable {
336 
337   mapping(address => bool) frozen;
338 
339   /**
340    * @dev Check if given address is frozen. Freeze works only if moderator role is active
341    * @param _addr address Address to check
342    */
343   function isFrozen(address _addr) constant returns (bool){
344       return frozen[_addr] && hasModerator();
345   }
346 
347   /**
348    * @dev Freezes address (no transfer can be made from or to this address).
349    * @param _addr address Address to be frozen
350    */
351   function freeze(address _addr) onlyModerator {
352       frozen[_addr] = true;
353   }
354 
355   /**
356    * @dev Unfreezes frozen address.
357    * @param _addr address Address to be unfrozen
358    */
359   function unfreeze(address _addr) onlyModerator {
360       frozen[_addr] = false;
361   }
362 
363   /**
364    * @dev Declines transfers from/to frozen addresses.
365    * @param _to address The address which you want to transfer to
366    * @param _value uint256 the amout of tokens to be transfered
367    */
368   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
369     require(!isFrozen(msg.sender));
370     require(!isFrozen(_to));
371     return super.transfer(_to, _value);
372   }
373 
374   /**
375    * @dev Declines transfers from/to/by frozen addresses.
376    * @param _from address The address which you want to send tokens from
377    * @param _to address The address which you want to transfer to
378    * @param _value uint256 the amout of tokens to be transfered
379    */
380   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
381     require(!isFrozen(msg.sender));
382     require(!isFrozen(_from));
383     require(!isFrozen(_to));
384     return super.transferFrom(_from, _to, _value);
385   }
386 
387   /**
388    * @dev Allows moderator to transfer tokens from one address to another.
389    * @param _from address The address which you want to send tokens from
390    * @param _to address The address which you want to transfer to
391    * @param _value uint256 the amout of tokens to be transfered
392    */
393   function moderatorTransferFrom(address _from, address _to, uint256 _value) onlyModerator returns (bool) {
394     balances[_to] = balances[_to].add(_value);
395     balances[_from] = balances[_from].sub(_value);
396     Transfer(_from, _to, _value);
397     return true;
398   }
399 }
400 
401 contract EVXTestToken is evxModeratedToken {
402   string public constant version = "0.0.2";
403   string public constant name = "TEST Smart Contract 2";
404   string public constant symbol = "xTEST";
405   uint256 public constant decimals = 4;
406 
407   /**
408    * @dev Constructor that gives msg.sender all of existing tokens.
409    */
410   function EVXTestToken(uint256 _initialSupply) {
411     totalSupply = _initialSupply;
412     balances[msg.sender] = _initialSupply;
413   }
414 }