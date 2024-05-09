1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() public {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner public {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 library AddressUtils {
37   function isContract(address addr) internal view returns (bool) {
38     uint256 size;
39     assembly { size := extcodesize(addr) }
40     return size > 0;
41   }
42 }
43 
44 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
45 interface ERC165ReceiverInterface {
46     function tokensReceived(address _from, address _to, uint _amount) external returns (bool);
47 }
48 
49 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
50 contract ERC165Query {
51     bytes4 constant InvalidID = 0xffffffff;
52     bytes4 constant ERC165ID = 0x01ffc9a7;
53 
54     function doesContractImplementInterface(address _contract, bytes4 _interfaceId) internal view returns (bool) {
55         uint256 success;
56         uint256 result;
57 
58         (success, result) = noThrowCall(_contract, ERC165ID);
59         if ((success==0)||(result==0)) {
60             return false;
61         }
62 		
63         (success, result) = noThrowCall(_contract, InvalidID);
64         if ((success==0)||(result!=0)) {
65             return false;
66         }
67 
68         (success, result) = noThrowCall(_contract, _interfaceId);
69         if ((success==1)&&(result==1)) {
70             return true;
71         }
72         return false;
73     }
74 
75     function noThrowCall(address _contract, bytes4 _interfaceId) constant internal returns (uint256 success, uint256 result) {
76         bytes4 erc165ID = ERC165ID;
77 
78         assembly {
79                 let x := mload(0x40)               // Find empty storage location using "free memory pointer"
80                 mstore(x, erc165ID)                // Place signature at begining of empty storage
81                 mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature
82 
83                 success := staticcall(
84                                     30000,         // 30k gas
85                                     _contract,     // To addr
86                                     x,             // Inputs are stored at location x
87                                     0x20,          // Inputs are 32 bytes long
88                                     x,             // Store output over input (saves space)
89                                     0x20)          // Outputs are 32 bytes long
90 
91                 result := mload(x)                 // Load the result
92         }
93     }
94 }
95 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
96 
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 contract BasicToken is ERC20Basic, ERC165Query {
105   using SafeMath for uint256;
106   using AddressUtils for address;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132 	
133 	
134 	/** Support ERC165 */
135 	if (_to.isContract()) {
136 		ERC165ReceiverInterface i;
137 		if(doesContractImplementInterface(_to, i.tokensReceived.selector)) 
138 		{
139 			ERC165ReceiverInterface app= ERC165ReceiverInterface(_to);
140 			app.tokensReceived(msg.sender, _to, _value);
141 		}
142 	}
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256 balance) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 library SafeMath {
158   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a * b;
160     assert(a == 0 || c / a == b);
161     return c;
162   }
163 
164   function div(uint256 a, uint256 b) internal pure returns (uint256) {
165     // assert(b > 0); // Solidity automatically throws when dividing by 0
166     uint256 c = a / b;
167     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168     return c;
169   }
170 
171   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172     assert(b <= a);
173     return a - b;
174   }
175 
176   function add(uint256 a, uint256 b) internal pure returns (uint256) {
177     uint256 c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 }
182 
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
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
209     Transfer(_from, _to, _value);
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
225     Approval(msg.sender, _spender, _value);
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
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
272     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 contract ReleasableToken is ERC20, Ownable {
279 
280   /* The finalizer contract that allows unlift the transfer limits on this token */
281   address public releaseAgent;
282 
283   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
284   bool public released = false;
285 
286   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
287   mapping (address => bool) public transferAgents;
288   
289   //dtco : time lock with specific address
290   mapping(address => uint) public lock_addresses;
291   
292   event AddLockAddress(address addr, uint lock_time);  
293 
294   /**
295    * Limit token transfer until the crowdsale is over.
296    *
297    */
298   modifier canTransfer(address _sender) {
299 
300     if(!released) {
301         if(!transferAgents[_sender]) {
302             revert();
303         }
304     }
305 	else {
306 		//check time lock with team
307 		if(now < lock_addresses[_sender]) {
308 			revert();
309 		}
310 	}
311     _;
312   }
313   
314   function ReleasableToken() public {
315 	releaseAgent = msg.sender;
316   }
317   
318   //lock new team release time
319   function addLockAddressInternal(address addr, uint lock_time) inReleaseState(false) internal {
320 	if(addr == 0x0) revert();
321 	lock_addresses[addr]= lock_time;
322 	AddLockAddress(addr, lock_time);
323   }
324   
325   
326   /**
327    * Set the contract that can call release and make the token transferable.
328    *
329    * Design choice. Allow reset the release agent to fix fat finger mistakes.
330    */
331   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
332 
333     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
334     releaseAgent = addr;
335   }
336 
337   /**
338    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
339    */
340   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
341     transferAgents[addr] = state;
342   }
343   
344   /** The function can be called only by a whitelisted release agent. */
345   modifier onlyReleaseAgent() {
346     if(msg.sender != releaseAgent) {
347         revert();
348     }
349     _;
350   }
351 
352   /**
353    * One way function to release the tokens to the wild.
354    *
355    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
356    */
357   function releaseTokenTransfer() public onlyReleaseAgent {
358     released = true;
359   }
360 
361   /** The function can be called only before or after the tokens have been releasesd */
362   modifier inReleaseState(bool releaseState) {
363     if(releaseState != released) {
364         revert();
365     }
366     _;
367   }  
368 
369   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
370     // Call StandardToken.transfer()
371    return super.transfer(_to, _value);
372   }
373 
374   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
375     // Call StandardToken.transferForm()
376     return super.transferFrom(_from, _to, _value);
377   }
378 
379 }
380 
381 contract MintableToken is StandardToken, Ownable {
382   bool public mintingFinished = false;
383   
384   /** List of agents that are allowed to create new tokens */
385   mapping (address => bool) public mintAgents;
386 
387   event MintingAgentChanged(address addr, bool state  );
388   event Mint(address indexed to, uint256 amount);
389   event MintFinished();
390 
391   modifier onlyMintAgent() {
392     // Only crowdsale contracts are allowed to mint new tokens
393     if(!mintAgents[msg.sender]) {
394         revert();
395     }
396     _;
397   }
398   
399   modifier canMint() {
400     require(!mintingFinished);
401     _;
402   }
403   
404   /**
405    * Owner can allow a crowdsale contract to mint new tokens.
406    */
407   function setMintAgent(address addr, bool state) onlyOwner canMint public {
408     mintAgents[addr] = state;
409     MintingAgentChanged(addr, state);
410   }
411 
412   /**
413    * @dev Function to mint tokens
414    * @param _to The address that will recieve the minted tokens.
415    * @param _amount The amount of tokens to mint.
416    * @return A boolean that indicates if the operation was successful.
417    */
418   function mint(address _to, uint256 _amount) onlyMintAgent canMint public returns (bool) {
419     totalSupply_ = totalSupply_.add(_amount);
420     balances[_to] = balances[_to].add(_amount);
421     Mint(_to, _amount);
422 	
423 	Transfer(address(0), _to, _amount);
424     return true;
425   }
426 
427   /**
428    * @dev Function to stop minting new tokens.
429    * @return True if the operation was successful.
430    */
431   function finishMinting() onlyMintAgent public returns (bool) {
432     mintingFinished = true;
433     MintFinished();
434     return true;
435   }
436 }
437 
438 contract CrowdsaleToken is ReleasableToken, MintableToken {
439 
440   string public name = "KINWA Token";
441   string public symbol = "KINWA";
442   uint public decimals = 8;
443     
444   function CrowdsaleToken() public {
445     owner = msg.sender;
446     totalSupply_ = 0;
447   }
448 
449   /**
450    * When token is released to be transferable, enforce no new tokens can be created.
451    */
452    
453   function releaseTokenTransfer() public onlyReleaseAgent {
454     mintingFinished = true;
455     super.releaseTokenTransfer();
456   }
457   
458   //lock team address by crowdsale
459   function addLockAddress(address addr, uint lock_time) onlyMintAgent inReleaseState(false) public {
460 	super.addLockAddressInternal(addr, lock_time);
461   }
462 
463 }