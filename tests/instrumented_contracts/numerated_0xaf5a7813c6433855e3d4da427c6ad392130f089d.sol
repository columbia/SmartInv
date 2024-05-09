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
198     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
199 
200     event Deposit(address token, address user, uint amount, uint balance);
201     event Distribution(address token, address host, address hunter, uint256 amount, uint64 timestamp);
202 
203 
204     constructor() public {
205         
206     }
207 
208     // for erc223 tokens
209     function tokenFallback(address _from, uint _value, bytes _data) public whenNotPaused {
210         address _token = msg.sender;
211 
212         tokens[_token][_from] = SafeMath.add(tokens[_token][_from], _value);
213         emit Deposit(_token, _from, _value, tokens[_token][_from]);
214     }
215 
216     // for erc20 tokens 
217     function depositToken(address _token, uint _amount) public whenNotPaused {
218         //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
219         require(_token != address(0));
220 
221         require(ERC20(_token).transferFrom(msg.sender, this, _amount));
222         tokens[_token][msg.sender] = SafeMath.add(tokens[_token][msg.sender], _amount);
223 
224         emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
225     }
226 
227 
228     function distributeTokenToAddress(address _token, address _host, address _hunter, uint256 _amount) external onlyOwner {
229         require(_token != address(0));
230         require(_hunter != address(0));
231         require(tokens[_token][_host] >= _amount);
232 
233         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], _amount);
234         require(ERC20(_token).transfer(_hunter, _amount));
235 
236         emit Distribution(_token, _host, _hunter, _amount, uint64(now));
237     }
238 
239     function distributeTokenToAddressesAndAmounts(address _token, address _host, address[] _hunters, uint256[] _amounts) external onlyOwner {
240         require(_token != address(0));
241         require(_host != address(0));
242         require(_hunters.length == _amounts.length);
243 
244         uint256 totalAmount = 0;
245         for (uint j = 0; j < _amounts.length; j++) {
246             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
247         }
248         require(tokens[_token][_host] >= totalAmount);
249         tokens[_token][_host] = SafeMath.sub(tokens[_token][_host], totalAmount);
250 
251         for (uint i = 0; i < _hunters.length; i++) {
252             require(ERC20(_token).transfer(_hunters[i], _amounts[i]));
253 
254             emit Distribution(_token, _host, _hunters[i], _amounts[i], uint64(now));
255         }
256     }
257 
258     function distributeTokenToAddressesAndAmountsWithoutHost(address _token, address[] _hunters, uint256[] _amounts) external onlyOwner {
259         require(_token != address(0));
260         require(_hunters.length == _amounts.length);
261 
262         uint256 totalAmount = 0;
263         for (uint j = 0; j < _amounts.length; j++) {
264             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
265         }
266         require(ERC20(_token).balanceOf(this) >= totalAmount);
267 
268         for (uint i = 0; i < _hunters.length; i++) {
269             require(ERC20(_token).transfer(_hunters[i], _amounts[i]));
270 
271             emit Distribution(_token, this, _hunters[i], _amounts[i], uint64(now));
272         }
273     }
274     
275     function distributeWithTransferFrom(address _token, address _ownerOfTokens, address[] _hunters, uint256[] _amounts) external onlyOwner {
276         require(_token != address(0));
277         require(_hunters.length == _amounts.length);
278 
279         uint256 totalAmount = 0;
280         for (uint j = 0; j < _amounts.length; j++) {
281             totalAmount = SafeMath.add(totalAmount, _amounts[j]);
282         }
283         require(ERC20(_token).allowance(_ownerOfTokens, this) >= totalAmount);
284 
285         for (uint i = 0; i < _hunters.length; i++) {
286             require(ERC20(_token).transferFrom(_ownerOfTokens, _hunters[i], _amounts[i]));
287 
288             emit Distribution(_token, this, _hunters[i], _amounts[i], uint64(now));
289         }
290     }
291     
292     // in case of emergency
293     function approveToPullOutTokens(address _token, address _receiver, uint256 _amount) external onlyOwner {
294         ERC20(_token).approve(_receiver, _amount);
295     }
296     
297 }