1 /* 
2 MicroDAO V0.0.2 - <me@thorsten-zoerner.com>
3 ===========================================================
4 Simplified DAO allowing to do initial funding.
5 - Funders are able to specify how long to keep funds in.
6 - If funding is not closed by this time fundes returned
7 - Close funding is a manual taken by the director
8 
9 Single Director
10 - Has the possibility to file SpendingRequest
11 - allowed to change fundamental parameters
12 - allowed to move directorship forward
13 - deadman switch prevents lost DAO.
14 
15 Each Spending needs to be approved by share holders (Vote)
16 - spendings have a time to vote
17 - spendings require to be executed in a given number of days
18 
19 - Checked for recursive withdraw bug (DAO Hack) 
20 */
21 
22 contract SpendingRequest {
23 	string public name="SpendingRequest 4 MicroDAO";
24 	 address public creator;
25 	 string public description;
26 	 uint256 public request_until;
27 	 uint256 public vote_until;
28 		
29 	 option[] public  options;
30  	 address public dao;
31 	 mapping(address=>bool) public voted;
32 	 bool public voting_started;
33 	 bool public executed;
34 	 address public result_payto;
35 	 uint256 public result_amount;
36 	 uint256 public result_votes;
37 	
38 	struct option {
39 		string description;
40 		address payout_to;
41 		uint256 eth_amount;		
42 		uint256 votes_pro;
43 		uint256 votes_veto;
44 	}
45 	
46 	function SpendingRequest () {
47 		creator=msg.sender;
48 	}
49 	
50 	function setDescription(string _description) {
51 		if(voting_started) throw;
52 		description=_description;		
53 	}
54 	
55 	function setDAO(address _dao) {
56 		if(msg.sender!=creator) throw;
57 		if(voting_started) throw;
58  		if(dao!=0) throw;
59 		MicroDAO d = MicroDAO(_dao);
60 		if(d.balanceOf(creator)<1) throw;
61 		dao=_dao;		
62 	}
63 	
64 	function execute(){
65 		if(vote_until>now) return;
66 		if(request_until<now) return;
67 		if((msg.sender!=dao)&&(msg.sender!=creator)) throw;
68 		for(var i=0;i<options.length;i++) {
69 			if(options[i].votes_pro-options[i].votes_veto>result_votes) {
70 				result_payto=options[i].payout_to;
71 				result_amount=options[i].eth_amount;
72 				if(options[i].votes_veto>options[i].votes_pro) result_votes=0; else 
73 				result_votes=options[i].votes_pro-options[i].votes_veto;
74 			}
75 		}
76 		executed=true;		
77 	}
78 	
79 	function vote(uint256 option,bool veto) {		
80 		if(voted[msg.sender]) throw;
81 		if(now<vote_until) throw;
82 		voting_started=true;
83 		MicroDAO d = MicroDAO(dao);
84 		if(!veto) options[option].votes_pro+=d.balanceOf(msg.sender);	else options[option].votes_veto+=d.balanceOf(msg.sender);
85 		
86 		d.blockTransfer(msg.sender,vote_until);
87 	}
88 	function setRequestUntil(uint8 days_from_now) {
89 		if(msg.sender!=creator) throw;
90 		if(voting_started) throw;
91 		request_until=now+(86400*days_from_now);		
92 	}
93 	function setVotetUntil(uint8 days_from_now) {
94 		if(msg.sender!=creator) throw;
95 		if(voting_started) throw;
96 		vote_until=now+(86400*days_from_now);		
97 	}
98 	function addOption(string _description,address _payout_to,uint256 _amount) {
99 		if(msg.sender!=creator) throw;
100 		if(voting_started) throw;
101 		options.push(option(_description,_payout_to,_amount,0,0));
102 	}	
103 }
104 contract MicroDAO
105 {
106 	string public directorNode;
107 	address public director;
108 	string public directorName;
109 	string public directorJurisdication;
110 	bool public initialFunding;	
111 	uint256 public sharesRaised;
112 	uint public lockInDays;	
113 	string public name ="MicroDAO";
114 	string public symbol ="E/";
115 	uint256 public fundingGoal;
116 	uint256 public balanceFinney;
117 	uint256 public directorLockUntil;
118 	uint256 public directorLockDays;
119 	uint256 public directorTransferShareRequired;
120 	mapping (address => uint256) public balanceOf;		
121 	mapping (address => uint256) public fundsExpire;
122 	mapping (address => uint256) public blockedtransfer;
123 	
124 	
125 	address[] public funders;
126 	SpendingRequest[]  public allowances;
127 	struct booking {
128 		uint256 time;
129 		uint256 funding;
130 		uint256 spending;
131 		address counterpart;
132 		string text;
133 	}
134 	booking[] public bookings;
135 	
136 	event Transfer(address indexed from, address indexed to, uint256 value);
137 	
138 	function MicroDAO() {
139 		initialFunding=true;
140 		director=msg.sender;	
141 		directorLockUntil=now+(86400*30);		
142 	}
143 	function setDirectorNode(string node) {
144 		if(msg.sender!=director) throw;
145 		directorNode=node;
146 		directorLockUntil=now+(86400*directorLockDays);
147 	} 
148 	
149 	function blockTransfer(address a,uint256 until) {
150 		bool found=false;
151 		for(var i=0;((i<allowances.length)&&(found==false));i++) {
152 			if(allowances[i]==msg.sender) found=true;
153 		}
154 		if(found) {
155 			if(blockedtransfer[a]>until) {
156 				blockedtransfer[a]=until;
157 			}
158 		}
159 	}
160 	
161 	function setDirectorLock(uint256 number_of_days,uint256 requiredShares) {
162 		if(msg.sender!=director) throw; 
163 		if(requiredShares>sharesRaised) throw;
164 		if(number_of_days>365) number_of_days=365;
165 		
166 		
167 		directorLockDays=number_of_days;
168 		directorTransferShareRequired=requiredShares;
169 	}
170 	
171 	function transferDirector(address director) {
172 		// Dead Director check ...		
173 		if(msg.sender==director) {
174 			director=director;
175 			directorName="";
176 			directorJurisdication="";
177 			initialFunding=true;
178 		} else if((now>directorLockUntil)&&(balanceOf[msg.sender]>directorTransferShareRequired)) {
179 			director=msg.sender;
180 			directorName="";
181 			directorJurisdication="";
182 			initialFunding=true;
183 		}
184 	}
185 	function setdirectorName(string name) {
186 		if(msg.sender!=director) throw;
187 		if(!initialFunding) throw;
188 		directorName=name;
189 	}
190 	
191 	function setFundingGoal(uint256 goal) {
192 		if(msg.sender!=director) throw;
193 		fundingGoal=goal;
194 	}
195 	
196 	function setInitialLockinDays(uint number_of_days) {
197 		if(msg.sender!=director) throw;
198 		lockInDays=number_of_days;
199 	}
200 	
201 	
202 	function setJurisdication(string juri) {
203 		if(msg.sender!=director) throw;
204 		if(!initialFunding) throw;
205 		directorJurisdication=juri;
206 	}
207 	
208 	function addSpendingRequest(address spendingRequest) {
209 		if(msg.sender!=director) throw;	
210 		SpendingRequest s = SpendingRequest(spendingRequest);		
211 		if(s.executed()) throw;
212 		if(s.vote_until()<now) throw; 
213 		allowances.push(s);		
214 	}
215 	
216 	function executeSpendingRequests() {
217 		for(var i=0;i<allowances.length;i++) {
218 			SpendingRequest s =SpendingRequest(allowances[i]);
219 			if(!s.executed()) {
220 				if((s.vote_until()<now)&&(s.request_until()>now)) {
221 					s.execute();
222 					directorLockUntil=now+(86400*directorLockDays);
223 					if(s.result_amount()>0) {
224 						if(s.result_payto()!=0) {
225 							s.result_payto().send(s.result_amount()*1 ether);
226 							bookings.push(booking(now,0,s.result_amount()*1 ether,s.result_payto(),"Executed SpendingRequest"));
227 						}
228 					}
229 				}
230 			}
231 		}
232 	}
233 	
234 	function myFundsExpireIn(uint256 number_of_days) {
235 		var exp=now+(86400*number_of_days);
236 		if(exp>fundsExpire[msg.sender]) fundsExpire[msg.sender]=exp; else throw;
237 	}
238 		
239 	function closeFunding() {
240 		if(msg.sender!=director) throw;
241 		initialFunding=false;		
242 		checkExpiredfunds();		
243 	}
244 	
245 	function checkExpiredfunds() {
246 		if(!initialFunding) return;
247 		for(var i=0;i<funders.length;i++) {
248 			if((fundsExpire[funders[i]]>0)&&((fundsExpire[funders[i]]<now))) {
249 				var amount=balanceOf[funders[i]]*1 finney;				
250 				Transfer(funders[i],this,balanceOf[funders[i]]);
251 				sharesRaised-=balanceOf[funders[i]];
252 				balanceOf[funders[i]]=0;
253 				funders[i].send(amount);				
254 			}
255 		}
256 	}
257 	
258 	function transfer(address _to, uint256 _value) {
259 		if(blockedtransfer[msg.sender]>now) throw;
260 		if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
261         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
262         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
263         balanceOf[_to] += _value;                            // Add the same to the recipient
264 		if(balanceOf[_to]==0) {
265 			funders.push(_to);
266 		}
267         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
268     }
269 	
270 	function() {	
271 		 var funding_type="Incomming";			
272 			var finneys=msg.value/1 finney;
273 			if(initialFunding) {
274 				
275 				if(balanceOf[msg.sender]==0) {
276 					funders.push(msg.sender);
277 				}		
278 				if(msg.value<100 finney) throw;
279 				
280 				fundsExpire[msg.sender]=now+(lockInDays*86400);
281 				balanceOf[msg.sender]+=finneys;
282 				Transfer(this,msg.sender,finneys);
283 				sharesRaised+=finneys;
284 				funding_type="Initial Funding";
285 			}
286 			bookings.push(booking(now,msg.value,0,msg.sender,funding_type));
287 			balanceFinney=this.balance/1 finney;
288 	}
289 }