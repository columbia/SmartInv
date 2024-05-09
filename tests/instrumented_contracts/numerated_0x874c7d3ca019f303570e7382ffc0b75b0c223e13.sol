1 pragma solidity ^0.5.0;
2 //p3Dank.io
3 //A never ending free for all strategy game
4 //send 0.2 ETH to contract to play
5 //you get 3 lives/plants/houses(it can be anything, you get 3)
6 //you cant rebuy till your out
7 //each life has a type
8 //BLOCK smashes fork
9 //FORK forks the chain
10 //CHAIN adds the block
11 //plants automatically grow over time 
12 //the older the plants get a bigger % bonus for selling
13 //choose to sell 1 plant or attack at random every 7 hours 
14 //if your random attack wins the rock paper scissors...
15 //you sell the targets plant for 50% its base value(no bonus)
16 //sucessful attacks raise the value of every other plant, >>DONT MISS ATTACKS<<
17 //sold plants have a bonus and reduce the value of every other plant. 
18 //Sell bonus is 2x after 42000 blocks, Max bonus of 4x after 69420 blocks
19 //sell price = (total eth in contract) * (growth of plant being sold) / (total growth in game) + (big plant bonus)
20 //1% dev cut 99% back to players.
21 //If this works as intended the game expands and contracts to any amount of players and never ends
22 
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function sub(uint a, uint b) internal pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32     function mul(uint a, uint b) internal pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36     function div(uint a, uint b) internal pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39         }
40     }
41 
42 
43 
44 //import "browser/safemath.sol";
45 
46 contract p3Dank  {
47     using SafeMath for uint;
48     uint256 public _totalhouses; // total number of houses in the game, used to calc divs
49     uint256 public blocksbeforeaction = 1680;// blocks between player action. 7 hours / 420 minutes / 3 moves per day
50     uint256 public nextFormation;// next spot in formation
51     mapping(address => uint256)public _playerhouses; // number of houses owned by player
52     mapping(address => uint256)public lastmove;//blocknumber lastMove
53     mapping(address => uint256) buyblock;// block that houses were purchased by a player
54     address payable happydev = 0xDC6dfe8040fc162Ab318De99c63Ec2cd0e203010; // dev cut
55 
56    struct house { //houses for the battlefield
57        address owner; //who owns the house
58        uint8 rpstype; //what type of house is it 1=roc 2=pap 3=sis
59    }
60 
61     mapping(uint256 => house)public formation;// the playing field
62 
63     //modifiers
64 
65     modifier ishuman() {//"real" players only
66         address _addr = msg.sender;
67         uint256 _codeLength;
68         assembly {_codeLength := extcodesize(_addr)}
69         require(_codeLength == 0, "sorry humans only");
70         _;
71     }
72 
73     modifier canmove() {
74           address sender = msg.sender;
75           require(_playerhouses[sender] > 0);
76           require(canimoveyet());
77           _;
78     }
79 
80     //events
81 
82     event sell (address seller, uint256 plantsize, uint256 cashout);
83     event battle(address attacker, uint8 ktype, address defender);
84     event win (uint256 position, uint256 sizesold, uint256 amountsent);  
85     event buyin (address buyer, uint256 blockbuy);  
86 
87     function () external payable{}
88 
89     function buyhouses() ishuman() public payable { // houses... plants... lives ... its all good
90         uint256 value = msg.value;
91         if(value == 200 finney){// buying 3 houses costs 0.2 eth
92             address sender = msg.sender;
93             if(_playerhouses[sender] == 0 ){ // check that user has no houses
94                 _playerhouses[sender] = 3; // add houses to players count
95                 uint256 next = nextFormation;
96                 formation[next++] = house(sender, 1);// add houses to playing field
97                 formation[next++] = house(sender, 2);// roc = 1, pap =2, sis = 3.
98                 formation[next++] = house(sender, 3);
99                 nextFormation = next;
100                 lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
101                 buyblock[sender] = block.number; // log the buy block of the sender
102                 _totalhouses += 3;// update totalSupply
103                 happydev.transfer(2 finney);
104                 totaldivpts += 3000;
105                 emit buyin(sender, buyblock[sender]);
106                 } } }
107 
108     bool gameon;
109 
110     function startgame() public payable {
111         uint256 value = msg.value;
112         require(value == 200 finney);// buying 3 houses costs 0.2 eth
113         require (gameon == false);
114         address sender = msg.sender;
115         _playerhouses[sender] = _playerhouses[sender]+3;// add houses to players count
116         formation[nextFormation] = house(sender, 1);// add houses to playing field
117         nextFormation++;
118         formation[nextFormation] = house(sender, 2);// roc = 1, pap =2, sis = 3.
119         nextFormation++;
120         formation[nextFormation] = house(sender, 3);
121         nextFormation++;
122         lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
123         buyblock[sender] = block.number; // log the buy block of the sender
124         _totalhouses = _totalhouses+3;// update totalSupply
125         happydev.transfer(2 finney);
126         lastupdateblock = block.number;
127         gameon = true;
128         totaldivpts += 3000;
129         emit buyin(sender, buyblock[sender]);
130     }
131 
132     //divsection
133     uint256 lastupdateblock;
134     uint256 totaldivpts;
135 
136     function updateglobal() internal {                       
137         totaldivpts = gametotaldivs();
138         lastupdateblock = block.number;//updated
139         lastmove[msg.sender] = block.number; // reset lastmove of attacker
140     }
141 
142     function rekt(uint8 typeToKill) internal {
143         updateglobal();
144         uint256 attacked = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, tx.origin))) % nextFormation;
145         uint256 _rpstype = formation[attacked].rpstype;
146         address killed = formation[attacked].owner;//set address of attacked player
147         address payable sender = msg.sender;
148         if(_rpstype == typeToKill) {
149             formation[attacked] = formation[--nextFormation];//reform playing field
150             delete formation[nextFormation];  //delete unused formation
151             uint256 playerdivpts = block.number.sub(buyblock[killed]).add(1000);//figure out how big robbed plant is
152             uint256 robbed = (address(this).balance).mul(playerdivpts).div(totaldivpts).div(2); //figure out how much was robbed
153             totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
154             _totalhouses--;//update total houses in game
155             _playerhouses[killed]--;//update attacked players houses
156             sender.transfer(robbed);//pay the robber
157             emit win(attacked, playerdivpts, robbed);  
158         }
159         emit battle(sender, typeToKill, killed);
160         } 
161   
162         
163 
164     function rockattack() canmove() public { //rock attack function
165         rekt(3);
166         }
167 
168     function sisattack() canmove() public { //sicssor attack function
169         rekt(1);
170         }
171 
172     function papattack() canmove() public {//paper attack function
173         rekt(2);
174         }
175 
176     function sellhouse (uint256 selling) canmove() public {// house sell function
177         address payable sender = msg.sender;
178         address beingsold = formation[selling].owner;
179         if (beingsold == sender){ // how to comfirm sender is owner
180             updateglobal();
181             uint256 next = --nextFormation;
182             formation[selling] = formation[next];
183             delete formation[next];
184             _totalhouses--;//update total houses in game
185             _playerhouses[sender]--;//update selling players houses
186             uint256 maxbuyblock = 69420;
187             uint256 playerdivpts = block.number.sub(buyblock[sender]).add(1000);
188             uint256 sold;
189             if (playerdivpts >= maxbuyblock) {
190                 sold = (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
191                 }
192             else {
193                 uint256 payoutmultiplier = playerdivpts.mul(playerdivpts).mul(10000).div(1953640000).add(10000);
194                 sold = (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
195             }
196             totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
197             sender.transfer(sold);//payout
198             emit sell(sender, playerdivpts, sold);
199             } }         
200 
201 
202     //view functions
203     function singleplantdivs ()public view returns(uint256){ //how big are are my plants?
204         return(block.number.sub(buyblock[msg.sender]).add(1000));
205     }
206     function howmanyplants ()public view returns(uint256){ //how many plants do I have?
207         return(_playerhouses[msg.sender]);
208     }
209     function whatblockmove ()public view returns(uint256){  // what block # can I make my next move at
210         return(lastmove[msg.sender]).add(blocksbeforeaction);
211     }
212     function canimoveyet ()public view returns(bool){ //can i move
213         if (blocksbeforeaction <= (block.number).sub(lastmove[msg.sender])) return true;
214     }
215     function howmucheth ()public view returns(uint256){//how much eth is in the contract
216         return address(this).balance;
217     }
218     function gametotaldivs ()public view returns(uint256){//how many div points are in the game right now
219         return (block.number).sub(lastupdateblock).mul(_totalhouses).add(totaldivpts);
220     }
221     function singleplantpayout ()public view returns(uint256){
222         uint256 playerdivpts = block.number.sub(buyblock[msg.sender]).add(1000);
223         uint256 maxbuyblock = 69420;
224         if (playerdivpts >= maxbuyblock) {
225             return (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
226         }
227         else {
228             uint256 payoutmultiplier = playerdivpts.mul(playerdivpts).mul(10000).div(1953640000).add(10000);
229             return (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
230         }
231     }
232 
233 //thanks for playing
234 }