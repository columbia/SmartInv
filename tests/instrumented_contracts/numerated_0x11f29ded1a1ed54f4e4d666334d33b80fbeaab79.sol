1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ReceivingContractCallback.sol
4 
5 contract ReceivingContractCallback {
6 
7   function tokenFallback(address _from, uint _value) public;
8 
9 }
10 
11 // File: contracts/ownership/Ownable.sol
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20 
21 
22   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   function Ownable() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 // File: contracts/math/SafeMath.sol
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     if (a == 0) {
66       return 0;
67     }
68     uint256 c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return c;
81   }
82 
83   /**
84   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 // File: contracts/token/ERC20/ERC20Basic.sol
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109   function totalSupply() public view returns (uint256);
110   function balanceOf(address who) public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 // File: contracts/token/ERC20/BasicToken.sol
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125 
126   uint256 totalSupply_;
127 
128   /**
129   * @dev total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133   }
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance.
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) public view returns (uint256 balance) {
157     return balances[_owner];
158   }
159 
160 }
161 
162 // File: contracts/token/ERC20/ERC20.sol
163 
164 /**
165  * @title ERC20 interface
166  * @dev see https://github.com/ethereum/EIPs/issues/20
167  */
168 contract ERC20 is ERC20Basic {
169   function allowance(address owner, address spender) public view returns (uint256);
170   function transferFrom(address from, address to, uint256 value) public returns (bool);
171   function approve(address spender, uint256 value) public returns (bool);
172   event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 // File: contracts/token/ERC20/StandardToken.sol
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
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
272 // File: contracts/token/ERC20/MintableToken.sol
273 
274 /**
275  * @title Mintable token
276  * @dev Simple ERC20 Token example, with mintable token creation
277  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
278  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
279  */
280 contract MintableToken is StandardToken, Ownable {
281   event Mint(address indexed to, uint256 amount);
282   event MintFinished();
283 
284   bool public mintingFinished = false;
285 
286 
287   modifier canMint() {
288     require(!mintingFinished);
289     _;
290   }
291 
292   /**
293    * @dev Function to mint tokens
294    * @param _to The address that will receive the minted tokens.
295    * @param _amount The amount of tokens to mint.
296    * @return A boolean that indicates if the operation was successful.
297    */
298   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
299     totalSupply_ = totalSupply_.add(_amount);
300     balances[_to] = balances[_to].add(_amount);
301     Mint(_to, _amount);
302     Transfer(address(0), _to, _amount);
303     return true;
304   }
305 
306   /**
307    * @dev Function to stop minting new tokens.
308    * @return True if the operation was successful.
309    */
310   function finishMinting() onlyOwner canMint public returns (bool) {
311     mintingFinished = true;
312     MintFinished();
313     return true;
314   }
315 }
316 
317 // File: contracts/StasyqToken.sol
318 
319 contract StasyqToken is MintableToken {
320 
321   string public constant name = "Stasyq";
322 
323   string public constant symbol = "STQ";
324 
325   uint32 public constant decimals = 18;
326 
327   address public saleAgent;
328 
329   mapping (address => uint) public locked;
330 
331   mapping(address => bool)  public registeredCallbacks;
332 
333   modifier canTransfer() {
334     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
335     _;
336   }
337 
338   modifier onlyOwnerOrSaleAgent() {
339     require(msg.sender == owner || msg.sender == saleAgent);
340     _;
341   }
342 
343   function setSaleAgent(address newSaleAgnet) public onlyOwnerOrSaleAgent {
344     saleAgent = newSaleAgnet;
345   }
346 
347   function mint(address _to, uint256 _amount) public onlyOwnerOrSaleAgent canMint returns (bool) {
348     totalSupply_ = totalSupply_.add(_amount);
349     balances[_to] = balances[_to].add(_amount);
350     Mint(_to, _amount);
351     return true;
352   }
353 
354   function finishMinting() public onlyOwnerOrSaleAgent canMint returns (bool) {
355     mintingFinished = true;
356     MintFinished();
357     return true;
358   }
359 
360   function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
361     require(locked[msg.sender] < now);
362     return processCallback(super.transfer(_to, _value), msg.sender, _to, _value);
363   }
364 
365   function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
366     require(locked[_from] < now);
367     return processCallback(super.transferFrom(_from, _to, _value), _from, _to, _value);
368   }
369 
370   function lock(address addr, uint periodInDays) public {
371     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
372     locked[addr] = now.add(periodInDays * 1 days);
373   }
374 
375   function registerCallback(address callback) public onlyOwner {
376     registeredCallbacks[callback] = true;
377   }
378 
379   function deregisterCallback(address callback) public onlyOwner {
380     registeredCallbacks[callback] = false;
381   }
382 
383   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
384     if (result && registeredCallbacks[to]) {
385       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
386       targetCallback.tokenFallback(from, value);
387     }
388     return result;
389   }
390 
391 }