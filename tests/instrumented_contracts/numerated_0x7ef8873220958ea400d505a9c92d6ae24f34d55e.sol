1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public constant returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool success) {
63     if (balances[msg.sender] >= _value) {
64       balances[msg.sender] = balances[msg.sender].sub(_value);
65       balances[_to] = balances[_to].add(_value);
66       Transfer(msg.sender, _to, _value);
67       return true;
68     } else {
69       return false;
70     }
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public constant returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
116     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
117       balances[_to] = balances[_to].add(_value);
118       balances[_from] = balances[_from].sub(_value);
119       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120       Transfer(_from, _to, _value);
121       return true;
122     } else {
123       return false;
124     }
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval (address _spender, uint _addedValue)
160     returns (bool success) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval (address _spender, uint _subtractedValue)
167     returns (bool success) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178 }
179 
180 
181 /**
182  * @title Ownable
183  * @dev The Ownable contract has an owner address, and provides basic authorization control
184  * functions, this simplifies the implementation of "user permissions".
185  */
186 contract Ownable {
187   address public owner;
188 
189 
190   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192 
193   /**
194    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
195    * account.
196    */
197   function Ownable() {
198     owner = msg.sender;
199   }
200 
201 
202   /**
203    * @dev Throws if called by any account other than the owner.
204    */
205   modifier onlyOwner() {
206     require(msg.sender == owner);
207     _;
208   }
209 
210 
211   /**
212    * @dev Allows the current owner to transfer control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function transferOwnership(address newOwner) onlyOwner public {
216     require(newOwner != address(0));
217     OwnershipTransferred(owner, newOwner);
218     owner = newOwner;
219   }
220 
221 }
222 
223 
224 
225 /**
226  * @title Mintable token
227  * @dev Simple ERC20 Token example, with mintable token creation
228  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
229  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
230  */
231 
232 contract MintableToken is StandardToken, Ownable {
233   event Mint(address indexed to, uint256 amount);
234   event MintFinished();
235 
236   bool public mintingFinished = false;
237 
238 
239   modifier canMint() {
240     require(!mintingFinished);
241     _;
242   }
243 
244   /**
245    * @dev Function to mint tokens
246    * @param _to The address that will receive the minted tokens.
247    * @param _amount The amount of tokens to mint.
248    * @return A boolean that indicates if the operation was successful.
249    */
250   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
251     totalSupply = totalSupply.add(_amount);
252     balances[_to] = balances[_to].add(_amount);
253     Mint(_to, _amount);
254     Transfer(0x0, _to, _amount);
255     return true;
256   }
257 
258   /**
259    * @dev Function to stop minting new tokens.
260    * @return True if the operation was successful.
261    */
262   function finishMinting() onlyOwner public returns (bool) {
263     mintingFinished = true;
264     MintFinished();
265     return true;
266   }
267 }
268 
269 
270 contract ARCDToken is MintableToken {
271     string public constant name = "Arcade Token";
272     string public constant symbol = "ARCD";
273     uint8 public constant decimals = 18;
274     string public version = "1.0";
275 }
276 
277 
278 contract Crowdsale {
279     function buyTokens(address _recipient) public payable;
280 }
281 
282 contract ARCDCrowdsale is Crowdsale {
283     using SafeMath for uint256;
284 
285     // metadata
286     uint256 public constant decimals = 18;
287 
288     // contracts
289     // deposit address for ETH for Arcade City
290     address public constant ETH_FUND_DEPOSIT = 0x3b2470E99b402A333a82eE17C3244Ff04C79Ec6F;
291     // deposit address for Arcade City use and ARCD User Fund
292     address public constant ARCD_FUND_DEPOSIT = 0x3b2470E99b402A333a82eE17C3244Ff04C79Ec6F;
293 
294     // crowdsale parameters
295     bool public isFinalized;                                                    // switched to true in operational state
296     uint256 public constant FUNDING_START_TIMESTAMP = 1511919480;               // 11/29/2017 @ 1:38am UTC
297     uint256 public constant FUNDING_END_TIMESTAMP = FUNDING_START_TIMESTAMP + (60 * 60 * 24 * 90); // 90 days
298     uint256 public constant ARCD_FUND = 92 * (10**8) * 10**decimals;            // 9.2B for Arcade City
299     uint256 public constant TOKEN_EXCHANGE_RATE = 200000;                       // 200,000 ARCD tokens per 1 ETH
300     uint256 public constant TOKEN_CREATION_CAP =  10 * (10**9) * 10**decimals;  // 10B total
301     uint256 public constant MIN_BUY_TOKENS = 20000 * 10**decimals;              // 0.1 ETH
302     uint256 public constant GAS_PRICE_LIMIT = 60 * 10**9;                       // Gas limit 60 gwei
303 
304     // events
305     event CreateARCD(address indexed _to, uint256 _value);
306 
307     ARCDToken public token;
308 
309     // constructor
310     function ARCDCrowdsale () public {
311       token = new ARCDToken();
312 
313       // sanity checks
314       assert(ETH_FUND_DEPOSIT != 0x0);
315       assert(ARCD_FUND_DEPOSIT != 0x0);
316       assert(FUNDING_START_TIMESTAMP < FUNDING_END_TIMESTAMP);
317       assert(uint256(token.decimals()) == decimals);
318 
319       isFinalized = false;
320 
321       token.mint(ARCD_FUND_DEPOSIT, ARCD_FUND);
322       CreateARCD(ARCD_FUND_DEPOSIT, ARCD_FUND);
323     }
324 
325     /// @dev Accepts ether and creates new ARCD tokens.
326     function createTokens() payable external {
327       buyTokens(msg.sender);
328     }
329 
330     function () public payable {
331       buyTokens(msg.sender);
332     }
333 
334     // low level token purchase function
335     function buyTokens(address beneficiary) public payable {
336       require (!isFinalized);
337       require (block.timestamp >= FUNDING_START_TIMESTAMP);
338       require (block.timestamp <= FUNDING_END_TIMESTAMP);
339       require (msg.value != 0);
340       require (beneficiary != 0x0);
341       require (tx.gasprice <= GAS_PRICE_LIMIT);
342 
343       uint256 tokens = msg.value.mul(TOKEN_EXCHANGE_RATE); // check that we're not over totals
344       uint256 checkedSupply = token.totalSupply().add(tokens);
345 
346       // return money if something goes wrong
347       require (TOKEN_CREATION_CAP >= checkedSupply);
348 
349       // return money if tokens is less than the min amount
350       // the min amount does not apply if the availables tokens are less than the min amount.
351       require (tokens >= MIN_BUY_TOKENS || (TOKEN_CREATION_CAP.sub(token.totalSupply())) <= MIN_BUY_TOKENS);
352 
353       token.mint(beneficiary, tokens);
354       CreateARCD(beneficiary, tokens);  // logs token creation
355 
356       forwardFunds();
357     }
358 
359     function finalize() public {
360       require (!isFinalized);
361       require (block.timestamp > FUNDING_END_TIMESTAMP || token.totalSupply() == TOKEN_CREATION_CAP);
362       require (msg.sender == ETH_FUND_DEPOSIT);
363       isFinalized = true;
364       token.finishMinting();
365     }
366 
367     // send ether to the fund collection wallet
368     function forwardFunds() internal {
369       ETH_FUND_DEPOSIT.transfer(msg.value);
370     }
371 }