1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a * b;
50     assert(a == 0 || c / a == b);
51     return c;
52   }
53 
54   function div(uint256 a, uint256 b) internal constant returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   function add(uint256 a, uint256 b) internal constant returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 contract PreIco is Ownable {
74     using SafeMath for uint;
75 
76     uint public decimals = 18;
77 
78     uint256 public initialSupply = 4000000 * 10 ** decimals;  // 4 milions XCC
79 
80     uint256 public remainingSupply = initialSupply;
81 
82     uint256 public tokenValue;  // value in wei
83 
84     address public updater;  // account in charge of updating the token value
85 
86     uint256 public startBlock;  // block number of contract deploy
87 
88     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
89 
90     function PreIco(uint256 initialValue, address initialUpdater, uint256 end) {
91         tokenValue = initialValue;
92         updater = initialUpdater;
93         startBlock = block.number;
94         endTime = end;
95     }
96 
97     event UpdateValue(uint256 newValue);
98 
99     function updateValue(uint256 newValue) {
100         require(msg.sender == updater || msg.sender == owner);
101         tokenValue = newValue;
102         UpdateValue(newValue);
103     }
104 
105     function updateUpdater(address newUpdater) onlyOwner {
106         updater = newUpdater;
107     }
108 
109     function updateEndTime(uint256 newEnd) onlyOwner {
110         endTime = newEnd;
111     }
112 
113     event Withdraw(address indexed to, uint value);
114 
115     function withdraw(address to, uint256 value) onlyOwner {
116         to.transfer(value);
117         Withdraw(to, value);
118     }
119 
120     modifier beforeEndTime() {
121         require(now < endTime);
122         _;
123     }
124 
125     event AssignToken(address indexed to, uint value);
126 
127     function () payable beforeEndTime {
128         require(remainingSupply > 0);
129         address sender = msg.sender;
130         uint256 value = msg.value.mul(10 ** decimals).div(tokenValue);
131         if (remainingSupply >= value) {
132             AssignToken(sender, value);
133             remainingSupply = remainingSupply.sub(value);
134         } else {
135             AssignToken(sender, remainingSupply);
136             remainingSupply = 0;
137         }
138     }
139 }