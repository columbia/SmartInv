1 pragma solidity ^0.4.24;
2 
3 library Math {
4   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
5     return _a >= _b ? _a : _b;
6   }
7 
8   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
9     return _a < _b ? _a : _b;
10   }
11 
12   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     return _a >= _b ? _a : _b;
14   }
15 
16   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     return _a < _b ? _a : _b;
18   }
19 }
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30     if (_a == 0) {
31       return 0;
32     }
33 
34     c = _a * _b;
35     assert(c / _a == _b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     // assert(_b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = _a / _b;
45     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
46     return _a / _b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     assert(_b <= _a);
54     return _a - _b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
61     c = _a + _b;
62     assert(c >= _a);
63     return c;
64   }
65 }
66 
67 contract ERC20Basic {
68   function totalSupply() public view returns (uint256);
69   function balanceOf(address _who) public view returns (uint256);
70   function transfer(address _to, uint256 _value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) internal balances;
78 
79   uint256 internal totalSupply_;
80 
81   /**
82   * @dev Total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev Transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_value <= balances[msg.sender]);
95     require(_to != address(0));
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 contract ERC20 is ERC20Basic {
115   function allowance(address _owner, address _spender)
116     public view returns (uint256);
117 
118   function transferFrom(address _from, address _to, uint256 _value)
119     public returns (bool);
120 
121   function approve(address _spender, uint256 _value) public returns (bool);
122   event Approval(
123     address indexed owner,
124     address indexed spender,
125     uint256 value
126   );
127 }
128 
129 library SafeERC20 {
130   function safeTransfer(
131     ERC20Basic _token,
132     address _to,
133     uint256 _value
134   )
135     internal
136   {
137     require(_token.transfer(_to, _value));
138   }
139 
140   function safeTransferFrom(
141     ERC20 _token,
142     address _from,
143     address _to,
144     uint256 _value
145   )
146     internal
147   {
148     require(_token.transferFrom(_from, _to, _value));
149   }
150 
151   function safeApprove(
152     ERC20 _token,
153     address _spender,
154     uint256 _value
155   )
156     internal
157   {
158     require(_token.approve(_spender, _value));
159   }
160 }
161 
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(
174     address _from,
175     address _to,
176     uint256 _value
177   )
178     public
179     returns (bool)
180   {
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183     require(_to != address(0));
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     emit Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(
214     address _owner,
215     address _spender
216    )
217     public
218     view
219     returns (uint256)
220   {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(
234     address _spender,
235     uint256 _addedValue
236   )
237     public
238     returns (bool)
239   {
240     allowed[msg.sender][_spender] = (
241       allowed[msg.sender][_spender].add(_addedValue));
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    * approve should be called when allowed[_spender] == 0. To decrement
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _subtractedValue The amount of tokens to decrease the allowance by.
254    */
255   function decreaseApproval(
256     address _spender,
257     uint256 _subtractedValue
258   )
259     public
260     returns (bool)
261   {
262     uint256 oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue >= oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 contract PlusToken is StandardToken {
275   string public constant name = "PayPlus Token";
276   string public constant symbol = "PLUS";
277   uint8 public constant decimals = 18;                      //         0123456789012345678
278   uint256 public INITIAL_SUPPLY = uint256(uint256(500000000) * uint256(1000000000000000000));
279 
280   constructor() public
281   {
282     totalSupply_ = INITIAL_SUPPLY;
283     balances[msg.sender] = INITIAL_SUPPLY;
284     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
285   }
286 }