1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 
22 
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (a == 0) {
39       return 0;
40     }
41 
42     c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return a / b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 
122 
123 
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender)
132     public view returns (uint256);
133 
134   function transferFrom(address from, address to, uint256 value)
135     public returns (bool);
136 
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(
139     address indexed owner,
140     address indexed spender,
141     uint256 value
142   );
143 }
144 
145 
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
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
170     public
171     returns (bool)
172   {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     emit Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(
207     address _owner,
208     address _spender
209    )
210     public
211     view
212     returns (uint256)
213   {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(
228     address _spender,
229     uint _addedValue
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
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(
251     address _spender,
252     uint _subtractedValue
253   )
254     public
255     returns (bool)
256   {
257     uint oldValue = allowed[msg.sender][_spender];
258     if (_subtractedValue > oldValue) {
259       allowed[msg.sender][_spender] = 0;
260     } else {
261       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
262     }
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267 }
268 
269 contract TutorialToken is StandardToken {
270 	string public name = "IOTG";
271 	string public symbol = "TXT";
272 	uint8 public decimals = 18;
273 	uint public INITIAL_SUPPLY = 1000000000*(10**18);
274 
275 	constructor() public {
276   	totalSupply_ = INITIAL_SUPPLY;
277   	balances[msg.sender] = INITIAL_SUPPLY;
278 	}
279 }