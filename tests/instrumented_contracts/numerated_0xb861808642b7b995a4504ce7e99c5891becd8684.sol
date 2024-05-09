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
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
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
60   function balanceOf(address _who) public view returns (uint256);
61   function transfer(address _to, uint256 _value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address _owner, address _spender)
71     public view returns (uint256);
72 
73   function transferFrom(address _from, address _to, uint256 _value)
74     public returns (bool);
75 
76   function approve(address _spender, uint256 _value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 // import "./BasicToken.sol";
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) internal balances;
93 
94   uint256 internal totalSupply_;
95 
96   /**
97   * @dev Total number of tokens in existence
98   */
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   /**
104   * @dev Transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_value <= balances[msg.sender]);
110     require(_to != address(0));
111 
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     emit Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * https://github.com/ethereum/EIPs/issues/20
134  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(
148     address _from,
149     address _to,
150     uint256 _value
151   )
152     public
153     returns (bool)
154   {
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157     require(_to != address(0));
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    * approve should be called when allowed[_spender] == 0. To increment
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _addedValue The amount of tokens to increase the allowance by.
206    */
207   function increaseApproval(
208     address _spender,
209     uint256 _addedValue
210   )
211     public
212     returns (bool)
213   {
214     allowed[msg.sender][_spender] = (
215       allowed[msg.sender][_spender].add(_addedValue));
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(
230     address _spender,
231     uint256 _subtractedValue
232   )
233     public
234     returns (bool)
235   {
236     uint256 oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue >= oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 /**
249  * @title Burnable Token
250  * @dev Token that can be irreversibly burned (destroyed).
251  */
252 contract BurnableToken is BasicToken {
253 
254   event Burn(address indexed burner, uint256 value);
255 
256   /**
257    * @dev Burns a specific amount of tokens.
258    * @param _value The amount of token to be burned.
259    */
260   function burn(uint256 _value) public {
261     _burn(msg.sender, _value);
262   }
263 
264   function _burn(address _who, uint256 _value) internal {
265     require(_value <= balances[_who]);
266     // no need to require value <= totalSupply, since that would imply the
267     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
268 
269     balances[_who] = balances[_who].sub(_value);
270     totalSupply_ = totalSupply_.sub(_value);
271     emit Burn(_who, _value);
272     emit Transfer(_who, address(0), _value);
273   }
274 }
275 
276 /**
277  * @title Standard Burnable Token
278  * @dev Adds burnFrom method to ERC20 implementations
279  */
280 contract StandardBurnableToken is BurnableToken, StandardToken {
281 
282   /**
283    * @dev Burns a specific amount of tokens from the target address and decrements allowance
284    * @param _from address The address which you want to send tokens from
285    * @param _value uint256 The amount of token to be burned
286    */
287   function burnFrom(address _from, uint256 _value) public {
288     require(_value <= allowed[_from][msg.sender]);
289     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
290     // this function needs to emit an event with the updated approval.
291     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
292     _burn(_from, _value);
293   }
294 }
295 
296 
297 contract CC is StandardBurnableToken{
298   string public name = "CopyFun";
299   string public symbol = "CC";
300   uint8 public decimals = 18;
301   uint public INITIAL_SUPPLY = 10000000000;
302 
303   constructor(address holder) public{
304     totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
305     balances[holder] = totalSupply_;
306   }
307 
308 }