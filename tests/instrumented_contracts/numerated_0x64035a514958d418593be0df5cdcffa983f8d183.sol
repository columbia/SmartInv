1 pragma solidity ^0.4.23;
2 
3 //////////////////////////////////////// ERC20Basic.sol ////////////////////////////////////////
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 //////////////////////////////////////// SafeMath.sol ////////////////////////////////////////
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     if (a == 0) {
32       return 0;
33     }
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 //////////////////////////////////////// BasicToken.sol ////////////////////////////////////////
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   uint256 totalSupply_;
80 
81   /**
82   * @dev total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[msg.sender]);
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 //////////////////////////////////////// ERC20.sol ////////////////////////////////////////
115 
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 //////////////////////////////////////// StandardToken.sol ////////////////////////////////////////
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(
219     address _spender,
220     uint _addedValue
221   )
222     public
223     returns (bool)
224   {
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To decrement
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _subtractedValue The amount of tokens to decrease the allowance by.
240    */
241   function decreaseApproval(
242     address _spender,
243     uint _subtractedValue
244   )
245     public
246     returns (bool)
247   {
248     uint oldValue = allowed[msg.sender][_spender];
249     if (_subtractedValue > oldValue) {
250       allowed[msg.sender][_spender] = 0;
251     } else {
252       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253     }
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258 }
259 
260 //////////////////////////////////////// DetailedERC20.sol ////////////////////////////////////////
261 
262 
263 contract DetailedERC20 is ERC20 {
264   string public name;
265   string public symbol;
266   uint8 public decimals;
267 
268   constructor(string _name, string _symbol, uint8 _decimals) public {
269     name = _name;
270     symbol = _symbol;
271     decimals = _decimals;
272   }
273 }
274 
275 //////////////////////////////////////// Ownable.sol ////////////////////////////////////////
276 
277 
278 /**
279  * @title Ownable
280  * @dev The Ownable contract has an owner address, and provides basic authorization control
281  * functions, this simplifies the implementation of "user permissions".
282  */
283 contract Ownable {
284   address public owner;
285 
286 
287   event OwnershipRenounced(address indexed previousOwner);
288   event OwnershipTransferred(
289     address indexed previousOwner,
290     address indexed newOwner
291   );
292 
293 
294   /**
295    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
296    * account.
297    */
298   constructor() public {
299     owner = msg.sender;
300   }
301 
302   /**
303    * @dev Throws if called by any account other than the owner.
304    */
305   modifier onlyOwner() {
306     require(msg.sender == owner);
307     _;
308   }
309 
310   /**
311    * @dev Allows the current owner to transfer control of the contract to a newOwner.
312    * @param newOwner The address to transfer ownership to.
313    */
314   function transferOwnership(address newOwner) public onlyOwner {
315     require(newOwner != address(0));
316     emit OwnershipTransferred(owner, newOwner);
317     owner = newOwner;
318   }
319 
320   /**
321    * @dev Allows the current owner to relinquish control of the contract.
322    */
323   function renounceOwnership() public onlyOwner {
324     emit OwnershipRenounced(owner);
325     owner = address(0);
326   }
327 }
328 
329 //////////////////////////////////////// CanReclaimToken.sol ////////////////////////////////////////
330 
331 
332 /**
333  * @title Contracts that should be able to recover tokens
334  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
335  * This will prevent any accidental loss of tokens.
336  */
337 contract CanReclaimToken is Ownable {
338 
339   /**
340    * @dev Reclaim all ERC20Basic compatible tokens
341    * @param token ERC20Basic The address of the token contract
342    */
343   function reclaimToken(ERC20Basic token) external onlyOwner {
344     uint256 balance = token.balanceOf(this);
345     token.transfer(owner, balance);
346   }
347 
348 }
349 
350 //////////////////////////////////////// ERC20Token.sol ////////////////////////////////////////
351 
352 contract ERC20Token is DetailedERC20, StandardToken, CanReclaimToken {
353     address public funder;
354 
355     constructor(string _name, string _symbol, uint8 _decimals, address _funder, uint256 _initToken)
356         public
357         DetailedERC20(_name, _symbol, _decimals)
358     {
359         uint256 initToken = _initToken.mul(10**uint256(_decimals));
360         require(address(0) != _funder);
361         funder = _funder;
362         totalSupply_ = initToken;
363         balances[_funder] = initToken;
364         emit Transfer(address(0), funder, initToken);
365     }
366 }
367 
368 //////////////////////////////////////// BurnableToken.sol ////////////////////////////////////////
369 
370 
371 /**
372  * @title Burnable Token
373  * @dev Token that can be irreversibly burned (destroyed).
374  */
375 contract BurnableToken is BasicToken {
376 
377   event Burn(address indexed burner, uint256 value);
378 
379   /**
380    * @dev Burns a specific amount of tokens.
381    * @param _value The amount of token to be burned.
382    */
383   function burn(uint256 _value) public {
384     _burn(msg.sender, _value);
385   }
386 
387   function _burn(address _who, uint256 _value) internal {
388     require(_value <= balances[_who]);
389     // no need to require value <= totalSupply, since that would imply the
390     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
391 
392     balances[_who] = balances[_who].sub(_value);
393     totalSupply_ = totalSupply_.sub(_value);
394     emit Burn(_who, _value);
395     emit Transfer(_who, address(0), _value);
396   }
397 }
398 
399 //////////////////////////////////////// bucky.sol ////////////////////////////////////////
400 
401 contract BZUToken is ERC20Token, BurnableToken {
402 
403     bool public active = true;
404     string  _name = "BZU Token";
405     string _symbol = "BZU";
406     uint8 _decimals = 18;
407     address _funder = address(0xC9AD62F26Aa7F79c095281Cab10446ec9Bc7A5E5);
408     uint256 _initToken = 1000000000;
409     
410 
411     modifier onlyActive() {
412         require(active);
413         _;
414     }
415     
416     constructor()
417         public
418         ERC20Token(_name, _symbol, _decimals,  _funder, _initToken)
419     {}
420     
421     /**
422     * @dev transfer token for a specified address
423     * @param _to The address to transfer to.
424     * @param _value The amount to be transferred.
425     */
426     function transfer(address _to, uint256 _value) public onlyActive returns (bool) {
427         return super.transfer(_to, _value);
428     }
429     
430     /**
431     * @dev Transfer tokens from one address to another
432     * @param _from address The address which you want to send tokens from
433     * @param _to address The address which you want to transfer to
434     * @param _value uint256 the amount of tokens to be transferred
435     */
436     function transferFrom(
437         address _from,
438         address _to,
439         uint256 _value
440     )
441     public
442     onlyActive
443     returns (bool)
444     {
445         return super.transferFrom(_from, _to, _value);
446     }
447     
448     function setState(bool _state) public onlyOwner {
449         active = _state;
450     }
451 }