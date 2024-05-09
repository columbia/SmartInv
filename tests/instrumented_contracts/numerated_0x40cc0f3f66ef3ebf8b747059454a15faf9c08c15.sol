1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract Presale {
47     using SafeMath for uint256;
48     address owner;
49     mapping (address => uint) public userV1ItemNumber;  // p1
50     mapping (address => uint) public userV2ItemNumber;  // p2
51     mapping (address => uint) public userV3ItemNumber;  // p3
52     uint v1Price = 1 ether;
53     uint v2Price = 500 finney;
54     uint v3Price = 100 finney;
55     uint v1Number = 10;
56     uint v2Number = 50;
57     uint v3Number = 100;
58     uint currentV1Number = 0;
59     uint currentV2Number = 0;
60     uint currentV3Number = 0;
61     /* Modifiers */
62     modifier onlyOwner() {
63         require(owner == msg.sender);
64         _;
65     }
66     
67     /* Owner */
68     function setOwner (address _owner) onlyOwner() public {
69         owner = _owner;
70     }
71 
72     function Presale() public {
73         owner = msg.sender;
74     }
75 
76     function buyItem1() public payable{
77         require(msg.value >= v1Price);
78         require(currentV1Number < v1Number);
79         uint excess = msg.value.sub(v1Price);
80         if (excess > 0) {
81             msg.sender.transfer(excess);
82         }
83         currentV1Number += 1;
84         userV1ItemNumber[msg.sender] += 1;
85     }
86     
87     function buyItem2() public payable{
88         require(msg.value >= v2Price);
89         require(currentV2Number < v2Number);
90         uint excess = msg.value.sub(v2Price);
91         if (excess > 0) {
92             msg.sender.transfer(excess);
93         }
94         currentV2Number += 1;
95         userV2ItemNumber[msg.sender] += 1;
96     }
97     
98     function buyItem3() public payable{
99         require(msg.value >= v3Price);
100         require(currentV3Number < v3Number);
101         uint excess = msg.value.sub(v3Price);
102         if (excess > 0) {
103             msg.sender.transfer(excess);
104         }
105         currentV3Number += 1;
106         userV3ItemNumber[msg.sender] += 1;
107     }
108     
109     function getGameStats() public view returns(uint, uint, uint) {
110         return (currentV1Number, currentV2Number, currentV3Number);    
111     }
112     
113     function withdrawAll () onlyOwner() public {
114         msg.sender.transfer(address(this).balance);
115     }
116 
117     function withdrawAmount (uint256 _amount) onlyOwner() public {
118         msg.sender.transfer(_amount);
119     }
120 }