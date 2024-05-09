1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title BlockportDistributor
69  * @dev This contract can be used to distribute ether to multiple addresses
70  * at once. 
71  */
72 contract BlockportDistributor {
73     using SafeMath for uint256;
74 
75     event Distributed(address payable[] receivers, uint256 amount);
76 
77     /**
78      * @dev Constructor
79      */
80     constructor () public {
81     }
82 
83     /**
84      * @dev payable fallback
85      * dont accept pure ether: revert it.
86      */
87     function () external payable {
88         revert();
89     }
90 
91     /**
92      * @dev distribute function, note that enough ether must be send (receivers.length * amount)
93      * @param receivers Addresses who should all receive amount.
94      * @param amount amount to distribute to each address, in wei.
95      * @return bool success
96      */
97     function distribute(address payable[] calldata receivers, uint256 amount) external payable returns (bool success) {
98         require(amount.mul(receivers.length) == msg.value);
99 
100         for (uint256 i = 0; i < receivers.length; i++) {
101             receivers[i].transfer(amount);
102         }
103         emit Distributed(receivers, amount);
104         return true;
105     }
106 }