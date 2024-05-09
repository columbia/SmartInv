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
85 
86     function () external payable{}
87 
88     function buyhouses() ishuman() public payable { // houses... plants... lives ... its all good
89         uint256 value = msg.value;
90         if(value == 200 finney){// buying 3 houses costs 0.2 eth
91             address sender = msg.sender;
92             if(_playerhouses[sender] == 0 ){ // check that user has no houses
93                 _playerhouses[sender] = 3; // add houses to players count
94                 uint256 next = nextFormation;
95                 formation[next++] = house(sender, 1);// add houses to playing field
96                 formation[next++] = house(sender, 2);// roc = 1, pap =2, sis = 3.
97                 formation[next++] = house(sender, 3);
98                 nextFormation = next;
99                 lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
100                 buyblock[sender] = block.number; // log the buy block of the sender
101                 _totalhouses += 3;// update totalSupply
102                 happydev.transfer(2 finney);
103                 totaldivpts += 3000;
104                 } } }
105 
106     bool gameon;
107 
108     function startgame() public payable {
109         uint256 value = msg.value;
110         require(value == 200 finney);// buying 3 houses costs 0.2 eth
111         require (gameon == false);
112         address sender = msg.sender;
113         _playerhouses[sender] = _playerhouses[sender]+3;// add houses to players count
114         formation[nextFormation] = house(sender, 1);// add houses to playing field
115         nextFormation++;
116         formation[nextFormation] = house(sender, 2);// roc = 1, pap =2, sis = 3.
117         nextFormation++;
118         formation[nextFormation] = house(sender, 3);
119         nextFormation++;
120         lastmove[sender] = block.number; // reset lastMove to prevent people from attacking right away
121         buyblock[sender] = block.number; // log the buy block of the sender
122         _totalhouses = _totalhouses+3;// update totalSupply
123         happydev.transfer(2 finney);
124         lastupdateblock = block.number;
125         gameon = true;
126         totaldivpts += 3000;
127     }
128 
129     //divsection
130     uint256 lastupdateblock;
131     uint256 totaldivpts;
132 
133     function updateglobal() internal {                       
134         totaldivpts = gametotaldivs();
135         lastupdateblock = block.number;//updated
136         lastmove[msg.sender] = block.number; // reset lastmove of attacker
137     }
138 
139     function rekt(uint8 typeToKill) internal {
140         updateglobal();
141         uint256 attacked = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, tx.origin))) % nextFormation;
142         uint256 _rpstype = formation[attacked].rpstype;
143         address killed = formation[attacked].owner;//set address of attacked player
144         address payable sender = msg.sender;
145         if(_rpstype == typeToKill) {
146             formation[attacked] = formation[--nextFormation];//reform playing field
147             delete formation[nextFormation];  //delete unused formation
148             uint256 playerdivpts = block.number.sub(buyblock[killed]).add(1000);//figure out how big robbed plant is
149             uint256 robbed = (address(this).balance).mul(playerdivpts).div(totaldivpts).div(2); //figure out how much was robbed
150             totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
151             _totalhouses--;//update total houses in game
152             _playerhouses[killed]--;//update attacked players houses
153             sender.transfer(robbed);//pay the robber
154             emit win(attacked, playerdivpts, robbed);  
155         }
156         emit battle(sender, typeToKill, killed);
157         } 
158   
159         
160 
161     function rockattack() canmove() public { //rock attack function
162         rekt(3);
163         }
164 
165     function sisattack() canmove() public { //sicssor attack function
166         rekt(1);
167         }
168 
169     function papattack() canmove() public {//paper attack function
170         rekt(2);
171         }
172 
173     function sellhouse (uint256 selling) canmove() public {// house sell function
174         address payable sender = msg.sender;
175         address beingsold = formation[selling].owner;
176         if (beingsold == sender){ // how to comfirm sender is owner
177             updateglobal();
178             uint256 next = --nextFormation;
179             formation[selling] = formation[next];
180             delete formation[next];
181             _totalhouses--;//update total houses in game
182             _playerhouses[sender]--;//update selling players houses
183             uint256 maxbuyblock = 69420;
184             uint256 playerdivpts = block.number.sub(buyblock[sender]).add(1000);
185             uint256 sold;
186             if (playerdivpts >= maxbuyblock) {
187                 sold = (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
188                 }
189             else {
190                 uint256 payoutmultiplier = playerdivpts.mul(playerdivpts).mul(10000).div(1953640000).add(10000);
191                 sold = (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
192             }
193             totaldivpts = totaldivpts.sub(playerdivpts); //adjust total div points
194             sender.transfer(sold);//payout
195             emit sell(sender, playerdivpts, sold);
196             } }         
197 
198 
199     //view functions
200     function singleplantdivs ()public view returns(uint256){ //how big are are my plants?
201         return(block.number.sub(buyblock[msg.sender]).add(1000));
202     }
203     function howmanyplants ()public view returns(uint256){ //how many plants do I have?
204         return(_playerhouses[msg.sender]);
205     }
206     function whatblockmove ()public view returns(uint256){  // what block # can I make my next move at
207         return(lastmove[msg.sender]).add(blocksbeforeaction);
208     }
209     function canimoveyet ()public view returns(bool){ //can i move
210         if (blocksbeforeaction <= (block.number).sub(lastmove[msg.sender])) return true;
211     }
212     function howmucheth ()public view returns(uint256){//how much eth is in the contract
213         return address(this).balance;
214     }
215     function gametotaldivs ()public view returns(uint256){//how many div points are in the game right now
216         return (block.number).sub(lastupdateblock).mul(_totalhouses).add(totaldivpts);
217     }
218     function singleplantpayout ()public view returns(uint256){
219         uint256 playerdivpts = block.number.sub(buyblock[msg.sender]).add(1000);
220         uint256 maxbuyblock = 69420;
221         if (playerdivpts >= maxbuyblock) {
222             return (address(this).balance).mul(maxbuyblock * 4).div(totaldivpts);
223         }
224         else {
225             uint256 payoutmultiplier = playerdivpts.mul(playerdivpts).mul(10000).div(1953640000).add(10000);
226             return (address(this).balance).mul(playerdivpts).mul(payoutmultiplier).div(totaldivpts).div(10000);
227         }
228     }
229 
230 //thanks for playing
231 }