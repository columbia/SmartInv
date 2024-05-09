1 pragma solidity ^0.4.24;
2 
3 /**xxp 校验防止溢出情况
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59     function totalSupply() public view returns (uint256);
60     function balanceOf(address who) public view returns (uint256);
61     function transfer(address to, uint256 value) public returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     function allowance(address owner, address spender) public view returns (uint256);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76     address public owner;
77 
78 
79     event OwnershipRenounced(address indexed previousOwner);
80     event OwnershipTransferred(
81         address indexed previousOwner,
82         address indexed newOwner
83     );
84 
85 
86   /**
87    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88    * account.
89    */
90     constructor() public {
91         owner = msg.sender;
92     }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97     modifier onlyOwner() {
98         require(msg.sender == owner);
99         _;
100     }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    * @notice Renouncing to ownership will leave the contract without an owner.
105    * It will not be possible to call the functions with the `onlyOwner`
106    * modifier anymore.
107    */
108     function renounceOwnership() public onlyOwner {
109         emit OwnershipRenounced(owner);
110         owner = address(0);
111     }
112 
113   /**
114    * @dev Allows the current owner to transfer control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117     function transferOwnership(address _newOwner) public onlyOwner {
118         _transferOwnership(_newOwner);
119     }
120 
121   /**
122    * @dev Transfers control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125     function _transferOwnership(address _newOwner) internal {
126         require(_newOwner != address(0));
127         emit OwnershipTransferred(owner, _newOwner);
128         owner = _newOwner;
129     }
130 }
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20Basic {
140 
141     using SafeMath for uint256;
142 
143     mapping(address => uint256) balances;
144 
145     uint256 totalSupply_;
146 
147     /**
148     * @dev Total number of tokens in existence
149     */
150     function totalSupply() public view returns (uint256) {
151         return totalSupply_;
152     }
153 
154     /**
155     * @dev Transfer token for a specified address
156     * @param _to The address to transfer to.
157     * @param _value The amount to be transferred.
158     */
159     function transfer(address _to, uint256 _value) public returns (bool) {
160         require(_value <= balances[msg.sender]);
161         require(_to != address(0));
162 
163         balances[msg.sender] = balances[msg.sender].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         emit Transfer(msg.sender, _to, _value);
166         return true;
167     }
168 
169     /**
170     * @dev Gets the balance of the specified address.
171     * @param _owner The address to query the the balance of.
172     * @return An uint256 representing the amount owned by the passed address.
173     */
174     function balanceOf(address _owner) public view returns (uint256) {
175         return balances[_owner];
176     }
177 
178     mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181     /**
182     * @dev Transfer tokens from one address to another
183     * @param _from address The address which you want to send tokens from
184     * @param _to address The address which you want to transfer to
185     * @param _value uint256 the amount of tokens to be transferred
186     */
187     function transferFrom(
188         address _from,
189         address _to,
190         uint256 _value
191     )
192         public
193         returns (bool)
194     {
195         require(_value <= balances[_from]);
196         require(_value <= allowed[_from][msg.sender]);
197         require(_to != address(0));
198 
199         balances[_from] = balances[_from].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202         emit Transfer(_from, _to, _value);
203         return true;
204     }
205 
206     /**
207     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208     * Beware that changing an allowance with this method brings the risk that someone may use both the old
209     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212     * @param _spender The address which will spend the funds.
213     * @param _value The amount of tokens to be spent.
214     */
215     function approve(address _spender, uint256 _value) public returns (bool) {
216         allowed[msg.sender][_spender] = _value;
217         emit Approval(msg.sender, _spender, _value);
218         return true;
219     }
220 
221     /**
222     * @dev Function to check the amount of tokens that an owner allowed to a spender.
223     * @param _owner address The address which owns the funds.
224     * @param _spender address The address which will spend the funds.
225     * @return A uint256 specifying the amount of tokens still available for the spender.
226     */
227     function allowance(
228         address _owner,
229         address _spender
230     )
231         public
232         view
233         returns (uint256)
234     {
235         return allowed[_owner][_spender];
236     }
237 
238     /**
239     * @dev Increase the amount of tokens that an owner allowed to a spender.
240     * approve should be called when allowed[_spender] == 0. To increment
241     * allowed value is better to use this function to avoid 2 calls (and wait until
242     * the first transaction is mined)
243     * From MonolithDAO Token.sol
244     * @param _spender The address which will spend the funds.
245     * @param _addedValue The amount of tokens to increase the allowance by.
246     */
247     function increaseApproval(
248         address _spender,
249         uint256 _addedValue
250     )
251         public
252         returns (bool)
253     {
254         allowed[msg.sender][_spender] = (
255         allowed[msg.sender][_spender].add(_addedValue));
256         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257         return true;
258     }
259 
260     /**
261     * @dev Decrease the amount of tokens that an owner allowed to a spender.
262     * approve should be called when allowed[_spender] == 0. To decrement
263     * allowed value is better to use this function to avoid 2 calls (and wait until
264     * the first transaction is mined)
265     * From MonolithDAO Token.sol
266     * @param _spender The address which will spend the funds.
267     * @param _subtractedValue The amount of tokens to decrease the allowance by.
268     */
269     function decreaseApproval(
270         address _spender,
271         uint256 _subtractedValue
272     )
273         public
274         returns (bool)
275     {
276         uint256 oldValue = allowed[msg.sender][_spender];
277         if (_subtractedValue >= oldValue) {
278             allowed[msg.sender][_spender] = 0;
279         } else {
280             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281         }
282         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283         return true;
284     }
285 }
286 
287 /**
288  * @title Burnable Token
289  * @dev Token that can be irreversibly burned (destroyed).
290  */
291 contract BurnableToken is StandardToken {
292 
293     event Burn(address indexed burner, uint256 value);
294 
295     /**
296     * @dev Burns a specific amount of tokens.
297     * @param _value The amount of token to be burned.
298     */
299     function burn(uint256 _value) public {
300         _burn(msg.sender, _value);
301     }
302 
303     function _burn(address _who, uint256 _value) internal {
304         require(_value <= balances[_who]);
305         // no need to require value <= totalSupply, since that would imply the
306         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
307 
308         balances[_who] = balances[_who].sub(_value);
309         totalSupply_ = totalSupply_.sub(_value);
310         emit Burn(_who, _value);
311         emit Transfer(_who, address(0), _value);
312     }
313 }
314 
315 /**
316  * @title Mintable token
317  * @dev Simple ERC20 Token example, with mintable token creation
318  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
319  */
320 contract MintableToken is StandardToken, Ownable {
321     event Mint(address indexed to, uint256 amount);
322     event MintFinished();
323 
324     bool public mintingFinished = false;
325 
326 
327     modifier canMint() {
328         require(!mintingFinished);
329         _;
330     }
331 
332     modifier hasMintPermission() {
333         require(msg.sender == owner);
334         _;
335     }
336 
337     /**
338     * @dev Function to mint tokens
339     * @param _to The address that will receive the minted tokens.
340     * @param _amount The amount of tokens to mint.
341     * @return A boolean that indicates if the operation was successful.
342     */
343     function mint(
344         address _to,
345         uint256 _amount
346     )
347         hasMintPermission
348         canMint
349         public
350         returns (bool)
351     {
352         totalSupply_ = totalSupply_.add(_amount);
353         balances[_to] = balances[_to].add(_amount);
354         emit Mint(_to, _amount);
355         emit Transfer(address(0), _to, _amount);
356         return true;
357     }
358 
359     /**
360     * @dev Function to stop minting new tokens.
361     * @return True if the operation was successful.
362     */
363     function finishMinting() onlyOwner canMint public returns (bool) {
364         mintingFinished = true;
365         emit MintFinished();
366         return true;
367     }
368 }
369 
370 contract Controlled is Ownable{
371 
372     constructor() public {
373         setExclude(msg.sender);
374     }
375 
376     // Flag that determines if the token is transferable or not.
377     bool public transferEnabled = false;
378 
379     // flag that makes locked address effect
380     bool public plockFlag=true;
381     mapping(address => bool) locked;
382     mapping(address => bool) exclude;
383 
384     // 控制全局全局锁
385     function enableTransfer(bool _enable) public onlyOwner{
386         transferEnabled = _enable;
387     }
388 
389     // 控制个人锁功能
390     function enableLockFlag(bool _enable) public onlyOwner returns (bool success){
391         plockFlag = _enable;
392         return true;
393     }
394 
395     function addLock(address _addr) public onlyOwner returns (bool success){
396         require(_addr!=msg.sender);
397         locked[_addr] = true;
398         return true;
399     }
400 
401     function setExclude(address _addr) public onlyOwner returns (bool success){
402         exclude[_addr] = true;
403         return true;
404     }
405 
406     function removeLock(address _addr) public onlyOwner returns (bool success){
407         locked[_addr] = false;
408         return true;
409     }
410 
411     modifier transferAllowed(address _addr) {
412         if (!exclude[_addr]) {
413             // flase抛异常，并扣除gas消耗
414             assert(transferEnabled);
415             if(plockFlag){
416                 assert(!locked[_addr]);
417             }
418         }
419         
420         _;
421     }
422 
423 }
424 
425 /**
426  * @title Pausable token
427  *
428  * @dev StandardToken modified with pausable transfers.
429  **/
430 
431 contract PausableToken is StandardToken, Controlled {
432 
433     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
434         return super.transfer(_to, _value);
435     }
436 
437     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
438         return super.transferFrom(_from, _to, _value);
439     }
440 
441     function approve(address _spender, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
442         return super.approve(_spender, _value);
443     }
444 }
445 
446 /*
447  * @title GAT
448  */
449 contract GAT is BurnableToken, MintableToken, PausableToken {
450     // Public variables of the token
451     string public name;
452     string public symbol;
453     // decimals is the strongly suggested default, avoid changing it
454     uint8 public decimals;
455 
456     constructor() public {
457         name = "Gold Art Token";
458         symbol = "GAT";
459         decimals = 18;
460         totalSupply_ = 100000000 * 10 ** uint256(decimals);
461 
462         // Allocate initial balance to the owner
463         balances[msg.sender] = totalSupply_;
464     }
465 
466     // transfer balance to owner
467     function withdrawEther() onlyOwner public {
468         address addr = this;
469         owner.transfer(addr.balance);
470     }
471 
472     // can accept ether
473     function() payable public { }
474 
475     // Allocate tokens to the users
476     // @param _owners The owners list of the token
477     // @param _values The value list of the token
478     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
479 
480         require(_owners.length == _values.length, "data length mismatch");
481         address from = msg.sender;
482 
483         for(uint256 i = 0; i < _owners.length ; i++){
484             address to = _owners[i];
485             uint256 value = _values[i];
486             require(value <= balances[from]);
487 
488             balances[to] = balances[to].add(value);
489             balances[from] = balances[from].sub(value);
490             emit Transfer(from, to, value);
491         }
492     }
493 }