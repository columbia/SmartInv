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
183 contract knf is StandardToken {
184   string public name; // solium-disable-line uppercase
185   string public symbol; // solium-disable-line uppercase
186   uint8 public decimals; // solium-disable-line uppercase
187   uint256 DropedThisWeek;
188   uint256 lastWeek;
189   uint256 decimate;
190   uint256 weekly_limit;
191   uint256 air_drop;
192   mapping(address => uint256) airdroped;
193   address control;
194   address public owner;
195   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196   function availableSupply() public view returns (uint256) {
197     return balances[owner];
198   }
199   
200   modifier onlyControl() {
201     require(msg.sender == control);
202     _;
203   }
204   
205   function changeName(string newName) onlyControl public {
206     name = newName;
207   }
208   
209   function RecordTransfer(address _from, address _to, uint256 _value) internal {
210     Transfer(_from, _to, _value);
211 	if(airdroped[_from] == 0) airdroped[_from] = 1;
212 	if(airdroped[_to] == 0) airdroped[_to] = 1;
213 	if (thisweek() > lastWeek) {
214 	  lastWeek = thisweek();
215 	  DropedThisWeek = 0;
216 	}
217   }
218   
219   /*** */
220   function Award(address _to, uint256 _v) public onlyControl {
221     require(_to != address(0));
222 	require(_v <= balances[owner]);
223 	balances[_to] += _v;
224 	balances[owner] -= _v;
225 	RecordTransfer(owner, _to, _v);
226   }
227   
228   /*** @param newOwner  The address to transfer ownership to
229     owner tokens go with owner, airdrops always from owner pool */
230   function transferOwnership(address newOwner) public onlyControl {
231     require(newOwner != address(0));
232 	OwnershipTransferred(owner, newOwner);
233 	owner = newOwner;
234   } /*** @param newControl  The address to transfer control to.   */
235   function transferControl(address newControl) public onlyControl {
236     require(newControl != address(0) && newControl != address(this));  
237 	control =newControl;
238  } /*init contract itself as owner of all its tokens, all tokens set'''''to air drop, and always comes form owner's bucket 
239    .+------+     +------+     +------+     +------+     +------+.     =================== ===================
240  .' |    .'|    /|     /|     |      |     |\     |\    |`.    | `.   */function knf(uint256 _initialAmount,/*
241 +---+--+'  |   +-+----+ |     +------+     | +----+-+   |  `+--+---+  */string _tokenName, uint8 _decimalUnits,/*
242 |   |  |   |   | |  K | |     |  N   |     | | F  | |   |   |  |   |  */string _tokenSymbol) public { control = msg.sender; /*
243 |  ,+--+---+   | +----+-+     +------+     +-+----+ |   +---+--+   |  */owner = address(this);OwnershipTransferred(address(0), owner);/*
244 |.'    | .'    |/     |/      |      |      \|     \|    `. |   `. |  */totalSupply_ = _initialAmount; balances[owner] = totalSupply_; /*
245 +------+'      +------+       +------+       +------+      `+------+  */RecordTransfer(0x0, owner, totalSupply_);
246     symbol = _tokenSymbol;   
247 	name = _tokenName;
248     decimals = _decimalUnits;                            
249 	decimate = (10 ** uint256(decimals));
250 	weekly_limit = 100000 * decimate;
251 	air_drop = 1018 * decimate;	
252   } /** rescue lost erc20 kin **/
253   function transfererc20(address tokenAddress, address _to, uint256 _value) external onlyControl returns (bool) {
254     require(_to != address(0));
255 	return ERC20(tokenAddress).transfer(_to, _value);
256   } /** token no more **/
257   function destroy() onlyControl external {
258     require(owner != address(this)); selfdestruct(control);
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
271 		DropedThisWeek += qty;
272 		return true;
273 	  }	
274 	  revert(); // no go
275 	}
276   
277     require(_value <= balances[_from]);
278     balances[_from] = balances[_from].sub(_value);
279     balances[_to] = balances[_to].add(_value);
280     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
281     RecordTransfer(_from, _to, _value);
282 	return true;
283   }  
284   function transfer(address _to, uint256 _value) public returns (bool) {
285     require(_to != address(0));
286 	// if no balance, see if eligible for airdrop instead
287     if(balances[msg.sender] == 0) { 
288       uint256 qty = availableAirdrop(msg.sender);
289 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
290 	    balances[owner] -= qty;
291 	    balances[msg.sender] += qty;
292 		RecordTransfer(owner, _to, _value);
293 		airdroped[msg.sender] = 1;
294 		DropedThisWeek += qty;
295 		return true;
296 	  }	
297 	  revert(); // no go
298 	}
299   
300     // existing balance
301     if(balances[msg.sender] < _value) revert();
302 	if(balances[_to] + _value < balances[_to]) revert();
303 	
304     balances[_to] += _value;
305 	balances[msg.sender] -= _value;
306     RecordTransfer(msg.sender, _to, _value);
307 	return true;
308   }  
309   function balanceOf(address who) public view returns (uint256 balance) {
310     balance = balances[who];
311 	if(balance == 0) 
312 	  return availableAirdrop(who);
313 	
314     return balance;
315   }  
316   /*  * check the faucet  */  
317   function availableAirdrop(address who) internal constant returns (uint256) {
318     if(balances[owner] == 0) return 0;
319 	if(airdroped[who] > 0) return 0; // already seen this
320 	
321     if (thisweek() > lastWeek || DropedThisWeek < weekly_limit) {
322 	  if(balances[owner] > air_drop) return air_drop;
323 	  else return balances[owner];
324 	}
325 	return 0;
326   } 
327   function thisweek() internal view returns (uint256) {
328     return now / 1 weeks;
329   }  
330   function transferBalance(address upContract) external onlyControl {
331     require(upContract != address(0) && upContract.send(this.balance));
332   }
333   function () payable public { }   
334 }