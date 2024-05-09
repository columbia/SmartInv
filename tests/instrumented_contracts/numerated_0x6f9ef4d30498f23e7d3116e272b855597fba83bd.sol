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
16 // Warning! do not simpply send eth to the contract, this will result in the
17 // rafflepot being upped and does not give tickets
18 // this is needed to receive the P3D divs
19 
20 // ----------------------------------------------------------------------------
21 // Safe maths
22 // ----------------------------------------------------------------------------
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
39     }
40 }
41 
42 // ----------------------------------------------------------------------------
43 // Owned contract
44 // ----------------------------------------------------------------------------
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     constructor() public {
52         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 interface SPASMInterface  {
71     function() payable external;
72     function disburse() external  payable;
73 }
74 interface HourglassInterface  {
75     function() payable external;
76     function buy(address _playerAddress) payable external returns(uint256);
77     function sell(uint256 _amountOfTokens) external;
78     function reinvest() external;
79     function withdraw() external;
80     function exit() external;
81     function dividendsOf(address _playerAddress) external view returns(uint256);
82     function balanceOf(address _playerAddress) external view returns(uint256);
83     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
84     function stakingRequirement() external view returns(uint256);
85 }
86 contract P3DRaffle is  Owned {
87     using SafeMath for uint;
88     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe); 
89    function harvestabledivs()
90         view
91         public
92         returns(uint256)
93     {
94         return ( P3Dcontract_.dividendsOf(address(this)))  ;
95     }
96     function raffleinfo(uint256 rafflenumber)
97         view
98         public
99         returns(uint256 drawblock,    uint256 ticketssold,
100     uint256 result,
101     uint256 resultjackpot,
102     bool validation,
103     bool wasabletovalidate,
104     address rafflevanity )
105     {
106         return (Raffles[rafflenumber].drawblock,    Raffles[rafflenumber].ticketssold,
107     Raffles[rafflenumber].result,
108     Raffles[rafflenumber].resultjackpot,
109     Raffles[rafflenumber].validation,
110     Raffles[rafflenumber].wasabletovalidate,
111     Raffles[rafflenumber].rafflevanity
112             )  ;
113     }
114     function FetchVanity(address player) view public returns(string)
115     {
116         return Vanity[player];
117     }
118     function devfeesoutstanding() view public returns(uint256)
119     {
120         return devfee;
121     }
122     function nextlotnumber() view public returns(uint256)
123     {
124         return (nextlotnr);
125     }
126     function nextrafflenumber() view public returns(uint256)
127     {
128         return (nextrafflenr);
129     }
130     function pots() pure public returns(uint256 rafflepot, uint256 jackpot)
131     {
132         return (rafflepot, jackpot);
133     }
134     struct Raffle {
135     uint256 drawblock;
136     uint256 ticketssold;
137     uint256 result;
138     uint256 resultjackpot;
139     bool validation;
140     bool wasabletovalidate;
141     address rafflevanity;
142 }
143 
144     uint256 public nextlotnr;
145     uint256 public nextrafflenr;
146     mapping(uint256 => address) public ticketsales;
147     mapping(uint256 => Raffle) public Raffles;
148     mapping(address => string) public Vanity;
149     uint256 public rafflepot;//90%
150     uint256 public jackpot; //9%
151     uint256 public devfee;//1%
152     SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
153     
154     constructor() public{
155     Raffles[0].validation = true;
156     nextrafflenr++;    
157 }
158     
159     function buytickets(uint256 amount ,address masternode) public payable{
160     require(msg.value >= 10 finney * amount);
161     require(amount > 0);
162     uint256 counter;
163     address sender  = msg.sender;
164     for(uint i=0; i< amount; i++)
165         {
166             counter = i + nextlotnr;
167             ticketsales[counter] = sender;
168         }
169     nextlotnr += i;
170     P3Dcontract_.buy.value(msg.value)(masternode);
171 }
172 function fetchdivstopot () public{
173     //uint256 divs = harvestabledivs();
174     
175    
176     P3Dcontract_.withdraw();
177     
178 }
179 function devfeetodev () public {
180     
181     SPASM_.disburse.value(devfee)();
182     devfee = 0;
183 }
184 function changevanity(string van) public payable{
185     require(msg.value >= 100  finney);
186     Vanity[msg.sender] = van;
187     rafflepot = rafflepot.add(msg.value);
188 }
189 function startraffle () public{
190     require(Raffles[nextrafflenr - 1].validation == true);
191     require(rafflepot >= 103 finney);
192     Raffles[nextrafflenr].drawblock = block.number;
193     
194     Raffles[nextrafflenr].ticketssold = nextlotnr;
195     nextrafflenr++;
196 }
197 function validateraffle () public{
198     uint256 rafnr = nextrafflenr - 1;
199     bool val = Raffles[rafnr].validation;
200     uint256 drawblock = Raffles[rafnr].drawblock;
201     require(val != true);
202     require(drawblock < block.number);
203     
204     //check if blockhash can be determined
205         if(block.number - 256 > drawblock) {
206             // can not be determined
207             Raffles[rafnr].validation = true;
208             Raffles[rafnr].wasabletovalidate = false;
209         }
210         if(block.number - 256 <= drawblock) {
211             // can be determined
212             uint256 winningticket = uint256(blockhash(drawblock)) % Raffles[rafnr].ticketssold;
213             uint256 jackpotdraw = uint256(blockhash(drawblock)) % 1000;
214             address winner = ticketsales[winningticket];
215             Raffles[rafnr].validation = true;
216             Raffles[rafnr].wasabletovalidate = true;
217             Raffles[rafnr].result = winningticket;
218             Raffles[rafnr].resultjackpot = jackpotdraw;
219             Raffles[rafnr].rafflevanity = winner;
220             if(jackpotdraw == 777){
221                 winner.transfer(jackpot);
222                 jackpot = 0;
223             }
224             winner.transfer(100 finney);
225             msg.sender.transfer(3 finney);
226             rafflepot = rafflepot.sub(103 finney);
227         }
228     
229 }
230 function () external payable{
231     uint256 base = msg.value.div(100);
232     
233     rafflepot = rafflepot.add(base.mul(90));// allocation to raffle
234     jackpot = jackpot.add(base.mul(9)); // allocation to jackpot
235     devfee = devfee.add(base);
236 }// needed for P3D divs receiving
237 }