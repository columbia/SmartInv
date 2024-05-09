1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/20
13  */
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public view returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 /**
22  * @title SafeERC20
23  * @dev Wrappers around ERC20 operations that throw on failure.
24  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
25  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
26  */
27 library SafeERC20 {
28   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
29     assert(token.transfer(to, value));
30   }
31 
32   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
33     assert(token.transferFrom(from, to, value));
34   }
35 
36   function safeApprove(ERC20 token, address spender, uint256 value) internal {
37     assert(token.approve(spender, value));
38   }
39 }
40 
41 /**
42  * @title ParetoFourMonthLockup
43  * @dev PretoFourMonthLockup is a token holder contract that will allow a
44  * beneficiary to extract the tokens after a given release time
45  */
46 contract ParetoFourMonthLockup {
47   using SafeERC20 for ERC20Basic;
48 
49   // ERC20 basic token contract being held
50   ERC20Basic public token;
51 
52   // beneficiary of tokens after they are released
53   address public beneficiary;
54 
55   // timestamp when token release is enabled
56   uint256 public releaseTime;
57 
58   function ParetoFourMonthLockup()public {
59     token = ERC20Basic(0xea5f88E54d982Cbb0c441cde4E79bC305e5b43Bc);
60     beneficiary = 0x439f2cEe51F19BA158f1126eC3635587F7637718;
61     releaseTime = now + 120 days;
62   }
63 
64   /**
65    * @notice Transfers tokens held by timelock to beneficiary.
66    */
67   function release() public {
68     require(now >= releaseTime);
69 
70     uint256 amount = token.balanceOf(this);
71     require(amount > 0);
72 
73     token.safeTransfer(beneficiary, amount);
74   }
75 }