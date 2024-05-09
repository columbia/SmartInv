1 pragma solidity ^0.4.19;
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
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public view returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215 }
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227 
228   /**
229    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
230    * account.
231    */
232   function Ownable() public {
233     owner = msg.sender;
234   }
235 
236   /**
237    * @dev Throws if called by any account other than the owner.
238    */
239   modifier onlyOwner() {
240     require(msg.sender == owner);
241     _;
242   }
243 
244   /**
245    * @dev Allows the current owner to transfer control of the contract to a newOwner.
246    * @param newOwner The address to transfer ownership to.
247    */
248   function transferOwnership(address newOwner) public onlyOwner {
249     require(newOwner != address(0));
250     OwnershipTransferred(owner, newOwner);
251     owner = newOwner;
252   }
253 
254 }
255 
256 /**
257  * @title Mintable token
258  * @dev Simple ERC20 Token example, with mintable token creation
259  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
260  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
261  */
262 contract MintableToken is StandardToken, Ownable {
263   event Mint(address indexed to, uint256 amount);
264   event MintFinished();
265 
266   bool public mintingFinished = false;
267 
268 
269   modifier canMint() {
270     require(!mintingFinished);
271     _;
272   }
273 
274   /**
275    * @dev Function to mint tokens
276    * @param _to The address that will receive the minted tokens.
277    * @param _amount The amount of tokens to mint.
278    * @return A boolean that indicates if the operation was successful.
279    */
280   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281     totalSupply_ = totalSupply_.add(_amount);
282     balances[_to] = balances[_to].add(_amount);
283     Mint(_to, _amount);
284     Transfer(address(0), _to, _amount);
285     return true;
286   }
287 
288   /**
289    * @dev Function to stop minting new tokens.
290    * @return True if the operation was successful.
291    */
292   function finishMinting() onlyOwner canMint public returns (bool) {
293     mintingFinished = true;
294     MintFinished();
295     return true;
296   }
297 }
298 
299 contract LareCoin is StandardToken, MintableToken
300 {
301     // ERC20 token parameters
302     string public constant name = "LareCoin";
303     string public constant symbol = "LARE";
304     uint8 public constant decimals = 18;
305     
306     uint256 public constant ETH_PER_LARE = 0.0006 ether;
307     uint256 public constant MINIMUM_CONTRIBUTION = 0.05 ether;
308     uint256 public constant MAXIMUM_CONTRIBUTION = 5000000 ether;
309     
310     // Track the amount of Lare that has been sold in the pre-sale and main-sale.
311     // These variables do not include the bonuses.
312     uint256 public totalBaseLareSoldInPreSale = 0;
313     uint256 public totalBaseLareSoldInMainSale = 0;
314     
315     // The total amount of LARE sold.
316     // This variable does include the bonuses.
317     uint256 public totalLareSold = 0;
318     
319     uint256 public constant PRE_SALE_START_TIME  = 1518998400; // 16 february 2018
320     uint256 public constant MAIN_SALE_START_TIME = 1528070400; // 4 june 2018
321     uint256 public constant MAIN_SALE_END_TIME   = 1546560000; // 4 january 2019
322     
323     uint256 public constant TOTAL_LARE_FOR_SALE = 28000000000 * (uint256(10) ** decimals);
324     
325     address public owner;
326     
327     // Statistics
328     mapping(address => uint256) public addressToLarePurchased;
329     mapping(address => uint256) public addressToEtherContributed;
330     address[] public allParticipants;
331     function amountOfParticipants() external view returns (uint256)
332     {
333         return allParticipants.length;
334     }
335     
336     // Constructor function
337     function LareCoin() public
338     {
339         owner = msg.sender;
340         totalSupply_ = 58000000000 * (uint256(10) ** decimals);
341         balances[owner] = totalSupply_;
342         Transfer(0x0, owner, balances[owner]);
343     }
344     
345     // Fallback function
346     function () payable external
347     {
348         // Make sure the contribution is within limits
349         require(msg.value >= MINIMUM_CONTRIBUTION);
350         require(msg.value <= MAXIMUM_CONTRIBUTION);
351         
352         // Calculate the base amount of tokens purchased, excluding the bonus
353         uint256 purchasedTokensBase = msg.value * (uint256(10)**18) / ETH_PER_LARE;
354         
355         // Check which stage of the sale we are in, and act accordingly
356         uint256 purchasedTokensIncludingBonus = purchasedTokensBase;
357         if (now < PRE_SALE_START_TIME)
358         {
359             // The pre-sale has not started yet.
360             // Cancel the transaction.
361             revert();
362         }
363         else if (now >= PRE_SALE_START_TIME && now < MAIN_SALE_START_TIME)
364         {
365             totalBaseLareSoldInPreSale += purchasedTokensBase;
366             
367             if (totalBaseLareSoldInPreSale <= 2000000000 * (uint256(10)**decimals))
368             {
369                 // Pre-sale 100% bonus
370                 purchasedTokensIncludingBonus += purchasedTokensBase;
371             }
372             else
373             {
374                 // We've reached the 2 billion LARE limit of the pre-sale.
375                 // Cancel the transaction.
376                 revert();
377             }
378         }
379         else if (now >= MAIN_SALE_START_TIME && now < MAIN_SALE_END_TIME)
380         {
381             totalBaseLareSoldInMainSale += purchasedTokensBase;
382             
383             // Tier 1: 80% bonus
384                  if (totalBaseLareSoldInMainSale <=  2000000000 * (uint256(10)**decimals))
385                 purchasedTokensIncludingBonus += purchasedTokensBase * 80 / 100;
386 
387             // Tier 2: 70% bonus
388             else if (totalBaseLareSoldInMainSale <=  4000000000 * (uint256(10)**decimals))
389                 purchasedTokensIncludingBonus += purchasedTokensBase * 70 / 100;
390 
391             // Tier 3: 60% bonus
392             else if (totalBaseLareSoldInMainSale <=  6000000000 * (uint256(10)**decimals))
393                 purchasedTokensIncludingBonus += purchasedTokensBase * 60 / 100;
394 
395             // Tier 4: 50% bonus
396             else if (totalBaseLareSoldInMainSale <=  8000000000 * (uint256(10)**decimals))
397                 purchasedTokensIncludingBonus += purchasedTokensBase * 50 / 100;
398 
399             // Tier 5: 40% bonus
400             else if (totalBaseLareSoldInMainSale <=  9500000000 * (uint256(10)**decimals))
401                 purchasedTokensIncludingBonus += purchasedTokensBase * 40 / 100;
402 
403             // Tier 6: 30% bonus
404             else if (totalBaseLareSoldInMainSale <= 11000000000 * (uint256(10)**decimals))
405                 purchasedTokensIncludingBonus += purchasedTokensBase * 30 / 100;
406 
407             // Tier 7: 20% bonus
408             else if (totalBaseLareSoldInMainSale <= 12500000000 * (uint256(10)**decimals))
409                 purchasedTokensIncludingBonus += purchasedTokensBase * 20 / 100;
410 
411             // Tier 8: 10% bonus
412             else if (totalBaseLareSoldInMainSale <= 14000000000 * (uint256(10)**decimals))
413                 purchasedTokensIncludingBonus += purchasedTokensBase * 10 / 100;
414             
415             // Tier 9: 8% bonus
416             else if (totalBaseLareSoldInMainSale <= 15000000000 * (uint256(10)**decimals))
417                 purchasedTokensIncludingBonus += purchasedTokensBase * 8 / 100;
418             
419             // Tier 10: 6% bonus
420             else if (totalBaseLareSoldInMainSale <= 16000000000 * (uint256(10)**decimals))
421                 purchasedTokensIncludingBonus += purchasedTokensBase * 6 / 100;
422             
423             // Tier 11: 4% bonus
424             else if (totalBaseLareSoldInMainSale <= 16691200000 * (uint256(10)**decimals))
425                 purchasedTokensIncludingBonus += purchasedTokensBase * 4 / 100;
426             
427             // Tier 12: 2% bonus
428             else
429                 purchasedTokensIncludingBonus += purchasedTokensBase * 2 / 100;
430         }
431         else
432         {
433             // The main sale has ended.
434             // Cancel the transaction.
435             revert();
436         }
437         
438         // Statistics tracking
439         if (addressToLarePurchased[msg.sender] == 0) allParticipants.push(msg.sender);
440         addressToLarePurchased[msg.sender] += purchasedTokensIncludingBonus;
441         addressToEtherContributed[msg.sender] += msg.value;
442         totalLareSold += purchasedTokensIncludingBonus;
443         
444         // Don't allow selling more than the maximum
445         require(totalLareSold < TOTAL_LARE_FOR_SALE);
446         
447         // Send the ETH to the owner
448         owner.transfer(msg.value);
449     }
450     
451     function grantPurchasedTokens(address _purchaser) external onlyOwner
452     {
453         uint256 amountToTransfer = addressToLarePurchased[_purchaser];
454         addressToLarePurchased[_purchaser] = 0;
455         transfer(_purchaser, amountToTransfer);
456     }
457 }