1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract TicTacPotato{
6 
7     /***EVENTS***/
8     event StalematePayout(address adr, uint256 amount);
9 
10     address public ceoAddress;
11     uint256 public lastBidTime;
12     uint256 public contestStartTime;
13     uint256 public lastPot;
14     
15     //mapping (address => uint256) public numTilesOwnedByAddress;
16     mapping (uint256 => address) public indexToAddress;
17     mapping (address => uint256) public cantBidUntil;
18     Tile[] public tiles;
19     
20     uint256 public TIME_TO_STALEMATE=30 minutes;
21     uint256 public NUM_TILES=12;
22     uint256 public START_PRICE=0.005 ether;
23     uint256 public CONTEST_INTERVAL=15 minutes;
24     uint256 public COOLDOWN_TIME=7 minutes;//time you have to wait between buying tiles
25     uint[][]  tests = [[0,1,2],[3,4,5],[6,7,8], [0,3,6],[1,4,7],[2,5,8], [0,4,8],[2,4,6]];
26     /*** DATATYPES ***/
27     struct Tile {
28         address owner;
29         uint256 price;
30     }
31     
32     /*** CONSTRUCTOR ***/
33     function TicTacPotato() public{
34         ceoAddress=msg.sender;
35         contestStartTime=SafeMath.add(now,1 hours);
36         for(uint i = 0; i<NUM_TILES; i++){
37             Tile memory newtile=Tile({owner:address(this),price: START_PRICE});
38             tiles.push(newtile);
39             indexToAddress[i]=address(this);
40         }
41     }
42     
43     /*** PUBLIC FUNCTIONS ***/
44     function buyTile(uint256 index) public payable{
45         require(now>contestStartTime);
46         if(_endContestIfNeededStalemate()){ 
47 
48         }
49         else{
50             Tile storage tile=tiles[index];
51             require(msg.value >= tile.price);
52             require(now >= cantBidUntil[msg.sender]);//ensure timeout has expired
53             cantBidUntil[msg.sender]=SafeMath.add(now,COOLDOWN_TIME);
54             //allow calling transfer() on these addresses without risking re-entrancy attacks
55             require(msg.sender != tile.owner);
56             require(msg.sender != ceoAddress);
57             uint256 sellingPrice=tile.price;
58             uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
59             uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 70), 100));
60             uint256 devFee= uint256(SafeMath.div(SafeMath.mul(sellingPrice, 4), 100));
61             //26 percent remaining in the contract goes to the pot
62             //if the owner is the contract, this is the first purchase, and payment should go to the pot
63             if(tile.owner!=address(this)){
64                 tile.owner.transfer(payment);
65             }
66             ceoAddress.transfer(devFee);
67             //numTilesOwnedByAddress[tile.owner]=SafeMath.sub(numTilesOwnedByAddress[tile.owner],1)
68             tile.price= SafeMath.div(SafeMath.mul(sellingPrice, 115), 70);
69             tile.owner=msg.sender;//transfer ownership
70             indexToAddress[index]=msg.sender;
71             lastBidTime=block.timestamp;
72             if(!_endContestIfNeeded()){//if contest ended through this method, caller will receive entire contract balance anyways.
73                 msg.sender.transfer(purchaseExcess);//returns excess eth
74             }
75         }
76     }
77     function pause() public {
78         require(msg.sender==ceoAddress);
79         require(now<contestStartTime);
80         contestStartTime=SafeMath.add(now,7 days);
81     }
82     function unpause() public{
83         require(msg.sender==ceoAddress);
84         require(now<contestStartTime);
85         _setNewStartTime();
86     }
87     function getBalance() public view returns(uint256 value){
88         return this.balance;
89     }
90     function timePassed() public view returns(uint256 time){
91         if(lastBidTime==0){
92             return 0;
93         }
94         return SafeMath.sub(block.timestamp,lastBidTime);
95     }
96     function timeLeftToContestStart() public view returns(uint256 time){
97         if(block.timestamp>contestStartTime){
98             return 0;
99         }
100         return SafeMath.sub(contestStartTime,block.timestamp);
101     }
102     function timeLeftToBid(address addr) public view returns(uint256 time){
103         if(now>cantBidUntil[addr]){
104             return 0;
105         }
106         return SafeMath.sub(cantBidUntil[addr],now);
107     }
108     function timeLeftToCook() public view returns(uint256 time){
109         return SafeMath.sub(TIME_TO_STALEMATE,timePassed());
110     }
111     function contestOver() public view returns(bool){
112         return timePassed()>=TIME_TO_STALEMATE;
113     }
114     function haveIWon() public view returns(bool){
115         return checkWinner(msg.sender);
116     }
117     
118      // 0 1 2
119     // 3 4 5
120     // 6 7 8
121     function checkWinner(address a) constant returns (bool){
122         for(uint i =0; i < 8;i++){
123             uint[] memory b = tests[i];
124             if(indexToAddress[b[0]] ==a && indexToAddress[b[1]]==a && indexToAddress[b[2]]==a) return true;
125         }
126         return false;
127     }
128     
129     /*** PRIVATE FUNCTIONS ***/
130     
131     function _endContestIfNeeded() private returns(bool){
132         if(haveIWon()){
133             lastPot=this.balance;
134             msg.sender.transfer(this.balance);//send winner the pot
135             lastBidTime=0;
136             _resetTiles();
137             _setNewStartTime();
138             return true;
139         }
140         return false;
141     }
142     //for ending the contest in a stalemate
143     function _endContestIfNeededStalemate() private returns(bool){
144         if(timePassed()>=TIME_TO_STALEMATE){
145             //contest over, refund anything paid
146             msg.sender.transfer(msg.value);
147             lastPot=this.balance;
148             _stalemateTransfer();
149             lastBidTime=0;
150             _resetTiles();
151             _setNewStartTime();
152             return true;
153         }
154         return false;
155     }
156     //transfers various amounts to the holders of the stalemate cards
157     function _stalemateTransfer() private{
158         uint payout=this.balance;
159         //pay the pot to holders of the stalemate cards
160         for(uint i=9;i<12;i++){
161             require(msg.sender != indexToAddress[i]);
162             if(indexToAddress[i]!=address(this)){
163                 uint proportion=(i-8)*15;
164                 indexToAddress[i].transfer(uint256(SafeMath.div(SafeMath.mul(payout, proportion), 100)));
165                 emit StalematePayout(indexToAddress[i], uint256(SafeMath.div(SafeMath.mul(payout, proportion), 100)));
166             }
167         }
168     }
169     function _resetTiles() private{
170         for(uint i = 0; i<NUM_TILES; i++){
171             //numTilesOwnedByAddress[tiles[i].owner]=0;
172             Tile memory newtile=Tile({owner:address(this),price: START_PRICE});
173             tiles[i]=newtile;
174             indexToAddress[i]=address(this);
175         }
176         //numTilesOwnedByAddress[address(this)]=9;
177     }
178     function _setNewStartTime() private{
179             contestStartTime=SafeMath.add(now,CONTEST_INTERVAL);
180     }
181 }
182 library SafeMath {
183 
184   /**
185   * @dev Multiplies two numbers, throws on overflow.
186   */
187   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188     if (a == 0) {
189       return 0;
190     }
191     uint256 c = a * b;
192     assert(c / a == b);
193     return c;
194   }
195 
196   /**
197   * @dev Integer division of two numbers, truncating the quotient.
198   */
199   function div(uint256 a, uint256 b) internal pure returns (uint256) {
200     // assert(b > 0); // Solidity automatically throws when dividing by 0
201     uint256 c = a / b;
202     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203     return c;
204   }
205 
206   /**
207   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
208   */
209   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210     assert(b <= a);
211     return a - b;
212   }
213 
214   /**
215   * @dev Adds two numbers, throws on overflow.
216   */
217   function add(uint256 a, uint256 b) internal pure returns (uint256) {
218     uint256 c = a + b;
219     assert(c >= a);
220     return c;
221   }
222 }