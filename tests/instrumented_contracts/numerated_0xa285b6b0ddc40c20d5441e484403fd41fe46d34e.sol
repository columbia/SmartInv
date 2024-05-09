1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(
144     address _from,
145     address _to,
146     uint256 _value
147   )
148     public
149     returns (bool)
150   {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     emit Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(
206     address _spender,
207     uint _addedValue
208   )
209     public
210     returns (bool)
211   {
212     allowed[msg.sender][_spender] = (
213       allowed[msg.sender][_spender].add(_addedValue));
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to transfer control of the contract to a newOwner.
281    * @param newOwner The address to transfer ownership to.
282    */
283   function transferOwnership(address newOwner) public onlyOwner {
284     require(newOwner != address(0));
285     emit OwnershipTransferred(owner, newOwner);
286     owner = newOwner;
287   }
288 
289   /**
290    * @dev Allows the current owner to relinquish control of the contract.
291    */
292   function renounceOwnership() public onlyOwner {
293     emit OwnershipRenounced(owner);
294     owner = address(0);
295   }
296 }
297 
298 /**
299  * @title Mintable token
300  * @dev Simple ERC20 Token example, with mintable token creation
301  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
302  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
303  */
304 contract MintableToken is StandardToken, Ownable {
305   event Mint(address indexed to, uint256 amount);
306   event MintFinished();
307 
308   bool public mintingFinished = false;
309 
310 
311   modifier canMint() {
312     require(!mintingFinished);
313     _;
314   }
315 
316   modifier hasMintPermission() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Function to mint tokens
323    * @param _to The address that will receive the minted tokens.
324    * @param _amount The amount of tokens to mint.
325    * @return A boolean that indicates if the operation was successful.
326    */
327   function mint(
328     address _to,
329     uint256 _amount
330   )
331     hasMintPermission
332     canMint
333     public
334     returns (bool)
335   {
336     totalSupply_ = totalSupply_.add(_amount);
337     balances[_to] = balances[_to].add(_amount);
338     emit Mint(_to, _amount);
339     emit Transfer(address(0), _to, _amount);
340     return true;
341   }
342 
343   /**
344    * @dev Function to stop minting new tokens.
345    * @return True if the operation was successful.
346    */
347   function finishMinting() onlyOwner canMint public returns (bool) {
348     mintingFinished = true;
349     emit MintFinished();
350     return true;
351   }
352 }
353 
354 contract CrowdsaleToken is MintableToken {
355   uint256 public cap = 300000000;
356   uint256 public crowdSaleCap = 210000000;
357 //  uint256 public basePrice = 1500000000000000; //wei per 1 token
358   uint256 public basePrice = 15000000000000; //wei per 1 token * 100 for testing
359   uint32 public privateSaleStartDate = 1526342400; //15.05.2018 00:00
360   uint32 public privateSaleEndDate = 1529107199; //15.06.2018 23:59
361   uint32 public preIcoStartDate = 1529107200; //16.06.2018 00:00
362   uint32 public preIcoEndDate = 1531785599; //16.06.2018 00:00
363   uint32 public icoStartDate = 1533081600; //01.08.2018 00:00
364   uint32 public icoBonus1EndDate = 1533437999; //05.08.2018 23:59
365   uint32 public icoBonus2EndDate = 1533945599; //10.08.2018 23:59
366   uint32 public icoBonus3EndDate = 1534377599; //15.08.2018 23:59
367   uint32 public icoBonus4EndDate = 1534809599; //20.08.2018 23:59
368   uint32 public icoBonus5EndDate = 1535846399; //01.09.2018 23:59
369 
370   enum Stages {PrivateSale, PreIco, Ico}
371   Stages currentStage;
372 
373   constructor() public {
374     uint256 team = cap.sub(crowdSaleCap);
375     balances[owner] = team;
376     totalSupply_ = team;
377     emit Transfer(address(this), owner, team);
378     currentStage = Stages.PrivateSale;
379   }
380 
381   function getStage () internal returns (uint8) {
382     if (now > preIcoEndDate && currentStage != Stages.Ico) currentStage = Stages.Ico;
383     if (now > privateSaleEndDate && now <= preIcoEndDate && currentStage != Stages.PreIco) currentStage = Stages.PreIco;
384     return uint8(currentStage);
385   }
386 
387   function getBonuses (uint256 _tokens) public returns (uint8) {
388     uint8 _currentStage = getStage();
389     if (_currentStage == 0) {
390       if (_tokens > 70000) return 60;
391       if (_tokens > 45000) return 50;
392       if (_tokens > 30000) return 42;
393       if (_tokens > 10000) return 36;
394       if (_tokens > 3000) return 30;
395       if (_tokens > 1000) return 25;
396     }
397     if (_currentStage == 1) {
398       if (_tokens > 45000) return 45;
399       if (_tokens > 30000) return 35;
400       if (_tokens > 10000) return 30;
401       if (_tokens > 3000) return 25;
402       if (_tokens > 1000) return 20;
403       if (_tokens > 25) return 15;
404     }
405     if (_currentStage == 2) {
406       if (now <= icoBonus1EndDate) return 30;
407       if (now <= icoBonus2EndDate) return 25;
408       if (now <= icoBonus3EndDate) return 20;
409       if (now <= icoBonus4EndDate) return 15;
410       if (now <= icoBonus5EndDate) return 10;
411     }
412     return 0;
413   }
414 
415   function mint (address _to, uint256 _amount) public returns (bool) {
416     require(totalSupply_.add(_amount) <= cap);
417     return super.mint(_to, _amount);
418   }
419 
420   function () public payable {
421     uint256 tokens = msg.value.div(basePrice);
422     uint8 bonuses = getBonuses(tokens);
423     uint256 extraTokens = tokens.mul(bonuses).div(100);
424     tokens = tokens.add(extraTokens);
425     require(totalSupply_.add(tokens) <= cap);
426     owner.transfer(msg.value);
427     balances[msg.sender] = balances[msg.sender].add(tokens);
428     totalSupply_ = totalSupply_.add(tokens);
429     emit Transfer(address(this), msg.sender, tokens);
430   }
431 } 
432 
433 contract FBC is CrowdsaleToken {
434   string public constant name = "Feon Bank Coin";
435   string public constant symbol = "FBC";
436   uint32 public constant decimals = 0;
437 }