1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     require(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     require(b > 0); 
17     uint256 c = a / b;
18     // require(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     require(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     require(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  */
37 contract Ownable {
38   address public owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 /**
61  * @title ERC20Basic
62  * @dev Simpler version of ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/179
64  */
65 contract ERC20Basic {
66   uint256 public totalSupply;
67   function balanceOf(address who) constant returns (uint256);
68   function transfer(address to, uint256 value) returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender) constant returns (uint256);
77   function transferFrom(address from, address to, uint256 value) returns (bool);
78   function approve(address spender, uint256 value) returns (bool);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 contract ERC677 is ERC20 {
83   function transferAndCall(address to, uint value, bytes data) returns (bool success);
84 
85   event Transfer(address indexed from, address indexed to, uint value, bytes data);
86 }
87 
88 contract ERC677Receiver {
89   function onTokenTransfer(address _sender, uint _value, bytes _data);
90 }
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) returns (bool) {
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // require (_value <= _allowance);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
174     return allowed[_owner][_spender];
175   }
176 
177     /*
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    */
183   function increaseApproval (address _spender, uint _addedValue)
184     returns (bool success) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   function decreaseApproval (address _spender, uint _subtractedValue)
191     returns (bool success) {
192     uint oldValue = allowed[msg.sender][_spender];
193     if (_subtractedValue > oldValue) {
194       allowed[msg.sender][_spender] = 0;
195     } else {
196       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
197     }
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202 }
203 
204 contract ERC677Token is ERC677 {
205 
206   /**
207   * @dev transfer token to a contract address with additional data if the recipient is a contact.
208   * @param _to The address to transfer to.
209   * @param _value The amount to be transferred.
210   * @param _data The extra data to be passed to the receiving contract.
211   */
212   function transferAndCall(address _to, uint _value, bytes _data)
213     public
214     returns (bool success)
215   {
216     super.transfer(_to, _value);
217     Transfer(msg.sender, _to, _value, _data);
218     if (isContract(_to)) {
219       contractFallback(_to, _value, _data);
220     }
221     return true;
222   }
223 
224 
225   // PRIVATE
226 
227   function contractFallback(address _to, uint _value, bytes _data)
228     private
229   {
230     ERC677Receiver receiver = ERC677Receiver(_to);
231     receiver.onTokenTransfer(msg.sender, _value, _data);
232   }
233 
234   function isContract(address _addr)
235     private
236     returns (bool hasCode)
237   {
238     uint length;
239     assembly { length := extcodesize(_addr) }
240     return length > 0;
241   }
242 
243 }
244 
245 contract ALCEDO is StandardToken, ERC677Token, Ownable {
246 
247   uint public constant totalSupply = 10**26;
248   string public constant name = 'ALCEDO';
249   uint8 public constant decimals = 18;
250   string public constant symbol = 'ALCE';
251 
252   function ALCEDO()
253     public
254   {
255     balances[msg.sender] = totalSupply;
256   }
257 
258   /**
259   * @dev transfer token to a specified address with additional data if the recipient is a contract.
260   * @param _to The address to transfer to.
261   * @param _value The amount to be transferred.
262   * @param _data The extra data to be passed to the receiving contract.
263   */
264   function transferAndCall(address _to, uint _value, bytes _data)
265     public
266     validRecipient(_to)
267     returns (bool success)
268   {
269     return super.transferAndCall(_to, _value, _data);
270   }
271 
272   /**
273   * @dev transfer token to a specified address.
274   * @param _to The address to transfer to.
275   * @param _value The amount to be transferred.
276   */
277   function transfer(address _to, uint _value)
278     public
279     validRecipient(_to)
280     returns (bool success)
281   {
282     return super.transfer(_to, _value);
283   }
284 
285   /**
286    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287    * @param _spender The address which will spend the funds.
288    * @param _value The amount of tokens to be spent.
289    */
290   function approve(address _spender, uint256 _value)
291     public
292     validRecipient(_spender)
293     returns (bool)
294   {
295     return super.approve(_spender,  _value);
296   }
297 
298   /**
299    * @dev Transfer tokens from one address to another
300    * @param _from address The address which you want to send tokens from
301    * @param _to address The address which you want to transfer to
302    * @param _value uint256 the amount of tokens to be transferred
303    */
304   function transferFrom(address _from, address _to, uint256 _value)
305     public
306     validRecipient(_to)
307     returns (bool)
308   {
309     return super.transferFrom(_from, _to, _value);
310   }
311 
312 
313   // MODIFIERS
314 
315   modifier validRecipient(address _recipient) {
316     require(_recipient != address(0) && _recipient != address(this));
317     _;
318   }
319 
320 }