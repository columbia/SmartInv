1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0));
18         OwnershipTransferred(owner, newOwner);
19         owner = newOwner;
20     }
21 }
22 
23 contract Empires is Ownable {
24 
25     uint curr_rate = 50000000000000000; // 0.05 Ether
26     uint withraw_balance = 0;
27 
28     struct Flag {
29         address[] spotOwner;
30         bytes32[] spotTxt;
31         uint spotRate;
32         uint prize;
33         uint16 spotWon;
34     }
35 
36     Flag emptyFlag;
37 
38     mapping (uint16 => Flag[]) public cntry_flgs;
39 
40     function getRate () external view returns (uint) {
41         return curr_rate;
42     }
43 
44     function setRate (uint newRate) external onlyOwner {
45         curr_rate = newRate;
46     }
47 
48     function regSpot (uint16 cntryId, bytes32 stxt) private {
49 
50         cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotOwner.push(msg.sender);
51         cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotTxt.push(stxt);
52         cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].prize = cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].prize + (cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotRate * 70 / 100);
53         withraw_balance = withraw_balance + cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotRate - (cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotRate * 70 / 100);
54 
55     }
56 
57     function createFlag (uint16 cntryId, uint sRate) private {
58 
59         cntry_flgs[cntryId].push(Flag(new address[](0), new bytes32[](0), sRate, 0, 1000));
60 
61     }
62 
63     function completedFlag (uint16 cntryId) private {
64 
65         //generate spotWon
66         uint16 randomSpot = uint16(uint(keccak256(now, msg.sender)) % 600);
67 
68         // transfer to winner
69         cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotOwner[randomSpot].transfer(cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].prize);
70 
71         cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotWon = randomSpot;
72 
73     }
74 
75     function regSpots (uint16 cntryId, uint16 numOfSpots, bytes32 stxt) external payable {
76 
77         require (numOfSpots > 0 && numOfSpots <= 600);
78 
79         uint i;
80         uint j;
81         uint j1;
82         uint flagCompleted;
83 
84         // check active flag exists:
85         if (cntry_flgs[cntryId].length > 0) {
86           
87             require(msg.value == cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotRate * numOfSpots);
88 
89             i = cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotOwner.length;
90 
91             if (600-i >= numOfSpots) {
92 
93                 j = numOfSpots;
94 
95                 while (j > 0) {
96 
97                     regSpot(cntryId, stxt);
98                     j --;
99                     i ++;
100 
101                 }
102 
103             } else {
104               // flag spots overflow
105 
106                 j1 = 600-i;
107                 j = numOfSpots - j1;
108 
109                 while (j1 > 0) {
110 
111                     regSpot(cntryId, stxt);
112                     j1 --;
113                     i ++;
114 
115                 }
116 
117                 uint currRateHolder = cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotRate;
118 
119                 // flag completion
120                 completedFlag (cntryId);
121                 flagCompleted = 1;
122 
123                 // create new flag
124                 createFlag(cntryId, currRateHolder);
125 
126                 i = 0;
127 
128                 while (j > 0) {
129 
130                     regSpot(cntryId, stxt);
131                     j --;
132                     i ++;
133                 }
134 
135         }
136 
137       } else {
138 
139             require(msg.value == curr_rate * numOfSpots);
140 
141             // create new flag
142             createFlag(cntryId, curr_rate);
143 
144             i = 0;
145             j = numOfSpots;
146 
147             while (j > 0) {
148 
149                 regSpot(cntryId, stxt);
150                 j --;
151                 i ++;
152             }
153 
154       }
155       
156       // check flag completion
157         if (i==600) {
158             completedFlag (cntryId);
159             flagCompleted = 1;
160             createFlag(cntryId, curr_rate);
161         }
162 
163         UpdateFlagList(cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotOwner, cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotTxt, flagCompleted);
164 
165     }
166 
167     event UpdateFlagList(address[] spotOwners,bytes32[] spotTxt, uint flagCompleted);
168 
169     function getActiveFlag(uint16 cntryId) external view returns (address[],bytes32[],uint,uint,uint16) {
170       // check active flag exists:
171         if (cntry_flgs[cntryId].length > 0) {
172             return (cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotOwner, 
173             cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotTxt, 
174             cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotRate, 
175             cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].prize, 
176             cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotWon);
177         } else {
178             return (emptyFlag.spotOwner, 
179             emptyFlag.spotTxt, 
180             emptyFlag.spotRate, 
181             emptyFlag.prize, 
182             emptyFlag.spotWon);      
183         }
184     }
185 
186     function getCompletedFlag(uint16 cntryId, uint16 flagId) external view returns (address[],bytes32[],uint,uint,uint16) {
187         return (cntry_flgs[cntryId][flagId].spotOwner, 
188         cntry_flgs[cntryId][flagId].spotTxt, 
189         cntry_flgs[cntryId][flagId].spotRate, 
190         cntry_flgs[cntryId][flagId].prize, 
191         cntry_flgs[cntryId][flagId].spotWon);
192     }
193 
194 
195     function getActiveFlagRate(uint16 cntryId) external view returns (uint) {
196         // check active flag exists:
197         if (cntry_flgs[cntryId].length > 0) {
198             return cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotRate;
199         } else {
200             return curr_rate;
201         }
202     }
203 
204     function getCountrySpots(uint16 cntryId) external view returns (uint) {
205         if (cntry_flgs[cntryId].length > 0) {
206             return (cntry_flgs[cntryId].length-1)*600 + cntry_flgs[cntryId][cntry_flgs[cntryId].length-1].spotOwner.length;
207         } else {
208             return 0;
209         }
210     }
211 
212     function withdraw() external onlyOwner {
213         uint tb = withraw_balance;
214         owner.transfer(tb);
215         withraw_balance = withraw_balance - tb;
216     }
217 
218     function getWithdrawBalance () external view onlyOwner returns (uint) {
219         return withraw_balance;
220     }
221 
222     function() public payable { }
223 
224 }