1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (a == 0) {
82       return 0;
83     }
84 
85     c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return a / b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112     c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * See https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   function totalSupply() public view returns (uint256);
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 
133 
134 
135 
136 
137 
138 
139 
140 /**
141  * @title Basic token
142  * @dev Basic version of StandardToken, with no allowances.
143  */
144 contract BasicToken is ERC20Basic {
145   using SafeMath for uint256;
146 
147   mapping(address => uint256) balances;
148 
149   uint256 totalSupply_;
150 
151   /**
152   * @dev Total number of tokens in existence
153   */
154   function totalSupply() public view returns (uint256) {
155     return totalSupply_;
156   }
157 
158   /**
159   * @dev Transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[msg.sender]);
166 
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     emit Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint256 representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) public view returns (uint256) {
179     return balances[_owner];
180   }
181 
182 }
183 
184 
185 
186 
187 
188 
189 
190 
191 
192 
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender)
200     public view returns (uint256);
201 
202   function transferFrom(address from, address to, uint256 value)
203     public returns (bool);
204 
205   function approve(address spender, uint256 value) public returns (bool);
206   event Approval(
207     address indexed owner,
208     address indexed spender,
209     uint256 value
210   );
211 }
212 
213 
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * https://github.com/ethereum/EIPs/issues/20
220  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(
234     address _from,
235     address _to,
236     uint256 _value
237   )
238     public
239     returns (bool)
240   {
241     require(_to != address(0));
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     emit Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _value) public returns (bool) {
262     allowed[msg.sender][_spender] = _value;
263     emit Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(
274     address _owner,
275     address _spender
276    )
277     public
278     view
279     returns (uint256)
280   {
281     return allowed[_owner][_spender];
282   }
283 
284   /**
285    * @dev Increase the amount of tokens that an owner allowed to a spender.
286    * approve should be called when allowed[_spender] == 0. To increment
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _addedValue The amount of tokens to increase the allowance by.
292    */
293   function increaseApproval(
294     address _spender,
295     uint256 _addedValue
296   )
297     public
298     returns (bool)
299   {
300     allowed[msg.sender][_spender] = (
301       allowed[msg.sender][_spender].add(_addedValue));
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   /**
307    * @dev Decrease the amount of tokens that an owner allowed to a spender.
308    * approve should be called when allowed[_spender] == 0. To decrement
309    * allowed value is better to use this function to avoid 2 calls (and wait until
310    * the first transaction is mined)
311    * From MonolithDAO Token.sol
312    * @param _spender The address which will spend the funds.
313    * @param _subtractedValue The amount of tokens to decrease the allowance by.
314    */
315   function decreaseApproval(
316     address _spender,
317     uint256 _subtractedValue
318   )
319     public
320     returns (bool)
321   {
322     uint256 oldValue = allowed[msg.sender][_spender];
323     if (_subtractedValue > oldValue) {
324       allowed[msg.sender][_spender] = 0;
325     } else {
326       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
327     }
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332 }
333 
334 
335 
336 
337 /**
338  * @title Mintable token
339  * @dev Simple ERC20 Token example, with mintable token creation
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
393 
394 contract DioToken is BasicToken, MintableToken {
395 
396     /**
397     * @dev Math operations with safety checks that throw on error
398     */
399     using SafeMath for uint256;
400 
401     string public constant name = "DIO Token";
402     string public constant symbol = "DIO";
403     uint8  public constant decimals = 8;
404 
405     /**
406     * @dev E8 represents the number 100000000, allowing easy multiplications between the minimal
407     */
408     uint constant E8 = 10**8;
409 
410     function transfer(
411         address _to,
412         uint256 _value
413     )
414     public
415     onlyOwner
416     returns (bool)
417     {
418         return super.transfer(_to, _value);
419     }
420 
421     function transferFrom(
422         address _from,
423         address _to,
424         uint256 _value
425     )
426     public
427     onlyOwner
428     returns (bool)
429     {
430         return super.transferFrom(_from, _to, _value);
431     }
432 
433     function approve(
434         address _spender,
435         uint256 _value
436     )
437     public
438     onlyOwner
439     returns (bool)
440     {
441         return super.approve(_spender, _value);
442     }
443 
444     function increaseApproval(
445         address _spender,
446         uint _addedValue
447     )
448     public
449     onlyOwner
450     returns (bool success)
451     {
452         return super.increaseApproval(_spender, _addedValue);
453     }
454 
455     function decreaseApproval(
456         address _spender,
457         uint _subtractedValue
458     )
459     public
460     onlyOwner
461     returns (bool success)
462     {
463         return super.decreaseApproval(_spender, _subtractedValue);
464     }
465 }