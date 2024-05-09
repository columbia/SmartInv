1 pragma solidity ^0.4.12;
2 
3 /**
4  * ===== Zeppelin library =====
5  */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) constant returns (uint256);
45   function transfer(address to, uint256 value) returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) constant returns (uint256);
55   function transferFrom(address from, address to, uint256 value) returns (bool);
56   function approve(address spender, uint256 value) returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() {
74     owner = msg.sender;
75   }
76 
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) onlyOwner {
92     require(newOwner != address(0));      
93     owner = newOwner;
94   }
95 
96 }
97 
98 /**
99  * @title Contracts that should not own Ether
100  * @author Remco Bloemen <remco@2π.com>
101  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
102  * in the contract, it will allow the owner to reclaim this ether.
103  * @notice Ether can still be send to this contract by:
104  * calling functions labeled `payable`
105  * `selfdestruct(contract_address)`
106  * mining directly to the contract address
107 */
108 contract HasNoEther is Ownable {
109 
110   /**
111   * @dev Constructor that rejects incoming Ether
112   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
113   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
114   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
115   * we could use assembly to access msg.value.
116   */
117   function HasNoEther() payable {
118     require(msg.value == 0);
119   }
120 
121   /**
122    * @dev Disallows direct send by settings a default function without the `payable` flag.
123    */
124   function() external {
125   }
126 
127   /**
128    * @dev Transfer all Ether held by the contract to the owner.
129    */
130   function reclaimEther() external onlyOwner {
131     assert(owner.send(this.balance));
132   }
133 }
134 
135 
136 /** 
137  * @title Contracts that should not own Contracts
138  * @author Remco Bloemen <remco@2π.com>
139  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
140  * of this contract to reclaim ownership of the contracts.
141  */
142 contract HasNoContracts is Ownable {
143 
144   /**
145    * @dev Reclaim ownership of Ownable contracts
146    * @param contractAddr The address of the Ownable to be reclaimed.
147    */
148   function reclaimContract(address contractAddr) external onlyOwner {
149     Ownable contractInst = Ownable(contractAddr);
150     contractInst.transferOwnership(owner);
151   }
152 }
153 
154 /**
155  * @title Contracts that should not own Tokens
156  * @author Remco Bloemen <remco@2π.com>
157  * @dev This blocks incoming ERC23 tokens to prevent accidental loss of tokens.
158  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
159  * owner to reclaim the tokens.
160  */
161 contract HasNoTokens is Ownable {
162 
163  /**
164   * @dev Reject all ERC23 compatible tokens
165   * @param from_ address The address that is transferring the tokens
166   * @param value_ uint256 the amount of the specified token
167   * @param data_ Bytes The data passed from the caller.
168   */
169   function tokenFallback(address from_, uint256 value_, bytes data_) external {
170     revert();
171   }
172 
173   /**
174    * @dev Reclaim all ERC20Basic compatible tokens
175    * @param tokenAddr address The address of the token contract
176    */
177   function reclaimToken(address tokenAddr) external onlyOwner {
178     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
179     uint256 balance = tokenInst.balanceOf(this);
180     tokenInst.transfer(owner, balance);
181   }
182 }
183 
184 
185 
186 /**
187  * @title Basic token
188  * @dev Basic version of StandardToken, with no allowances. 
189  */
190 contract BasicToken is ERC20Basic {
191   using SafeMath for uint256;
192 
193   mapping(address => uint256) balances;
194 
195   /**
196   * @dev transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint256 _value) returns (bool) {
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of. 
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) constant returns (uint256 balance) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 /**
219  * @title Standard ERC20 token
220  *
221  * @dev Implementation of the basic standard token.
222  * @dev https://github.com/ethereum/EIPs/issues/20
223  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  */
225 contract StandardToken is ERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amout of tokens to be transfered
235    */
236   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
237     var _allowance = allowed[_from][msg.sender];
238 
239     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
240     // require (_value <= _allowance);
241 
242     balances[_to] = balances[_to].add(_value);
243     balances[_from] = balances[_from].sub(_value);
244     allowed[_from][msg.sender] = _allowance.sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) returns (bool) {
255 
256     // To change the approve amount you first have to reduce the addresses`
257     //  allowance to zero by calling `approve(_spender, 0)` if it is not
258     //  already 0 to mitigate the race condition described here:
259     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
261 
262     allowed[msg.sender][_spender] = _value;
263     Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifing the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
274     return allowed[_owner][_spender];
275   }
276 
277 }
278 
279 /**
280  * @title Mintable token
281  * @dev Simple ERC20 Token example, with mintable token creation
282  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
283  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
284  */
285 
286 contract MintableToken is StandardToken, Ownable {
287   event Mint(address indexed to, uint256 amount);
288   event MintFinished();
289 
290   bool public mintingFinished = false;
291 
292 
293   modifier canMint() {
294     require(!mintingFinished);
295     _;
296   }
297 
298   /**
299    * @dev Function to mint tokens
300    * @param _to The address that will recieve the minted tokens.
301    * @param _amount The amount of tokens to mint.
302    * @return A boolean that indicates if the operation was successful.
303    */
304   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
305     totalSupply = totalSupply.add(_amount);
306     balances[_to] = balances[_to].add(_amount);
307     Mint(_to, _amount);
308     Transfer(0x0, _to, _amount);
309     return true;
310   }
311 
312   /**
313    * @dev Function to stop minting new tokens.
314    * @return True if the operation was successful.
315    */
316   function finishMinting() onlyOwner returns (bool) {
317     mintingFinished = true;
318     MintFinished();
319     return true;
320   }
321 }
322 
323 /**
324  * ===== DFS contracts =====
325  */
326 
327 
328 /**
329  * @title DFS token
330  */
331 contract DFSToken is MintableToken, HasNoEther, HasNoContracts, HasNoTokens { //MintableToken is StandardToken, Ownable
332     using SafeMath for uint256;
333 
334     string public name = "DFS";
335     string public symbol = "DFS";
336     uint256 public decimals = 18;
337 
338 }
339 
340 /**
341  * @title DFS Crowdsale
342  */
343 contract DFSCrowdsale is Ownable, HasNoTokens {
344     using SafeMath for uint256;
345 
346     uint256 public constant MAXIMUM_SUPPLY = 50000000000000000000000000; //Supply of tokens available for ICO. Initial value = 50 000 000 tokens, converted to token units
347     uint256 public constant OWNER_TOKENS = MAXIMUM_SUPPLY * 25 / 100;
348 
349 
350     uint256 public availableSupply;     //Supply of tokens available for ICO.
351     uint256 public startTimestamp;      //Start crowdsale timestamp
352     uint256 public endTimestamp;        //End crowdsale timestamp
353     uint256 public price;               //Price: how many token units one will receive per wei
354     DFSToken public dfs;               //Token contract
355     bool public finalized;              //crowdsale is finalized
356 
357   /**
358    * Event for token sale logging
359    * @param to who purshased tokens
360    * @param eth weis paid for purchase
361    * @param tokens amount of token units purchased
362    */ 
363     event LogSale(address indexed to, uint256 eth, uint256 tokens);
364 
365     /**
366      * Throws if crowdsale is not running: not started, ended or max cap reached
367      */
368     modifier crowdsaleIsRunning(){
369         //require(now > startTimestamp);
370         //require(now <= endTimestamp);
371         //require(availableSupply > 0);
372         require(crowdsaleRunning());
373         _;
374     }
375 
376     /**
377      * @dev DFS Crowdsale Contract
378      * @param _startTimestamp time when crowdsale is staring
379      * @param _endTimestamp time when crowdsale is finished
380      * @param _price crowdsale price (how many token units one will receive per wei)
381      */
382     function DFSCrowdsale(uint256 _startTimestamp, uint256 _endTimestamp, uint256 _price){
383         startTimestamp = _startTimestamp;
384         endTimestamp = _endTimestamp;
385         price = _price;
386         availableSupply = MAXIMUM_SUPPLY;
387 
388         dfs = new DFSToken();
389         mintTokens(owner, OWNER_TOKENS);
390     }
391 
392     function() payable crowdsaleIsRunning {
393         require(msg.value > 0);
394         uint256 tokens = price.mul(msg.value);
395         assert(tokens > 0);
396         require(availableSupply - tokens >= 0);
397 
398         mintTokens(msg.sender, tokens);
399         LogSale(msg.sender, msg.value, tokens);
400     } 
401 
402     function crowdsaleRunning() constant public returns(bool){
403         return (now > startTimestamp) &&  (now <= endTimestamp) && (availableSupply > 0) && !finalized;
404     }
405 
406 
407     /**
408     * @dev Mints tokens for owner and for crowdsale participants 
409     * @param _to whom to send tokens
410     * @param _amount how many tokens to send
411     */
412     function mintTokens(address _to, uint256 _amount) private {
413         availableSupply = availableSupply.sub(_amount);
414         dfs.mint(_to, _amount);
415     }
416 
417 
418     /**
419     * @dev Finalizes crowdsale when one of conditions met:
420     * - end time reached OR
421     * - no more tokens available (cap reached) OR
422     * - message sent by owner
423     */
424     function finalizeCrowdsale() public {
425         require ( (now > endTimestamp) || (availableSupply == 0) || (msg.sender == owner) );
426         finalized = dfs.finishMinting();
427         dfs.transferOwnership(owner);
428     } 
429 
430     /**
431     * @dev Sends collected funds to owner
432     */
433     function withdrawFunds(uint256 amount) public onlyOwner {
434         owner.transfer(amount);
435     }
436 
437 }