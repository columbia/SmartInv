1 pragma solidity ^0.4.24;
2 
3 // File: contracts\openzeppelin-solidity\token\ERC20\ERC20Basic.sol
4 
5 
6 /* @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts\openzeppelin-solidity\token\ERC20\ERC20.sol
18 
19 /* @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address _owner, address _spender)
24     public view returns (uint256);
25 
26   function transferFrom(address _from, address _to, uint256 _value)
27     public returns (bool);
28 
29   function approve(address _spender, uint256 _value) public returns (bool);
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 // File: contracts\openzeppelin-solidity\token\ERC20\SafeERC20.sol
38 
39 /* @title SafeERC20
40  * @dev Wrappers around ERC20 operations that throw on failure.
41  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
42  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
43  */
44 library SafeERC20 {
45   function safeTransfer(
46     ERC20Basic _token,
47     address _to,
48     uint256 _value
49   )
50     internal
51   {
52     require(_token.transfer(_to, _value));
53   }
54 
55   function safeTransferFrom(
56     ERC20 _token,
57     address _from,
58     address _to,
59     uint256 _value
60   )
61     internal
62   {
63     require(_token.transferFrom(_from, _to, _value));
64   }
65 
66   function safeApprove(
67     ERC20 _token,
68     address _spender,
69     uint256 _value
70   )
71     internal
72   {
73     require(_token.approve(_spender, _value));
74   }
75 }
76 
77 // File: contracts\openzeppelin-solidity\token\ERC20\TokenTimelock.sol
78 
79 /* @title TokenTimelock
80  * @dev TokenTimelock is a token holder contract that will allow a
81  * beneficiary to extract the tokens after a given release time
82  */
83 contract TokenTimelock {
84   using SafeERC20 for ERC20Basic;
85 
86   // ERC20 basic token contract being held
87   ERC20Basic public token;
88 
89   // beneficiary of tokens after they are released
90   address public beneficiary;
91 
92   // timestamp when token release is enabled
93   uint256 public releaseTime;
94 
95   constructor(
96     ERC20Basic _token,
97     address _beneficiary,
98     uint256 _releaseTime
99   )
100     public
101   {
102     // solium-disable-next-line security/no-block-members
103     require(_releaseTime > block.timestamp);
104     token = _token;
105     beneficiary = _beneficiary;
106     releaseTime = _releaseTime;
107   }
108 
109   /**
110    * @notice Transfers tokens held by timelock to beneficiary.
111    */
112   function release() public {
113     // solium-disable-next-line security/no-block-members
114     require(block.timestamp >= releaseTime);
115 
116     uint256 amount = token.balanceOf(address(this));
117     require(amount > 0);
118 
119     token.safeTransfer(beneficiary, amount);
120   }
121 }