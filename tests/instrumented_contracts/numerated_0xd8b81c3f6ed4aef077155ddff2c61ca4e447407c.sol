1 pragma solidity ^0.4.4; 
2 
3 contract Authorization {
4 
5     address internal admin;
6 
7     function Authorization() {
8         admin = msg.sender;
9     }
10 
11     modifier onlyAdmin() {
12         if(msg.sender != admin) throw;
13         _;
14     }
15 }
16 
17 contract NATVCoin is Authorization {
18 
19 //*************************************************************************
20 // Variables
21 
22     mapping (address => uint256) private Balances;
23     mapping (address => mapping (address => uint256)) private Allowances;
24     string public standard = "NATVCoin v1.0";
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28     uint256 public coinSupply;
29     uint private balance;
30     uint256 private sellPrice;
31     uint256 private buyPrice;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed _owner, address indexed _spender, uint _value);
35 //*************************************************************************************
36 // End Variables
37 
38 //**************************************************************************************
39 //Constructor
40     function NATVCoin(address benificairyAddress) {
41         admin = msg.sender;
42         Balances[admin] = 3000000000000000;
43         coinSupply = 3000000000000000;
44         decimals = 8;
45         symbol = "NATV";
46         name = "Native Currency";
47         beneficiary = benificairyAddress; // Need to modify to client's wallet address
48         SetNATVTokenSale();
49     }
50 
51 //***************************************************************************************
52 
53 //***************************************************************************************
54 // Base Token  Started ERC 20 Standards
55     function totalSupply() constant returns (uint initCoinSupply) {
56         return coinSupply;
57     }
58 
59     function balanceOf (address _owner) constant returns (uint balance){
60         return Balances[_owner];
61     }
62 
63     function transfer(address _to, uint256 _value) returns (bool success){
64         if(Balances[msg.sender]< _value) throw;
65         if(Balances[_to] + _value < Balances[_to]) throw;
66         //if(admin)
67 
68         Balances[msg.sender] -= _value;
69         Balances[_to] += _value;
70 
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
76         if(Balances[_from] < _value) throw;
77         if(Balances[_to] + _value < Balances[_to]) throw;
78         if(_value > Allowances[_from][msg.sender]) throw;
79         Balances[_from] -= _value;
80         Balances[_to] += _value;
81         Allowances[_from][msg.sender] -= _value;
82         Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function approve(address _sbalanceOfpender, uint256 _value) returns (bool success){
87         Allowances[msg.sender][_sbalanceOfpender] = _value;
88         Approval(msg.sender, _sbalanceOfpender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
93         return Allowances[_owner][_spender];
94     }
95     //***********************************************************************************************
96     //End Base Token
97     //
98 
99     function OBEFAC(address addr) onlyAdmin public {
100         beneficiary = addr;
101     } 
102 
103     function releaseTokens (address _to, uint256 _value) private returns (bool success) {
104 
105         if(Balances[admin]< _value) throw;
106         if(Balances[_to] + _value < Balances[_to]) throw;
107         //if(admin)
108 
109         Balances[admin] -= _value;
110         Balances[_to] += _value;
111 
112         Transfer(admin, _to, _value);
113 
114         return true;
115     }
116 
117     //***********************************************************************************************
118     //Crowd Sale Logic
119     //
120 
121     enum State {
122         Fundraising, //initial state of crowdsale
123         Failed, //failed to achieve the minimum target
124         Successful, //funding is successfull but not yet transfered the funds to the founders
125         Closed //everything is done i.e. the purpose of crowdsale is over
126     }
127     State private state = State.Fundraising; // setting the default state to fundraising
128 
129     struct Contribution {
130         uint amount; //amount(in ETH) the person has contributed
131         address contributor;
132     }
133     Contribution[] contributions;
134 
135     uint private totalRaised;
136     uint private currentBalance; //currentBalance can be less than totalRaised in case of refund
137     uint private deadline;
138     uint private completedAt;
139     uint private priceInWei; //price of token (e.g. 1 token = 1 ETH i.e. 10^18 Wei )
140     uint private fundingMinimumTargetInWei;
141     uint private fundingMaximumTargetInWei;
142     address private creator; //who created the crowdsale
143     address private beneficiary; //beneficiary can also be a DAO
144     string private campaignUrl;
145     byte constant version = 1;
146 
147     uint256 private amountInWei=0;
148     uint256 private tempTotalRasiedFunds=0;
149     uint256 private actualVlaue=0;
150     uint256 private refundAmount = 0;
151     uint256 private fundingTokens=0;
152 
153     event LogRefund(address addr, uint amount);
154     event LogFundingReceived(address addr, uint amount, uint currentTotal); //funds received by contributors
155     event LogWinnerPaid(address winnerAddress); //whether the beneficiary has paid or not
156     event LogFundingSuccessful(uint totalRaised); //will announce when funding is successfully completed
157     event LogFunderInitialized(
158     address creator,
159     address beneficiary,
160     string url,
161     uint _fundingMaximumTargetInEther,
162     uint256 deadline);
163 
164     // Modified by amit as on 18th August to stop the tarnsaction if ICO date is Over
165     modifier inState(State _state) {
166         if ( now > deadline ) {
167             state = State.Closed;
168         }
169 
170         if (state != _state) throw;
171         _;
172     }
173 
174     modifier isMinimum() {
175         if(msg.value < priceInWei*10) throw;
176         _;
177     }
178 
179     modifier inMultipleOfPrice() {
180         if(msg.value%priceInWei != 0) throw;
181         _;
182     }
183 
184     modifier isCreator() {
185         if (msg.sender != creator) throw;
186         _;
187     }
188 
189     modifier atEndOfLifecycle() {
190         if(!((state == State.Failed || state == State.Successful) && completedAt < now)) {
191             throw;
192         }
193         _;
194     }
195 
196 
197     function SetNATVTokenSale () private {
198 
199         creator = msg.sender;
200         campaignUrl = "www.nativecurrency.com";
201         fundingMinimumTargetInWei = 0 * 1 ether;
202         fundingMaximumTargetInWei = 30000 * 1 ether;
203         deadline = now + (46739 * 1 minutes);
204         currentBalance = 0;
205         priceInWei = 0.001 * 1 ether;
206         LogFunderInitialized(
207         creator,
208         beneficiary,
209         campaignUrl,
210         fundingMaximumTargetInWei,
211         deadline);
212     }
213 
214     function contribute(address _sender)
215     private
216     inState(State.Fundraising) returns (uint256) {
217 
218         uint256 _value = this.balance;
219         amountInWei = _value;
220         tempTotalRasiedFunds = totalRaised + _value;
221         actualVlaue = _value;
222         //debugLog("amountInWei",amountInWei,1);
223         //debugLog("tempTotalRasiedFunds",tempTotalRasiedFunds,2);
224         if (fundingMaximumTargetInWei != 0 && tempTotalRasiedFunds > fundingMaximumTargetInWei) {
225             //  debugLog("insideIf Loop",0,3);
226             refundAmount = tempTotalRasiedFunds-fundingMaximumTargetInWei;
227             actualVlaue = _value-refundAmount;
228         }
229         contributions.push(
230             Contribution({
231                 amount: actualVlaue,
232                 contributor: _sender
233             })
234         );
235 
236         if ( refundAmount > 0 ){
237             if (!_sender.send(refundAmount)) {
238                 throw;
239             }
240             LogRefund(_sender,refundAmount);
241         }
242 
243         totalRaised += actualVlaue;
244         currentBalance = totalRaised;
245 
246         fundingTokens = (amountInWei * 100000000) / priceInWei;
247 
248         releaseTokens(_sender, fundingTokens);
249 
250         LogFundingReceived(_sender, actualVlaue, totalRaised);
251 
252         payOut();
253         checkIfFundingCompleteOrExpired();
254         return contributions.length - 1; //this will return the contribution ID
255     }
256 
257 
258     //************************************************************************************/
259     // To check if funding is given to the founders or the beneficiaries
260 
261     function checkIfFundingCompleteOrExpired() private {
262 
263         if (fundingMaximumTargetInWei != 0 && totalRaised >= fundingMaximumTargetInWei) {
264             state = State.Closed;
265             LogFundingSuccessful(totalRaised);
266             completedAt = now;
267 
268         } else if ( now > deadline )  {
269             if(totalRaised >= fundingMinimumTargetInWei){
270                 state = State.Closed;
271                 LogFundingSuccessful(totalRaised);
272                 completedAt = now;
273             } else{
274                 state = State.Failed;
275                 completedAt = now;
276             }
277         }
278     }
279 
280     function payOut()
281     private
282     inState(State.Fundraising)
283     {
284         if(!beneficiary.send(this.balance)) {
285             throw;
286         }
287         if (state == State.Successful) {
288             state = State.Closed;
289         }
290         currentBalance = 0;
291         LogWinnerPaid(beneficiary);
292     }
293 
294     //***************************************************************************/
295     //This default function will execute and will throw an exception if anything is executed besides defined functions
296 
297     // Modified by amit, added modifer instate to Verify the State of ICO
298     function () payable inState(State.Fundraising) isMinimum() { contribute(msg.sender); }
299 }