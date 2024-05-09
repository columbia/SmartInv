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
102         require(amountOffers >= OpenOffers[offerNumber].amount );
103         require(value >= amountOffers.mul(OpenOffers[offerNumber].takerSize));
104         placedBets[nextBetOffer].longOrShort = OpenOffers[offerNumber].longOrShort;
105         placedBets[nextBetOffer].maker = OpenOffers[offerNumber].maker;
106         placedBets[nextBetOffer].taker = sender;
107         uint256 timeframe = OpenOffers[offerNumber].betEndInDays * 1 days;
108         placedBets[nextBetOffer].betEnd =  timer.add(timeframe);
109         placedBets[nextBetOffer].round = FoMo3Dlong_.rID_();
110         placedBets[nextBetOffer].betSize = value.add(amountOffers.mul(OpenOffers[offerNumber].betSize));
111         OpenOffers[offerNumber].amount = OpenOffers[offerNumber].amount.sub(amountOffers);
112         nextBetOffer++;
113     }
114     function validateBet(uint256 betNumber) public {
115         // to do
116         
117         uint256 timer = now;
118         uint256 round = FoMo3Dlong_.rID_();
119         if(placedBets[betNumber].validated != true){
120             if(placedBets[betNumber].longOrShort == true){
121                 //wincon maker
122                 if(timer >= placedBets[betNumber].betEnd){
123                     placedBets[betNumber].validated = true;
124                     playerVault[placedBets[betNumber].maker] = playerVault[placedBets[betNumber].maker].add(placedBets[betNumber].betSize);
125                 }
126                 // wincon taker
127                 if(timer < placedBets[betNumber].betEnd && round > placedBets[betNumber].round){
128                     placedBets[betNumber].validated = true;
129                     playerVault[placedBets[betNumber].taker] = playerVault[placedBets[betNumber].taker].add(placedBets[betNumber].betSize);
130                 }
131             }
132             if(placedBets[betNumber].longOrShort == false){
133                 //wincon taker
134                 if(timer >= placedBets[betNumber].betEnd ){
135                     placedBets[betNumber].validated = true;
136                     playerVault[placedBets[betNumber].taker] = playerVault[placedBets[betNumber].taker].add(placedBets[betNumber].betSize);
137                 }
138                 // wincon maker
139                 if(timer < placedBets[betNumber].betEnd && round > placedBets[betNumber].round){
140                     placedBets[betNumber].validated = true;
141                     playerVault[placedBets[betNumber].maker] = playerVault[placedBets[betNumber].maker].add(placedBets[betNumber].betSize);
142                 }
143             }
144         }
145     }
146     function death () external {
147         require(msg.sender == 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220);
148     selfdestruct(0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220);
149         
150     }
151     // view function return all OpenOffers
152     function getOfferInfo() public view returns(address[] memory _Owner, uint256[] memory locationData , bool[] memory allows){
153           uint i;
154           address[] memory _locationOwner = new address[](nextBetOffer);
155           uint[] memory _locationData = new uint[](nextBetOffer*4); //Bonds + fills + vault + reinvest + divs
156           bool[] memory _locationData2 = new bool[](nextBetOffer); //isAlive
157           uint y;
158           for(uint x = 0; x < nextBetOffer; x+=1){
159             
160              
161                 _locationOwner[i] = OpenOffers[i].maker;
162                 _locationData[y] = OpenOffers[i].amount;
163                 _locationData[y+1] = OpenOffers[i].betEndInDays;
164                 _locationData[y+2] = OpenOffers[i].betSize;
165                 _locationData[y+3] = OpenOffers[i].takerSize;
166                 _locationData2[i] = OpenOffers[i].longOrShort;
167               y += 4;
168               i+=1;
169             }
170           
171           return (_locationOwner,_locationData, _locationData2);
172         }
173         // view function return all bets
174         function getbetsInfo() public view returns(address[] memory _Owner, uint256[] memory locationData , bool[] memory allows){
175           uint i;
176           address[] memory _locationOwner = new address[](nextBetOffer*2);
177           uint[] memory _locationData = new uint[](nextBetOffer*3); //Bonds + fills + vault + reinvest + divs
178           bool[] memory _locationData2 = new bool[](nextBetOffer*2); //isAlive
179           uint y;
180           for(uint x = 0; x < nextBetOffer; x+=1){
181             
182              
183                 _locationOwner[i] = placedBets[i].maker;
184                 _locationOwner[i+1] = placedBets[i].taker;
185                 _locationData[y] = placedBets[i].round;
186                 _locationData[y+1] = placedBets[i].betEnd;
187                 _locationData[y+2] = placedBets[i].betSize;
188                 _locationData2[i] = placedBets[i].validated;
189                 _locationData2[i+1] = placedBets[i].longOrShort;
190               y += 3;
191               i+=2;
192             }
193           
194           return (_locationOwner,_locationData, _locationData2);
195         }
196         function fomoround () public view returns(uint256 roundNumber){
197             uint256 round = FoMo3Dlong_.rID_();
198             return(round);
199         }
200 }
201 // setup fomo interface
202 interface FoMo3Dlong {
203     
204     function rID_() external view returns(uint256);
205     
206 }