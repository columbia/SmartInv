1 pragma solidity ^0.4.25;
2 
3 
4 // Author: Securypto Team | Iceman
5 //
6 // Name: Securypto
7 // Symbol: SCU
8 // Total Supply: 100,000,000
9 // Decimals: 18
10 
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that revert on error
15  */
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, reverts on overflow.
20   */
21   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     if (_a == 0) {
23       return 0;
24     }
25 
26     uint256 c = _a * _b;
27     require(c / _a == _b);
28 
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
34   */
35   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
36     require(_b > 0); 
37     uint256 c = _a / _b;
38 
39     return c;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     require(_b <= _a);
47     uint256 c = _a - _b;
48 
49     return c;
50   }
51 
52   /**
53   * @dev Adds two numbers, reverts on overflow.
54   */
55   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     uint256 c = _a + _b;
57     require(c >= _a);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
64   * reverts when dividing by zero.
65   */
66   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b != 0);
68     return a % b;
69   }
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78 
79   address public owner;
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor() public {
86     owner = msg.sender;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner)public onlyOwner {
102     require(newOwner != address(0));
103     owner = newOwner;
104   }
105 }
106 
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 interface IERC20 {
114   function totalSupply() external view returns (uint256);
115 
116   function balanceOf(address _who) external view returns (uint256);
117 
118   function allowance(address _owner, address _spender)
119     external view returns (uint256);
120 
121   function transfer(address _to, uint256 _value) external returns (bool);
122 
123   function approve(address _spender, uint256 _value)
124     external returns (bool);
125 
126   function transferFrom(address _from, address _to, uint256 _value)
127     external returns (bool);
128 
129   event Transfer(
130     address indexed from,
131     address indexed to,
132     uint256 value
133   );
134 
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 /**
143  * @title AdvanceToken ERC20 token
144  */
145 contract SecuryptoToken is IERC20, Ownable {
146   using SafeMath for uint256;
147 
148   mapping (address => uint256) private balances_;
149 
150   mapping (address => mapping (address => uint256)) private allowed_;
151 
152   mapping (address => bool) private frozenAccount;
153 
154   uint256 private totalSupply_;
155 
156   event FrozenFunds(
157       address target, 
158       bool frozen
159       );
160       
161   string public constant name = "Securypto";
162   string public constant symbol = "SCU";
163   uint256 public constant decimals = 18;
164 
165   uint256 public constant INITIAL_SUPPLY = 100000000 * 10**decimals;
166 
167   /**
168    * @dev Upon deplyment the the total supply will be credited to the owner
169    */
170   constructor() public {
171     totalSupply_ = INITIAL_SUPPLY;
172     
173 
174     balances_[msg.sender] = totalSupply_.mul(10).div(100); //foundation 0xe8d7391fe693013360B1e627fe8B4B65e3B3F306
175     balances_[0x80DBF0C72C682a422D7A2C73890117ab8499d227] = totalSupply_.mul(70).div(100); //crowdsale
176     balances_[0x2e61DF87983C4bE9Fe4CDb583a99DC3a51877EEf] = totalSupply_.mul(5).div(100); //Angels
177     balances_[0x8924E322d42AC7Ba595d38c921F4501D59ee41f3] = totalSupply_.mul(5).div(100); //Airdrop
178     balances_[0xf5a4FC1C72B8411519057E18b62c878A6aC2784c] = totalSupply_.mul(7).div(100); // Dev team
179     balances_[0x3F184ee7a1b5b7a299687EFF581C78A6C67f2b16] = totalSupply_.mul(3).div(100); // ico team
180     
181     emit Transfer(address(0), msg.sender, totalSupply_); //foundation 0xe8d7391fe693013360B1e627fe8B4B65e3B3F306
182     emit Transfer(address(0), 0x80DBF0C72C682a422D7A2C73890117ab8499d227, totalSupply_.mul(70).div(100));
183     emit Transfer(address(0), 0x2e61DF87983C4bE9Fe4CDb583a99DC3a51877EEf, totalSupply_.mul(5).div(100));
184     emit Transfer(address(0), 0x8924E322d42AC7Ba595d38c921F4501D59ee41f3, totalSupply_.mul(5).div(100));
185     emit Transfer(address(0), 0xf5a4FC1C72B8411519057E18b62c878A6aC2784c, totalSupply_.mul(7).div(100));
186     emit Transfer(address(0), 0x3F184ee7a1b5b7a299687EFF581C78A6C67f2b16, totalSupply_.mul(3).div(100));
187 
188   }
189   
190   /**
191   * @dev Total number of tokens in existence
192   */
193   function totalSupply() public view returns (uint256) {
194     return totalSupply_;
195   }
196 
197   /**
198   * @dev Gets the balance of the specified address.
199   * @param _owner The address to query the the balance of.
200   * @return An uint256 representing the amount owned by the passed address.
201   */
202   function balanceOf(address _owner) public view returns (uint256) {
203     return balances_[_owner];
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(
213     address _owner,
214     address _spender
215    )
216     public
217     view
218     returns (uint256)
219   {
220     return allowed_[_owner][_spender];
221   }
222 
223   /**
224   * @dev Transfer token for a specified address
225   * @param _to The address to transfer to.
226   * @param _value The amount to be transferred.
227   */
228   function transfer(address _to, uint256 _value) public returns (bool) {
229     require(!frozenAccount[msg.sender]);
230     require(_value <= balances_[msg.sender]);
231     require(_to != address(0));
232 
233     balances_[msg.sender] = balances_[msg.sender].sub(_value);
234     balances_[_to] = balances_[_to].add(_value);
235     emit Transfer(msg.sender, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed_[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Transfer tokens from one address to another
256    * @param _from address The address which you want to send tokens from
257    * @param _to address The address which you want to transfer to
258    * @param _value uint256 the amount of tokens to be transferred
259    */
260   function transferFrom(
261     address _from,
262     address _to,
263     uint256 _value
264   )
265     public
266     returns (bool)
267   {
268     require(_value <= balances_[_from]);
269     require(_value <= allowed_[_from][msg.sender]);
270     require(_to != address(0));
271     require(!frozenAccount[_from]);
272 
273 
274     balances_[_from] = balances_[_from].sub(_value);
275     balances_[_to] = balances_[_to].add(_value);
276     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
277     emit Transfer(_from, _to, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed_[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseApproval(
291     address _spender,
292     uint256 _addedValue
293   )
294     public
295     returns (bool)
296   {
297     allowed_[msg.sender][_spender] = (
298       allowed_[msg.sender][_spender].add(_addedValue));
299     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed_[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseApproval(
313     address _spender,
314     uint256 _subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     uint256 oldValue = allowed_[msg.sender][_spender];
320     if (_subtractedValue >= oldValue) {
321       allowed_[msg.sender][_spender] = 0;
322     } else {
323       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324     }
325     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
326     return true;
327   }
328   
329      /**
330      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
331      * @param target Address to be frozen
332      * @param freeze either to freeze it or not
333      */
334     function freezeAccount(address target, bool freeze) onlyOwner public {
335         frozenAccount[target] = freeze;
336         emit FrozenFunds(target, freeze);
337     }
338 
339 
340 }