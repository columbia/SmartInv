1 pragma solidity 0.4.24;
2 /**
3 * Token swapper contract for CLASSY tokens
4 */
5 
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 }
20 
21 interface Token {
22 
23   function balanceOf(address _owner) external constant returns (uint256 balance);
24   function transfer(address _to, uint256 _value) external returns (bool success);
25   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
26   function approve(address _spender, uint256 _value) external returns (bool success);
27   function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
28   event Transfer(address indexed _from, address indexed _to, uint256 _value);
29   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31 }
32 
33 interface ANYtoken {
34   function balanceOf(address _owner) external constant returns (uint256 balance);
35   function transfer(address _to, uint256 _value) external;
36 }
37 
38 contract Swap {
39 
40   using SafeMath for uint;
41 
42   Token public tokenA;
43   Token public tokenB;
44 
45   address public admin;
46 
47   constructor() public {
48 
49     tokenA = Token(0x30CC0e266cF33B8eaC6A99cBD98E39b890cfD69b);
50     tokenB = Token(0x8Cc3B3E4F62070afb2f0Dfece7228376626c1b0C);
51     admin = 0x71bAe8D36266F6a2115aa7E18A395e4676528100;
52 
53   }
54 
55   function changeAdmin(address newAdmin) public returns (bool){
56 
57     require(msg.sender == admin, "You are not allowed to do this");
58 
59     admin = newAdmin;
60 
61     return true;
62 
63   }
64 
65   function receiveApproval(address sender, uint value, address cont, bytes data) public returns (bool) {
66 
67     require(cont == address(tokenA),"This is not the expected caller");
68 
69     require(tokenA.transferFrom(sender,address(this),value),"An error ocurred whe getting the old tokens");
70 
71     uint toTransfer = value.mul(1e2); //Decimals correction
72     require(tokenB.transfer(sender,toTransfer), "Not enough tokens on contract to swap");
73 
74     return true;
75 
76   }
77 
78   function tokenRecovery(address token) public returns (bool) {
79 
80     require(msg.sender == admin, "You are not allowed to do this");
81 
82     ANYtoken toGet = ANYtoken(token);
83 
84     uint balance = toGet.balanceOf(address(this));
85 
86     toGet.transfer(msg.sender,balance);
87 
88     return true;
89 
90   }
91 
92 }