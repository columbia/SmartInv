1 pragma solidity 0.4.21;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 // File: contracts/ERC20Basic.sol
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   uint256 public totalSupply;
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 // File: contracts/SafeMath.sol
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         assert(c / a == b);
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         // assert(b > 0); // Solidity automatically throws when dividing by 0
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78         return c;
79     }
80 
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         assert(b <= a);
83         return a - b;
84     }
85 
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         assert(c >= a);
89         return c;
90     }
91 }
92 
93 // File: contracts/BasicToken.sol
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112 
113     // SafeMath.sub will throw if there is not enough balance.
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param _owner The address to query the the balance of.
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address _owner) public view returns (uint256 balance) {
126     return balances[_owner];
127   }
128 
129 }
130 
131 // File: contracts/ERC20.sol
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address owner, address spender) public view returns (uint256);
139   function transferFrom(address from, address to, uint256 value) public returns (bool);
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 // File: contracts/StandardToken.sol
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public view returns (uint256) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    */
208   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
209     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 // File: contracts/ReleasableToken.sol
228 
229 /**
230  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
231  *
232  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
233  *
234  * Some of this code has been updated by Pickeringware ltd to faciliatte the new solidity compilation requirements
235  */
236 
237 pragma solidity 0.4.21;
238 
239 
240 
241 
242 /**
243  * Define interface for releasing the token transfer after a successful crowdsale.
244  */
245 contract ReleasableToken is StandardToken, Ownable {
246 
247   /* The finalizer contract that allows unlift the transfer limits on this token */
248   address public releaseAgent;
249 
250   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
251   bool public released = false;
252 
253   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
254   mapping (address => bool) public transferAgents;
255 
256   /**
257    * Limit token transfer until the crowdsale is over.
258    *
259    */
260   modifier canTransfer(address _sender) {
261     if(!released) {
262         if(!transferAgents[_sender]) {
263             revert();
264         }
265     }
266     _;
267   }
268 
269   /**
270    * Set the contract that can call release and make the token transferable.
271    *
272    * Design choice. Allow reset the release agent to fix fat finger mistakes.
273    */
274   function setReleaseAgent() onlyOwner inReleaseState(false) public {
275 
276     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
277     releaseAgent = owner;
278   }
279 
280   /**
281    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
282    */
283   function setTransferAgent(address addr, bool state) onlyReleaseAgent inReleaseState(false) public {
284     transferAgents[addr] = state;
285   }
286 
287   /**
288    * One way function to release the tokens to the wild.
289    *
290    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
291    */
292   function releaseTokenTransfer() public onlyReleaseAgent {
293     released = true;
294   }
295 
296   /** The function can be called only before or after the tokens have been releasesd */
297   modifier inReleaseState(bool releaseState) {
298     if(releaseState != released) {
299         revert();
300     }
301     _;
302   }
303 
304   /** The function can be called only by a whitelisted release agent. */
305   modifier onlyReleaseAgent() {
306     if(msg.sender != releaseAgent) {
307         revert();
308     }
309     _;
310   }
311 
312   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
313     // Call StandardToken.transfer()
314    return super.transfer(_to, _value);
315   }
316 
317   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
318     // Call StandardToken.transferForm()
319     return super.transferFrom(_from, _to, _value);
320   }
321 
322 }
323 
324 // File: contracts/MintableToken.sol
325 
326 /**
327  * @title Mintable token
328  * @dev Simple ERC20 Token example, with mintable token creation
329  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
330  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
331  * 
332  * Some of this code has been changed by Pickeringware ltd to facilitate solidities new compilation requirements
333  */
334 
335 contract MintableToken is ReleasableToken {
336   event Mint(address indexed to, uint256 amount);
337   event MintFinished();
338 
339   bool public mintingFinished = false;
340 
341   modifier canMint() {
342     require(!mintingFinished);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
353     totalSupply = totalSupply.add(_amount);
354     balances[_to] = balances[_to].add(_amount);
355     Mint(_to, _amount);
356     Transfer(address(0), _to, _amount);
357     return true;
358   }
359 
360   /**
361    * @dev Function to stop minting new tokens.
362    * @return True if the operation was successful.
363    */
364   function finishMinting() onlyOwner canMint public returns (bool) {
365     mintingFinished = true;
366     MintFinished();
367     return true;
368   }
369 }
370 
371 // File: contracts/AMLToken.sol
372 
373 /**
374  * This contract has been written by Pickeringware ltd in some areas to facilitate custom crwodsale features
375  */
376 
377 pragma solidity 0.4.21;
378 
379 
380 
381 /**
382  * The AML Token
383  *
384  * This subset of MintableCrowdsaleToken gives the Owner a possibility to
385  * reclaim tokens from a participant before the token is released
386  * after a participant has failed a prolonged AML process.
387  *
388  * It is assumed that the anti-money laundering process depends on blockchain data.
389  * The data is not available before the transaction and not for the smart contract.
390  * Thus, we need to implement logic to handle AML failure cases post payment.
391  * We give a time window before the token release for the token sale owners to
392  * complete the AML and claw back all token transactions that were
393  * caused by rejected purchases.
394  */
395 contract AMLToken is MintableToken {
396 
397   // An event when the owner has reclaimed non-released tokens
398   event ReclaimedAllAndBurned(address claimedBy, address fromWhom, uint amount);
399 
400     // An event when the owner has reclaimed non-released tokens
401   event ReclaimAndBurned(address claimedBy, address fromWhom, uint amount);
402 
403   /// @dev Here the owner can reclaim the tokens from a participant if
404   ///      the token is not released yet. Refund will be handled in sale contract.
405   /// We also burn the tokens in the interest of economic value to the token holder
406   /// @param fromWhom address of the participant whose tokens we want to claim
407   function reclaimAllAndBurn(address fromWhom) public onlyReleaseAgent inReleaseState(false) {
408     uint amount = balanceOf(fromWhom);    
409     balances[fromWhom] = 0;
410     totalSupply = totalSupply.sub(amount);
411     
412     ReclaimedAllAndBurned(msg.sender, fromWhom, amount);
413   }
414 
415   /// @dev Here the owner can reclaim the tokens from a participant if
416   ///      the token is not released yet. Refund will be handled in sale contract.
417   /// We also burn the tokens in the interest of economic value to the token holder
418   /// @param fromWhom address of the participant whose tokens we want to claim
419   function reclaimAndBurn(address fromWhom, uint256 amount) public onlyReleaseAgent inReleaseState(false) {       
420     balances[fromWhom] = balances[fromWhom].sub(amount);
421     totalSupply = totalSupply.sub(amount);
422     
423     ReclaimAndBurned(msg.sender, fromWhom, amount);
424   }
425 }
426 
427 // File: contracts/PickToken.sol
428 
429 /*
430  * This token is part of Pickeringware ltds smart contracts
431  * It is used to specify certain details about the token upon release
432  */
433 
434 
435 contract PickToken is AMLToken {
436   string public name = "AX1 Mining token";
437   string public symbol = "AX1";
438   uint8 public decimals = 5;
439 }