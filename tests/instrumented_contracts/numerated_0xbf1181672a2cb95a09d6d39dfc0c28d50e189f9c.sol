1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // Betting contract
26 contract FomoBet  {
27     using SafeMath for uint;
28     //setup
29     struct bet {
30         address maker;
31         address taker;
32         uint256 round;
33         bool longOrShort;// false if maker bets round will end before - true if maker bets round will last longer then
34         bool validated;
35         uint256 betEnd; // ending time of bet 
36         uint256 betSize; // winner gets this amount
37         
38         }
39     struct offer {
40         address maker;
41         uint256 amount;
42         bool longOrShort;// false if maker bets round will end before - true if maker bets round will last longer then
43         uint256 betEndInDays; // ending time of bet 
44         uint256 betSize; // maker gives this amount for each takersize
45         uint256 takerSize; // for each offer taken taker gives this amount
46         }   
47     FoMo3Dlong constant FoMo3Dlong_ = FoMo3Dlong(0xF3ECc585010952b7809d0720a69514761ba1866D);    
48     mapping(uint256 => bet) public placedBets;
49     uint256 public nextBetInLine;
50     mapping(uint256 => offer) public OpenOffers;
51     uint256 public nextBetOffer;
52     mapping(address => uint256) public playerVault;
53     // functions
54     function vaultToWallet() public {
55         
56         address sender = msg.sender;
57         require(playerVault[sender] > 0);
58         uint256 value = playerVault[sender];
59         playerVault[sender] = 0;
60         sender.transfer(value);
61         
62     }
63     function () external payable{
64         address sender= msg.sender;
65         playerVault[sender] = playerVault[sender].add(msg.value);
66     }
67     function setupOffer(uint256 amountOffers, bool longOrShort, uint256 endingInDays, uint256 makerGive, uint256 takerGive) public payable{
68         address sender = msg.sender;
69         uint256 value = msg.value;
70         require(value >= amountOffers.mul(makerGive));
71         
72         OpenOffers[nextBetOffer].maker = sender;
73         OpenOffers[nextBetOffer].amount = amountOffers;
74         OpenOffers[nextBetOffer].longOrShort = longOrShort;
75         OpenOffers[nextBetOffer].betEndInDays = endingInDays;
76         OpenOffers[nextBetOffer].betSize = makerGive;
77         OpenOffers[nextBetOffer].takerSize = takerGive;
78         
79         nextBetOffer++;
80     }
81     function addToExistingOffer(uint256 offerNumber, uint256 amountOffers) public payable{
82         address sender = msg.sender;
83         uint256 value = msg.value;
84         require(sender == OpenOffers[offerNumber].maker);
85         require(value >= OpenOffers[offerNumber].betSize.mul(amountOffers));
86         OpenOffers[offerNumber].amount = OpenOffers[offerNumber].amount.add(amountOffers);
87     }
88     function removeFromExistingOffer(uint256 offerNumber, uint256 amountOffers) public {
89         address sender = msg.sender;
90         
91         require(sender == OpenOffers[offerNumber].maker);
92         require(amountOffers <= OpenOffers[offerNumber].amount);
93         OpenOffers[offerNumber].amount = OpenOffers[offerNumber].amount.sub(amountOffers);
94         playerVault[sender] = playerVault[sender].add(amountOffers.mul(OpenOffers[offerNumber].betSize));
95     }
96     function takeOffer(uint256 offerNumber, uint256 amountOffers) public payable{
97         // 
98         address sender = msg.sender;
99         uint256 value = msg.value;
100         uint256 timer = now;
101         
102         //require(amountOffers >= OpenOffers[offerNumber].amount );
103         //require(value >= amountOffers.mul(OpenOffers[offerNumber].takerSize));
104         placedBets[nextBetOffer].longOrShort = OpenOffers[offerNumber].longOrShort;
105         placedBets[nextBetOffer].maker = OpenOffers[offerNumber].maker;
106         placedBets[nextBetOffer].taker = sender;
107         placedBets[nextBetOffer].betEnd =  timer.add(OpenOffers[offerNumber].betEndInDays * 1 days);
108         placedBets[nextBetOffer].round = FoMo3Dlong_.rID_();
109         placedBets[nextBetOffer].betSize = value.add(amountOffers.mul(OpenOffers[offerNumber].betSize));
110         OpenOffers[offerNumber].amount = OpenOffers[offerNumber].amount.sub(amountOffers);
111         nextBetOffer++;
112     }
113     function validateBet(uint256 betNumber) public {
114         // to do
115         
116         uint256 timer = now;
117         uint256 round = FoMo3Dlong_.rID_();
118         if(placedBets[betNumber].validated != true){
119             if(placedBets[betNumber].longOrShort == true){
120                 //wincon maker
121                 if(timer >= placedBets[betNumber].betEnd){
122                     placedBets[betNumber].validated = true;
123                     playerVault[placedBets[betNumber].maker] = playerVault[placedBets[betNumber].maker].add(placedBets[betNumber].betSize);
124                 }
125                 // wincon taker
126                 if(timer < placedBets[betNumber].betEnd && round > placedBets[betNumber].round){
127                     placedBets[betNumber].validated = true;
128                     playerVault[placedBets[betNumber].taker] = playerVault[placedBets[betNumber].taker].add(placedBets[betNumber].betSize);
129                 }
130             }
131             if(placedBets[betNumber].longOrShort == false){
132                 //wincon taker
133                 if(timer >= placedBets[betNumber].betEnd ){
134                     placedBets[betNumber].validated = true;
135                     playerVault[placedBets[betNumber].taker] = playerVault[placedBets[betNumber].taker].add(placedBets[betNumber].betSize);
136                 }
137                 // wincon maker
138                 if(timer < placedBets[betNumber].betEnd && round > placedBets[betNumber].round){
139                     placedBets[betNumber].validated = true;
140                     playerVault[placedBets[betNumber].maker] = playerVault[placedBets[betNumber].maker].add(placedBets[betNumber].betSize);
141                 }
142             }
143         }
144     }
145     function death () external {
146         require(msg.sender == 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220);
147     selfdestruct(0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220);
148         
149     }
150     // view function return all OpenOffers
151     function getOfferInfo() public view returns(address[] memory _Owner, uint256[] memory locationData , bool[] memory allows){
152           uint i;
153           address[] memory _locationOwner = new address[](nextBetOffer);
154           uint[] memory _locationData = new uint[](nextBetOffer*4); //Bonds + fills + vault + reinvest + divs
155           bool[] memory _locationData2 = new bool[](nextBetOffer); //isAlive
156           uint y;
157           for(uint x = 0; x < nextBetOffer; x+=1){
158             
159              
160                 _locationOwner[i] = OpenOffers[i].maker;
161                 _locationData[y] = OpenOffers[i].amount;
162                 _locationData[y+1] = OpenOffers[i].betEndInDays;
163                 _locationData[y+2] = OpenOffers[i].betSize;
164                 _locationData[y+3] = OpenOffers[i].takerSize;
165                 _locationData2[i] = OpenOffers[i].longOrShort;
166               y += 4;
167               i+=1;
168             }
169           
170           return (_locationOwner,_locationData, _locationData2);
171         }
172         // view function return all bets
173         function getbetsInfo() public view returns(address[] memory _Owner, uint256[] memory locationData , bool[] memory allows){
174           uint i;
175           address[] memory _locationOwner = new address[](nextBetOffer*2);
176           uint[] memory _locationData = new uint[](nextBetOffer*3); //Bonds + fills + vault + reinvest + divs
177           bool[] memory _locationData2 = new bool[](nextBetOffer*2); //isAlive
178           uint y;
179           for(uint x = 0; x < nextBetOffer; x+=1){
180             
181              
182                 _locationOwner[i] = placedBets[i].maker;
183                 _locationOwner[i+1] = placedBets[i].taker;
184                 _locationData[y] = placedBets[i].round;
185                 _locationData[y+1] = placedBets[i].betEnd;
186                 _locationData[y+2] = placedBets[i].betSize;
187                 _locationData2[i] = placedBets[i].validated;
188                 _locationData2[i+1] = placedBets[i].longOrShort;
189               y += 3;
190               i+=2;
191             }
192           
193           return (_locationOwner,_locationData, _locationData2);
194         }
195         function fomoround () public view returns(uint256 roundNumber){
196             uint256 round = FoMo3Dlong_.rID_();
197             return(round);
198         }
199 }
200 // setup fomo interface
201 interface FoMo3Dlong {
202     
203     function rID_() external view returns(uint256);
204     
205 }