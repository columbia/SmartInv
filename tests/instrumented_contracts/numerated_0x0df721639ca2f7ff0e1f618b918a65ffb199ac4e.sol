1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of 'user permissions'.
54  */
55 
56 /// @title Ownable
57 /// @author Applicature
58 /// @notice helper mixed to other contracts to link contract on an owner
59 /// @dev Base class
60 contract Ownable {
61     //Variables
62     address public owner;
63     address public newOwner;
64 
65     //    Modifiers
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     /**
75      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76      * account.
77      */
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     /**
83      * @dev Allows the current owner to transfer control of the contract to a newOwner.
84      * @param _newOwner The address to transfer ownership to.
85      */
86     function transferOwnership(address _newOwner) public onlyOwner {
87         require(_newOwner != address(0));
88         newOwner = _newOwner;
89 
90     }
91 
92     function acceptOwnership() public {
93         if (msg.sender == newOwner) {
94             owner = newOwner;
95         }
96     }
97 }
98 /**
99  * @title ERC20Basic
100  * @dev Simpler version of ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/179
102  */
103 contract ERC20Basic {
104   function totalSupply() public view returns (uint256);
105   function balanceOf(address who) public view returns (uint256);
106   function transfer(address to, uint256 value) public returns (bool);
107   event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 /**
153  * @title ERC20 interface
154  * @dev see https://github.com/ethereum/EIPs/issues/20
155  */
156 contract ERC20 is ERC20Basic {
157   function allowance(address owner, address spender)
158     public view returns (uint256);
159 
160   function transferFrom(address from, address to, uint256 value)
161     public returns (bool);
162 
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(
165     address indexed owner,
166     address indexed spender,
167     uint256 value
168   );
169 }
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address _from,
190     address _to,
191     uint256 _value
192   )
193     public
194     returns (bool)
195   {
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     emit Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(
230     address _owner,
231     address _spender
232    )
233     public
234     view
235     returns (uint256)
236   {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(
251     address _spender,
252     uint _addedValue
253   )
254     public
255     returns (bool)
256   {
257     allowed[msg.sender][_spender] = (
258       allowed[msg.sender][_spender].add(_addedValue));
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(
274     address _spender,
275     uint _subtractedValue
276   )
277     public
278     returns (bool)
279   {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 /// @title OpenZeppelinERC20
292 /// @author Applicature
293 /// @notice Open Zeppelin implementation of standart ERC20
294 /// @dev Base class
295 contract OpenZeppelinERC20 is StandardToken, Ownable {
296     using SafeMath for uint256;
297 
298     uint8 public decimals;
299     string public name;
300     string public symbol;
301     string public standard;
302 
303     constructor(
304         uint256 _totalSupply,
305         string _tokenName,
306         uint8 _decimals,
307         string _tokenSymbol,
308         bool _transferAllSupplyToOwner
309     ) public {
310         standard = 'ERC20 0.1';
311         totalSupply_ = _totalSupply;
312 
313         if (_transferAllSupplyToOwner) {
314             balances[msg.sender] = _totalSupply;
315         } else {
316             balances[this] = _totalSupply;
317         }
318 
319         name = _tokenName;
320         // Set the name for display purposes
321         symbol = _tokenSymbol;
322         // Set the symbol for display purposes
323         decimals = _decimals;
324     }
325 
326 }
327 /// @title MintableToken
328 /// @author Applicature
329 /// @notice allow to mint tokens
330 /// @dev Base class
331 contract MintableToken is BasicToken, Ownable {
332 
333     using SafeMath for uint256;
334 
335     uint256 public maxSupply;
336     bool public allowedMinting;
337     mapping(address => bool) public mintingAgents;
338     mapping(address => bool) public stateChangeAgents;
339 
340     event Mint(address indexed holder, uint256 tokens);
341 
342     modifier onlyMintingAgents () {
343         require(mintingAgents[msg.sender]);
344         _;
345     }
346 
347     modifier onlyStateChangeAgents () {
348         require(stateChangeAgents[msg.sender]);
349         _;
350     }
351 
352     constructor(uint256 _maxSupply, uint256 _mintedSupply, bool _allowedMinting) public {
353         maxSupply = _maxSupply;
354         totalSupply_ = totalSupply_.add(_mintedSupply);
355         allowedMinting = _allowedMinting;
356         mintingAgents[msg.sender] = true;
357     }
358 
359     /// @notice allow to mint tokens
360     function mint(address _holder, uint256 _tokens) public onlyMintingAgents() {
361         require(allowedMinting == true && totalSupply_.add(_tokens) <= maxSupply);
362 
363         totalSupply_ = totalSupply_.add(_tokens);
364 
365         balances[_holder] = balanceOf(_holder).add(_tokens);
366 
367         if (totalSupply_ == maxSupply) {
368             allowedMinting = false;
369         }
370         emit Mint(_holder, _tokens);
371     }
372 
373     /// @notice update allowedMinting flat
374     function disableMinting() public onlyStateChangeAgents() {
375         allowedMinting = false;
376     }
377 
378     /// @notice update minting agent
379     function updateMintingAgent(address _agent, bool _status) public onlyOwner {
380         mintingAgents[_agent] = _status;
381     }
382 
383     /// @notice update state change agent
384     function updateStateChangeAgent(address _agent, bool _status) public onlyOwner {
385         stateChangeAgents[_agent] = _status;
386     }
387 
388     /// @return available tokens
389     function availableTokens() public view returns (uint256 tokens) {
390         return maxSupply.sub(totalSupply_);
391     }
392 }
393 /// @title TimeLocked
394 /// @author Applicature
395 /// @notice helper mixed to other contracts to lock contract on a timestamp
396 /// @dev Base class
397 contract TimeLocked {
398     uint256 public time;
399     mapping(address => bool) public excludedAddresses;
400 
401     modifier isTimeLocked(address _holder, bool _timeLocked) {
402         bool locked = (block.timestamp < time);
403         require(excludedAddresses[_holder] == true || locked == _timeLocked);
404         _;
405     }
406 
407     constructor(uint256 _time) public {
408         time = _time;
409     }
410 
411     function updateExcludedAddress(address _address, bool _status) public;
412 }
413 /// @title TimeLockedToken
414 /// @author Applicature
415 /// @notice helper mixed to other contracts to lock contract on a timestamp
416 /// @dev Base class
417 contract TimeLockedToken is TimeLocked, StandardToken {
418 
419     constructor(uint256 _time) public TimeLocked(_time) {}
420 
421     function transfer(address _to, uint256 _tokens) public isTimeLocked(msg.sender, false) returns (bool) {
422        return super.transfer(_to, _tokens);
423     }
424 
425     function transferFrom(
426         address _holder,
427         address _to,
428         uint256 _tokens
429     ) public isTimeLocked(_holder, false) returns (bool) {
430         return super.transferFrom(_holder, _to, _tokens);
431     }
432 }
433 contract Howdoo is OpenZeppelinERC20, MintableToken, TimeLockedToken {
434 
435     uint256 public amendCount = 113;
436 
437     constructor(uint256 _unlockTokensTime) public
438     OpenZeppelinERC20(0, "uDOO", 18, "uDOO", false)
439     MintableToken(888888888e18, 0, true)
440     TimeLockedToken(_unlockTokensTime) {
441 
442     }
443 
444     function updateExcludedAddress(address _address, bool _status) public onlyOwner {
445         excludedAddresses[_address] = _status;
446     }
447 
448     function setUnlockTime(uint256 _unlockTokensTime) public onlyStateChangeAgents {
449         time = _unlockTokensTime;
450     }
451 
452     function transfer(address _to, uint256 _tokens) public returns (bool) {
453         return super.transfer(_to, _tokens);
454     }
455 
456     function transferFrom(address _holder, address _to, uint256 _tokens) public returns (bool) {
457         return super.transferFrom(_holder, _to, _tokens);
458     }
459 
460     function migrateBalances(Howdoo _token, address[] _holders) public onlyOwner {
461         uint256 amount;
462 
463         for (uint256 i = 0; i < _holders.length; i++) {
464             amount = _token.balanceOf(_holders[i]);
465 
466             mint(_holders[i], amount);
467         }
468     }
469 
470     function amendBalances(address[] _holders) public onlyOwner {
471         uint256 amount = 302074971158267328898484;
472         for (uint256 i = 0; i < _holders.length; i++) {
473             require(amendCount > 0);
474             amendCount--;
475             totalSupply_ = totalSupply_.sub(amount);
476             balances[_holders[i]] = balances[_holders[i]].sub(amount);
477             emit Transfer(_holders[i], address(0), amount);
478 
479         }
480     }
481 
482 }