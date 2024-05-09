1 pragma solidity ^0.4.13;
2 
3 /**
4  * EthercraftFarm Front-end:
5  * https://mryellow.github.io/ethercraft_farm_ui/
6  */
7 
8 contract ReentrancyGuard {
9 
10   /**
11    * @dev We use a single lock for the whole contract.
12    */
13   bool private reentrancy_lock = false;
14 
15   /**
16    * @dev Prevents a contract from calling itself, directly or indirectly.
17    * @notice If you mark a function `nonReentrant`, you should also
18    * mark it `external`. Calling one nonReentrant function from
19    * another is not supported. Instead, you can implement a
20    * `private` function doing the actual work, and a `external`
21    * wrapper marked as `nonReentrant`.
22    */
23   modifier nonReentrant() {
24     require(!reentrancy_lock);
25     reentrancy_lock = true;
26     _;
27     reentrancy_lock = false;
28   }
29 
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 contract Destructible is Ownable {
68 
69   function Destructible() public payable { }
70 
71   /**
72    * @dev Transfers the current balance to the owner and terminates the contract.
73    */
74   function destroy() onlyOwner public {
75     selfdestruct(owner);
76   }
77 
78   function destroyAndSend(address _recipient) onlyOwner public {
79     selfdestruct(_recipient);
80   }
81 }
82 
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ShopInterface
91 {
92     ERC20Basic public object;
93     function buyObject(address _beneficiary) public payable;
94 }
95 
96 contract Pausable is Ownable {
97   event Pause();
98   event Unpause();
99 
100   bool public paused = false;
101 
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106   modifier whenNotPaused() {
107     require(!paused);
108     _;
109   }
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is paused.
113    */
114   modifier whenPaused() {
115     require(paused);
116     _;
117   }
118 
119   /**
120    * @dev called by the owner to pause, triggers stopped state
121    */
122   function pause() onlyOwner whenNotPaused public {
123     paused = true;
124     Pause();
125   }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130   function unpause() onlyOwner whenPaused public {
131     paused = false;
132     Unpause();
133   }
134 }
135 
136 contract TokenDestructible is Ownable {
137 
138   function TokenDestructible() public payable { }
139 
140   /**
141    * @notice Terminate contract and refund to owner
142    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
143    refund.
144    * @notice The called token contracts could try to re-enter this contract. Only
145    supply token contracts you trust.
146    */
147   function destroy(address[] tokens) onlyOwner public {
148 
149     // Transfer tokens to owner
150     for (uint256 i = 0; i < tokens.length; i++) {
151       ERC20Basic token = ERC20Basic(tokens[i]);
152       uint256 balance = token.balanceOf(this);
153       token.transfer(owner, balance);
154     }
155 
156     // Transfer Eth to owner and terminate contract
157     selfdestruct(owner);
158   }
159 }
160 
161 library SafeMath {
162 
163   /**
164   * @dev Multiplies two numbers, throws on overflow.
165   */
166   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167     if (a == 0) {
168       return 0;
169     }
170     uint256 c = a * b;
171     assert(c / a == b);
172     return c;
173   }
174 
175   /**
176   * @dev Integer division of two numbers, truncating the quotient.
177   */
178   function div(uint256 a, uint256 b) internal pure returns (uint256) {
179     // assert(b > 0); // Solidity automatically throws when dividing by 0
180     uint256 c = a / b;
181     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182     return c;
183   }
184 
185   /**
186   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
187   */
188   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189     assert(b <= a);
190     return a - b;
191   }
192 
193   /**
194   * @dev Adds two numbers, throws on overflow.
195   */
196   function add(uint256 a, uint256 b) internal pure returns (uint256) {
197     uint256 c = a + b;
198     assert(c >= a);
199     return c;
200   }
201 }
202 
203 contract EthercraftFarm is Ownable, ReentrancyGuard, Destructible, TokenDestructible, Pausable {
204     using SafeMath for uint8;
205     using SafeMath for uint256;
206 
207     /**
208      * EthercraftFarm Front-end:
209      * https://mryellow.github.io/ethercraft_farm_ui/
210      */
211 
212     event Prepped(address indexed shop, address indexed object, uint256 iterations);
213     event Reapped(address indexed object, uint256 balance);
214 
215     mapping (address => mapping (address => uint256)) public balanceOfToken;
216     mapping (address => uint256) public totalOfToken;
217 
218     function() payable public {
219         //owner.transfer(msg.value);
220     }
221 
222     function prep(address _shop, uint8 _iterations) nonReentrant whenNotPaused external {
223         require(_shop != address(0));
224 
225         uint256 _len = 1;
226         if (_iterations > 1)
227             _len = uint256(_iterations);
228 
229         require(_len > 0);
230         ShopInterface shop = ShopInterface(_shop);
231         for (uint256 i = 0; i < _len.mul(100); i++)
232             shop.buyObject(this);
233 
234         address object = shop.object();
235         balanceOfToken[msg.sender][object] = balanceOfToken[msg.sender][object].add(uint256(_len.mul(95 ether)));
236         balanceOfToken[owner][object] = balanceOfToken[owner][object].add(uint256(_len.mul(5 ether)));
237         totalOfToken[object] = totalOfToken[object].add(uint256(_len.mul(100 ether)));
238 
239         Prepped(_shop, object, _len);
240     }
241 
242     function reap(address _object) nonReentrant external {
243         require(_object != address(0));
244         require(balanceOfToken[msg.sender][_object] > 0);
245 
246         // Retrieve any accumulated ETH.
247         if (msg.sender == owner)
248             owner.transfer(this.balance);
249 
250         uint256 balance = balanceOfToken[msg.sender][_object];
251         balance = balance.sub(balance % (1 ether)); // Round to whole token
252         ERC20Basic(_object).transfer(msg.sender, balance);
253         balanceOfToken[msg.sender][_object] = 0;
254         totalOfToken[_object] = totalOfToken[_object].sub(balance);
255 
256         Reapped(_object, balance);
257     }
258 
259     // Recover tokens sent in error
260     function transferAnyERC20Token(address _token, uint256 _value) external onlyOwner returns (bool success) {
261         require(_token != address(0));
262         require(_value > 0);
263         // Whatever remains after subtracting those in vaults
264         require(_value <= ERC20Basic(_token).balanceOf(this).sub(this.totalOfToken(_token)));
265 
266         // Retrieve any accumulated ETH.
267         if (msg.sender == owner)
268             owner.transfer(this.balance);
269 
270         return ERC20Basic(_token).transfer(owner, _value);
271     }
272 
273 }