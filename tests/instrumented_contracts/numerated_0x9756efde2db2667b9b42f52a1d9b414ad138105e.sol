1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30     
31     /**
32     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
33     * reverts when dividing by zero.
34     */
35     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b != 0);
37         return a % b;
38     }
39 }
40 
41 contract dominance {
42     using SafeMath for uint;
43     
44     address public admin = 0xCf5BB540e63d87A104C071770eBfAEF40392aC95;
45     address public dev = 0x0b60946a9C39B7b1ab220562b0638244beD3f958;
46     uint public hardcap1 = 720 ether;
47     uint public hardcap2 = 2800 ether;
48     uint public currentcap = 0;
49     uint public currentround = 1;
50     bool open = true;
51     uint public hardcap = hardcap1;
52     
53     constructor() public{
54     }
55     
56     function deposit(address _referredBy) payable public {
57         require(open);
58         require(msg.value >= 0.33 ether);
59         uint value = msg.value;
60          
61         currentcap += msg.value;
62         if (currentcap >= hardcap && currentround == 1) {
63                 currentcap = 0;
64                 hardcap = hardcap2;
65                 currentround = 2;
66         }
67         else if(currentcap >= hardcap && currentround == 2){
68             open = false;
69         }
70         
71         uint referbalance = value.div(4);
72         address payable _referral = address(uint160(_referredBy));
73         _referral.transfer(referbalance);
74         value -= referbalance;
75         
76         uint devbalance = msg.value.div(100);
77         address payable _dev = address(uint160(dev));
78         _dev.transfer(devbalance);
79         value -= devbalance;
80         
81         address payable _admin = address(uint160(admin));
82         _admin.transfer(value);
83        
84     }
85     
86     function () payable external {
87        require(false);
88     }
89 }