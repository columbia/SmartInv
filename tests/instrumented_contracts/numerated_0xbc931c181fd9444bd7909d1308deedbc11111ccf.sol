1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender)
24     public view returns (uint256);
25 
26   function transferFrom(address from, address to, uint256 value)
27     public returns (bool);
28 
29   function approve(address spender, uint256 value) public returns (bool);
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 
38 /**
39  * @title SafeERC20
40  * @dev Wrappers around ERC20 operations that throw on failure.
41  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
42  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
43  */
44 library SafeERC20 {
45   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
46     assert(token.transfer(to, value));
47   }
48 
49   function safeTransferFrom(
50     ERC20 token,
51     address from,
52     address to,
53     uint256 value
54   )
55     internal
56   {
57     assert(token.transferFrom(from, to, value));
58   }
59 
60   function safeApprove(ERC20 token, address spender, uint256 value) internal {
61     assert(token.approve(spender, value));
62   }
63 }
64 
65 /**
66  * @title TokenTimelock
67  * @dev TokenTimelock is a token holder contract that will allow a
68  * beneficiary to extract the tokens after a given release time
69  */
70 contract TokenTimelock {
71   using SafeERC20 for ERC20Basic;
72 
73   // ERC20 basic token contract being held
74   ERC20Basic public token;
75 
76   // beneficiary of tokens after they are released
77   address public beneficiary;
78 
79   // timestamp when token release is enabled
80   uint256 public releaseTime;
81 
82   constructor(
83     ERC20Basic _token,
84     address _beneficiary,
85     uint256 _releaseTime
86   )
87     public
88   {
89     // solium-disable-next-line security/no-block-members
90     require(_releaseTime > block.timestamp);
91     token = _token;
92     beneficiary = _beneficiary;
93     releaseTime = _releaseTime;
94   }
95 
96   /**
97    * @notice Transfers tokens held by timelock to beneficiary.
98    */
99   function release() public {
100     // solium-disable-next-line security/no-block-members
101     require(block.timestamp >= releaseTime);
102 
103     uint256 amount = token.balanceOf(this);
104     require(amount > 0);
105 
106     token.safeTransfer(beneficiary, amount);
107   }
108 }