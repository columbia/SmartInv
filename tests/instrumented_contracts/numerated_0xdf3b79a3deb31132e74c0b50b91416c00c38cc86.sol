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
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender)
22     public view returns (uint256);
23 
24   function transferFrom(address from, address to, uint256 value)
25     public returns (bool);
26 
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 /**
36  * @title SafeERC20
37  * @dev Wrappers around ERC20 operations that throw on failure.
38  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
39  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
40  */
41 library SafeERC20 {
42   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
43     require(token.transfer(to, value));
44   }
45 
46   function safeTransferFrom(
47     ERC20 token,
48     address from,
49     address to,
50     uint256 value
51   )
52     internal
53   {
54     require(token.transferFrom(from, to, value));
55   }
56 
57   function safeApprove(ERC20 token, address spender, uint256 value) internal {
58     require(token.approve(spender, value));
59   }
60 }
61 
62 /**
63  * @title TokenTimelock
64  * @dev TokenTimelock is a token holder contract that will allow a
65  * beneficiary to extract the tokens after a given release time
66  */
67 contract TokenTimelock {
68   using SafeERC20 for ERC20Basic;
69 
70   // ERC20 basic token contract being held
71   ERC20Basic public token;
72 
73   // beneficiary of tokens after they are released
74   address public beneficiary;
75 
76   // timestamp when token release is enabled
77   uint256 public releaseTime;
78 
79   constructor(
80     ERC20Basic _token,
81     address _beneficiary,
82     uint256 _releaseTime
83   )
84     public
85   {
86     // solium-disable-next-line security/no-block-members
87     require(_releaseTime > block.timestamp);
88     token = _token;
89     beneficiary = _beneficiary;
90     releaseTime = _releaseTime;
91   }
92 
93   /**
94    * @notice Transfers tokens held by timelock to beneficiary.
95    */
96   function release() public {
97     // solium-disable-next-line security/no-block-members
98     require(block.timestamp >= releaseTime);
99 
100     uint256 amount = token.balanceOf(this);
101     require(amount > 0);
102 
103     token.safeTransfer(beneficiary, amount);
104   }
105 }
106 
107 contract WemergeTimelock is TokenTimelock {
108     
109     string public name = "";
110     
111     constructor(
112         string _name,
113         ERC20Basic _token,
114         address _beneficiary,
115         uint256 _releaseTime
116     )
117         public
118         TokenTimelock(_token,_beneficiary,_releaseTime)
119     {
120           name = _name;
121     }
122 }