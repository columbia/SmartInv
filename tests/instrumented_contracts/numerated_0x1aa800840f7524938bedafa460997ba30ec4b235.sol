1 pragma solidity ^0.4.18;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222 
223   /**
224    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
225    * account.
226    */
227   function Ownable() public {
228     owner = msg.sender;
229   }
230 
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require(msg.sender == owner);
236     _;
237   }
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) public onlyOwner {
244     require(newOwner != address(0));
245     OwnershipTransferred(owner, newOwner);
246     owner = newOwner;
247   }
248 
249 }
250 
251 contract ConfigurableToken is StandardToken, Ownable {
252   uint256 public totalTokens = uint256(1000000000).mul(1 ether);
253   uint256 public tokensForSale = uint256(750000000).mul(1 ether);
254   uint256 public bountyTokens = uint256(25000000).mul(1 ether);
255   uint256 public teamTokens = uint256(100000000).mul(1 ether);
256   uint256 public teamReleased = 0;
257   uint256 public employeePoolTokens = uint256(50000000).mul(1 ether);
258   uint256 public liquidityPoolTokens = uint256(50000000).mul(1 ether);
259   uint256 public advisorsTokens = uint256(25000000).mul(1 ether);
260   uint256 public advisorsReleased = 0;
261   uint256 public listingDate = 0;
262   uint256 tokensUnlockPeriod = 2592000; // 30 days
263   uint256 vestingPeriod = 15724800; // 182 days (6 months)
264   address public saleContract;
265   address public advisors;
266   address public team;
267   bool public tokensLocked = true;
268 
269   event SaleContractActivation(address saleContract, uint256 tokensForSale);
270 
271   event Burn(address tokensOwner, uint256 burnedTokensAmount);
272 
273   modifier tokenNotLocked() {
274     if (tokensLocked && msg.sender != owner) {
275       if (listingDate > 0 && now.sub(listingDate) > tokensUnlockPeriod) {
276         tokensLocked = false;
277       } else {
278         revert();
279       }
280     }
281     _;
282   }
283 
284   function activateSaleContract(address _saleContract) public onlyOwner {
285     require(_saleContract != address(0));
286     saleContract = _saleContract;
287     balances[saleContract] = balances[saleContract].add(tokensForSale);
288     totalSupply_ = totalSupply_.add(tokensForSale);
289     require(totalSupply_ <= totalTokens);
290     Transfer(address(this), saleContract, tokensForSale);
291     SaleContractActivation(saleContract, tokensForSale);
292   }
293 
294   function isListing() public onlyOwner {
295     listingDate = now;
296   }
297 
298   function transfer(address _to, uint256 _value) public tokenNotLocked returns (bool) {
299     return super.transfer(_to, _value);
300   }
301 
302   function transferFrom(address _from, address _to, uint256 _value) public tokenNotLocked returns (bool) {
303     return super.transferFrom(_from, _to, _value);
304   }
305 
306   function approve(address _spender, uint256 _value) public tokenNotLocked returns (bool) {
307     return super.approve(_spender, _value);
308   }
309 
310   function increaseApproval(address _spender, uint _addedValue) public tokenNotLocked returns (bool success) {
311     return super.increaseApproval(_spender, _addedValue);
312   }
313 
314   function decreaseApproval(address _spender, uint _subtractedValue) public tokenNotLocked returns (bool success) {
315     return super.decreaseApproval(_spender, _subtractedValue);
316   }
317 
318   function saleTransfer(address _to, uint256 _value) public returns (bool) {
319     require(saleContract != address(0));
320     require(msg.sender == saleContract);
321     return super.transfer(_to, _value);
322   }
323 
324   function sendBounty(address _to, uint256 _value) public onlyOwner returns (bool) {
325     uint256 value = _value.mul(1 ether);
326     require(bountyTokens >= value);
327     totalSupply_ = totalSupply_.add(value);
328     require(totalSupply_ <= totalTokens);
329     balances[_to] = balances[_to].add(value);
330     bountyTokens = bountyTokens.sub(value);
331     Transfer(address(this), _to, value);
332     return true;
333   }
334 
335   function burn(uint256 _value) public onlyOwner returns (bool) {
336     uint256 value = _value.mul(1 ether);
337     require(balances[owner] >= value);
338     require(totalSupply_ >= value);
339     balances[owner] = balances[owner].sub(value);
340     totalSupply_ = totalSupply_.sub(value);
341     Burn(owner, value);
342     return true;
343   }
344 
345   function burnTokensForSale() public returns (bool) {
346     require(saleContract != address(0));
347     require(msg.sender == saleContract);
348     uint256 tokens = balances[saleContract];
349     require(tokens > 0);
350     require(tokens <= totalSupply_);
351     balances[saleContract] =0;
352     totalSupply_ = totalSupply_.sub(tokens);
353     Burn(saleContract, tokens);
354     return true;
355   }
356 
357   function getVestingPeriodNumber() public view returns (uint256) {
358     if (listingDate == 0) return 0;
359     return now.sub(listingDate).div(vestingPeriod);
360   }
361 
362   function releaseAdvisorsTokens() public returns (bool) {
363     uint256 vestingPeriodNumber = getVestingPeriodNumber();
364     uint256 percents = vestingPeriodNumber.mul(50);
365     if (percents > 100) percents = 100;
366     uint256 tokensToRelease = advisorsTokens.mul(percents).div(100).sub(advisorsReleased);
367     require(tokensToRelease > 0);
368     totalSupply_ = totalSupply_.add(tokensToRelease);
369     require(totalSupply_ <= totalTokens);
370     balances[advisors] = balances[advisors].add(tokensToRelease);
371     advisorsReleased = advisorsReleased.add(tokensToRelease);
372     require(advisorsReleased <= advisorsTokens);
373     Transfer(address(this), advisors, tokensToRelease);
374     return true;
375   }
376 
377   function releaseTeamTokens() public returns (bool) {
378     uint256 vestingPeriodNumber = getVestingPeriodNumber();
379     uint256 percents = vestingPeriodNumber.mul(25);
380     if (percents > 100) percents = 100;
381     uint256 tokensToRelease = teamTokens.mul(percents).div(100).sub(teamReleased);
382     require(tokensToRelease > 0);
383     totalSupply_ = totalSupply_.add(tokensToRelease);
384     require(totalSupply_ <= totalTokens);
385     balances[team] = balances[team].add(tokensToRelease);
386     teamReleased = teamReleased.add(tokensToRelease);
387     require(teamReleased <= teamTokens);
388     Transfer(address(this), team, tokensToRelease);
389     return true;
390   }
391 }
392 
393 contract IDAP is ConfigurableToken {
394   string public constant name = "IDAP";
395   string public constant symbol = "IDAP";
396   uint32 public constant decimals = 18;
397 
398   function IDAP(address _newOwner, address _team, address _advisors) public {
399     require(_newOwner != address(0));
400     require(_team != address(0));
401     require(_advisors != address(0));
402     totalSupply_ = employeePoolTokens.add(liquidityPoolTokens); 
403     owner = _newOwner;
404     team = _team;
405     advisors = _advisors;
406     balances[owner] = totalSupply_;
407     Transfer(address(this), owner, totalSupply_);
408   }
409 }