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
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * See https://github.com/ethereum/EIPs/issues/179
58  */
59 contract ERC20Basic {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev Total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev Transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender)
118     public view returns (uint256);
119 
120   function transferFrom(address from, address to, uint256 value)
121     public returns (bool);
122 
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(
125     address indexed owner,
126     address indexed spender,
127     uint256 value
128   );
129 }
130 
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * https://github.com/ethereum/EIPs/issues/20
137  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(
151     address _from,
152     address _to,
153     uint256 _value
154   )
155     public
156     returns (bool)
157   {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     emit Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(
191     address _owner,
192     address _spender
193    )
194     public
195     view
196     returns (uint256)
197   {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseApproval(
211     address _spender,
212     uint256 _addedValue
213   )
214     public
215     returns (bool)
216   {
217     allowed[msg.sender][_spender] = (
218       allowed[msg.sender][_spender].add(_addedValue));
219     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   /**
224    * @dev Decrease the amount of tokens that an owner allowed to a spender.
225    * approve should be called when allowed[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseApproval(
233     address _spender,
234     uint256 _subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     uint256 oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 /**
252 * @title Atomz Token
253 * @dev atomz.io token contract.
254 */
255 
256 contract ATZToken is StandardToken {
257 
258   string public constant name = "Atomz Token";
259   string public constant symbol = "ATZ";
260   uint8 public constant decimals = 18;
261 
262   uint256 public constant INITIAL_SUPPLY = 25000000 * (10 ** uint256(decimals));
263 
264   /**
265    * @dev Constructor that gives msg.sender all of existing tokens.
266    */
267 
268   constructor() public {
269     totalSupply_ = INITIAL_SUPPLY;
270     balances[msg.sender] = INITIAL_SUPPLY;
271     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
272   }
273 
274 }