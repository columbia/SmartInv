1 pragma solidity ^0.5.7;
2 
3 
4 // Send more than 1 ETH for 1002 Vokens, and get unused ETH refund automatically.
5 //   Use the current voken price of Voken Public-Sale.
6 //
7 // Conditions:
8 //   1. You have no Voken yet.
9 //   2. You are not in the whitelist yet.
10 //   3. Send more than 1 ETH (for balance verification).
11 //
12 // More info:
13 //   https://vision.network
14 //   https://voken.io
15 //
16 // Contact us:
17 //   support@vision.network
18 //   support@voken.io
19 
20 
21 /**
22  * @title SafeMath for uint256
23  * @dev Unsigned math operations with safety checks that revert on error.
24  */
25 library SafeMath256 {
26     /**
27      * @dev Adds two unsigned integers, reverts on overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 
35     /**
36      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44      * @dev Multiplies two unsigned integers, reverts on overflow.
45      */
46     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         if (a == 0) {
48             return 0;
49         }
50         c = a * b;
51         assert(c / a == b);
52         return c;
53     }
54 
55     /**
56      * @dev Integer division of two unsigned integers truncating the quotient,
57      * reverts on division by zero.
58      */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         assert(b > 0);
61         uint256 c = a / b;
62         assert(a == b * c + a % b);
63         return a / b;
64     }
65 
66     /**
67      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
68      * reverts when dividing by zero.
69      */
70     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b != 0);
72         return a % b;
73     }
74 }
75 
76 
77 /**
78  * @title Ownable
79  */
80 contract Ownable {
81     address private _owner;
82     address payable internal _receiver;
83 
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
86 
87     /**
88      * @dev The Ownable constructor sets the original `owner` of the contract
89      * to the sender account.
90      */
91     constructor () internal {
92         _owner = msg.sender;
93         _receiver = msg.sender;
94     }
95 
96     /**
97      * @return The address of the owner.
98      */
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(msg.sender == _owner);
108         _;
109     }
110 
111     /**
112      * @dev Allows the current owner to transfer control of the contract to a newOwner.
113      * @param newOwner The address to transfer ownership to.
114      */
115     function transferOwnership(address newOwner) external onlyOwner {
116         require(newOwner != address(0));
117         address __previousOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(__previousOwner, newOwner);
120     }
121 
122     /**
123      * @dev Change receiver.
124      */
125     function changeReceiver(address payable newReceiver) external onlyOwner {
126         require(newReceiver != address(0));
127         address __previousReceiver = _receiver;
128         _receiver = newReceiver;
129         emit ReceiverChanged(__previousReceiver, newReceiver);
130     }
131 
132     /**
133      * @dev Rescue compatible ERC20 Token
134      *
135      * @param tokenAddr ERC20 The address of the ERC20 token contract
136      * @param receiver The address of the receiver
137      * @param amount uint256
138      */
139     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
140         IERC20 _token = IERC20(tokenAddr);
141         require(receiver != address(0));
142         uint256 balance = _token.balanceOf(address(this));
143         require(balance >= amount);
144 
145         assert(_token.transfer(receiver, amount));
146     }
147 
148     /**
149      * @dev Withdraw ether
150      */
151     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
152         require(to != address(0));
153         uint256 balance = address(this).balance;
154         require(balance >= amount);
155 
156         to.transfer(amount);
157     }
158 }
159 
160 
161 /**
162  * @title Pausable
163  * @dev Base contract which allows children to implement an emergency stop mechanism.
164  */
165 contract Pausable is Ownable {
166     bool private _paused;
167 
168     event Paused(address account);
169     event Unpaused(address account);
170 
171     constructor () internal {
172         _paused = false;
173     }
174 
175     /**
176      * @return Returns true if the contract is paused, false otherwise.
177      */
178     function paused() public view returns (bool) {
179         return _paused;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is not paused.
184      */
185     modifier whenNotPaused() {
186         require(!_paused, "Paused.");
187         _;
188     }
189 
190     /**
191      * @dev Called by a pauser to pause, triggers stopped state.
192      */
193     function setPaused(bool state) external onlyOwner {
194         if (_paused && !state) {
195             _paused = false;
196             emit Unpaused(msg.sender);
197         } else if (!_paused && state) {
198             _paused = true;
199             emit Paused(msg.sender);
200         }
201     }
202 }
203 
204 
205 /**
206  * @title ERC20 interface
207  * @dev see https://eips.ethereum.org/EIPS/eip-20
208  */
209 interface IERC20 {
210     function balanceOf(address owner) external view returns (uint256);
211     function transfer(address to, uint256 value) external returns (bool);
212 }
213 
214 
215 /**
216  * @title Voken interface
217  */
218 interface IVoken {
219     function balanceOf(address owner) external view returns (uint256);
220     function transfer(address to, uint256 value) external returns (bool);
221     function inWhitelist(address account) external view returns (bool);
222 }
223 
224 
225 /**
226  * @title Voken Public-Sale interface
227  */
228 interface IVokenPublicSale {
229     function status() external view returns (uint256 auditEtherPrice,
230                                              uint16 stage,
231                                              uint16 season,
232                                              uint256 vokenUsdPrice,
233                                              uint256 currentTopSalesRatio,
234                                              uint256 txs,
235                                              uint256 vokenTxs,
236                                              uint256 vokenBonusTxs,
237                                              uint256 vokenWhitelistTxs,
238                                              uint256 vokenIssued,
239                                              uint256 vokenBonus,
240                                              uint256 vokenWhitelist);
241 }
242 
243 
244 /**
245  * @title Get 1002 Voken
246  */
247 contract Get1002Voken is Ownable, Pausable {
248     using SafeMath256 for uint256;
249 
250     IVoken public VOKEN = IVoken(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
251     IVokenPublicSale public VOKEN_PUBLIC_SALE = IVokenPublicSale(0xAC873993E43A5AF7B39aB4A5a50ce1FbDb7191D3);
252 
253     uint256 private WEI_MIN = 1 ether;
254     uint256 private VOKEN_PER_TXN = 1002000000; // 1002.000000 Voken
255 
256     uint256 private _txs;
257     
258     mapping (address => bool) _alreadyGot;
259 
260     event Tx(uint256 etherPrice, uint256 vokdnUsdPrice, uint256 weiUsed);
261 
262     /**
263      * @dev Transaction counter
264      */
265     function txs() public view returns (uint256) {
266         return _txs;
267     }
268 
269     /**
270      * @dev Get 1002 Voken and ETH refund.
271      */
272     function () external payable whenNotPaused {
273         require(msg.value >= WEI_MIN);
274         require(VOKEN.balanceOf(address(this)) >= VOKEN_PER_TXN);
275         require(VOKEN.balanceOf(msg.sender) == 0);
276         require(!VOKEN.inWhitelist(msg.sender));
277         require(!_alreadyGot[msg.sender]);
278 
279         uint256 __etherPrice;
280         uint256 __vokenUsdPrice;
281         (__etherPrice, , , __vokenUsdPrice, , , , , , , ,) = VOKEN_PUBLIC_SALE.status();
282 
283         require(__etherPrice > 0);
284 
285         uint256 __usd = VOKEN_PER_TXN.mul(__vokenUsdPrice).div(1000000);
286         uint256 __wei = __usd.mul(1 ether).div(__etherPrice);
287 
288         require(msg.value >= __wei);
289 
290         if (msg.value > __wei) {
291             msg.sender.transfer(msg.value.sub(__wei));
292             _receiver.transfer(__wei);
293         }
294 
295         _txs = _txs.add(1);
296         _alreadyGot[msg.sender] = true;
297         emit Tx(__etherPrice, __vokenUsdPrice, __wei);
298 
299         assert(VOKEN.transfer(msg.sender, VOKEN_PER_TXN));
300     }
301 }