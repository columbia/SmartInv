1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }