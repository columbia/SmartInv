1 pragma solidity ^0.4.24;
2 // Game by spielley
3 // If you want a cut of the 1% dev share on P3D divs
4 // buy shares at => 0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1
5 // P3D masternode rewards for the UI builder
6 // Raffle3D v 1.04
7 // spielley is not liable for any known or unknown bugs contained by contract
8 // This is not a TEAM JUST product!
9 
10 // Concept:
11 // buy a raffle ticket
12 // => lifetime possible to win a round payout and a chance to win the jackpot
13 // 
14 // Have fun, these games are purely intended for fun.
15 // 
16 // Warning! do not simpply send eth to the contract, this will result in the
17 // eth being stuck at contract => restriction using P3D in this version
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 library SafeMath {
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     constructor() public {
51         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 interface SPASMInterface  {
70     function() payable external;
71     function disburse() external  payable;
72 }
73 interface HourglassInterface  {
74     function() payable external;
75     function buy(address _playerAddress) payable external returns(uint256);
76     function sell(uint256 _amountOfTokens) external;
77     function reinvest() external;
78     function withdraw() external;
79     function exit() external;
80     function dividendsOf(address _playerAddress) external view returns(uint256);
81     function balanceOf(address _playerAddress) external view returns(uint256);
82     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
83     function stakingRequirement() external view returns(uint256);
84 }
85 contract P3DRaffle is  Owned {
86     using SafeMath for uint;
87     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe); 
88    function harvestabledivs()
89         view
90         public
91         returns(uint256)
92     {
93         return ( P3Dcontract_.dividendsOf(address(this)))  ;
94     }
95     function raffleinfo(uint256 rafflenumber)
96         view
97         public
98         returns(uint256 drawblock,    uint256 ticketssold,
99     uint256 result,
100     uint256 resultjackpot,
101     bool validation,
102     bool wasabletovalidate,
103     address rafflevanity )
104     {
105         return (Raffles[rafflenumber].drawblock,    Raffles[rafflenumber].ticketssold,
106     Raffles[rafflenumber].result,
107     Raffles[rafflenumber].resultjackpot,
108     Raffles[rafflenumber].validation,
109     Raffles[rafflenumber].wasabletovalidate,
110     Raffles[rafflenumber].rafflevanity
111             )  ;
112     }
113     function FetchVanity(address player) view public returns(string)
114     {
115         return Vanity[player];
116     }
117     function devfeesoutstanding() view public returns(uint256)
118     {
119         return devfee;
120     }
121     function nextlotnumber() view public returns(uint256)
122     {
123         return (nextlotnr);
124     }
125     function nextrafflenumber() view public returns(uint256)
126     {
127         return (nextrafflenr);
128     }
129     function pots() pure public returns(uint256 rafflepot, uint256 jackpot)
130     {
131         return (rafflepot, jackpot);
132     }
133     struct Raffle {
134     uint256 drawblock;
135     uint256 ticketssold;
136     uint256 result;
137     uint256 resultjackpot;
138     bool validation;
139     bool wasabletovalidate;
140     address rafflevanity;
141 }
142 
143     uint256 public nextlotnr;
144     uint256 public nextrafflenr;
145     mapping(uint256 => address) public ticketsales;
146     mapping(uint256 => Raffle) public Raffles;
147     mapping(address => string) public Vanity;
148     uint256 public rafflepot;//90%
149     uint256 public jackpot; //9%
150     uint256 public devfee;//1%
151     SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
152     
153     constructor() public{
154     Raffles[0].validation = true;
155     nextrafflenr++;    
156 }
157     
158     function buytickets(uint256 amount ,address masternode) public payable{
159     require(msg.value >= 10 finney * amount);
160     require(amount > 0);
161     uint256 counter;
162     address sender  = msg.sender;
163     for(uint i=0; i< amount; i++)
164         {
165             counter = i + nextlotnr;
166             ticketsales[counter] = sender;
167         }
168     nextlotnr += i;
169     P3Dcontract_.buy.value(msg.value)(masternode);
170 }
171 function fetchdivstopot () public{
172     uint256 divs = harvestabledivs();
173     uint256 base = divs.div(100);
174     
175     rafflepot = rafflepot.add(base.mul(90));// allocation to raffle
176     jackpot = jackpot.add(base.mul(9)); // allocation to jackpot
177     devfee = devfee.add(base);//dev fee
178    
179     P3Dcontract_.withdraw();
180     
181 }
182 function devfeetodev () public {
183     
184     SPASM_.disburse.value(devfee)();
185     devfee = 0;
186 }
187 function changevanity(string van) public payable{
188     require(msg.value >= 100  finney);
189     Vanity[msg.sender] = van;
190     rafflepot = rafflepot.add(msg.value);
191 }
192 function startraffle () public{
193     require(Raffles[nextrafflenr - 1].validation == true);
194     require(rafflepot >= 103 finney);
195     Raffles[nextrafflenr].drawblock = block.number;
196     
197     Raffles[nextrafflenr].ticketssold = nextlotnr;
198     nextrafflenr++;
199 }
200 function validateraffle () public{
201     uint256 rafnr = nextrafflenr - 1;
202     bool val = Raffles[rafnr].validation;
203     uint256 drawblock = Raffles[rafnr].drawblock;
204     require(val != true);
205     require(drawblock < block.number);
206     
207     //check if blockhash can be determined
208         if(block.number - 256 > drawblock) {
209             // can not be determined
210             Raffles[rafnr].validation = true;
211             Raffles[rafnr].wasabletovalidate = false;
212         }
213         if(block.number - 256 <= drawblock) {
214             // can be determined
215             uint256 winningticket = uint256(blockhash(drawblock)) % Raffles[rafnr].ticketssold;
216             uint256 jackpotdraw = uint256(blockhash(drawblock)) % 1000;
217             address winner = ticketsales[winningticket];
218             Raffles[rafnr].validation = true;
219             Raffles[rafnr].wasabletovalidate = true;
220             Raffles[rafnr].result = winningticket;
221             Raffles[rafnr].resultjackpot = jackpotdraw;
222             Raffles[rafnr].rafflevanity = winner;
223             if(jackpotdraw == 777){
224                 winner.transfer(jackpot);
225                 jackpot = 0;
226             }
227             winner.transfer(100 finney);
228             msg.sender.transfer(3 finney);
229             rafflepot = rafflepot.sub(103 finney);
230         }
231     
232 }
233 function () external payable{}// needed for P3D divs receiving
234 function dusttorafflepot () public onlyOwner {
235     if(address(this).balance.sub(rafflepot).sub(jackpot).sub(devfee) > 0)
236     {
237         rafflepot = address(this).balance.sub(jackpot).sub(devfee);
238     }
239 }
240 }