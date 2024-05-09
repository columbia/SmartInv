1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94 
95   /**
96   * @dev Multiplies two numbers, throws on overflow.
97   */
98   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
99     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
100     // benefit is lost if 'b' is also tested.
101     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
102     if (a == 0) {
103       return 0;
104     }
105 
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return a / b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 
140 
141 /**
142  * @title Basic token
143  * @dev Basic version of StandardToken, with no allowances.
144  */
145 contract BasicToken is ERC20Basic {
146   using SafeMath for uint256;
147 
148   mapping(address => uint256) balances;
149 
150   uint256 totalSupply_;
151 
152   /**
153   * @dev total number of tokens in existence
154   */
155   function totalSupply() public view returns (uint256) {
156     return totalSupply_;
157   }
158 
159   /**
160   * @dev transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   function transfer(address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[msg.sender]);
167 
168     balances[msg.sender] = balances[msg.sender].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     emit Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174   /**
175   * @dev Gets the balance of the specified address.
176   * @param _owner The address to query the the balance of.
177   * @return An uint256 representing the amount owned by the passed address.
178   */
179   function balanceOf(address _owner) public view returns (uint256) {
180     return balances[_owner];
181   }
182 
183 }
184 
185 
186 
187 
188 
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender)
196     public view returns (uint256);
197 
198   function transferFrom(address from, address to, uint256 value)
199     public returns (bool);
200 
201   function approve(address spender, uint256 value) public returns (bool);
202   event Approval(
203     address indexed owner,
204     address indexed spender,
205     uint256 value
206   );
207 }
208 
209 
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(
230     address _from,
231     address _to,
232     uint256 _value
233   )
234     public
235     returns (bool)
236   {
237     require(_to != address(0));
238     require(_value <= balances[_from]);
239     require(_value <= allowed[_from][msg.sender]);
240 
241     balances[_from] = balances[_from].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
244     emit Transfer(_from, _to, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250    *
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) public returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(
271     address _owner,
272     address _spender
273    )
274     public
275     view
276     returns (uint256)
277   {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    *
284    * approve should be called when allowed[_spender] == 0. To increment
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _addedValue The amount of tokens to increase the allowance by.
290    */
291   function increaseApproval(
292     address _spender,
293     uint _addedValue
294   )
295     public
296     returns (bool)
297   {
298     allowed[msg.sender][_spender] = (
299       allowed[msg.sender][_spender].add(_addedValue));
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    *
307    * approve should be called when allowed[_spender] == 0. To decrement
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    * @param _spender The address which will spend the funds.
312    * @param _subtractedValue The amount of tokens to decrease the allowance by.
313    */
314   function decreaseApproval(
315     address _spender,
316     uint _subtractedValue
317   )
318     public
319     returns (bool)
320   {
321     uint oldValue = allowed[msg.sender][_spender];
322     if (_subtractedValue > oldValue) {
323       allowed[msg.sender][_spender] = 0;
324     } else {
325       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326     }
327     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328     return true;
329   }
330 
331 }
332 
333 
334 
335 
336 /**
337  * @title Mintable token
338  * @dev Simple ERC20 Token example, with mintable token creation
339  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
340  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
341  */
342 contract MintableToken is StandardToken, Ownable {
343   event Mint(address indexed to, uint256 amount);
344   event MintFinished();
345 
346   bool public mintingFinished = false;
347 
348 
349   modifier canMint() {
350     require(!mintingFinished);
351     _;
352   }
353 
354   modifier hasMintPermission() {
355     require(msg.sender == owner);
356     _;
357   }
358 
359   /**
360    * @dev Function to mint tokens
361    * @param _to The address that will receive the minted tokens.
362    * @param _amount The amount of tokens to mint.
363    * @return A boolean that indicates if the operation was successful.
364    */
365   function mint(
366     address _to,
367     uint256 _amount
368   )
369     hasMintPermission
370     canMint
371     public
372     returns (bool)
373   {
374     totalSupply_ = totalSupply_.add(_amount);
375     balances[_to] = balances[_to].add(_amount);
376     emit Mint(_to, _amount);
377     emit Transfer(address(0), _to, _amount);
378     return true;
379   }
380 
381   /**
382    * @dev Function to stop minting new tokens.
383    * @return True if the operation was successful.
384    */
385   function finishMinting() onlyOwner canMint public returns (bool) {
386     mintingFinished = true;
387     emit MintFinished();
388     return true;
389   }
390 }
391 
392 
393 contract SolidToken is MintableToken {
394 
395   string public constant name = "SolidToken";
396   string public constant symbol = "SOLID";
397   uint8  public constant decimals = 18;
398 
399   uint256 constant private DECIMAL_PLACES = 10 ** 18;
400   uint256 constant SUPPLY_CAP = 4000000 * DECIMAL_PLACES;
401 
402   bool public transfersEnabled = false;
403   uint256 public transferEnablingDate;
404 
405 
406   /**
407    * @dev Sets the date that the tokens becomes transferable
408    * @param date The timestamp of the date
409    * @return A boolean that indicates if the operation was successful.
410    */
411   function setTransferEnablingDate(uint256 date) public onlyOwner returns(bool success) {
412     transferEnablingDate = date;
413     return true;
414   }
415 
416 
417   /**
418    * @dev Enables the token transfer
419    */
420   function enableTransfer() public {
421     require(transferEnablingDate != 0 && now >= transferEnablingDate);
422     transfersEnabled = true;
423   }
424 
425 
426 
427   // OVERRIDES
428   /**
429    * @dev Function to mint tokens. Overriden to check for supply cap.
430    * @param _to The address that will receive the minted tokens.
431    * @param _amount The amount of tokens to mint.
432    * @return A boolean that indicates if the operation was successful.
433    */
434   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
435     require(totalSupply_.add(_amount) <= SUPPLY_CAP);
436     require(super.mint(_to, _amount));
437     return true;
438   }
439 
440   /**
441   * @dev transfer token for a specified address
442   * @param _to The address to transfer to.
443   * @param _value The amount to be transferred.
444   */
445   function transfer(address _to, uint256 _value) public returns (bool) {
446     require(transfersEnabled, "Tranfers are disabled");
447     require(super.transfer(_to, _value));
448     return true;
449   }
450 
451 
452   /**
453    * @dev Transfer tokens from one address to another
454    * @param _from address The address which you want to send tokens from
455    * @param _to address The address which you want to transfer to
456    * @param _value uint256 the amount of tokens to be transferred
457    */
458   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
459     require(transfersEnabled, "Tranfers are disabled");
460     require(super.transferFrom(_from, _to, _value));
461     return true;
462   }
463 
464 
465 }