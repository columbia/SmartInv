1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
39 
40 /**
41  * @title SafeERC20
42  * @dev Wrappers around ERC20 operations that throw on failure.
43  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
44  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
45  */
46 library SafeERC20 {
47   function safeTransfer(
48     ERC20Basic _token,
49     address _to,
50     uint256 _value
51   )
52     internal
53   {
54     require(_token.transfer(_to, _value));
55   }
56 
57   function safeTransferFrom(
58     ERC20 _token,
59     address _from,
60     address _to,
61     uint256 _value
62   )
63     internal
64   {
65     require(_token.transferFrom(_from, _to, _value));
66   }
67 
68   function safeApprove(
69     ERC20 _token,
70     address _spender,
71     uint256 _value
72   )
73     internal
74   {
75     require(_token.approve(_spender, _value));
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
80 
81 /**
82  * @title TokenTimelock
83  * @dev TokenTimelock is a token holder contract that will allow a
84  * beneficiary to extract the tokens after a given release time
85  */
86 contract TokenTimelock {
87   using SafeERC20 for ERC20Basic;
88 
89   // ERC20 basic token contract being held
90   ERC20Basic public token;
91 
92   // beneficiary of tokens after they are released
93   address public beneficiary;
94 
95   // timestamp when token release is enabled
96   uint256 public releaseTime;
97 
98   constructor(
99     ERC20Basic _token,
100     address _beneficiary,
101     uint256 _releaseTime
102   )
103     public
104   {
105     // solium-disable-next-line security/no-block-members
106     require(_releaseTime > block.timestamp);
107     token = _token;
108     beneficiary = _beneficiary;
109     releaseTime = _releaseTime;
110   }
111 
112   /**
113    * @notice Transfers tokens held by timelock to beneficiary.
114    */
115   function release() public {
116     // solium-disable-next-line security/no-block-members
117     require(block.timestamp >= releaseTime);
118 
119     uint256 amount = token.balanceOf(address(this));
120     require(amount > 0);
121 
122     token.safeTransfer(beneficiary, amount);
123   }
124 }