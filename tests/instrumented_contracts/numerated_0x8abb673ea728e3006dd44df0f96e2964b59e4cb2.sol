1 pragma solidity 0.4.21;
2 
3 /**
4 
5  * @title ERC20Basic
6 
7  * @dev Simpler version of ERC20 interface
8 
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10 
11  */
12 
13 contract ERC20Basic {
14 
15   function totalSupply() public view returns (uint256);
16 
17   function balanceOf(address who) public view returns (uint256);
18 
19   function transfer(address to, uint256 value) public returns (bool);
20 
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 
23 }
24 
25 
26 
27 /**
28 
29  * @title SafeMath
30 
31  * @dev Math operations with safety checks that throw on error
32 
33  */
34 
35 library SafeMath {
36 
37 
38 
39   /**
40 
41   * @dev Multiplies two numbers, throws on overflow.
42 
43   */
44 
45   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
46 
47     if (a == 0) {
48 
49       return 0;
50 
51     }
52 
53     c = a * b;
54 
55     assert(c / a == b);
56 
57     return c;
58 
59   }
60 
61 
62 
63   /**
64 
65   * @dev Integer division of two numbers, truncating the quotient.
66 
67   */
68 
69   function div(uint256 a, uint256 b) internal pure returns (uint256) {
70 
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72 
73     // uint256 c = a / b;
74 
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77     return a / b;
78 
79   }
80 
81 
82 
83   /**
84 
85   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86 
87   */
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90 
91     assert(b <= a);
92 
93     return a - b;
94 
95   }
96 
97 
98 
99   /**
100 
101   * @dev Adds two numbers, throws on overflow.
102 
103   */
104 
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106 
107     c = a + b;
108 
109     assert(c >= a);
110 
111     return c;
112 
113   }
114 
115 }
116 
117 
118 
119 /**
120 * @title ERC223 interface
121 * @dev see https://github.com/ethereum/eips/issues/223
122 */
123 contract ERC223 {
124     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
125     function transfer(address _to, uint _value, bytes _data, string _fallback) public returns (bool success);
126     event Transfer(address indexed from, address indexed to, uint value, bytes data);
127 }
128 
129 /**
130  * @title Contract that will work with ERC223 tokens.
131  */
132  
133 contract ERC223ReceivingContract { 
134 /**
135  * @dev Standard ERC223 function that will handle incoming token transfers.
136  *
137  * @param _from  Token sender address.
138  * @param _value Amount of tokens.
139  * @param _data  Transaction metadata.
140  */
141     function tokenFallback(address _from, uint _value, bytes _data);
142 }
143 
144 /**
145 * @title ERC223Token
146 * @dev Generic implementation for the required functionality of the ERC223 standard.
147 * @dev 
148 */
149 contract SpecialDrawingRight is ERC223, ERC20Basic {
150   using SafeMath for uint256;
151   
152   string public name;
153   string public symbol;
154   uint8 public decimals;
155   uint256 public totalSupply;
156   mapping(address => uint256) public balances;
157 
158   /**
159   * @dev Function to access name of token.
160   * @return _name string the name of the token.
161   */
162   function name() public view returns (string _name) {
163     return name;
164   }
165     
166   /**
167   * @dev Function to access symbol of token.
168   * @return _symbol string the symbol of the token.
169   */
170   function symbol() public view returns (string _symbol) {
171     return symbol;
172   }
173     
174   /**
175   * @dev Function to access decimals of token.
176   * @return _decimals uint8 decimal point of token fractions.
177   */
178   function decimals() public view returns (uint8 _decimals) {
179     return decimals;
180   }
181   
182   /**
183   * @dev Function to access total supply of tokens.
184   * @return _totalSupply uint256 total token supply.
185   */
186   function totalSupply() public view returns (uint256 _totalSupply) {
187     return totalSupply;
188   }
189 
190   /**
191   * @dev Function to access the balance of a specific address.
192   * @param _owner address the target address to get the balance from.
193   * @return _balance uint256 the balance of the target address.
194   */
195   function balanceOf(address _owner) public view returns (uint256 _balance) {
196     return balances[_owner];
197   }
198   
199   
200   function SpecialDrawingRight() public{
201       name = "Special Drawing Right";
202       symbol = "SDR";
203       decimals = 2;
204       totalSupply = 1000000000 * 10 ** uint(decimals);  
205       balances[msg.sender] = totalSupply;
206 
207   }
208 
209   /**
210   * @dev Function that is called when a user or another contract wants to transfer funds using custom fallback.
211   * @param _to address to which the tokens are transfered.
212   * @param _value uint256 amount of tokens to be transfered.
213   * @param _data bytes data along token transaction.
214   * @param _fallback string name of the custom fallback function to be called after transaction.
215   */
216   function transfer(address _to, uint256 _value, bytes _data, string _fallback) public returns (bool _success) {
217     if (isContract(_to)) {
218       if (balanceOf(msg.sender) < _value)
219       revert();
220       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
221       balances[_to] = balanceOf(_to).add(_value);
222       
223       // Calls the custom fallback function.
224       // Will fail if not implemented, reverting transaction.
225       assert(_to.call.value(0)(bytes4(keccak256(_fallback)), msg.sender, _value, _data));
226       
227       Transfer(msg.sender, _to, _value, _data);
228       return true;
229     } else {
230       return transferToAddress(_to, _value, _data);
231     }
232   }
233 
234   /**
235   * @dev Function that is called when a user or another contract wants to transfer funds using default fallback.
236   * @param _to address to which the tokens are transfered.
237   * @param _value uint256 amount of tokens to be transfered.
238   * @param _data bytes data along token transaction.
239   */
240   function transfer(address _to, uint256 _value, bytes _data) public returns (bool _success) {
241     if (isContract(_to)) {
242       return transferToContract(_to, _value, _data);
243     } else {
244       return transferToAddress(_to, _value, _data);
245     }
246   }
247 
248   /**
249   * @dev Standard function transfer similar to ERC20 transfer with no _data.
250   * Added due to backwards compatibility reasons.
251   * @param _to address to which the tokens are transfered.
252   * @param _value uint256 amount of tokens to be transfered.
253   */
254   function transfer(address _to, uint256 _value) public returns (bool _success) {
255     // Adds empty bytes to fill _data param in functions
256     bytes memory empty;
257     if (isContract(_to)) {
258       return transferToContract(_to, _value, empty);
259     } else {
260       return transferToAddress(_to, _value, empty);
261     }
262   }
263 
264   /**
265   * @dev Function to test whether target address is a contract.
266   * @param _addr address to be tested as a contract address or something else.
267   * @return _isContract bool true if target address is a contract false otherwise.
268   */
269   function isContract(address _addr) private view returns (bool _isContract) {
270     uint length;
271     assembly {
272       length := extcodesize(_addr)
273     }
274     return (length > 0);
275   }
276     
277   /**
278   * @dev Function that is called when transaction target is an address.
279   * @param _to address to which the tokens are transfered.
280   * @param _value uint256 amount of tokens to be transfered.
281   * @param _data bytes data along token transaction.
282   */
283   function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool _success) {
284     if (balanceOf(msg.sender) < _value)
285     revert();
286     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
287     balances[_to] = balanceOf(_to).add(_value);
288 
289     Transfer(msg.sender, _to, _value, _data);
290     return true;
291   }
292 
293   /**
294   * @dev Function that is called when transaction target is a contract.
295   * @param _to address to which the tokens are transfered.
296   * @param _value uint256 amount of tokens to be transfered.
297   * @param _data bytes data along token transaction.
298   */
299   function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool _success) {
300     if (balanceOf(msg.sender) < _value) {
301         revert();
302     }
303     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
304     balances[_to] = balanceOf(_to).add(_value);
305 
306     // Calls the default fallback function.
307     // Will fail if not implemented, reverting transaction.
308     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
309     receiver.tokenFallback(msg.sender, _value, _data);
310 
311     Transfer(msg.sender, _to, _value, _data);
312     return true;
313   }
314 }