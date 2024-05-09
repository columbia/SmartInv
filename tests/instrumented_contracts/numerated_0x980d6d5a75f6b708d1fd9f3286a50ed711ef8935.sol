1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) public view returns (uint256);
21 
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23 
24     function approve(address spender, uint256 value) public returns (bool);
25     event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29     );
30 }
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, throws on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     // uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return a / b;
62   }
63 
64   /**
65   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
76     c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   uint256 totalSupply_;
92 
93   /**
94   * @dev Total number of tokens in existence
95   */
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   /**
101   * @dev Transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_value <= balances[msg.sender]);
107     require(_to != address(0));
108 
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256) {
121     return balances[_owner];
122   }
123 
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * https://github.com/ethereum/EIPs/issues/20
131  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(
145     address _from,
146     address _to,
147     uint256 _value
148   )
149     public
150     returns (bool)
151   {
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154     require(_to != address(0));
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(
205     address _spender,
206     uint256 _addedValue
207   )
208     public
209     returns (bool)
210   {
211     allowed[msg.sender][_spender] = (
212       allowed[msg.sender][_spender].add(_addedValue));
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(
227     address _spender,
228     uint256 _subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     uint256 oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue >= oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 /**
246  * @title Ownable
247  * @dev The Ownable contract has an owner address, and provides basic authorization control
248  * functions, this simplifies the implementation of "user permissions".
249  */
250 contract Ownable {
251   address public owner;
252 
253 
254   event OwnershipRenounced(address indexed previousOwner);
255   event OwnershipTransferred(
256     address indexed previousOwner,
257     address indexed newOwner
258   );
259 
260 
261   /**
262    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
263    * account.
264    */
265   constructor() public {
266     owner = msg.sender;
267   }
268 
269   /**
270    * @dev Throws if called by any account other than the owner.
271    */
272   modifier onlyOwner() {
273     require(msg.sender == owner);
274     _;
275   }
276 
277   /**
278    * @dev Allows the current owner to relinquish control of the contract.
279    * @notice Renouncing to ownership will leave the contract without an owner.
280    * It will not be possible to call the functions with the `onlyOwner`
281    * modifier anymore.
282    */
283   function renounceOwnership() public onlyOwner {
284     emit OwnershipRenounced(owner);
285     owner = address(0);
286   }
287 
288   /**
289    * @dev Allows the current owner to transfer control of the contract to a newOwner.
290    * @param _newOwner The address to transfer ownership to.
291    */
292   function transferOwnership(address _newOwner) public onlyOwner {
293     _transferOwnership(_newOwner);
294   }
295 
296   /**
297    * @dev Transfers control of the contract to a newOwner.
298    * @param _newOwner The address to transfer ownership to.
299    */
300   function _transferOwnership(address _newOwner) internal {
301     require(_newOwner != address(0));
302     emit OwnershipTransferred(owner, _newOwner);
303     owner = _newOwner;
304   }
305 }
306 
307 /**
308  * @title Mintable token
309  * @dev Simple ERC20 Token example, with mintable token creation
310  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
311  */
312 contract MintableToken is StandardToken, Ownable {
313   event Mint(address indexed to, uint256 amount);
314   event MintFinished();
315 
316   bool public mintingFinished = false;
317 
318 
319   modifier canMint() {
320     require(!mintingFinished);
321     _;
322   }
323 
324   modifier hasMintPermission() {
325     require(msg.sender == owner);
326     _;
327   }
328 
329   /**
330    * @dev Function to mint tokens
331    * @param _to The address that will receive the minted tokens.
332    * @param _amount The amount of tokens to mint.
333    * @return A boolean that indicates if the operation was successful.
334    */
335     function mint(
336     address _to,
337     uint256 _amount
338   )
339     hasMintPermission
340     canMint
341     public
342     returns (bool)
343   {
344     totalSupply_ = totalSupply_.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     emit Mint(_to, _amount);
347     emit Transfer(address(0), _to, _amount);
348     return true;
349     }
350 
351   /**
352    * @dev Function to stop minting new tokens.
353    * @return True if the operation was successful.
354    */
355     function finishMinting() onlyOwner canMint public returns (bool) {
356     mintingFinished = true;
357     emit MintFinished();
358     return true;
359     }
360 }
361 
362 /**
363  * @title Burnable Token
364  * @dev Token that can be irreversibly burned (destroyed).
365  */
366 contract BurnableToken is BasicToken {
367 
368   event Burn(address indexed burner, uint256 value);
369 
370   /**
371    * @dev Burns a specific amount of tokens.
372    * @param _value The amount of token to be burned.
373    */
374   function burn(uint256 _value) public {
375     _burn(msg.sender, _value * (10 ** 18));
376   }
377 
378   function _burn(address _who, uint256 _value) internal {
379     require(_value <= balances[_who]);
380     // no need to require value <= totalSupply, since that would imply the
381     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
382 
383     balances[_who] = balances[_who].sub(_value);
384     totalSupply_ = totalSupply_.sub(_value);
385     emit Burn(_who, _value);
386     emit Transfer(_who, address(0), _value);
387   }
388 }
389 
390 contract GekkoinEURToken is MintableToken, BurnableToken {
391 
392     string public constant name = "Gekkoin EUR Token"; // solium-disable-line uppercase
393     string public constant symbol = "GKE"; // solium-disable-line uppercase
394     uint8 public constant decimals = 18; // solium-disable-line uppercase
395 
396 }
397 
398 contract GekkoinEUR {
399     using SafeMath for uint256;
400 
401     GekkoinEURToken public token;
402     address public ownerContract;       
403 
404   modifier isContractOwner() {
405     require(msg.sender == ownerContract);
406     _;
407   }
408 
409   function createTokenContract() internal returns (GekkoinEURToken) {
410       return new GekkoinEURToken();
411   }
412 
413   function GekkoinEUR() public {
414       token = createTokenContract();
415       ownerContract = msg.sender;      
416   }
417 
418   function createTokens(uint count, address addr) isContractOwner public returns(bool) {  
419       uint256 tokenAmount = count * (10 ** 18);   
420       require(count > 0);
421       require(addr != address(0));
422       token.mint(addr, tokenAmount);      
423       return true;
424   }
425 }