1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 
5 interface IERC20 {
6     function decimals() external view returns (uint8);
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
33   function allowance(address owner, address spender) external view returns (uint256);
34 
35   /**
36    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37    *
38    * Returns a boolean value indicating whether the operation succeeded.
39    *
40    * IMPORTANT: Beware that changing an allowance with this method brings the risk
41    * that someone may use both the old and the new allowance by unfortunate
42    * transaction ordering. One possible solution to mitigate this race
43    * condition is to first reduce the spender's allowance to 0 and set the
44    * desired value afterwards:
45    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46    *
47    * Emits an {Approval} event.
48    */
49   function approve(address spender, uint256 amount) external returns (bool);
50 
51   /**
52    * @dev Moves `amount` tokens from `sender` to `recipient` using the
53    * allowance mechanism. `amount` is then deducted from the caller's
54    * allowance.
55    *
56    * Returns a boolean value indicating whether the operation succeeded.
57    *
58    * Emits a {Transfer} event.
59    */
60   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62   /**
63    * @dev Emitted when `value` tokens are moved from one account (`from`) to
64    * another (`to`).
65    *
66    * Note that `value` may be zero.
67    */
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 
70   /**
71    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72    * a call to {approve}. `value` is the new allowance.
73    */
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 interface IStaking {
78     function stake( uint _amount, address _recipient ) external returns ( bool );
79     function claim( address _recipient ) external;
80 }
81 
82 contract StakingHelper {
83 
84     address public immutable staking;
85     address public immutable BTRFLY;
86 
87     constructor ( address _staking, address _BTRFLY ) {
88         require( _staking != address(0) );
89         staking = _staking;
90         require( _BTRFLY != address(0) );
91         BTRFLY = _BTRFLY;
92     }
93 
94     function stake( uint _amount ) external {
95         IERC20( BTRFLY ).transferFrom( msg.sender, address(this), _amount );
96         IERC20( BTRFLY ).approve( staking, _amount );
97         IStaking( staking ).stake( _amount, msg.sender );
98         IStaking( staking ).claim( msg.sender );
99     }
100 }