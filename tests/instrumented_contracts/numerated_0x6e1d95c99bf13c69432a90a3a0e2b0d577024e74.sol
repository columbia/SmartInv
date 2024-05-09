1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby disabling any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Contract module that helps prevent reentrant calls to a function.
124  *
125  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
126  * available, which can be applied to functions to make sure there are no nested
127  * (reentrant) calls to them.
128  *
129  * Note that because there is a single `nonReentrant` guard, functions marked as
130  * `nonReentrant` may not call one another. This can be worked around by making
131  * those functions `private`, and then adding `external` `nonReentrant` entry
132  * points to them.
133  *
134  * TIP: If you would like to learn more about reentrancy and alternative ways
135  * to protect against it, check out our blog post
136  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
137  */
138 abstract contract ReentrancyGuard {
139     // Booleans are more expensive than uint256 or any type that takes up a full
140     // word because each write operation emits an extra SLOAD to first read the
141     // slot's contents, replace the bits taken up by the boolean, and then write
142     // back. This is the compiler's defense against contract upgrades and
143     // pointer aliasing, and it cannot be disabled.
144 
145     // The values being non-zero value makes deployment a bit more expensive,
146     // but in exchange the refund on every call to nonReentrant will be lower in
147     // amount. Since refunds are capped to a percentage of the total
148     // transaction's gas, it is best to keep them low in cases like this one, to
149     // increase the likelihood of the full refund coming into effect.
150     uint256 private constant _NOT_ENTERED = 1;
151     uint256 private constant _ENTERED = 2;
152 
153     uint256 private _status;
154 
155     constructor() {
156         _status = _NOT_ENTERED;
157     }
158 
159     /**
160      * @dev Prevents a contract from calling itself, directly or indirectly.
161      * Calling a `nonReentrant` function from another `nonReentrant`
162      * function is not supported. It is possible to prevent this from happening
163      * by making the `nonReentrant` function external, and making it call a
164      * `private` function that does the actual work.
165      */
166     modifier nonReentrant() {
167         _nonReentrantBefore();
168         _;
169         _nonReentrantAfter();
170     }
171 
172     function _nonReentrantBefore() private {
173         // On the first call to nonReentrant, _status will be _NOT_ENTERED
174         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
175 
176         // Any calls to nonReentrant after this point will fail
177         _status = _ENTERED;
178     }
179 
180     function _nonReentrantAfter() private {
181         // By storing the original value once again, a refund is triggered (see
182         // https://eips.ethereum.org/EIPS/eip-2200)
183         _status = _NOT_ENTERED;
184     }
185 
186     /**
187      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
188      * `nonReentrant` function in the call stack.
189      */
190     function _reentrancyGuardEntered() internal view returns (bool) {
191         return _status == _ENTERED;
192     }
193 }
194 
195 // File: contracts/NetjammersPond.sol
196 
197 
198 
199 
200 
201 pragma solidity ^0.8.18;
202 
203 interface Netjammers {
204     function balanceOf(address owner) external view returns (uint256 balance);
205     function totalSupply() external view returns (uint256);
206     function Airdrop(uint256 _mintAmount, address _receiver) external;
207     function withdraw() external;
208     function setSaleStatus(bool _sale) external;
209     function transferOwnership(address newOwner) external;
210 }
211 
212 interface IERC20 {
213     function transfer(address _to, uint256 _amount) external returns (bool);
214     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
215     function balanceOf(address _owner) external returns (uint256);
216     function approve(address spender, uint256 amount) external returns (bool);
217     function allowance(address owner, address spender) external view returns (uint256);
218 }
219 
220 /*
221  _   _  _____ _____  ___  ___  ___  ______  ___ ___________  _____ 
222 | \ | ||  ___|_   _||_  |/ _ \ |  \/  ||  \/  ||  ___| ___ \/  ___|
223 |  \| || |__   | |    | / /_\ \| .  . || .  . || |__ | |_/ /\ `--. 
224 | . ` ||  __|  | |    | |  _  || |\/| || |\/| ||  __||    /  `--. \
225 | |\  || |___  | |/\__/ / | | || |  | || |  | || |___| |\ \ /\__/ /
226 \_| \_/\____/  \_/\____/\_| |_/\_|  |_/\_|  |_/\____/\_| \_|\____/ 
227                    ~we're dipping into the pond~
228 */
229 
230 // Proxy contract to handle Pond mints.
231 contract NetjammersPond is Ownable, ReentrancyGuard {
232     Netjammers public nj;
233     IERC20 public pond;
234     uint256 public freeMintCount = 0;
235     uint256 public maxFreeMintCount = 500;
236     uint256 public freeMintMax = 1;
237     uint256 public pondBalance = 10000000000000000000000000; // 10 million $PNDC held for free mint
238     uint256 public pondPrice = 18000000000000000000000000; // 18 million $PNDC
239     mapping (address => uint) freeMintedPondHolder;
240 
241     constructor (address _contractAddress, address _pondContractAddress) {
242         nj = Netjammers(_contractAddress);
243         pond = IERC20(_pondContractAddress);
244     }
245 
246     function setPondPrice(uint256 _price) public onlyOwner {
247         pondPrice = _price;
248     }
249 
250     function setPondBalance(uint256 _price) public onlyOwner {
251         pondBalance = _price;
252     }
253 
254     function setFreeMintMax(uint256 _amt) public onlyOwner {
255         freeMintMax = _amt;
256     }
257     
258     function setSaleStatus(bool _sale) public onlyOwner {
259         nj.setSaleStatus(_sale);
260     }
261 
262     function acceptPayment(uint256 _amt) public returns(bool) {
263        require(pond.allowance(msg.sender, address(this)) >= _amt, "Please approve tokens for transaction");
264        pond.transferFrom(msg.sender, address(this), _amt);
265        return true;
266     }
267 
268     function freeMinted() public view returns (uint256) {
269         return freeMintCount;
270     }
271 
272     function freeMint () public {
273         require(pond.balanceOf(msg.sender) >= pondBalance, "Gotta hold more $PNDC!");
274         require(freeMintMax > freeMintedPondHolder[msg.sender], "You got your free mint already");
275         require(nj.totalSupply() + 1 <= 10000, "Max supply exceeded!");
276         require(500 > freeMintCount, "Free mints exhausted");
277         unchecked {
278             freeMintedPondHolder[msg.sender]++;
279             freeMintCount++;
280         }
281         nj.Airdrop(1, msg.sender);
282     }
283 
284     function mint (uint256 _mintAmount) public payable {
285         require(_mintAmount > 0 && _mintAmount <= 10, "Invalid mint amount");
286         require(nj.totalSupply() + _mintAmount <= 10000, "Max supply exceeded!");
287         require(nj.balanceOf(msg.sender) + _mintAmount <= 20, "Max mint per wallet exceeded");
288         require(pond.balanceOf(msg.sender) >= pondPrice * _mintAmount, "Insufficient funds");
289         require(acceptPayment(_mintAmount * pondPrice), "Payment failed");
290         nj.Airdrop(_mintAmount, msg.sender);
291     }
292 
293     function transferParentOwnership (address newOwner) public onlyOwner {
294         nj.transferOwnership(newOwner);
295     }
296 
297     // Withdraw all funds from parent contract to this contract, then to owner
298     function withdrawAllBalances() external onlyOwner nonReentrant {
299         nj.withdraw();
300         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
301         require(success, "Transaction Failed");
302         pond.transfer(owner(), pond.balanceOf(address(this)));
303     }
304 
305     function withdrawPond() external onlyOwner {
306         pond.transfer(owner(), pond.balanceOf(address(this)));
307     }
308 
309     fallback() external payable {
310     }
311 
312     receive() external payable {
313     }
314 
315     function getBalance() public view returns (uint256) {
316         return address(this).balance;
317     }
318 }