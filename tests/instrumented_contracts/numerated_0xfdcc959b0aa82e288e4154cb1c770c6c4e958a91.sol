1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/Redeemer.sol
4 // SPDX-License-Identifier: MIT
5 pragma solidity >=0.8.0 <0.9.0;
6 
7 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
8 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
9 
10 /* pragma solidity ^0.8.0; */
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
33 // OpenZeppelin Contracts v4.3.2 (access/Ownable.sol)
34 
35 /* pragma solidity ^0.8.0; */
36 
37 /* import "../utils/Context.sol"; */
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
110 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
111 
112 /* pragma solidity ^0.8.0; */
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) external returns (bool);
176 
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 ////// src/Redeemer.sol
193 /* pragma solidity ^0.8.0; */
194 
195 /* import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; */
196 /* import "@openzeppelin/contracts/access/Ownable.sol"; */
197 
198 /**
199  * @dev A Redeemer contract
200  */
201 contract Redeemer is Ownable {
202     IERC20 immutable public grid;
203     IERC20 immutable public phon;
204     uint256 immutable public deadline;
205     uint256 constant internal MULTIPLIER = 155e18; // Phonon tokens per Grid
206 
207     uint256 constant internal WAD = 10 ** 18;
208 
209     function add(uint x, uint y) internal pure returns (uint z) {
210         require((z = x + y) >= x, "ds-math-add-overflow");
211     }
212 
213      function mul(uint x, uint y) internal pure returns (uint z) {
214         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
215     }
216 
217     //rounds to zero if x*y < WAD / 2
218     function wmul(uint x, uint y) internal pure returns (uint z) {
219         z = add(mul(x, y), WAD / 2) / WAD;
220     }
221 
222     /**
223      * @dev Constructor
224      * @param _grid Old GRID token to be locked up
225      * @param _phon New PHONON token to be distributed
226      * @param _deadline When contract owner can withdraw PHONON tokens
227      */
228     constructor(IERC20 _grid, IERC20 _phon, uint256 _deadline) {
229         grid = _grid;
230         phon = _phon;
231         deadline = _deadline;
232     }
233 
234     function redeem() external {
235         uint256 amount = grid.balanceOf(msg.sender);
236         require(grid.transferFrom(msg.sender, address(this), amount), "Redeemer: could not transfer GRID.");
237         require(phon.transfer(msg.sender, wmul(amount * 10 ** 6, MULTIPLIER) ), "Redeemer: could not transfer PHONON.");
238     }
239 
240     /**
241      * @notice Withdraws PHONON tokens from the contract.
242      */
243     function withdraw() external onlyOwner {
244         require(
245             block.timestamp >= deadline,
246             "Redeemer: Can't withdraw"
247         );
248         require(phon.transfer(owner(), phon.balanceOf(address(this))), "Redeemer: withdraw failed");
249     }
250 }
