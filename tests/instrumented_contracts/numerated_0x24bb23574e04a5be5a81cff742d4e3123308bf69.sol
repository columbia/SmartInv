1 // Sources flattened with hardhat v2.7.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `to`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address to, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Contract module which provides a basic access control mechanism, where
114  * there is an account (an owner) that can be granted exclusive access to
115  * specific functions.
116  *
117  * By default, the owner account will be the one that deploys the contract. This
118  * can later be changed with {transferOwnership}.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be applied to your functions to restrict their use to
122  * the owner.
123  */
124 abstract contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor() {
133         _transferOwnership(_msgSender());
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view virtual returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(owner() == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         _transferOwnership(address(0));
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Can only be called by the current owner.
165      */
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Internal function without access restriction.
174      */
175     function _transferOwnership(address newOwner) internal virtual {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 
183 pragma solidity ^0.8.4;
184 
185 
186 contract Claim is Ownable {
187 
188     mapping(uint => bool) used_nonces;
189     address token;
190 
191     struct ClaimRequest {
192         uint256 nonce;
193         uint256 amount;
194         address to;
195         bytes signature;
196     }
197 
198     event ClaimSuccessful(uint256 indexed nonce, uint256 amount, address to);
199     event ClaimCancelled(uint256 indexed nonce);
200 
201     constructor(address _token, address owner) {
202         token = _token;
203         Ownable._transferOwnership(owner);
204     }
205 
206     function verify_signatures(bytes memory signature, bytes memory message) pure public returns(address) {
207         require(signature.length == 65, "invalid signature length");
208 
209         bytes32 message_hash = keccak256(message);
210 
211         bytes32 r;
212         bytes32 s;
213         uint8 v;
214         assembly {
215             r := mload(add(signature, 32))
216             s := mload(add(signature, 64))
217             v := byte(0, mload(add(signature, 96)))
218         }
219         
220         if (v < 27) v += 27;
221 
222         if (v != 27 && v != 28) {
223             return (address(0));
224         } else {
225             // solium-disable-next-line arg-overflow
226             return ecrecover(message_hash, v, r, s);
227         }
228     }
229 
230     function claim(uint256 nonce, uint256 amount, address to, bytes memory signature) public {
231         require(!used_nonces[nonce], "nonce already used");
232         IERC20(token).transfer(to, amount);
233         address signedBy = verify_signatures(signature, abi.encode(nonce, amount, to));
234         require(signedBy == Ownable.owner(), "Invalid signature");
235         used_nonces[nonce] = true;
236         emit ClaimSuccessful(nonce, amount, to);
237     }
238 
239     function claims(ClaimRequest[] memory _claims) public {
240         for (uint i = 0; i < _claims.length; i++) {
241             ClaimRequest memory _claim = _claims[i];
242             claim(_claim.nonce, _claim.amount, _claim.to, _claim.signature);
243         }
244     }
245 
246     function isClaimed(uint256[] memory nonces) view public returns (bool[] memory) {
247         bool[] memory response = new bool[](nonces.length);
248         for (uint i = 0; i < nonces.length; i++) {
249             response[i] = used_nonces[nonces[i]];
250         }
251         return response;
252     }
253 
254     function cancelClaims(uint256[] memory nonces) public {
255         for (uint i = 0; i < nonces.length; i++) {
256             used_nonces[nonces[i]] = true;
257             emit ClaimCancelled(nonces[i]);
258         }
259     }
260 }