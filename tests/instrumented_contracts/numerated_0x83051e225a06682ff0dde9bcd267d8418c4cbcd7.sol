1 contract ParallelGambling {
2     
3     //--------parameters
4     uint[3] private deposit;
5     uint private feesThousandth = 10;       //1% of fees !
6     uint private time_max = 6 * 60 * 60;   //6 hours in seconds, time to wait before you can cancel the round
7     uint private fees = 0; 
8     
9     //percentage of attribution of differents prizes
10     uint private first_prize = 170;     //Big winner gets 160 %
11     uint private second_prize = 130;    //Little winner gets 140 %
12     uint private third_prize = 0;       //looser gets nothing !
13     
14     //--Contract ledger for the 3 "play zones"
15     
16     uint[3] private Balance;
17     uint[3] private id;
18     uint[3] private cursor;
19     uint[3] private nb_player ;
20     uint[3] private last_time ;
21     
22     // -- random uniformers -
23 	uint256 private toss1;
24 	uint256 private toss2;
25 	
26 	
27     address private admin;
28     
29     //Constructor - executed on creation only
30     function ParallelGambling() {
31         admin = msg.sender;
32         uint i;
33         //*****initiate everything properly****
34         for(i=0;i<3;i++){
35             Balance[i]=0;
36             last_time[i] = block.timestamp;
37             nb_player[i]=0;
38             id[i]=0;
39 			cursor[i]=0;
40         }
41         deposit[0]= 100 finney; // ZONE 1
42         deposit[1]= 1 ether;    // ZONE 2
43         deposit[2]= 5 ether;    // ZONE 3
44     }
45 
46     modifier onlyowner {if (msg.sender == admin) _  }
47 
48     
49     struct Player { //for each entry
50         address addr;
51         uint payout; //this section is filled when payout are done !
52         bool paid;
53     }
54     
55     Player[][3] private players;
56 	
57 	
58 	struct GamblerStats { //for each address, to keep a record
59 		uint bets;
60 		uint deposits;
61 		uint paid;
62 	}
63 	mapping(address => GamblerStats) private gamblers;
64 
65     
66     function() {
67         init();
68     }
69 
70     
71     function init() private {
72         //------ Verifications to select play zone-----
73         uint256 actual_deposit = msg.value;
74         uint zone_selected;
75         
76         if (actual_deposit < deposit[0]) { //not enough for any zones !
77             msg.sender.send(actual_deposit);
78             return;
79         }
80         if(actual_deposit >= deposit[0] && actual_deposit < deposit[1]){   // GAME ZONE 1
81 			if( actual_deposit-deposit[0] >0){
82 				msg.sender.send(actual_deposit-deposit[0]);
83 			}
84             actual_deposit=deposit[0];
85             zone_selected=0;
86         }
87         if(actual_deposit >= deposit[1] && actual_deposit < deposit[2]){   // GAME ZONE 2
88 			if( actual_deposit-deposit[1] >0){
89 				msg.sender.send(actual_deposit-deposit[1]);
90 			}
91             actual_deposit=deposit[1];
92             zone_selected=1;
93         }
94         if(actual_deposit >= deposit[2]){                             // GAME ZONE 3
95 			if( actual_deposit-deposit[2] >0){
96 				msg.sender.send(actual_deposit-deposit[2]);
97 			}
98             actual_deposit=deposit[2];
99             zone_selected=2;
100         }
101         
102         //----update balances and ledger according to the playing zone selected---
103         
104         fees += (actual_deposit * feesThousandth) / 1000;      // collect 1% fee
105         Balance[zone_selected] += (actual_deposit * (1000 - feesThousandth )) / 1000; //update balance
106         
107         last_time[zone_selected] = block.timestamp;
108         
109         players[zone_selected].length++;
110         players[zone_selected][cursor[zone_selected]]=(Player(msg.sender,  0 , false));
111 		cursor[zone_selected]++;
112         nb_player[zone_selected]++;
113 		
114 		//update stats
115 		gamblers[msg.sender].bets++;
116 		gamblers[msg.sender].deposits += actual_deposit;
117 		
118 		//random
119 		if(nb_player[zone_selected]%2 ==0)	toss1 = uint256(sha3(msg.gas)) + uint256(sha3(block.timestamp));
120 		else toss2 = uint256(sha3(tx.gasprice+block.difficulty)); 
121         
122         //-check if end of the round
123         if(nb_player[zone_selected] == 3){ //end of a round
124             EndRound(zone_selected);
125         }
126     }
127     
128     function EndRound(uint zone) private{
129         
130         //randomness is created here from previous toss
131         uint256 toss = toss1+toss2+msg.value; //send a value higher than the required deposit to create more randomness if you are the third player (ending round).
132 		//indices of players
133         uint i_big_winner;
134         uint i_small_winner;
135         uint i_looser;
136         
137         if( toss % 3 == 0 ){
138             i_big_winner=id[zone];
139             i_small_winner=id[zone]+1;
140             i_looser =id[zone]+2;
141         }
142         else if( toss % 3 == 1){
143             i_big_winner=id[zone]+2;
144             i_small_winner=id[zone];
145             i_looser =id[zone]+1;
146         }
147         else{
148             i_big_winner=id[zone]+1;
149             i_small_winner=id[zone]+2;
150             i_looser =id[zone];
151         }
152         
153         uint256 effective_bet = (deposit[zone] * (1000 - feesThousandth )) / 1000;
154         
155         players[zone][i_big_winner].addr.send(effective_bet*first_prize/100);     //big win
156         players[zone][i_small_winner].addr.send(effective_bet*second_prize/100);    //small win
157         if(third_prize > 0){
158             players[zone][i_small_winner].addr.send(effective_bet*third_prize/100);    //looser
159         }
160         
161         //update zone information
162         players[zone][i_big_winner].payout=effective_bet*first_prize/100;
163         players[zone][i_small_winner].payout=effective_bet*second_prize/100;
164         players[zone][i_looser].payout=effective_bet*third_prize/100;
165         players[zone][id[zone]].paid=true;
166         players[zone][id[zone]+1].paid=true;
167         players[zone][id[zone]+2].paid=true;
168 		//update gamblers ledger
169 		gamblers[players[zone][i_big_winner].addr].paid += players[zone][i_big_winner].payout;
170 		gamblers[players[zone][i_small_winner].addr].paid += players[zone][i_small_winner].payout;
171 		gamblers[players[zone][i_looser].addr].paid += players[zone][i_looser].payout;
172 		
173         Balance[zone]=0;
174         nb_player[zone]=0;
175         id[zone] += 3;
176     }
177 
178     
179     function CancelRoundAndRefundAll(uint zone) { //refund every participants in a zone, anyone can call this !
180         if(zone<0 && zone>3) throw;
181         if(nb_player[zone]==0) return;
182         
183         uint256 pay=(deposit[zone] * (1000 - feesThousandth )) / 1000;
184         
185         if (last_time[zone] + time_max < block.timestamp) {
186             for(uint i=id[zone]; i<(id[zone]+nb_player[zone]); i++){
187                 players[zone][i].addr.send(pay);
188                 players[zone][i].paid=true;
189                 players[zone][i].payout=pay;
190 				
191 				gamblers[players[zone][i].addr].bets--;
192 				gamblers[players[zone][i].addr].deposits -= pay;
193             }
194             id[zone] += nb_player[zone];
195             nb_player[zone]=0;
196 			Balance[zone]=0;
197 			//remove informations from stats - cancelling = removing
198 			
199         }
200     }
201     
202     //------------ Contract informations -----------------------------------
203     
204     
205     function LookAtBalance() constant returns(uint BalanceOfZone1,uint BalanceOfZone2,uint BalanceOfZone3, string info) {
206         BalanceOfZone1 = Balance[0] /  1 finney;
207         BalanceOfZone2 = Balance[1] /  1 finney;
208         BalanceOfZone3 = Balance[2] /  1 finney;
209         info ='Balances of all play zones in finney';
210     }
211     
212     function PlayerInfoPerZone(uint id, uint zone) constant returns(address Address, uint Payout, bool UserPaid, string info) {
213         if(zone<0 && zone>3) throw;
214         if (id <= players[zone].length) {
215             Address = players[zone][id].addr;
216             Payout = (players[zone][id].payout) / 1 finney;
217             UserPaid= players[zone][id].paid;
218         }
219 		
220 		info = 'Select zone between 0 and 2, then use the id to look trough this zone';
221     }
222     
223     function LookAtLastTimePerZone(uint zone) constant returns(uint LastTimeForSelectedZone,uint TimeToWaitEnablingRefund, string info) {
224         if(zone<0 && zone>3) throw;
225         LastTimeForSelectedZone = last_time[zone];
226         TimeToWaitEnablingRefund = time_max;
227         info ='Timestamps, use this to know when you can cancel a round to get back funds, TimeToWait in seconds !';
228     }
229 
230     function LookAtCollectedFees() constant returns(uint Fees, string info) {
231         Fees = fees / 1 finney;
232 		info = 'Fees collected, in finney.';
233     }
234     
235     
236     function LookAtDepositsToPlay() constant returns(uint InZone1,uint InZone2,uint InZone3, string info) {
237         InZone1 = deposit[0] / 1 finney;
238         InZone2 = deposit[1] / 1 finney;
239         InZone3 = deposit[2] / 1 finney;
240 		info = 'Deposit for each zones, in finney. Surpus are always refunded.';
241     }
242 
243     function LookAtPrizes() constant returns(uint FirstPrize,uint SecondPrize,uint LooserPrize, string info) {
244 		FirstPrize=first_prize;
245 		SecondPrize=second_prize;
246 		LooserPrize=third_prize;
247 	
248 		info = 'Prizes in percent of the deposit';
249     }
250 	
251 	function GamblerPerAddress(address addr) constant returns(uint Bets, uint Deposited, uint PaidOut, string info) {
252 		Bets      = gamblers[addr].bets;
253 		Deposited = gamblers[addr].deposits / 1 finney;
254 		PaidOut   = gamblers[addr].paid / 1 finney;
255 		info ='Bets is the number of time you participated, no matter the zone.';
256 	}
257 	
258     function LookAtNumberOfPlayers() constant returns(uint InZone1,uint InZone2,uint InZone3, string info) {
259         InZone1 = nb_player[0];
260         InZone2 = nb_player[1];
261         InZone3 = nb_player[2];
262 		
263 		info = 'Players in a round, in each zones.';
264     }
265     //----------- Contract management functions -------------------------
266     
267     function ChangeOwnership(address _owner) onlyowner {
268         admin = _owner;
269     }
270 	
271 	
272     function ModifyFeeFraction(uint new_fee) onlyowner {
273 		if( new_fee>=0 && new_fee<=20 ){ //admin can only set the fee percentage between 0 and 2%, initially 1%
274 			feesThousandth = new_fee;
275 		}
276     }
277     
278     //function to modify settings, only if no player in a round !
279     function ModifySettings(uint new_time_max, uint new_first_prize, uint new_second_prize, uint new_third_prize,
280                             uint deposit_1,uint deposit_2,uint deposit_3) onlyowner {
281         if(nb_player[0]!=0 || nb_player[1]!=0 || nb_player[2]!=0 ) throw; //can only modify if nobody plays !
282         
283         if(new_time_max>=(1 * 60 * 60) && new_time_max<=(24 * 60 * 60) ) time_max=new_time_max;
284 		
285 		if((new_first_prize+new_second_prize+new_third_prize)==300){ //the total must be distributed in a correct way
286 			if(new_first_prize>=130 && new_first_prize<=190){			
287 				first_prize=new_first_prize;
288 				if(new_second_prize>100 && new_second_prize<=130){
289 					second_prize=new_second_prize;
290 					if(new_third_prize>=0 && new_third_prize<=50) third_prize=new_third_prize;
291 				}
292 			}
293         }
294         if(deposit_1>=(1 finney) && deposit_1<(1 ether)) deposit[0]=deposit_1;
295         if(deposit_2>=(1 ether) && deposit_2<(5 ether)) deposit[1]=deposit_2;
296         if(deposit_3>=(5 ether) && deposit_3<=(20 ether)) deposit[2]=deposit_3;
297         
298     }
299     
300     function CollectAllFees() onlyowner { //it just send fees, that's all folks !
301         if (fees == 0) throw;
302         admin.send(fees);
303         fees = this.balance -Balance[0]-Balance[1]-Balance[2]; //just in case there is lost ethers.
304     }
305 }