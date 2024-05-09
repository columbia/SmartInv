1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() public {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 
82 
83 
84 /**
85  * @title KYC
86  * @dev KYC contract handles the white list for ASTCrowdsale contract
87  * Only accounts registered in KYC contract can buy AST token.
88  * Admins can register account, and the reason why
89  */
90 contract KYC is Ownable {
91   // check the address is registered for token sale
92   // first boolean is true if presale else false
93   // second boolean is true if registered else false
94   mapping (address => mapping (bool => bool)) public registeredAddress;
95 
96   // check the address is admin of kyc contract
97   mapping (address => bool) public admin;
98 
99   event Registered(address indexed _addr);
100   event Unregistered(address indexed _addr);
101   event SetAdmin(address indexed _addr);
102 
103   /**
104    * @dev check whether the address is registered for token sale or not.
105    * @param _addr address
106    * @param _isPresale bool Whether the address is registered to presale or mainsale
107    */
108   modifier onlyRegistered(address _addr, bool _isPresale) {
109     require(registeredAddress[_addr][_isPresale]);
110     _;
111   }
112 
113   /**
114    * @dev check whether the msg.sender is admin or not
115    */
116   modifier onlyAdmin() {
117     require(admin[msg.sender]);
118     _;
119   }
120 
121   function KYC() public {
122     admin[msg.sender] = true;
123   }
124 
125   /**
126    * @dev set new admin as admin of KYC contract
127    * @param _addr address The address to set as admin of KYC contract
128    */
129   function setAdmin(address _addr, bool _value)
130     public
131     onlyOwner
132     returns (bool)
133   {
134     require(_addr != address(0));
135     require(admin[_addr] == !_value);
136 
137     admin[_addr] = _value;
138 
139     SetAdmin(_addr);
140 
141     return true;
142   }
143 
144   /**
145    * @dev check the address is register
146    * @param _addr address The address to check
147    * @param _isPresale bool Whether the address is registered to presale or mainsale
148    */
149   function isRegistered(address _addr, bool _isPresale)
150     public
151     view
152     returns (bool)
153   {
154     return registeredAddress[_addr][_isPresale];
155   }
156 
157   /**
158    * @dev register the address for token sale
159    * @param _addr address The address to register for token sale
160    * @param _isPresale bool Whether register to presale or mainsale
161    */
162   function register(address _addr, bool _isPresale)
163     public
164     onlyAdmin
165   {
166     require(_addr != address(0) && registeredAddress[_addr][_isPresale] == false);
167 
168     registeredAddress[_addr][_isPresale] = true;
169 
170     Registered(_addr);
171   }
172 
173   /**
174    * @dev register the addresses for token sale
175    * @param _addrs address[] The addresses to register for token sale
176    * @param _isPresale bool Whether register to presale or mainsale
177    */
178   function registerByList(address[] _addrs, bool _isPresale)
179     public
180     onlyAdmin
181   {
182     for(uint256 i = 0; i < _addrs.length; i++) {
183       register(_addrs[i], _isPresale);
184     }
185   }
186 
187   /**
188    * @dev unregister the registered address
189    * @param _addr address The address to unregister for token sale
190    * @param _isPresale bool Whether unregister to presale or mainsale
191    */
192   function unregister(address _addr, bool _isPresale)
193     public
194     onlyAdmin
195     onlyRegistered(_addr, _isPresale)
196   {
197     registeredAddress[_addr][_isPresale] = false;
198 
199     Unregistered(_addr);
200   }
201 
202   /**
203    * @dev unregister the registered addresses
204    * @param _addrs address[] The addresses to unregister for token sale
205    * @param _isPresale bool Whether unregister to presale or mainsale
206    */
207   function unregisterByList(address[] _addrs, bool _isPresale)
208     public
209     onlyAdmin
210   {
211     for(uint256 i = 0; i < _addrs.length; i++) {
212       unregister(_addrs[i], _isPresale);
213     }
214   }
215 }
216 
217 
218 
219 
220 
221 
222 
223 
224 
225 
226 
227 
228 contract PaymentFallbackReceiver {
229   BTCPaymentI public payment;
230 
231   enum SaleType { pre, main }
232 
233   function PaymentFallbackReceiver(address _payment) public {
234     require(_payment != address(0));
235     payment = BTCPaymentI(_payment);
236   }
237 
238   modifier onlyPayment() {
239     require(msg.sender == address(payment));
240     _;
241   }
242 
243   event MintByBTC(SaleType _saleType, address indexed _beneficiary, uint256 _tokens);
244 
245   /**
246    * @dev paymentFallBack() is called in BTCPayment.addPayment().
247    * Presale or Mainsale contract should mint token to beneficiary,
248    * and apply corresponding ether amount to max ether cap.
249    * @param _beneficiary ethereum address who receives tokens
250    * @param _tokens amount of FXT to mint
251    */
252   function paymentFallBack(address _beneficiary, uint256 _tokens) external onlyPayment();
253 }
254 
255 
256 
257 contract PresaleFallbackReceiver {
258   bool public presaleFallBackCalled;
259 
260   function presaleFallBack(uint256 _presaleWeiRaised) public returns (bool);
261 }
262 
263 
264 
265 contract BTCPaymentI is Ownable, PresaleFallbackReceiver {
266   PaymentFallbackReceiver public presale;
267   PaymentFallbackReceiver public mainsale;
268 
269   function addPayment(address _beneficiary, uint256 _tokens) public;
270   function setPresale(address _presale) external;
271   function setMainsale(address _mainsale) external;
272   function presaleFallBack(uint256) public returns (bool);
273 }
274 
275 
276 contract BTCPayment is Ownable, PresaleFallbackReceiver {
277   using SafeMath for uint256;
278 
279   PaymentFallbackReceiver public presale;
280   PaymentFallbackReceiver public mainsale;
281 
282   event NewPayment(address _beneficiary, uint256 _tokens);
283 
284   function addPayment(address _beneficiary, uint256 _tokens)
285     public
286     onlyOwner
287   {
288     if (!presaleFallBackCalled) {
289       presale.paymentFallBack(_beneficiary, _tokens);
290     } else {
291       mainsale.paymentFallBack(_beneficiary, _tokens);
292     }
293 
294     NewPayment(_beneficiary, _tokens);
295   }
296 
297   function setPresale(address _presale) external onlyOwner {
298     require(presale == address(0));
299     presale = PaymentFallbackReceiver(_presale); // datatype conversion `address` to `PaymentFallbackReceiver`. not calling constructor `PaymentFallbackReceiver`
300   }
301 
302   function setMainsale(address _mainsale) external onlyOwner {
303     require(mainsale == address(0));
304     mainsale = PaymentFallbackReceiver(_mainsale); // datatype conversion `address` to `PaymentFallbackReceiver`. not calling constructor `PaymentFallbackReceiver`
305   }
306 
307   /**
308    * @dev Presale should notify that presale is finalized and mainsale
309    * is going to start.
310    */
311   function presaleFallBack(uint256) public returns (bool) {
312     require(msg.sender == address(presale));
313     if (presaleFallBackCalled) return false;
314     presaleFallBackCalled = true;
315     return true;
316   }
317 }