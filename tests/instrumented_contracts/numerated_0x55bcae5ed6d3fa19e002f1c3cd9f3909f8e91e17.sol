1 pragma solidity ^0.4.23;
2 
3 
4 //1,45 left. -*-*-*-*- 45 55 programmer. -*-*-*-*-*-upper 35 right.
5 library SafeMath {
6 
7     /**
8     * @dev Multiplies two numbers, throws on overflow.
9     */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     /**
20     * @dev Integer division of two numbers, truncating the quotient.
21     */
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     /**
30     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31     */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     /**
38     * @dev Adds two numbers, throws on overflow.
39     */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract Cryptoraces {
48 
49 
50   using SafeMath for uint;
51   uint256 maximumBalance;
52   uint256 rewardnumber;
53   address private manager;
54   uint minimumBet;
55   //address public listofwinners;
56   //address public listoflosers;
57 
58   struct raceDetails {
59       uint time;
60       uint luckNumber;
61       uint horseType;
62   }
63 
64   mapping (address => raceDetails) members;
65 
66   address[] private listofUsers;
67 
68 
69   constructor() public {
70       manager = msg.sender;
71   }
72 
73 
74     function random() private view returns (uint) {
75         return uint(keccak256(block.difficulty, block.timestamp, now));
76     }
77 
78 
79 
80   function enter(uint256 leftorright) public payable {
81 
82       if(leftorright == 1) {
83         maximumBalance = getMaximumBetRate();
84         require(msg.value < maximumBalance && msg.value > .001 ether,"Your bet is too high!");
85 
86         rewardnumber = randomtests();
87         if(rewardnumber < 45){
88             msg.sender.transfer(msg.value.mul(2));
89             members[msg.sender].time = now;
90             members[msg.sender].luckNumber = rewardnumber;
91             members[msg.sender].horseType = leftorright;
92             listofUsers.push(msg.sender) -1;
93         } else {
94 
95           members[msg.sender].time = now;
96           members[msg.sender].luckNumber = rewardnumber;
97           members[msg.sender].horseType = leftorright;
98           listofUsers.push(msg.sender) -1;
99         }
100       } else {
101         maximumBalance = getMaximumBetRate();
102         require(msg.value < maximumBalance && msg.value > .001 ether,"Your bet is too high or low");
103 
104         rewardnumber = randomtests();
105         if(rewardnumber > 55){
106             msg.sender.transfer(msg.value.mul(2));
107 
108             members[msg.sender].time = now;
109             members[msg.sender].horseType = leftorright;
110             members[msg.sender].luckNumber = rewardnumber;
111             listofUsers.push(msg.sender) -1;
112         } else {
113 
114           members[msg.sender].time = now;
115           members[msg.sender].horseType = leftorright;
116           members[msg.sender].luckNumber = rewardnumber;
117           listofUsers.push(msg.sender) -1;
118         }
119       }
120     }
121 
122 function getMaximumBetRate() public view returns(uint256){
123     return address(this).balance.div(20);
124   }
125 
126 
127   function randomtests() private view returns(uint256){
128     uint256 index = random() % 100;
129     return index;
130   }
131 
132   function getAccounts() view public returns(address[]) {
133       return listofUsers;
134   }
135 
136   function numberofGamePlay() view public returns (uint) {
137       return listofUsers.length;
138   }
139 
140   function uint2str(uint i) internal pure returns (string){
141     if (i == 0) return "0";
142     uint j = i;
143     uint length;
144     while (j != 0){
145         length++;
146         j /= 10;
147     }
148     bytes memory bstr = new bytes(length);
149     uint k = length - 1;
150     while (i != 0){
151         bstr[k--] = byte(48 + i % 10);
152         i /= 10;
153     }
154     return string(bstr);
155 }
156 
157 
158 
159 
160 
161 
162   function getAccDetails(address _address) view public returns (string, string, string ,string) {
163 
164 
165     if(members[_address].time == 0){
166             return ("0", "0", "0", "You have never played this game before");
167     } else {
168 
169       if(members[_address].horseType == 1) {
170 
171        if(rewardnumber < 45){
172            return (uint2str(members[_address].time), uint2str(members[_address].luckNumber), uint2str(members[_address].horseType), "You Win because your number smaller than 45");
173 
174        } else {
175            return (uint2str(members[_address].time), uint2str(members[_address].luckNumber),uint2str(members[_address].horseType), "youre lose  because your number bigger than 45");
176        }
177      } else {
178 
179        if(rewardnumber > 55){
180            return (uint2str(members[_address].time), uint2str(members[_address].luckNumber),uint2str(members[_address].horseType), "You win, because your number bigger than 55");
181        } else {
182          return (uint2str(members[_address].time), uint2str(members[_address].luckNumber),uint2str(members[_address].horseType), "You lose because your number smaller than 55");
183        }
184      }
185 
186 
187     }
188   }
189 
190 
191 
192 
193 
194   function getEthBalance() public view returns(uint) {
195     return address(this).balance;
196  }
197 
198 
199   function depositEther() public payable returns(uint256){
200      require(msg.sender == manager,"only manager can reach  here");
201     return address(this).balance;
202   }
203 
204   function withDrawalether(uint amount) public payable returns(uint256){
205       require(msg.sender == manager,"only manager can reach  here");
206       manager.transfer(amount*1000000000000000); // 1 etherin 1000' de birini gönderebilir.
207       return address(this).balance;
208   }
209 
210 }