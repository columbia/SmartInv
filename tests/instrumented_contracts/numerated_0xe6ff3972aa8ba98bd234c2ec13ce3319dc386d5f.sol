1 pragma solidity ^0.4.24;
2 
3 //--------------------------------------------------------------------------------------------------------------
4 // 'BitEuro' token Contract
5 //
6 // Deployed to  : 0xe6ff3972aa8ba98bd234c2ec13ce3319dc386d5f
7 // Symbol       : XEURO
8 // Name         : BitEuro
9 // Total supply : 100,000,000.00
10 // Decimals     : 2
11 // 
12 // Copyright (c) cfinex.com
13 // Contract designed by: ThalKod
14 //---------------------------------------------------------------------------------------------------------------
15 
16 /**
17  * @title ERC20Basic
18  * @dev Simpler version of ERC20 interface
19  * See https://github.com/ethereum/EIPs/issues/179
20  */
21 contract ERC20Basic {
22   function totalSupply() public view returns (uint256);
23   function balanceOf(address _who) public view returns (uint256);
24   function transfer(address _to, uint256 _value) public returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, throws on overflow.
38   */
39   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
40     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
41     // benefit is lost if 'b' is also tested.
42     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43     if (_a == 0) {
44       return 0;
45     }
46 
47     c = _a * _b;
48     assert(c / _a == _b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     // assert(_b > 0); // Solidity automatically throws when dividing by 0
57     // uint256 c = _a / _b;
58     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
59     return _a / _b;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     assert(_b <= _a);
67     return _a - _b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
74     c = _a + _b;
75     assert(c >= _a);
76     return c;
77   }
78 }
79 
80 
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) internal balances;
90 
91   uint256 internal totalSupply_;
92 
93   /**
94   * @dev Total number of tokens in existence
95   */
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   /**
101   * @dev Transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_value <= balances[msg.sender]);
107     require(_to != address(0));
108 
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256) {
121     return balances[_owner];
122   }
123 
124 }
125 
126 
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address _owner, address _spender)
134     public view returns (uint256);
135 
136   function transferFrom(address _from, address _to, uint256 _value)
137     public returns (bool);
138 
139   function approve(address _spender, uint256 _value) public returns (bool);
140   event Approval(
141     address indexed owner,
142     address indexed spender,
143     uint256 value
144   );
145 }
146 
147 
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * https://github.com/ethereum/EIPs/issues/20
154  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(
168     address _from,
169     address _to,
170     uint256 _value
171   )
172     public
173     returns (bool)
174   {
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177     require(_to != address(0));
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(
208     address _owner,
209     address _spender
210    )
211     public
212     view
213     returns (uint256)
214   {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(
228     address _spender,
229     uint256 _addedValue
230   )
231     public
232     returns (bool)
233   {
234     allowed[msg.sender][_spender] = (
235       allowed[msg.sender][_spender].add(_addedValue));
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(
250     address _spender,
251     uint256 _subtractedValue
252   )
253     public
254     returns (bool)
255   {
256     uint256 oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue >= oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 
268 /**
269  * @title BitEuro
270  */
271 contract BitEuro is StandardToken{
272 
273     string public name = "BitEuro";
274     string public symbol = "XEURO";
275     uint8 public decimals = 2;
276     uint public INITIAL_SUPPLY = 100000000 * 10**uint(decimals);
277 
278     constructor() public {
279         totalSupply_ = INITIAL_SUPPLY;
280         balances[msg.sender] = INITIAL_SUPPLY;
281     }
282 }