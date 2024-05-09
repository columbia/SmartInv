1 pragma solidity ^0.5.7;
2 
3 
4 // Send more than WEI_MIN (init = 1 ETH) for 1002 Wesions, and get unused ETH refund automatically.
5 //   Use the current Wesion price of Wesion Public-Sale.
6 //
7 // Conditions:
8 //   1. You have no Wesion yet.
9 //   2. You are not in the whitelist yet.
10 //   3. Send more than 1 ETH (for balance verification).
11 //
12 
13 /**
14  * @title SafeMath for uint256
15  * @dev Unsigned math operations with safety checks that revert on error.
16  */
17 library SafeMath256 {
18     /**
19      * @dev Adds two unsigned integers, reverts on overflow.
20      */
21     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 
27     /**
28      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36      * @dev Multiplies two unsigned integers, reverts on overflow.
37      */
38     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39         if (a == 0) {
40             return 0;
41         }
42         c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     /**
48      * @dev Integer division of two unsigned integers truncating the quotient,
49      * reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b > 0);
53         uint256 c = a / b;
54         assert(a == b * c + a % b);
55         return a / b;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 /**
70  * @title Ownable
71  */
72 contract Ownable {
73     address private _owner;
74     address payable internal _receiver;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract
81      * to the sender account.
82      */
83     constructor () internal {
84         _owner = msg.sender;
85         _receiver = msg.sender;
86     }
87 
88     /**
89      * @return The address of the owner.
90      */
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         require(msg.sender == _owner);
100         _;
101     }
102 
103     /**
104      * @dev Allows the current owner to transfer control of the contract to a newOwner.
105      * @param newOwner The address to transfer ownership to.
106      */
107     function transferOwnership(address newOwner) external onlyOwner {
108         require(newOwner != address(0));
109         address __previousOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(__previousOwner, newOwner);
112     }
113 
114     /**
115      * @dev Change receiver.
116      */
117     function changeReceiver(address payable newReceiver) external onlyOwner {
118         require(newReceiver != address(0));
119         address __previousReceiver = _receiver;
120         _receiver = newReceiver;
121         emit ReceiverChanged(__previousReceiver, newReceiver);
122     }
123 
124     /**
125      * @dev Rescue compatible ERC20 Token
126      *
127      * @param tokenAddr ERC20 The address of the ERC20 token contract
128      * @param receiver The address of the receiver
129      * @param amount uint256
130      */
131     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
132         IERC20 _token = IERC20(tokenAddr);
133         require(receiver != address(0));
134         uint256 balance = _token.balanceOf(address(this));
135         require(balance >= amount);
136 
137         assert(_token.transfer(receiver, amount));
138     }
139 
140     /**
141      * @dev Withdraw ether
142      */
143     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
144         require(to != address(0));
145         uint256 balance = address(this).balance;
146         require(balance >= amount);
147 
148         to.transfer(amount);
149     }
150 }
151 
152 
153 /**
154  * @title Pausable
155  * @dev Base contract which allows children to implement an emergency stop mechanism.
156  */
157 contract Pausable is Ownable {
158     bool private _paused;
159 
160     event Paused(address account);
161     event Unpaused(address account);
162 
163     constructor () internal {
164         _paused = false;
165     }
166 
167     /**
168      * @return Returns true if the contract is paused, false otherwise.
169      */
170     function paused() public view returns (bool) {
171         return _paused;
172     }
173 
174     /**
175      * @dev Modifier to make a function callable only when the contract is not paused.
176      */
177     modifier whenNotPaused() {
178         require(!_paused, "Paused.");
179         _;
180     }
181 
182     /**
183      * @dev Called by a pauser to pause, triggers stopped state.
184      */
185     function setPaused(bool state) external onlyOwner {
186         if (_paused && !state) {
187             _paused = false;
188             emit Unpaused(msg.sender);
189         } else if (!_paused && state) {
190             _paused = true;
191             emit Paused(msg.sender);
192         }
193     }
194 }
195 
196 
197 /**
198  * @title ERC20 interface
199  * @dev see https://eips.ethereum.org/EIPS/eip-20
200  */
201 interface IERC20 {
202     function balanceOf(address owner) external view returns (uint256);
203     function transfer(address to, uint256 value) external returns (bool);
204 }
205 
206 
207 /**
208  * @title Wesion interface
209  */
210 interface IWesion {
211     function balanceOf(address owner) external view returns (uint256);
212     function transfer(address to, uint256 value) external returns (bool);
213     function inWhitelist(address account) external view returns (bool);
214 }
215 
216 
217 /**
218  * @title Wesion Public-Sale interface
219  */
220 interface IWesionPublicSale {
221     function status() external view returns (uint256 auditEtherPrice,
222                                              uint16 stage,
223                                              uint16 season,
224                                              uint256 WesionUsdPrice,
225                                              uint256 currentTopSalesRatio,
226                                              uint256 txs,
227                                              uint256 WesionTxs,
228                                              uint256 WesionBonusTxs,
229                                              uint256 WesionWhitelistTxs,
230                                              uint256 WesionIssued,
231                                              uint256 WesionBonus,
232                                              uint256 WesionWhitelist);
233 }
234 
235 
236 /**
237  * @title Get 1002 Wesion
238  */
239 contract Get1002Wesion is Ownable, Pausable {
240     using SafeMath256 for uint256;
241 
242     IWesion public Wesion = IWesion(0xF0921CF26f6BA21739530ccA9ba2548bB34308f1);
243     IWesionPublicSale public Wesion_PUBLIC_SALE = IWesionPublicSale(0xf988df5509Af01cC5B76FF1Fa3ED3b5F31BAaF84);
244 
245     uint256 public WEI_MIN = 1 ether;
246     uint256 private Wesion_PER_TXN = 1002000000; // 1002.000000 Wesion
247 
248     uint256 private _txs;
249 
250     mapping (address => bool) _alreadyGot;
251 
252     event Tx(uint256 etherPrice, uint256 vokdnUsdPrice, uint256 weiUsed);
253 
254     /**
255      * @dev Transaction counter
256      */
257     function txs() public view returns (uint256) {
258         return _txs;
259     }
260 
261     function setWeiMin(uint256 weiMin) public onlyOwner {
262         WEI_MIN = weiMin;
263     }
264 
265     /**
266      * @dev Get 1002 Wesion and ETH refund.
267      */
268     function () external payable whenNotPaused {
269         require(msg.value >= WEI_MIN);
270         require(Wesion.balanceOf(address(this)) >= Wesion_PER_TXN);
271         require(Wesion.balanceOf(msg.sender) == 0);
272         require(!Wesion.inWhitelist(msg.sender));
273         require(!_alreadyGot[msg.sender]);
274 
275         uint256 __etherPrice;
276         uint256 __WesionUsdPrice;
277         (__etherPrice, , , __WesionUsdPrice, , , , , , , ,) = Wesion_PUBLIC_SALE.status();
278 
279         require(__etherPrice > 0);
280 
281         uint256 __usd = Wesion_PER_TXN.mul(__WesionUsdPrice).div(1000000);
282         uint256 __wei = __usd.mul(1 ether).div(__etherPrice);
283 
284         require(msg.value >= __wei);
285 
286         if (msg.value > __wei) {
287             msg.sender.transfer(msg.value.sub(__wei));
288             _receiver.transfer(__wei);
289         }
290 
291         _txs = _txs.add(1);
292         _alreadyGot[msg.sender] = true;
293         emit Tx(__etherPrice, __WesionUsdPrice, __wei);
294 
295         assert(Wesion.transfer(msg.sender, Wesion_PER_TXN));
296     }
297 }