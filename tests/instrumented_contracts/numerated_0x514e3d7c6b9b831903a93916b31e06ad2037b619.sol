1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address public owner;
63 
64 
65  
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param _newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address _newOwner) public onlyOwner {
94     _transferOwnership(_newOwner);
95   }
96 
97   /**
98    * @dev Transfers control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function _transferOwnership(address _newOwner) internal {
102     require(_newOwner != address(0));
103     emit OwnershipTransferred(owner, _newOwner);
104     owner = _newOwner;
105   }
106 }
107 
108 
109 /**
110  * @title Pausable
111  * @dev Base contract which allows children to implement an emergency stop mechanism.
112  */
113 contract Pausable is Ownable {
114   event Pause();
115   event Unpause();
116 
117   bool public paused = false;
118 
119 
120   /**
121    * @dev Modifier to make a function callable only when the contract is not paused.
122    */
123   modifier whenNotPaused() {
124     require(!paused);
125     _;
126   }
127 
128   /**
129    * @dev Modifier to make a function callable only when the contract is paused.
130    */
131   modifier whenPaused() {
132     require(paused);
133     _;
134   }
135 
136   /**
137    * @dev called by the owner to pause, triggers stopped state
138    */
139   function pause() onlyOwner whenNotPaused public {
140     paused = true;
141     emit Pause();
142   }
143 
144   /**
145    * @dev called by the owner to unpause, returns to normal state
146    */
147   function unpause() onlyOwner whenPaused public {
148     paused = false;
149     emit Unpause();
150   }
151 }
152 
153 /**
154  * @title ERC20Basic
155  * @dev Simpler version of ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/179
157  */
158 contract ERC20Basic {
159   function totalSupply() public view returns (uint256);
160   function balanceOf(address who) public view returns (uint256);
161   function transfer(address to, uint256 value) public returns (bool);
162   event Transfer(address indexed from, address indexed to, uint256 value);
163 }
164 
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender)
172     public view returns (uint256);
173 
174   function transferFrom(address from, address to, uint256 value)
175     public returns (bool);
176 
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(
179     address indexed owner,
180     address indexed spender,
181     uint256 value
182   );
183 }
184 
185 
186 /**
187  * @title Basic token
188  * @dev Basic version of StandardToken, with no allowances.
189  */
190 contract BasicToken is ERC20Basic, Ownable {
191   using SafeMath for uint256;
192 
193   mapping(address => uint256) balances;
194 
195   uint256 totalSupply_;
196 
197   /**
198   * @dev Total number of tokens in existence
199   */
200   function totalSupply() public view returns (uint256) {
201     return totalSupply_;
202   }
203 
204   /**
205   * @dev Transfer token for a specified address
206   * @param _to The address to transfer to.
207   * @param _value The amount to be transferred.
208   */
209   function transfer(address _to, uint256 _value) public returns (bool) {
210     require(_to != address(0));
211     require(_value <= balances[msg.sender]);
212 
213     balances[msg.sender] = balances[msg.sender].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     emit Transfer(msg.sender, _to, _value);
216     return true;
217   }
218 
219   /**
220   * @dev Gets the balance of the specified address.
221   * @param _owner The address to query the the balance of.
222   * @return An uint256 representing the amount owned by the passed address.
223   */
224   function balanceOf(address _owner) public view returns (uint256) {
225     return balances[_owner];
226   }
227 
228 }
229 
230 
231 /**
232  * @title Standard ERC20 token
233  *
234  * @dev Implementation of the basic standard token.
235  * @dev https://github.com/ethereum/EIPs/issues/20
236  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
237  */
238 contract StandardToken is ERC20, BasicToken {
239 
240   mapping (address => mapping (address => uint256)) internal allowed;
241 
242 
243   /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249   function transferFrom(
250     address _from,
251     address _to,
252     uint256 _value
253   )
254     public
255     returns (bool)
256   {
257     require(_to != address(0));
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260 
261     balances[_from] = balances[_from].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
264     emit Transfer(_from, _to, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
270    *
271    * Beware that changing an allowance with this method brings the risk that someone may use both the old
272    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
273    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
274    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275    * @param _spender The address which will spend the funds.
276    * @param _value The amount of tokens to be spent.
277    */
278   function approve(address _spender, uint256 _value) public returns (bool) {
279     allowed[msg.sender][_spender] = _value;
280     emit Approval(msg.sender, _spender, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Function to check the amount of tokens that an owner allowed to a spender.
286    * @param _owner address The address which owns the funds.
287    * @param _spender address The address which will spend the funds.
288    * @return A uint256 specifying the amount of tokens still available for the spender.
289    */
290   function allowance(
291     address _owner,
292     address _spender
293    )
294     public
295     view
296     returns (uint256)
297   {
298     return allowed[_owner][_spender];
299   }
300 
301   
302   /**
303    * @dev Function to revert eth transfers to this contract
304     */
305     function() public payable {
306 	    revert();
307 	}
308 	
309 	
310    /**
311    * @dev  Owner can transfer out any accidentally sent ERC20 tokens
312    */
313  function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
314         return BasicToken(tokenAddress).transfer(owner, tokens);
315     }
316  
317 }
318 
319 
320 
321 
322 
323 /**
324  * @title Pausable token
325  * @dev StandardToken modified with pausable transfers.
326  **/
327 contract PausableToken is StandardToken, Pausable {
328 
329   function transfer(
330     address _to,
331     uint256 _value
332   )
333     public
334     whenNotPaused
335     returns (bool)
336   {
337     return super.transfer(_to, _value);
338   }
339 
340   function transferFrom(
341     address _from,
342     address _to,
343     uint256 _value
344   )
345     public
346     whenNotPaused
347     returns (bool)
348   {
349     return super.transferFrom(_from, _to, _value);
350   }
351 
352   function approve(
353     address _spender,
354     uint256 _value
355   )
356     public
357     whenNotPaused
358     returns (bool)
359   {
360     return super.approve(_spender, _value);
361   }
362 
363 
364      /**
365     * @dev Transfer the specified amounts of tokens to the specified addresses.
366     * @dev Be aware that there is no check for duplicate recipients.
367     *
368     * @param _toAddresses Receiver addresses.
369     * @param _amounts Amounts of tokens that will be transferred.
370     */
371     function multiTransfer(address[] _toAddresses, uint256[] _amounts) public whenNotPaused returns (bool) {
372         /* Ensures _toAddresses array is less than or equal to 255 */
373         require(_toAddresses.length <= 255);
374         /* Ensures _toAddress and _amounts have the same number of entries. */
375         require(_toAddresses.length == _amounts.length);
376 
377         for (uint8 i = 0; i < _toAddresses.length; i++) {
378             transfer(_toAddresses[i], _amounts[i]);
379         }
380     }
381 
382     /**
383     * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
384     * @dev Be aware that there is no check for duplicate recipients.
385     *
386     * @param _from The address of the sender
387     * @param _toAddresses The addresses of the recipients (MAX 255)
388     * @param _amounts The amounts of tokens to be transferred
389     */
390     function multiTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public whenNotPaused returns (bool) {
391         /* Ensures _toAddresses array is less than or equal to 255 */
392         require(_toAddresses.length <= 255);
393         /* Ensures _toAddress and _amounts have the same number of entries. */
394         require(_toAddresses.length == _amounts.length);
395 
396         for (uint8 i = 0; i < _toAddresses.length; i++) {
397             transferFrom(_from, _toAddresses[i], _amounts[i]);
398         }
399     }
400 
401 
402 }
403 
404 
405  contract AkoinToken is PausableToken {
406 
407   string public constant name = "Akoin";
408   string public constant symbol = "AKOIN"; 
409   uint8 public constant decimals = 18; 
410 
411   uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));
412 
413   /**
414    * @dev Constructor that gives msg.sender all of existing tokens.
415    */
416   constructor() public {
417     totalSupply_ = INITIAL_SUPPLY;
418     balances[msg.sender] = INITIAL_SUPPLY;
419     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
420   }
421 
422 }