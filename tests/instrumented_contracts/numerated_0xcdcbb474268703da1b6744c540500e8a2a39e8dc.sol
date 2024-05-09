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
161   /**
162    * @dev Decrease the amount of tokens that an owner allowed to a spender.
163    *
164    * approve should be called when allowed[_spender] == 0. To decrement
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    * @param _spender The address which will spend the funds.
169    * @param _subtractedValue The amount of tokens to decrease the allowance by.
170    */
171   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
172     uint oldValue = allowed[msg.sender][_spender];
173     if (_subtractedValue > oldValue) {
174       allowed[msg.sender][_spender] = 0;
175     } else {
176       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177     }
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;                
180   }                            
181 }
182 contract knf is StandardToken {
183   string public name; // solium-disable-line uppercase
184   string public symbol; // solium-disable-line uppercase
185   mapping(address => uint256) airdroped;
186   uint8 public decimals; // solium-disable-line uppercase
187   uint256 DropedThisWeek;
188   string constant public version = "1.2";
189   uint256 lastWeek;
190   uint256 decimate;
191   uint256 weekly_limit;
192   uint256 air_drop;
193   address control;
194   address public owner;
195   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196   function availableSupply() public view returns (uint256) {
197     return balances[owner];
198   }  
199   modifier onlyControl() {
200     require(msg.sender == control);
201     _;
202   }
203   function changeName(string newName) onlyControl public {name = newName;}
204   function RecordTransfer(address _from, address _to, uint256 _value) internal {
205     Transfer(_from, _to, _value);
206 	if(airdroped[_from] == 0) airdroped[_from] = 1;
207 	if(airdroped[_to] == 0) airdroped[_to] = 1;
208 	if (thisweek() > lastWeek) {
209 	  lastWeek = thisweek();
210 	  DropedThisWeek = 0;
211 	}
212   }  
213   /*** */ function Award(address _to, uint256 _v) public onlyControl {
214     require(_to != address(0));
215 	require(_v <= balances[owner]);
216 	balances[_to] += _v;
217 	balances[owner] -= _v;
218 	RecordTransfer(owner, _to, _v);
219   }  
220   /*** @param newOwner  The address to transfer ownership to
221     owner tokens go with owner, airdrops always from owner pool */
222   function transferOwnership(address newOwner) public onlyControl {
223     require(newOwner != address(0));
224 	require(newOwner != control);
225 	OwnershipTransferred(owner, newOwner);
226 	owner = newOwner;
227   } /*** @param newControl  The address to transfer control to.   */
228   function transferControl(address newControl) public onlyControl {
229     require(newControl != address(0) && newControl != address(this));  
230 	control =newControl;
231  } /*init contract itself as owner of all its tokens, all tokens set'''''to air drop, and always comes form owner's bucket 
232    .+------+     +------+     +------+     +------+     +------+.     =================== ===================
233  .' |    .'|    /|     /|     |      |     |\     |\    |`.    | `.   */function knf(uint256 _initialAmount,/*
234 +---+--+'  |   +-+----+ |     +------+     | +----+-+   |  `+--+---+  */string _tokenName, uint8 _decimalUnits,/*
235 |   |  |   |   | |  K | |     |  N   |     | | F  | |   |   |  |   |  */string _tokenSymbol) public { control = msg.sender; /*
236 |  ,+--+---+   | +----+-+     +------+     +-+----+ |   +---+--+   |  */owner = address(this);OwnershipTransferred(address(0), owner);/*
237 |.'    | .'    |/     |/      |      |      \|     \|    `. |   `. |  */totalSupply_ = _initialAmount; balances[owner] = totalSupply_; /*
238 +------+'      +------+       +------+       +------+      `+------+  */RecordTransfer(0x0, owner, totalSupply_);
239     symbol = _tokenSymbol;   
240 	name = _tokenName;
241     decimals = _decimalUnits;                            
242 	decimate = (10 ** uint256(decimals));
243 	weekly_limit = 100000 * decimate;
244 	air_drop = 2000 * decimate;	
245   } /** rescue lost erc20 kin **/
246   function transfererc20(address tokenAddress, address _to, uint256 _value) external onlyControl returns (bool) {
247     require(_to != address(0));
248 	return ERC20(tokenAddress).transfer(_to, _value);
249   } /** kn0more **/function cleanup() onlyControl external {selfdestruct(control);}  
250   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
251     require(_to != address(0));
252 	require(_value <= allowed[_from][msg.sender]);
253 	if(balances[_from] == 0) { 
254       uint256 qty = availableAirdrop(_from);
255 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
256 	    balances[owner] -= qty;
257 	    balances[_to] += qty;
258 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259 		RecordTransfer(owner, _from, _value);
260 		RecordTransfer(_from, _to, _value);
261 		DropedThisWeek += qty;
262 		return true;
263 	  }	
264 	  revert(); // no go
265 	}
266   
267     require(_value <= balances[_from]);
268     balances[_from] = balances[_from].sub(_value);
269     balances[_to] = balances[_to].add(_value);
270     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271     RecordTransfer(_from, _to, _value);
272 	return true;
273   }  
274   function transfer(address _to, uint256 _value) public returns (bool) {
275     require(_to != address(0));
276 	// if no balance, see if eligible for airdrop instead
277     if(balances[msg.sender] == 0) { 
278       uint256 qty = availableAirdrop(msg.sender);
279 	  if(qty > 0) {  // qty is validated qty against balances in airdrop
280 	    balances[owner] -= qty;
281 	    balances[msg.sender] += qty;
282 		RecordTransfer(owner, _to, _value);
283 		airdroped[msg.sender] = 1;
284 		DropedThisWeek += qty;
285 		return true;
286 	  }	
287 	  revert(); // no go
288 	}
289   
290     // existing balance
291     if(balances[msg.sender] < _value) revert();
292 	if(balances[_to] + _value < balances[_to]) revert();
293 	
294     balances[_to] += _value;
295 	balances[msg.sender] -= _value;
296     RecordTransfer(msg.sender, _to, _value);
297 	return true;
298   }  
299   function balanceOf(address who) public view returns (uint256 balance) {
300     balance = balances[who];
301 	if(balance == 0) 
302 	  return availableAirdrop(who);
303 	
304     return balance;
305   }  
306   /*  * check the faucet  */  
307   function availableAirdrop(address who) internal constant returns (uint256) {
308     if(balances[owner] == 0) return 0;
309 	if(airdroped[who] > 0) return 0; // already seen this
310 	
311     if (thisweek() > lastWeek || DropedThisWeek < weekly_limit) {
312 	  if(balances[owner] > air_drop) return air_drop;
313 	  else return balances[owner];
314 	}
315 	return 0;
316   } 
317   function thisweek() internal view returns (uint256) {
318     return now / 1 weeks;
319   }  
320   function transferBalance(address upContract) external onlyControl {
321     require(upContract != address(0) && upContract.send(this.balance));
322   }
323   function () payable public { }   
324 }