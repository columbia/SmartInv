1 pragma solidity ^0.4.11;
2 
3 
4 contract Better{
5     event Bet(address indexed _from, uint team, uint _value);
6     event Claim(address indexed _from, uint _value);
7     event Transfer(address indexed _from, address indexed _to, uint _value);
8     event LogManualWinnerUpdated(uint winner);
9 
10     //only informative states
11     uint public constant STATE_BET_ENABLED=0;
12     uint public constant STATE_BET_DISABLED=1;
13     uint public constant  STATE_CLAIM_ENABLED=2;
14     
15     uint private constant NO_TEAM=0;
16     uint[33] private _pools;  //pools[0] is reserved
17     
18     uint public DEV_TAX_DIVISOR;    //example 1/4 = 25%
19     uint public  _startTime;    //example=1522983600;   //when WC starts and bets close
20     uint public  _endTime;  //example=1522985400;  //when WC ends and claims open
21 
22     uint private _totalPrize;
23     uint private _winnerTeam;
24     uint private _numberBets;
25     
26     address public creatorAddr;
27     
28     
29     mapping (address => mapping (uint => uint)) private _bets;
30     
31     function Better(uint passDevTaxDivisor, uint passStartTime, uint passEndTime) public {
32         creatorAddr=msg.sender;
33         DEV_TAX_DIVISOR=passDevTaxDivisor;
34         _startTime=passStartTime;
35         _endTime=passEndTime;
36         
37         _winnerTeam=NO_TEAM;
38 
39         _totalPrize=0;
40         _numberBets=0;
41         for(uint i =0; i<33; i++)_pools[i]=0; //set all pool to 0
42     }
43     
44     
45     modifier onlyCreator {
46         require(msg.sender == creatorAddr);
47         _;
48     }
49     
50     modifier onlyBeforeWinner {
51         require(_winnerTeam == NO_TEAM);
52         _;
53     }
54     
55     modifier onlyAfterWinner {
56         require(_winnerTeam != NO_TEAM);
57         _;
58     }
59     
60     modifier onlyAfterEndTime() {
61         require(now >= _endTime);
62         _;
63     }
64     
65     modifier onlyBeforeStartTime() {
66         require(now <= _startTime);
67         _;
68     }
69 
70     function setWinnerManually(uint winnerTeam) public onlyCreator onlyBeforeWinner returns (bool){
71          _winnerTeam = winnerTeam;
72          emit LogManualWinnerUpdated(winnerTeam);
73     }
74     
75     function updateEndTimeManually(uint passEndTime) public onlyCreator onlyBeforeWinner returns (bool){
76         _endTime=passEndTime;
77     }
78     
79     function updateStartTimeManually(uint passStartTime) public onlyCreator onlyBeforeWinner returns (bool){
80         _startTime=passStartTime;
81     }
82     
83     function bet(uint team) public onlyBeforeWinner onlyBeforeStartTime payable returns (bool)  {
84         require(msg.value>0);
85         require(team >0);
86         
87         uint devTax= SafeMath.div(msg.value,DEV_TAX_DIVISOR);
88         uint finalValue=SafeMath.sub(msg.value,devTax);
89         
90         assert(finalValue>0 && devTax>0);
91         
92         creatorAddr.transfer(devTax);
93         
94         _pools[team]=SafeMath.add(_pools[team],finalValue);
95         _bets[msg.sender][team]=SafeMath.add(_bets[msg.sender][team],finalValue);
96         _totalPrize=SafeMath.add(_totalPrize,finalValue);
97         
98         _numberBets++;
99         emit Bet(msg.sender,team,msg.value);
100         return true;
101     }
102     
103     function claim() public onlyAfterWinner onlyAfterEndTime returns (bool){
104         uint moneyInvested= _bets[msg.sender][_winnerTeam];
105         require(moneyInvested>0);
106         
107         uint moneyTeam= _pools[_winnerTeam];
108         
109 
110         uint aux= SafeMath.mul(_totalPrize,moneyInvested);
111         uint wonAmmount= SafeMath.div(aux,moneyTeam);
112         
113         _bets[msg.sender][_winnerTeam]=0;
114         msg.sender.transfer(wonAmmount);
115         
116         emit Claim(msg.sender,wonAmmount);
117         return true;
118     }
119 
120     function getMyBet(uint teamNumber) public constant returns (uint teamBet) {
121        return (_bets[msg.sender][teamNumber]);
122     }
123     
124     function getPools() public constant returns (uint[33] pools) {
125         return _pools;
126     }
127     
128     function getTotalPrize() public constant returns (uint prize){
129         return _totalPrize;
130     }
131     
132     function getNumberOfBets() public constant returns (uint numberBets){
133         return _numberBets;
134     }
135     
136     function getWinnerTeam() public constant returns (uint winnerTeam){
137         return _winnerTeam;
138     }
139     
140 
141     function getState() public constant returns (uint state){
142         if(now<_startTime)return STATE_BET_ENABLED;
143         if(now<_endTime)return STATE_BET_DISABLED;
144         else return STATE_CLAIM_ENABLED;
145     }
146     
147     function getDev() public constant returns (string signature){
148         return 'chelinho139';
149     }
150     function () public payable {
151         throw;
152     }
153     
154 
155 // EgyptEgypt 1
156 // MoroccoMorocco 2
157 // NigeriaNigeria 3
158 // SenegalSenegal 4
159 // TunisiaTunisia 5
160 // AustraliaAustralia 6
161 // IR IranIR Iran 7
162 // JapanJapan 8
163 // Korea RepublicKorea Republic 9
164 // Saudi ArabiaSaudi Arabia 10
165 // BelgiumBelgium 11
166 // CroatiaCroatia 12 
167 // DenmarkDenmark 13 
168 // EnglandEngland 14 
169 // FranceFrance 15 
170 // GermanyGermany 16 
171 // IcelandIceland 17 
172 // PolandPoland 18 
173 // PortugalPortugal 19 
174 // RussiaRussia 20
175 // SerbiaSerbia 21 
176 // SpainSpain 22 
177 // SwedenSweden 23 
178 // SwitzerlandSwitzerland 24 
179 // Costa RicaCosta Rica 25 
180 // MexicoMexico 26 
181 // PanamaPanama 27 
182 // ArgentinaArgentina 28 
183 // BrazilBrazil 29 
184 // ColombiaColombia 30 
185 // PeruPeru 31 
186 // UruguayUruguay 32
187 }
188 
189 
190 library SafeMath {
191 
192     /**
193     * @dev Multiplies two numbers, throws on overflow.
194     */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         if (a == 0) {
197             return 0;
198         }
199         uint256 c = a * b;
200         assert(c / a == b);
201         return c;
202     }
203 
204     /**
205     * @dev Integer division of two numbers, truncating the quotient.
206     */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         // assert(b > 0); // Solidity automatically throws when dividing by 0
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211         return c;
212     }
213 
214     /**
215     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
216     */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         assert(b <= a);
219         return a - b;
220     }
221 
222     /**
223     * @dev Adds two numbers, throws on overflow.
224     */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         assert(c >= a);
228         return c;
229     }
230 }