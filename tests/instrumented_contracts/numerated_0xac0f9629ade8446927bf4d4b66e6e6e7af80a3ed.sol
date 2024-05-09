1 // File: contracts/IWabipunks.sol
2 
3 pragma solidity ^0.8.7;
4 interface IWabipunks {
5      function mint(uint256 amount, address to) external;
6 }
7 // File: @openzeppelin/contracts/utils/Context.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/access/Ownable.sol
35 
36 
37 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 // File: @openzeppelin/contracts/security/Pausable.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Contract module which allows children to implement an emergency stop
122  * mechanism that can be triggered by an authorized account.
123  *
124  * This module is used through inheritance. It will make available the
125  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
126  * the functions of your contract. Note that they will not be pausable by
127  * simply including this module, only once the modifiers are put in place.
128  */
129 abstract contract Pausable is Context {
130     /**
131      * @dev Emitted when the pause is triggered by `account`.
132      */
133     event Paused(address account);
134 
135     /**
136      * @dev Emitted when the pause is lifted by `account`.
137      */
138     event Unpaused(address account);
139 
140     bool private _paused;
141 
142     /**
143      * @dev Initializes the contract in unpaused state.
144      */
145     constructor() {
146         _paused = false;
147     }
148 
149     /**
150      * @dev Returns true if the contract is paused, and false otherwise.
151      */
152     function paused() public view virtual returns (bool) {
153         return _paused;
154     }
155 
156     /**
157      * @dev Modifier to make a function callable only when the contract is not paused.
158      *
159      * Requirements:
160      *
161      * - The contract must not be paused.
162      */
163     modifier whenNotPaused() {
164         require(!paused(), "Pausable: paused");
165         _;
166     }
167 
168     /**
169      * @dev Modifier to make a function callable only when the contract is paused.
170      *
171      * Requirements:
172      *
173      * - The contract must be paused.
174      */
175     modifier whenPaused() {
176         require(paused(), "Pausable: not paused");
177         _;
178     }
179 
180     /**
181      * @dev Triggers stopped state.
182      *
183      * Requirements:
184      *
185      * - The contract must not be paused.
186      */
187     function _pause() internal virtual whenNotPaused {
188         _paused = true;
189         emit Paused(_msgSender());
190     }
191 
192     /**
193      * @dev Returns to normal state.
194      *
195      * Requirements:
196      *
197      * - The contract must be paused.
198      */
199     function _unpause() internal virtual whenPaused {
200         _paused = false;
201         emit Unpaused(_msgSender());
202     }
203 }
204 
205 // File: contracts/Wabistore.sol
206 
207 pragma solidity ^0.8.7;
208 
209 
210 
211 contract WabiStore is Pausable, Ownable {
212   address payable private wabiWallet;
213   uint256 public _price = 0.05 ether;
214   IWabipunks wabiPunks = IWabipunks(0x427226f7336a9975ceca338ED9a75B5799f995Df);
215   constructor(
216   ){
217   }
218 
219   /**
220         @dev Mint new token and maps to receiver
221     */
222   function mint(uint256 amount)
223     external
224     payable
225     whenNotPaused
226   {
227     require(msg.value >= amount*_price, "WabiStore: msg.value is less than total price");
228     wabiPunks.mint(amount, msg.sender);
229   }
230 
231 
232   function updatePrice(uint256 _newPrice) external onlyOwner {
233     _price = _newPrice;
234   } 
235   /**
236     @dev Withdraw ETH balance to the owner
237      */
238   function withdraw() external onlyOwner {
239     payable(owner()).transfer(address(this).balance);
240   }
241   function pause() external onlyOwner {
242     _pause();
243   }
244 
245   function unPause() external onlyOwner {
246     _unpause();
247   }
248 }