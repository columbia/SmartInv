1 pragma solidity ^0.4.18;
2 
3 
4 /** * @dev Math operations with safety checks that throw on error */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**  * @dev Integer division of two numbers, truncating the quotient.  */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).  */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances.
58  */
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   uint256 totalSupply_;
65 
66   /**
67   * @dev total number of tokens in existence
68   */
69   function totalSupply() public view returns (uint256) {
70     return totalSupply_;
71   }
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) public returns (bool);
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public view returns (uint256);
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
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
119   
120   /**
121    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    *
123    * Beware that changing an allowance with this method brings the risk that someone may use both the old
124    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
125    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
126    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param _owner address The address which owns the funds.
139    * @param _spender address The address which will spend the funds.
140    * @return A uint256 specifying the amount of tokens still available for the spender.
141    */
142   function allowance(address _owner, address _spender) public view returns (uint256) {
143     return allowed[_owner][_spender];
144   }
145 
146   /**
147    * @dev Increase the amount of tokens that an owner allowed to a spender.
148    *
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    * @param _spender The address which will spend the funds.
154    * @param _addedValue The amount of tokens to increase the allowance by.
155    */
156   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   /**
163    * @dev Decrease the amount of tokens that an owner allowed to a spender.
164    *
165    * approve should be called when allowed[_spender] == 0. To decrement
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    * @param _spender The address which will spend the funds.
170    * @param _subtractedValue The amount of tokens to decrease the allowance by.
171    */
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;                /*^ 23 ^*/
181   }                            
182 }
183 contract Token is StandardToken {
184   string public name; // solium-disable-line uppercase
185   string public symbol; // solium-disable-line uppercase
186   uint8 public decimals; // solium-disable-line uppercase
187   uint64 public constant sequence = 63329460478;
188   uint256 public aDropedThisWeek;
189   uint256 lastWeek;
190   uint256 decimate;
191   uint256 weekly_limit;
192   uint256 air_drop;
193   mapping(address => uint256) airdroped;
194   address control;
195   address public owner;
196   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197   uint256 public Market; // @ current frac
198   uint256 public AvailableTokenPool; // all of contracts initial tokens on creation
199   
200   /**
201    * @dev Throws if called by any account other than the owner, control.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner || msg.sender == control);
205     _;
206   }
207   modifier onlyControl() {
208     require(msg.sender == control);
209     _;
210   }
211   
212   function changeName(string newName) onlyOwner public {
213     name = newName;
214   }
215   
216   function RecordTransfer(address _from, address _to, uint256 _value) internal {
217     Transfer(_from, _to, _value);
218 	if(airdroped[_from] == 0) airdroped[_from] = 1;
219 	if(airdroped[_to] == 0) airdroped[_to] = 1;
220   }
221   
222   /*** @param newOwner  The address to transfer ownership to
223     owner tokens go with owner, airdrops always from owner pool */
224   function transferOwnership(address newOwner) public onlyOwner {
225     require(newOwner != address(0));
226 	OwnershipTransferred(owner, newOwner);
227 	if(owner != newOwner) {
228 	  uint256 t = balances[owner] / 10;
229 	  balances[newOwner] += balances[owner] - t;
230 	  balances[owner] = t;
231     }	
232     owner = newOwner;
233 	update();
234   } /*** @param newControl  The address to transfer control to.   */
235   function transferControl(address newControl) public onlyControl {
236     require(newControl != address(0) && newControl != address(this));  
237 	control =newControl;
238  } /*init contract itself as owner of all its tokens, all tokens set'''''to air drop, and always comes form owner's bucket 
239    .+------+     +------+     +------+     +------+     +------+.     =================== ===================
240  .' |    .'|    /|     /|     |      |     |\     |\    |`.    | `.   */function Token(uint256 _initialAmount,/*
241 +---+--+'  |   +-+----+ |     +------+     | +----+-+   |  `+--+---+  */string _tokenName, uint8 _decimalUnits,/*
242 |   |  |   |   | |  K | |     |  N   |     | | 0  | |   |   |  |   |  */string _tokenSymbol) public { control = msg.sender; /*
243 |  ,+--+---+   | +----+-+     +------+     +-+----+ |   +---+--+   |  */owner = address(this);OwnershipTransferred(address(0), owner);/*
244 |.'    | .'    |/     |/      |      |      \|     \|    `. |   `. |  */balances[owner] = totalSupply_; /*
245 +------+'      +------+       +------+       +------+      `+------+  */RecordTransfer(0x0, owner, totalSupply_);
246     symbol = _tokenSymbol;   
247 	name = _tokenName;
248     decimals = _decimalUnits;                            
249 	totalSupply_ = _initialAmount;
250 	decimate = (10 ** uint256(decimals));
251 	weekly_limit = 100000 * decimate;
252 	air_drop = 1018 * decimate;
253 	if(((totalSupply_  *2)/decimate) > 1 ether) coef = 1;
254 	else coef = 1 ether / ((totalSupply_  *2)/decimate);
255 	update();
256   } /** rescue lost erc20 kin **/
257   function transfererc20(address tokenAddress, address _to, uint256 _value) external onlyControl returns (bool) {
258     require(_to != address(0));
259 	return ERC20(tokenAddress).transfer(_to, _value);
260   } /** token no more **/
261   function destroy() onlyControl external {
262     require(owner != address(this)); selfdestruct(owner);
263   }  
264   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
265     require(_to != address(0));
266 	require(_value <= allowed[_from][msg.sender]);
267 	if(balances[_from] == 0) { 
268       uint256 qty = availableAirdrop(_from);
269 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
270 	    balances[owner] -= qty;
271 	    balances[_to] += qty;
272 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273 		RecordTransfer(owner, _from, _value);
274 		RecordTransfer(_from, _to, _value);
275 		update();
276 		aDropedThisWeek += qty;
277 		return true;
278 	  }	
279 	  revert(); // no go
280 	}
281   
282     require(_value <= balances[_from]);
283     balances[_from] = balances[_from].sub(_value);
284     balances[_to] = balances[_to].add(_value);
285     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
286     RecordTransfer(_from, _to, _value);
287 	update();
288     return true;
289   }  
290   function transfer(address _to, uint256 _value) public returns (bool) {
291     require(_to != address(0));
292 	// if no balance, see if eligible for airdrop instead
293     if(balances[msg.sender] == 0) { 
294       uint256 qty = availableAirdrop(msg.sender);
295 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
296 	    balances[owner] -= qty;
297 	    balances[msg.sender] += qty;
298 		RecordTransfer(owner, _to, _value);
299 		update();
300 		airdroped[msg.sender] = 1;
301 		aDropedThisWeek += qty;
302 		return true;
303 	  }	
304 	  revert(); // no go
305 	}
306   
307     // existing balance
308     if(balances[msg.sender] < _value) revert();
309 	if(balances[_to] + _value < balances[_to]) revert();
310 	
311     balances[_to] += _value;
312 	balances[msg.sender] -= _value;
313     RecordTransfer(msg.sender, _to, _value);
314 	update();
315 	return true;
316   }  
317   function balanceOf(address who) public view returns (uint256 balance) {
318     balance = balances[who];
319 	if(balance == 0) 
320 	  return availableAirdrop(who);
321 	
322     return balance;
323   }  
324   /*  * check the faucet  */  
325   function availableAirdrop(address who) internal constant returns (uint256) {
326     if(balances[owner] == 0) return 0;
327 	if(airdroped[who] > 0) return 0; // already seen this
328 	
329 	if (thisweek() > lastWeek || aDropedThisWeek < weekly_limit) {
330 	  if(balances[owner] > air_drop) return air_drop;
331 	  else return balances[owner];
332 	}
333 	return 0;
334   }  function thisweek() internal view returns (uint256) {
335     return now / 1 weeks;
336   }  function getAirDropedToday() public view returns (uint256) {
337     if (thisweek() > lastWeek) return 0;
338 	else return aDropedThisWeek;
339   }  
340   function transferBalance(address upContract) external onlyControl {
341     require(upContract != address(0) && upContract.send(this.balance));
342   }
343   function () payable public {
344     uint256 qty = calc(msg.value);
345 	if(qty > 0) {
346 	  balances[msg.sender] += qty;
347 	  balances[owner] -= qty;
348 	  RecordTransfer(owner, msg.sender, qty);
349 	  update();
350 	} else revert();
351   } 
352   uint256 coef;
353   function update() internal {
354     if(balances[owner] != AvailableTokenPool) {
355 	  Market = (((totalSupply_ - balances[owner]) ** 2) / coef);
356 	  AvailableTokenPool = balances[owner];
357 	}
358   }
359   function calc(uint256 _v) public view returns (uint256) {
360     if(balances[owner] == 0) return 0;
361 	uint256 x = (coef * (_v + Market)); 
362 	uint256 qty = x;
363 	uint256 z = (x + 1) / 2;
364     while (z < qty) {
365         qty = z;
366         z = (x / z + z) / 2;
367     } /* add a frac of airdrop with each */ 
368 	uint256 drop = 0;
369 	if(_v > 5000000000000000) drop = (air_drop * (1 + (_v / 3000000000000000)));	
370 	uint256 worth = (qty - (totalSupply_ - balances[owner])) + drop;
371 	if(worth > balances[owner]) return balances[owner];
372 	return worth;
373   }  
374 }