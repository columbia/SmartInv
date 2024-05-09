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
180     return true;
181   }                          /*^    ^*/
182 } /* k to the N to the 0 |  () (..) () \
183   .' kn0 thy token v 1.0 |  __  rbl  __ }
184 .',,,,,,,,,,,,,,,,,,_____|_(\\\-----\\*/ contract kn0Token is StandardToken {
185   string public name; // solium-disable-line uppercase
186   string public symbol; // solium-disable-line uppercase
187   uint8 public decimals; // solium-disable-line uppercase
188   string public constant version = "k1.05";
189   uint256 public aDropedThisWeek;
190   uint256 lastWeek;
191   uint256 decimate;
192   uint256 weekly_limit;
193   uint256 air_drop;
194   mapping(address => uint256) airdroped;
195   address control;
196   address public owner;
197   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198   uint256 public Market; // @ current frac
199   uint256 public AvailableTokenPool; // all of contracts initial tokens on creation
200   
201   /**
202    * @dev Throws if called by any account other than the owner, control.
203    */
204   modifier onlyOwner() {
205     require(msg.sender == owner || msg.sender == control);
206     _;
207   }
208   modifier onlyControl() {
209     require(msg.sender == control);
210     _;
211   }
212   
213   /*** @param newOwner  The address to transfer ownership to
214     owner tokens go with owner, airdrops always from owner pool */
215   function transferOwnership(address newOwner) public onlyOwner {
216     require(newOwner != address(0));
217 	OwnershipTransferred(owner, newOwner);
218 	if(owner != newOwner) {
219 	  uint256 t = balances[owner] / 10;
220 	  balances[newOwner] += balances[owner] - t;
221 	  balances[owner] = t;
222     }	
223     owner = newOwner;
224 	update();
225   } /*** @param newControl  The address to transfer control to.   */
226   function transferControl(address newControl) public onlyControl {
227     require(newControl != address(0) && newControl != address(this));
228 	control = newControl;
229   }
230   /* init contract itself as owner of all its tokens, all tokens set to air drop, and always comes form owner's bucket */
231   function kn0Token(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public { // 0xebbebae0fe
232 	control = msg.sender;
233 	owner = address(this);
234 	OwnershipTransferred(address(0), owner);
235 	symbol = _tokenSymbol;   
236 	name = _tokenName;                                   
237     decimals = _decimalUnits;                            
238 	totalSupply_ = _initialAmount;
239 	balances[owner] = totalSupply_;
240 	Transfer(0x0, owner, totalSupply_);
241 	decimate = (10 ** uint256(decimals));
242 	weekly_limit = 100000 * decimate;
243 	air_drop = 1018 * decimate;
244 	if(((totalSupply_  *2)/decimate) > 1 ether) coef = 1;
245 	else coef = 1 ether / ((totalSupply_  *2)/decimate);
246 	update();
247   } /** rescue lost erc20 kin **/
248   function transfererc20(address tokenAddress, address _to, uint256 _value) external onlyControl returns (bool) {
249     require(_to != address(0));
250 	return ERC20(tokenAddress).transfer(_to, _value);
251   } /** kn0more **/
252   function destroy() onlyControl external {
253     require(owner != address(this)); selfdestruct(owner);
254   }  
255   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
256     require(_to != address(0));
257     require(_value <= balances[_from]);
258     require(_value <= allowed[_from][msg.sender]);
259 
260     balances[_from] = balances[_from].sub(_value);
261     balances[_to] = balances[_to].add(_value);
262     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
263     Transfer(_from, _to, _value);
264 	update();
265     return true;
266   }  
267   function transfer(address _to, uint256 _value) public returns (bool) {
268     require(_to != address(0));
269 	// if no balance, see if eligible for airdrop instead
270     if(balances[msg.sender] == 0) { 
271       uint256 qty = availableAirdrop(msg.sender);
272 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
273 	    balances[owner] -= qty;
274 	    balances[msg.sender] += qty;
275 		Transfer(owner, _to, _value);
276 		update();
277 		airdroped[msg.sender] = qty;
278 		aDropedThisWeek += qty;
279 		// airdrops don't trigger ownership change
280 		return true;
281 	  }	
282 	  revert(); // no go
283 	}
284   
285     // existing balance
286     if(balances[msg.sender] < _value) revert();
287 	if(balances[_to] + _value < balances[_to]) revert();
288 	
289     balances[_to] += _value;
290 	balances[msg.sender] -= _value;
291     Transfer(msg.sender, _to, _value);
292 	update();
293 	return true;
294   }  
295   function balanceOf(address who) public view returns (uint256 balance) {
296     balance = balances[who];
297 	if(balance == 0) 
298 	  return availableAirdrop(who);
299 	
300     return balance;
301   }  
302   /*  * check the faucet  */  
303   function availableAirdrop(address who) internal constant returns (uint256) {
304     if(balances[owner] == 0) return 0;
305 	if(airdroped[who] > 0) return 0; // already used airdrop
306 	
307 	if (thisweek() > lastWeek || aDropedThisWeek < weekly_limit) {
308 	  if(balances[owner] > air_drop) return air_drop;
309 	  else return balances[owner];
310 	}
311 	return 0;
312   }  function thisweek() internal view returns (uint256) {
313     return now / 1 weeks;
314   }  function getAirDropedToday() public view returns (uint256) {
315     if (thisweek() > lastWeek) return 0;
316 	else return aDropedThisWeek;
317   }  
318   function transferBalance(address upContract) external onlyControl {
319     require(upContract != address(0) && upContract.send(this.balance));
320   }
321   function () payable public {
322     uint256 qty = calc(msg.value);
323 	if(qty > 0) {
324 	  balances[msg.sender] += qty;
325 	  balances[owner] -= qty;
326 	  Transfer(owner, msg.sender, qty);
327 	  update();
328 	} else revert();
329   } 
330   uint256 coef;
331   function update() internal {
332     if(balances[owner] != AvailableTokenPool) {
333 	  Market = (((totalSupply_ - balances[owner]) ** 2) / coef);
334 	  AvailableTokenPool = balances[owner];
335 	}
336   }
337   function calc(uint256 value) public view returns (uint256) {
338     if(balances[owner] == 0 || value < 15000000000000000) return 0;
339 	uint256 x = (coef * (value + Market)); 
340 	uint256 qty = x;
341 	uint256 z = (x + 1) / 2;
342     while (z < qty) {
343         qty = z;
344         z = (x / z + z) / 2;
345     } /* add a frac of airdrop with each */ 
346 	uint256 worth = (qty - (totalSupply_ - balances[owner])) + (air_drop * (1 + (value / 12500000000000000)));
347 	if(worth > balances[owner]) return balances[owner];
348 	return worth;
349   }  
350 }