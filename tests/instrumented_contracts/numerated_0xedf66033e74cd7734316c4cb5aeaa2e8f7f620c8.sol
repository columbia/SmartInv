1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56 * @title Ownable
57 * @dev The Ownable contract has an owner address, and provides basic authorization control
58 * functions, this simplifies the implementation of "user permissions".
59 */
60 contract Ownable {
61     address public owner;
62     address public newOwner;
63 
64     event OwnershipRenounced(address indexed previousOwner);
65     event OwnershipTransferInitiated(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69     event OwnershipTransferred(
70         address indexed previousOwner,
71         address indexed newOwner
72     );
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
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89   
90     /**
91      * @dev Throws if called by any account other than the specific function owner.
92      */
93     modifier ownedBy(address _a) {
94         require( msg.sender == _a );
95         _;
96     }
97 
98     /**
99      * @dev Allows the current owner to relinquish control of the contract.
100      * @notice Renouncing to ownership will leave the contract without an owner.
101      * It will not be possible to call the functions with the `onlyOwner`
102      * modifier anymore.
103      */
104     function renounceOwnership() public onlyOwner {
105         emit OwnershipRenounced(owner);
106         owner = address(0);
107     }
108   
109     /**
110      * @dev Allows the current owner to transfer control of the contract to a newOwner.
111      * @param _newOwner The address to transfer ownership to. Needs to be accepted by
112      * the new owner.
113      */
114     function transferOwnership(address _newOwner) public onlyOwner {
115         _transferOwnership(_newOwner);
116     }
117 
118     /**
119      * @dev Allows the current owner to transfer control of the contract to a newOwner.
120      * @param _newOwner The address to transfer ownership to.
121      */
122     function transferOwnershipAtomic(address _newOwner) public onlyOwner {
123         owner = _newOwner;
124         newOwner = address(0);
125         emit OwnershipTransferred(owner, _newOwner);
126     }
127   
128     /**
129      * @dev Completes the ownership transfer by having the new address confirm the transfer.
130      */
131     function acceptOwnership() public {
132         require(msg.sender == newOwner);
133         emit OwnershipTransferred(owner, msg.sender);
134         owner = msg.sender;
135         newOwner = address(0);
136     }
137   
138     /**
139      * @dev Transfers control of the contract to a newOwner.
140      * @param _newOwner The address to transfer ownership to.
141      */
142     function _transferOwnership(address _newOwner) internal {
143         require(_newOwner != address(0));
144         newOwner = _newOwner;
145         emit OwnershipTransferInitiated(owner, _newOwner);
146     }
147 }
148 
149 
150 /**
151  * @title ERC20Basic
152  * @dev Simpler version of ERC20 interface
153  * See https://github.com/ethereum/EIPs/issues/179
154  */
155 contract ERC20Basic {
156   function totalSupply() public view returns (uint256);
157   function balanceOf(address who) public view returns (uint256);
158   function transfer(address to, uint256 value) public returns (bool);
159   event Transfer(address indexed from, address indexed to, uint256 value);
160 }
161 
162 
163 /**
164  * @title ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 is ERC20Basic {
168   function allowance(address owner, address spender)
169     public view returns (uint256);
170 
171   function transferFrom(address from, address to, uint256 value)
172     public returns (bool);
173 
174   function approve(address spender, uint256 value) public returns (bool);
175   event Approval(
176     address indexed owner,
177     address indexed spender,
178     uint256 value
179   );
180 }
181 
182 
183 /**
184  * @title Basic token
185  * @dev Basic version of StandardToken, with no allowances.
186  */
187 contract BasicToken is ERC20Basic {
188   using SafeMath for uint256;
189 
190   mapping(address => uint256) internal balances;
191 
192   uint256 internal totalSupply_;
193 
194   /**
195   * @dev Total number of tokens in existence
196   */
197   function totalSupply() public view returns (uint256) {
198     return totalSupply_;
199   }
200 
201   /**
202   * @dev Transfer token for a specified address
203   * @param _to The address to transfer to.
204   * @param _value The amount to be transferred.
205   */
206   function transfer(address _to, uint256 _value) public returns (bool) {
207     require(_value <= balances[msg.sender]);
208     require(_to != address(0));
209 
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     emit Transfer(msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) public view returns (uint256) {
222     return balances[_owner];
223   }
224 }
225 
226 
227 /**
228  * @title Standard ERC20 token
229  *
230  * @dev Implementation of the basic standard token.
231  * https://github.com/ethereum/EIPs/issues/20
232  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  */
234 contract StandardToken is ERC20, BasicToken {
235 
236   mapping (address => mapping (address => uint256)) internal allowed;
237 
238 
239   /**
240    * @dev Transfer tokens from one address to another
241    * @param _from address The address which you want to send tokens from
242    * @param _to address The address which you want to transfer to
243    * @param _value uint256 the amount of tokens to be transferred
244    */
245   function transferFrom(
246     address _from,
247     address _to,
248     uint256 _value
249   )
250     public
251     returns (bool)
252   {
253     require(_value <= balances[_from]);
254     require(_value <= allowed[_from][msg.sender]);
255     require(_to != address(0));
256 
257     balances[_from] = balances[_from].sub(_value);
258     balances[_to] = balances[_to].add(_value);
259     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
260     emit Transfer(_from, _to, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
266    * Beware that changing an allowance with this method brings the risk that someone may use both the old
267    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
268    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
269    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270    * @param _spender The address which will spend the funds.
271    * @param _value The amount of tokens to be spent.
272    */
273   function approve(address _spender, uint256 _value) public returns (bool) {
274     require( (allowed[msg.sender][_spender] == 0) || (_value == 0) );
275     allowed[msg.sender][_spender] = _value;
276     emit Approval(msg.sender, _spender, _value);
277     return true;
278   }
279 
280   /**
281    * @dev Function to check the amount of tokens that an owner allowed to a spender.
282    * @param _owner address The address which owns the funds.
283    * @param _spender address The address which will spend the funds.
284    * @return A uint256 specifying the amount of tokens still available for the spender.
285    */
286   function allowance(
287     address _owner,
288     address _spender
289    )
290     public
291     view
292     returns (uint256)
293   {
294     return allowed[_owner][_spender];
295   }
296 
297   /**
298    * @dev Increase the amount of tokens that an owner allowed to a spender.
299    * approve should be called when allowed[_spender] == 0. To increment
300    * allowed value is better to use this function to avoid 2 calls (and wait until
301    * the first transaction is mined)
302    * From MonolithDAO Token.sol
303    * @param _spender The address which will spend the funds.
304    * @param _addedValue The amount of tokens to increase the allowance by.
305    */
306   function increaseApproval(
307     address _spender,
308     uint256 _addedValue
309   )
310     public
311     returns (bool)
312   {
313     allowed[msg.sender][_spender] = (
314       allowed[msg.sender][_spender].add(_addedValue));
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319   /**
320    * @dev Decrease the amount of tokens that an owner allowed to a spender.
321    * approve should be called when allowed[_spender] == 0. To decrement
322    * allowed value is better to use this function to avoid 2 calls (and wait until
323    * the first transaction is mined)
324    * From MonolithDAO Token.sol
325    * @param _spender The address which will spend the funds.
326    * @param _subtractedValue The amount of tokens to decrease the allowance by.
327    */
328   function decreaseApproval(
329     address _spender,
330     uint256 _subtractedValue
331   )
332     public
333     returns (bool)
334   {
335     uint256 oldValue = allowed[msg.sender][_spender];
336     if (_subtractedValue >= oldValue) {
337       allowed[msg.sender][_spender] = 0;
338     } else {
339       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
340     }
341     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
342     return true;
343   }
344 
345 }
346 
347 
348 /**
349  * @title Mintable token
350  * @dev Simple ERC20 Token example, with mintable token creation
351  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
352  */
353 contract MintableToken is StandardToken, Ownable {
354     event Mint(address indexed to, uint256 amount);
355     event MintFinished();
356 
357     // Overflow check: 2700 *1e6 * 1e18 < 10^30 < 2^105 < 2^256
358     uint constant public SUPPLY_HARD_CAP = 2700 * 1e6 * 1e18;
359     bool public mintingFinished = false;
360 
361     modifier canMint() {
362         require(!mintingFinished);
363         _;
364     }
365 
366     modifier hasMintPermission() {
367         require(msg.sender == owner);
368         _;
369     }
370 
371     /**
372      * @dev Function to mint tokens
373      * @param _to The address that will receive the minted tokens.
374      * @param _amount The amount of tokens to mint.
375      * @return A boolean that indicates if the operation was successful.
376      */
377     function mint(
378         address _to,
379         uint256 _amount
380     )
381         public
382         hasMintPermission
383         canMint
384         returns (bool)
385     {
386         require( totalSupply_.add(_amount) <= SUPPLY_HARD_CAP );
387         totalSupply_ = totalSupply_.add(_amount);
388         balances[_to] = balances[_to].add(_amount);
389         emit Mint(_to, _amount);
390         emit Transfer(address(0), _to, _amount);
391         return true;
392     }
393 
394     /**
395      * @dev Function to stop minting new tokens.
396      * @return True if the operation was successful.
397      */
398     function finishMinting() public onlyOwner canMint returns (bool) {
399         mintingFinished = true;
400         emit MintFinished();
401         return true;
402     }
403 }
404 
405 
406 contract OPUCoin is MintableToken {
407     string constant public symbol = "OPU";
408     string constant public name = "Opu Coin";
409     uint8 constant public decimals = 18;
410 
411     // -------------------------------------------
412 	// Public functions
413     // -------------------------------------------
414     constructor() public { }
415 }