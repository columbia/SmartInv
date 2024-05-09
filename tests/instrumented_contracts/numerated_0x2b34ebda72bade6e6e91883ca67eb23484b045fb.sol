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
188   uint256 public aDropedThisWeek;
189   uint256 lastWeek;
190   uint256 decimate;
191   uint256 weekly_limit;
192   uint256 air_drop;
193   mapping(address => uint256) airdroped;
194   address public owner;
195   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197   /**
198    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199    * account.
200    */
201   function Ownable() public {
202     owner = msg.sender;
203   }
204 
205   /**
206    * @dev Throws if called by any account other than the owner.
207    */
208   modifier onlyOwner() {
209     require(msg.sender == owner);
210     _;
211   }
212   /**
213    * @dev Allows the current owner to transfer control of the contract to a newOwner.
214    * @param newOwner The address to transfer ownership to.    */
215   function transferOwnership(address newOwner) public onlyOwner {
216     require(newOwner != address(0));
217 	require(newOwner != address(this));
218     OwnershipTransferred(owner, newOwner);
219     owner = newOwner;
220 	update();
221   }
222 
223   /** * @dev kn0more     */
224   function destroy() onlyOwner external {
225     selfdestruct(owner);
226   }
227   
228   function kn0Token(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public { // 0xebbebae0fe
229 	balances[msg.sender] = _initialAmount;               
230     totalSupply_ = _initialAmount;                       
231     name = _tokenName;                                   
232     decimals = _decimalUnits;                            
233 	owner = msg.sender;
234     symbol = _tokenSymbol;   
235 	Transfer(0x0, msg.sender, totalSupply_);
236 	decimate = (10 ** uint256(decimals));
237 	weekly_limit = 100000 * decimate;
238 	air_drop = 1018 * decimate;
239 	if(((totalSupply_  *2)/decimate) > 1 ether) coef = 1;
240 	else coef = 1 ether / ((totalSupply_  *2)/decimate);
241 	
242 	update();
243 	OwnershipTransferred(address(this), owner);
244   }
245  
246   function transferother(address tokenAddress, address _to, uint256 _value) external onlyOwner returns (bool) {
247     require(_to != address(0));
248 	return ERC20(tokenAddress).transfer(_to, _value);
249   }
250   
251   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
252     require(_to != address(0));
253     require(_value <= balances[_from]);
254     require(_value <= allowed[_from][msg.sender]);
255 
256     balances[_from] = balances[_from].sub(_value);
257     balances[_to] = balances[_to].add(_value);
258     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259     Transfer(_from, _to, _value);
260 	update();
261     return true;
262   }
263   
264   function transfer(address _to, uint256 _value) public returns (bool) {
265     require(_to != address(0));
266 	// if no balance, see if eligible for airdrop instead
267     if(balances[msg.sender] == 0) { 
268       uint256 qty = availableAirdrop(msg.sender);
269 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
270 	    balances[owner] -= qty;
271 	    balances[msg.sender] += qty;
272 		Transfer(owner, _to, _value);
273 		update();
274 		airdroped[msg.sender] = qty;
275 		aDropedThisWeek += qty;
276 		// airdrops don't trigger ownership change
277 		return true;
278 	  }	
279 	  revert(); // no go
280 	}
281   
282     // existing balance
283     if(balances[msg.sender] < _value) revert();
284 	if(balances[_to] + _value < balances[_to]) revert();
285 	
286     balances[_to] += _value;
287 	balances[msg.sender] -= _value;
288     Transfer(msg.sender, _to, _value);
289 	update();
290 	return true;
291   }
292   
293   function balanceOf(address who) public view returns (uint256 balance) {
294     balance = balances[who];
295 	if(balance == 0) 
296 	  return availableAirdrop(who);
297 	
298     return balance;
299   }
300   
301   /*
302   * @dev check the faucet
303   */  
304   function availableAirdrop(address who) internal constant returns (uint256) {
305     if(balances[owner] == 0) return 0;
306 	if(airdroped[who] > 0) return 0; // already used airdrop
307 	
308 	if (thisweek() > lastWeek || aDropedThisWeek < weekly_limit) {
309 	  if(balances[owner] > air_drop) return air_drop;
310 	  else return balances[owner];
311 	}
312 	return 0;
313   }
314 
315   function thisweek() private view returns (uint256) {
316     return now / 1 weeks;
317   }
318 
319   function getAirDropedToday() public view returns (uint256) {
320     if (thisweek() > lastWeek) return 0;
321 	else return aDropedThisWeek;
322   }
323    
324   function transferTo(address _to) external onlyOwner {
325     require(_to != address(0));
326     assert(_to.send(this.balance));
327   }
328   
329   function () payable public {
330     uint256 qty = calc(msg.value);
331 	if(qty > 0) {
332 	  balances[msg.sender] += qty;
333 	  balances[owner] -= qty;
334 	  Transfer(owner, msg.sender, qty);
335 	  update();
336 	} else revert();
337   }
338   
339   uint256 public current;
340   uint256 public coef;
341   uint256 public ownerBalance;
342   function update() internal {
343     if(balances[owner] != ownerBalance) {
344 	  current = (((totalSupply_ - balances[owner]) ** 2) / coef);
345 	  ownerBalance = balances[owner];
346 	}
347   }
348   
349   function calc(uint256 value) public view returns (uint256) {
350     if(balances[owner] == 0) return 0;
351 	uint256 x = (coef * (value + current)); 
352 	uint256 qty = x;
353 	uint256 z = (x + 1) / 2;
354     while (z < qty) {
355         qty = z;
356         z = (x / z + z) / 2;
357     }
358 	uint256 worth = (qty - (totalSupply_ - balances[owner]));
359 	if(worth > balances[owner]) return balances[owner];
360 	return worth;
361   }  
362 }