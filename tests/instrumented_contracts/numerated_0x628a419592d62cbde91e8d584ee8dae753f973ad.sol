1 pragma solidity ^0.4.25;
2 // First Spielley and Dav collab on creating a Hot potato take for P3D
3 // pass the spud, 
4 // each time you have the spud you can win the jackpot, 
5 // first player has most chance of hitting jackpot and slowly the chances of winning decrease. 
6 // if someone doesn't take over the spud within 256 blocks you auto win
7 // each time you play you get a spudcoin
8 // spudcoin reward for UI devs
9 // spudcoins can be traded in for a part of the contracts divs
10 // dependant on totalsupply and how many coins you trade in
11 // you can also trade in spudcoin for spots in the MN rotator when the contract buys P3D
12 // 
13 
14 contract Spud3D {
15     using SafeMath for uint;
16     
17     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
18     SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);//spielley's profit sharing payout
19     
20     struct State {
21         
22         uint256 blocknumber;
23         address player;
24         
25         
26     }
27     
28     mapping(uint256 =>  State) public Spudgame;
29     mapping(address => uint256) public playerVault;
30     mapping(address => uint256) public SpudCoin;
31     mapping(uint256 => address) public Rotator;
32     
33     uint256 public totalsupply;//spud totalsupply
34     uint256 public Pot; // pot that get's filled from entry mainly
35     uint256 public SpudPot; // divpot spucoins can be traded for
36     uint256 public round; //roundnumber
37     
38     uint256 public RNGdeterminator; // variable upon gameprogress
39     uint256 public nextspotnr; // next spot in rotator
40     
41     mapping(address => string) public Vanity;
42     
43     event Withdrawn(address indexed player, uint256 indexed amount);
44     event SpudRnG(address indexed player, uint256 indexed outcome);
45     event payout(address indexed player, uint256 indexed amount);
46     
47     function harvestabledivs()
48         view
49         public
50         returns(uint256)
51     {
52         return ( p3dContract.myDividends(true))  ;
53     }
54     function contractownsthismanyP3D()
55         public
56         view
57         returns(uint256)
58     {
59         
60         return (p3dContract.balanceOf(address(this)));
61     }
62     function getthismuchethforyourspud(uint256 amount)
63         public
64         view
65         returns(uint256)
66     {
67         uint256 dividends = p3dContract.myDividends(true);
68             
69             uint256 amt = dividends.div(100);
70             
71             uint256 thepot = SpudPot.add(dividends.sub(amt));
72             
73         uint256 payouts = thepot.mul(amount).div(totalsupply);
74         return (payouts);
75     }
76     function thismanyblockstillthspudholderwins()
77         public
78         view
79         returns(uint256)
80     {
81         uint256 value;
82         if(265-( block.number - Spudgame[round].blocknumber) >0){value = 265- (block.number - Spudgame[round].blocknumber);}
83         return (value);
84     }
85     function currentspudinfo()
86         public
87         view
88         returns(uint256, address)
89     {
90         
91         return (Spudgame[round].blocknumber, Spudgame[round].player);
92     }
93     function returntrueifcurrentplayerwinsround()
94         public
95         view
96         returns(bool)
97     {
98         uint256 refblocknr = Spudgame[round].blocknumber;
99         uint256 RNGresult = uint256(blockhash(refblocknr)) % RNGdeterminator;
100         
101         bool result;
102         if(RNGresult == 1){result = true;}
103         if(refblocknr < block.number - 256){result = true;}
104         return (result);
105     }
106     //mods
107     modifier hasEarnings()
108     {
109         require(playerVault[msg.sender] > 0);
110         _;
111     }
112     
113     function() external payable {} // needed for P3D myDividends
114     //constructor
115     constructor()
116         public
117     {
118         Spudgame[0].player = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
119         Spudgame[0].blocknumber = block.number;
120         RNGdeterminator = 6;
121         Rotator[0] = 0x989eB9629225B8C06997eF0577CC08535fD789F9;//raffle3d possible MN reward
122         nextspotnr++;
123     }
124     //vanity
125     
126     function changevanity(string van , address masternode) public payable
127     {
128         require(msg.value >= 1  finney);
129         Vanity[msg.sender] = van;
130         if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address
131         p3dContract.buy.value(msg.value)(masternode);
132     } 
133     //
134      function withdraw()
135         external
136         hasEarnings
137     {
138        
139         
140         uint256 amount = playerVault[msg.sender];
141         playerVault[msg.sender] = 0;
142         
143         emit Withdrawn(msg.sender, amount); 
144         
145         msg.sender.transfer(amount);
146     }
147     // main function
148     function GetSpud(address MN) public payable
149     {
150         require(msg.value >= 1  finney);
151         address sender = msg.sender;
152         uint256 blocknr = block.number;
153         uint256 curround = round;
154         uint256 refblocknr = Spudgame[curround].blocknumber;
155         
156         SpudCoin[MN]++;
157         totalsupply +=2;
158         SpudCoin[sender]++;
159         
160         // check previous RNG
161         
162         if(blocknr == refblocknr) 
163         {
164             // just change state previous player does not win
165             
166             playerVault[msg.sender] += msg.value;
167             
168         }
169         if(blocknr - 256 <= refblocknr && blocknr != refblocknr)
170         {
171         
172         uint256 RNGresult = uint256(blockhash(refblocknr)) % RNGdeterminator;
173         emit SpudRnG(Spudgame[curround].player , RNGresult) ;
174         
175         Pot += msg.value;
176         if(RNGresult == 1)
177         {
178             // won payout
179             uint256 RNGrotator = uint256(blockhash(refblocknr)) % nextspotnr;
180             address rotated = Rotator[RNGrotator]; 
181             uint256 base = Pot.div(10);
182             p3dContract.buy.value(base)(rotated);
183             Spudgame[curround].player.transfer(base.mul(5));
184             emit payout(Spudgame[curround].player , base.mul(5));
185             Pot = Pot.sub(base.mul(6));
186             // ifpreviouswon => new round
187             uint256 nextround = curround+1;
188             Spudgame[nextround].player = sender;
189             Spudgame[nextround].blocknumber = blocknr;
190             
191             round++;
192             RNGdeterminator = 6;
193         }
194         if(RNGresult != 1)
195         {
196             // not won
197             
198             Spudgame[curround].player = sender;
199             Spudgame[curround].blocknumber = blocknr;
200         }
201         
202         
203         }
204         if(blocknr - 256 > refblocknr)
205         {
206             //win
207             // won payout
208             Pot += msg.value;
209             RNGrotator = uint256(blockhash(blocknr-1)) % nextspotnr;
210             rotated =Rotator[RNGrotator]; 
211             base = Pot.div(10);
212             p3dContract.buy.value(base)(rotated);
213             Spudgame[round].player.transfer(base.mul(5));
214             emit payout(Spudgame[round].player , base.mul(5));
215             Pot = Pot.sub(base.mul(6));
216             // ifpreviouswon => new round
217             nextround = curround+1;
218             Spudgame[nextround].player = sender;
219             Spudgame[nextround].blocknumber = blocknr;
220             
221             round++;
222             RNGdeterminator = 6;
223         }
224         
225     } 
226 
227 function SpudToDivs(uint256 amount) public 
228     {
229         address sender = msg.sender;
230         require(amount>0 && SpudCoin[sender] >= amount );
231          uint256 dividends = p3dContract.myDividends(true);
232             require(dividends > 0);
233             uint256 amt = dividends.div(100);
234             p3dContract.withdraw();
235             SPASM_.disburse.value(amt)();// to dev fee sharing contract SPASM
236             SpudPot = SpudPot.add(dividends.sub(amt));
237         uint256 payouts = SpudPot.mul(amount).div(totalsupply);
238         SpudPot = SpudPot.sub(payouts);
239         SpudCoin[sender] = SpudCoin[sender].sub(amount);
240         totalsupply = totalsupply.sub(amount);
241         sender.transfer(payouts);
242     } 
243 function SpudToRotator(uint256 amount, address MN) public
244     {
245         address sender = msg.sender;
246         require(amount>0 && SpudCoin[sender] >= amount );
247         uint256 counter;
248     for(uint i=0; i< amount; i++)
249         {
250             counter = i + nextspotnr;
251             Rotator[counter] = MN;
252         }
253     nextspotnr += i;
254     SpudCoin[sender] = SpudCoin[sender].sub(amount);
255     totalsupply = totalsupply.sub(amount);
256     }
257 }
258 
259 interface HourglassInterface {
260     function buy(address _playerAddress) payable external returns(uint256);
261     function withdraw() external;
262     function myDividends(bool _includeReferralBonus) external view returns(uint256);
263     function balanceOf(address _playerAddress) external view returns(uint256);
264 }
265 interface SPASMInterface  {
266     function() payable external;
267     function disburse() external  payable;
268 }
269 // ----------------------------------------------------------------------------
270 // Safe maths
271 // ----------------------------------------------------------------------------
272 library SafeMath {
273     function add(uint a, uint b) internal pure returns (uint c) {
274         c = a + b;
275         require(c >= a);
276     }
277     function sub(uint a, uint b) internal pure returns (uint c) {
278         require(b <= a);
279         c = a - b;
280     }
281     function mul(uint a, uint b) internal pure returns (uint c) {
282         c = a * b;
283         require(a == 0 || c / a == b);
284     }
285     function div(uint a, uint b) internal pure returns (uint c) {
286         require(b > 0);
287         c = a / b;
288     }
289 }