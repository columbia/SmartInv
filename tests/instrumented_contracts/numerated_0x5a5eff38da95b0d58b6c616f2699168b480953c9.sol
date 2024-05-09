1 // A life-log, done for Charlyn Greeff, born 18 April 2016 @ 15h30 (1460993400)
2 //    Mother: Mirana Hotz, 16 December 1977 (251078400)
3 //    Father: Jaco Greeff, 11 June 1973 (108604800)
4 //
5 // version: 1.0.0
6 // source: https://github.com/jacogr/ethcontracts/tree/master/src/LifeLog
7 
8 contract CharlyLifeLog {
9   // allow a maximum 20% withdrawal at any time
10   uint private constant MAX_WITHDRAW_DIV = 5; // 100/20
11 
12   // allow one withdrawal every 6 months/180 days
13   uint private constant WITHDRAW_INTERVAL = 180 days;
14 
15   // all the actual events that can be created
16   event LogDonation(address indexed by, uint loggedAt, uint amount);
17   event LogWithdrawal(address indexed by, uint loggedAt, uint amount);
18   event LogPersonNew(address indexed by, uint loggedAt, uint index);
19   event LogPersonUpdate(address indexed by, uint loggedAt, uint index, string field);
20   event LogWhitelistAdd(address indexed by, uint loggedAt, address addr);
21   event LogWhitelistRemove(address indexed by, uint loggedAt);
22   event LogEvent(address indexed by, uint loggedAt, uint when, string description);
23 
24   // a structure describing a person
25   struct Person {
26     bool active;
27     uint activatedAt;
28     uint deactivatedAt;
29     int dateOfBirth;
30     int dateOfDeath;
31     string name;
32     string relation;
33   }
34 
35   // next time whitelist address is allowed to get some funds
36   uint public nextWithdrawal = now + WITHDRAW_INTERVAL;
37 
38   // totals of received and withdrawn amounts
39   uint public totalDonated = 0;
40   uint public totalWithdrawn = 0;
41 
42   // people in the life of ([0] == 'self')
43   Person[] public people;
44 
45   // donations received
46   mapping(address => uint) public donations;
47 
48   // whitelisted modifier accounts
49   mapping(address => bool) public whitelist;
50 
51   // modifier to allow only the whitelisted addresses
52   modifier isOnWhitelist {
53     // if not in the whitelist, throw error
54     if (!whitelist[msg.sender]) {
55       throw;
56     }
57 
58     // if any value attached, don't accept it
59     if (msg.value > 0) {
60       throw;
61     }
62 
63     // original code executes in here
64     _
65   }
66 
67   // construct a lifelog for this specific person
68   function CharlyLifeLog(string name, int dateOfBirth) {
69     // creator should go on the whitelist
70     whitelist[msg.sender] = true;
71 
72     // add the first person
73     personAdd(name, dateOfBirth, 0, 'self');
74 
75     // any donations?
76     if (msg.value > 0) {
77       donate();
78     }
79   }
80 
81   // log an event
82   function log(string description, uint _when) public isOnWhitelist {
83     // infer timestamp or use specified
84     uint when = _when;
85     if (when == 0) {
86       when = now;
87     }
88 
89     // create the event
90     LogEvent(msg.sender, now, when, description);
91   }
92 
93   // add a specific person
94   function personAdd(string name, int dateOfBirth, int dateOfDeath, string relation) public isOnWhitelist {
95     // create the event
96     LogPersonNew(msg.sender, now, people.length);
97 
98     // add the person
99     people.push(
100       Person({
101         active: true,
102         activatedAt: now,
103         deactivatedAt: 0,
104         dateOfBirth: dateOfBirth,
105         dateOfDeath: dateOfDeath,
106         name: name,
107         relation: relation
108       })
109     );
110   }
111 
112   // activate/deactivate a specific person
113   function personUpdateActivity(uint index, bool active) public isOnWhitelist {
114     // set the flag
115     people[index].active = active;
116 
117     // activate/deactivate
118     if (active) {
119       // create the event
120       LogPersonUpdate(msg.sender, now, index, 'active');
121 
122       // make it so
123       people[index].activatedAt = now;
124       people[index].deactivatedAt = 0;
125     } else {
126       // create the event
127       LogPersonUpdate(msg.sender, now, index, 'inactive');
128 
129       // make it so
130       people[index].deactivatedAt = now;
131     }
132   }
133 
134   // update a person's name
135   function personUpdateName(uint index, string name) public isOnWhitelist {
136     // create the event
137     LogPersonUpdate(msg.sender, now, index, 'name');
138 
139     // update
140     people[index].name = name;
141   }
142 
143   // update a person's relation
144   function personUpdateRelation(uint index, string relation) public isOnWhitelist {
145     // create the event
146     LogPersonUpdate(msg.sender, now, index, 'relation');
147 
148     // update
149     people[index].relation = relation;
150   }
151 
152   // update a person's DOB
153   function personUpdateDOB(uint index, int dateOfBirth) public isOnWhitelist {
154     // create the event
155     LogPersonUpdate(msg.sender, now, index, 'dateOfBirth');
156 
157     // update
158     people[index].dateOfBirth = dateOfBirth;
159   }
160 
161   // update a person's DOD
162   function personUpdateDOD(uint index, int dateOfDeath) public isOnWhitelist {
163     // create the event
164     LogPersonUpdate(msg.sender, now, index, 'dateOfDeath');
165 
166     // update
167     people[index].dateOfDeath = dateOfDeath;
168   }
169 
170   // add a whitelist address
171   function whitelistAdd(address addr) public isOnWhitelist {
172     // create the event
173     LogWhitelistAdd(msg.sender, now, addr);
174 
175     // update
176     whitelist[addr] = true;
177   }
178 
179   // remove a whitelist address
180   function whitelistRemove(address addr) public isOnWhitelist {
181     // we can only remove ourselves, double-validate failsafe
182     if (msg.sender != addr) {
183       throw;
184     }
185 
186     // create the event
187     LogWhitelistRemove(msg.sender, now);
188 
189     // remove
190     whitelist[msg.sender] = false;
191   }
192 
193   // withdraw funds as/when needed
194   function withdraw(uint amount) public isOnWhitelist {
195     // the maximum we are allowed to take out right now
196     uint max = this.balance / MAX_WITHDRAW_DIV;
197 
198     // see that we are in range and the timing matches
199     if (amount > max || now < nextWithdrawal) {
200       throw;
201     }
202 
203     // update the event log with the action
204     LogWithdrawal(msg.sender, now, amount);
205 
206     // set the next withdrawal date/time & totals
207     nextWithdrawal = now + WITHDRAW_INTERVAL;
208     totalWithdrawn += amount;
209 
210     // send and throw if not ok
211     if (!msg.sender.send(amount)) {
212       throw;
213     }
214   }
215 
216   // accept donations from anywhere and give credit
217   function donate() public {
218     // there needs to be something here
219     if (msg.value == 0) {
220       throw;
221     }
222 
223     // update the event log with the action
224     LogDonation(msg.sender, now, msg.value);
225 
226     // store the donation
227     donations[msg.sender] += msg.value;
228     totalDonated += msg.value;
229   }
230 
231   // fallback is a donation
232   function() public {
233     donate();
234   }
235 }