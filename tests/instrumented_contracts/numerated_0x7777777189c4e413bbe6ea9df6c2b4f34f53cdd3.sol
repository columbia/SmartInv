1 pragma solidity ^0.4.11;
2 
3 //
4 // SafeMath
5 //
6 // Ownable
7 // Destructible
8 // Pausable
9 //
10 // ERC20Basic
11 // ERC20 : ERC20Basic
12 // BasicToken : ERC20Basic
13 // StandardToken : ERC20, BasicToken
14 // MintableToken : StandardToken, Ownable
15 // PausableToken : StandardToken, Pausable
16 //
17 // CAToken : MintableToken, PausableToken
18 //
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) onlyOwner public {
85     require(newOwner != address(0));
86     OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 /**
93  * @title Destructible
94  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
95  */
96 contract Destructible is Ownable {
97 
98   function Destructible() payable public { }
99 
100   /**
101    * @dev Transfers the current balance to the owner and terminates the contract.
102    */
103   function destroy() onlyOwner public {
104     selfdestruct(owner);
105   }
106 
107   function destroyAndSend(address _recipient) onlyOwner public {
108     selfdestruct(_recipient);
109   }
110 }
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is Ownable {
117   event Pause();
118   event Unpause();
119 
120   bool public paused = false;
121 
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is not paused.
125    */
126   modifier whenNotPaused() {
127     require(!paused);
128     _;
129   }
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is paused.
133    */
134   modifier whenPaused() {
135     require(paused);
136     _;
137   }
138 
139   /**
140    * @dev called by the owner to pause, triggers stopped state
141    */
142   function pause() onlyOwner whenNotPaused public {
143     paused = true;
144     Pause();
145   }
146 
147   /**
148    * @dev called by the owner to unpause, returns to normal state
149    */
150   function unpause() onlyOwner whenPaused public {
151     paused = false;
152     Unpause();
153   }
154 }
155 
156 /**
157  * @title ERC20Basic
158  * @dev Simpler version of ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/179
160  */
161 contract ERC20Basic {
162   uint256 public totalSupply;
163   function balanceOf(address who) public constant returns (uint256);
164   function transfer(address to, uint256 value) public returns (bool);
165   event Transfer(address indexed from, address indexed to, uint256 value);
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender) public constant returns (uint256);
174   function transferFrom(address from, address to, uint256 value) public returns (bool);
175   function approve(address spender, uint256 value) public returns (bool);
176   event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 /**
180  * @title Basic token
181  * @dev Basic version of StandardToken, with no allowances.
182  */
183 contract BasicToken is ERC20Basic {
184   using SafeMath for uint256;
185 
186   mapping(address => uint256) balances;
187 
188   /**
189   * @dev transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) public returns (bool) {
194     require(_to != address(0));
195 
196     // SafeMath.sub will throw if there is not enough balance.
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public constant returns (uint256 balance) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234 
235     uint256 _allowance = allowed[_from][msg.sender];
236 
237     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
238     // require (_value <= _allowance);
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = _allowance.sub(_value);
243     Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    *
250    * Beware that changing an allowance with this method brings the risk that someone may use both the old
251    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254    * @param _spender The address which will spend the funds.
255    * @param _value The amount of tokens to be spent.
256    */
257   function approve(address _spender, uint256 _value) public returns (bool) {
258     allowed[msg.sender][_spender] = _value;
259     Approval(msg.sender, _spender, _value);
260     return true;
261   }
262 
263   /**
264    * @dev Function to check the amount of tokens that an owner allowed to a spender.
265    * @param _owner address The address which owns the funds.
266    * @param _spender address The address which will spend the funds.
267    * @return A uint256 specifying the amount of tokens still available for the spender.
268    */
269   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
270     return allowed[_owner][_spender];
271   }
272 
273   /**
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    */
279   function increaseApproval (address _spender, uint _addedValue) public
280     returns (bool success) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   function decreaseApproval (address _spender, uint _subtractedValue) public
287     returns (bool success) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 /**
301  * @title Mintable token
302  * @dev Simple ERC20 Token example, with mintable token creation
303  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
304  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
305  */
306 
307 contract MintableToken is StandardToken, Ownable {
308   event Mint(address indexed to, uint256 amount);
309   event MintFinished();
310 
311   bool public mintingFinished = false;
312 
313 
314   modifier canMint() {
315     require(!mintingFinished);
316     _;
317   }
318 
319   /**
320    * @dev Function to mint tokens
321    * @param _to The address that will receive the minted tokens.
322    * @param _amount The amount of tokens to mint.
323    * @return A boolean that indicates if the operation was successful.
324    */
325   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
326     totalSupply = totalSupply.add(_amount);
327     balances[_to] = balances[_to].add(_amount);
328     Mint(_to, _amount);
329     Transfer(0x0, _to, _amount);
330     return true;
331   }
332 
333   /**
334    * @dev Function to stop minting new tokens.
335    * @return True if the operation was successful.
336    */
337   function finishMinting() onlyOwner public returns (bool) {
338     mintingFinished = true;
339     MintFinished();
340     return true;
341   }
342 }
343 
344 /**
345  * @title Pausable token
346  *
347  * @dev StandardToken modified with pausable transfers.
348  **/
349 
350 contract PausableToken is StandardToken, Pausable {
351 
352   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
353     return super.transfer(_to, _value);
354   }
355 
356   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
357     return super.transferFrom(_from, _to, _value);
358   }
359 
360   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
361     return super.approve(_spender, _value);
362   }
363 
364   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
365     return super.increaseApproval(_spender, _addedValue);
366   }
367 
368   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
369     return super.decreaseApproval(_spender, _subtractedValue);
370   }
371 }
372 
373 contract MintableMasterToken is MintableToken {
374     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
375     address public mintMaster;
376 
377     modifier onlyMintMasterOrOwner() {
378         require(msg.sender == mintMaster || msg.sender == owner);
379         _;
380     }
381 
382     function MintableMasterToken() public {
383         mintMaster = msg.sender;
384     }
385 
386     function transferMintMaster(address newMaster) onlyOwner public {
387         require(newMaster != address(0));
388         MintMasterTransferred(mintMaster, newMaster);
389         mintMaster = newMaster;
390     }
391 
392     /**
393      * @dev Function to mint tokens
394      * @param _to The address that will receive the minted tokens.
395      * @param _amount The amount of tokens to mint.
396      * @return A boolean that indicates if the operation was successful.
397      */
398     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
399         address oldOwner = owner;
400         owner = msg.sender;
401 
402         bool result = super.mint(_to, _amount);
403 
404         owner = oldOwner;
405 
406         return result;
407     }
408 
409 }
410 
411 contract ICrowdsale {
412 
413     bool public finalized;
414     address[] public participants;
415     function participantsCount() public constant returns(uint);
416     function participantBonus(address participant) public constant returns(uint);
417 
418 }
419 
420 contract VanityToken is MintableToken, PausableToken {
421 
422     // Metadata
423     string public constant symbol = "VIP";
424     string public constant name = "VipCoin";
425     uint8 public constant decimals = 18;
426     string public constant version = "1.2";
427 
428     uint256 public constant TOKEN_RATE = 1000000; // 1 ETH = 1000000 VPL
429     uint256 public constant OWNER_TOKENS_PERCENT = 70;
430 
431     ICrowdsale public crowdsale;
432     bool public distributed;
433     uint256 public distributedCount;
434     uint256 public distributedTokens;
435 
436     event Distributed();
437 
438     function VanityToken(address _crowdsale) public {
439         crowdsale = ICrowdsale(_crowdsale);
440         pause();
441     }
442 
443     function distribute(uint count) public onlyOwner {
444         require(crowdsale.finalized() && !distributed);
445         require(count > 0 && distributedCount + count <= crowdsale.participantsCount());
446         
447         for (uint i = 0; i < count; i++) {
448             address participant = crowdsale.participants(distributedCount + i);
449             uint256 bonus = crowdsale.participantBonus(participant);
450             uint256 balance = participant.balance;
451             if (balance > 3 ether) {
452                 balance = 3 ether;
453             }
454             uint256 tokens = balance.mul(TOKEN_RATE).mul(100 + bonus).div(100);
455             mint(participant, tokens);
456             distributedTokens += tokens;
457         }
458         distributedCount += count;
459 
460         if (distributedCount == crowdsale.participantsCount()) {
461             uint256 ownerTokens = distributedTokens.mul(OWNER_TOKENS_PERCENT).div(100 - OWNER_TOKENS_PERCENT);
462             mint(owner, ownerTokens);
463             finishMinting();
464             unpause();
465             distributed = true;
466             Distributed();
467         }
468     }
469 
470 }