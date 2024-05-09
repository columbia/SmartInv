1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-09
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         // uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return a / b;
37     }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63     function totalSupply() public view returns (uint256);
64     function balanceOf(address who) public view returns (uint256);
65     function transfer(address to, uint256 value) public returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 /**
75  * @title Ownable
76  * @dev The Ownable contract has an owner address, and provides basic authorization control
77  * functions, this simplifies the implementation of "user permissions".
78  */
79 contract Ownable {
80     address public owner;
81 
82 
83     event OwnershipRenounced(address indexed previousOwner);
84     event OwnershipTransferred(
85         address indexed previousOwner,
86         address indexed newOwner
87     );
88 
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94     constructor() public {
95         owner = msg.sender;
96     }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101     modifier onlyOwner() {
102         require(msg.sender == owner);
103         _;
104     }
105 
106   /**
107    * @dev Allows the current owner to relinquish control of the contract.
108    * @notice Renouncing to ownership will leave the contract without an owner.
109    * It will not be possible to call the functions with the `onlyOwner`
110    * modifier anymore.
111    */
112     function renounceOwnership() public onlyOwner {
113         emit OwnershipRenounced(owner);
114         owner = address(0);
115     }
116 
117   /**
118    * @dev Allows the current owner to transfer control of the contract to a newOwner.
119    * @param _newOwner The address to transfer ownership to.
120    */
121     function transferOwnership(address _newOwner) public onlyOwner {
122         _transferOwnership(_newOwner);
123     }
124 
125   /**
126    * @dev Transfers control of the contract to a newOwner.
127    * @param _newOwner The address to transfer ownership to.
128    */
129     function _transferOwnership(address _newOwner) internal {
130         require(_newOwner != address(0));
131         emit OwnershipTransferred(owner, _newOwner);
132         owner = _newOwner;
133     }
134 }
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20Basic {
144 
145     using SafeMath for uint256;
146 
147     mapping(address => uint256) balances;
148 
149     uint256 totalSupply_;
150 
151     /**
152     * @dev Total number of tokens in existence
153     */
154     function totalSupply() public view returns (uint256) {
155         return totalSupply_;
156     }
157 
158     /**
159     * @dev Transfer token for a specified address
160     * @param _to The address to transfer to.
161     * @param _value The amount to be transferred.
162     */
163     function transfer(address _to, uint256 _value) public returns (bool) {
164         require(_value <= balances[msg.sender]);
165         require(_to != address(0));
166 
167         balances[msg.sender] = balances[msg.sender].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         emit Transfer(msg.sender, _to, _value);
170         return true;
171     }
172 
173     /**
174     * @dev Gets the balance of the specified address.
175     * @param _owner The address to query the the balance of.
176     * @return An uint256 representing the amount owned by the passed address.
177     */
178     function balanceOf(address _owner) public view returns (uint256) {
179         return balances[_owner];
180     }
181 
182     mapping (address => mapping (address => uint256)) internal allowed;
183 
184 
185     /**
186     * @dev Transfer tokens from one address to another
187     * @param _from address The address which you want to send tokens from
188     * @param _to address The address which you want to transfer to
189     * @param _value uint256 the amount of tokens to be transferred
190     */
191     function transferFrom(
192         address _from,
193         address _to,
194         uint256 _value
195     )
196         public
197         returns (bool)
198     {
199         require(_value <= balances[_from]);
200         require(_value <= allowed[_from][msg.sender]);
201         require(_to != address(0));
202 
203         balances[_from] = balances[_from].sub(_value);
204         balances[_to] = balances[_to].add(_value);
205         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
206         emit Transfer(_from, _to, _value);
207         return true;
208     }
209 
210     /**
211     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212     * Beware that changing an allowance with this method brings the risk that someone may use both the old
213     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216     * @param _spender The address which will spend the funds.
217     * @param _value The amount of tokens to be spent.
218     */
219     function approve(address _spender, uint256 _value) public returns (bool) {
220         allowed[msg.sender][_spender] = _value;
221         emit Approval(msg.sender, _spender, _value);
222         return true;
223     }
224 
225     /**
226     * @dev Function to check the amount of tokens that an owner allowed to a spender.
227     * @param _owner address The address which owns the funds.
228     * @param _spender address The address which will spend the funds.
229     * @return A uint256 specifying the amount of tokens still available for the spender.
230     */
231     function allowance(
232         address _owner,
233         address _spender
234     )
235         public
236         view
237         returns (uint256)
238     {
239         return allowed[_owner][_spender];
240     }
241 
242     /**
243     * @dev Increase the amount of tokens that an owner allowed to a spender.
244     * approve should be called when allowed[_spender] == 0. To increment
245     * allowed value is better to use this function to avoid 2 calls (and wait until
246     * the first transaction is mined)
247     * From MonolithDAO Token.sol
248     * @param _spender The address which will spend the funds.
249     * @param _addedValue The amount of tokens to increase the allowance by.
250     */
251     function increaseApproval(
252         address _spender,
253         uint256 _addedValue
254     )
255         public
256         returns (bool)
257     {
258         allowed[msg.sender][_spender] = (
259         allowed[msg.sender][_spender].add(_addedValue));
260         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263 
264     /**
265     * @dev Decrease the amount of tokens that an owner allowed to a spender.
266     * approve should be called when allowed[_spender] == 0. To decrement
267     * allowed value is better to use this function to avoid 2 calls (and wait until
268     * the first transaction is mined)
269     * From MonolithDAO Token.sol
270     * @param _spender The address which will spend the funds.
271     * @param _subtractedValue The amount of tokens to decrease the allowance by.
272     */
273     function decreaseApproval(
274         address _spender,
275         uint256 _subtractedValue
276     )
277         public
278         returns (bool)
279     {
280         uint256 oldValue = allowed[msg.sender][_spender];
281         if (_subtractedValue >= oldValue) {
282             allowed[msg.sender][_spender] = 0;
283         } else {
284             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285         }
286         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287         return true;
288     }
289 }
290 
291 /**
292  * @title Burnable Token
293  * @dev Token that can be irreversibly burned (destroyed).
294  */
295 contract BurnableToken is StandardToken {
296 
297     event Burn(address indexed burner, uint256 value);
298 
299     /**
300     * @dev Burns a specific amount of tokens.
301     * @param _value The amount of token to be burned.
302     */
303     function burn(uint256 _value) public {
304         _burn(msg.sender, _value);
305     }
306 
307     function _burn(address _who, uint256 _value) internal {
308         require(_value <= balances[_who]);
309         // no need to require value <= totalSupply, since that would imply the
310         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
311 
312         balances[_who] = balances[_who].sub(_value);
313         totalSupply_ = totalSupply_.sub(_value);
314         emit Burn(_who, _value);
315         emit Transfer(_who, address(0), _value);
316     }
317 }
318 
319 /**
320  * @title Mintable token
321  * @dev Simple ERC20 Token example, with mintable token creation
322  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
323  */
324 contract MintableToken is StandardToken, Ownable {
325     event Mint(address indexed to, uint256 amount);
326     event MintFinished();
327 
328     bool public mintingFinished = false;
329 
330 
331     modifier canMint() {
332         require(!mintingFinished);
333         _;
334     }
335 
336     modifier hasMintPermission() {
337         require(msg.sender == owner);
338         _;
339     }
340 
341     /**
342     * @dev Function to mint tokens
343     * @param _to The address that will receive the minted tokens.
344     * @param _amount The amount of tokens to mint.
345     * @return A boolean that indicates if the operation was successful.
346     */
347     function mint(
348         address _to,
349         uint256 _amount
350     )
351         hasMintPermission
352         canMint
353         public
354         returns (bool)
355     {
356         totalSupply_ = totalSupply_.add(_amount);
357         balances[_to] = balances[_to].add(_amount);
358         emit Mint(_to, _amount);
359         emit Transfer(address(0), _to, _amount);
360         return true;
361     }
362 
363     /**
364     * @dev Function to stop minting new tokens.
365     * @return True if the operation was successful.
366     */
367     function finishMinting() onlyOwner canMint public returns (bool) {
368         mintingFinished = true;
369         emit MintFinished();
370         return true;
371     }
372 }
373 
374 contract Controlled is Ownable{
375 
376     constructor() public {
377         setExclude(msg.sender);
378     }
379 
380     // Flag that determines if the token is transferable or not.
381     bool public transferEnabled = false;
382 
383     // flag that makes locked address effect
384     bool public plockFlag=true;
385     mapping(address => bool) locked;
386     mapping(address => bool) exclude;
387 
388     function enableTransfer(bool _enable) public onlyOwner{
389         transferEnabled = _enable;
390     }
391     
392     function enableLockFlag(bool _enable) public onlyOwner returns (bool success){
393         plockFlag = _enable;
394         return true;
395     }
396 
397     function addLock(address _addr) public onlyOwner returns (bool success){
398         require(_addr!=msg.sender);
399         locked[_addr] = true;
400         return true;
401     }
402 
403     function setExclude(address _addr) public onlyOwner returns (bool success){
404         exclude[_addr] = true;
405         return true;
406     }
407 
408     function removeLock(address _addr) public onlyOwner returns (bool success){
409         locked[_addr] = false;
410         return true;
411     }
412 
413     modifier transferAllowed(address _addr) {
414         if (!exclude[_addr]) {
415             assert(transferEnabled);
416             if(plockFlag){
417                 assert(!locked[_addr]);
418             }
419         }
420         
421         _;
422     }
423 
424 }
425 
426 /**
427  * @title Pausable token
428  *
429  * @dev StandardToken modified with pausable transfers.
430  **/
431 
432 contract PausableToken is StandardToken, Controlled {
433 
434     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
435         return super.transfer(_to, _value);
436     }
437 
438     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
439         return super.transferFrom(_from, _to, _value);
440     }
441 
442     function approve(address _spender, uint256 _value) public transferAllowed(msg.sender) returns (bool) {
443         return super.approve(_spender, _value);
444     }
445 }
446 
447 /*
448  * @title ARCloud
449  */
450 contract ARC is BurnableToken, MintableToken, PausableToken {
451     // Public variables of the token
452     string public name;
453     string public symbol;
454     // decimals is the strongly suggested default, avoid changing it
455     uint8 public decimals;
456 
457     constructor() public {
458         name = "ARCloud";
459         symbol = "ARC";
460         decimals = 18;
461         totalSupply_ = 1000000000 * 10 ** uint256(decimals);
462 
463         // Allocate initial balance to the owner
464         balances[msg.sender] = totalSupply_;
465     }
466 
467     // transfer balance to owner
468     function withdrawEther() onlyOwner public {
469         address addr = this;
470         owner.transfer(addr.balance);
471     }
472 
473     // can accept ether
474     function() payable public { }
475 
476     // Allocate tokens to the users
477     // @param _owners The owners list of the token
478     // @param _values The value list of the token
479     function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {
480 
481         require(_owners.length == _values.length, "data length mismatch");
482         address from = msg.sender;
483 
484         for(uint256 i = 0; i < _owners.length ; i++){
485             address to = _owners[i];
486             uint256 value = _values[i];
487             require(value <= balances[from]);
488 
489             balances[to] = balances[to].add(value);
490             balances[from] = balances[from].sub(value);
491             emit Transfer(from, to, value);
492         }
493     }
494 }