1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeERC20
28  * @dev Wrappers around ERC20 operations that throw on failure.
29  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
30  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
31  */
32 
33 library SafeERC20 {
34   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
35     assert(token.transfer(to, value));
36   }
37 
38   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
39     assert(token.transferFrom(from, to, value));
40   }
41 
42   function safeApprove(ERC20 token, address spender, uint256 value) internal {
43     assert(token.approve(spender, value));
44   }
45 }
46 
47 /**
48  * @title TokenTimelock
49  * @dev TokenTimelock is a token holder contract that will allow a
50  * beneficiary to extract the tokens after a given release time
51  */
52 contract TokenTimelock {
53   using SafeERC20 for ERC20Basic;
54 
55   // ERC20 basic token contract being held
56   ERC20Basic public token;
57 
58   // beneficiary of tokens after they are released
59   address public beneficiary;
60 
61   // timestamp when token release is enabled
62   uint256 public releaseTime;
63 
64   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
65     require(_releaseTime > now);
66     token = _token;
67     beneficiary = _beneficiary;
68     releaseTime = _releaseTime;
69   }
70 
71   /**
72    * @notice Transfers tokens held by timelock to beneficiary.
73    */
74   function release() public {
75     require(now >= releaseTime);
76 
77     uint256 amount = token.balanceOf(this);
78     require(amount > 0);
79 
80     token.safeTransfer(beneficiary, amount);
81   }
82 }