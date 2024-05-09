1 pragma solidity ^0.4.24;
2 
3 contract BettingInterface {
4     // place a bet on a coin(horse) lockBetting
5     function placeBet(bytes32 horse) external payable;
6     // method to claim the reward amount
7     function claim_reward() external;
8 
9     mapping (bytes32 => bool) public winner_horse;
10     
11     function checkReward() external constant returns (uint);
12 }
13 
14 /**
15  * @dev Allows to bet on a race and receive future tokens used to withdraw winnings
16 */
17 contract HorseFutures {
18     
19     event Claimed(address indexed Race, uint256 Count);
20     event Selling(bytes32 Id, uint256 Amount, uint256 Price, address indexed Race, bytes32 Horse, address indexed Owner);
21     event Buying(bytes32 Id, uint256 Amount, uint256 Price, address indexed Race, bytes32 Horse, address indexed Owner);
22     event Canceled(bytes32 Id, address indexed Owner,address indexed Race);
23     event Bought(bytes32 Id, uint256 Amount, address indexed Owner, address indexed Race);
24     event Sold(bytes32 Id, uint256 Amount, address indexed Owner, address indexed Race);
25     event BetPlaced(address indexed EthAddr, address indexed Race);
26     
27     struct Offer
28     {
29         uint256 Amount;
30         bytes32 Horse;
31         uint256 Price;
32         address Race;
33         bool BuyType;
34     }
35     
36     mapping(address => mapping(address => mapping(bytes32 => uint256))) ClaimTokens;
37     mapping(address => mapping (bytes32 => uint256)) TotalTokensCoinRace;
38     mapping(address => bool) ClaimedRaces;
39     
40     mapping(address => uint256) toDistributeRace;
41     //market
42     mapping(bytes32 => Offer) market;
43     mapping(bytes32 => address) owner;
44     mapping(address => uint256) public marketBalance;
45     
46     function placeBet(bytes32 horse, address race) external payable
47     _validRace(race) {
48         BettingInterface raceContract = BettingInterface(race);
49         raceContract.placeBet.value(msg.value)(horse);
50         uint256 c = uint256(msg.value / 1 finney);
51         ClaimTokens[msg.sender][race][horse] += c;
52         TotalTokensCoinRace[race][horse] += c;
53 
54         emit BetPlaced(msg.sender, race);
55     }
56     
57     function getOwnedAndTotalTokens(bytes32 horse, address race) external view
58     _validRace(race) 
59     returns(uint256,uint256) {
60         return (ClaimTokens[msg.sender][race][horse],TotalTokensCoinRace[race][horse]);
61     }
62 
63     // required for the claimed ether to be transfered here
64     function() public payable { }
65     
66     function claim(address race) external
67     _validRace(race) {
68         BettingInterface raceContract = BettingInterface(race);
69         if(!ClaimedRaces[race]) {
70             toDistributeRace[race] = raceContract.checkReward();
71             raceContract.claim_reward();
72             ClaimedRaces[race] = true;
73         }
74 
75         uint256 totalWinningTokens = 0;
76         uint256 ownedWinningTokens = 0;
77 
78         bool btcWin = raceContract.winner_horse(bytes32("BTC"));
79         bool ltcWin = raceContract.winner_horse(bytes32("LTC"));
80         bool ethWin = raceContract.winner_horse(bytes32("ETH"));
81 
82         if(btcWin)
83         {
84             totalWinningTokens += TotalTokensCoinRace[race][bytes32("BTC")];
85             ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("BTC")];
86             ClaimTokens[msg.sender][race][bytes32("BTC")] = 0;
87         } 
88         if(ltcWin)
89         {
90             totalWinningTokens += TotalTokensCoinRace[race][bytes32("LTC")];
91             ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("LTC")];
92             ClaimTokens[msg.sender][race][bytes32("LTC")] = 0;
93         } 
94         if(ethWin)
95         {
96             totalWinningTokens += TotalTokensCoinRace[race][bytes32("ETH")];
97             ownedWinningTokens += ClaimTokens[msg.sender][race][bytes32("ETH")];
98             ClaimTokens[msg.sender][race][bytes32("ETH")] = 0;
99         }
100 
101         uint256 claimerCut = toDistributeRace[race] / totalWinningTokens * ownedWinningTokens;
102         
103         msg.sender.transfer(claimerCut);
104         
105         emit Claimed(race, claimerCut);
106     }
107     
108     function sellOffer(uint256 amount, uint256 price, address race, bytes32 horse) external
109     _validRace(race) 
110     _validHorse(horse)
111     returns (bytes32) {
112         uint256 ownedAmount = ClaimTokens[msg.sender][race][horse];
113         require(ownedAmount >= amount);
114         require(amount > 0);
115         
116         bytes32 id = keccak256(abi.encodePacked(amount,price,race,horse,true,block.timestamp));
117         require(owner[id] == address(0)); //must not already exist
118         
119         Offer storage newOffer = market[id];
120         
121         newOffer.Amount = amount;
122         newOffer.Horse = horse;
123         newOffer.Price = price;
124         newOffer.Race = race;
125         newOffer.BuyType = false;
126         
127         ClaimTokens[msg.sender][race][horse] -= amount;
128         owner[id] = msg.sender;
129         
130         emit Selling(id,amount,price,race,horse,msg.sender);
131         
132         return id;
133     }
134 
135     function getOffer(bytes32 id) external view returns(uint256,bytes32,uint256,address,bool) {
136         Offer memory off = market[id];
137         return (off.Amount,off.Horse,off.Price,off.Race,off.BuyType);
138     }
139     
140     function buyOffer(uint256 amount, uint256 price, address race, bytes32 horse) external payable
141     _validRace(race) 
142     _validHorse(horse)
143     returns (bytes32) {
144         require(amount > 0);
145         require(price > 0);
146         require(msg.value == price * amount);
147         bytes32 id = keccak256(abi.encodePacked(amount,price,race,horse,false,block.timestamp));
148         require(owner[id] == address(0)); //must not already exist
149         
150         Offer storage newOffer = market[id];
151         
152         newOffer.Amount = amount;
153         newOffer.Horse = horse;
154         newOffer.Price = price;
155         newOffer.Race = race;
156         newOffer.BuyType = true;
157         owner[id] = msg.sender;
158         
159         emit Buying(id,amount,price,race,horse,msg.sender);
160         
161         return id;
162     }
163     
164     function cancelOrder(bytes32 id) external {
165         require(owner[id] == msg.sender);
166         
167         Offer memory off = market[id];
168         if(off.BuyType) {
169             msg.sender.transfer(off.Amount * off.Price);
170         }
171         else {
172             ClaimTokens[msg.sender][off.Race][off.Horse] += off.Amount;
173         }
174         
175 
176         emit Canceled(id,msg.sender,off.Race);
177         delete market[id];
178         delete owner[id];
179     }
180     
181     function buy(bytes32 id, uint256 amount) external payable {
182         require(owner[id] != address(0));
183         require(owner[id] != msg.sender);
184         Offer storage off = market[id];
185         require(!off.BuyType);
186         require(amount <= off.Amount);
187         uint256 cost = off.Price * amount;
188         require(msg.value >= cost);
189         
190         ClaimTokens[msg.sender][off.Race][off.Horse] += amount;
191         marketBalance[owner[id]] += msg.value;
192 
193         emit Bought(id,amount,msg.sender, off.Race);
194         
195         if(off.Amount == amount)
196         {
197             delete market[id];
198             delete owner[id];
199         }
200         else
201         {
202             off.Amount -= amount;
203         }
204     }
205 
206     function sell(bytes32 id, uint256 amount) external {
207         require(owner[id] != address(0));
208         require(owner[id] != msg.sender);
209         Offer storage off = market[id];
210         require(off.BuyType);
211         require(amount <= off.Amount);
212         
213         uint256 cost = amount * off.Price;
214         ClaimTokens[msg.sender][off.Race][off.Horse] -= amount;
215         ClaimTokens[owner[id]][off.Race][off.Horse] += amount;
216         marketBalance[owner[id]] -= cost;
217         marketBalance[msg.sender] += cost;
218 
219         emit Sold(id,amount,msg.sender,off.Race);
220         
221         if(off.Amount == amount)
222         {
223             delete market[id];
224             delete owner[id];
225         }
226         else
227         {
228             off.Amount -= amount;
229         }
230     }
231     
232     function withdraw() external {
233         msg.sender.transfer(marketBalance[msg.sender]);
234         marketBalance[msg.sender] = 0;
235     }
236     
237     modifier _validRace(address race) {
238         require(race != address(0));
239         _;
240     }
241 
242     modifier _validHorse(bytes32 horse) {
243         require(horse == bytes32("BTC") || horse == bytes32("ETH") || horse == bytes32("LTC"));
244         _;
245     }
246     
247 }