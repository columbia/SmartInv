1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-12
3  */
4 
5 // SPDX-License-Identifier: AGPL-3.0-or-later
6 pragma solidity 0.7.5;
7 
8 interface IERC20 {
9     function decimals() external view returns (uint8);
10 
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.stakingHelper_address
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount)
29         external
30         returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 interface IStaking {
95     function stake(uint256 _amount, address _recipient) external returns (bool);
96 
97     function claim(address _recipient) external;
98 }
99 
100 contract StakingHelper {
101     address public immutable staking;
102     address public immutable ASG;
103 
104     constructor(address _staking, address _ASG) {
105         require(_staking != address(0));
106         staking = _staking;
107         require(_ASG != address(0));
108         ASG = _ASG;
109     }
110 
111     function stake(uint256 _amount, address _recipient) external {
112         IERC20(ASG).transferFrom(msg.sender, address(this), _amount);
113         IERC20(ASG).approve(staking, _amount);
114         IStaking(staking).stake(_amount, _recipient);
115         IStaking(staking).claim(_recipient);
116     }
117 }