1 pragma solidity ^0.4.3;
2 contract Game{
3     //创建者
4     address founder;
5 
6     uint betPhase=6;
7 
8     uint commitPhase=6;
9 
10     uint openPhase=6;
11 
12     uint minValue=0.1 ether;
13 
14 
15 
16     uint refund=90;
17 
18     bool finished=true;
19 
20     uint startBlock;
21 
22     uint id=0;
23 
24     struct Participant{
25         bytes32 hash;
26         bytes32 origin;
27         uint value;
28         bool committed;
29         bool returned;
30     }
31 
32 
33 
34 
35     struct Bet{
36         uint betPhase;
37         uint commitPhase;
38         uint openPhase;
39         uint minValue;
40 
41         mapping(address=>Participant) participants;
42         address[] keys;
43         uint totalValue;
44         uint valiadValue;
45         uint validUsers;
46         bytes32 luckNumber;
47         address lucky;
48         bool prized;
49         uint refund;
50     }
51 
52     mapping(uint=>Bet) games;
53 
54 
55     modifier checkGameFinish(){
56         if(finished){
57             throw;
58         }
59         _;
60     }
61 
62     modifier checkFounder(){
63         if(msg.sender!=founder){
64             throw;
65         }
66         _;
67     }
68 
69     modifier checkPrized(uint id){
70         if(games[id].prized){
71             throw;
72         }
73         _;
74     }
75 
76     modifier checkFihished(){
77         if(!finished){
78             throw;
79         }
80         _;
81     }
82 
83     modifier checkId(uint i){
84         if(id!=i){
85             throw;
86         }
87         _;
88     }
89 
90     modifier checkValue(uint value){
91         if(value<minValue){
92             throw;
93         }
94         _;
95     }
96 
97     modifier checkBetPhase(){
98         if(block.number>startBlock+betPhase){
99             throw;
100         }
101         _;
102     }
103 
104     modifier checkCommitPhase(){
105         if(block.number>startBlock+betPhase+commitPhase){
106             throw;
107         }
108         _;
109     }
110 
111     modifier checkOpen(){
112         if(block.number<startBlock+betPhase+commitPhase){
113             throw;
114         }
115         _;
116     }
117 
118     modifier checkUser(address user,uint id){
119         if(games[id].participants[user].hash==""){
120             throw;
121         }
122         _;
123     }
124 
125     modifier checkRegister(uint id,address user){
126         if(games[id].participants[user].hash!=""){
127             throw;
128         }
129         _;
130     }
131 
132     function Game() public{
133         founder=msg.sender;
134     }
135 
136     event StartGame(uint indexed id,uint betPhase,uint commitPhase,uint openPhase,uint betValue,uint refund,uint startBlock);
137 
138 
139 
140     function startGame(uint iBetPhase,uint iCommitPhase,uint iOpenPhase,uint betvalue,uint iRefund)
141     checkFounder
142     checkFihished
143     {
144         id+=1;
145         betPhase=iBetPhase;
146         commitPhase=iCommitPhase;
147         openPhase=iOpenPhase;
148         minValue=(betvalue*1 ether)/100;
149         finished=false;
150         startBlock=block.number;
151         refund=iRefund;
152         StartGame(id,betPhase,commitPhase,openPhase,minValue,refund,startBlock);
153     }
154 
155     // current total value,hash,id,sid
156     event Play(uint indexed value,bytes32 hash,uint id,bytes32 sid,address player);
157 
158     function play(uint id,bytes32 hash,bytes32 sid) public payable
159     checkValue(msg.value)
160     checkBetPhase
161     checkId(id)
162     checkRegister(id,msg.sender)
163     {
164         address user=msg.sender;
165         Bet memory tmp=games[id];
166         Participant memory participant=Participant({hash:hash,origin:"",value:msg.value,committed:false,returned:false});
167         uint value;
168         if(tmp.keys.length==0){
169             Bet storage bet=games[id];
170             bet.betPhase=betPhase;
171             bet.commitPhase=commitPhase;
172             bet.openPhase=openPhase;
173             bet.minValue=minValue;
174 
175             bet.keys.push(user);
176             bet.participants[user]=participant;
177             bet.refund=refund;
178             bet.totalValue=msg.value;
179             value=msg.value;
180         }else{
181             games[id].keys.push(user);
182             games[id].participants[user]=participant;
183             games[id].totalValue+=msg.value;
184             value=msg.value;
185         }
186         var num=games[id].keys.length;
187         Play(value,hash,id,sid,msg.sender);
188     }
189     // origin,valid users
190     event CommitOrigin(address indexed user,bytes32 origin,uint num,bytes32 sid,uint id);
191 
192     function commitOrigin(uint id,bytes32 origin,bytes32 sid)
193     checkCommitPhase
194     checkId(id)
195     checkUser(msg.sender,id)
196     {
197         bytes32 hash=games[id].participants[msg.sender].hash;
198         if(sha3(origin)==hash){
199             if(games[id].participants[msg.sender].committed!=true){
200                 games[id].participants[msg.sender].committed=true;
201                 games[id].participants[msg.sender].origin=origin;
202                 games[id].valiadValue+=games[id].participants[msg.sender].value;
203                 games[id].validUsers++;
204                 CommitOrigin(msg.sender,origin,games[id].validUsers,sid,id);
205             }
206 
207         }else{
208             throw;
209         }
210     }
211 
212     function getLuckNumber(Bet storage bet) internal
213     returns(bytes32)
214     {
215         address[] memory users=bet.keys;
216         bytes32 random;
217         for(uint i=0;i<users.length;i++){
218             address key=users[i];
219             Participant memory p=bet.participants[key];
220 
221             if(p.committed==true){
222                 random ^=p.origin;
223             }
224         }
225         return sha3(random);
226     }
227 
228     // lucky user,lucky number,random number,prize
229     event Open(address indexed user,bytes32 random,uint prize,uint id);
230 
231     function open(uint id)
232     checkPrized(id)
233     checkFounder
234     checkOpen
235     checkGameFinish
236     {
237         bytes32 max=0;
238         Bet storage bet=games[id];
239         bytes32 random=getLuckNumber(bet);
240         address tmp;
241         address[] memory users=bet.keys;
242         for(uint i=0;i<users.length;i++){
243 
244             address key=users[i];
245             Participant storage p=bet.participants[key];
246             if(p.committed==true){
247                 bytes32 distance=random^p.origin;
248                 if(distance>max){
249                     max=distance;
250                     tmp=key;
251                 }
252             }else{
253                 if(p.returned==false){
254                     if(key.send(p.value*8/10)){
255                         p.returned=true;
256                     }
257 
258                 }
259             }
260 
261         }
262         bet.lucky=tmp;
263         bet.luckNumber=random;
264         uint prize=bet.valiadValue*refund/100;
265 
266         founder.send((bet.valiadValue-prize));
267         if(tmp.send(prize)){
268             bet.prized=true;
269             Open(tmp,random,prize,id);
270         }
271 
272         finished=true;
273     }
274 
275     function getContractBalance() constant returns(uint){
276         return this.balance;
277     }
278 
279     function withdraw(address user,uint value)
280     checkFounder
281     {
282         user.send(value);
283     }
284 
285     function getPlayerCommitted(uint period,address player) constant returns(bool){
286         Participant memory p=games[period].participants[player];
287         return p.committed;
288     }
289 
290     function getPlayerReturned(uint period,address player) constant returns(bool){
291         Participant memory p=games[period].participants[player];
292         return p.returned;
293     }
294 
295     function getPlayerNum(uint period) constant
296     returns(uint){
297         Bet bet=games[period];
298         return bet.keys.length;
299     }
300 
301     function getPlayerAddress(uint period,uint offset) constant
302     returns(address){
303         Bet bet=games[period];
304         return bet.keys[offset];
305     }
306 
307     function getPlayerOrigin(uint period,uint offset) constant
308     returns(bytes32){
309         Bet bet=games[period];
310         address user=bet.keys[offset];
311         return bet.participants[user].origin;
312     }
313 
314     function getPlayerHash(uint period,uint offset) constant
315     returns(bytes32){
316         Bet bet=games[period];
317         address user=bet.keys[offset];
318         return bet.participants[user].hash;
319     }
320 
321     function getPlayerValue(uint period,uint offset) constant
322     returns(uint){
323         Bet bet=games[period];
324         address user=bet.keys[offset];
325         return bet.participants[user].value;
326     }
327 
328     // public getRandom(uint id) constant{
329 
330     // }
331     function getId() constant returns(uint){
332         return id;
333     }
334 
335     function getRandom(uint id) constant
336     checkId(id)
337     returns(bytes32){
338         return games[id].luckNumber;
339     }
340 
341     function getLuckUser(uint id) constant
342     checkId(id)
343     returns(address){
344         return games[id].lucky;
345     }
346 
347     function getPrizeAmount(uint id) constant
348     checkId(id)
349     returns(uint){
350         return games[id].totalValue;
351     }
352 
353     function getMinAmount(uint id) constant
354     checkId(id)
355     returns(uint)
356     {
357         return minValue;
358     }
359 
360     function getsha3(bytes32 x) constant
361     returns(bytes32){
362         return sha3(x);
363     }
364 
365     function getGamePeriod() constant
366     returns(uint){
367         return id;
368     }
369 
370 
371     function getStartBlock() constant
372     returns(uint){
373         return startBlock;
374     }
375 
376     function getBetPhase() constant
377     returns(uint){
378         return betPhase;
379     }
380 
381     function getCommitPhase() constant
382     returns(uint){
383         return commitPhase;
384     }
385 
386     function getFinished() constant
387     returns(bool){
388         return finished;
389     }
390 
391 }