1 pragma solidity ^0.4.21;
2 
3 // zeppelin-solidity: 1.9.0
4 
5 /// @title Contract that supports the receival of ERC223 tokens.
6 contract ERC223ReceivingContract {
7 
8   /// @dev Standard ERC223 function that will handle incoming token transfers.
9   /// @param _from  Token sender address.
10   /// @param _value Amount of tokens.
11   /// @param _data  Transaction metadata.
12   function tokenFallback(address _from, uint _value, bytes _data) public;
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title ERC20Basic
63  * @dev Simpler version of ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/179
65  */
66 contract ERC20Basic {
67   function totalSupply() public view returns (uint256);
68   function balanceOf(address who) public view returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 /**
74  * @title ERC223 standard token interface.
75  */
76 
77 contract ERC223Basic is ERC20Basic {
78 
79   /**
80    * @dev Transfer the specified amount of tokens to the specified address.
81    *      Now with a new parameter _data.
82    *
83    * @param _to    Receiver address.
84    * @param _value Amount of tokens that will be transferred.
85    * @param _data  Transaction metadata.
86    */
87   function transfer(address _to, uint _value, bytes _data) public returns (bool);
88 
89   /**
90    * @dev triggered when transfer is successfully called.
91    *
92    * @param _from  Sender address.
93    * @param _to    Receiver address.
94    * @param _value Amount of tokens that will be transferred.
95    * @param _data  Transaction metadata.
96    */
97   event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
98 }
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120   uint256 totalSupply_;
121 
122   /**
123   * @dev total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply_;
127   }
128 
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134   function transfer(address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[msg.sender]);
137 
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     emit Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public view returns (uint256) {
150     return balances[_owner];
151   }
152 
153 }
154 
155 /**
156  * @title ERC223 standard token implementation.
157  */
158 contract ERC223BasicToken is ERC223Basic, BasicToken {
159 
160   /**
161    * @dev Transfer the specified amount of tokens to the specified address.
162    *      Invokes the `tokenFallback` function if the recipient is a contract.
163    *      The token transfer fails if the recipient is a contract
164    *      but does not implement the `tokenFallback` function
165    *      or the fallback function to receive funds.
166    *
167    * @param _to    Receiver address.
168    * @param _value Amount of tokens that will be transferred.
169    * @param _data  Transaction metadata.
170    */
171   function transfer(address _to, uint _value, bytes _data) public returns (bool) {
172     // Standard function transfer similar to ERC20 transfer with no _data .
173     // Added due to backwards compatibility reasons .
174     uint codeLength;
175 
176     assembly {
177       // Retrieve the size of the code on target address, this needs assembly .
178       codeLength := extcodesize(_to)
179     }
180 
181     require(super.transfer(_to, _value));
182 
183     if(codeLength>0) {
184       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
185       receiver.tokenFallback(msg.sender, _value, _data);
186     }
187     emit Transfer(msg.sender, _to, _value, _data);
188     return true;
189   }
190 
191   /**
192    * @dev Transfer the specified amount of tokens to the specified address.
193    *      Invokes the `tokenFallback` function if the recipient is a contract.
194    *      The token transfer fails if the recipient is a contract
195    *      but does not implement the `tokenFallback` function
196    *      or the fallback function to receive funds.
197    *
198    * @param _to    Receiver address.
199    * @param _value Amount of tokens that will be transferred.
200    */
201   function transfer(address _to, uint256 _value) public returns (bool) {
202     bytes memory empty;
203     require(transfer(_to, _value, empty));
204     return true;
205   }
206 }
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * @dev https://github.com/ethereum/EIPs/issues/20
213  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
214  */
215 contract StandardToken is ERC20, BasicToken {
216 
217   mapping (address => mapping (address => uint256)) internal allowed;
218 
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param _from address The address which you want to send tokens from
223    * @param _to address The address which you want to transfer to
224    * @param _value uint256 the amount of tokens to be transferred
225    */
226   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
227     require(_to != address(0));
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230 
231     balances[_from] = balances[_from].sub(_value);
232     balances[_to] = balances[_to].add(_value);
233     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234     emit Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    *
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     emit Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(address _owner, address _spender) public view returns (uint256) {
261     return allowed[_owner][_spender];
262   }
263 
264   /**
265    * @dev Increase the amount of tokens that an owner allowed to a spender.
266    *
267    * approve should be called when allowed[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
275     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
291     uint oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue > oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301 }
302 
303 contract Squirrelcoin is StandardToken, ERC223BasicToken {
304   string  constant public name = "Squirrelcoin";
305   string  constant public symbol = "NTS";
306   uint8   constant public decimals = 18;
307 
308   // 10 billion (10,000,000,000)
309   uint256 constant private INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
310 
311   constructor() public {
312     totalSupply_ = INITIAL_SUPPLY;
313     balances[msg.sender] = INITIAL_SUPPLY;
314     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
315   }
316 }