1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract BountyHunter {
51 
52   function() public payable { }
53 
54   string public constant NAME = "BountyHunter";
55   string public constant SYMBOL = "BountyHunter";
56   address ceoAddress = 0xc10A6AedE9564efcDC5E842772313f0669D79497;
57   address hunter;
58   address hunted;
59   address emblemOwner;
60   uint256 emblemPrice = 10000000000000000;
61   uint256 killshot;
62   uint256 x;
63   //uint256 secondKillShot;
64 
65   struct ContractData {
66     address user;
67     uint256 hunterPrice;
68     uint256 last_transaction;
69    
70   }
71 
72   ContractData[8] data;
73   
74 
75   
76   function BountyHunter() public {
77     for (uint i = 0; i < 8; i++) {
78      
79       data[i].hunterPrice = 5000000000000000;
80       data[i].user = msg.sender;
81       data[i].last_transaction = block.timestamp;
82     }
83   }
84 
85 
86   function payoutOnPurchase(address previousHunterOwner, uint256 hunterPrice) private {
87     previousHunterOwner.transfer(hunterPrice);
88   }
89   function transactionFee(address, uint256 hunterPrice) private {
90     ceoAddress.transfer(hunterPrice);
91   }
92   function createBounty(uint256 hunterPrice) private {
93     this.transfer(hunterPrice);
94   }
95 
96 
97   
98   function hireBountyHunter(uint bountyHunterID) public payable returns (uint, uint) {
99     require(bountyHunterID >= 0 && bountyHunterID <= 8);
100     
101     if ( data[bountyHunterID].hunterPrice == 5000000000000000 ) {
102       data[bountyHunterID].hunterPrice = 10000000000000000;
103     }
104     else { 
105       data[bountyHunterID].hunterPrice = data[bountyHunterID].hunterPrice * 2;
106     }
107     
108     require(msg.value >= data[bountyHunterID].hunterPrice * uint256(1));
109 
110     createBounty((data[bountyHunterID].hunterPrice / 10) * (3));
111     
112     payoutOnPurchase(data[bountyHunterID].user,  (data[bountyHunterID].hunterPrice / 10) * (6));
113     
114     transactionFee(ceoAddress, (data[bountyHunterID].hunterPrice / 10) * (1));
115 
116     
117     data[bountyHunterID].user = msg.sender;
118     
119     playerKiller();
120     
121     return (bountyHunterID, data[bountyHunterID].hunterPrice);
122 
123   }
124 
125   function purchaseMysteriousEmblem() public payable returns (address, uint) {
126     require(msg.value >= emblemPrice);
127     emblemOwner = msg.sender;
128     return (emblemOwner, emblemPrice);
129   }
130 
131   function getEmblemOwner() public view returns (address) {
132     return emblemOwner;
133   }
134 
135 
136   function getUsers() public view returns (address[], uint256[]) {
137     address[] memory users = new address[](8);
138     uint256[] memory hunterPrices =  new uint256[](8);
139     for (uint i=0; i<8; i++) {
140       if (data[i].user != ceoAddress){
141         users[i] = (data[i].user);
142       }
143       else{
144         users[i] = address(0);
145       }
146       
147       hunterPrices[i] = (data[i].hunterPrice);
148     }
149     return (users,hunterPrices);
150   }
151 
152   function rand(uint max) public returns (uint256){
153         
154     uint256 lastBlockNumber = block.number - 1;
155     uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
156 
157     uint256 FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
158     return uint256(uint256( (hashVal) / FACTOR) + 1) % max;
159   }
160 
161 
162   function playerKiller() private {
163     if (msg.sender == emblemOwner){
164       x = 24;
165     }
166     else {
167       x = 31;
168     }
169     killshot = rand(x);
170     if( (killshot < 8) &&  (msg.sender != data[killshot].user) ){
171       hunter = msg.sender;
172       if( ceoAddress != data[killshot].user &&  emblemOwner != data[killshot].user){
173         hunted = data[killshot].user;
174             if (this.balance > 100000000000000000) {
175               if (killshot == 0) {
176                 data[4].hunterPrice = 5000000000000000;
177                 data[4].user = ceoAddress;
178               }
179               if (killshot == 1){
180                 data[5].hunterPrice = 5000000000000000;
181                 data[5].user = 5000000000000000;
182               }
183               if (killshot == 2) {
184                 data[6].hunterPrice = 5000000000000000;
185                 data[6].user = ceoAddress;
186               }
187               if (killshot == 3) {
188                 data[7].hunterPrice = 5000000000000000;
189                 data[7].user = ceoAddress;
190               }      
191               if (killshot == 4) {
192                 data[0].hunterPrice = 5000000000000000;
193                 data[0].user = ceoAddress;
194               }      
195               if (killshot == 5) {
196                 data[1].hunterPrice = 5000000000000000;
197                 data[1].user = ceoAddress;
198               }      
199               if (killshot == 6) {
200                 data[2].hunterPrice = 5000000000000000;
201                 data[2].user = ceoAddress;
202               }      
203               if (killshot == 7) {
204                 data[3].hunterPrice = 5000000000000000;
205                 data[3].user = ceoAddress;
206               }
207 
208            }
209         data[killshot].hunterPrice  = 5000000000000000;
210         data[killshot].user  = ceoAddress;
211         ceoAddress.transfer((this.balance / 100) * (10));
212         msg.sender.transfer(this.balance);
213       }
214       else {
215         hunted = address(0);
216     
217     }
218   }
219 }
220 
221 
222 
223   function killFeed() public view returns(address, address){
224     return(hunter, hunted);
225   }
226   
227 }