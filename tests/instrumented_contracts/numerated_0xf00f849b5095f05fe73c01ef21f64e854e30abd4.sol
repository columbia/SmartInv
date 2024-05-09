1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address _owner, address _spender)
26     public view returns (uint256);
27 
28   function transferFrom(address _from, address _to, uint256 _value)
29     public returns (bool);
30 
31   function approve(address _spender, uint256 _value) public returns (bool);
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 
40 
41 
42 
43 
44 /**
45  * @title SafeERC20
46  * @dev Wrappers around ERC20 operations that throw on failure.
47  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
48  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
49  */
50 library SafeERC20 {
51   function safeTransfer(
52     ERC20Basic _token,
53     address _to,
54     uint256 _value
55   )
56     internal
57   {
58     require(_token.transfer(_to, _value));
59   }
60 
61   function safeTransferFrom(
62     ERC20 _token,
63     address _from,
64     address _to,
65     uint256 _value
66   )
67     internal
68   {
69     require(_token.transferFrom(_from, _to, _value));
70   }
71 
72   function safeApprove(
73     ERC20 _token,
74     address _spender,
75     uint256 _value
76   )
77     internal
78   {
79     require(_token.approve(_spender, _value));
80   }
81 }
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (_a == 0) {
107       return 0;
108     }
109 
110     c = _a * _b;
111     assert(c / _a == _b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     // assert(_b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = _a / _b;
121     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
122     return _a / _b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
129     assert(_b <= _a);
130     return _a - _b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
137     c = _a + _b;
138     assert(c >= _a);
139     return c;
140   }
141 }
142 
143 
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) internal balances;
153 
154   uint256 internal totalSupply_;
155 
156   /**
157   * @dev Total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev Transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_value <= balances[msg.sender]);
170     require(_to != address(0));
171 
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     emit Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 
190 
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * https://github.com/ethereum/EIPs/issues/20
197  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
198  */
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(
211     address _from,
212     address _to,
213     uint256 _value
214   )
215     public
216     returns (bool)
217   {
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220     require(_to != address(0));
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(
251     address _owner,
252     address _spender
253    )
254     public
255     view
256     returns (uint256)
257   {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(
271     address _spender,
272     uint256 _addedValue
273   )
274     public
275     returns (bool)
276   {
277     allowed[msg.sender][_spender] = (
278       allowed[msg.sender][_spender].add(_addedValue));
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(
293     address _spender,
294     uint256 _subtractedValue
295   )
296     public
297     returns (bool)
298   {
299     uint256 oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue >= oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 
312 
313 
314 contract NeLunaCoin is StandardToken {
315     using SafeERC20 for ERC20;
316     
317     string public name = "NeLunaCoin";
318     string public symbol = "NLC";
319     uint8 public decimals = 18;
320     uint public INITIAL_SUPPLY = 1200000000 * (10 ** uint256(decimals));
321     constructor() public {
322         totalSupply_ = INITIAL_SUPPLY;
323         balances[msg.sender] = INITIAL_SUPPLY;
324         emit Transfer(address(this), msg.sender, INITIAL_SUPPLY);
325     }
326 }