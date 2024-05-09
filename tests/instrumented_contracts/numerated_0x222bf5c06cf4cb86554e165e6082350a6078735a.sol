1 /**
2  * Decentraliced Grid Organization
3  * Version: 0.0.1
4  * Author: Thorsten Zoerner <me@thorsten-zoerner.com>
5  * Donations: btc:1MvghD6TE2nurN4iCUSLdmcCRiwohgCA86 eth:0x697a040b13aefdd9553f3922dcb547be6efd88d2
6  * Implementation: Ethereum/Solidity
7  */
8 
9 /**
10 Business Case / Purpose
11 =========================================================================================
12 Introduces a smart contract for members of a power grid to facilitate P2P balancing.
13 
14 - Implements post delivery balancing with peers
15 - Provides tokens per GridMember for clearing
16 - Handles simple prioty list for merit order 
17 - Allow Exchange of Meter Device
18 - Allow multiple "Listeners" (Push Clients) per MP (according to Smart Meter Gateway Concept)
19 
20 Requires independend smart meter operator.
21 */
22 /*
23 [{"constant":false,"inputs":[{"name":"from","type":"address"},{"name":"to","type":"address"}],"name":"switchMPO","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"mp","outputs":[{"name":"","type":"address"}],"type":"function"}]
24 */
25 contract MPO { 
26 	uint256 public reading;
27 	uint256 public time;
28 	address public operator; 
29 	uint256 shift;
30 	string public name ="MP";
31 	string public symbol ="Wh";
32 	event Transfer(address indexed from, address indexed to, uint256 value);
33 	mapping (address => uint256) public balanceOf;
34 	address[] public listeners;
35 	
36 	function MPO() {
37 		operator=msg.sender;
38 		shift=0;
39 	}
40 	
41 	function updateReading(uint256 last_reading,uint256 timeofreading) {		
42 		if(msg.sender!=operator) throw;
43 		if((timeofreading<time)||(reading>last_reading)) throw;	
44 		var oldreading=last_reading;
45 		reading=last_reading-shift;
46 		time=timeofreading;	
47 		balanceOf[this]=last_reading;
48 		for(var i=0;i<listeners.length;i++) {
49 			balanceOf[listeners[i]]=last_reading;
50 			Transfer(msg.sender,listeners[i],last_reading-oldreading);
51 		}
52 	}
53 	
54 	function registerListening(address a) {
55 		listeners.push(a);
56 		balanceOf[a]=reading;
57 		Transfer(msg.sender,a,reading);
58 	}
59 	
60 	function unregisterListening(address a) {
61 	
62 		for(var i=0;i<listeners.length;i++) {
63 			if(listeners[i]==a) listeners[i]=0;
64 		}
65 		
66 	}
67 	function transferOwnership(address to) {
68 		if(msg.sender!=operator) throw;
69 		operator=to;
70 	}
71 	function transfer(address _to, uint256 _value) {
72 		/* Function stub required to see tokens in wallet */		
73         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
74     }
75 	function assetMoveInformation(address newmpo,address gridMemberToInform) {
76 		if(msg.sender!=operator) throw;
77 		/*var gm=GridMember(gridMemberToInform);
78 		gm.switchMPO(this,newmpo);
79 		*/
80 	}
81 	
82 }
83 contract MPOListener {
84 	MPO public mp;
85 	
86 	function switchMPO(address from, address to) {
87 		if(msg.sender!=mp.operator()) throw;
88 		if(mp==from) {
89 			mp=MPO(to);			
90 		}
91 	}
92 }
93 contract operated {
94     address public operator;
95 
96     function operated() {
97         operator = msg.sender;
98     }
99 
100     modifier onlyOperator {
101         if (msg.sender != operator) throw;
102         _
103     }
104 
105     function transferOperator(address newOperator) onlyOperator {
106         operator = newOperator;
107     }
108 }
109 
110 contract GridMember is operated,MPOListener {
111 		
112 	
113 	address[] public peers;
114 	uint256 public lastreading;
115 	string public name;
116 	uint256 public actual_feedin=0;
117 	uint256 public actual_feedout=0;	
118 	uint256 public total_feedin;
119 	uint256 public total_feedout;
120 	string public symbol ="Wh";
121 	uint256 public managedbalance;
122 	bool public feedin;
123 	bool public autobalancepeers;
124 	bool listening;
125 	address public aggregate;
126 	event Transfer(address indexed from, address indexed to, uint256 value);
127 	mapping (address => uint256) public balanceOf;
128 	mapping (address => uint256) public allowance;	
129 	
130 	mapping (address => uint256) public molist;
131 	
132 	function GridMember(string membername,uint256 managablebalance,bool directionFeedin,address mpo,address aggregation) {			
133 		name=membername;
134 		managedbalance=managablebalance;
135 		balanceOf[this]=managablebalance;
136 		Transfer(msg.sender,this,managablebalance);
137 		feedin=directionFeedin;		
138 		if(feedin) total_feedin=lastreading; else total_feedout=lastreading;
139 		autobalancepeers=false;	
140 		mp=MPO(mpo);
141 		updateReading(mp.reading());		
142 		actual_feedin=0;
143 		actual_feedout=0;
144 		listening=false;
145 		aggregate=aggregation;
146 	}
147 	
148 	function switchMPO(address from, address to) {
149 		if(msg.sender!=mp.operator()) throw;
150 		updateWithMPO();
151 		lastreading=0;
152 		super.switchMPO(from,to);
153 		updateWithMPO();
154 		listening=false;
155 	}
156 	function registerListening() onlyOperator {
157 		mp.registerListening(this);
158 		listening=true;
159 	}
160 	
161 	function addPowerSource(address peer,uint256 manageallowed,uint merritorder) onlyOperator {
162 		if(merritorder>9) throw;
163 		if(feedin) throw;
164  		allowance[peer]=manageallowed;
165 		peers.push(peer);
166 		molist[peer]=merritorder;
167 		
168 	} 
169 	
170 	function updateWithMPO() {			
171 		updateReading(mp.balanceOf(mp));
172 	}
173 		
174 	function updateReading(uint256 reading) private {	
175 		if(getActual()>0) runPeerBalance();
176 		if(reading<lastreading) throw;
177 		var actual = reading -lastreading;
178 		if(feedin) actual_feedin+=actual; else actual_feedout+=actual;		
179 		if(feedin) total_feedin+=actual; else total_feedout+=actual;										
180 		lastreading=reading;
181 		runPeerBalance();
182 	}
183 	
184 	function requestPeerBalance() onlyOperator {
185 		updateWithMPO();
186 		runPeerBalance();
187 		Aggregation a = Aggregation(aggregate);
188 		a.doBalanceFor(this);
189 		
190 	}
191 	
192 	function runPeerBalance() private {
193 		for(var j=0;j<10;j++) {
194 			for(var i=0;i<peers.length;i++) {
195 				if(molist[peers[i]]==j) {
196 				GridMember peer = GridMember(peers[i]);
197 				allowance[peer]=getActual();
198 				peer.doBalance(this);
199 				}
200 			}
201 		}	
202 	}
203 	function getActual() returns(uint256) {
204 		if(feedin) return actual_feedin; else return actual_feedout;				
205 	}
206 	
207 	function receiveTransfer(uint256 amount) {
208 		if(tx.origin!=operator) throw;	
209 		if(feedin) actual_feedin-=amount; else actual_feedout-=amount;
210 	}
211 	function sendToAggregation(uint256 amount) {
212 		balanceOf[this]-=amount;
213 		balanceOf[aggregate]+=amount;
214 		if(feedin) actual_feedin-=amount; else actual_feedout-=amount;
215 		Transfer(this,aggregate,amount);
216 	}
217 	function doBalance(address requester) {		
218 		updateWithMPO();
219 		if(autobalancepeers) {
220 			if((actual_feedin>0)||(actual_feedout>0)) {
221 				// Prevent Loop Condition!
222 				
223 			}				
224 		}
225 		GridMember peer = GridMember(requester);		
226 		
227 		if(feedin==peer.feedin()) return;
228 		uint256 peer_allowance = peer.allowance(this);
229 		uint256 balance_amount=0;
230 		//
231 		if(feedin) { balance_amount=actual_feedin; } else { balance_amount=actual_feedout; }
232 		if(peer_allowance<balance_amount) { balance_amount=peer_allowance; }		
233 		if(balanceOf[this]<balance_amount) balance_amount=balanceOf[this];	
234 		
235 		if((peer.managedbalance()-peer.balanceOf(requester))+peer.getActual()<balance_amount) balance_amount=(peer.managedbalance()-peer.balanceOf(requester))+peer.getActual();
236 		
237 		if(balance_amount>0) {
238 			balanceOf[this]-=balance_amount;
239 			balanceOf[requester]+=balance_amount;
240 			Transfer(this,requester,balance_amount);
241 			if(feedin) { actual_feedin-=balance_amount; 						
242 					   } else { actual_feedout-=balance_amount; }
243 			peer.receiveTransfer(balance_amount);
244 		}		
245 	}
246 
247 	
248 	function transfer(address _to, uint256 _value) {
249 		/* Function stub required to see tokens in wallet */		
250         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
251     }
252    
253 }
254 
255 
256 contract Aggregation {
257 	address public owner;
258 	address[] public members;
259 	uint256 public actual_feedin;
260 	uint256 public actual_feedout;
261 	uint256 public balance_in;
262 	uint256 public balance_out;
263 	uint256 public last_balance;
264 	uint256 public next_balance;
265 	string public name="Aggregation";
266 	string public symbol="Wh";
267 	mapping (address => uint256) public balanceOf;
268 	mapping (address => uint256) public lastbalancing;
269 	
270 	event Transfer(address indexed from, address indexed to, uint256 value);
271 	function Aggregation() {
272 		owner=msg.sender;
273 		next_balance=now+3600;
274 	}
275 	
276 	function addGridMember(address gridmember) {
277 		if(msg.sender!=owner) throw;
278 	
279 		members.push(gridmember);
280 	}
281 	function transfer(address _to, uint256 _value) {
282 		/* Function stub required to see tokens in wallet */		
283         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
284     }
285 	
286 	function doBalanceFor(address a) {
287 		bool found=false;
288 		for(var i=0;i<members.length;i++) {
289 			if(members[i]==a) found=true; 
290 		}
291 		if(!found) throw;
292 		
293 		GridMember g = GridMember(a);
294 		actual_feedin+=g.actual_feedin();
295 		actual_feedout+=g.actual_feedout();
296 		// as a member is either feeder or consumer this is not dangerous... :)
297 
298 		g.sendToAggregation(g.actual_feedin()+g.actual_feedout());
299 		lastbalancing[a]=now;
300 		
301 	}	
302 	function doBalance() {
303 		if(now<next_balance) throw;
304 		for(var i=0;i<members.length;i++) {
305 			doBalanceFor(members[i]);			
306 		}
307 		next_balance=now+3600;
308 	}
309 }
310 // Aggregation Testnet: 0x70F24857194520Fd70a788C6a9D9638bA44a0B85