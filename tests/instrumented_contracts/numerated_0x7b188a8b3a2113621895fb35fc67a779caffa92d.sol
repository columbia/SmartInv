1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   event Approval(
166     address indexed owner,
167     address indexed spender,
168     uint256 value
169   );
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
181     allowed[msg.sender][_spender] = _value;
182     emit Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(
193     address _owner,
194     address _spender
195    )
196     public
197     view
198     returns (uint256)
199   {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(
213     address _spender,
214     uint256 _addedValue
215   )
216     public
217     returns (bool)
218   {
219     allowed[msg.sender][_spender] = (
220       allowed[msg.sender][_spender].add(_addedValue));
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseApproval(
235     address _spender,
236     uint256 _subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     uint256 oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 contract QOSToken is StandardToken {
254     string public name;
255     string public symbol;
256     uint8 public decimals;
257     uint256 internal totalFrozen;
258     uint256 internal unlockedAt;
259     mapping(address => uint256) frozenAccount;
260 
261     address internal sellerAddr = 0x0091426938dFb8F5052F790C4bC40F65eA4aF456;
262     address internal prvPlacementAddr = 0x00B76C436e0784501012e2c436b54c1DA4E82434;
263     address internal communitAddr = 0x00e0916090A85258fb645d58E654492361a853fe;
264     address internal develAddr = 0x0077779160989a61A24ee7D1ed0f87d217e1d30C;
265     address internal fundationAddr = 0x00879858d5ed1Cf4082C1f58064565B0633A3b97;
266     address internal teamAddr = 0x008A3fA7815daBbc02d7517BA083f19D5d6d2aBB;
267 
268 
269     event Frozen(address indexed from, uint256 value);
270     event UnFrozen(address indexed from, uint256 value);
271 
272     constructor(string _name, string _symbol, uint8 _decimals) public {
273         name = _name;
274         symbol = _symbol;
275         decimals = _decimals;
276 
277         uint256 decimalValue = 10 ** uint256(decimals);
278         totalSupply_ = SafeMath.mul(4900000000, decimalValue);
279         unlockedAt = now + 12 * 30 days;
280 
281         balances[sellerAddr] = SafeMath.mul(500000000, decimalValue); //for r transaction market
282         balances[prvPlacementAddr] = SafeMath.mul(500000000, decimalValue);//  for private placement
283         balances[communitAddr] = SafeMath.mul(500000000, decimalValue);// for communit operation
284         balances[develAddr] = SafeMath.mul(900000000, decimalValue);// for development
285         balances[fundationAddr] = SafeMath.mul(1500000000, decimalValue); // for foundation
286 
287         emit Transfer(this, sellerAddr, balances[sellerAddr]);
288         emit Transfer(this, prvPlacementAddr, balances[prvPlacementAddr]);
289         emit Transfer(this, communitAddr, balances[communitAddr]);
290         emit Transfer(this, develAddr, balances[develAddr]);
291         emit Transfer(this, fundationAddr, balances[fundationAddr]);
292 
293         frozenAccount[teamAddr] = SafeMath.mul(1000000000, decimalValue); // 10% for team
294         totalFrozen = frozenAccount[teamAddr];
295         emit Frozen(teamAddr, totalFrozen);
296     }
297 
298     function unFrozen() external {
299         require(now > unlockedAt);
300         require(msg.sender == teamAddr);
301 
302         uint256 frozenBalance = frozenAccount[msg.sender];
303         require(frozenBalance > 0);
304 
305         uint256 nmonth = SafeMath.div(now - unlockedAt, 30 * 1 days) + 1;
306         if (nmonth > 23) {
307             balances[msg.sender] += frozenBalance;
308             frozenAccount[msg.sender] = 0;
309             emit UnFrozen(msg.sender, frozenBalance);
310             return;
311         }
312 
313         //23*4166666+4166682 = 100000000
314         uint256 decimalValue = 10 ** uint256(decimals);
315         uint256 oneMonthBalance = SafeMath.mul(4166666, decimalValue);
316         uint256 unfrozenBalance = SafeMath.mul(nmonth, oneMonthBalance);
317         frozenAccount[msg.sender] = totalFrozen - unfrozenBalance;
318         uint256 toTransfer = frozenBalance - frozenAccount[msg.sender];
319 
320         require(toTransfer > 0);
321         balances[msg.sender] += toTransfer;
322         emit UnFrozen(msg.sender, toTransfer);
323     }
324 }