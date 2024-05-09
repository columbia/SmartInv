1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract IERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract IERC20 is IERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract IERC677 is IERC20 {
59   function transferAndCall(address to, uint value, bytes memory data) public returns (bool success);
60 
61   event Transfer(address indexed from, address indexed to, uint value, bytes data);
62 }
63 
64 contract ERC677Receiver {
65   function onTokenTransfer(address _sender, uint _value, bytes memory _data) public;
66 }
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances. 
71  */
72 contract BasicToken is IERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) public returns (bool) {
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     emit Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of. 
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public view returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is IERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     uint256 _allowance = allowed[_from][msg.sender];
121 
122     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
123     // require (_value <= _allowance);
124 
125     balances[_from] = balances[_from].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     allowed[_from][msg.sender] = _allowance.sub(_value);
128     emit Transfer(_from, _to, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     emit Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152   
153     /*
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until 
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 contract ERC677Token is IERC677 {
179 
180   /**
181   * @dev transfer token to a contract address with additional data if the recipient is a contact.
182   * @param _to The address to transfer to.
183   * @param _value The amount to be transferred.
184   * @param _data The extra data to be passed to the receiving contract.
185   */
186   function transferAndCall(address _to, uint _value, bytes memory _data)
187     public
188     returns (bool success)
189   {
190     transfer(_to, _value);
191     //super.transfer(_to, _value);
192     emit Transfer(msg.sender, _to, _value, _data);
193     if (isContract(_to)) {
194       contractFallback(_to, _value, _data);
195     }
196     return true;
197   }
198 
199 
200   // PRIVATE
201 
202   function contractFallback(address _to, uint _value, bytes memory _data)
203     private
204   {
205     ERC677Receiver receiver = ERC677Receiver(_to);
206     receiver.onTokenTransfer(msg.sender, _value, _data);
207   }
208 
209   function isContract(address _addr) 
210     private view 
211     returns (bool hasCode)
212   {
213     uint length;
214     assembly { length := extcodesize(_addr) }
215     return length > 0;
216   }
217 
218 }
219 
220 contract WadaToken is StandardToken, ERC677Token {
221 
222   uint public constant totalSupply = 10**27;
223   string public constant name = 'Wada Token';
224   uint8 public constant decimals = 18;
225   string public constant symbol = 'WADA';
226 
227   constructor () public
228   {
229     balances[msg.sender] = totalSupply;
230   }
231 
232   /**
233   * @dev transfer token to a specified address with additional data if the recipient is a contract.
234   * @param _to The address to transfer to.
235   * @param _value The amount to be transferred.
236   * @param _data The extra data to be passed to the receiving contract.
237   */
238   function transferAndCall(address _to, uint _value, bytes memory _data)
239     public
240     validRecipient(_to)
241     returns (bool success)
242   {
243     return super.transferAndCall(_to, _value, _data);
244   }
245 
246   /**
247   * @dev transfer token to a specified address.
248   * @param _to The address to transfer to.
249   * @param _value The amount to be transferred.
250   */
251   function transfer(address _to, uint _value)
252     public
253     validRecipient(_to)
254     returns (bool success)
255   {
256     return super.transfer(_to, _value);
257   }
258 
259   /**
260    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
261    * @param _spender The address which will spend the funds.
262    * @param _value The amount of tokens to be spent.
263    */
264   function approve(address _spender, uint256 _value)
265     public
266     validRecipient(_spender)
267     returns (bool)
268   {
269     return super.approve(_spender,  _value);
270   }
271 
272   /**
273    * @dev Transfer tokens from one address to another
274    * @param _from address The address which you want to send tokens from
275    * @param _to address The address which you want to transfer to
276    * @param _value uint256 the amount of tokens to be transferred
277    */
278   function transferFrom(address _from, address _to, uint256 _value)
279     public
280     validRecipient(_to)
281     returns (bool)
282   {
283     return super.transferFrom(_from, _to, _value);
284   }
285 
286 
287   // MODIFIERS
288   modifier validRecipient(address _recipient) {
289     require(_recipient != address(0) && _recipient != address(this));
290     _;
291   }
292 
293 }