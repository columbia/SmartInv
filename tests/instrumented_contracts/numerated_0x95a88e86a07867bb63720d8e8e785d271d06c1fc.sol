1 // File: contracts/openzeppelin/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: contracts/openzeppelin/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 // File: contracts/openzeppelin/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: contracts/openzeppelin/contracts/token/ERC20/ERC20.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender)
136     public view returns (uint256);
137 
138   function transferFrom(address from, address to, uint256 value)
139     public returns (bool);
140 
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 // File: contracts/openzeppelin/contracts/token/ERC20/StandardToken.sol
150 
151 pragma solidity ^0.4.24;
152 
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue > oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 // File: contracts/openzeppelin/contracts/ownership/Ownable.sol
276 
277 pragma solidity ^0.4.24;
278 
279 
280 /**
281  * @title Ownable
282  * @dev The Ownable contract has an owner address, and provides basic authorization control
283  * functions, this simplifies the implementation of "user permissions".
284  */
285 contract Ownable {
286   address public owner;
287 
288   event OwnershipRenounced(address indexed previousOwner);
289   event OwnershipTransferred(
290     address indexed previousOwner,
291     address indexed newOwner
292   );
293 
294 
295   /**
296    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297    * account.
298    */
299   constructor() public {
300     owner = msg.sender;
301   }
302 
303   /**
304    * @dev Throws if called by any account other than the owner.
305    */
306   modifier onlyOwner() {
307     require(msg.sender == owner);
308     _;
309   }
310 
311   /**
312    * @dev Allows the current owner to relinquish control of the contract.
313    * @notice Renouncing to ownership will leave the contract without an owner.
314    * It will not be possible to call the functions with the `onlyOwner`
315    * modifier anymore.
316    */
317   function renounceOwnership() public onlyOwner {
318     emit OwnershipRenounced(owner);
319     owner = address(0);
320   }
321 
322   /**
323    * @dev Allows the current owner to transfer control of the contract to a newOwner.
324    * @param _newOwner The address to transfer ownership to.
325    */
326   function transferOwnership(address _newOwner) public onlyOwner {
327     _transferOwnership(_newOwner);
328   }
329 
330   /**
331    * @dev Transfers control of the contract to a newOwner.
332    * @param _newOwner The address to transfer ownership to.
333    */
334   function _transferOwnership(address _newOwner) internal {
335     require(_newOwner != address(0));
336     emit OwnershipTransferred(owner, _newOwner);
337     owner = _newOwner;
338   }
339 }
340 
341 // File: contracts/openzeppelin/contracts/token/ERC20/MintableToken.sol
342 
343 pragma solidity ^0.4.24;
344 
345 
346 
347 
348 /**
349  * @title Mintable token
350  * @dev Simple ERC20 Token example, with mintable token creation
351  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
352  */
353 contract MintableToken is StandardToken, Ownable {
354   event Mint(address indexed to, uint256 amount);
355   event MintFinished();
356 
357   bool public mintingFinished = false;
358 
359 
360   modifier canMint() {
361     require(!mintingFinished);
362     _;
363   }
364 
365   modifier hasMintPermission() {
366     require(msg.sender == owner);
367     _;
368   }
369 
370   /**
371    * @dev Function to mint tokens
372    * @param _to The address that will receive the minted tokens.
373    * @param _amount The amount of tokens to mint.
374    * @return A boolean that indicates if the operation was successful.
375    */
376   function mint(
377     address _to,
378     uint256 _amount
379   )
380     hasMintPermission
381     canMint
382     public
383     returns (bool)
384   {
385     totalSupply_ = totalSupply_.add(_amount);
386     balances[_to] = balances[_to].add(_amount);
387     emit Mint(_to, _amount);
388     emit Transfer(address(0), _to, _amount);
389     return true;
390   }
391 
392   /**
393    * @dev Function to stop minting new tokens.
394    * @return True if the operation was successful.
395    */
396   function finishMinting() onlyOwner canMint public returns (bool) {
397     mintingFinished = true;
398     emit MintFinished();
399     return true;
400   }
401 }
402 
403 // File: contracts/openzeppelin/contracts/token/ERC20/CappedToken.sol
404 
405 pragma solidity ^0.4.24;
406 
407 
408 
409 /**
410  * @title Capped token
411  * @dev Mintable token with a token cap.
412  */
413 contract CappedToken is MintableToken {
414 
415   uint256 public cap;
416 
417   constructor(uint256 _cap) public {
418     require(_cap > 0);
419     cap = _cap;
420   }
421 
422   /**
423    * @dev Function to mint tokens
424    * @param _to The address that will receive the minted tokens.
425    * @param _amount The amount of tokens to mint.
426    * @return A boolean that indicates if the operation was successful.
427    */
428   function mint(
429     address _to,
430     uint256 _amount
431   )
432     public
433     returns (bool)
434   {
435     require(totalSupply_.add(_amount) <= cap);
436 
437     return super.mint(_to, _amount);
438   }
439 
440 }
441 
442 // File: contracts/BlankToken.sol
443 
444 pragma solidity ^0.4.24;
445 
446 
447 
448 /**
449  * @title Share token contract.
450   * @dev ERC20 token contract.
451  */
452 contract BlankToken is CappedToken {
453     string public constant name = "blankToken";
454     string public constant symbol = "BDT";
455     uint32 public constant decimals = 18;
456 
457    constructor(uint256 _cap) public CappedToken (_cap){
458    }
459 }