1 //                       , ; ,   .-'"""'-.   , ; ,
2 //                       \\|/  .'         '.  \|//
3 //                        \-;-/   ()   ()   \-;-/
4 //                        // ;               ; \\
5 //                       //__; :.         .; ;__\\
6 //                      `-----\'.'-.....-'.'/-----'
7 //                             '.'.-.-,_.'.'
8 //                               '(  (..-'
9 //                                 '-'
10 //   WHYSOS3RIOUS   PRESENTS :                          
11 //                                                                
12 //   MATCHING ETHERS                              
13 //   a Strategy and Luck DaapGame          
14 //   www.matching-ethers.com                 
15 //
16 //
17 // *** coded by WhySoS3rious, 2016.                                       ***//
18 // *** please do not copy without authorization                       ***//
19 // *** contact : reddit    /u/WhySoS3rious                                ***//
20 
21 //VERSION : 1.0
22 
23 // GAME MODE : MATCHING FINNEYS
24 // STAKE : 0.1 ETH
25 
26  contract Matching_Finneys
27 {
28     enum State{Active, Deactivated}
29     State public state;
30 
31     modifier onlyOwner() {
32 	    if (msg.sender!=owner) throw;
33 	    _
34     }
35     modifier onlyActive() {
36          if (state!=State.Active) throw;
37          _
38     }
39     modifier onlyInactive() {
40          if (state!=State.Deactivated) throw;
41          _
42     }
43     modifier equalGambleValue() {
44 	if (msg.value < gamble_value) throw;
45         if (msg.value > gamble_value) msg.sender.send(msg.value-gamble_value);
46 	_
47     }
48     modifier resolvePendingRound{
49         blockLastPlayer=block.number+1;    
50         if (pendingRound && blockLastPlayer!=blockEndRound ) endRound();
51 	else if (pendingRound && blockLastPlayer==blockEndRound) throw;
52 	_
53     }
54 
55     uint blockLastPlayer;
56     address private owner;
57     uint gamble_value;
58     uint information_cost;
59     uint round_max_size ;
60     uint round_min_size  ;  
61     uint index_player;
62     uint index_round_ended;
63     uint index_player_in_round;
64     bool pendingRound = false;
65     uint blockEndRound;
66     struct Gamble  {
67 	    address player;
68 	    bool flipped;
69     }
70     Gamble[] matchers; 
71     Gamble[] contrarians;
72     struct Result  {
73 	    address player_matcher;
74 	    bool flipped_matcher;
75 	    uint256 payout_matcher;
76 	    address player_contrarian;
77 	    bool flipped_contrarian;
78 	    uint256 payout_contrarian;
79     }
80     Result[] results; 
81     mapping (address => uint) payout_history;
82     mapping (address => uint) times_played_history;    
83      
84     //Contract Construtor
85     function Matching_Finneys() { //Initial settings
86 	    owner = msg.sender; 
87 	    round_min_size = 16;
88 	    round_max_size = 20;
89 	    information_cost= 500 szabo; //0.0005 ether, 0.5 finney
90             gamble_value = 100000 szabo; //0.1 ether
91     }
92     //FallBack Function (play by sending a transaction)
93     function () { 
94         bool flipped;
95         if (msg.value == gamble_value) flipped=false; 
96         if (msg.value > gamble_value) {
97             flipped=true;
98         }
99         Play(flipped); 
100     }
101     //Play Function (play by contract function call)
102     function Play(bool flipped) equalGambleValue onlyActive resolvePendingRound{
103         if ( index_player_in_round%2==0 ) {   //first is matcher
104 	    matchers.push(Gamble(msg.sender, flipped));
105 	}
106 	else {
107 	    contrarians.push(Gamble(msg.sender, flipped));
108 	}
109         index_player+=1;
110         index_player_in_round+=1;
111 	times_played_history[msg.sender]+=1;
112         if (index_player_in_round>=round_min_size && index_player_in_round%2==0) {
113 	            bool end = randomEnd();
114 		    if (end) {
115 		        pendingRound=true;
116 			blockEndRound=block.number;}
117         }
118     }
119 
120     //Random Number Generator (between 1 and range)
121     function randomGen(uint seed, uint range) private constant returns (uint randomNumber) {
122         return(uint(sha3(block.blockhash(block.number-1), seed))%range+1);
123     }
124     //Function that determines randomly when the round should be ended
125     function randomEnd() private returns(bool) {
126 	if (index_player_in_round==round_max_size) return true; //end if max_size
127 	else{
128 	    uint random = randomGen(index_player, (round_max_size-index_player_in_round)/2+1);
129 	    if (random==1) return true;
130 	    else return false;
131 	    }
132     }
133     //Function to end Round and pay winners
134     function endRound() private {
135         delete results;
136         uint256 random_start_contrarian = randomGen(index_player,(index_player_in_round)/2)-1;
137         uint256 payout_total;
138         for (var k = 0; k < (index_player_in_round)/2; k++) {
139             uint256 index_contrarian;
140 	    if (k+random_start_contrarian<(index_player_in_round)/2){
141 	        index_contrarian=k+random_start_contrarian;
142             }
143 	    else{
144 	        index_contrarian=(k+random_start_contrarian)-(index_player_in_round/2);
145 	    }
146 	    uint256 information_cost_matcher = information_cost * k;
147 	    uint256 payout_matcher = 2*(gamble_value-information_cost_matcher);
148 	    uint256 information_cost_contrarian = information_cost * index_contrarian;
149 	    uint256 payout_contrarian = 2*(gamble_value-information_cost_contrarian);
150 	    results.push(Result(matchers[k].player,matchers[k].flipped,payout_matcher,contrarians[index_contrarian].player,contrarians[index_contrarian].flipped, payout_contrarian));
151 	    if (matchers[k].flipped == contrarians[index_contrarian].flipped) {
152 	        matchers[k].player.send(payout_matcher);
153 		payout_total+=payout_matcher;
154 		payout_history[matchers[k].player]+=payout_matcher;
155 	    }
156 	    else {
157 	        contrarians[index_contrarian].player.send(payout_contrarian);
158 		payout_total+=payout_contrarian;
159 		payout_history[contrarians[k].player]+=payout_contrarian;
160 	    }
161 	}
162         index_round_ended+=1;
163         owner.send(index_player_in_round*gamble_value-payout_total);
164 	payout_total=0;
165         index_player_in_round=0;
166         delete matchers;
167         delete contrarians;
168 	pendingRound=false;
169 	if (terminate_after_round==true) state=State.Deactivated;
170     }
171     //Full Refund of Current Round (if needed)
172     function refundRound() 
173     onlyActive
174     onlyOwner noEthSent{  
175         uint totalRefund;
176 	uint balanceBeforeRefund=this.balance;
177         for (var k = 0;  k< matchers.length; k++) {
178 	            matchers[k].player.send(gamble_value);
179 		    totalRefund+=gamble_value;
180         }
181         for (var j = 0;  j< contrarians.length ; j++) {	
182 	            contrarians[j].player.send(gamble_value);
183 		    totalRefund+=gamble_value;		    
184         }
185 	delete matchers;
186 	delete contrarians;
187 	state=State.Deactivated;
188 	index_player_in_round=0;
189         uint balanceLeft = balanceBeforeRefund-totalRefund;
190 	if (balanceLeft >0) owner.send(balanceLeft);
191     }
192     //Function Pause contract after next round (for new contract or to change settings) 
193     bool terminate_after_round=false;
194     function deactivate()
195     onlyOwner noEthSent{
196 	    terminate_after_round=true;
197     }
198     //Function Reactivates contract (after change of settings for instance or a refound)
199     function reactivate()
200     onlyOwner noEthSent{
201         state=State.Active;
202         terminate_after_round=false;
203     }
204     //Function to change game settings (within limits)
205     //(to adapt to community feedback, popularity)
206     function config(uint new_max_round, uint new_min_round, uint new_information_cost, uint new_gamble_value)
207 	    onlyOwner
208 	    onlyInactive noEthSent{
209 	    if (new_max_round<new_min_round) throw;
210 	    if (new_information_cost > new_gamble_value/100) throw;
211 	    round_max_size = new_max_round;
212 	    round_min_size = new_min_round;
213 	    information_cost= new_information_cost;
214 	    gamble_value = new_gamble_value;
215     }
216     function changeOwner(address new_owner)
217 	    onlyOwner noEthSent{
218 	    owner=new_owner;
219     }
220     
221 
222     modifier noEthSent(){
223         if (msg.value>0) throw;
224 	_
225     }
226     //JSON GLOBAL STATS
227     function gameStats() noEthSent constant returns (uint number_of_player_in_round, uint total_number_of_player, uint number_of_round_ended, bool pending_round_to_resolve, uint block_end_last_round, uint block_last_player, State state, bool pause_contract_after_round)
228     {
229          number_of_player_in_round = index_player_in_round;
230 	 total_number_of_player = index_player;
231 	 number_of_round_ended = index_round_ended;
232 	 pending_round_to_resolve = pendingRound;
233 	 block_end_last_round = blockEndRound;
234 	 block_last_player = blockLastPlayer;
235 	 state = state;
236 	 pause_contract_after_round = terminate_after_round;
237      }
238      //JSON CURRENT SETTINGS
239      function gameSettings() noEthSent constant returns (uint _gamble_value, uint _information_cost, uint _round_min_size, uint _round_max_size) {
240 	 _gamble_value = gamble_value;
241 	 _information_cost = information_cost;
242 	 _round_min_size = round_min_size;
243 	 _round_max_size = round_max_size;
244      }
245 
246     //JSON MATCHER TEAM
247     function getMatchers_by_index(uint _index) noEthSent constant returns (address _address, bool _flipped) {
248         _address=matchers[_index].player;
249 	_flipped = matchers[_index].flipped;
250     }
251     //JSON CONTRARIAN TEAM
252     function getContrarians_by_index(uint _index) noEthSent constant returns (address _address, bool _flipped) {
253         _address=contrarians[_index].player;
254 	_flipped = contrarians[_index].flipped;
255     }
256     //JSON LAST ROUND RESULT
257     function getLastRoundResults_by_index(uint _index) noEthSent constant returns (address _address_matcher, address _address_contrarian, bool _flipped_matcher, bool _flipped_contrarian, uint _payout_matcher, uint _payout_contrarian) {
258         _address_matcher=results[_index].player_matcher;
259         _address_contrarian=results[_index].player_contrarian;
260 	_flipped_matcher = results[_index].flipped_matcher;
261 	_flipped_contrarian = results[_index].flipped_contrarian;
262 	_payout_matcher =  results[_index].payout_matcher;
263 	_payout_contrarian =  results[_index].payout_contrarian;
264     }
265     //User set nickname for the website
266      mapping (address => string) nicknames;
267      function setNickname(string name) noEthSent{
268          if (bytes(name).length >= 2 && bytes(name).length <= 16)
269              nicknames[msg.sender] = name;
270      }
271      function getNickname(address _address) noEthSent constant returns(string _name) {
272              _name = nicknames[_address];
273      }
274      //JSON HISTORY
275      function historyPayout(address _address) noEthSent constant returns(uint _payout) {
276              _payout = payout_history[_address]; 
277      }
278      function historyTimesPlayed(address _address) noEthSent constant returns(uint _count) {
279              _count = times_played_history[_address]; 
280      }
281 
282 }