1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) constant returns (uint256);
43   function transfer(address to, uint256 value) returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) returns (bool);
53   function approve(address spender, uint256 value) returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract ERC677 is ERC20 {
58   function transferAndCall(address to, uint value, bytes data) returns (bool success);
59 
60   event Transfer(address indexed from, address indexed to, uint value, bytes data);
61 }
62 
63 contract ERC677Receiver {
64   function onTokenTransfer(address _sender, uint _value, bytes _data);
65 }
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
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) returns (bool) {
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of. 
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
119     var _allowance = allowed[_from][msg.sender];
120 
121     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
122     // require (_value <= _allowance);
123 
124     balances[_from] = balances[_from].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     allowed[_from][msg.sender] = _allowance.sub(_value);
127     Transfer(_from, _to, _value);
128     return true;
129   }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151   
152     /*
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until 
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue) 
159     returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue) 
166     returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 contract ERC677Token is ERC677 {
180 
181   /**
182   * @dev transfer token to a contract address with additional data if the recipient is a contact.
183   * @param _to The address to transfer to.
184   * @param _value The amount to be transferred.
185   * @param _data The extra data to be passed to the receiving contract.
186   */
187   function transferAndCall(address _to, uint _value, bytes _data)
188     public
189     returns (bool success)
190   {
191     super.transfer(_to, _value);
192     Transfer(msg.sender, _to, _value, _data);
193     if (isContract(_to)) {
194       contractFallback(_to, _value, _data);
195     }
196     return true;
197   }
198 
199 
200   // PRIVATE
201 
202   function contractFallback(address _to, uint _value, bytes _data)
203     private
204   {
205     ERC677Receiver receiver = ERC677Receiver(_to);
206     receiver.onTokenTransfer(msg.sender, _value, _data);
207   }
208 
209   function isContract(address _addr)
210     private
211     returns (bool hasCode)
212   {
213     uint length;
214     assembly { length := extcodesize(_addr) }
215     return length > 0;
216   }
217 
218 }
219 
220 contract LinkToken is StandardToken, ERC677Token {
221 
222   uint public constant totalSupply = 10**27;
223   string public constant name = 'ChainLink Token';
224   uint8 public constant decimals = 18;
225   string public constant symbol = 'LINK';
226 
227   function LinkToken()
228     public
229   {
230     balances[msg.sender] = totalSupply;
231   }
232 
233   /**
234   * @dev transfer token to a specified address with additional data if the recipient is a contract.
235   * @param _to The address to transfer to.
236   * @param _value The amount to be transferred.
237   * @param _data The extra data to be passed to the receiving contract.
238   */
239   function transferAndCall(address _to, uint _value, bytes _data)
240     public
241     validRecipient(_to)
242     returns (bool success)
243   {
244     return super.transferAndCall(_to, _value, _data);
245   }
246 
247   /**
248   * @dev transfer token to a specified address.
249   * @param _to The address to transfer to.
250   * @param _value The amount to be transferred.
251   */
252   function transfer(address _to, uint _value)
253     public
254     validRecipient(_to)
255     returns (bool success)
256   {
257     return super.transfer(_to, _value);
258   }
259 
260   /**
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint256 _value)
266     public
267     validRecipient(_spender)
268     returns (bool)
269   {
270     return super.approve(_spender,  _value);
271   }
272 
273   /**
274    * @dev Transfer tokens from one address to another
275    * @param _from address The address which you want to send tokens from
276    * @param _to address The address which you want to transfer to
277    * @param _value uint256 the amount of tokens to be transferred
278    */
279   function transferFrom(address _from, address _to, uint256 _value)
280     public
281     validRecipient(_to)
282     returns (bool)
283   {
284     return super.transferFrom(_from, _to, _value);
285   }
286 
287 
288   // MODIFIERS
289 
290   modifier validRecipient(address _recipient) {
291     require(_recipient != address(0) && _recipient != address(this));
292     _;
293   }
294 
295 }