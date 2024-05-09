1 pragma solidity ^0.4.24;
2 // Game by spielley
3 // If you want a cut of the 1% dev share on P3D divs
4 // buy shares at => 0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1
5 // P3D masternode rewards for the UI builder
6 // Raffle3D v 1.02
7 // spielley is not liable for any known or unknown bugs contained by contract
8 // This is not a TEAM JUST product!
9 
10 // Concept:
11 // buy a raffle ticket
12 // => lifetime possible to win a round payout and a chance to win the jackpot
13 // 
14 // Have fun, these games are purely intended for fun.
15 // 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 // ----------------------------------------------------------------------------
40 // Owned contract
41 // ----------------------------------------------------------------------------
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     constructor() public {
49         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 interface SPASMInterface  {
68     function() payable external;
69     function disburse() external  payable;
70 }
71 interface HourglassInterface  {
72     function() payable external;
73     function buy(address _playerAddress) payable external returns(uint256);
74     function sell(uint256 _amountOfTokens) external;
75     function reinvest() external;
76     function withdraw() external;
77     function exit() external;
78     function dividendsOf(address _playerAddress) external view returns(uint256);
79     function balanceOf(address _playerAddress) external view returns(uint256);
80     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
81     function stakingRequirement() external view returns(uint256);
82 }
83 contract P3DRaffle is  Owned {
84     using SafeMath for uint;
85     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe); 
86    function harvestabledivs()
87         view
88         public
89         returns(uint256)
90     {
91         return ( P3Dcontract_.dividendsOf(address(this)))  ;
92     }
93     function raffleinfo(uint256 rafflenumber)
94         view
95         public
96         returns(uint256 drawblock,    uint256 ticketssold,
97     uint256 result,
98     uint256 resultjackpot,
99     bool validation,
100     bool wasabletovalidate,
101     address rafflevanity )
102     {
103         return (Raffles[rafflenumber].drawblock,    Raffles[rafflenumber].ticketssold,
104     Raffles[rafflenumber].result,
105     Raffles[rafflenumber].resultjackpot,
106     Raffles[rafflenumber].validation,
107     Raffles[rafflenumber].wasabletovalidate,
108     Raffles[rafflenumber].rafflevanity
109             )  ;
110     }
111     function FetchVanity(address player) view public returns(string)
112     {
113         return Vanity[player];
114     }
115     function nextlotnumber() view public returns(uint256)
116     {
117         return (nextlotnr);
118     }
119     function nextrafflenumber() view public returns(uint256)
120     {
121         return (nextrafflenr);
122     }
123     function pots() pure public returns(uint256 rafflepot, uint256 jackpot)
124     {
125         return (rafflepot, jackpot);
126     }
127     struct Raffle {
128     uint256 drawblock;
129     uint256 ticketssold;
130     uint256 result;
131     uint256 resultjackpot;
132     bool validation;
133     bool wasabletovalidate;
134     address rafflevanity;
135 }
136 
137     uint256 public nextlotnr;
138     uint256 public nextrafflenr;
139     mapping(uint256 => address) public ticketsales;
140     mapping(uint256 => Raffle) public Raffles;
141     mapping(address => string) public Vanity;
142     uint256 public rafflepot;
143     uint256 public jackpot;
144     SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
145     
146     constructor() public{
147     Raffles[0].validation = true;
148     nextrafflenr++;    
149 }
150     
151     function buytickets(uint256 amount ,address masternode) public payable{
152     require(msg.value >= 10 finney * amount);
153     require(amount > 0);
154     uint256 counter;
155     address sender  = msg.sender;
156     for(uint i=0; i< amount; i++)
157         {
158             counter = i + nextlotnr;
159             ticketsales[counter] = sender;
160         }
161     nextlotnr += i;
162     P3Dcontract_.buy.value(msg.value)(masternode);
163 }
164 function fetchdivstopot () public{
165     uint256 divs = harvestabledivs();
166     
167     uint256 base = divs.div(100);
168     SPASM_.disburse.value(base)();// to dev fee sharing contract SPASM
169     rafflepot = rafflepot.add(base.mul(90));// allocation to raffle
170     jackpot = jackpot.add(base.mul(9)); // allocation to jackpot
171     P3Dcontract_.withdraw();
172     SPASM_.disburse.value(base)();// to dev fee sharing contract SPASM
173 }
174 function changevanity(string van) public payable{
175     require(msg.value >= 100  finney);
176     Vanity[msg.sender] = van;
177     rafflepot = rafflepot.add(msg.value);
178 }
179 function startraffle () public{
180     require(Raffles[nextrafflenr - 1].validation == true);
181     require(rafflepot >= 103 finney);
182     Raffles[nextrafflenr].drawblock = block.number;
183     
184     Raffles[nextrafflenr].ticketssold = nextlotnr-1;
185     nextrafflenr++;
186 }
187 function validateraffle () public{
188     uint256 rafnr = nextrafflenr - 1;
189     bool val = Raffles[rafnr].validation;
190     uint256 drawblock = Raffles[rafnr].drawblock;
191     require(val != true);
192     require(drawblock < block.number);
193     
194     //check if blockhash can be determined
195         if(block.number - 256 > drawblock) {
196             // can not be determined
197             Raffles[rafnr].validation = true;
198             Raffles[rafnr].wasabletovalidate = false;
199         }
200         if(block.number - 256 <= drawblock) {
201             // can be determined
202             uint256 winningticket = uint256(blockhash(drawblock)) % Raffles[rafnr].ticketssold;
203             uint256 jackpotdraw = uint256(blockhash(drawblock)) % 1000;
204             address winner = ticketsales[winningticket];
205             Raffles[rafnr].validation = true;
206             Raffles[rafnr].wasabletovalidate = true;
207             Raffles[rafnr].result = winningticket;
208             Raffles[rafnr].resultjackpot = jackpotdraw;
209             Raffles[rafnr].rafflevanity = winner;
210             if(jackpotdraw == 777){
211                 winner.transfer(jackpot);
212                 jackpot = 0;
213             }
214             winner.transfer(100 finney);
215             msg.sender.transfer(3 finney);
216             rafflepot = rafflepot.sub(103 finney);
217         }
218     
219 }
220 
221 }