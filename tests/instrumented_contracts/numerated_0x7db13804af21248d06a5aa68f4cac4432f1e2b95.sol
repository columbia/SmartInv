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
118 /**
119 * @title ERC223 interface
120 * @dev see https://github.com/ethereum/eips/issues/223
121 */
122 contract ERC223 {
123     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
124     function transfer(address _to, uint _value, bytes _data, string _fallback) public returns (bool success);
125     event Transfer(address indexed from, address indexed to, uint value, bytes data);
126 }
127 
128 /**
129  * @title Contract that will work with ERC223 tokens.
130  */
131  
132 contract ERC223ReceivingContract { 
133 /**
134  * @dev Standard ERC223 function that will handle incoming token transfers.
135  *
136  * @param _from  Token sender address.
137  * @param _value Amount of tokens.
138  * @param _data  Transaction metadata.
139  */
140     function tokenFallback(address _from, uint _value, bytes _data);
141 }
142 
143 /**
144 * @title ERC223Token
145 * @dev Generic implementation for the required functionality of the ERC223 standard.
146 * @dev 
147 */
148 contract ZoologicalGarden is ERC223, ERC20Basic {
149   using SafeMath for uint256;
150   
151   string public name;
152   string public symbol;
153   uint8 public decimals;
154   uint256 public totalSupply;
155   mapping(address => uint256) public balances;
156 
157   /**
158   * @dev Function to access name of token.
159   * @return _name string the name of the token.
160   */
161   function name() public view returns (string _name) {
162     return name;
163   }
164     
165   /**
166   * @dev Function to access symbol of token.
167   * @return _symbol string the symbol of the token.
168   */
169   function symbol() public view returns (string _symbol) {
170     return symbol;
171   }
172     
173   /**
174   * @dev Function to access decimals of token.
175   * @return _decimals uint8 decimal point of token fractions.
176   */
177   function decimals() public view returns (uint8 _decimals) {
178     return decimals;
179   }
180   
181   /**
182   * @dev Function to access total supply of tokens.
183   * @return _totalSupply uint256 total token supply.
184   */
185   function totalSupply() public view returns (uint256 _totalSupply) {
186     return totalSupply;
187   }
188 
189   /**
190   * @dev Function to access the balance of a specific address.
191   * @param _owner address the target address to get the balance from.
192   * @return _balance uint256 the balance of the target address.
193   */
194   function balanceOf(address _owner) public view returns (uint256 _balance) {
195     return balances[_owner];
196   }
197   
198   
199   function ZoologicalGarden() public{
200       name = "Zoological Garden";
201       symbol = "ZOO";
202       decimals = 4;
203       totalSupply = 100000000 * 10 ** uint(decimals);
204       balances[msg.sender] = totalSupply;
205 
206   }
207 
208   /**
209   * @dev Function that is called when a user or another contract wants to transfer funds using custom fallback.
210   * @param _to address to which the tokens are transfered.
211   * @param _value uint256 amount of tokens to be transfered.
212   * @param _data bytes data along token transaction.
213   * @param _fallback string name of the custom fallback function to be called after transaction.
214   */
215   function transfer(address _to, uint256 _value, bytes _data, string _fallback) public returns (bool _success) {
216     if (isContract(_to)) {
217       if (balanceOf(msg.sender) < _value)
218       revert();
219       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
220       balances[_to] = balanceOf(_to).add(_value);
221       
222       // Calls the custom fallback function.
223       // Will fail if not implemented, reverting transaction.
224       assert(_to.call.value(0)(bytes4(keccak256(_fallback)), msg.sender, _value, _data));
225       
226       Transfer(msg.sender, _to, _value, _data);
227       return true;
228     } else {
229       return transferToAddress(_to, _value, _data);
230     }
231   }
232 
233   /**
234   * @dev Function that is called when a user or another contract wants to transfer funds using default fallback.
235   * @param _to address to which the tokens are transfered.
236   * @param _value uint256 amount of tokens to be transfered.
237   * @param _data bytes data along token transaction.
238   */
239   function transfer(address _to, uint256 _value, bytes _data) public returns (bool _success) {
240     if (isContract(_to)) {
241       return transferToContract(_to, _value, _data);
242     } else {
243       return transferToAddress(_to, _value, _data);
244     }
245   }
246 
247   /**
248   * @dev Standard function transfer similar to ERC20 transfer with no _data.
249   * Added due to backwards compatibility reasons.
250   * @param _to address to which the tokens are transfered.
251   * @param _value uint256 amount of tokens to be transfered.
252   */
253   function transfer(address _to, uint256 _value) public returns (bool _success) {
254     // Adds empty bytes to fill _data param in functions
255     bytes memory empty;
256     if (isContract(_to)) {
257       return transferToContract(_to, _value, empty);
258     } else {
259       return transferToAddress(_to, _value, empty);
260     }
261   }
262 
263   /**
264   * @dev Function to test whether target address is a contract.
265   * @param _addr address to be tested as a contract address or something else.
266   * @return _isContract bool true if target address is a contract false otherwise.
267   */
268   function isContract(address _addr) private view returns (bool _isContract) {
269     uint length;
270     assembly {
271       length := extcodesize(_addr)
272     }
273     return (length > 0);
274   }
275     
276   /**
277   * @dev Function that is called when transaction target is an address.
278   * @param _to address to which the tokens are transfered.
279   * @param _value uint256 amount of tokens to be transfered.
280   * @param _data bytes data along token transaction.
281   */
282   function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool _success) {
283     if (balanceOf(msg.sender) < _value)
284     revert();
285     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
286     balances[_to] = balanceOf(_to).add(_value);
287 
288     Transfer(msg.sender, _to, _value, _data);
289     return true;
290   }
291 
292   /**
293   * @dev Function that is called when transaction target is a contract.
294   * @param _to address to which the tokens are transfered.
295   * @param _value uint256 amount of tokens to be transfered.
296   * @param _data bytes data along token transaction.
297   */
298   function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool _success) {
299     if (balanceOf(msg.sender) < _value) {
300         revert();
301     }
302     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
303     balances[_to] = balanceOf(_to).add(_value);
304 
305     // Calls the default fallback function.
306     // Will fail if not implemented, reverting transaction.
307     ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
308     receiver.tokenFallback(msg.sender, _value, _data);
309 
310     Transfer(msg.sender, _to, _value, _data);
311     return true;
312   }
313 }