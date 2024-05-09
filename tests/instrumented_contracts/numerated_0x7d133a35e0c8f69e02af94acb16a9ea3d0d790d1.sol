1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17  /**
18  * @title Contract that will work with ERC223 tokens.
19  */
20 
21 contract ERC223ReceivingContract {
22 /**
23  * @dev Standard ERC223 function that will handle incoming token transfers.
24  *
25  * @param _from  Token sender address.
26  * @param _value Amount of tokens.
27  * @param _data  Transaction metadata.
28  */
29     function tokenFallback(address _from, uint _value, bytes _data);
30 }
31 
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipRenounced(address indexed previousOwner);
44   event OwnershipTransferred(
45     address indexed previousOwner,
46     address indexed newOwner
47   );
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to relinquish control of the contract.
68    * @notice Renouncing to ownership will leave the contract without an owner.
69    * It will not be possible to call the functions with the `onlyOwner`
70    * modifier anymore.
71    */
72   function renounceOwnership() public onlyOwner {
73     emit OwnershipRenounced(owner);
74     owner = address(0);
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param _newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address _newOwner) public onlyOwner {
82     _transferOwnership(_newOwner);
83   }
84 
85   /**
86    * @dev Transfers control of the contract to a newOwner.
87    * @param _newOwner The address to transfer ownership to.
88    */
89   function _transferOwnership(address _newOwner) internal {
90     require(_newOwner != address(0));
91     emit OwnershipTransferred(owner, _newOwner);
92     owner = _newOwner;
93   }
94 }
95 
96 
97 
98 
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  */
104 library SafeMath {
105 
106   /**
107   * @dev Multiplies two numbers, throws on overflow.
108   */
109   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
111     // benefit is lost if 'b' is also tested.
112     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
113     if (a == 0) {
114       return 0;
115     }
116 
117     c = a * b;
118     assert(c / a == b);
119     return c;
120   }
121 
122   /**
123   * @dev Integer division of two numbers, truncating the quotient.
124   */
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     // uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return a / b;
130   }
131 
132   /**
133   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134   */
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   /**
141   * @dev Adds two numbers, throws on overflow.
142   */
143   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
144     c = a + b;
145     assert(c >= a);
146     return c;
147   }
148 }
149 
150 
151 
152 
153 
154 
155 
156 
157 /**
158  * @title Pausable
159  * @dev Base contract which allows children to implement an emergency stop mechanism.
160  */
161 contract Pausable is Ownable {
162   event Pause();
163   event Unpause();
164 
165   bool public paused = false;
166 
167 
168   /**
169    * @dev Modifier to make a function callable only when the contract is not paused.
170    */
171   modifier whenNotPaused() {
172     require(!paused);
173     _;
174   }
175 
176   /**
177    * @dev Modifier to make a function callable only when the contract is paused.
178    */
179   modifier whenPaused() {
180     require(paused);
181     _;
182   }
183 
184   /**
185    * @dev called by the owner to pause, triggers stopped state
186    */
187   function pause() onlyOwner whenNotPaused public {
188     paused = true;
189     emit Pause();
190   }
191 
192   /**
193    * @dev called by the owner to unpause, returns to normal state
194    */
195   function unpause() onlyOwner whenPaused public {
196     paused = false;
197     emit Unpause();
198   }
199 }
200 
201 
202 
203 
204 
205 
206 /**
207  * @title ERC20 interface
208  * @dev see https://github.com/ethereum/EIPs/issues/20
209  */
210 contract ERC20 is ERC20Basic {
211   function allowance(address owner, address spender)
212     public view returns (uint256);
213 
214   function transferFrom(address from, address to, uint256 value)
215     public returns (bool);
216 
217   function approve(address spender, uint256 value) public returns (bool);
218   event Approval(
219     address indexed owner,
220     address indexed spender,
221     uint256 value
222   );
223 }
224 
225 
226 
227 
228 contract Bounty0xEscrow is Ownable, ERC223ReceivingContract, Pausable {
229 
230     using SafeMath for uint256;
231 
232     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
233 
234     event Deposit(address indexed token, address indexed user, uint amount, uint balance);
235     event Distribution(address indexed token, address indexed host, address indexed hunter, uint256 amount);
236 
237 
238     constructor() public {
239     }
240 
241     // for erc223 tokens
242     function tokenFallback(address _from, uint _value, bytes _data) public whenNotPaused {
243         address _token = msg.sender;
244 
245         tokens[_token][_from] = SafeMath.add(tokens[_token][_from], _value);
246         emit Deposit(_token, _from, _value, tokens[_token][_from]);
247     }
248 
249     // for erc20 tokens
250     function depositToken(address _token, uint _amount) public whenNotPaused {
251         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
252         require(_token != address(0));
253 
254         require(ERC20(_token).transferFrom(msg.sender, this, _amount));
255         tokens[_token][msg.sender] = SafeMath.add(tokens[_token][msg.sender], _amount);
256 
257         emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
258     }
259 
260     // for ether
261     function depositEther() public payable whenNotPaused {
262         tokens[address(0)][msg.sender] = SafeMath.add(tokens[address(0)][msg.sender], msg.value);
263         emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
264     }
265 
266 
267     function distributeTokenToAddress(address _token, address _host, address _hunter, uint256 _amount) external onlyOwner {
268         require(_hunter != address(0));
269         require(tokens[_token][_host] >= _amount);
270 
271         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], _amount);
272 
273         if (_token == address(0)) {
274             require(_hunter.send(_amount));
275         } else {
276             require(ERC20(_token).transfer(_hunter, _amount));
277         }
278 
279         emit Distribution(_token, _host, _hunter, _amount);
280     }
281 
282     function distributeTokenToAddressesAndAmounts(address _token, address _host, address[] _hunters, uint256[] _amounts) external onlyOwner {
283         require(_host != address(0));
284         require(_hunters.length == _amounts.length);
285 
286         uint256 totalAmount = 0;
287         for (uint j = 0; j < _amounts.length; j++) {
288             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
289         }
290         require(tokens[_token][_host] >= totalAmount);
291         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], totalAmount);
292 
293         if (_token == address(0)) {
294             for (uint i = 0; i < _hunters.length; i++) {
295                 require(_hunters[i].send(_amounts[i]));
296                 emit Distribution(_token, _host, _hunters[i], _amounts[i]);
297             }
298         } else {
299             for (uint k = 0; k < _hunters.length; k++) {
300                 require(ERC20(_token).transfer(_hunters[k], _amounts[k]));
301                 emit Distribution(_token, _host, _hunters[k], _amounts[k]);
302             }
303         }
304     }
305 
306     function distributeTokenToAddressesAndAmountsWithoutHost(address _token, address[] _hunters, uint256[] _amounts) external onlyOwner {
307         require(_hunters.length == _amounts.length);
308 
309         uint256 totalAmount = 0;
310         for (uint j = 0; j < _amounts.length; j++) {
311             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
312         }
313 
314         if (_token == address(0)) {
315             require(address(this).balance >= totalAmount);
316             for (uint i = 0; i < _hunters.length; i++) {
317                 require(_hunters[i].send(_amounts[i]));
318                 emit Distribution(_token, this, _hunters[i], _amounts[i]);
319             }
320         } else {
321             require(ERC20(_token).balanceOf(this) >= totalAmount);
322             for (uint k = 0; k < _hunters.length; k++) {
323                 require(ERC20(_token).transfer(_hunters[k], _amounts[k]));
324                 emit Distribution(_token, this, _hunters[k], _amounts[k]);
325             }
326         }
327     }
328 
329     function distributeWithTransferFrom(address _token, address _ownerOfTokens, address[] _hunters, uint256[] _amounts) external onlyOwner {
330         require(_token != address(0));
331         require(_hunters.length == _amounts.length);
332 
333         uint256 totalAmount = 0;
334         for (uint j = 0; j < _amounts.length; j++) {
335             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
336         }
337         require(ERC20(_token).allowance(_ownerOfTokens, this) >= totalAmount);
338 
339         for (uint i = 0; i < _hunters.length; i++) {
340             ERC20(_token).transferFrom(_ownerOfTokens, _hunters[i], _amounts[i]);
341 
342             emit Distribution(_token, this, _hunters[i], _amounts[i]);
343         }
344     }
345 
346     // in case of emergency
347     function approveToPullOutTokens(address _token, address _receiver, uint256 _amount) external onlyOwner {
348         ERC20(_token).approve(_receiver, _amount);
349     }
350 
351 }