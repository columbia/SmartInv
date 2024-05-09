1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title ERC20Basic
69  * @dev Simpler version of ERC20 interface
70  * See https://github.com/ethereum/EIPs/issues/179
71  */
72 contract ERC20Basic {
73   function totalSupply() public view returns (uint256);
74   function balanceOf(address who) public view returns (uint256);
75   function transfer(address to, uint256 value) public returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender)
85     public view returns (uint256);
86 
87   function transferFrom(address from, address to, uint256 value)
88     public returns (bool);
89 
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(
92     address indexed owner,
93     address indexed spender,
94     uint256 value
95   );
96 }
97 
98 /**
99  * @title DetailedERC20 token
100  * @dev The decimals are only for visualization purposes.
101  * All the operations are done using the smallest and indivisible token unit,
102  * just as on Ethereum all the operations are done in wei.
103  */
104 contract DetailedERC20 is ERC20 {
105   string public name;
106   string public symbol;
107   uint8 public decimals;
108 
109   constructor(string _name, string _symbol, uint8 _decimals) public {
110     name = _name;
111     symbol = _symbol;
112     decimals = _decimals;
113   }
114 }
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   uint256 totalSupply_;
126 
127   /**
128   * @dev Total number of tokens in existence
129   */
130   function totalSupply() public view returns (uint256) {
131     return totalSupply_;
132   }
133 
134   /**
135   * @dev Transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[msg.sender]);
142 
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     emit Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) public view returns (uint256) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * https://github.com/ethereum/EIPs/issues/20
165  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
166  */
167 contract StandardToken is DetailedERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(
179     address _from,
180     address _to,
181     uint256 _value
182   )
183     public
184     returns (bool)
185   {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(
219     address _owner,
220     address _spender
221    )
222     public
223     view
224     returns (uint256)
225   {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * @dev Increase the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(
239     address _spender,
240     uint256 _addedValue
241   )
242     public
243     returns (bool)
244   {
245     allowed[msg.sender][_spender] = (
246       allowed[msg.sender][_spender].add(_addedValue));
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    * approve should be called when allowed[_spender] == 0. To decrement
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _subtractedValue The amount of tokens to decrease the allowance by.
259    */
260   function decreaseApproval(
261     address _spender,
262     uint256 _subtractedValue
263   )
264     public
265     returns (bool)
266   {
267     uint256 oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 contract ZEON is StandardToken {
280 
281   constructor() public DetailedERC20("ZEON", "ZEON", 18) {
282     totalSupply_ = 50000000000000000000000000000;
283     balances[msg.sender] = totalSupply_;
284     emit Transfer(address(0), msg.sender, totalSupply_);
285   }
286 }