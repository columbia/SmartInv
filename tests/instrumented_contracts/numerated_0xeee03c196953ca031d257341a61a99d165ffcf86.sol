1 pragma solidity 0.4.24;
2 
3 
4 contract ERC20 {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   function allowance(address owner, address spender)
9     public view returns (uint256);
10 
11   function transferFrom(address from, address to, uint256 value)
12     public returns (bool);
13 
14   function approve(address spender, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(
17     address indexed owner,
18     address indexed spender,
19     uint256 value
20   );
21 }
22 
23 
24 library SafeERC20 {
25   function safeTransfer(ERC20 token, address to, uint256 value) internal {
26     require(token.transfer(to, value));
27   }
28 
29   function safeTransferFrom(
30     ERC20 token,
31     address from,
32     address to,
33     uint256 value
34   )
35     internal
36   {
37     require(token.transferFrom(from, to, value));
38   }
39 
40   function safeApprove(ERC20 token, address spender, uint256 value) internal {
41     require(token.approve(spender, value));
42   }
43 }
44 
45 
46 /**
47  * @title TokenTimelock
48  * @dev TokenTimelock is a token holder contract that will allow a
49  * beneficiary to extract the tokens after a given release time
50  */
51 contract CGCXTimelock {
52   using SafeERC20 for ERC20;
53 
54   // ERC20 basic token contract being held
55   ERC20 public token;
56 
57   // beneficiary of tokens after they are released
58   address public beneficiary;
59 
60   // timestamp when token release is enabled
61   uint256 public firstReleaseTime;
62   uint256 public secondReleaseTime;
63   uint256 public thirdReleaseTime;
64   uint256 public fourthReleaseTime;
65 
66   constructor(
67     address _token,
68     address _beneficiary,
69     uint256 _firstLockupInDays,
70     uint256 _secondLockupInDays,
71     uint256 _thirdLockupInDays,
72     uint256 _fourthLockupInDays
73   )
74     public
75   {
76     require(_beneficiary != address(0));
77     // solium-disable-next-line security/no-block-members
78     require(_firstLockupInDays > 0);
79     require(_secondLockupInDays > 0);
80     require(_thirdLockupInDays > 0);
81     require(_fourthLockupInDays > 0);
82     token = ERC20(_token);
83     beneficiary = _beneficiary;
84     firstReleaseTime = now + _firstLockupInDays * 1 minutes;
85     secondReleaseTime = now + _secondLockupInDays * 1 minutes;
86     thirdReleaseTime = now + _thirdLockupInDays * 1 minutes;
87     fourthReleaseTime = now + _fourthLockupInDays * 1 minutes;
88   }
89 
90   /**
91    * @notice Transfers tokens held by timelock to beneficiary.
92    */
93   function release() public {
94     uint256 amount;
95     // solium-disable-next-line security/no-block-members
96     if (fourthReleaseTime != 0 && block.timestamp >= fourthReleaseTime) {
97       amount = token.balanceOf(this);
98       require(amount > 0);
99       token.safeTransfer(beneficiary, amount);
100       fourthReleaseTime = 0;
101     } else if (thirdReleaseTime != 0 && block.timestamp >= thirdReleaseTime) {
102       amount = token.balanceOf(this);
103       require(amount > 0);
104       token.safeTransfer(beneficiary, amount / 2);
105       thirdReleaseTime = 0;
106     } else if (secondReleaseTime != 0 && block.timestamp >= secondReleaseTime) {
107       amount = token.balanceOf(this);
108       require(amount > 0);
109       token.safeTransfer(beneficiary, amount / 3);
110       secondReleaseTime = 0;
111     } else if (firstReleaseTime != 0 && block.timestamp >= firstReleaseTime) {
112       amount = token.balanceOf(this);
113       require(amount > 0);
114       token.safeTransfer(beneficiary, amount / 4);
115       firstReleaseTime = 0;
116     } else {
117       revert();
118     }
119   }
120 
121 
122 }