1 pragma solidity 0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/Dividend.sol
70 
71 contract Dividend {
72     using SafeMath for uint;
73 
74     address payable public addr1 = 0x2b339Ebdd12d6f79aA18ed2A032ebFE1FA4Faf45;
75     address payable public addr2 = 0x4BB515b7443969f7eb519d175e209aE8Af3601C1;
76 
77     event LogPayment(
78         address indexed from,
79         address indexed to,
80         uint amount,
81         uint total
82     );
83 
84     // NOTE: Transfer of block reward (coinbase) does not invoke this function
85     function () external payable {
86         // 80 % to address 1, remaining to address 2
87         uint amount1 = msg.value.mul(8).div(10);
88         uint amount2 = msg.value.sub(amount1);
89 
90         // WARNING: transfer will fail if it uses more than 2300 gas
91         addr1.transfer(amount1);
92         addr2.transfer(amount2);
93 
94         emit LogPayment(msg.sender, addr1, amount1, msg.value);
95         emit LogPayment(msg.sender, addr2, amount2, msg.value);
96     }
97 }