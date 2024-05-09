1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 
54 
55 /**
56  * @title MultiOwnable
57  */
58 contract MultiOwnable {
59   address public root;
60   mapping (address => address) public owners; // owner => parent of owner
61   
62   /**
63   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64   * account.
65   */
66   constructor() public {
67     root = msg.sender;
68     owners[root] = root;
69   }
70   
71   /**
72   * @dev Throws if called by any account other than the owner.
73   */
74   modifier onlyOwner() {
75     require(owners[msg.sender] != 0);
76     _;
77   }
78   
79   /**
80   * @dev Adding new owners
81   */
82   function newOwner(address _owner) onlyOwner external returns (bool) {
83     require(_owner != 0);
84     owners[_owner] = msg.sender;
85     return true;
86   }
87   
88   /**
89     * @dev Deleting owners
90     */
91   function deleteOwner(address _owner) onlyOwner external returns (bool) {
92     require(owners[_owner] == msg.sender || (owners[_owner] != 0 && msg.sender == root));
93     owners[_owner] = 0;
94     return true;
95   }
96 }
97 
98 
99 
100 /**
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address who) public view returns (uint256);
108   function transfer(address to, uint256 value) public returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 /**
126  * @title Basic token
127  * @dev Basic version of StandardToken, with no allowances.
128  */
129 contract BasicToken is ERC20Basic {
130   using SafeMath for uint256;
131 
132   mapping(address => uint256) balances;
133 
134   uint256 totalSupply_;
135 
136   /**
137   * @dev total number of tokens in existence
138   */
139   function totalSupply() public view returns (uint256) {
140     return totalSupply_;
141   }
142 
143   /**
144   * @dev transfer token for a specified address
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transfer(address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[msg.sender]);
151 
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     emit Transfer(msg.sender, _to, _value);
155     return true;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of.
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) public view returns (uint256 balance) {
164     return balances[_owner];
165   }
166 
167 }
168 
169 
170 
171 
172 /**
173  * @title Burnable Token
174  * @dev Token that can be irreversibly burned (destroyed).
175  */
176 contract BurnableToken is BasicToken {
177 
178   event Burn(address indexed burner, uint256 value);
179 
180   /**
181    * @dev Burns a specific amount of tokens.
182    * @param _value The amount of token to be burned.
183    */
184   function burn(uint256 _value) public {
185     _burn(msg.sender, _value);
186   }
187 
188   function _burn(address _who, uint256 _value) internal {
189     require(_value <= balances[_who]);
190     // no need to require value <= totalSupply, since that would imply the
191     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
192 
193     balances[_who] = balances[_who].sub(_value);
194     totalSupply_ = totalSupply_.sub(_value);
195     emit Burn(_who, _value);
196     emit Transfer(_who, address(0), _value);
197   }
198 }
199 
200 
201 
202 
203 /**
204  * @title Standard ERC20 token
205  *
206  * @dev Implementation of the basic standard token.
207  * @dev https://github.com/ethereum/EIPs/issues/20
208  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
209  */
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229     emit Transfer(_from, _to, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    *
236    * Beware that changing an allowance with this method brings the risk that someone may use both the old
237    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint256 _value) public returns (bool) {
244     allowed[msg.sender][_spender] = _value;
245     emit Approval(msg.sender, _spender, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param _owner address The address which owns the funds.
252    * @param _spender address The address which will spend the funds.
253    * @return A uint256 specifying the amount of tokens still available for the spender.
254    */
255   function allowance(address _owner, address _spender) public view returns (uint256) {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
270     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   /**
276    * @dev Decrease the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
286     uint oldValue = allowed[msg.sender][_spender];
287     if (_subtractedValue > oldValue) {
288       allowed[msg.sender][_spender] = 0;
289     } else {
290       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291     }
292     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296 }
297 
298 
299 
300 
301 
302 /**
303  * @title Mintable token
304  * @dev Simple ERC20 Token example, with mintable token creation
305  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
306  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
307  */
308 contract MintableToken is StandardToken, MultiOwnable {
309   event Mint(address indexed to, uint256 amount);
310   event MintFinished();
311 
312   bool public mintingFinished = false;
313 
314 
315   modifier canMint() {
316     require(!mintingFinished);
317     _;
318   }
319 
320   /**
321    * @dev Function to mint tokens
322    * @param _to The address that will receive the minted tokens.
323    * @param _amount The amount of tokens to mint.
324    * @return A boolean that indicates if the operation was successful.
325    */
326   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
327     totalSupply_ = totalSupply_.add(_amount);
328     balances[_to] = balances[_to].add(_amount);
329     emit Mint(_to, _amount);
330     emit Transfer(address(0), _to, _amount);
331     return true;
332   }
333 
334   /**
335    * @dev Function to stop minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function finishMinting() onlyOwner canMint public returns (bool) {
339     mintingFinished = true;
340     emit MintFinished();
341     return true;
342   }
343 }
344 
345 
346 
347 
348 /**
349  * @title HUMToken
350  * @dev ERC20 HUMToken.
351  * Note they can later distribute these tokens as they wish using `transfer` and other
352  * `StandardToken` functions.
353  */
354 contract HUMToken is MintableToken, BurnableToken {
355 
356   string public constant name = "HUMToken"; // solium-disable-line uppercase
357   string public constant symbol = "HUM"; // solium-disable-line uppercase
358   uint8 public constant decimals = 18; // solium-disable-line uppercase, // 18 decimals is the strongly suggested default, avoid changing it
359 
360   uint256 public constant INITIAL_SUPPLY = 2500 * 1000 * 1000 * (10 ** uint256(decimals)); // 2,500,000,000 HUM
361 
362   bool public isUnlocked = false;
363   
364   /**
365    * @dev Constructor that gives msg.sender all of existing tokens.
366    */
367   constructor(address _wallet) public {
368     totalSupply_ = INITIAL_SUPPLY;
369     balances[_wallet] = INITIAL_SUPPLY;
370     emit Transfer(address(0), _wallet, INITIAL_SUPPLY);
371   }
372 
373   modifier onlyTransferable() {
374     require(isUnlocked || owners[msg.sender] != 0);
375     _;
376   }
377 
378   function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable returns (bool) {
379       return super.transferFrom(_from, _to, _value);
380   }
381 
382   function transfer(address _to, uint256 _value) public onlyTransferable returns (bool) {
383       return super.transfer(_to, _value);
384   }
385   
386   function unlockTransfer() public onlyOwner {
387       isUnlocked = true;
388   }
389 
390 }