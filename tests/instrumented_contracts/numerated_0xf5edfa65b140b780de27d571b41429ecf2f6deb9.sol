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
47     
48     FoMo3Dlong constant FoMo3Dlong_ = FoMo3Dlong(0xA62142888ABa8370742bE823c1782D17A0389Da1);    
49     mapping(uint256 => bet) public placedBets;
50     uint256 public nextBetInLine;
51     mapping(uint256 => offer) public OpenOffers;
52     uint256 public nextBetOffer;
53     mapping(address => uint256) public playerVault;
54     // functions
55     function vaultToWallet() public {
56         
57         address sender = msg.sender;
58         require(playerVault[sender] > 0);
59         uint256 value = playerVault[sender];
60         playerVault[sender] = 0;
61         sender.transfer(value);
62         
63     }
64     function () external payable{
65         address sender= msg.sender;
66         playerVault[sender] = playerVault[sender].add(msg.value);
67     }
68     function setupOffer(uint256 amountOffers, bool longOrShort, uint256 endingInDays, uint256 makerGive, uint256 takerGive) public payable{
69         address sender = msg.sender;
70         uint256 value = msg.value;
71         require(value >= amountOffers.mul(makerGive));
72         
73         OpenOffers[nextBetOffer].maker = sender;
74         OpenOffers[nextBetOffer].amount = amountOffers;
75         OpenOffers[nextBetOffer].longOrShort = longOrShort;
76         OpenOffers[nextBetOffer].betEndInDays = endingInDays;
77         OpenOffers[nextBetOffer].betSize = makerGive;
78         OpenOffers[nextBetOffer].takerSize = takerGive;
79         
80         nextBetOffer++;
81     }
82     function addToExistingOffer(uint256 offerNumber, uint256 amountOffers) public payable{
83         address sender = msg.sender;
84         uint256 value = msg.value;
85         require(sender == OpenOffers[offerNumber].maker);
86         require(value >= OpenOffers[offerNumber].betSize.mul(amountOffers));
87         OpenOffers[offerNumber].amount = OpenOffers[offerNumber].amount.add(amountOffers);
88     }
89     function removeFromExistingOffer(uint256 offerNumber, uint256 amountOffers) public {
90         address sender = msg.sender;
91         
92         require(sender == OpenOffers[offerNumber].maker);
93         require(amountOffers <= OpenOffers[offerNumber].amount);
94         OpenOffers[offerNumber].amount = OpenOffers[offerNumber].amount.sub(amountOffers);
95         playerVault[sender] = playerVault[sender].add(amountOffers.mul(OpenOffers[offerNumber].betSize));
96     }
97     function takeOffer(uint256 offerNumber, uint256 amountOffers) public payable{
98         // 
99         address sender = msg.sender;
100         uint256 value = msg.value;
101         uint256 timer = now;
102         
103         require(amountOffers <= OpenOffers[offerNumber].amount );
104         require(value >= amountOffers.mul(OpenOffers[offerNumber].takerSize));
105         placedBets[nextBetInLine].longOrShort = OpenOffers[offerNumber].longOrShort;
106         placedBets[nextBetInLine].maker = OpenOffers[offerNumber].maker;
107         placedBets[nextBetInLine].taker = sender;
108         uint256 timeframe = OpenOffers[offerNumber].betEndInDays * 1 days;
109         placedBets[nextBetInLine].betEnd =  timer.add(timeframe);
110         placedBets[nextBetInLine].round = FoMo3Dlong_.rID_();
111         placedBets[nextBetInLine].betSize = value.add(amountOffers.mul(OpenOffers[offerNumber].betSize));
112         OpenOffers[offerNumber].amount = OpenOffers[offerNumber].amount.sub(amountOffers);
113         nextBetInLine++;
114     }
115     function validateBet(uint256 betNumber) public {
116         
117         (uint256 _end,bool _ended,uint256 _eth) = fomoroundInfo(placedBets[betNumber].round);
118         uint256 timer = _end;
119         
120         if(placedBets[betNumber].validated == false){
121             if(placedBets[betNumber].longOrShort == true){
122                 //wincon maker
123                 if(timer >= placedBets[betNumber].betEnd){
124                     placedBets[betNumber].validated = true;
125                     playerVault[placedBets[betNumber].maker] = playerVault[placedBets[betNumber].maker].add(placedBets[betNumber].betSize);
126                 }
127                 // wincon taker
128                 if(timer < placedBets[betNumber].betEnd && _ended == true){
129                     placedBets[betNumber].validated = true;
130                     playerVault[placedBets[betNumber].taker] = playerVault[placedBets[betNumber].taker].add(placedBets[betNumber].betSize);
131                 }
132             }
133             if(placedBets[betNumber].longOrShort == false){
134                 //wincon taker
135                 if(timer >= placedBets[betNumber].betEnd ){
136                     placedBets[betNumber].validated = true;
137                     playerVault[placedBets[betNumber].taker] = playerVault[placedBets[betNumber].taker].add(placedBets[betNumber].betSize);
138                 }
139                 // wincon maker
140                 if(timer < placedBets[betNumber].betEnd &&  _ended == true){
141                     placedBets[betNumber].validated = true;
142                     playerVault[placedBets[betNumber].maker] = playerVault[placedBets[betNumber].maker].add(placedBets[betNumber].betSize);
143                 }
144             }
145         }
146     }
147     function death () external {
148         require(msg.sender == 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220);
149     selfdestruct(0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220);
150         
151     }
152     // view function return all OpenOffers
153     function getOfferInfo() public view returns(address[] memory _Owner, uint256[] memory locationData , bool[] memory allows){
154           uint i;
155           address[] memory _locationOwner = new address[](nextBetOffer);
156           uint[] memory _locationData = new uint[](nextBetOffer*4); //Bonds + fills + vault + reinvest + divs
157           bool[] memory _locationData2 = new bool[](nextBetOffer); //isAlive
158           uint y;
159           for(uint x = 0; x < nextBetOffer; x+=1){
160             
161              
162                 _locationOwner[i] = OpenOffers[i].maker;
163                 _locationData[y] = OpenOffers[i].amount;
164                 _locationData[y+1] = OpenOffers[i].betEndInDays;
165                 _locationData[y+2] = OpenOffers[i].betSize;
166                 _locationData[y+3] = OpenOffers[i].takerSize;
167                 _locationData2[i] = OpenOffers[i].longOrShort;
168               y += 4;
169               i+=1;
170             }
171           
172           return (_locationOwner,_locationData, _locationData2);
173         }
174         // view function return all bets
175         function getbetsInfo() public view returns(address[] memory _Owner, uint256[] memory locationData , bool[] memory allows){
176           uint i;
177           address[] memory _locationOwner = new address[](nextBetOffer*2);
178           uint[] memory _locationData = new uint[](nextBetOffer*3); //Bonds + fills + vault + reinvest + divs
179           bool[] memory _locationData2 = new bool[](nextBetOffer*2); //isAlive
180           uint y;
181           for(uint x = 0; x < nextBetOffer; x+=1){
182             
183              
184                 _locationOwner[i] = placedBets[i].maker;
185                 _locationOwner[i+1] = placedBets[i].taker;
186                 _locationData[y] = placedBets[i].round;
187                 _locationData[y+1] = placedBets[i].betEnd;
188                 _locationData[y+2] = placedBets[i].betSize;
189                 _locationData2[i] = placedBets[i].validated;
190                 _locationData2[i+1] = placedBets[i].longOrShort;
191               y += 3;
192               i+=2;
193             }
194           
195           return (_locationOwner,_locationData, _locationData2);
196         }
197         function fomoround () public view returns(uint256 roundNumber){
198             uint256 round = FoMo3Dlong_.rID_();
199             return(round);
200         }//FoMo3Dlong_.rID_();
201         function fomoroundInfo (uint256 roundNumber) public view returns(uint256 _end,bool _ended,uint256 _eth){
202            plyr = roundNumber;
203             
204             (uint256 plyr,uint256 team,uint256 end,bool ended,uint256 strt,uint256 keys,uint256 eth,uint256 pot,uint256 mask,uint256 ico,uint256 icoGen,uint256 icoAvg) = FoMo3Dlong_.round_(plyr);
205             return( end, ended, eth);
206         }
207 }
208 // setup fomo interface
209 interface FoMo3Dlong {
210     
211     function rID_() external view returns(uint256);
212     function round_(uint256) external view returns(uint256 plyr,uint256 team,uint256 end,bool ended,uint256 strt,uint256 keys,uint256 eth,uint256 pot,uint256 mask,uint256 ico,uint256 icoGen,uint256 icoAvg);
213 //uint256 plyr,uint256 team,uint256 end,bool ended,uint256 strt,uint256 keys,uint256 eth,uint256 pot,uint256 mask,uint256 ico,uint256 icoGen,uint256 icoAvg; // average key price for ICO phase
214     
215 }