1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (a == 0) {
83       return 0;
84     }
85 
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address who) public view returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) balances;
143 
144   uint256 totalSupply_;
145 
146   /**
147   * @dev Total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev Transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender)
187     public view returns (uint256);
188 
189   function transferFrom(address from, address to, uint256 value)
190     public returns (bool);
191 
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * https://github.com/ethereum/EIPs/issues/20
207  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     public
226     returns (bool)
227   {
228     require(_to != address(0));
229     require(_value <= balances[_from]);
230     require(_value <= allowed[_from][msg.sender]);
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     emit Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(
261     address _owner,
262     address _spender
263    )
264     public
265     view
266     returns (uint256)
267   {
268     return allowed[_owner][_spender];
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
310     if (_subtractedValue > oldValue) {
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
321 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     hasMintPermission
356     canMint
357     public
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() onlyOwner canMint public returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: contracts\BuddyToken.sol
379 
380 contract BuddyToken is MintableToken {
381 
382     string public symbol = "BUD";
383     string public name = "Buddy";
384     uint8 public decimals = 18;
385 
386     constructor() public  {
387 
388     }
389 
390     function burn(uint256 _value) public {
391         _burn(msg.sender, _value);
392     }
393 
394     function _burn(address _who, uint256 _value) internal {
395         require(_value <= balances[_who]);
396         // no need to require value <= totalSupply, since that would imply the
397         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
398 
399         balances[_who] = balances[_who].sub(_value);
400         totalSupply_ = totalSupply_.sub(_value);
401         emit Burn(_who, _value);
402         emit Transfer(_who, address(0), _value);
403     }
404 
405     //helps to recover stucked tokens
406     function withdrawTokens(ERC20 erc20, address reciver, uint amount) public onlyOwner {
407         require(reciver != address(0x0));
408         erc20.transfer(reciver, amount);
409     }
410 
411 
412     event Burn(address indexed burner, uint256 value);
413 
414 }