1 pragma solidity 0.6.8;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two unsigned integers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12         return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // Solidity only automatically asserts when dividing by 0
26     require(b > 0);
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two unsigned integers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 interface ERC20 {
64   function balanceOf(address who) external view returns (uint256);
65   function transfer(address to, uint value) external  returns (bool success);
66   function transferFrom(address from, address to, uint256 value) external returns (bool success);
67   function approve(address spender, uint value) external returns (bool success);
68 }
69 
70 contract YFMSTokenSwap {
71   using SafeMath for uint256;
72 
73   ERC20 public YFMSToken;
74   ERC20 public LUCRToken;
75 
76   address public owner;
77 
78   constructor(address yfms, address lucr) public {
79     owner = msg.sender;
80     YFMSToken = ERC20(yfms);
81     LUCRToken = ERC20(lucr);
82   }
83 
84   function swap () public {
85     uint256 balance = YFMSToken.balanceOf(msg.sender);
86     require(balance > 0, "balance must be greater than 0");
87     require(YFMSToken.transferFrom(msg.sender, address(this), balance), "YFMS transfer failed");
88     require(LUCRToken.transferFrom(owner, msg.sender, balance), "LUCR transfer failed");
89   }
90 
91   function withdrawYFMS () public {
92     require(msg.sender == owner);
93     YFMSToken.transfer(owner, YFMSToken.balanceOf(address(this)));
94   }
95 }