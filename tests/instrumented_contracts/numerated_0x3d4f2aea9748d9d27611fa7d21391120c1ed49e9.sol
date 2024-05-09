1 pragma solidity ^0.4.24;
2 
3 // Using OpenZeppelin v1.12.0
4 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
30     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (_a == 0) {
34       return 0;
35     }
36 
37     c = _a * _b;
38     assert(c / _a == _b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // assert(_b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = _a / _b;
48     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
49     return _a / _b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     assert(_b <= _a);
57     return _a - _b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
64     c = _a + _b;
65     assert(c >= _a);
66     return c;
67   }
68 }
69 
70 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) internal balances;
80 
81   uint256 internal totalSupply_;
82 
83   /**
84   * @dev Total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev Transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_value <= balances[msg.sender]);
97     require(_to != address(0));
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address _owner, address _spender)
124     public view returns (uint256);
125 
126   function transferFrom(address _from, address _to, uint256 _value)
127     public returns (bool);
128 
129   function approve(address _spender, uint256 _value) public returns (bool);
130   event Approval(
131     address indexed owner,
132     address indexed spender,
133     uint256 value
134   );
135 }
136 
137 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * https://github.com/ethereum/EIPs/issues/20
144  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(
158     address _from,
159     address _to,
160     uint256 _value
161   )
162     public
163     returns (bool)
164   {
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167     require(_to != address(0));
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     emit Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseApproval(
218     address _spender,
219     uint256 _addedValue
220   )
221     public
222     returns (bool)
223   {
224     allowed[msg.sender][_spender] = (
225       allowed[msg.sender][_spender].add(_addedValue));
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(
240     address _spender,
241     uint256 _subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     uint256 oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue >= oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 // File: contracts/LamboCoin.sol
259 
260 contract LamboCoin is StandardToken {
261 
262   string public constant name = "LamboCoin";
263   string public constant symbol = "LAMBO";
264   uint8 public constant decimals = 18;
265 
266   uint256 public constant INITIAL_SUPPLY = 1000000000000000000000 * (10 ** uint256(decimals));
267 
268   /**
269    * @dev Constructor that gives msg.sender all of existing tokens.
270    */
271   constructor() public {
272     totalSupply_ = INITIAL_SUPPLY;
273     balances[msg.sender] = INITIAL_SUPPLY;
274     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
275   }
276 
277 }