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
298 contract MNC is StandardToken, Ownable {
299   string public constant name = "Moneynet Coin";
300   string public constant symbol = "MNC";
301   uint32 public constant decimals = 18;
302 
303   // Tokens amount
304   uint256 public saleTokens = uint256(6e9).mul(1 ether);
305   uint256 public ecosystemTokens = uint256(204e8).mul(1 ether);
306   uint256 public teamTokens = uint256(4e9).mul(1 ether);
307   uint256 public investorsTokens = uint256(24e8).mul(1 ether);
308   uint256 public advisorsTokens = uint256(2e9).mul(1 ether);
309   uint256 public bonusTokens = uint256(16e8).mul(1 ether);
310   uint256 public reserveTokens = uint256(36e8).mul(1 ether);
311 
312   // sale contract address
313   address public saleContract;
314 
315   // locked tokens data
316   mapping(address => uint256) public lockedTokens_3;
317   mapping(address => uint256) public lockedTokens_6;
318   mapping(address => uint256) public lockedTokens_12;
319   uint256 lockTime = now;
320 
321   constructor(address _newOwner) public {
322     require(_newOwner != address(0));
323     uint256 tokens = ecosystemTokens;
324     owner = _newOwner;
325     balances[owner] = balances[owner].add(tokens);
326     totalSupply_ = totalSupply_.add(tokens);
327     emit Transfer(address(0), owner, tokens);
328   }
329 
330 
331   /**
332    * @dev Sending tokens for sale to the sale contract address.
333    * @param _contract Sale contract address.
334    */
335   function activateSaleContract(address _contract) public onlyOwner returns (bool) {
336     require(_contract != address(0));
337     require(saleTokens > 0);
338     uint256 tokens = saleTokens;
339     saleTokens = 0;
340     saleContract = _contract;
341     totalSupply_ = totalSupply_.add(tokens);
342     balances[_contract] = balances[_contract].add(tokens);
343     emit Transfer(address(0), _contract, tokens);
344     return true;
345   }
346 
347   /**
348    * @dev Sending reserve tokens to the sale contract address.
349    */
350   function sendReserveTokens() public onlyOwner returns (bool) {
351     require(saleContract != address(0));
352     require(reserveTokens > 0);
353     uint256 tokens = reserveTokens;
354     reserveTokens = 0;
355     totalSupply_ = totalSupply_.add(tokens);
356     balances[saleContract] = balances[saleContract].add(tokens);
357     emit Transfer(address(0), saleContract, tokens);
358     return true;
359   }
360 
361   /**
362    * @dev  Team tokens accrual.
363    * @param _address Recepient address.
364    * @param _amount Accrued amount.
365    */
366   function accrueTeamTokens(address _address, uint256 _amount) public onlyOwner returns (bool) {
367     require(_amount > 0);
368     require(_amount <= teamTokens);
369     require(_address != address(0));
370     teamTokens = teamTokens.sub(_amount);
371     lockedTokens_12[_address] = lockedTokens_12[_address].add(_amount);
372     return true;
373   }
374 
375   /**
376    * @dev  Investors tokens accrual.
377    * @param _address Recepient address.
378    * @param _amount Accrued amount.
379    */
380   function accrueInvestorsTokens(address _address, uint256 _amount) public onlyOwner returns (bool) {
381     require(_amount > 0);
382     require(_amount <= investorsTokens);
383     require(_address != address(0));
384     investorsTokens = investorsTokens.sub(_amount);
385     lockedTokens_6[_address] = lockedTokens_6[_address].add(_amount);
386     return true;
387   }
388 
389   /**
390    * @dev  Advisors tokens accrual.
391    * @param _address Recepient address.
392    * @param _amount Accrued amount.
393    */
394   function accrueAdvisorsTokens(address _address, uint256 _amount) public onlyOwner returns (bool) {
395     require(_amount > 0);
396     require(_amount <= advisorsTokens);
397     require(_address != address(0));
398     advisorsTokens = advisorsTokens.sub(_amount);
399     lockedTokens_6[_address] = lockedTokens_6[_address].add(_amount);
400     return true;
401   }
402 
403   /**
404    * @dev  Bonus tokens accrual.
405    * @param _address Recepient address.
406    * @param _amount Accrued amount.
407    */
408   function accrueBonusTokens(address _address, uint256 _amount) public onlyOwner returns (bool) {
409     require(_amount > 0);
410     require(_amount <= bonusTokens);
411     require(_address != address(0));
412     bonusTokens = bonusTokens.sub(_amount);
413     lockedTokens_3[_address] = lockedTokens_3[_address].add(_amount);
414     return true;
415   }
416 
417   function releaseTokens() public returns (bool) {
418     uint256 tokens = 0;
419     if (lockedTokens_3[msg.sender] > 0 && now.sub(lockTime) > 91 days) {
420       tokens = tokens.add(lockedTokens_3[msg.sender]);
421       lockedTokens_3[msg.sender] = 0;
422     }
423     if (lockedTokens_6[msg.sender] > 0 && now.sub(lockTime) > 182 days) {
424       tokens = tokens.add(lockedTokens_6[msg.sender]);
425       lockedTokens_6[msg.sender] = 0;
426     }
427     if (lockedTokens_12[msg.sender] > 0 && now.sub(lockTime) > 365 days) {
428       tokens = tokens.add(lockedTokens_12[msg.sender]);
429       lockedTokens_12[msg.sender] = 0;
430     }
431     require (tokens > 0);
432     totalSupply_ = totalSupply_.add(tokens);
433     balances[msg.sender] = balances[msg.sender].add(tokens);
434     emit Transfer(address(0), msg.sender, tokens);
435   }
436 }