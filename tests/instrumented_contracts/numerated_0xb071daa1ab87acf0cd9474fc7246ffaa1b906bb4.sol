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
58     bool private reentrancy_lock = false;
59     
60     address public shop = 0x28bdDb555AdF1Bb71ce21cAb60566956bbFB0f08;
61     address public object = 0x67BE1A7555A7D38D837F6587530FFc33d89F5a90;
62     address public taxMan = 0xd5048F05Ed7185821C999e3e077A3d1baed0952c;
63     
64     mapping(address => uint256) public workDone;
65     
66     modifier nonReentrant() {
67         require(!reentrancy_lock);
68         reentrancy_lock = true;
69         _;
70         reentrancy_lock = false;
71     }
72     
73     function pepFarm() nonReentrant external {
74         for (uint8 i = 0; i < 100; i++) {
75             CornFarm(shop).buyObject(this);
76         }
77         
78         workDone[msg.sender] = workDone[msg.sender].add(uint256(95 ether));
79         workDone[taxMan] = workDone[taxMan].add(uint256(5 ether));
80     }
81     
82     function reapFarm() nonReentrant external {
83         require(workDone[msg.sender] > 0);
84         Corn(object).transfer(msg.sender, workDone[msg.sender]);
85         Corn(object).transfer(taxMan, workDone[taxMan]);
86         workDone[msg.sender] = 0;
87         workDone[taxMan] = 0;
88     }
89 }