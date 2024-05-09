1 pragma solidity ^0.5.0;
2 //p3Dank.io
3 //send 0.25 ETH to contract to purchase 3 plants. 
4 //you can only rebuy when you have ZERO plants
5 //contract will take all ether sent and add it to the pot >>>NO REFUNDS<<<
6 //only send 0.25 ether, no more, no less
7 //Block plant, Chain plant, Fork plant
8 //BLOCK smashes fork
9 //FORK forks the chain
10 //CHAIN adds the block
11 //plants automatically grow over time 
12 //the older the plants get a bigger % bonus for selling
13 //choose to sell 1 plant or attack at random every 7 hours 
14 //if your random attack wins the rock paper scissors, you sell the targets house for 50% its base value(no bonus)
15 //sucessful attacks raise the value of every other plant, >>DONT MISS ATTACKS<<
16 //sold plants have a bonus and reduce the value of every other plant. 
17 //Sell bonus is 2x after 42000 blocks, Max bonus of 4x after 69420 blocks
18 //sell price = (total eth in contract) * (growth of plant being sold) / (total growth in game) + (big plant bonus)
19 //1.2% dev cut 2% buys p3d. 96.8% back to players. p3d divs go to pot
20 //tron version of the game soon with mechanics more suited for that chain
21 //A 1 eth entry cost version after we see how the economics play out
22 //If this works as intended the game expands and contracts to any amount of players and never ends
23 //thanks to Team Just and Spielley for the code I used
24 
25 library SafeMath {
26     function add(uint a, uint b) internal pure returns (uint c) {
27         c = a + b;
28         require(c >= a);
29     }
30     function sub(uint a, uint b) internal pure returns (uint c) {
31         require(b <= a);
32         c = a - b;
33     }
34     function mul(uint a, uint b) internal pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38     function div(uint a, uint b) internal pure returns (uint c) {
39         require(b > 0);
40         c = a / b;
41         }
42     }
43 
44 interface HourglassInterface  {
45     function buy(address _playerAddress) payable external returns(uint256);
46     function withdraw() external;
47     function dividendsOf(address _playerAddress) external view returns(uint256);
48     function balanceOf(address _playerAddress) external view returns(uint256);
49 }
50 
51 //import "browser/safemath.sol";
52 //import "browser/hourglassinterface.sol";
53 
54 contract p3Dank  {
55     using SafeMath for uint;
56     uint256 public _totalhouses; // total number of houses in the game, used to calc divs
57     uint256 public blocksbeforeaction = 1680;// blocks between player action. 7 hours / 420 minutes / 3 moves per day
58     uint256 public nextFormation;// next spot in formation
59     mapping(address => uint256)public _playerhouses; // number of houses owned by player
60     mapping(address => uint256)public lastmove;//blocknumber lastMove
61     mapping(address => uint256) buyblock;// block that houses were purchased by a player
62     address payable happydev = 0xDC6dfe8040fc162Ab318De99c63Ec2cd0e203010; // dev cut
63     address payable feeder; //address of p3d feeder contract
64     address p3dref;
65 
66    struct house { //houses for the battlefield
67        address owner; //who owns the house
68        uint8 rpstype; //what type of house is it 1=roc 2=pap 3=sis
69    }
70 
71     mapping(uint256 => house)public formation;// the playing field
72 
73     modifier ishuman() {//"real" players only
74         address _addr = msg.sender;
75         uint256 _codeLength;
76         assembly {_codeLength := extcodesize(_addr)}
77         require(_codeLength == 0, "sorry humans only");
78         _;
79     }
80 
81     modifier canmove() {
82           address sender = msg.sender;
83           require(_playerhouses[sender] > 0);
84           require(canimoveyet());
85           _;
86     }
87 
88     function buyp3d4me(uint256 value) public payable {//
89         P3Dcontract_.buy.value(value)(p3dref);//buy p3d
90     }
91 
92     bool feedset;
93 
94     function setfeedaddress(address payable feedadd) public {
95         require (feedset == false);
96         feeder = feedadd;
97         feedset = true;
98     }
99 
100     function () external payable{}
101 
102     function buyhouses() ishuman() public payable { // houses... plants... tulips ... its all good
103         uint256 value = msg.value;
104         if(value == 250 finney){// buying 3 houses costs 0.25 eth
105             address sender = msg.sender;
106             if(_playerhouses[sender] == 0 ){ // check that user has no houses
107                 _playerhouses[sender] = 3; // add houses to players count
108                 uint256 next = nextFormation;
109                 formation[next++] = house(sender, 1);// add houses to playing field
110                 formation[next++] = house(sender, 2);// roc = 1, pap =2, sis = 3.
111                 formation[next++] = house(sender, 3);
112                 nextFormation = next;
113                 lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
114                 buyblock[sender] = block.number; // log the buy block of the sender
115                 _totalhouses += 3;// update totalSupply
116                 feeder.transfer(5 finney);
117                 happydev.transfer(3 finney);
118                 } } }
119 
120     bool gameon;
121 
122     function startgame() public payable {
123         uint256 value = msg.value;
124         require(value == 250 finney);// buying 3 houses costs 0.25 eth
125         require (gameon == false);
126         address sender = msg.sender;
127         _playerhouses[sender] = _playerhouses[sender]+3;// add houses to players count
128         formation[nextFormation] = house(sender, 1);// add houses to playing field
129         nextFormation++;
130         formation[nextFormation] = house(sender, 2);// roc = 1, pap =2, sis = 3.
131         nextFormation++;
132         formation[nextFormation] = house(sender, 3);
133         nextFormation++;
134         lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
135         buyblock[sender] = block.number; // log the buy block of the sender
136         _totalhouses = _totalhouses+3;// update totalSupply
137          feeder.transfer(5 finney);
138         happydev.transfer(3 finney);
139         lastupdateblock = block.number;
140         gameon = true;
141     }
142 
143     //divsection
144     uint256 lastupdateblock;
145     uint256 totaldivpts;
146 
147     function updateglobal() internal {                       
148         totaldivpts = gametotaldivs();
149         lastupdateblock = block.number;//updated
150         lastmove[msg.sender] = block.number; // reset lastmove of attacker
151     }
152 
153     function rekt(uint8 typeToKill) internal {
154         updateglobal();
155         uint256 attacked = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, tx.origin))) % nextFormation;
156         if(formation[attacked].rpstype == typeToKill) {
157             address payable sender = msg.sender;
158             address killed = formation[attacked].owner;//set address of attacked player
159             formation[attacked] = formation[--nextFormation];//reform playing field
160             delete formation[nextFormation];  //delete unused formation
161             uint256 playerdivpts = block.number.sub(buyblock[killed]);//figure out how big robbed plant is
162             uint256 robbed = (address(this).balance).mul(playerdivpts).div(totaldivpts).div(2); //figure out how much was robbed
163             totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
164             _totalhouses--;//update total houses in game
165             _playerhouses[killed]--;//update attacked players houses
166             sender.transfer(robbed);//pay the robber
167         } }
168 
169     function rockattack() canmove() public { //rock attack function
170         rekt(3);
171         }
172 
173     function sisattack() canmove() public { //sicssor attack function
174         rekt(1);
175         }
176 
177     function papattack() canmove() public {//paper attack function
178         rekt(2);
179         }
180 
181     function sellhouse (uint256 selling) canmove() public {// house sell function
182         address payable sender = msg.sender;
183         address beingsold = formation[selling].owner;
184         if (beingsold == sender){ // how to comfirm sender is owner
185             updateglobal();
186             uint256 next = --nextFormation;
187             formation[selling] = formation[next];
188             delete formation[next];
189             _totalhouses--;//update total houses in game
190             _playerhouses[sender]--;//update selling players houses
191             uint256 maxbuyblock = 69420;
192             uint256 playerdivpts = block.number.sub(buyblock[sender]);
193             uint256 sold;
194             if (playerdivpts >= maxbuyblock) {
195                 sold = (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
196                 }
197             else {
198                 uint256 payoutmultiplier = playerdivpts.mul(playerdivpts).mul(10000).div(1953640000).add(10000);
199                 sold = (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
200             }
201             totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
202             sender.transfer(sold);//payout
203             } } 
204 
205     //p3d section
206     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
207         function P3DDivstocontract() public{
208             address newref = msg.sender;
209             p3dref = newref;
210             P3Dcontract_.withdraw(); //withdraw p3d divs into contract 
211         }
212         function amountofp3d() external view returns(uint256){//balanceof = Retrieve the tokens owned by the caller.
213             return ( P3Dcontract_.balanceOf(address(this)))  ;
214         }
215         function harvestabledivs() view  public returns(uint256){//dividendsof = Retrieve the dividend balance of any single address.
216             return ( P3Dcontract_.dividendsOf(address(this)))  ;
217         }
218         
219 
220     //view functions
221     function singleplantdivs ()public view returns(uint256){ //how many blocks old are my plants?
222         return(block.number.sub(buyblock[msg.sender]));
223     }
224     function howmanyplants ()public view returns(uint256){ //how many plants do I have?
225         return(_playerhouses[msg.sender]);
226     }
227     function whatblockmove ()public view returns(uint256){  // what block # can I make my next move at
228         return(lastmove[msg.sender]).add(blocksbeforeaction);
229     }
230     function canimoveyet ()public view returns(bool){ //can i move
231         if (blocksbeforeaction <= (block.number).sub(lastmove[msg.sender])) return true;
232     }
233     function howmucheth ()public view returns(uint256){//how much eth is in the contract
234         return address(this).balance;
235     }
236     function gametotaldivs ()public view returns(uint256){//how many div points are in the game right now
237         return (block.number).sub(lastupdateblock).mul(_totalhouses).add(totaldivpts);
238     }
239     function singleplantpayout ()public view returns(uint256){
240         uint256 playerdivpts = block.number.sub(buyblock[msg.sender]);
241         uint256 maxbuyblock = 69420;
242         if (playerdivpts >= maxbuyblock) {
243             return (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
244         }
245         else {
246             uint256 payoutmultiplier = playerdivpts.mul(playerdivpts).mul(10000).div(1953640000).add(10000);
247             return (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
248         }
249     }
250 
251 //thanks for playing
252 }