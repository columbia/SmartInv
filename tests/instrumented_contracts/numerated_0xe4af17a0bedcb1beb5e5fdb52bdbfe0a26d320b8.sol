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
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender)
23     public view returns (uint256);
24 
25   function transferFrom(address from, address to, uint256 value)
26     public returns (bool);
27 
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 /**
38  * @title SafeERC20
39  * @dev Wrappers around ERC20 operations that throw on failure.
40  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
41  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
42  */
43 library SafeERC20 {
44   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
45     require(token.transfer(to, value));
46   }
47 
48   function safeTransferFrom(
49     ERC20 token,
50     address from,
51     address to,
52     uint256 value
53   )
54     internal
55   {
56     require(token.transferFrom(from, to, value));
57   }
58 
59   function safeApprove(ERC20 token, address spender, uint256 value) internal {
60     require(token.approve(spender, value));
61   }
62 }
63 
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