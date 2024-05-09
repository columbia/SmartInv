1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     require(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     require(_b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     require(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     require(c >= _a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 {
75   function totalSupply() public view returns (uint256);
76 
77   function balanceOf(address _who) public view returns (uint256);
78 
79   function allowance(address _owner, address _spender)
80     public view returns (uint256);
81 
82   function transfer(address _to, uint256 _value) public returns (bool);
83 
84   function approve(address _spender, uint256 _value)
85     public returns (bool);
86 
87   function transferFrom(address _from, address _to, uint256 _value)
88     public returns (bool);
89 
90   event Transfer(
91     address indexed from,
92     address indexed to,
93     uint256 value
94   );
95 
96   event Approval(
97     address indexed owner,
98     address indexed spender,
99     uint256 value
100   );
101 }
102 
103 
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * https://github.com/ethereum/EIPs/issues/20
110  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20 {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119   uint256 totalSupply_;
120 
121   /**
122   * @dev Total number of tokens in existence
123   */
124   function totalSupply() public view returns (uint256) {
125     return totalSupply_;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256) {
134     return balances[_owner];
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(
144     address _owner,
145     address _spender
146    )
147     public
148     view
149     returns (uint256)
150   {
151     return allowed[_owner][_spender];
152   }
153 
154   /**
155   * @dev Transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) public returns (bool) {
160     require(_value <= balances[msg.sender]);
161     require(_to != address(0));
162 
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     emit Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param _from address The address which you want to send tokens from
187    * @param _to address The address which you want to transfer to
188    * @param _value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(
191     address _from,
192     address _to,
193     uint256 _value
194   )
195     public
196     returns (bool)
197   {
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200     require(_to != address(0));
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     emit Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(
219     address _spender,
220     uint256 _addedValue
221   )
222     public
223     returns (bool)
224   {
225     allowed[msg.sender][_spender] = (
226       allowed[msg.sender][_spender].add(_addedValue));
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231   /**
232    * @dev Decrease the amount of tokens that an owner allowed to a spender.
233    * approve should be called when allowed[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseApproval(
241     address _spender,
242     uint256 _subtractedValue
243   )
244     public
245     returns (bool)
246   {
247     uint256 oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue >= oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 
260 /**
261  * @title Burnable Token
262  * @dev Token that can be irreversibly burned (destroyed).
263  */
264 contract BurnableToken is StandardToken {
265 
266   event Burn(address indexed burner, uint256 value);
267 
268   /**
269    * @dev Burns a specific amount of tokens.
270    * @param _value The amount of token to be burned.
271    */
272   function burn(uint256 _value) public {
273     _burn(msg.sender, _value);
274   }
275 
276   /**
277    * @dev Burns a specific amount of tokens from the target address and decrements allowance
278    * @param _from address The address which you want to send tokens from
279    * @param _value uint256 The amount of token to be burned
280    */
281   function burnFrom(address _from, uint256 _value) public {
282     require(_value <= allowed[_from][msg.sender]);
283     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
284     // this function needs to emit an event with the updated approval.
285     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
286     _burn(_from, _value);
287   }
288 
289   function _burn(address _who, uint256 _value) internal {
290     require(_value <= balances[_who]);
291     // no need to require value <= totalSupply, since that would imply the
292     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
293 
294     balances[_who] = balances[_who].sub(_value);
295     totalSupply_ = totalSupply_.sub(_value);
296     emit Burn(_who, _value);
297     emit Transfer(_who, address(0), _value);
298   }
299 }
300 
301 
302 
303 contract ECTAToken is BurnableToken {
304     
305     string public constant name = "ECTA Token";
306     string public constant symbol = "ECTA";
307     uint8 public constant decimals = 18;
308     uint256 public constant INITIAL_SUPPLY =  1000000000 * (10 ** uint256(decimals)); // 100 %
309     uint256 public constant ADMIN_ALLOWANCE =  170000000 * (10 ** uint256(decimals));  //17 %
310     uint256 public constant TEAM_VESTING_AMOUNT = 200000000 * (10 ** uint256(decimals)); // 20 %
311     uint256 public constant PLATFORM_GROWTH_VESTING_AMOUNT = 130000000 * (10 ** uint256(decimals)); // 13 %
312     uint256 public constant CROWDSALE_ALLOWANCE= 500000000 * (10 ** uint256(decimals)); // 50 %;
313  
314 
315     address public crowdsaleAddress; // contract with allowance of spending 50% of token supply
316     address public creator; // owner of tokens (except those for vesting), forbidden token transfer
317     address public adminAddress = 0xCF3D36be31838DA6d600B882848566A1aEAE8008;  // address with allowance of spending 17% of token supply
318   
319     constructor () public BurnableToken(){
320         creator = msg.sender;
321         approve(adminAddress, ADMIN_ALLOWANCE);
322         totalSupply_ = INITIAL_SUPPLY;
323         balances[creator] = totalSupply_ - TEAM_VESTING_AMOUNT - PLATFORM_GROWTH_VESTING_AMOUNT;
324     }
325   
326     modifier onlyCreator {
327       require(msg.sender == creator);
328       _;
329     }
330     
331     function setCrowdsaleAndVesting(address _crowdsaleAddress, address _teamVestingContractAddress, address _platformVestingContractAddress) onlyCreator external {
332         require (crowdsaleAddress == address(0));
333         crowdsaleAddress = _crowdsaleAddress;
334         approve(crowdsaleAddress, CROWDSALE_ALLOWANCE); // approve 50% tokens for crowdsale
335         balances[_teamVestingContractAddress] = TEAM_VESTING_AMOUNT; // after crowdsale init, reserved tokens for team & advisors are applied to vesting smart contract 
336         balances[_platformVestingContractAddress] = PLATFORM_GROWTH_VESTING_AMOUNT; // after crowdsale init, reserved tokens for platform growth are applied to vesting smart contract 
337     }
338   
339     function transfer(address _to, uint256 _value) public returns (bool) {
340       require(msg.sender != creator);
341       return super.transfer(_to, _value);
342     }
343    
344     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
345       require(msg.sender != creator);
346       return super.transferFrom(_from, _to, _value);
347     }
348 }