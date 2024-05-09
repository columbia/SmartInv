1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 interface IERC20 {
5   function decimals() external view returns (uint8);
6 
7   /**
8    * @dev Returns the amount of tokens in existence.
9    */
10   function totalSupply() external view returns (uint256);
11 
12   /**
13    * @dev Returns the amount of tokens owned by `account`.
14    */
15   function balanceOf(address account) external view returns (uint256);
16 
17   /**
18    * @dev Moves `amount` tokens from the caller's account to `recipient`.
19    *
20    * Returns a boolean value indicating whether the operation succeeded.
21    *
22    * Emits a {Transfer} event.
23    */
24   function transfer(address recipient, uint256 amount) external returns (bool);
25 
26   /**
27    * @dev Returns the remaining number of tokens that `spender` will be
28    * allowed to spend on behalf of `owner` through {transferFrom}. This is
29    * zero by default.
30    *
31    * This value changes when {approve} or {transferFrom} are called.
32    */
33   function allowance(address owner, address spender)
34     external
35     view
36     returns (uint256);
37 
38   /**
39    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40    *
41    * Returns a boolean value indicating whether the operation succeeded.
42    *
43    * IMPORTANT: Beware that changing an allowance with this method brings the risk
44    * that someone may use both the old and the new allowance by unfortunate
45    * transaction ordering. One possible solution to mitigate this race
46    * condition is to first reduce the spender's allowance to 0 and set the
47    * desired value afterwards:
48    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49    *
50    * Emits an {Approval} event.
51    */
52   function approve(address spender, uint256 amount) external returns (bool);
53 
54   /**
55    * @dev Moves `amount` tokens from `sender` to `recipient` using the
56    * allowance mechanism. `amount` is then deducted from the caller's
57    * allowance.
58    *
59    * Returns a boolean value indicating whether the operation succeeded.
60    *
61    * Emits a {Transfer} event.
62    */
63   function transferFrom(
64     address sender,
65     address recipient,
66     uint256 amount
67   ) external returns (bool);
68 
69   /**
70    * @dev Emitted when `value` tokens are moved from one account (`from`) to
71    * another (`to`).
72    *
73    * Note that `value` may be zero.
74    */
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 
77   /**
78    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79    * a call to {approve}. `value` is the new allowance.
80    */
81   event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 interface IStaking {
85   function stake(uint256 _amount, address _recipient) external returns (bool);
86 
87   function claim(address _recipient) external;
88 }
89 
90 contract StakingHelper {
91   address public immutable staking;
92   address public immutable LOBI;
93 
94   constructor(address _staking, address _LOBI) {
95     require(_staking != address(0));
96     staking = _staking;
97     require(_LOBI != address(0));
98     LOBI = _LOBI;
99   }
100 
101   function stake(uint256 _amount, address _recipient) external {
102     IERC20(LOBI).transferFrom(msg.sender, address(this), _amount);
103     IERC20(LOBI).approve(staking, _amount);
104     IStaking(staking).stake(_amount, _recipient);
105     IStaking(staking).claim(_recipient);
106   }
107 }