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
51 contract BCoinTimeLock {
52   using SafeERC20 for ERC20;
53 
54   // ERC20 basic token contract being held
55   ERC20 public token;
56 
57   // beneficiary of tokens after they are released
58   address public beneficiary;
59 
60   // timestamp when token release is enabled
61   uint256 public releaseTime;
62 
63   constructor(
64     address _token,
65     address _beneficiary,
66     uint256 _utcTime
67   )
68     public
69   {
70     require(_beneficiary != address(0));
71     // solium-disable-next-line security/no-block-members
72     token = ERC20(_token);
73     beneficiary = _beneficiary;
74     releaseTime = _utcTime;
75   }
76 
77   /**
78    * @notice Transfers tokens held by timelock to beneficiary.
79    */
80   function release() public {
81     uint256 amount;
82     // solium-disable-next-line security/no-block-members
83     if (block.timestamp >= releaseTime) {
84       amount = token.balanceOf(this);
85       require(amount > 0);
86       token.safeTransfer(beneficiary, amount);
87       releaseTime = 0;
88     } else {
89       revert();
90     }
91   }
92 
93 
94 }