1 pragma solidity ^0.4.11;
2 
3 // ERC20 token interface is implemented only partially.
4 // Token transfer is prohibited due to spec (see PRESALE-SPEC.md),
5 // hence some functions are left undefined:
6 //  - transfer, transferFrom,
7 //  - approve, allowance.
8 
9 contract MaptPresale2Token {
10     // MAPT TOKEN PRICE:
11     uint256 constant MAPT_IN_ETH = 100; // 1 MAPT = 0.01 ETH
12 
13     uint constant MIN_TRANSACTION_AMOUNT_ETH = 0 ether;
14 
15     uint public PRESALE_START_DATE = 1506834000; //Sun Oct  1 12:00:00 +07 2017
16     uint public PRESALE_END_DATE = 1508198401; //17 oct 00:00:01 +00
17 
18     /// @dev Constructor
19     /// @param _tokenManager Token manager address.
20     function MaptPresale2Token(address _tokenManager, address _escrow) {
21         tokenManager = _tokenManager;
22         escrow = _escrow;
23         PRESALE_START_DATE = now;
24     }
25 
26     /*/
27      *  Constants
28     /*/
29     string public constant name = "MAT Presale2 Token";
30     string public constant symbol = "MAPT2";
31     uint   public constant decimals = 18;
32 
33     // Cup is 2M tokens
34     uint public constant TOKEN_SUPPLY_LIMIT = 2700000 * 1 ether / 1 wei;
35 
36     /*/
37      *  Token state
38     /*/
39     enum Phase {
40         Created,
41         Running,
42         Paused,
43         Migrating,
44         Migrated
45     }
46 
47     Phase public currentPhase = Phase.Created;
48 
49     uint public totalSupply = 0; // amount of tokens already sold
50 
51     // Token manager has exclusive priveleges to call administrative
52     // functions on this contract.
53     address public tokenManager;
54 
55     // Gathered funds can be withdrawn only to escrow's address.
56     address public escrow;
57 
58     // Crowdsale manager has exclusive priveleges to burn presale tokens.
59     address public crowdsaleManager;
60 
61     mapping (address => uint256) private balanceTable;
62 
63     /*/
64      * Modifiers
65     /*/
66     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
67     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
68 
69     /*/
70      *  Events
71     /*/
72     event LogBuy(address indexed owner, uint etherWeiIncoming, uint tokensSold);
73     event LogBurn(address indexed owner, uint value);
74     event LogPhaseSwitch(Phase newPhase);
75     event LogEscrowWei(uint balanceWei);
76     event LogEscrowWeiReq(uint balanceWei);
77     event LogEscrowEth(uint balanceEth);
78     event LogEscrowEthReq(uint balanceEth);
79     event LogStartDate(uint newdate, uint oldDate);
80 
81 
82     /**
83      * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
84      *
85      * @param valueWei - What is the value of the transaction send in as wei
86      * @return Amount of tokens the investor receives
87      */
88     function calculatePrice(uint valueWei) private constant returns (uint tokenAmount) {
89       uint res = valueWei * MAPT_IN_ETH;
90       return res;
91     }
92 
93     /*/
94      *  Public functions
95     /*/
96     function() payable {
97         buyTokens(msg.sender);
98     }
99 
100     /// @dev Returns number of tokens owned by given address.
101     /// @param _owner Address of token owner.
102     function burnTokens(address _owner)
103         public
104         onlyCrowdsaleManager
105         returns (uint)
106     {
107         // Available only during migration phase
108         if(currentPhase != Phase.Migrating) return 1;
109 
110         uint tokens = balanceTable[_owner];
111         if(tokens == 0) return 2;
112         totalSupply -= tokens;
113         balanceTable[_owner] = 0;
114         LogBurn(_owner, tokens);
115 
116         // Automatically switch phase when migration is done.
117         if(totalSupply == 0) {
118             currentPhase = Phase.Migrated;
119             LogPhaseSwitch(Phase.Migrated);
120         }
121 
122         return 0;
123     }
124 
125     /// @dev Returns number of tokens owned by given address.
126     /// @param _owner Address of token owner.
127     function balanceOf(address _owner) constant returns (uint256) {
128         return balanceTable[_owner];
129     }
130 
131     /*/
132      *  Administrative functions
133     /*/
134 
135     //takes uint
136     function setPresalePhaseUInt(uint phase)
137         public
138         onlyTokenManager
139     {
140       require( uint(Phase.Migrated) >= phase && phase >= 0 );
141       setPresalePhase(Phase(phase));
142     }
143 
144     // takes enum
145     function setPresalePhase(Phase _nextPhase)
146         public
147         onlyTokenManager
148     {
149       _setPresalePhase(_nextPhase);
150     }
151 
152     function _setPresalePhase(Phase _nextPhase)
153         private
154     {
155         bool canSwitchPhase
156             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
157             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
158                 // switch to migration phase only if crowdsale manager is set
159             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
160                 && _nextPhase == Phase.Migrating
161                 && crowdsaleManager != 0x0)
162             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
163                 // switch to migrated only if everyting is migrated
164             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
165                 && totalSupply == 0);
166 
167         if(!canSwitchPhase) throw;
168         currentPhase = _nextPhase;
169         LogPhaseSwitch(_nextPhase);
170     }
171 
172     function setCrowdsaleManager(address _mgr)
173         public
174         onlyTokenManager
175     {
176         // You can't change crowdsale contract when migration is in progress.
177         if(currentPhase == Phase.Migrating) throw;
178         crowdsaleManager = _mgr;
179     }
180 
181     /** buy tokens for Ehter */
182     function buyTokens(address _buyer)
183         public
184         payable
185     {
186         require(totalSupply < TOKEN_SUPPLY_LIMIT);
187         uint valueWei = msg.value;
188 
189         //conditions
190         require(currentPhase == Phase.Running);
191         require(valueWei >= MIN_TRANSACTION_AMOUNT_ETH);
192         require(now >= PRESALE_START_DATE);
193         require(now <= PRESALE_END_DATE);
194 
195         uint newTokens = calculatePrice(valueWei);
196 
197         require(newTokens > 0);
198         require(totalSupply + newTokens <= TOKEN_SUPPLY_LIMIT);
199 
200         totalSupply += newTokens;
201         balanceTable[_buyer] += newTokens;
202 
203         LogBuy(_buyer, valueWei, newTokens);
204     }
205 
206     /**
207      * return values: 0 - OK, 1 - balance is zero, 2 - cannot send to escrow
208      */
209     function withdrawWei(uint balWei)
210         public
211         onlyTokenManager
212         returns (uint)
213     {
214         // Available at any phase.
215         LogEscrowWeiReq(balWei);
216         if(this.balance >= balWei) {
217             escrow.transfer(balWei);
218             LogEscrowWei(balWei);
219             return 0;
220         }
221         return 1;
222     }
223 
224     /**
225      * return values: 0 - OK, 1 - balance is zero, 2 - cannot send to escrow
226      */
227     function withdrawEther(uint sumEther)
228         public
229         onlyTokenManager
230         returns (uint)
231     {
232         // Available at any phase.
233         LogEscrowEthReq(sumEther);
234         uint sumWei = sumEther * 1 ether / 1 wei;
235         if(this.balance >= sumWei) {
236             escrow.transfer(sumWei);
237             LogEscrowWei(sumWei);
238             return 0;
239         }
240         return 1;
241     }
242 }