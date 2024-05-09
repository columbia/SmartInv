1 pragma solidity ^0.4.18;
2 
3 /*
4     Copyright 2017-2018 Phillip A. Elsasser
5 
6     Licensed under the Apache License, Version 2.0 (the "License");
7     you may not use this file except in compliance with the License.
8     You may obtain a copy of the License at
9 
10     http://www.apache.org/licenses/LICENSE-2.0
11 
12     Unless required by applicable law or agreed to in writing, software
13     distributed under the License is distributed on an "AS IS" BASIS,
14     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15     See the License for the specific language governing permissions and
16     limitations under the License.
17 */
18 
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 contract ERC20Basic {
67   function totalSupply() public view returns (uint256);
68   function balanceOf(address who) public view returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public view returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 
123 contract UpgradeableTarget {
124     function upgradeFrom(address from, uint256 value) external; // note: implementation should require(from == oldToken)
125 }
126 
127 
128 contract BurnableToken is BasicToken {
129 
130   event Burn(address indexed burner, uint256 value);
131 
132   /**
133    * @dev Burns a specific amount of tokens.
134    * @param _value The amount of token to be burned.
135    */
136   function burn(uint256 _value) public {
137     require(_value <= balances[msg.sender]);
138     // no need to require value <= totalSupply, since that would imply the
139     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
140 
141     address burner = msg.sender;
142     balances[burner] = balances[burner].sub(_value);
143     totalSupply_ = totalSupply_.sub(_value);
144     Burn(burner, _value);
145     Transfer(burner, address(0), _value);
146   }
147 }
148 
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() public {
161     owner = msg.sender;
162   }
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) public onlyOwner {
177     require(newOwner != address(0));
178     OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 
184 contract StandardToken is ERC20, BasicToken {
185 
186   mapping (address => mapping (address => uint256)) internal allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(address _owner, address _spender) public view returns (uint256) {
230     return allowed[_owner][_spender];
231   }
232 
233   /**
234    * @dev Increase the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _addedValue The amount of tokens to increase the allowance by.
242    */
243   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
260     uint oldValue = allowed[msg.sender][_spender];
261     if (_subtractedValue > oldValue) {
262       allowed[msg.sender][_spender] = 0;
263     } else {
264       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
265     }
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270 }
271 
272 
273 
274 /// @title Upgradeable Token
275 /// @notice allows for us to update some of the needed functionality in our tokens post deployment. Inspiration taken
276 /// from Golems migrate functionality.
277 /// @author Phil Elsasser <phil@marketprotocol.io>
278 contract UpgradeableToken is Ownable, BurnableToken, StandardToken {
279 
280     address public upgradeableTarget;       // contract address handling upgrade
281     uint256 public totalUpgraded;           // total token amount already upgraded
282 
283     event Upgraded(address indexed from, address indexed to, uint256 value);
284 
285     /*
286     // EXTERNAL METHODS - TOKEN UPGRADE SUPPORT
287     */
288 
289     /// @notice Update token to the new upgraded token
290     /// @param value The amount of token to be migrated to upgraded token
291     function upgrade(uint256 value) external {
292         require(upgradeableTarget != address(0));
293 
294         burn(value);                    // burn tokens as we migrate them.
295         totalUpgraded = totalUpgraded.add(value);
296 
297         UpgradeableTarget(upgradeableTarget).upgradeFrom(msg.sender, value);
298         Upgraded(msg.sender, upgradeableTarget, value);
299     }
300 
301     /// @notice Set address of upgrade target process.
302     /// @param upgradeAddress The address of the UpgradeableTarget contract.
303     function setUpgradeableTarget(address upgradeAddress) external onlyOwner {
304         upgradeableTarget = upgradeAddress;
305     }
306 
307 }
308 
309 
310 
311 
312 /// @title Market Token
313 /// @notice Our membership token.  Users must lock tokens to enable trading for a given Market Contract
314 /// as well as have a minimum balance of tokens to create new Market Contracts.
315 /// @author Phil Elsasser <phil@marketprotocol.io>
316 contract MarketToken is UpgradeableToken {
317 
318     string public constant name = "MARKET Protocol Token";
319     string public constant symbol = "MKT";
320     uint8 public constant decimals = 18;
321 
322     uint public constant INITIAL_SUPPLY = 600000000 * 10**uint(decimals); // 600 million tokens with 18 decimals (6e+26)
323 
324     uint public lockQtyToAllowTrading;
325     uint public minBalanceToAllowContractCreation;
326 
327     mapping(address => mapping(address => uint)) contractAddressToUserAddressToQtyLocked;
328 
329     event UpdatedUserLockedBalance(address indexed contractAddress, address indexed userAddress, uint balance);
330 
331     function MarketToken(uint qtyToLockForTrading, uint minBalanceForCreation) public {
332         lockQtyToAllowTrading = qtyToLockForTrading;
333         minBalanceToAllowContractCreation = minBalanceForCreation;
334         totalSupply_ = INITIAL_SUPPLY;  //note totalSupply_ and INITIAL_SUPPLY may vary as token's are burnt.
335 
336         balances[msg.sender] = INITIAL_SUPPLY; // for now allocate all tokens to creator
337     }
338 
339     /*
340     // EXTERNAL METHODS
341     */
342 
343     /// @notice checks if a user address has locked the needed qty to allow trading to a given contract address
344     /// @param marketContractAddress address of the MarketContract
345     /// @param userAddress address of the user
346     /// @return true if user has locked tokens to trade the supplied marketContractAddress
347     function isUserEnabledForContract(address marketContractAddress, address userAddress) external view returns (bool) {
348         return contractAddressToUserAddressToQtyLocked[marketContractAddress][userAddress] >= lockQtyToAllowTrading;
349     }
350 
351     /// @notice checks if a user address has enough token balance to be eligible to create a contract
352     /// @param userAddress address of the user
353     /// @return true if user has sufficient balance of tokens
354     function isBalanceSufficientForContractCreation(address userAddress) external view returns (bool) {
355         return balances[userAddress] >= minBalanceToAllowContractCreation;
356     }
357 
358     /// @notice allows user to lock tokens to enable trading for a given market contract
359     /// @param marketContractAddress address of the MarketContract
360     /// @param qtyToLock desired qty of tokens to lock
361     function lockTokensForTradingMarketContract(address marketContractAddress, uint qtyToLock) external {
362         uint256 lockedBalance = contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender].add(
363             qtyToLock
364         );
365         transfer(this, qtyToLock);
366         contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender] = lockedBalance;
367         UpdatedUserLockedBalance(marketContractAddress, msg.sender, lockedBalance);
368     }
369 
370     /// @notice allows user to unlock tokens previously allocated to trading a MarketContract
371     /// @param marketContractAddress address of the MarketContract
372     /// @param qtyToUnlock desired qty of tokens to unlock
373     function unlockTokens(address marketContractAddress, uint qtyToUnlock) external {
374         uint256 balanceAfterUnLock = contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender].sub(
375             qtyToUnlock
376         );  // no need to check balance, sub() will ensure sufficient balance to unlock!
377         contractAddressToUserAddressToQtyLocked[marketContractAddress][msg.sender] = balanceAfterUnLock;        // update balance before external call!
378         transferLockedTokensBackToUser(qtyToUnlock);
379         UpdatedUserLockedBalance(marketContractAddress, msg.sender, balanceAfterUnLock);
380     }
381 
382     /// @notice get the currently locked balance for a user given the specific contract address
383     /// @param marketContractAddress address of the MarketContract
384     /// @param userAddress address of the user
385     /// @return the locked balance
386     function getLockedBalanceForUser(address marketContractAddress, address userAddress) external view returns (uint) {
387         return contractAddressToUserAddressToQtyLocked[marketContractAddress][userAddress];
388     }
389 
390     /*
391     // EXTERNAL - ONLY CREATOR  METHODS
392     */
393 
394     /// @notice allows the creator to set the qty each user address needs to lock in
395     /// order to trade a given MarketContract
396     /// @param qtyToLock qty needed to enable trading
397     function setLockQtyToAllowTrading(uint qtyToLock) external onlyOwner {
398         lockQtyToAllowTrading = qtyToLock;
399     }
400 
401     /// @notice allows the creator to set minimum balance a user must have in order to create MarketContracts
402     /// @param minBalance balance to enable contract creation
403     function setMinBalanceForContractCreation(uint minBalance) external onlyOwner {
404         minBalanceToAllowContractCreation = minBalance;
405     }
406 
407     /*
408     // PRIVATE METHODS
409     */
410 
411     /// @dev returns locked balance from this contract to the user's balance
412     /// @param qtyToUnlock qty to return to user's balance
413     function transferLockedTokensBackToUser(uint qtyToUnlock) private {
414         balances[this] = balances[this].sub(qtyToUnlock);
415         balances[msg.sender] = balances[msg.sender].add(qtyToUnlock);
416         Transfer(this, msg.sender, qtyToUnlock);
417     }
418 }