1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function div(uint256 a, uint256 b) internal pure returns (uint256) {
6     return a / b;
7   }
8 
9   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10     assert(b <= a);
11     return a - b;
12   }
13 
14   function add(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a + b;
16     assert(c >= a);
17     return c;
18   }
19 
20 }
21 
22 contract ERC20Basic {
23   function totalSupply() public view returns (uint256);
24   function balanceOf(address who) public view returns (uint256);
25   function transfer(address to, uint256 value) public returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public view returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeERC20 {
37   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
38     assert(token.transfer(to, value));
39   }
40 }
41 
42 /**
43  * @title JunketLockup
44  * @dev JunketLockup is a token holder contract that will allow a
45  * beneficiary to extract the tokens after a given release time
46  */
47 contract PhilipinesJunket{
48   using SafeERC20 for ERC20Basic;
49   using SafeMath for uint256;
50 
51   // ERC20 basic token contract being held
52   ERC20Basic public token;
53 
54   // beneficiary of tokens after they are released
55   address public beneficiary;
56 
57   // timestamp when token release is enabled
58   uint256 public releaseTime;
59 
60   uint256 public unlocked = 0;
61   
62   bool public withdrawalsInitiated = false;
63   
64   uint256 public year = 365 days; // equivalent to one year
65 
66   constructor() public {
67     token = ERC20Basic(0x814F67fA286f7572B041D041b1D99b432c9155Ee);
68     
69     beneficiary = address(0x8CBE4C9a921A19d8F074d9722815cD42a450f849);
70     
71     releaseTime = now + year;
72   }
73 
74   /**
75    * @notice Transfers tokens held by timelock to beneficiary.
76    */
77   function release(uint256 _amount) public {
78     
79     uint256 balance = token.balanceOf(address(this));
80     require(balance > 0);
81     
82     if(!withdrawalsInitiated){
83         // unlock 50% of existing balance
84         unlocked = balance.div(2);
85         withdrawalsInitiated = true;
86     }
87     
88     if(now >= releaseTime){
89         unlocked = balance;
90     }
91     
92     require(_amount <= unlocked);
93     unlocked = unlocked.sub(_amount);
94     
95     token.safeTransfer(beneficiary, _amount);
96     
97   }
98   
99   function balanceOf() external view returns(uint256){
100       return token.balanceOf(address(this));
101   }
102   
103   function currentTime() external view returns(uint256){
104       return now;
105   }
106 }