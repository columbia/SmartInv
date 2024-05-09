1 pragma solidity ^0.4.13;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public view returns (uint256) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
213     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 contract APRInflationToken is StandardToken, Ownable {
242   // Constants used in calculations
243   uint256 constant RATE_DECIMALS = 7;
244   uint256 constant HORIZON = 365 * 10;
245   uint256 constant ONE_DAY = 86400;
246   uint256 constant DAY_SCALE = 365 * 10 ** RATE_DECIMALS;
247   uint256 constant START_RATE = 10 * 10 ** (RATE_DECIMALS - 2);
248   uint256 constant END_RATE = 1 * 10 ** (RATE_DECIMALS - 2);
249   uint256 constant ADJ_RATE = (START_RATE - END_RATE) / HORIZON;
250 
251   // Date control variables
252   uint256 public startDate;
253   uint256 public lastAdjust;
254 
255   // events --------------------------------------------------------------------
256 
257   event APRMintAdjusted(uint256 _newSupply, uint256 _extraSupply, uint256 _daysPassed, uint256 _rate);
258 
259   // constructor function ------------------------------------------------------
260 
261   /**
262    * @dev Adjusts all the necessary calculations in constructor
263    */
264   function APRInflationToken(uint _startDate) public {
265     startDate = _startDate;
266     lastAdjust = 0;
267   }
268 
269   // external functions --------------------------------------------------------
270 
271   /**
272    * @dev allows anyone to adjust the year mint by calling aprMintAdjustment
273    * which will calculate days since the latest adjustment and run all calculation
274    * according N days skipped N days calculated
275    * @return true
276    */
277   function aprMintAdjustment() public returns (bool) {
278     uint256 extraSupply;
279     uint256 day;
280 
281     for (day = lastAdjust + 1; day <= _currentDay(); day++) {
282       uint256 rate = _rateFromDay(day);
283       extraSupply = totalSupply_.mul(rate).div(DAY_SCALE);
284       totalSupply_ = totalSupply_.add(extraSupply);
285       balances[owner] = balances[owner].add(extraSupply);
286       // Adjusts the day of the latest calculation
287       lastAdjust = day;
288       APRMintAdjusted(totalSupply_, extraSupply, lastAdjust, rate);
289     }
290 
291     return true;
292   }
293 
294   function _safeSub(uint256 a, uint256 b) internal pure returns(uint256) {
295     return b > a ? 0 : a.sub(b);
296   }
297 
298   // internal functions --------------------------------------------------------
299   function _rateFromDay(uint256 day) internal pure returns(uint256) {
300     if (day < 1) {
301       return 0;
302     }
303 
304     uint256 rate = _safeSub(START_RATE, (day.sub(1)).mul(ADJ_RATE));
305     return END_RATE > rate ? END_RATE : rate;
306   }
307 
308   // Returns the amount of days since the start date
309   // The calculations are made using the timestamp in seconds
310   function _currentDay() internal view returns(uint256) {
311     return now.sub(startDate).div(ONE_DAY);
312   }
313 }
314 
315 contract DelegateCallToken is APRInflationToken {
316   string public name    = 'DelegateCallToken';
317   string public symbol  = 'DCT';
318   uint8 public decimals = 18;
319 
320   // one billion
321   uint256 public constant INITIAL_SUPPLY = 1000000000;
322 
323   function DelegateCallToken(uint256 _startDate) public
324     APRInflationToken(_startDate)
325   {
326     owner = msg.sender;
327     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
328     balances[owner] = totalSupply_;
329   }
330 }