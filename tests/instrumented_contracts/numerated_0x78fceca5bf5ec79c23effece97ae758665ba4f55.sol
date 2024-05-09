1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 /**
99  * @title Standard ERC20 token
100  *
101  * @dev Implementation of the basic standard token.
102  * @dev https://github.com/ethereum/EIPs/issues/20
103  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  */
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) internal allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amount of tokens to be transferred
115    */
116   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[_from]);
119     require(_value <= allowed[_from][msg.sender]);
120 
121     balances[_from] = balances[_from].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124     emit Transfer(_from, _to, _value);
125     return true;
126   }
127 
128   /**
129    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130    *
131    * Beware that changing an allowance with this method brings the risk that someone may use both the old
132    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135    * @param _spender The address which will spend the funds.
136    * @param _value The amount of tokens to be spent.
137    */
138   function approve(address _spender, uint256 _value) public returns (bool) {
139     allowed[msg.sender][_spender] = _value;
140     emit Approval(msg.sender, _spender, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param _owner address The address which owns the funds.
147    * @param _spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(address _owner, address _spender) public view returns (uint256) {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155    * @dev Increase the amount of tokens that an owner allowed to a spender.
156    *
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    * @param _spender The address which will spend the funds.
162    * @param _addedValue The amount of tokens to increase the allowance by.
163    */
164   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
165     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
166     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   /**
171    * @dev Decrease the amount of tokens that an owner allowed to a spender.
172    *
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 /**
194  * @title Ownable
195  * @dev The Ownable contract has an owner address, and provides basic authorization control
196  * functions, this simplifies the implementation of "user permissions".
197  */
198 contract Ownable {
199   address public owner;
200 
201   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203   /**
204    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
205    * account.
206    */
207   function Ownable() public {
208     owner = msg.sender;
209   }
210 
211   /**
212    * @dev Throws if called by any account other than the owner.
213    */
214   modifier onlyOwner() {
215     require(msg.sender == owner);
216     _;
217   }
218 
219   /**
220    * @dev Allows the current owner to transfer control of the contract to a newOwner.
221    * @param newOwner The address to transfer ownership to.
222    */
223   function transferOwnership(address newOwner) public onlyOwner {
224     require(newOwner != address(0));
225     emit OwnershipTransferred(owner, newOwner);
226     owner = newOwner;
227   }
228 
229 }
230 
231 contract Pausable is Ownable {
232   event Pause();
233   event Unpause();
234 
235   bool public paused = false;
236 
237   /**
238    * @dev Modifier to make a function callable only when the contract is not paused.
239    */
240   modifier whenNotPaused() {
241     require(!paused);
242     _;
243   }
244 
245   /**
246    * @dev Modifier to make a function callable only when the contract is paused.
247    */
248   modifier whenPaused() {
249     require(paused);
250     _;
251   }
252 
253   /**
254    * @dev called by the owner to pause, triggers stopped state
255    */
256   function pause() onlyOwner whenNotPaused public {
257     paused = true;
258     emit Pause();
259   }
260 
261   /**
262    * @dev called by the owner to unpause, returns to normal state
263    */
264   function unpause() onlyOwner whenPaused public {
265     paused = false;
266     emit Unpause();
267   }
268 
269 }
270 
271 contract PausableToken is StandardToken, Pausable {
272 
273   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
274     return super.transfer(_to, _value);
275   }
276 
277   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
278     return super.transferFrom(_from, _to, _value);
279   }
280 
281   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
282     return super.approve(_spender, _value);
283   }
284 
285   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
286     return super.increaseApproval(_spender, _addedValue);
287   }
288 
289   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
290     return super.decreaseApproval(_spender, _subtractedValue);
291   }
292 
293 }
294 
295 /**
296  * @title YouDeal Token
297  * @dev YDChain.
298  */
299 contract YouDealToken is PausableToken {
300 
301   string public constant name = "YouDeal Token";
302   string public constant symbol = "YD";
303   uint8 public constant decimals = 18;
304 
305   uint256 private constant TOKEN_UNIT = 10 ** uint256(decimals);
306   uint256 private constant INITIAL_SUPPLY = 10500000000 * TOKEN_UNIT;
307 
308   uint256 private constant PRIVATE_SALE_SUPPLY = INITIAL_SUPPLY * 25 / 100;  // 25% for private sale
309   uint256 private constant COMMUNITY_REWARDS_SUPPLY = INITIAL_SUPPLY * 40 / 100;  // 40% for community rewards
310   uint256 private constant FOUNDATION_SUPPLY = INITIAL_SUPPLY * 20 / 100;  // 20% for foundation
311   uint256 private constant TEAM_SUPPLY = INITIAL_SUPPLY * 15 / 100;  // 15% for founder team
312 
313   struct VestingGrant {
314         address beneficiary;
315         uint256 start;
316         uint256 duration; //duration for each release
317         uint256 amount; //total grant amount
318         uint256 transfered; // transfered amount
319         uint8 releaseCount; // schedule release count
320   }
321 
322   address private constant PRIVAYE_SALE_ADDRESS = 0x65158a7270b58fd9499bE7E95feFBF2169360728; //team vesting  beneficiary address
323   address private constant COMMUNITY_REWARDS_ADDRESS = 0xDFE95879606F520CaC6a3546FE2f0d8BBC10A32b; //community rewards wallet address
324   address private constant FOUNDATION_ADDRESS = 0xC138e8A6763e78fA0fFAD6c392D01e37CF3fdf27; //foundation wallet address
325 
326   VestingGrant teamVestingGrant;
327 
328   /**
329    * @dev Constructor that gives msg.sender all of existing tokens.
330    */
331   function YouDealToken() public {
332     totalSupply =  INITIAL_SUPPLY;
333 
334     balances[PRIVAYE_SALE_ADDRESS] = PRIVATE_SALE_SUPPLY;
335     balances[COMMUNITY_REWARDS_ADDRESS] = COMMUNITY_REWARDS_SUPPLY;
336     balances[FOUNDATION_ADDRESS] = FOUNDATION_SUPPLY;
337 
338     teamVestingGrant = founderGrant(msg.sender, now.add(150 days), (30 days), TEAM_SUPPLY, 30); // The owner address is reserved for the Team Wallet
339   }
340 
341   function founderGrant(address _beneficiary, uint256 _start, uint256 _duration, uint256 _amount, uint8 _releaseCount)
342     internal pure returns  (VestingGrant) {
343       return VestingGrant({ beneficiary : _beneficiary, start: _start, duration:_duration, amount:_amount, transfered:0, releaseCount:_releaseCount});
344   }
345 
346   function releaseTeamVested() public onlyOwner {
347       relaseVestingGrant(teamVestingGrant);
348   }
349 
350   function releasableAmount(uint256 time, VestingGrant grant) internal pure returns (uint256) {
351       if (grant.amount == grant.transfered) {
352           return 0;
353       }
354 	  if (time < grant.start) {
355           return 0;
356       }
357       uint256 amountPerRelease = grant.amount.div(grant.releaseCount);
358       uint256 amount = amountPerRelease.mul((time.sub(grant.start)).div(grant.duration));
359       if (amount > grant.amount) {
360         amount = grant.amount;
361       }
362       amount = amount.sub(grant.transfered);
363       return amount;
364   }
365 
366   function relaseVestingGrant(VestingGrant storage grant) internal {
367       uint256 amount = releasableAmount(now, grant);
368       require(amount > 0);
369 
370       grant.transfered = grant.transfered.add(amount);
371       balances[grant.beneficiary] = balances[grant.beneficiary].add(amount);
372       emit Transfer(address(0), grant.beneficiary, amount);
373   }
374 
375 }