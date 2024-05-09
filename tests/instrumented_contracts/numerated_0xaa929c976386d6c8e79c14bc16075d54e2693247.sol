1 /** * @dev Math operations with safety checks that throw on error */
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**  * @dev Integer division of two numbers, truncating the quotient.  */
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   /**  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).  */
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   /**
31   * @dev Adds two numbers, throws on overflow.
32   */
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 /**
53  * @title Basic token
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   uint256 totalSupply_;
62 
63   /**
64   * @dev total number of tokens in existence
65   */
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool);
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) public view returns (uint256);
83 
84 }
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public view returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
116   
117   /**
118    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    *
120    * Beware that changing an allowance with this method brings the risk that someone may use both the old
121    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
122    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
123    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(address _owner, address _spender) public view returns (uint256) {
140     return allowed[_owner][_spender];
141   }
142 
143   /**
144    * @dev Increase the amount of tokens that an owner allowed to a spender.
145    *
146    * approve should be called when allowed[_spender] == 0. To increment
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * From MonolithDAO Token.sol
150    * @param _spender The address which will spend the funds.
151    * @param _addedValue The amount of tokens to increase the allowance by.
152    */
153   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
154     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
155     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159   /**
160    * @dev Decrease the amount of tokens that an owner allowed to a spender.
161    *
162    * approve should be called when allowed[_spender] == 0. To decrement
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    * @param _spender The address which will spend the funds.
167    * @param _subtractedValue The amount of tokens to decrease the allowance by.
168    */
169   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172       allowed[msg.sender][_spender] = 0;
173     } else {
174       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;                /*^ 23 ^*/
178   }                            
179 }
180 contract Token is StandardToken {
181   string public name; // solium-disable-line uppercase
182   string public symbol; // solium-disable-line uppercase
183   uint8 public decimals; // solium-disable-line uppercase
184   uint64 public constant sequence = 63329460478;
185   uint256 public aDropedThisWeek;
186   uint256 lastWeek;
187   uint256 decimate;
188   uint256 weekly_limit;
189   uint256 air_drop;
190   mapping(address => uint256) airdroped;
191   address control;
192   address public owner;
193   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194   uint256 public Market; // @ current frac
195   uint256 public AvailableTokenPool; // all of contracts initial tokens on creation
196   
197   /**
198    * @dev Throws if called by any account other than the owner, control.
199    */
200   modifier onlyOwner() {
201     require(msg.sender == owner || msg.sender == control);
202     _;
203   }
204   modifier onlyControl() {
205     require(msg.sender == control);
206     _;
207   }
208   
209   function changeName(string newName) onlyOwner public {
210     name = newName;
211   }
212   
213   function RecordTransfer(address _from, address _to, uint256 _value) internal {
214     Transfer(_from, _to, _value);
215 	if(airdroped[_from] == 0) airdroped[_from] = 1;
216 	if(airdroped[_to] == 0) airdroped[_to] = 1;
217   }
218   
219   /*** @param newOwner  The address to transfer ownership to
220     owner tokens go with owner, airdrops always from owner pool */
221   function transferOwnership(address newOwner) public onlyOwner {
222     require(newOwner != address(0));
223 	OwnershipTransferred(owner, newOwner);
224 	if(owner != newOwner) {
225 	  uint256 t = balances[owner] / 10;
226 	  balances[newOwner] += balances[owner] - t;
227 	  balances[owner] = t;
228     }	
229     owner = newOwner;
230 	update();
231   } /*** @param newControl  The address to transfer control to.   */
232   function transferControl(address newControl) public onlyControl {
233     require(newControl != address(0) && newControl != address(this));  
234 	control =newControl;
235  } /*init contract itself as owner of all its tokens, all tokens set'''''to air drop, and always comes form owner's bucket 
236    .+------+     +------+     +------+     +------+     +------+.     =================== ===================
237  .' |    .'|    /|     /|     |      |     |\     |\    |`.    | `.   */function Token(uint256 _initialAmount,/*
238 +---+--+'  |   +-+----+ |     +------+     | +----+-+   |  `+--+---+  */string _tokenName, uint8 _decimalUnits,/*
239 |   |  |   |   | |  K | |     |  N   |     | | 0  | |   |   |  |   |  */string _tokenSymbol) public { control = msg.sender; /*
240 |  ,+--+---+   | +----+-+     +------+     +-+----+ |   +---+--+   |  */owner = address(this);OwnershipTransferred(address(0), owner);/*
241 |.'    | .'    |/     |/      |      |      \|     \|    `. |   `. |  */totalSupply_ = _initialAmount; balances[owner] = totalSupply_; /*
242 +------+'      +------+       +------+       +------+      `+------+  */RecordTransfer(0x0, owner, totalSupply_);
243     symbol = _tokenSymbol;   
244 	name = _tokenName;
245     decimals = _decimalUnits;                            
246 	decimate = (10 ** uint256(decimals));
247 	weekly_limit = 100000 * decimate;
248 	air_drop = 1018 * decimate;
249 	if(((totalSupply_  *2)/decimate) > 1 ether) coef = 1;
250 	else coef = 1 ether / ((totalSupply_  *2)/decimate);
251 	update();
252   } /** rescue lost erc20 kin **/
253   function transfererc20(address tokenAddress, address _to, uint256 _value) external onlyControl returns (bool) {
254     require(_to != address(0));
255 	return ERC20(tokenAddress).transfer(_to, _value);
256   } /** token no more **/
257   function destroy() onlyControl external {
258     require(owner != address(this)); selfdestruct(owner);
259   }  
260   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
261     require(_to != address(0));
262 	require(_value <= allowed[_from][msg.sender]);
263 	if(balances[_from] == 0) { 
264       uint256 qty = availableAirdrop(_from);
265 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
266 	    balances[owner] -= qty;
267 	    balances[_to] += qty;
268 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269 		RecordTransfer(owner, _from, _value);
270 		RecordTransfer(_from, _to, _value);
271 		update();
272 		aDropedThisWeek += qty;
273 		return true;
274 	  }	
275 	  revert(); // no go
276 	}
277   
278     require(_value <= balances[_from]);
279     balances[_from] = balances[_from].sub(_value);
280     balances[_to] = balances[_to].add(_value);
281     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
282     RecordTransfer(_from, _to, _value);
283 	update();
284     return true;
285   }  
286   function transfer(address _to, uint256 _value) public returns (bool) {
287     require(_to != address(0));
288 	// if no balance, see if eligible for airdrop instead
289     if(balances[msg.sender] == 0) { 
290       uint256 qty = availableAirdrop(msg.sender);
291 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
292 	    balances[owner] -= qty;
293 	    balances[msg.sender] += qty;
294 		RecordTransfer(owner, _to, _value);
295 		update();
296 		airdroped[msg.sender] = 1;
297 		aDropedThisWeek += qty;
298 		return true;
299 	  }	
300 	  revert(); // no go
301 	}
302   
303     // existing balance
304     if(balances[msg.sender] < _value) revert();
305 	if(balances[_to] + _value < balances[_to]) revert();
306 	
307     balances[_to] += _value;
308 	balances[msg.sender] -= _value;
309     RecordTransfer(msg.sender, _to, _value);
310 	update();
311 	return true;
312   }  
313   function balanceOf(address who) public view returns (uint256 balance) {
314     balance = balances[who];
315 	if(balance == 0) 
316 	  return availableAirdrop(who);
317 	
318     return balance;
319   }  
320   /*  * check the faucet  */  
321   function availableAirdrop(address who) internal constant returns (uint256) {
322     if(balances[owner] == 0) return 0;
323 	if(airdroped[who] > 0) return 0; // already seen this
324 	
325 	if (thisweek() > lastWeek || aDropedThisWeek < weekly_limit) {
326 	  if(balances[owner] > air_drop) return air_drop;
327 	  else return balances[owner];
328 	}
329 	return 0;
330   }  function thisweek() internal view returns (uint256) {
331     return now / 1 weeks;
332   }  function getAirDropedToday() public view returns (uint256) {
333     if (thisweek() > lastWeek) return 0;
334 	else return aDropedThisWeek;
335   }  
336   function transferBalance(address upContract) external onlyControl {
337     require(upContract != address(0) && upContract.send(this.balance));
338   }
339   function () payable public {
340     uint256 qty = calc(msg.value);
341 	if(qty > 0) {
342 	  balances[msg.sender] += qty;
343 	  balances[owner] -= qty;
344 	  RecordTransfer(owner, msg.sender, qty);
345 	  update();
346 	} else revert();
347   } 
348   uint256 coef;
349   function update() internal {
350     if(balances[owner] != AvailableTokenPool) {
351 	  Market = (((totalSupply_ - balances[owner]) ** 2) / coef);
352 	  AvailableTokenPool = balances[owner];
353 	}
354   }
355   function calc(uint256 _v) public view returns (uint256) {
356     if(balances[owner] == 0) return 0;
357 	uint256 x = (coef * (_v + Market)); 
358 	uint256 qty = x;
359 	uint256 z = (x + 1) / 2;
360     while (z < qty) {
361         qty = z;
362         z = (x / z + z) / 2;
363     } /* add a frac of airdrop with each */ 
364 	uint256 drop = 0;
365 	if(_v > 5000000000000000) drop = (air_drop * (1 + (_v / 3000000000000000)));	
366 	uint256 worth = (qty - (totalSupply_ - balances[owner])) + drop;
367 	if(worth > balances[owner]) return balances[owner];
368 	return worth;
369   }  
370 }