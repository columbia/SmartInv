1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic{
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev Total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev Transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public  returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     balances[msg.sender] = balances[msg.sender].safeSub(_value);
34     balances[_to] = balances[_to].safeAdd(_value);
35     emit Transfer(msg.sender, _to, _value);
36     return true;
37   }
38 
39   /**
40   * @dev Gets the balance of the specified address.
41   * @param _owner The address to query the the balance of.
42   * @return An uint256 representing the amount owned by the passed address.
43   */
44   function balanceOf(address _owner) public view returns (uint256) {
45     return balances[_owner];
46   }
47 
48 }
49 
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender)
52     public view returns (uint256);
53 
54   function transferFrom(address from, address to, uint256 value)
55     public returns (bool);
56 
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(
59     address indexed owner,
60     address indexed spender,
61     uint256 value
62   );
63 }
64 
65 contract ReentrancyGuard {
66 
67   /// @dev counter to allow mutex lock with only one SSTORE operation
68   uint256 private guardCounter = 1;
69 
70   /**
71    * @dev Prevents a contract from calling itself, directly or indirectly.
72    * If you mark a function `nonReentrant`, you should also
73    * mark it `external`. Calling one `nonReentrant` function from
74    * another is not supported. Instead, you can implement a
75    * `private` function doing the actual work, and an `external`
76    * wrapper marked as `nonReentrant`.
77    */
78   modifier nonReentrant() {
79     guardCounter += 1;
80     uint256 localCounter = guardCounter;
81     _;
82     require(localCounter == guardCounter);
83   }
84 
85 }
86 
87 contract BurnableToken is BasicToken,ReentrancyGuard {
88 
89   event Burn(address indexed burner, uint256 value);
90 
91   /**
92    * @dev Burns a specific amount of tokens.
93    * @param _value The amount of token to be burned.
94    */
95   function burn(uint256 _value) public nonReentrant{
96     _burn(msg.sender, _value);
97   }
98 
99   function _burn(address _who, uint256 _value) internal {
100     require(_value <= balances[_who]);
101     // no need to require value <= totalSupply, since that would imply the
102     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
103 
104     balances[_who] = balances[_who].safeSub(_value);
105     totalSupply_ = totalSupply_.safeSub(_value);
106     emit Burn(_who, _value);
107     emit Transfer(_who, address(0), _value);
108   }
109 }
110 
111 library SafeMath {
112   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint c = a * b;
114     assert(a == 0 || c / a == b);
115     return c;
116   }
117 
118   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
119     assert(b > 0);
120     uint c = a / b;
121     assert(a == b * c + a % b);
122     return c;
123   }
124 
125   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint c = a + b;
132     assert(c>=a && c>=b);
133     return c;
134   }
135 
136   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
137     return a >= b ? a : b;
138   }
139 
140   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
141     return a < b ? a : b;
142   }
143 
144   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
145     return a >= b ? a : b;
146   }
147 
148   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
149     return a < b ? a : b;
150   }
151 
152 }
153 
154 contract StandardToken is ERC20, BasicToken, ReentrancyGuard {
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(
166     address _from,
167     address _to,
168     uint256 _value
169   )
170     public nonReentrant
171     returns (bool)
172   {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].safeSub(_value);
178     balances[_to] = balances[_to].safeAdd(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
180     emit Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     emit Approval(msg.sender, _spender, _value);
196     return true;
197   }
198   /**
199    * Change how many tokens given spender is allowed to transfer from message
200    * spender.  In order to prevent double spending of allowance, this method
201    * receives assumed current allowance value as an argument.  If actual
202    * allowance differs from an assumed one, this method just returns false.
203    *
204    * @param _spender address to allow the owner of to transfer tokens from
205    *        message sender
206    * @param _currentValue assumed number of tokens currently allowed to be
207    *        transferred
208    * @param _newValue number of tokens to allow to transfer
209    * @return true if token transfer was successfully approved, false otherwise
210    * 
211    * using secureApprove function instead of using standard approve function to prevent the double spending issue
212    */
213   function secureApprove (address _spender, uint256 _currentValue, uint256 _newValue)
214    public nonReentrant returns (bool success) {
215     if (allowance (msg.sender, _spender) == _currentValue)
216       return approve (_spender, _newValue);
217     else return false;
218   }
219   
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(
227     address _owner,
228     address _spender
229    )
230     public
231     view
232     returns (uint256)
233   {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _addedValue The amount of tokens to increase the allowance by.
245    */
246   function increaseApproval(
247     address _spender,
248     uint256 _addedValue
249   )
250     public nonReentrant
251     returns (bool)
252   {
253     allowed[msg.sender][_spender] = (
254       allowed[msg.sender][_spender].safeAdd(_addedValue));
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(
269     address _spender,
270     uint256 _subtractedValue
271   )
272     public nonReentrant
273     returns (bool)
274   {
275     uint256 oldValue = allowed[msg.sender][_spender];
276     if (_subtractedValue > oldValue) {
277       allowed[msg.sender][_spender] = 0;
278     } else {
279       allowed[msg.sender][_spender] = oldValue.safeSub(_subtractedValue);
280     }
281     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285 }
286 
287 contract StandardBurnableToken is BurnableToken, StandardToken {
288 
289   /**
290    * @dev Burns a specific amount of tokens from the target address and decrements allowance
291    * @param _from address The address which you want to send tokens from
292    * @param _value uint256 The amount of token to be burned
293    */
294   function burnFrom(address _from, uint256 _value) public {
295     require(_value <= allowed[_from][msg.sender]);
296     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
297     // this function needs to emit an event with the updated approval.
298     allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
299     _burn(_from, _value);
300   }
301 }
302 
303 contract BFCoin is StandardBurnableToken {
304 
305     string public constant name = "Betform Coin";
306     string public constant symbol = "BFC";
307     uint8 public constant decimals = 0;
308     uint256 public constant INITIAL_SUPPLY = 240000000;
309     address public crowdsaleAddress;
310     address public owner;
311 
312     //function BFCoin() public {
313     constructor() public {    
314         totalSupply_ = INITIAL_SUPPLY;
315         balances[msg.sender] = INITIAL_SUPPLY;
316         owner=msg.sender;
317     }
318     
319    modifier onlyCrowdsale {
320       require(msg.sender == crowdsaleAddress);
321       _;
322    }
323    modifier onlyOwner {
324       require(msg.sender == owner);
325       _;
326    }
327    
328    function setCrowdsale(address _crowdsaleAddress) public onlyOwner {
329       require(_crowdsaleAddress != address(0));
330       crowdsaleAddress = _crowdsaleAddress;
331    }
332    
333     function tokenTransfer(address _receiver, uint256 _amount) public onlyCrowdsale {
334       require(_receiver != address(0));
335       require(_amount > 0);
336       transferFrom(owner,_receiver, _amount);
337    }
338    
339 }