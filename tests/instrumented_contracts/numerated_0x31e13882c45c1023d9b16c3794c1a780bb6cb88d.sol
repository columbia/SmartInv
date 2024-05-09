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
23 // GAME MODE : MATCHING ETHERS
24 // STAKE : 1 ETH
25 
26  contract Matching_Ethers
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
85     function Matching_Ethers() { //Initial settings
86 	    owner = msg.sender; 
87 	    round_min_size = 16;
88 	    round_max_size = 20;
89 	    information_cost= 5000 szabo; //0.005 ether, 5 finney
90             gamble_value = 1000000 szabo; //1 ether
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
119     //Random Number Generator (between 1 and range)
120     function randomGen(uint seed, uint range) private constant returns (uint randomNumber) {
121         return(uint(sha3(block.blockhash(block.number-1), seed))%range+1);
122     }
123     //Function that determines randomly when the round should be ended
124     function randomEnd() private returns(bool) {
125 	if (index_player_in_round==round_max_size) return true; //end if max_size
126 	else{
127 	    uint random = randomGen(index_player, (round_max_size-index_player_in_round)/2+1);
128 	    if (random==1) return true;
129 	    else return false;
130 	    }
131     }
132     //Function to end Round and pay winners
133     function endRound() private {
134         delete results;
135         uint256 random_start_contrarian = randomGen(index_player,(index_player_in_round)/2)-1;
136         uint256 payout_total;
137         for (var k = 0; k < (index_player_in_round)/2; k++) {
138             uint256 index_contrarian;
139 	    if (k+random_start_contrarian<(index_player_in_round)/2){
140 	        index_contrarian=k+random_start_contrarian;
141             }
142 	    else{
143 	        index_contrarian=(k+random_start_contrarian)-(index_player_in_round/2);
144 	    }
145 	    uint256 information_cost_matcher = information_cost * k;
146 	    uint256 payout_matcher = 2*(gamble_value-information_cost_matcher);
147 	    uint256 information_cost_contrarian = information_cost * index_contrarian;
148 	    uint256 payout_contrarian = 2*(gamble_value-information_cost_contrarian);
149 	    results.push(Result(matchers[k].player,matchers[k].flipped,payout_matcher,contrarians[index_contrarian].player,contrarians[index_contrarian].flipped, payout_contrarian));
150 	    if (matchers[k].flipped == contrarians[index_contrarian].flipped) {
151 	        matchers[k].player.send(payout_matcher);
152 		payout_total+=payout_matcher;
153 		payout_history[matchers[k].player]+=payout_matcher;
154 	    }
155 	    else {
156 	        contrarians[index_contrarian].player.send(payout_contrarian);
157 		payout_total+=payout_contrarian;
158 		payout_history[contrarians[k].player]+=payout_contrarian;
159 	    }
160 	}
161         index_round_ended+=1;
162         owner.send(index_player_in_round*gamble_value-payout_total);
163 	payout_total=0;
164         index_player_in_round=0;
165         delete matchers;
166         delete contrarians;
167 	pendingRound=false;
168 	if (terminate_after_round==true) state=State.Deactivated;
169     }
170     //Full Refund of Current Round (if needed)
171     function refundRound() 
172     onlyActive
173     onlyOwner noEthSent{  
174         uint totalRefund;
175 	uint balanceBeforeRefund=this.balance;
176         for (var k = 0;  k< matchers.length; k++) {
177 	            matchers[k].player.send(gamble_value);
178 		    totalRefund+=gamble_value;
179         }
180         for (var j = 0;  j< contrarians.length ; j++) {	
181 	            contrarians[j].player.send(gamble_value);
182 		    totalRefund+=gamble_value;		    
183         }
184 	delete matchers;
185 	delete contrarians;
186 	state=State.Deactivated;
187 	index_player_in_round=0;
188         uint balanceLeft = balanceBeforeRefund-totalRefund;
189 	if (balanceLeft >0) owner.send(balanceLeft);
190     }
191     //Function Pause contract after next round (for new contract or to change settings) 
192     bool terminate_after_round=false;
193     function deactivate()
194     onlyOwner noEthSent{
195 	    terminate_after_round=true;
196     }
197     //Function Reactivates contract (after change of settings for instance or a refound)
198     function reactivate()
199     onlyOwner noEthSent{
200         state=State.Active;
201         terminate_after_round=false;
202     }
203     //Function to change game settings (within limits)
204     //(to adapt to community feedback, popularity)
205     function config(uint new_max_round, uint new_min_round, uint new_information_cost, uint new_gamble_value)
206 	    onlyOwner
207 	    onlyInactive noEthSent{
208 	    if (new_max_round<new_min_round) throw;
209 	    if (new_information_cost > new_gamble_value/100) throw;
210 	    round_max_size = new_max_round;
211 	    round_min_size = new_min_round;
212 	    information_cost= new_information_cost;
213 	    gamble_value = new_gamble_value;
214     }
215     function changeOwner(address new_owner)
216 	    onlyOwner noEthSent{
217 	    owner=new_owner;
218     }
219     
220 
221     modifier noEthSent(){
222         if (msg.value>0) throw;
223 	_
224     }
225     //JSON GLOBAL STATS
226     function gameStats() noEthSent constant returns (uint number_of_player_in_round, uint total_number_of_player, uint number_of_round_ended, bool pending_round_to_resolve, uint block_end_last_round, uint block_last_player, State state, bool pause_contract_after_round)
227     {
228          number_of_player_in_round = index_player_in_round;
229 	 total_number_of_player = index_player;
230 	 number_of_round_ended = index_round_ended;
231 	 pending_round_to_resolve = pendingRound;
232 	 block_end_last_round = blockEndRound;
233 	 block_last_player = blockLastPlayer;
234 	 state = state;
235 	 pause_contract_after_round = terminate_after_round;
236      }
237      //JSON CURRENT SETTINGS
238      function gameSettings() noEthSent constant returns (uint _gamble_value, uint _information_cost, uint _round_min_size, uint _round_max_size) {
239 	 _gamble_value = gamble_value;
240 	 _information_cost = information_cost;
241 	 _round_min_size = round_min_size;
242 	 _round_max_size = round_max_size;
243      }
244 
245     //JSON MATCHER TEAM
246     function getMatchers_by_index(uint _index) noEthSent constant returns (address _address, bool _flipped) {
247         _address=matchers[_index].player;
248 	_flipped = matchers[_index].flipped;
249     }
250     //JSON CONTRARIAN TEAM
251     function getContrarians_by_index(uint _index) noEthSent constant returns (address _address, bool _flipped) {
252         _address=contrarians[_index].player;
253 	_flipped = contrarians[_index].flipped;
254     }
255     //JSON LAST ROUND RESULT
256     function getLastRoundResults_by_index(uint _index) noEthSent constant returns (address _address_matcher, address _address_contrarian, bool _flipped_matcher, bool _flipped_contrarian, uint _payout_matcher, uint _payout_contrarian) {
257         _address_matcher=results[_index].player_matcher;
258         _address_contrarian=results[_index].player_contrarian;
259 	_flipped_matcher = results[_index].flipped_matcher;
260 	_flipped_contrarian = results[_index].flipped_contrarian;
261 	_payout_matcher =  results[_index].payout_matcher;
262 	_payout_contrarian =  results[_index].payout_contrarian;
263     }
264     //User set nickname for the website
265      mapping (address => string) nicknames;
266      function setNickname(string name) noEthSent{
267          if (bytes(name).length >= 2 && bytes(name).length <= 16)
268              nicknames[msg.sender] = name;
269      }
270      function getNickname(address _address) noEthSent constant returns(string _name) {
271              _name = nicknames[_address];
272      }
273      //JSON HISTORY
274      function historyPayout(address _address) noEthSent constant returns(uint _payout) {
275              _payout = payout_history[_address]; 
276      }
277      function historyTimesPlayed(address _address) noEthSent constant returns(uint _count) {
278              _count = times_played_history[_address]; 
279      }
280 
281 }