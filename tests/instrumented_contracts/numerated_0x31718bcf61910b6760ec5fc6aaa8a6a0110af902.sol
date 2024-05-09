1 pragma solidity ^0.4.18;
2 
3 interface CornFarm
4 {
5     function buyObject(address _beneficiary) public payable;
6 }
7 
8 interface Corn
9 {
10     function transfer(address to, uint256 value) public returns (bool);
11 }
12 
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19     if (a == 0) {
20       return 0;
21     }
22     uint256 c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   /**
38   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 contract PepFarmer {
56     using SafeMath for uint256;
57  
58     address public shop = 0x5f277da6734Cb32e182C8252467dF39D6EC424B4;
59     address public object = 0x12105bd41f403e33d444049884B000CC8D438AcB;
60 
61     mapping(address => uint256) public workDone;
62     
63     function pepFarm() external {
64         for (uint8 i = 0; i < 100; i++) {
65             CornFarm(shop).buyObject(this);
66         }
67         
68         workDone[msg.sender] = workDone[msg.sender].add(uint256(100 ether));
69     }
70     
71     function reapFarm() external {
72         require(workDone[msg.sender] > 0);
73         Corn(object).transfer(msg.sender, workDone[msg.sender]);
74         workDone[msg.sender] = 0;
75     }
76 }