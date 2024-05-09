1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title SafeERC20
30  * @dev Wrappers around ERC20 operations that throw on failure.
31  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
32  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
33  */
34  
35 library SafeERC20 {
36   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
37     assert(token.transfer(to, value));
38   }
39 
40   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
41     assert(token.transferFrom(from, to, value));
42   }
43 
44   function safeApprove(ERC20 token, address spender, uint256 value) internal {
45     assert(token.approve(spender, value));
46   }
47 }
48 
49 /**
50  * @title TokenTimelock
51  * @dev TokenTimelock is a token holder contract that will allow a
52  * beneficiary to extract the tokens after a given release time
53  */
54 contract TokenTimelock {
55   using SafeERC20 for ERC20Basic;
56 
57   // ERC20 basic token contract being held
58   ERC20Basic public token;
59 
60   // beneficiary of tokens after they are released
61   address public beneficiary;
62 
63   // timestamp when token release is enabled
64   uint256 public releaseTime;
65 
66   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
67     require(_releaseTime > now);
68     token = _token;
69     beneficiary = _beneficiary;
70     releaseTime = _releaseTime;
71   }
72 
73   /**
74    * @notice Transfers tokens held by timelock to beneficiary.
75    */
76   function release() public {
77     require(now >= releaseTime);
78 
79     uint256 amount = token.balanceOf(this);
80     require(amount > 0);
81 
82     token.safeTransfer(beneficiary, amount);
83   }
84 }
85 
86 contract ZipperTokenTimelockFactoryMonthLockup {
87    function create(ERC20Basic _token, address _beneficiary) public
88    {
89        emit Created(new TokenTimelock(_token, _beneficiary, now + 180 days));
90    }
91 
92    event Created(TokenTimelock _address);
93 }