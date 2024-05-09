1 pragma solidity ^0.4.21;
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
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 /**
60  * @title EOSclassic
61  */
62 
63 // Imports
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     if (a == 0) {
84       return 0;
85     }
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
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 
166 
167 
168 
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender) public view returns (uint256);
176   function transferFrom(address from, address to, uint256 value) public returns (bool);
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191 
192   mapping (address => mapping (address => uint256)) internal allowed;
193 
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     emit Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(address _owner, address _spender) public view returns (uint256) {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
250     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 
279 
280 
281 
282 
283 /**
284  * @title Contracts that should not own Ether
285  * @author Remco Bloemen <remco@2π.com>
286  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
287  * in the contract, it will allow the owner to reclaim this ether.
288  * @notice Ether can still be sent to this contract by:
289  * calling functions labeled `payable`
290  * `selfdestruct(contract_address)`
291  * mining directly to the contract address
292  */
293 contract HasNoEther is Ownable {
294 
295   /**
296   * @dev Constructor that rejects incoming Ether
297   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
298   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
299   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
300   * we could use assembly to access msg.value.
301   */
302   function HasNoEther() public payable {
303     require(msg.value == 0);
304   }
305 
306   /**
307    * @dev Disallows direct send by settings a default function without the `payable` flag.
308    */
309   function() external {
310   }
311 
312   /**
313    * @dev Transfer all Ether held by the contract to the owner.
314    */
315   function reclaimEther() external onlyOwner {
316     // solium-disable-next-line security/no-send
317     assert(owner.send(address(this).balance));
318   }
319 }
320 
321 
322 // Contract to help import the original EOS Crowdsale public key
323 contract EOSContractInterface
324 {
325     mapping (address => string) public keys;
326     function balanceOf( address who ) constant returns (uint value);
327 }
328 
329 // EOSclassic smart contract 
330 contract EOSclassic is StandardToken, HasNoEther 
331 {
332     // Welcome to EOSclassic
333     string public constant NAME = "EOSclassic";
334     string public constant SYMBOL = "EOSC";
335     uint8 public constant DECIMALS = 18;
336 
337     // Total amount minted
338     uint public constant TOTAL_SUPPLY = 1000000000 * (10 ** uint(DECIMALS));
339     
340     // Amount given to founders
341     uint public constant foundersAllocation = 100000000 * (10 ** uint(DECIMALS));   
342 
343     // Contract address of the original EOS contracts    
344     address public constant eosTokenAddress = 0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0;
345     address public constant eosCrowdsaleAddress = 0xd0a6E6C54DbC68Db5db3A091B171A77407Ff7ccf;
346     
347     // Map EOS keys; if not empty it should be favored over the original crowdsale address
348     mapping (address => string) public keys;
349     
350     // Keep track of EOS->EOSclassic claims
351     mapping (address => bool) public eosClassicClaimed;
352 
353     // LogClaim is called any time an EOS crowdsale user claims their EOSclassic equivalent
354     event LogClaim (address user, uint amount);
355 
356     // LogRegister is called any time a user registers a new EOS public key
357     event LogRegister (address user, string key);
358 
359     // ************************************************************
360     // Constructor; mints all tokens, assigns founder's allocation
361     // ************************************************************
362     constructor() public 
363     {
364         // Define total supply
365         totalSupply_ = TOTAL_SUPPLY;
366         // Allocate total supply of tokens to smart contract for disbursement
367         balances[address(this)] = TOTAL_SUPPLY;
368         // Announce initial allocation
369         emit Transfer(0x0, address(this), TOTAL_SUPPLY);
370         
371         // Transfer founder's allocation
372         balances[address(this)] = balances[address(this)].sub(foundersAllocation);
373         balances[msg.sender] = balances[msg.sender].add(foundersAllocation);
374         // Announce founder's allocation
375         emit Transfer(address(this), msg.sender, foundersAllocation);
376     }
377 
378     // Function that checks the original EOS token for a balance
379     function queryEOSTokenBalance(address _address) view public returns (uint) 
380     {
381         //return ERC20Basic(eosCrowdsaleAddress).balanceOf(_address);
382         EOSContractInterface eosTokenContract = EOSContractInterface(eosTokenAddress);
383         return eosTokenContract.balanceOf(_address);
384     }
385 
386     // Function that returns any registered EOS address from the original EOS crowdsale
387     function queryEOSCrowdsaleKey(address _address) view public returns (string) 
388     {
389         EOSContractInterface eosCrowdsaleContract = EOSContractInterface(eosCrowdsaleAddress);
390         return eosCrowdsaleContract.keys(_address);
391     }
392 
393     // Use to claim EOS Classic from the calling address
394     function claimEOSclassic() external returns (bool) 
395     {
396         return claimEOSclassicFor(msg.sender);
397     }
398 
399     // Use to claim EOSclassic for any Ethereum address 
400     function claimEOSclassicFor(address _toAddress) public returns (bool)
401     {
402         // Ensure that an address has been passed
403         require (_toAddress != address(0));
404         // Ensure this address has not already been claimed
405         require (isClaimed(_toAddress) == false);
406         
407         // Query the original EOS Crowdsale for address balance
408         uint _eosContractBalance = queryEOSTokenBalance(_toAddress);
409         
410         // Ensure that address had some balance in the crowdsale
411         require (_eosContractBalance > 0);
412         
413         // Sanity check: ensure we have enough tokens to send
414         require (_eosContractBalance <= balances[address(this)]);
415 
416         // Mark address as claimed
417         eosClassicClaimed[_toAddress] = true;
418         
419         // Convert equivalent amount of EOS to EOSclassic
420         // Transfer EOS Classic tokens from this contract to claiming address
421         balances[address(this)] = balances[address(this)].sub(_eosContractBalance);
422         balances[_toAddress] = balances[_toAddress].add(_eosContractBalance);
423         
424         // Broadcast transfer 
425         emit Transfer(address(this), _toAddress, _eosContractBalance);
426         
427         // Broadcast claim
428         emit LogClaim(_toAddress, _eosContractBalance);
429         
430         // Success!
431         return true;
432     }
433 
434     // Check any address to see if its EOSclassic has already been claimed
435     function isClaimed(address _address) public view returns (bool) 
436     {
437         return eosClassicClaimed[_address];
438     }
439 
440     // Returns the latest EOS key registered.
441     // EOS token holders that never registered their EOS public key 
442     // can do so using the 'register' function in EOSclassic and then request restitution 
443     // via the EOS mainnet arbitration process.
444     // EOS holders that previously registered can update their keys here;
445     // This contract could be used in future key snapshots for future EOS forks.
446     function getMyEOSKey() external view returns (string)
447     {
448         return getEOSKeyFor(msg.sender);
449     }
450 
451     // Return the registered EOS public key for the passed address
452     function getEOSKeyFor(address _address) public view returns (string)
453     {
454         string memory _eosKey;
455 
456         // Get any key registered with EOSclassic
457         _eosKey = keys[_address];
458 
459         if (bytes(_eosKey).length > 0) {
460             // EOSclassic key was registered; return this over the original crowdsale address
461             return _eosKey;
462         } else {
463             // EOSclassic doesn't have an EOS public key registered; return any original crowdsale key
464             _eosKey = queryEOSCrowdsaleKey(_address);
465             return _eosKey;
466         }
467     }
468 
469     // EOSclassic developer's note: the registration function is identical
470     // to the original EOS crowdsale registration function with only the
471     // freeze function removed, and 'emit' added to the LogRegister event,
472     // per updated Solidity standards.
473     //
474     // Value should be a public key.  Read full key import policy.
475     // Manually registering requires a base58
476     // encoded using the STEEM, BTS, or EOS public key format.
477     function register(string key) public {
478         assert(bytes(key).length <= 64);
479 
480         keys[msg.sender] = key;
481 
482         emit LogRegister(msg.sender, key);
483     }
484 
485 }