1 pragma solidity ^0.4.15;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 library SafeMath {
38   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal constant returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal constant returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 
65 contract PreIco is Ownable {
66     using SafeMath for uint;
67 
68     uint public decimals = 18;
69 
70     uint256 public initialSupply;
71 
72     uint256 public remainingSupply;
73 
74     uint256 public tokenValue;  // value in wei
75 
76     address public updater;  // account in charge of updating the token value
77 
78     uint256 public startBlock;  // block number of contract deploy
79 
80     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
81 
82     function PreIco(uint256 _initialSupply, uint256 initialValue, address initialUpdater, uint256 end) {
83         initialSupply = _initialSupply;
84         remainingSupply = initialSupply;
85         tokenValue = initialValue;
86         updater = initialUpdater;
87         startBlock = block.number;
88         endTime = end;
89     }
90 
91     event UpdateValue(uint256 newValue);
92 
93     function updateValue(uint256 newValue) {
94         require(msg.sender == updater || msg.sender == owner);
95         tokenValue = newValue;
96         UpdateValue(newValue);
97     }
98 
99     function updateUpdater(address newUpdater) onlyOwner {
100         updater = newUpdater;
101     }
102 
103     function updateEndTime(uint256 newEnd) onlyOwner {
104         endTime = newEnd;
105     }
106 
107     event Withdraw(address indexed to, uint value);
108 
109     function withdraw(address to, uint256 value) onlyOwner {
110         to.transfer(value);
111         Withdraw(to, value);
112     }
113 
114     modifier beforeEndTime() {
115         require(now < endTime);
116         _;
117     }
118 
119     event AssignToken(address indexed to, uint value);
120 
121     function () payable beforeEndTime {
122         require(remainingSupply > 0);
123         address sender = msg.sender;
124         uint256 value = msg.value.mul(10 ** decimals).div(tokenValue);
125         if (remainingSupply >= value) {
126             AssignToken(sender, value);
127             remainingSupply = remainingSupply.sub(value);
128         } else {
129             AssignToken(sender, remainingSupply);
130             remainingSupply = 0;
131         }
132     }
133 }