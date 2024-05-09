1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230 }
231 
232 contract ReceivingContractCallback {
233 
234   function tokenFallback(address _from, uint _value) public;
235 
236 }
237 
238 contract WalletsPercents is Ownable {
239 
240   address[] public wallets;
241 
242   mapping (address => uint) public percents;
243 
244   function addWallet(address wallet, uint percent) public onlyOwner {
245     wallets.push(wallet);
246     percents[wallet] = percent;
247   }
248  
249   function cleanWallets() public onlyOwner {
250     wallets.length = 0;
251   }
252 
253 }
254 
255 contract CommonToken is StandardToken, WalletsPercents {
256 
257   event Mint(address indexed to, uint256 amount);
258 
259   uint public constant PERCENT_RATE = 100;
260 
261   uint32 public constant decimals = 18;
262 
263   address[] public tokenHolders;
264 
265   bool public locked = false;
266 
267   mapping (address => bool)  public registeredCallbacks;
268 
269   mapping (address => bool) public unlockedAddresses;
270   
271   bool public initialized = false;
272 
273   function init() public onlyOwner {
274     require(!initialized);
275     totalSupply = 500000000000000000000000000;
276     balances[this] = totalSupply;
277     tokenHolders.push(this);
278     Mint(this, totalSupply);
279     unlockedAddresses[this] = true;
280     unlockedAddresses[owner] = true;
281     for(uint i = 0; i < wallets.length; i++) {
282       address wallet = wallets[i];
283       uint amount = totalSupply.mul(percents[wallet]).div(PERCENT_RATE);
284       balances[this] = balances[this].sub(amount);
285       balances[wallet] = balances[wallet].add(amount);
286       tokenHolders.push(wallet);
287       Transfer(this, wallet, amount);
288     }
289     initialized = true;
290   }
291 
292   modifier notLocked(address sender) {
293     require(!locked || unlockedAddresses[sender]);
294     _;
295   }
296 
297   function transferOwnership(address to) public {
298     unlockedAddresses[owner] = false;
299     super.transferOwnership(to);
300     unlockedAddresses[owner] = true;
301   }
302 
303   function addUnlockedAddress(address addressToUnlock) public onlyOwner {
304     unlockedAddresses[addressToUnlock] = true;
305   }
306 
307   function removeUnlockedAddress(address addressToUnlock) public onlyOwner {
308     unlockedAddresses[addressToUnlock] = false;
309   }
310 
311   function unlockBatchOfAddresses(address[] addressesToUnlock) public onlyOwner {
312     for(uint i = 0; i < addressesToUnlock.length; i++) unlockedAddresses[addressesToUnlock[i]] = true;
313   }
314 
315   function setLocked(bool newLock) public onlyOwner {
316     locked = newLock;
317   }
318 
319   function transfer(address to, uint256 value) public notLocked(msg.sender) returns (bool) {
320     tokenHolders.push(to);
321     return processCallback(super.transfer(to, value), msg.sender, to, value);
322   }
323 
324   function transferFrom(address from, address to, uint256 value) public notLocked(from) returns (bool) {
325     tokenHolders.push(to);
326     return processCallback(super.transferFrom(from, to, value), from, to, value);
327   }
328 
329   function registerCallback(address callback) public onlyOwner {
330     registeredCallbacks[callback] = true;
331   }
332 
333   function deregisterCallback(address callback) public onlyOwner {
334     registeredCallbacks[callback] = false;
335   }
336 
337   function processCallback(bool result, address from, address to, uint value) internal returns(bool) {
338     if (result && registeredCallbacks[to]) {
339       ReceivingContractCallback targetCallback = ReceivingContractCallback(to);
340       targetCallback.tokenFallback(from, value);
341     }
342     return result;
343   }
344 
345 }
346 
347 contract BITTToken is CommonToken {
348 
349   string public constant name = "BITT";
350 
351   string public constant symbol = "BITT";
352 
353 }
354 
355 
356 contract BITZToken is CommonToken {
357 
358   string public constant name = "BITZ";
359 
360   string public constant symbol = "BITZ";
361 
362 }
363 
364 contract Configurator is Ownable {
365 
366   CommonToken public bittToken;
367 
368   CommonToken public bitzToken;
369 
370   function Configurator() public onlyOwner {
371     address manager = 0xe99c8d442a5484bE05E3A5AB1AeA967caFf07133;
372 
373     bittToken = new BITTToken();
374     bittToken.addWallet(0x08C32a099E59c7e913B16cAd4a6C988f1a5A7216, 60);
375     bittToken.addWallet(0x5b2A9b86113632d086CcD8c9dAf67294eda78105, 20);
376     bittToken.addWallet(0x3019B9ad002Ddec2F49e14FB591c8CcD81800847, 10);
377     bittToken.addWallet(0x18fd87AAB645fd4c0cEBc21fb0a271E1E2bA5363, 5);
378     bittToken.addWallet(0x1eC03A084Cc02754776a9fEffC4b47dAE4800620, 3);
379     bittToken.addWallet(0xb119f842E6A10Dc545Af3c53ff28250B5F45F9b2, 2);
380     bittToken.init();
381     bittToken.transferOwnership(manager);
382 
383     bitzToken = new BITZToken();
384     bitzToken.addWallet(0xc0f1a3E91C2D0Bcc5CD398D05F851C2Fb1F3fE30, 60);
385     bitzToken.addWallet(0x3019B9ad002Ddec2F49e14FB591c8CcD81800847, 20);
386     bitzToken.addWallet(0x04eb6a716c814b0B4A12dC9964916D64C55179C1, 20);
387     bitzToken.init();
388     bitzToken.transferOwnership(manager);
389   }
390 
391 }