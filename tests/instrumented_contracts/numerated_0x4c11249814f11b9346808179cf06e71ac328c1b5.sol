1 /**
2  *Submitted for verification at Etherscan.io on 2017-09-23
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal constant returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 
39 /**
40  * @title ERC20Basic
41  * @dev Simpler version of ERC20 interface
42  * @dev see https://github.com/ethereum/EIPs/issues/179
43  */
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) constant returns (uint256);
47   function transfer(address to, uint256 value) returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) returns (bool);
57   function approve(address spender, uint256 value) returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract ERC677 is ERC20 {
62   function transferAndCall(address to, uint value, bytes data) returns (bool success);
63 
64   event Transfer(address indexed from, address indexed to, uint value, bytes data);
65 }
66 
67 contract ERC677Receiver {
68   function onTokenTransfer(address _sender, uint _value, bytes _data);
69 }
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances. 
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) returns (bool) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of. 
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) constant returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
123     var _allowance = allowed[_from][msg.sender];
124 
125     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126     // require (_value <= _allowance);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = _allowance.sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153     return allowed[_owner][_spender];
154   }
155   
156     /*
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until 
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    */
162   function increaseApproval (address _spender, uint _addedValue) 
163     returns (bool success) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   function decreaseApproval (address _spender, uint _subtractedValue) 
170     returns (bool success) {
171     uint oldValue = allowed[msg.sender][_spender];
172     if (_subtractedValue > oldValue) {
173       allowed[msg.sender][_spender] = 0;
174     } else {
175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176     }
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181 }
182 
183 contract ERC677Token is ERC677 {
184 
185   /**
186   * @dev transfer token to a contract address with additional data if the recipient is a contact.
187   * @param _to The address to transfer to.
188   * @param _value The amount to be transferred.
189   * @param _data The extra data to be passed to the receiving contract.
190   */
191   function transferAndCall(address _to, uint _value, bytes _data)
192     public
193     returns (bool success)
194   {
195     super.transfer(_to, _value);
196     Transfer(msg.sender, _to, _value, _data);
197     if (isContract(_to)) {
198       contractFallback(_to, _value, _data);
199     }
200     return true;
201   }
202 
203 
204   // PRIVATE
205 
206   function contractFallback(address _to, uint _value, bytes _data)
207     private
208   {
209     ERC677Receiver receiver = ERC677Receiver(_to);
210     receiver.onTokenTransfer(msg.sender, _value, _data);
211   }
212 
213   function isContract(address _addr)
214     private
215     returns (bool hasCode)
216   {
217     uint length;
218     assembly { length := extcodesize(_addr) }
219     return length > 0;
220   }
221 
222 }
223 
224 contract OraiToken is StandardToken, ERC677Token {
225 
226   uint public constant totalSupply = 86*10e23;
227   string public constant name = 'Oraichain Token';
228   uint8 public constant decimals = 18;
229   string public constant symbol = 'ORAI';
230 
231   function OraiToken()
232     public
233   {
234     balances[msg.sender] = totalSupply;
235   }
236 
237   /**
238   * @dev transfer token to a specified address with additional data if the recipient is a contract.
239   * @param _to The address to transfer to.
240   * @param _value The amount to be transferred.
241   * @param _data The extra data to be passed to the receiving contract.
242   */
243   function transferAndCall(address _to, uint _value, bytes _data)
244     public
245     validRecipient(_to)
246     returns (bool success)
247   {
248     return super.transferAndCall(_to, _value, _data);
249   }
250 
251   /**
252   * @dev transfer token to a specified address.
253   * @param _to The address to transfer to.
254   * @param _value The amount to be transferred.
255   */
256   function transfer(address _to, uint _value)
257     public
258     validRecipient(_to)
259     returns (bool success)
260   {
261     return super.transfer(_to, _value);
262   }
263 
264   /**
265    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269   function approve(address _spender, uint256 _value)
270     public
271     validRecipient(_spender)
272     returns (bool)
273   {
274     return super.approve(_spender,  _value);
275   }
276 
277   /**
278    * @dev Transfer tokens from one address to another
279    * @param _from address The address which you want to send tokens from
280    * @param _to address The address which you want to transfer to
281    * @param _value uint256 the amount of tokens to be transferred
282    */
283   function transferFrom(address _from, address _to, uint256 _value)
284     public
285     validRecipient(_to)
286     returns (bool)
287   {
288     return super.transferFrom(_from, _to, _value);
289   }
290 
291 
292   // MODIFIERS
293 
294   modifier validRecipient(address _recipient) {
295     require(_recipient != address(0) && _recipient != address(this));
296     _;
297   }
298 
299 }