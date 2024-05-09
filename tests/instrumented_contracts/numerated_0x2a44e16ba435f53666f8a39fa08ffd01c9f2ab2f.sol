1 pragma solidity ^0.4.16;
2 
3 /**
4  * White Stone Coin
5  *
6  * When Art meets Blockchain, interesting things happen.
7  *
8  * This is a very simple token with the following properties:
9  *  - 10.000.000 coins max supply
10  *  - 5.000.000 coins mined for the company wallet
11  *  - Investor receives bonus coins from company wallet during bonus phases
12  * 
13  * Visit https://whscoin.com for more information and tokenholder benefits. 
14  */
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22   function totalSupply() public view returns (uint256);
23   function balanceOf(address who) public view returns (uint256);
24   function transfer(address to, uint256 value) public returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   /**
57   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     // SafeMath.sub will throw if there is not enough balance.
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) public view returns (uint256);
125   function transferFrom(address from, address to, uint256 value) public returns (bool);
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(address _owner, address _spender) public view returns (uint256) {
183     return allowed[_owner][_spender];
184   }
185 
186   /**
187    * @dev Increase the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _addedValue The amount of tokens to increase the allowance by.
195    */
196   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   /**
203    * @dev Decrease the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To decrement
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _subtractedValue The amount of tokens to decrease the allowance by.
211    */
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 /**
226  * @title Ownable
227  * @dev The Ownable contract has an owner address, and provides basic authorization control
228  * functions, this simplifies the implementation of "user permissions".
229  */
230 contract Ownable {
231   address public owner;
232 
233 
234   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236 
237   /**
238    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
239    * account.
240    */
241   function Ownable() public {
242     owner = msg.sender;
243   }
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253   /**
254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
255    * @param newOwner The address to transfer ownership to.
256    */
257   function transferOwnership(address newOwner) public onlyOwner {
258     require(newOwner != address(0));
259     OwnershipTransferred(owner, newOwner);
260     owner = newOwner;
261   }
262 
263 }
264 
265 
266 
267 
268 contract WHSCoin is StandardToken, Ownable {
269   string public constant name = "White Stone Coin";
270   string public constant symbol = "WHS";
271   uint256 public constant decimals = 18;
272 
273   uint256 public constant UNIT = 10 ** decimals;
274 
275   address public companyWallet;
276   address public admin;
277 
278   uint256 public tokenPrice = 0.01 ether;
279   uint256 public maxSupply = 10000000 * UNIT;
280   uint256 public totalSupply = 0;
281   uint256 public totalWeiReceived = 0;
282 
283   uint256 startDate  = 1516856400; // 14:00 JST Jan 25 2018;
284   uint256 endDate    = 1522731600; // 14:00 JST Apr 3 2018;
285 
286   uint256 bonus30end = 1518066000; // 14:00 JST Feb 8 2018;
287   uint256 bonus15end = 1519794000; // 14:00 JST Feb 28 2018;
288   uint256 bonus5end  = 1521003600; // 14:00 JST Mar 14 2018;
289 
290   /**
291    * event for token purchase logging
292    * @param purchaser who paid for the tokens
293    * @param beneficiary who got the tokens
294    * @param value weis paid for purchase
295    * @param amount amount of tokens purchased
296    */
297   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
298 
299   event NewSale();
300 
301   modifier onlyAdmin() {
302     require(msg.sender == admin);
303     _;
304   }
305 
306   function WHSCoin(address _companyWallet, address _admin) public {
307     companyWallet = _companyWallet;
308     admin = _admin;
309     balances[companyWallet] = 5000000 * UNIT;
310     totalSupply = totalSupply.add(5000000 * UNIT);
311     Transfer(address(0x0), _companyWallet, 5000000 * UNIT);
312   }
313 
314   function setAdmin(address _admin) public onlyOwner {
315     admin = _admin;
316   }
317 
318   function calcBonus(uint256 _amount) internal view returns (uint256) {
319     uint256 bonusPercentage = 30;
320     if (now > bonus30end) bonusPercentage = 15;
321     if (now > bonus15end) bonusPercentage = 5;
322     if (now > bonus5end) bonusPercentage = 0;
323     return _amount * bonusPercentage / 100;
324   }
325 
326   function buyTokens() public payable {
327     require(now < endDate);
328     require(now >= startDate);
329     require(msg.value > 0);
330 
331     uint256 amount = msg.value * UNIT / tokenPrice;
332     uint256 bonus = calcBonus(msg.value) * UNIT / tokenPrice;
333     
334     totalSupply = totalSupply.add(amount);
335     
336     require(totalSupply <= maxSupply);
337 
338     totalWeiReceived = totalWeiReceived.add(msg.value);
339 
340     balances[msg.sender] = balances[msg.sender].add(amount);
341     
342     TokenPurchase(msg.sender, msg.sender, msg.value, amount);
343     
344     Transfer(address(0x0), msg.sender, amount);
345 
346     if (bonus > 0) {
347       Transfer(companyWallet, msg.sender, bonus);
348       balances[companyWallet] -= bonus;
349       balances[msg.sender] = balances[msg.sender].add(bonus);
350     }
351 
352     companyWallet.transfer(msg.value);
353   }
354 
355   function() public payable {
356     buyTokens();
357   }
358 
359   /***
360    * This function is used to transfer tokens that have been bought through other means (credit card, bitcoin, etc), and to burn tokens after the sale.
361    */
362   function sendTokens(address receiver, uint256 tokens) public onlyAdmin {
363     require(now < endDate);
364     require(now >= startDate);
365     require(totalSupply + tokens <= maxSupply);
366 
367     balances[receiver] += tokens;
368     totalSupply += tokens;
369     Transfer(address(0x0), receiver, tokens);
370 
371     uint256 bonus = calcBonus(tokens);
372     if (bonus > 0) {
373       sendBonus(receiver, bonus);
374     }
375   }
376 
377   function sendBonus(address receiver, uint256 bonus) public onlyAdmin {
378     Transfer(companyWallet, receiver, bonus);
379     balances[companyWallet] = balances[companyWallet].sub(bonus);
380     balances[receiver] = balances[receiver].add(bonus);
381   }
382 
383 }