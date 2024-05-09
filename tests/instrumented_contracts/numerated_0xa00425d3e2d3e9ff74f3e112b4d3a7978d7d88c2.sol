1 pragma solidity ^0.4.18;
2 
3 //
4 // imports from https://github.com/OpenZeppelin/zeppelin-solidity
5 //
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[msg.sender]);
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public view returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public view returns (uint256) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    */
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
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
180 /**
181  * @title Ownable
182  * @dev The Ownable contract has an owner address, and provides basic authorization control
183  * functions, this simplifies the implementation of "user permissions".
184  */
185 contract Ownable {
186   address public owner;
187 
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190   /**
191    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
192    * account.
193    */
194   function Ownable() public {
195     owner = msg.sender;
196   }
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206   /**
207    * @dev Allows the current owner to transfer control of the contract to a newOwner.
208    * @param newOwner The address to transfer ownership to.
209    */
210   function transferOwnership(address newOwner) public onlyOwner {
211     require(newOwner != address(0));
212     OwnershipTransferred(owner, newOwner);
213     owner = newOwner;
214   }
215 
216 }
217 
218 
219 //
220 //   GoPowerToken
221 //
222 
223 contract GoPowerToken is StandardToken, Ownable {
224 
225   string public name = 'GoPower Token';
226   string public symbol = 'GPT';
227   uint public decimals = 18;
228 
229 
230   //
231   //   Distribution of tokens
232   //
233 
234   uint constant TOKEN_TOTAL_SUPPLY_LIMIT = 700 * 1e6 * 1e18;
235   uint constant TOKEN_SALE_LIMIT =         600 * 1e6 * 1e18;
236   uint constant RESERVED_FOR_SETTLEMENTS =  50 * 1e6 * 1e18;
237   uint constant RESERVED_FOR_TEAM =         30 * 1e6 * 1e18;
238   uint constant RESERVED_FOR_BOUNTY =       20 * 1e6 * 1e18;
239 
240   address constant settlementsAddress = 0x9e6290C55faba3FFA269cCbF054f8D93586aaa6D;
241   address constant teamAddress = 0xaA2E8DEbEAf429A21c59c3E697d9FC5bB86E126d;
242   address constant bountyAddress = 0xdFa360FdF23DC9A7bdF1d968f453831d3351c33D;
243 
244 
245   //
246   //   Token rate calculation parameters
247   //
248 
249   uint constant TOKEN_RATE_INITIAL =  0.000571428571428571 ether;           // 1/1750
250   uint constant TOKEN_RATE_ICO_DAILY_INCREMENT = TOKEN_RATE_INITIAL / 200;  // 0.5%
251   uint constant BONUS_PRESALE = 50;    // 50%
252   uint constant BONUS_ICO_WEEK1 = 30;  // 30%
253   uint constant BONUS_ICO_WEEK2 = 20;  // 20%
254   uint constant BONUS_ICO_WEEK3 = 10;  // 10%
255   uint constant BONUS_ICO_WEEK4 = 5;   // 5%
256   uint constant MINIMUM_PAYABLE_AMOUNT = 0.0001 ether;
257   uint constant TOKEN_BUY_PRECISION = 0.01e18;
258 
259 
260   //
261   //    State transitions
262   //
263 
264   uint public presaleStartedAt;
265   uint public presaleFinishedAt;
266   uint public icoStartedAt;
267   uint public icoFinishedAt;
268 
269   function presaleInProgress() private view returns (bool) {
270     return ((presaleStartedAt > 0) && (presaleFinishedAt == 0));
271   }
272 
273   function icoInProgress() private view returns (bool) {
274     return ((icoStartedAt > 0) && (icoFinishedAt == 0));
275   }
276 
277   modifier onlyDuringSale { require(presaleInProgress() || icoInProgress()); _; }
278   modifier onlyAfterICO { require(icoFinishedAt > 0); _; }
279 
280   function startPresale() onlyOwner external returns(bool) {
281     require(presaleStartedAt == 0);
282     presaleStartedAt = now;
283     return true;
284   }
285 
286   function finishPresale() onlyOwner external returns(bool) {
287     require(presaleInProgress());
288     presaleFinishedAt = now;
289     return true;
290   }
291 
292   function startICO() onlyOwner external returns(bool) {
293     require(presaleFinishedAt > 0);
294     require(icoStartedAt == 0);
295     icoStartedAt = now;
296     return true;
297   }
298 
299   function finishICO() onlyOwner external returns(bool) {
300     require(icoInProgress());
301     _mint_internal(settlementsAddress, RESERVED_FOR_SETTLEMENTS);
302     _mint_internal(teamAddress, RESERVED_FOR_TEAM);
303     _mint_internal(bountyAddress, RESERVED_FOR_BOUNTY);
304     icoFinishedAt = now;
305     tradeRobot = address(0);   // disable trade robot
306     return true;
307   }
308 
309 
310   //
311   //  Trade robot permissions
312   //
313 
314   address public tradeRobot;
315   modifier onlyTradeRobot { require(msg.sender == tradeRobot); _; }
316 
317   function setTradeRobot(address _robot) onlyOwner external returns(bool) {
318     require(icoFinishedAt == 0); // the robot is disabled after the end of ICO
319     tradeRobot = _robot;
320     return true;
321   }
322 
323 
324   //
325   //   Token sale logic
326   //
327 
328   function _mint_internal(address _to, uint _amount) private {
329     totalSupply = totalSupply.add(_amount);
330     balances[_to] = balances[_to].add(_amount);
331     Transfer(address(0), _to, _amount);
332   }
333 
334   function mint(address _to, uint _amount) onlyDuringSale onlyTradeRobot external returns (bool) {
335     _mint_internal(_to, _amount);
336     return true;
337   }
338 
339   function mintUpto(address _to, uint _newValue) onlyDuringSale onlyTradeRobot external returns (bool) {
340     var oldValue = balances[_to];
341     require(_newValue > oldValue);
342     _mint_internal(_to, _newValue.sub(oldValue));
343     return true;
344   }
345 
346   function buy() onlyDuringSale public payable {
347     assert(msg.value >= MINIMUM_PAYABLE_AMOUNT);
348     var tokenRate = TOKEN_RATE_INITIAL;
349     uint amount;
350 
351     if (icoInProgress()) { // main ICO
352 
353       var daysFromIcoStart = now.sub(icoStartedAt).div(1 days);
354       tokenRate = tokenRate.add( TOKEN_RATE_ICO_DAILY_INCREMENT.mul(daysFromIcoStart) );
355       amount = msg.value.mul(1e18).div(tokenRate);
356 
357       var weekNumber = 1 + daysFromIcoStart.div(7);
358       if (weekNumber == 1) {
359         amount = amount.add( amount.mul(BONUS_ICO_WEEK1).div(100) );
360       } else if (weekNumber == 2) {
361         amount = amount.add( amount.mul(BONUS_ICO_WEEK2).div(100) );
362       } else if (weekNumber == 3) {
363         amount = amount.add( amount.mul(BONUS_ICO_WEEK3).div(100) );
364       } else if (weekNumber == 4) {
365         amount = amount.add( amount.mul(BONUS_ICO_WEEK4).div(100) );
366       }
367     
368     } else {  // presale
369 
370       amount = msg.value.mul(1e18).div(tokenRate);
371       amount = amount.add( amount.mul(BONUS_PRESALE).div(100) );
372     }
373 
374     amount = amount.add(TOKEN_BUY_PRECISION/2).div(TOKEN_BUY_PRECISION).mul(TOKEN_BUY_PRECISION);
375 
376     require(totalSupply.add(amount) <= TOKEN_SALE_LIMIT);
377     _mint_internal(msg.sender, amount);
378   }
379 
380   function () external payable {
381     buy();
382   }
383 
384   function collect() onlyOwner external {
385     msg.sender.transfer(this.balance);
386   }
387 
388 
389   //
390   //   Token transfer operations are locked until the end of ICO
391   //
392 
393   // this one is much more gas-effective because of the 'external' visibility
394   function transferExt(address _to, uint256 _value) onlyAfterICO external returns (bool) {
395     require(_to != address(0));
396     require(_value <= balances[msg.sender]);
397 
398     // SafeMath.sub will throw if there is not enough balance.
399     balances[msg.sender] = balances[msg.sender].sub(_value);
400     balances[_to] = balances[_to].add(_value);
401     Transfer(msg.sender, _to, _value);
402     return true;
403   }
404 
405   function transfer(address _to, uint _value) onlyAfterICO public returns (bool) {
406     return super.transfer(_to, _value);
407   }
408 
409   function transferFrom(address _from, address _to, uint _value) onlyAfterICO public returns (bool) {
410     return super.transferFrom(_from, _to, _value);
411   }
412 
413   function approve(address _spender, uint _value) onlyAfterICO public returns (bool) {
414     return super.approve(_spender, _value);
415   }
416 
417   function increaseApproval(address _spender, uint _addedValue) onlyAfterICO public returns (bool) {
418     return super.increaseApproval(_spender, _addedValue);
419   }
420 
421   function decreaseApproval(address _spender, uint _subtractedValue) onlyAfterICO public returns (bool) {
422     return super.decreaseApproval(_spender, _subtractedValue);
423   }
424 
425 }