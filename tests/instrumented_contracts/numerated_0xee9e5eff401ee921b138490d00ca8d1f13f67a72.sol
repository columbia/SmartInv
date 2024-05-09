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
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29     if (a == 0) {
30       return 0;
31     }
32 
33     c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     // uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return a / b;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60     c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev Total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev Transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender)
117     public view returns (uint256);
118 
119   function transferFrom(address from, address to, uint256 value)
120     public returns (bool);
121 
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(
150     address _from,
151     address _to,
152     uint256 _value
153   )
154     public
155     returns (bool)
156   {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(
191     address _owner,
192     address _spender
193    )
194     public
195     view
196     returns (uint256)
197   {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(
212     address _spender,
213     uint _addedValue
214   )
215     public
216     returns (bool)
217   {
218     allowed[msg.sender][_spender] = (
219       allowed[msg.sender][_spender].add(_addedValue));
220     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224   /**
225    * @dev Decrease the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseApproval(
235     address _spender,
236     uint _subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 
254 
255 /**
256  * @title Ownable
257  * @dev The Ownable contract has an owner address, and provides basic authorization control
258  * functions, this simplifies the implementation of "user permissions".
259  */
260 contract Ownable {
261   address public owner;
262 
263 
264   event OwnershipRenounced(address indexed previousOwner);
265   event OwnershipTransferred(
266     address indexed previousOwner,
267     address indexed newOwner
268   );
269 
270 
271   /**
272    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
273    * account.
274    */
275   constructor() public {
276     owner = msg.sender;
277   }
278 
279   /**
280    * @dev Throws if called by any account other than the owner.
281    */
282   modifier onlyOwner() {
283     require(msg.sender == owner);
284     _;
285   }
286 
287   /**
288    * @dev Allows the current owner to relinquish control of the contract.
289    * @notice Renouncing to ownership will leave the contract without an owner.
290    * It will not be possible to call the functions with the `onlyOwner`
291    * modifier anymore.
292    */
293   function renounceOwnership() public onlyOwner {
294     emit OwnershipRenounced(owner);
295     owner = address(0);
296   }
297 
298   /**
299    * @dev Allows the current owner to transfer control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function transferOwnership(address _newOwner) public onlyOwner {
303     _transferOwnership(_newOwner);
304   }
305 
306   /**
307    * @dev Transfers control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function _transferOwnership(address _newOwner) internal {
311     require(_newOwner != address(0));
312     emit OwnershipTransferred(owner, _newOwner);
313     owner = _newOwner;
314   }
315 }
316 
317 /**
318  * @title Mintable token
319  * @dev Simple ERC20 Token example, with mintable token creation
320  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
321  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
322  */
323 contract MintableToken is StandardToken, Ownable {
324   event Mint(address indexed to, uint256 amount);
325   event MintFinished();
326 
327   bool public mintingFinished = false;
328 
329 
330   modifier canMint() {
331     require(!mintingFinished);
332     _;
333   }
334 
335   modifier hasMintPermission() {
336     require(msg.sender == owner);
337     _;
338   }
339 
340   /**
341    * @dev Function to mint tokens
342    * @param _to The address that will receive the minted tokens.
343    * @param _amount The amount of tokens to mint.
344    * @return A boolean that indicates if the operation was successful.
345    */
346   function mint(
347     address _to,
348     uint256 _amount
349   )
350     hasMintPermission
351     canMint
352     public
353     returns (bool)
354   {
355     totalSupply_ = totalSupply_.add(_amount);
356     balances[_to] = balances[_to].add(_amount);
357     emit Mint(_to, _amount);
358     emit Transfer(address(0), _to, _amount);
359     return true;
360   }
361 
362   /**
363    * @dev Function to stop minting new tokens.
364    * @return True if the operation was successful.
365    */
366   function finishMinting() onlyOwner canMint public returns (bool) {
367     mintingFinished = true;
368     emit MintFinished();
369     return true;
370   }
371 }
372 
373 /**
374  * @title Burnable Token
375  * @dev Token that can be irreversibly burned (destroyed).
376  */
377 contract BurnableToken is BasicToken {
378 
379   event Burn(address indexed burner, uint256 value);
380 
381   /**
382    * @dev Burns a specific amount of tokens.
383    * @param _value The amount of token to be burned.
384    */
385   function burn(uint256 _value) public {
386     _burn(msg.sender, _value);
387   }
388 
389   function _burn(address _who, uint256 _value) internal {
390     require(_value <= balances[_who]);
391     // no need to require value <= totalSupply, since that would imply the
392     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
393 
394     balances[_who] = balances[_who].sub(_value);
395     totalSupply_ = totalSupply_.sub(_value);
396     emit Burn(_who, _value);
397     emit Transfer(_who, address(0), _value);
398   }
399 }
400 
401 contract Afin is MintableToken, BurnableToken {
402   string public name = "Asian Fintech";
403   string public symbol = "Afin";
404   uint public decimals = 8;
405   uint public INITIAL_SUPPLY = 500000000 * (10 ** decimals);
406 
407   /**
408    * @dev Constructor that gives msg.sender all of existing tokens.
409    */
410   constructor() public {
411     totalSupply_ = INITIAL_SUPPLY;
412     balances[msg.sender] = INITIAL_SUPPLY;
413     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
414   }
415 }