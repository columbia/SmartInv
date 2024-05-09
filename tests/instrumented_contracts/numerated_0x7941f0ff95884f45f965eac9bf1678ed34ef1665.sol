1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 /**
21  * @title ERC20Basic
22  * @dev Simpler version of ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/179
24  */
25 contract ERC20Basic {
26     function totalSupply() public view returns (uint256);
27     function balanceOf(address who) public view returns (uint256);
28     function transfer(address to, uint256 value) public returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 /**
33  * @title ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/20
35  */
36 contract ERC20 is ERC20Basic {
37     function allowance(address owner, address spender) public view returns (uint256);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract CLUBERC20  is ERC20 {
44     function lockBalanceOf(address who) public view returns (uint256);
45 }
46 
47 /**
48  * @title SafeERC20
49  * @dev Wrappers around ERC20 operations that throw on failure.
50  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
51  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
52  */
53 library SafeERC20 {
54     function safeTransfer(ERC20 token, address to, uint256 value) internal {
55         assert(token.transfer(to, value));
56     }
57 
58     function safeTransferFrom(
59         ERC20 token,
60         address from,
61         address to,
62         uint256 value
63     )
64     internal
65     {
66         assert(token.transferFrom(from, to, value));
67     }
68 
69     function safeApprove(ERC20 token, address spender, uint256 value) internal {
70         assert(token.approve(spender, value));
71     }
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a * b;
81     assert(a == 0 || c / a == b);
82     return c;
83   }
84 
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 /**
105  * @title ClubTransferContract
106  */
107 contract ClubTransferContract is owned {
108     using SafeERC20 for CLUBERC20;
109     using SafeMath for uint;
110 
111     string public constant name = "ClubTransferContract";
112 
113     CLUBERC20 public clubToken = CLUBERC20(0x045A464727871BE7731AD0028AAAA8127B90DBd5);
114 
115     function ClubTransferContract() public {}
116     
117     function getBalance() constant public returns(uint256) {
118         return clubToken.balanceOf(this);
119     }
120 
121     function transferClub(address _to, uint _amount) onlyOwner public {
122         require (_to != 0x0);
123         require(clubToken.balanceOf(this) >= _amount);
124         
125         clubToken.safeTransfer(_to, _amount);
126     }
127     
128     function transferBack() onlyOwner public {
129         clubToken.safeTransfer(owner, clubToken.balanceOf(this));
130     }
131 }