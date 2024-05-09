1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
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
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     emit OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 
74 
75 
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83 
84   /**
85   * @dev Multiplies two numbers, throws on overflow.
86   */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88     if (a == 0) {
89       return 0;
90     }
91     c = a * b;
92     assert(c / a == b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 a, uint256 b) internal pure returns (uint256) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return a / b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
118     c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 
125 
126 
127 
128 
129 
130 
131 /**
132  * @title Pausable
133  * @dev Base contract which allows children to implement an emergency stop mechanism.
134  */
135 contract Pausable is Ownable {
136   event Pause();
137   event Unpause();
138 
139   bool public paused = false;
140 
141 
142   /**
143    * @dev Modifier to make a function callable only when the contract is not paused.
144    */
145   modifier whenNotPaused() {
146     require(!paused);
147     _;
148   }
149 
150   /**
151    * @dev Modifier to make a function callable only when the contract is paused.
152    */
153   modifier whenPaused() {
154     require(paused);
155     _;
156   }
157 
158   /**
159    * @dev called by the owner to pause, triggers stopped state
160    */
161   function pause() onlyOwner whenNotPaused public {
162     paused = true;
163     emit Pause();
164   }
165 
166   /**
167    * @dev called by the owner to unpause, returns to normal state
168    */
169   function unpause() onlyOwner whenPaused public {
170     paused = false;
171     emit Unpause();
172   }
173 }
174 
175 
176 
177 
178 
179 
180 /**
181  * @title ERC20 interface
182  * @dev see https://github.com/ethereum/EIPs/issues/20
183  */
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 
192 
193 
194 contract Bounty0xEscrow is Ownable, ERC223ReceivingContract, Pausable {
195 
196     using SafeMath for uint256;
197 
198     address[] supportedTokens;
199 
200     mapping (address => bool) public tokenIsSupported;
201     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
202 
203     event Deposit(address token, address user, uint amount, uint balance);
204     event Distribution(address token, address host, address hunter, uint256 amount, uint64 timestamp);
205 
206 
207     constructor() public {
208         address Bounty0xToken = 0xd2d6158683aeE4Cc838067727209a0aAF4359de3;
209         supportedTokens.push(Bounty0xToken);
210         tokenIsSupported[Bounty0xToken] = true;
211     }
212 
213 
214     function addSupportedToken(address _token) public onlyOwner {
215         require(!tokenIsSupported[_token]);
216 
217         supportedTokens.push(_token);
218         tokenIsSupported[_token] = true;
219     }
220 
221     function removeSupportedToken(address _token) public onlyOwner {
222         require(tokenIsSupported[_token]);
223 
224         for (uint i = 0; i < supportedTokens.length; i++) {
225             if (supportedTokens[i] == _token) {
226                 uint256 indexOfLastToken = supportedTokens.length - 1;
227                 supportedTokens[i] = supportedTokens[indexOfLastToken];
228                 supportedTokens.length--;
229                 tokenIsSupported[_token] = false;
230                 return;
231             }
232         }
233     }
234 
235     function getListOfSupportedTokens() view public returns(address[]) {
236         return supportedTokens;
237     }
238 
239 
240     function tokenFallback(address _from, uint _value, bytes _data) public whenNotPaused {
241         address _token = msg.sender;
242         require(tokenIsSupported[_token]);
243 
244         tokens[_token][_from] = SafeMath.add(tokens[_token][_from], _value);
245         emit Deposit(_token, _from, _value, tokens[_token][_from]);
246     }
247 
248 
249     function depositToken(address _token, uint _amount) public whenNotPaused {
250         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
251         require(_token != address(0));
252         require(tokenIsSupported[_token]);
253 
254         require(ERC20(_token).transferFrom(msg.sender, this, _amount));
255         tokens[_token][msg.sender] = SafeMath.add(tokens[_token][msg.sender], _amount);
256 
257         emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
258     }
259 
260 
261     function distributeTokenToAddress(address _token, address _host, address _hunter, uint256 _amount) external onlyOwner {
262         require(_token != address(0));
263         require(_hunter != address(0));
264         require(tokenIsSupported[_token]);
265         require(tokens[_token][_host] >= _amount);
266 
267         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], _amount);
268         require(ERC20(_token).transfer(_hunter, _amount));
269 
270         emit Distribution(_token, _host, _hunter, _amount, uint64(now));
271     }
272 
273     function distributeTokenToAddressesAndAmounts(address _token, address _host, address[] _hunters, uint256[] _amounts) external onlyOwner {
274         require(_token != address(0));
275         require(_host != address(0));
276         require(_hunters.length == _amounts.length);
277         require(tokenIsSupported[_token]);
278 
279         uint256 totalAmount = 0;
280         for (uint j = 0; j < _amounts.length; j++) {
281             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
282         }
283         require(tokens[_token][_host] >= totalAmount);
284         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], totalAmount);
285 
286         for (uint i = 0; i < _hunters.length; i++) {
287             require(ERC20(_token).transfer(_hunters[i], _amounts[i]));
288 
289             emit Distribution(_token, _host, _hunters[i], _amounts[i], uint64(now));
290         }
291     }
292 
293     function distributeTokenToAddressesAndAmountsWithoutHost(address _token, address[] _hunters, uint256[] _amounts) external onlyOwner {
294         require(_token != address(0));
295         require(_hunters.length == _amounts.length);
296         require(tokenIsSupported[_token]);
297 
298         uint256 totalAmount = 0;
299         for (uint j = 0; j < _amounts.length; j++) {
300             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
301         }
302         require(ERC20(_token).balanceOf(this) >= totalAmount);
303 
304         for (uint i = 0; i < _hunters.length; i++) {
305             require(ERC20(_token).transfer(_hunters[i], _amounts[i]));
306 
307             emit Distribution(_token, this, _hunters[i], _amounts[i], uint64(now));
308         }
309     }
310 
311 }