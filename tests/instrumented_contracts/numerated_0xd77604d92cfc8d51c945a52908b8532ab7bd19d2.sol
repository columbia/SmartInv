1 /**
2  *Submitted for verification at Etherscan.io on 2020-04-14
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that revert on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, reverts on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
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
63     
64     return a % b;
65   }
66 }
67 
68 /**
69  * @title ERC20 Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/179
72  */
73 contract IERC20Basic {
74   uint256 public totalSupply;
75   function transfer(address to, uint256 value) public returns (bool);
76   function balanceOf(address who) public view returns (uint256);
77   
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract IERC20 is IERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87   function approve(address spender, uint256 value) public returns (bool);
88   function transferFrom(address from, address to, uint256 value) public returns (bool);
89   
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /**
94  * @title ERC677 interface
95  */
96 contract IERC677 is IERC20 {
97   function transferAndCall(address to, uint value, bytes memory data) public returns (bool success);
98 
99   event Transfer(address indexed from, address indexed to, uint value, bytes data);
100 }
101 
102 contract ERC677Receiver {
103   function onTokenTransfer(address _sender, uint _value, bytes memory _data) public;
104 }
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances. 
109  */
110 contract BasicToken is IERC20Basic {
111     
112   using SafeMath for uint256;
113   mapping(address => uint256) balances;
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     emit Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of. 
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is IERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     uint256 _allowance = allowed[_from][msg.sender];
158 
159     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160     // require (_value <= _allowance);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = _allowance.sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189   
190     /*
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until 
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    */
196   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 /**
216  * @title ERC677Token
217  */
218 contract ERC677Token is IERC677 {
219 
220   /**
221   * @dev transfer token to a contract address with additional data if the recipient is a contact.
222   * @param _to The address to transfer to.
223   * @param _value The amount to be transferred.
224   * @param _data The extra data to be passed to the receiving contract.
225   */
226   function transferAndCall(address _to, uint _value, bytes memory _data)
227     public
228     returns (bool success)
229   {
230     transfer(_to, _value);
231     //super.transfer(_to, _value);
232     emit Transfer(msg.sender, _to, _value, _data);
233     if (isContract(_to)) {
234       contractFallback(_to, _value, _data);
235     }
236     return true;
237   }
238 
239   // PRIVATE
240 
241   function contractFallback(address _to, uint _value, bytes memory _data)
242     private
243   {
244     ERC677Receiver receiver = ERC677Receiver(_to);
245     receiver.onTokenTransfer(msg.sender, _value, _data);
246   }
247 
248   function isContract(address _addr) 
249     private view 
250     returns (bool hasCode)
251   {
252     uint length;
253     assembly { length := extcodesize(_addr) }
254     return length > 0;
255   }
256 
257 }
258 
259 
260 /**
261  * @title AVN
262  */
263 contract EXG is StandardToken, ERC677Token {
264 
265   string public constant name = 'Exchain Global';
266   string public constant symbol = 'EXG';
267   uint8 public constant decimals = 6;
268   uint256 public constant totalSupply = 100*10**12; // 
269 
270   constructor () public
271   {
272     balances[msg.sender] = totalSupply;
273   }
274 
275   // MODIFIERS
276   modifier validRecipient(address _recipient) {
277     require(_recipient != address(0) && _recipient != address(this));
278     _;
279   }
280 
281   /**
282   * @dev transfer token to a specified address.
283   * @param _to The address to transfer to.
284   * @param _value The amount to be transferred.
285   */
286   function transfer(address _to, uint _value)
287     public
288     validRecipient(_to)
289     returns (bool success)
290   {
291     return super.transfer(_to, _value);
292   }
293 
294   /**
295    * @dev Transfer tokens from one address to another
296    * @param _from address The address which you want to send tokens from
297    * @param _to address The address which you want to transfer to
298    * @param _value uint256 the amount of tokens to be transferred
299    */
300   function transferFrom(address _from, address _to, uint256 _value)
301     public
302     validRecipient(_to)
303     returns (bool)
304   {
305     return super.transferFrom(_from, _to, _value);
306   }
307 
308   /**
309    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
310    * @param _spender The address which will spend the funds.
311    * @param _value The amount of tokens to be spent.
312    */
313   function approve(address _spender, uint256 _value)
314     public
315     validRecipient(_spender)
316     returns (bool)
317   {
318     return super.approve(_spender,  _value);
319   }
320 
321   /**
322   * @dev transfer token to a specified address with additional data if the recipient is a contract.
323   * @param _to The address to transfer to.
324   * @param _value The amount to be transferred.
325   * @param _data The extra data to be passed to the receiving contract.
326   */
327   function transferAndCall(address _to, uint _value, bytes memory _data)
328     public
329     validRecipient(_to)
330     returns (bool success)
331   {
332     return super.transferAndCall(_to, _value, _data);
333   }
334 
335 }