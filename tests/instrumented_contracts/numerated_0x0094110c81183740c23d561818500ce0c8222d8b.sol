1 pragma solidity ^0.4.0;
2 contract Bitscreen {
3 
4     struct IPFSHash {
5     bytes32 hash;
6     uint8 hashFunction;
7     uint8 size;
8     }
9     event ImageChange(bytes32 _hash,uint8 _hashFunction,uint8 _size, uint _cost);
10     event PriceChange(uint price);
11     
12     struct ScreenData {
13     uint currTopBid;
14     uint currTopBidTimeStamp;
15     uint lifetimeValue; //total eth that has gone into contract (historical)
16     uint periodPercentagePriceDecrease;
17     uint PriceDecreasePeriodLengthSecs;
18     address currHolder;
19     uint8 heightRatio;
20     uint8 widthRatio;
21     string country;
22     }
23     
24 
25     struct ContentRules {
26         bool sexual;
27         bool violent;
28         bool political;
29         bool controversial;
30         bool illegal; //content that goes agaisnt the law of the country it is operating in
31     }
32     
33     event RuleChange(bool _sexual,bool _violent,bool _political,bool _controversial,bool _illegal);
34 
35     struct AdBuyerInfo{
36         uint numberAdBuys;
37         bool cashedOut;
38     }
39     
40     struct DividendInfo{
41         uint  activeAdBuysForDividend; //gets lowered (according to their numberAdBuys) when someone cashes out
42         uint  ownerpool;
43         uint  dividendPool;
44         mapping(address => AdBuyerInfo) adbuyerMap;
45     }
46     
47 
48     //contract variables
49 
50     //creator of the contract
51     address public owner;
52     
53     //total eth currently in contract
54     uint public contractValue;
55 
56     //current ipfs hash 
57     IPFSHash public currPicHash;
58     
59     //current state of the screen
60     ScreenData public screenstate;
61     ContentRules public rules;
62     address[] private badAddresses;
63     
64     //current dividend info
65     DividendInfo public dividendinfo;
66 
67     function Bitscreen(bytes32 _ipfsHash, uint8 _ipfsHashFunc, uint8 _ipfsHashSize, uint8 _heightRatio, uint8 _widthRatio, string _country, uint _periodPercentagePriceDecrease,uint _priceDecreasePeriodLengthSecs) public {
68         owner = msg.sender;
69         currPicHash = IPFSHash(_ipfsHash,_ipfsHashFunc,_ipfsHashSize);
70         screenstate = ScreenData(0,now,0,_periodPercentagePriceDecrease,_priceDecreasePeriodLengthSecs,msg.sender,_heightRatio,_widthRatio,_country);
71         rules = ContentRules(false,false,false,false,false);
72         dividendinfo=DividendInfo(0,0,0);
73     }
74     
75 
76     function withdrawOwnerAmount() external{
77         if(msg.sender == owner) { // Only let the contract creator do this
78             uint withdrawAmount = dividendinfo.ownerpool;
79             dividendinfo.ownerpool=0;
80             contractValue-=withdrawAmount;
81             msg.sender.transfer(withdrawAmount);
82         }else{
83             revert();
84         }
85     }
86     
87     
88     //request to know how much dividend you can get
89     function inquireDividentAmount()  view external returns(uint){
90         uint dividendToSend=calcuCurrTxDividend(msg.sender);
91         return dividendToSend;
92     }
93     
94     function withdrawDividend() external{
95         uint dividendToSend=calcuCurrTxDividend(msg.sender);
96         if(dividendToSend==0){
97             revert();
98         }else{
99         uint senderNumAdbuys=dividendinfo.adbuyerMap[msg.sender].numberAdBuys;
100         dividendinfo.activeAdBuysForDividend-=senderNumAdbuys;
101         dividendinfo.dividendPool-=dividendToSend;
102         contractValue-=dividendToSend;
103         dividendinfo.adbuyerMap[msg.sender].cashedOut=true;
104         dividendinfo.adbuyerMap[msg.sender].numberAdBuys=0;
105         
106         //send
107         msg.sender.transfer(dividendToSend);
108         }
109     }
110     
111     function calcuCurrTxDividend(address dividentRecepient) view private returns(uint) {
112         uint totaldividend;
113         if(dividendinfo.activeAdBuysForDividend==0 || dividendinfo.adbuyerMap[dividentRecepient].cashedOut){ 
114             totaldividend=0;
115         }else{
116             totaldividend=(dividendinfo.dividendPool*dividendinfo.adbuyerMap[dividentRecepient].numberAdBuys)/(dividendinfo.activeAdBuysForDividend);
117         }
118         return totaldividend;
119     }
120     
121     function getBadAddresses() external constant returns (address[]) {
122         if(msg.sender == owner) {
123             return badAddresses;
124         }else{
125             revert();
126         }
127     }
128 
129     function changeRules(bool _sexual,bool _violent, bool _political, bool _controversial, bool _illegal) public {
130                 if(msg.sender == owner) {
131                 rules.sexual=_sexual;
132                 rules.violent=_violent;
133                 rules.political=_political;
134                 rules.controversial=_controversial;
135                 rules.illegal=_illegal;
136                 
137                 RuleChange(_sexual,_violent,_political,_controversial,_illegal);
138                 
139                 }else{
140                 revert();
141                 }
142     }
143 
144 
145     function calculateCurrDynamicPrice() public view returns (uint){
146         uint currDynamicPrice;
147         uint periodLengthSecs=screenstate.PriceDecreasePeriodLengthSecs;
148         
149         uint ellapsedPeriodsSinceLastBid= (now - screenstate.currTopBidTimeStamp)/periodLengthSecs;
150         
151         uint totalDecrease=((screenstate.currTopBid*screenstate.periodPercentagePriceDecrease*ellapsedPeriodsSinceLastBid)/100);
152         
153         if(totalDecrease>screenstate.currTopBid){
154             currDynamicPrice=0;
155         }else{
156             currDynamicPrice= screenstate.currTopBid-totalDecrease;
157         }
158         
159         return currDynamicPrice;
160         
161     }
162 
163     function truncToThreeDecimals(uint amount) private pure returns (uint){
164         return ((amount/1000000000000000)*1000000000000000);
165     }
166 
167 
168     function changeBid(bytes32 _ipfsHash, uint8 _ipfsHashFunc, uint8 _ipfsHashSize) payable external {
169         
170             uint dynamicPrice=calculateCurrDynamicPrice();
171         
172             if(msg.value>dynamicPrice) { //prev: msg.value>screenstate.currTopBid
173             
174                 if(truncToThreeDecimals(msg.value)-truncToThreeDecimals(dynamicPrice)<1000000000000000){
175                     revert();
176                 }else{
177                     
178                 screenstate.currTopBid=msg.value;
179                 screenstate.currTopBidTimeStamp=now;
180                 screenstate.currHolder=msg.sender;
181                 
182                 screenstate.lifetimeValue+=msg.value;
183                 contractValue+=msg.value;//total eth CURRENTLY IN contract
184                 //store 33% to dividend pool, send 66% to ownerpool
185                 dividendinfo.dividendPool+=msg.value/3;
186                 dividendinfo.ownerpool+=((msg.value*2)/3);
187                 
188                 currPicHash.hash=_ipfsHash;
189                 currPicHash.hashFunction=_ipfsHashFunc;
190                 currPicHash.size=_ipfsHashSize;
191                 
192                 dividendinfo.activeAdBuysForDividend++;
193                 if(dividendinfo.adbuyerMap[msg.sender].numberAdBuys==0){
194                     dividendinfo.adbuyerMap[msg.sender]=AdBuyerInfo(1,false);
195                 }else{
196                     dividendinfo.adbuyerMap[msg.sender].numberAdBuys++;
197                 }
198                 
199                 ImageChange(_ipfsHash,_ipfsHashFunc,_ipfsHashSize,screenstate.currTopBid);
200                 
201                 }
202                 
203             }else {
204                 revert();
205             }
206     }
207     
208     function emergencyOverwrite(bytes32 _ipfsHash, uint8 _ipfsHashFunc, uint8 _ipfsHashSize) external {
209         if(msg.sender == owner) { // Only let the contract creator do this
210             badAddresses.push(screenstate.currHolder);
211             currPicHash.hash=_ipfsHash;
212             currPicHash.hashFunction=_ipfsHashFunc;
213             currPicHash.size=_ipfsHashSize;
214             screenstate.currHolder=msg.sender;
215             ImageChange(_ipfsHash,_ipfsHashFunc,_ipfsHashSize,0);
216         }else{
217             revert();
218         }
219     }
220     
221     function changePriceDecreasePeriod(uint newPeriod) public{
222         require(msg.sender==owner);
223         screenstate.PriceDecreasePeriodLengthSecs=newPeriod;
224     }
225     
226     function changePriceDecreasePercent(uint newPercent) public{
227         require(msg.sender==owner);
228         screenstate.periodPercentagePriceDecrease=newPercent;
229     }
230     
231     
232     function () payable public {}
233 
234 }