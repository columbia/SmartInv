1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10 
11   function balanceOf(address _who) public view returns (uint256);
12 
13   function allowance(address _owner, address _spender)
14     public view returns (uint256);
15 
16   function transfer(address _to, uint256 _value) public returns (bool);
17 
18   function approve(address _spender, uint256 _value)
19     public returns (bool);
20 
21   function transferFrom(address _from, address _to, uint256 _value)
22     public returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipRenounced(address indexed previousOwner);
49   event OwnershipTransferred(
50     address indexed previousOwner,
51     address indexed newOwner
52   );
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   constructor() public {
60     owner = msg.sender;
61   }
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71   /**
72    * @dev Allows the current owner to relinquish control of the contract.
73    * @notice Renouncing to ownership will leave the contract without an owner.
74    * It will not be possible to call the functions with the `onlyOwner`
75    * modifier anymore.
76    */
77   function renounceOwnership() public onlyOwner {
78     emit OwnershipRenounced(owner);
79     owner = address(0);
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address _newOwner) public onlyOwner {
87     _transferOwnership(_newOwner);
88   }
89 
90   /**
91    * @dev Transfers control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function _transferOwnership(address _newOwner) internal {
95     require(_newOwner != address(0));
96     emit OwnershipTransferred(owner, _newOwner);
97     owner = _newOwner;
98   }
99 }
100 
101 
102 
103 
104 
105 
106 
107 
108 
109 
110 /**
111  * @title SafeMath
112  * @dev Math operations with safety checks that throw on error
113  */
114 library SafeMath {
115 
116   /**
117   * @dev Multiplies two numbers, throws on overflow.
118   */
119   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
120     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
121     // benefit is lost if 'b' is also tested.
122     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
123     if (_a == 0) {
124       return 0;
125     }
126 
127     uint256 c = _a * _b;
128     assert(c / _a == _b);
129 
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
137     // assert(_b > 0); // Solidity automatically throws when dividing by 0
138     uint256 c = _a / _b;
139     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
140 
141     return c;
142   }
143 
144   /**
145   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
146   */
147   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
148     assert(_b <= _a);
149     uint256 c = _a - _b;
150 
151     return c;
152   }
153 
154   /**
155   * @dev Adds two numbers, throws on overflow.
156   */
157   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
158     uint256 c = _a + _b;
159     assert(c >= _a);
160 
161     return c;
162   }
163 }
164 
165 
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * https://github.com/ethereum/EIPs/issues/20
172  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20 {
175   using SafeMath for uint256;
176 
177   mapping(address => uint256) balances;
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181   uint256 totalSupply_;
182 
183   /**
184   * @dev Total number of tokens in existence
185   */
186   function totalSupply() public view returns (uint256) {
187     return totalSupply_;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256) {
196     return balances[_owner];
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(
206     address _owner,
207     address _spender
208    )
209     public
210     view
211     returns (uint256)
212   {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217   * @dev Transfer token for a specified address
218   * @param _to The address to transfer to.
219   * @param _value The amount to be transferred.
220   */
221   function transfer(address _to, uint256 _value) public returns (bool) {
222     require(_value <= balances[msg.sender]);
223     require(_to != address(0));
224 
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     emit Transfer(msg.sender, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     emit Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Transfer tokens from one address to another
248    * @param _from address The address which you want to send tokens from
249    * @param _to address The address which you want to transfer to
250    * @param _value uint256 the amount of tokens to be transferred
251    */
252   function transferFrom(
253     address _from,
254     address _to,
255     uint256 _value
256   )
257     public
258     returns (bool)
259   {
260     require(_value <= balances[_from]);
261     require(_value <= allowed[_from][msg.sender]);
262     require(_to != address(0));
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To increment
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _addedValue The amount of tokens to increase the allowance by.
279    */
280   function increaseApproval(
281     address _spender,
282     uint256 _addedValue
283   )
284     public
285     returns (bool)
286   {
287     allowed[msg.sender][_spender] = (
288       allowed[msg.sender][_spender].add(_addedValue));
289     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint256 _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint256 oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue >= oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 
322 
323 
324 /**
325  * @title Mintable token
326  * @dev Simple ERC20 Token example, with mintable token creation
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     public
357     hasMintPermission
358     canMint
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() public onlyOwner canMint returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 
380 
381 
382 
383 
384 /**
385  * @title Burnable Token
386  * @dev Token that can be irreversibly burned (destroyed).
387  */
388 contract BurnableToken is StandardToken {
389 
390   event Burn(address indexed burner, uint256 value);
391 
392   /**
393    * @dev Burns a specific amount of tokens.
394    * @param _value The amount of token to be burned.
395    */
396   function burn(uint256 _value) public {
397     _burn(msg.sender, _value);
398   }
399 
400   /**
401    * @dev Burns a specific amount of tokens from the target address and decrements allowance
402    * @param _from address The address which you want to send tokens from
403    * @param _value uint256 The amount of token to be burned
404    */
405   function burnFrom(address _from, uint256 _value) public {
406     require(_value <= allowed[_from][msg.sender]);
407     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
408     // this function needs to emit an event with the updated approval.
409     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
410     _burn(_from, _value);
411   }
412 
413   function _burn(address _who, uint256 _value) internal {
414     require(_value <= balances[_who]);
415     // no need to require value <= totalSupply, since that would imply the
416     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
417 
418     balances[_who] = balances[_who].sub(_value);
419     totalSupply_ = totalSupply_.sub(_value);
420     emit Burn(_who, _value);
421     emit Transfer(_who, address(0), _value);
422   }
423 }
424 
425 contract Winsshar is MintableToken, BurnableToken {
426 
427 
428     string public name = "Winsshar";
429     string public symbol = "WSR";
430     uint public decimals = 18;
431 
432     uint public totalSupply = 100 * (10**6) * (10 ** uint256(decimals)) ;
433 
434     address public PartnersAddress = 0x0b465b9986f559B3bbB24ac2a4Dd7F85CAb3f9e9;
435 
436     uint256 PartnersTokens = 20 * (10**6) * (10**uint256(decimals));
437 
438     constructor () public {
439         balances[PartnersAddress] = PartnersTokens; //Partners 
440         balances[msg.sender] = totalSupply - PartnersTokens; //public
441     }
442     //////////////// owner only functions below
443 
444     /// @notice To transfer token contract ownership
445     /// @param _newOwner The address of the new owner of this contract
446     function transferOwnership(address _newOwner) public onlyOwner {
447         balances[_newOwner] = balances[owner];
448         balances[owner] = 0;
449         Ownable.transferOwnership(_newOwner);
450     }
451 }