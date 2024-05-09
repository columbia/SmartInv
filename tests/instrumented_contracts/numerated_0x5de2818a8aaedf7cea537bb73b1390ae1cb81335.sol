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
55 contract TaxManFarmer {
56     using SafeMath for uint256;
57     
58     bool private reentrancy_lock = false;
59     
60     address public taxMan = 0xd5048F05Ed7185821C999e3e077A3d1baed0952c;
61     address[9] public shop = [0x225e5E680358FaE78216A9C0A17793c2d2A85fC2, 0xf9208661ffE1607D96cF386B84B2BE621620097C, 
62     0x28bdDb555AdF1Bb71ce21cAb60566956bbFB0f08, 0xc8Ac76785C6b413753f6bFEdD9953785876B8a5c, 0x71e7a455991Cd9f60148720e2EB0Bc823014dB32, 
63     0xC946a2351eA574676f5e21043F05A33c2ceaBC59, 0x0B2DA98ab93207CE1367d63947A20E24372D9Ab5, 0x0029b494669cfE56E8cDBCafF074940CC107a970,
64     0xbD4282E6b2Bf8eef232eD211e53b54E560D71a2B];
65     address[9] public object = [0x339Cd902D6F2e50717b114f0837280ce56f36020, 0x56021b1b327eBE1eed2182A74d5f6a9a04eB2C73, 0x67BE1A7555A7D38D837F6587530FFc33d89F5a90,
66     0x7249fd2B946cAeD7D6C695e1656434A063723926, 0xAc4A1553e1e80222D6BF9f66D8FeF629aa8dBE74, 0x94b10291AA26f29994cF944da0Db6F03D4b407e1,
67     0x234FcB7f91fC353fefAd092b393850803A261cf9, 0xab87f28E10E3b0942EB27596Cc73B4031C9856e9, 0xFc1082B4d80651d9948b58ffCce45A5e6586AFE6];
68     
69     mapping(address => uint256) public workDone;
70     
71     modifier nonReentrant() {
72         require(!reentrancy_lock);
73         reentrancy_lock = true;
74         _;
75         reentrancy_lock = false;
76     }
77     
78     function pepFarm() nonReentrant external {
79         // buy 11 of each item
80         for (uint8 i = 0; i < 9; i++) { // 9 objects
81             for (uint8 j = 0; j < 11; j++) { // 11 times
82                 CornFarm(shop[i]).buyObject(this);
83             }
84             
85             // 10 for sender, 1 for taxMan
86             workDone[msg.sender] = workDone[msg.sender].add(uint256(10 ether));
87             workDone[taxMan] = workDone[taxMan].add(uint256(1 ether));
88         }
89         
90     }
91     
92     function reapFarm() nonReentrant external {
93         require(workDone[msg.sender] > 0);
94         for (uint8 i = 0; i < 9; i++) {
95             Corn(object[i]).transfer(msg.sender, workDone[msg.sender]);
96             Corn(object[i]).transfer(taxMan, workDone[taxMan]);
97         }
98         workDone[msg.sender] = 0;
99         workDone[taxMan] = 0;
100     }
101 }