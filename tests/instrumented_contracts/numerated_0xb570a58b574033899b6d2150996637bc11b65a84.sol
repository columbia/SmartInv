1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   /**
26   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
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
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 
81 }
82 
83 
84 /**
85  * @title Pausable
86  * @dev Base contract which allows children to implement an emergency stop mechanism.
87  */
88 contract Pausable is Ownable {
89   event Pause();
90   event Unpause();
91 
92   bool public paused = false;
93 
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is not paused.
97    */
98   modifier whenNotPaused() {
99     require(!paused);
100     _;
101   }
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is paused.
105    */
106   modifier whenPaused() {
107     require(paused);
108     _;
109   }
110 
111   /**
112    * @dev called by the owner to pause, triggers stopped state
113    */
114   function pause() onlyOwner whenNotPaused public {
115     paused = true;
116     Pause();
117   }
118 
119   /**
120    * @dev called by the owner to unpause, returns to normal state
121    */
122   function unpause() onlyOwner whenPaused public {
123     paused = false;
124     Unpause();
125   }
126 }
127 
128 /**
129  * @title ERC20Basic
130  * @dev Simpler version of ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/179
132  */
133 contract ERC20Basic {
134   function totalSupply() public view returns (uint256);
135   function balanceOf(address who) public view returns (uint256);
136   function transfer(address to, uint256 value) public returns (bool);
137   event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 
152 /**
153  * @title Basic token
154  * @dev Basic version of StandardToken, with no allowances.
155  */
156 contract BasicToken is ERC20Basic {
157   using SafeMath for uint256;
158 
159   mapping(address => uint256) balances;
160 
161   uint256 totalSupply_;
162 
163   /**
164   * @dev total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return totalSupply_;
168   }
169 
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175 
176   function transfer(address _to, uint256 _value) public  returns (bool) {
177 
178 
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197 }
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) internal allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    *
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(address _owner, address _spender) public view returns (uint256) {
251     return allowed[_owner][_spender];
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To increment
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _addedValue The amount of tokens to increase the allowance by.
263    */
264   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   /**
271    * @dev Decrease the amount of tokens that an owner allowed to a spender.
272    *
273    * approve should be called when allowed[_spender] == 0. To decrement
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _subtractedValue The amount of tokens to decrease the allowance by.
279    */
280   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
281     uint oldValue = allowed[msg.sender][_spender];
282     if (_subtractedValue > oldValue) {
283       allowed[msg.sender][_spender] = 0;
284     } else {
285       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286     }
287     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291 }
292 /**
293  * @title Mintable token
294  * @dev Simple ERC20 Token example, with mintable token creation
295  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
296  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
297  */
298 contract MintableToken is StandardToken, Ownable {
299   event Mint(address indexed to, uint256 amount);
300   event MintFinished();
301 
302   bool public mintingFinished = false;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
317     totalSupply_ = totalSupply_.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     Mint(_to, _amount);
320     Transfer(address(0), _to, _amount);
321     return true;
322   }
323 
324   /**
325    * @dev Function to stop minting new tokens.
326    * @return True if the operation was successful.
327    */
328   function finishMinting() onlyOwner canMint public returns (bool) {
329     mintingFinished = true;
330     MintFinished();
331     return true;
332   }
333 }
334 /**
335  * @title Pausable token
336  * @dev StandardToken modified with pausable transfers.
337  **/
338 contract PausableToken is StandardToken, Pausable {
339 
340   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
341     return super.transfer(_to, _value);
342   }
343 
344   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
345     return super.transferFrom(_from, _to, _value);
346   }
347 
348   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
349     return super.approve(_spender, _value);
350   }
351 
352   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
353     return super.increaseApproval(_spender, _addedValue);
354   }
355 
356   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
357     return super.decreaseApproval(_spender, _subtractedValue);
358   }
359 }
360 /**
361  * @dev Smw token ERC20 contract
362  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
363  */
364 contract Smw is MintableToken, PausableToken {
365     string public constant version = "1.1";
366     string public constant name = "Sameway DIGICCY";
367     string public constant symbol = "SMW";
368     uint8 public constant decimals = 18;
369 
370     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
371 
372     address public mintMaster;
373 
374     modifier onlyMintMasterOrOwner() {
375         require(msg.sender == mintMaster || msg.sender == owner);
376         _;
377     }
378 
379     function Smw() public {
380         mintMaster = msg.sender;
381     }
382 
383     function transferMintMaster(address newMaster) onlyOwner public {
384         require(newMaster != address(0));
385         MintMasterTransferred(mintMaster, newMaster);
386         mintMaster = newMaster;
387     }
388 
389     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
390         for (uint i = 0; i < addresses.length; i++) {
391             require(mint(addresses[i], amount));
392         }
393     }
394 
395     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
396         require(addresses.length == amounts.length);
397         for (uint i = 0; i < addresses.length; i++) {
398             require(mint(addresses[i], amounts[i]));
399         }
400     }
401     /**
402      * @dev Function to mint tokens
403      * @param _to The address that will receive the minted tokens.
404      * @param _amount The amount of tokens to mint.
405      * @return A boolean that indicates if the operation was successful.
406      */
407     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
408 
409 
410         address oldOwner = owner;
411         owner = msg.sender;
412         bool result = super.mint(_to, _amount);
413         owner = oldOwner;
414         return result;
415     }
416 
417 
418 
419 
420 }