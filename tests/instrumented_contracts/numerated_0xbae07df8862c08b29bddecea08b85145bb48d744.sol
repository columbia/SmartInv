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
48 		addOption("NN",address(0x9707F3C9ca3C554A6E6d31B71A3C03d7017063F4),2);
49 		setDAO(address(0x683c53084d997e6056c555f85f031f8317e26c2b));		
50 		vote_until=now+(86400*1);
51 		request_until=now+(86400*100);		
52 	}
53 	
54 	function setDescription(string _description) {
55 		if(voting_started) throw;
56 		description=_description;		
57 	}
58 	
59 	function setDAO(address _dao) {
60 		if(msg.sender!=creator) throw;
61 		if(voting_started) throw;
62  		if(dao!=0) throw;
63 		MicroDAO d = MicroDAO(_dao);
64 		if(d.balanceOf(creator)<1) throw;
65 		dao=_dao;		
66 	}
67 	
68 	function execute(){
69 		result_payto=options[0].payout_to;
70 		result_amount=options[0].eth_amount;
71 		executed=false;		
72 	}
73 	
74 	function vote(uint256 option,bool veto) {		
75 		if(voted[msg.sender]) throw;
76 		if(now<vote_until) throw;
77 		voting_started=true;
78 		MicroDAO d = MicroDAO(dao);
79 		if(!veto) options[option].votes_pro+=d.balanceOf(msg.sender);	else options[option].votes_veto+=d.balanceOf(msg.sender);
80 		
81 		d.blockTransfer(msg.sender,vote_until);
82 	}
83 	function setRequestUntil(uint8 days_from_now) {
84 		if(msg.sender!=creator) throw;
85 		if(voting_started) throw;
86 		request_until=now+(86400*days_from_now);		
87 	}
88 	function setVotetUntil(uint8 days_from_now) {
89 		if(msg.sender!=creator) throw;
90 		if(voting_started) throw;
91 		vote_until=now+(86400*days_from_now);		
92 	}
93 	function addOption(string _description,address _payout_to,uint256 _amount) {
94 		if(msg.sender!=creator) throw;
95 		if(voting_started) throw;
96 		options.push(option(_description,_payout_to,_amount,0,0));
97 	}	
98 }
99 contract MicroDAO
100 {
101 	string public directorNode;
102 	address public director;
103 	string public directorName;
104 	string public directorJurisdication;
105 	bool public initialFunding;	
106 	uint256 public sharesRaised;
107 	uint public lockInDays;	
108 	string public name ="MicroDAO";
109 	string public symbol ="E/";
110 	uint256 public fundingGoal;
111 	uint256 public balanceFinney;
112 	uint256 public directorLockUntil;
113 	uint256 public directorLockDays;
114 	uint256 public directorTransferShareRequired;
115 	mapping (address => uint256) public balanceOf;		
116 	mapping (address => uint256) public fundsExpire;
117 	mapping (address => uint256) public blockedtransfer;
118 	
119 	
120 	address[] public funders;
121 	SpendingRequest[]  public allowances;
122 	struct booking {
123 		uint256 time;
124 		uint256 funding;
125 		uint256 spending;
126 		address counterpart;
127 		string text;
128 	}
129 	booking[] public bookings;
130 	
131 	event Transfer(address indexed from, address indexed to, uint256 value);
132 	
133 	function MicroDAO() {
134 		initialFunding=true;
135 		director=msg.sender;	
136 		directorLockUntil=now+(86400*30);		
137 	}
138 	function setDirectorNode(string node) {
139 		if(msg.sender!=director) throw;
140 		directorNode=node;
141 		directorLockUntil=now+(86400*directorLockDays);
142 	} 
143 	
144 	function blockTransfer(address a,uint256 until) {
145 		bool found=false;
146 		for(var i=0;((i<allowances.length)&&(found==false));i++) {
147 			if(allowances[i]==msg.sender) found=true;
148 		}
149 		if(found) {
150 			if(blockedtransfer[a]>until) {
151 				blockedtransfer[a]=until;
152 			}
153 		}
154 	}
155 	
156 	function setDirectorLock(uint256 number_of_days,uint256 requiredShares) {
157 		if(msg.sender!=director) throw; 
158 		if(requiredShares>sharesRaised) throw;
159 		if(number_of_days>365) number_of_days=365;
160 		
161 		
162 		directorLockDays=number_of_days;
163 		directorTransferShareRequired=requiredShares;
164 	}
165 	
166 	function transferDirector(address director) {
167 		// Dead Director check ...		
168 		if(msg.sender==director) {
169 			director=director;
170 			directorName="";
171 			directorJurisdication="";
172 			initialFunding=true;
173 		} else if((now>directorLockUntil)&&(balanceOf[msg.sender]>directorTransferShareRequired)) {
174 			director=msg.sender;
175 			directorName="";
176 			directorJurisdication="";
177 			initialFunding=true;
178 		}
179 	}
180 	function setdirectorName(string name) {
181 		if(msg.sender!=director) throw;
182 		if(!initialFunding) throw;
183 		directorName=name;
184 	}
185 	
186 	function setFundingGoal(uint256 goal) {
187 		if(msg.sender!=director) throw;
188 		fundingGoal=goal;
189 	}
190 	
191 	function setInitialLockinDays(uint number_of_days) {
192 		if(msg.sender!=director) throw;
193 		lockInDays=number_of_days;
194 	}
195 	
196 	
197 	function setJurisdication(string juri) {
198 		if(msg.sender!=director) throw;
199 		if(!initialFunding) throw;
200 		directorJurisdication=juri;
201 	}
202 	
203 	function addSpendingRequest(address spendingRequest) {
204 		if(msg.sender!=director) throw;	
205 		SpendingRequest s = SpendingRequest(spendingRequest);		
206 		if(s.executed()) throw;
207 		if(s.vote_until()<now) throw; 
208 		allowances.push(s);		
209 	}
210 	
211 	function executeSpendingRequests() {
212 		for(var i=0;i<allowances.length;i++) {
213 			SpendingRequest s =SpendingRequest(allowances[i]);
214 			if(!s.executed()) {
215 				if((s.vote_until()<now)&&(s.request_until()>now)) {
216 					s.execute();
217 					directorLockUntil=now+(86400*directorLockDays);
218 					if(s.result_amount()>0) {
219 						if(s.result_payto()!=0) {
220 							s.result_payto().send(s.result_amount()*1 ether);
221 							bookings.push(booking(now,0,s.result_amount()*1 ether,s.result_payto(),"Executed SpendingRequest"));
222 						}
223 					}
224 				}
225 			}
226 		}
227 	}
228 	
229 	function myFundsExpireIn(uint256 number_of_days) {
230 		var exp=now+(86400*number_of_days);
231 		if(exp>fundsExpire[msg.sender]) fundsExpire[msg.sender]=exp; else throw;
232 	}
233 		
234 	function closeFunding() {
235 		if(msg.sender!=director) throw;
236 		initialFunding=false;		
237 		checkExpiredfunds();		
238 	}
239 	
240 	function checkExpiredfunds() {
241 		if(!initialFunding) return;
242 		for(var i=0;i<funders.length;i++) {
243 			if((fundsExpire[funders[i]]>0)&&((fundsExpire[funders[i]]<now))) {
244 				var amount=balanceOf[funders[i]]*1 finney;				
245 				Transfer(funders[i],this,balanceOf[funders[i]]);
246 				sharesRaised-=balanceOf[funders[i]];
247 				balanceOf[funders[i]]=0;
248 				funders[i].send(amount);				
249 			}
250 		}
251 	}
252 	
253 	function transfer(address _to, uint256 _value) {
254 		if(blockedtransfer[msg.sender]>now) throw;
255 		if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
256         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
257         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
258         balanceOf[_to] += _value;                            // Add the same to the recipient
259 		if(balanceOf[_to]==0) {
260 			funders.push(_to);
261 		}
262         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
263     }
264 	
265 	function() {	
266 		 var funding_type="Incomming";			
267 			var finneys=msg.value/1 finney;
268 			if(initialFunding) {
269 				
270 				if(balanceOf[msg.sender]==0) {
271 					funders.push(msg.sender);
272 				}		
273 				if(msg.value<100 finney) throw;
274 				
275 				fundsExpire[msg.sender]=now+(lockInDays*86400);
276 				balanceOf[msg.sender]+=finneys;
277 				Transfer(this,msg.sender,finneys);
278 				sharesRaised+=finneys;
279 				funding_type="Initial Funding";
280 			}
281 			bookings.push(booking(now,msg.value,0,msg.sender,funding_type));
282 			balanceFinney=this.balance/1 finney;
283 	}
284 }