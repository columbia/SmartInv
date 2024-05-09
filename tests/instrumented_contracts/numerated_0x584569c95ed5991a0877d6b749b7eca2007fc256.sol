1 pragma solidity ^0.4.23;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
57 
58 /**
59  * @title Contracts that should not own Ether
60  * @author Remco Bloemen <remco@2π.com>
61  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
62  * in the contract, it will allow the owner to reclaim this ether.
63  * @notice Ether can still be sent to this contract by:
64  * calling functions labeled `payable`
65  * `selfdestruct(contract_address)`
66  * mining directly to the contract address
67  */
68 contract HasNoEther is Ownable {
69 
70   /**
71   * @dev Constructor that rejects incoming Ether
72   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
73   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
74   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
75   * we could use assembly to access msg.value.
76   */
77   constructor() public payable {
78     require(msg.value == 0);
79   }
80 
81   /**
82    * @dev Disallows direct send by settings a default function without the `payable` flag.
83    */
84   function() external {
85   }
86 
87   /**
88    * @dev Transfer all Ether held by the contract to the owner.
89    */
90   function reclaimEther() external onlyOwner {
91     owner.transfer(this.balance);
92   }
93 }
94 
95 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
96 
97 /**
98  * @title SafeMath
99  * @dev Math operations with safety checks that throw on error
100  */
101 library SafeMath {
102 
103   /**
104   * @dev Multiplies two numbers, throws on overflow.
105   */
106   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
107     if (a == 0) {
108       return 0;
109     }
110     c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return a / b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
144 
145 /**
146  * @title ERC20Basic
147  * @dev Simpler version of ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/179
149  */
150 contract ERC20Basic {
151   function totalSupply() public view returns (uint256);
152   function balanceOf(address who) public view returns (uint256);
153   function transfer(address to, uint256 value) public returns (bool);
154   event Transfer(address indexed from, address indexed to, uint256 value);
155 }
156 
157 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
158 
159 /**
160  * @title Basic token
161  * @dev Basic version of StandardToken, with no allowances.
162  */
163 contract BasicToken is ERC20Basic {
164   using SafeMath for uint256;
165 
166   mapping(address => uint256) balances;
167 
168   uint256 totalSupply_;
169 
170   /**
171   * @dev total number of tokens in existence
172   */
173   function totalSupply() public view returns (uint256) {
174     return totalSupply_;
175   }
176 
177   /**
178   * @dev transfer token for a specified address
179   * @param _to The address to transfer to.
180   * @param _value The amount to be transferred.
181   */
182   function transfer(address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[msg.sender]);
185 
186     balances[msg.sender] = balances[msg.sender].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     emit Transfer(msg.sender, _to, _value);
189     return true;
190   }
191 
192   /**
193   * @dev Gets the balance of the specified address.
194   * @param _owner The address to query the the balance of.
195   * @return An uint256 representing the amount owned by the passed address.
196   */
197   function balanceOf(address _owner) public view returns (uint256) {
198     return balances[_owner];
199   }
200 
201 }
202 
203 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
204 
205 /**
206  * @title Burnable Token
207  * @dev Token that can be irreversibly burned (destroyed).
208  */
209 contract BurnableToken is BasicToken {
210 
211   event Burn(address indexed burner, uint256 value);
212 
213   /**
214    * @dev Burns a specific amount of tokens.
215    * @param _value The amount of token to be burned.
216    */
217   function burn(uint256 _value) public {
218     _burn(msg.sender, _value);
219   }
220 
221   function _burn(address _who, uint256 _value) internal {
222     require(_value <= balances[_who]);
223     // no need to require value <= totalSupply, since that would imply the
224     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
225 
226     balances[_who] = balances[_who].sub(_value);
227     totalSupply_ = totalSupply_.sub(_value);
228     emit Burn(_who, _value);
229     emit Transfer(_who, address(0), _value);
230   }
231 }
232 
233 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
234 
235 /**
236  * @title ERC20 interface
237  * @dev see https://github.com/ethereum/EIPs/issues/20
238  */
239 contract ERC20 is ERC20Basic {
240   function allowance(address owner, address spender)
241     public view returns (uint256);
242 
243   function transferFrom(address from, address to, uint256 value)
244     public returns (bool);
245 
246   function approve(address spender, uint256 value) public returns (bool);
247   event Approval(
248     address indexed owner,
249     address indexed spender,
250     uint256 value
251   );
252 }
253 
254 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
255 
256 /**
257  * @title Standard ERC20 token
258  *
259  * @dev Implementation of the basic standard token.
260  * @dev https://github.com/ethereum/EIPs/issues/20
261  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
262  */
263 contract StandardToken is ERC20, BasicToken {
264 
265   mapping (address => mapping (address => uint256)) internal allowed;
266 
267 
268   /**
269    * @dev Transfer tokens from one address to another
270    * @param _from address The address which you want to send tokens from
271    * @param _to address The address which you want to transfer to
272    * @param _value uint256 the amount of tokens to be transferred
273    */
274   function transferFrom(
275     address _from,
276     address _to,
277     uint256 _value
278   )
279     public
280     returns (bool)
281   {
282     require(_to != address(0));
283     require(_value <= balances[_from]);
284     require(_value <= allowed[_from][msg.sender]);
285 
286     balances[_from] = balances[_from].sub(_value);
287     balances[_to] = balances[_to].add(_value);
288     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
289     emit Transfer(_from, _to, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
295    *
296    * Beware that changing an allowance with this method brings the risk that someone may use both the old
297    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
298    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
299    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300    * @param _spender The address which will spend the funds.
301    * @param _value The amount of tokens to be spent.
302    */
303   function approve(address _spender, uint256 _value) public returns (bool) {
304     allowed[msg.sender][_spender] = _value;
305     emit Approval(msg.sender, _spender, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Function to check the amount of tokens that an owner allowed to a spender.
311    * @param _owner address The address which owns the funds.
312    * @param _spender address The address which will spend the funds.
313    * @return A uint256 specifying the amount of tokens still available for the spender.
314    */
315   function allowance(
316     address _owner,
317     address _spender
318    )
319     public
320     view
321     returns (uint256)
322   {
323     return allowed[_owner][_spender];
324   }
325 
326   /**
327    * @dev Increase the amount of tokens that an owner allowed to a spender.
328    *
329    * approve should be called when allowed[_spender] == 0. To increment
330    * allowed value is better to use this function to avoid 2 calls (and wait until
331    * the first transaction is mined)
332    * From MonolithDAO Token.sol
333    * @param _spender The address which will spend the funds.
334    * @param _addedValue The amount of tokens to increase the allowance by.
335    */
336   function increaseApproval(
337     address _spender,
338     uint _addedValue
339   )
340     public
341     returns (bool)
342   {
343     allowed[msg.sender][_spender] = (
344       allowed[msg.sender][_spender].add(_addedValue));
345     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 
349   /**
350    * @dev Decrease the amount of tokens that an owner allowed to a spender.
351    *
352    * approve should be called when allowed[_spender] == 0. To decrement
353    * allowed value is better to use this function to avoid 2 calls (and wait until
354    * the first transaction is mined)
355    * From MonolithDAO Token.sol
356    * @param _spender The address which will spend the funds.
357    * @param _subtractedValue The amount of tokens to decrease the allowance by.
358    */
359   function decreaseApproval(
360     address _spender,
361     uint _subtractedValue
362   )
363     public
364     returns (bool)
365   {
366     uint oldValue = allowed[msg.sender][_spender];
367     if (_subtractedValue > oldValue) {
368       allowed[msg.sender][_spender] = 0;
369     } else {
370       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
371     }
372     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
373     return true;
374   }
375 
376 }
377 
378 // File: contracts/ChartToken.sol
379 
380 contract ChartToken is StandardToken, BurnableToken, Ownable, HasNoEther {
381     string public constant name = "BetOnChart token";
382     string public constant symbol = "CHART";
383     uint8 public constant decimals = 18; // 1 ether
384     bool public saleFinished;
385     address public saleAgent;
386     address private wallet;
387 
388    /**
389     * @dev Event should be emited when sale agent changed
390     */
391     event SaleAgent(address);
392 
393    /**
394     * @dev ChartToken constructor
395     * All tokens supply will be assign to contract owner.
396     * @param _wallet Wallet to handle initial token emission.
397     */
398     constructor(address _wallet) public {
399         require(_wallet != address(0));
400 
401         totalSupply_ = 50*1e6*(1 ether);
402         saleFinished = false;
403         balances[_wallet] = totalSupply_;
404         wallet = _wallet;
405         saleAgent = address(0);
406     }
407 
408    /**
409     * @dev Modifier to make a function callable only by owner or sale agent.
410     */
411     modifier onlyOwnerOrSaleAgent() {
412         require(msg.sender == owner || msg.sender == saleAgent);
413         _;
414     }
415 
416    /**
417     * @dev Modifier to make a function callable only when a sale is finished.
418     */
419     modifier whenSaleFinished() {
420         require(saleFinished || msg.sender == saleAgent || msg.sender == wallet );
421         _;
422     }
423 
424    /**
425     * @dev Modifier to make a function callable only when a sale is not finished.
426     */
427     modifier whenSaleNotFinished() {
428         require(!saleFinished);
429         _;
430     }
431 
432    /**
433     * @dev Set sale agent
434     * @param _agent The agent address which you want to set.
435     */
436     function setSaleAgent(address _agent) public whenSaleNotFinished onlyOwner {
437         saleAgent = _agent;
438         emit SaleAgent(_agent);
439     }
440 
441    /**
442     * @dev Handle ICO end
443     */
444     function finishSale() public onlyOwnerOrSaleAgent {
445         saleAgent = address(0);
446         emit SaleAgent(saleAgent);
447         saleFinished = true;
448     }
449 
450    /**
451     * @dev Overrides default ERC20
452     */
453     function transfer(address _to, uint256 _value) public whenSaleFinished returns (bool) {
454         return super.transfer(_to, _value);
455     }
456 
457    /**
458     * @dev Overrides default ERC20
459     */
460     function transferFrom(address _from, address _to, uint256 _value) public whenSaleFinished returns (bool) {
461         return super.transferFrom(_from, _to, _value);
462     }
463 }