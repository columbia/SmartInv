1 pragma solidity ^0.5.1;
2 
3 contract NIOXToken {
4     uint256 public peopleCount = 0;
5     
6     mapping(address => Person ) public people;
7     
8     uint256 constant stage11 = 1584016200; // ---- Thursday, March 12, 2020 6:00:00 PM GMT+05:30
9     uint256 constant stage12 = 1591964999; // ---- Friday, June 12, 2020 5:59:59 PM GMT+05:30
10     uint256 constant stage21 = 1591965000; // ---- Friday, June 12, 2020 6:00:00 PM GMT+05:30
11     uint256 constant stage22 = 1597235399; // ---- Wednesday, August 12, 2020 5:59:59 PM GMT+05:30
12     uint256 constant stage31 = 1597235400; // ---- Wednesday, August 12, 2020 6:00:00 PM GMT+05:30
13     uint256 constant stage32 = 1599913799; // ---- Saturday, September 12, 2020 5:59:59 PM GMT+05:30
14     
15    uint256 constant oneyear = 31556926; // 31556926 secs = 1 YEAR
16     
17     
18     uint256 constant sixmonth = 15778458; // 6 month
19 
20     
21     uint256 constant addAddressLastDate = 1588163399;// Wednesday, April 29, 2020 5:59:59 PM GMT+05:30
22     
23    uint256 constant minStakeAmt = 3000000000;
24 
25     
26     // Status of user's address that he has withdrew NIOX or staked or haven't decided yet
27     enum userState {Withdraw, Staked, NotDecided}
28     
29     // Status of user's address after claiming their tokens
30     enum withdrawState {NotWithdraw, PartiallyWithdraw, FullyWithdraw}
31     
32     //users remaining claimed tokens
33     enum remainToken {stage0, stage1, stage2, stage3, stage4}
34     
35     // Token name
36     string public constant name = "Autonio";
37 
38     // Token symbol
39     string public constant symbol = "NIOX";
40 
41 	// Token decimals
42     uint8 public constant decimals = 4;
43     
44     // Contract owner will be your Link account
45     address public owner;
46 
47     address public treasury;
48 
49     uint256 public totalSupply;
50 
51     mapping (address => mapping (address => uint256)) private allowed;
52     mapping (address => uint256) private balances;
53 
54     event Approval(address indexed tokenholder, address indexed spender, uint256 value);
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event AddedNewUser(address indexed, uint _value);
58 
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }   
63 
64     modifier checkUser() {
65         require(msg.sender == people[msg.sender]._address);
66         _;
67     }
68 
69     struct Person {
70         uint _id;
71         address _address;
72         uint256 _value;
73         uint256 _txHashAddress;
74         userState _userState;
75         withdrawState _withdrawState;
76         remainToken _remainToken;
77         uint256 _blocktimestamp;
78         uint256 _userStateBlocktimestamp;
79     }
80 
81     constructor() public {
82         owner = msg.sender;
83 
84         // Add your wallet address here which will contain your total token supply
85         treasury = owner;
86 
87         // Set your total token supply (default 1000)
88         totalSupply = 3000000000000;
89 
90         balances[treasury] = totalSupply;
91         emit Transfer(address(0), treasury, totalSupply);
92     }
93 
94     function () external payable {
95         revert();
96     }
97 
98     function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {
99         return allowed[_tokenholder][_spender];
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool) {
103         require(_spender != address(0));
104         require(_spender != msg.sender);
105 
106         allowed[msg.sender][_spender] = _value;
107 
108         emit Approval(msg.sender, _spender, _value);
109 
110         return true;
111     }
112 
113     function balanceOf(address _tokenholder) public view returns (uint256 balance) {
114         return balances[_tokenholder];
115     }
116 
117     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
118         require(_spender != address(0));
119         require(_spender != msg.sender);
120 
121         if (allowed[msg.sender][_spender] <= _subtractedValue) {
122             allowed[msg.sender][_spender] = 0;
123         } else {
124             allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;
125         }
126 
127         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128 
129         return true;
130     }
131 
132     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
133         require(_spender != address(0));
134         require(_spender != msg.sender);
135         require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);
136 
137         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
138 
139         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140 
141         return true;
142     }
143 
144     function transfer(address _to, uint256 _value) public returns (bool) {
145         require(_to != msg.sender);
146         require(_to != address(0));
147         require(_to != address(this));
148         require(balances[msg.sender] - _value <= balances[msg.sender]);
149         require(balances[_to] <= balances[_to] + _value);
150         require(_value <= transferableTokens(msg.sender));
151 
152         balances[msg.sender] = balances[msg.sender] - _value;
153         balances[_to] = balances[_to] + _value;
154 
155         emit Transfer(msg.sender, _to, _value);
156 
157         return true;
158     }
159 
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161         require(_from != address(0));
162         require(_from != address(this));
163         require(_to != _from);
164         require(_to != address(0));
165         require(_to != address(this));
166         require(_value <= transferableTokens(_from));
167         require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);
168         require(balances[_from] - _value <= balances[_from]);
169         require(balances[_to] <= balances[_to] + _value);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
171         balances[_from] = balances[_from] - _value;
172         balances[_to] = balances[_to] + _value;
173 
174         emit Transfer(_from, _to, _value);
175 
176         return true;
177     }
178 
179     function transferOwnership(address _newOwner) public {
180         require(msg.sender == owner);
181         require(_newOwner != address(0));
182         require(_newOwner != address(this));
183         require(_newOwner != owner);
184 
185         address previousOwner = owner;
186         owner = _newOwner;
187 
188         emit OwnershipTransferred(previousOwner, _newOwner);
189     }
190 
191     function transferableTokens(address holder) public view returns (uint256) {
192         return balanceOf(holder);
193     }
194     
195     function addAddress(address _useraddress, uint256 _value, uint256 _txHashAddress, userState _userState, withdrawState _withdrawState, remainToken _remainToken) public onlyOwner {
196         
197         require(people[_useraddress]._address != _useraddress);
198         require(block.timestamp <= addAddressLastDate);
199         
200         incrementCount();
201         people[_useraddress] = Person(peopleCount, _useraddress, _value, _txHashAddress, _userState, _withdrawState, _remainToken, block.timestamp, 0);
202     }
203     
204     function incrementCount() internal {
205         peopleCount += 1;
206     }
207     
208     function getRemainTokenCount(address  _address) public view returns (uint256 tokens) {
209         
210         require(_address == people[_address]._address);
211         
212         if(people[_address]._remainToken == remainToken.stage0) {
213             
214             return people[_address]._value;
215         }
216         
217         else if(people[_address]._remainToken == remainToken.stage1) {
218             
219             return people[_address]._value / 100 * 50;
220         }
221         
222         else if(people[_address]._remainToken == remainToken.stage2) {
223             
224             return people[_address]._value / 100 * 30;
225         }
226         
227         else if(people[_address]._remainToken == remainToken.stage3) {
228             
229             return people[_address]._value / 100 * 20;
230         }
231         
232         else if(people[_address]._remainToken == remainToken.stage4) {
233             
234             return 0;
235         }
236     }
237     
238     function getWithdrawTokenCount(address  _address) public view returns (uint256 tokens) {
239         
240         require(_address == people[_address]._address);
241         
242         if(people[_address]._remainToken == remainToken.stage0) {
243             
244             return 0;
245         }
246         
247         else if(people[_address]._remainToken == remainToken.stage1) {
248             
249             return people[_address]._value / 100 * 50;
250         }
251         
252         else if(people[_address]._remainToken == remainToken.stage2) {
253             
254             return people[_address]._value / 100 * 70;
255         }
256         
257         else if(people[_address]._remainToken == remainToken.stage3) {
258             
259             return people[_address]._value / 100 * 80;
260         }
261         
262         else if(people[_address]._remainToken == remainToken.stage4) {
263             
264             return people[_address]._value;
265         }
266     }
267     
268     function getUserState(address _address) public view returns (userState){
269         
270         require(_address == people[_address]._address);
271         
272         return people[_address]._userState;
273     }
274     
275     function withdrawOrStake(userState _userStates) public returns (bool) {
276         
277         require(msg.sender == people[msg.sender]._address);
278         require(people[msg.sender]._userState == userState.NotDecided);
279         require(people[msg.sender]._userStateBlocktimestamp == 0);
280         
281         if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Withdraw){
282             people[msg.sender]._userState = userState.Withdraw;
283             people[msg.sender]._userStateBlocktimestamp = block.timestamp;
284             return true;
285         }
286         else if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Staked && people[msg.sender]._value >= minStakeAmt ){
287             people[msg.sender]._userState = userState.Staked;
288             people[msg.sender]._userStateBlocktimestamp = block.timestamp;
289             return true;
290         }
291         else {
292             return false;
293         }
294         
295     }
296     
297     function changeStakeToWithdraw() public checkUser returns (bool) {
298         
299         require(msg.sender == people[msg.sender]._address);
300         require(people[msg.sender]._userState == userState.Staked);
301         require(people[msg.sender]._userStateBlocktimestamp != 0);
302         require(block.timestamp >= (people[msg.sender]._userStateBlocktimestamp + sixmonth));
303         
304         if(people[msg.sender]._userState == userState.Staked){
305             people[msg.sender]._userState = userState.Withdraw;
306             // people[msg.sender]._blocktimestamp = block.timestamp;
307             return true;
308         }
309         
310     }
311     
312     function withdrawToken() public checkUser returns (bool){
313         
314         require(msg.sender == people[msg.sender]._address);
315         require(people[msg.sender]._userState == userState.Withdraw);
316         require(people[msg.sender]._userStateBlocktimestamp != 0);
317         require(people[msg.sender]._withdrawState == withdrawState.NotWithdraw);
318         require(people[msg.sender]._remainToken == remainToken.stage0);
319         
320         if (block.timestamp >= stage11 && block.timestamp <= stage12 ){
321             
322             uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
323              require(owner != msg.sender);
324              require(balances[owner] - clamimTkn <= balances[owner]);
325              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
326              require(clamimTkn <= transferableTokens(owner));
327         
328             balances[owner] = balances[owner] - clamimTkn;
329             balances[msg.sender] = balances[msg.sender] + clamimTkn;
330     
331             emit Transfer(owner, msg.sender, clamimTkn);
332             
333             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
334             people[msg.sender]._remainToken = remainToken.stage1;
335             people[msg.sender]._blocktimestamp = block.timestamp;
336             
337             return true;
338         }
339         else if (block.timestamp > stage21 && block.timestamp <= stage22 ){
340             
341             uint256 clamimTkn = people[msg.sender]._value / 100 * 70; 
342              require(owner != msg.sender);
343              require(balances[owner] - clamimTkn <= balances[owner]);
344              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
345              require(clamimTkn <= transferableTokens(owner));
346         
347             balances[owner] = balances[owner] - clamimTkn;
348             balances[msg.sender] = balances[msg.sender] + clamimTkn;
349     
350             emit Transfer(owner, msg.sender, clamimTkn);
351             
352             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
353             people[msg.sender]._remainToken = remainToken.stage2;
354             people[msg.sender]._blocktimestamp = block.timestamp;
355             
356             return true;
357         }
358         else if (block.timestamp > stage31 && block.timestamp <= stage32 ){
359             
360             uint256 clamimTkn = people[msg.sender]._value / 100 * 80; 
361              require(owner != msg.sender);
362              require(balances[owner] - clamimTkn <= balances[owner]);
363              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
364              require(clamimTkn <= transferableTokens(owner));
365         
366             balances[owner] = balances[owner] - clamimTkn;
367             balances[msg.sender] = balances[msg.sender] + clamimTkn;
368     
369             emit Transfer(owner, msg.sender, clamimTkn);
370             
371             people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
372             people[msg.sender]._remainToken = remainToken.stage3;
373             people[msg.sender]._blocktimestamp = block.timestamp;
374             
375             return true;
376         }
377         else if (block.timestamp > stage32){
378             
379             uint256 clamimTkn = people[msg.sender]._value; 
380              require(owner != msg.sender);
381              require(balances[owner] - clamimTkn <= balances[owner]);
382              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
383              require(clamimTkn <= transferableTokens(owner));
384         
385             balances[owner] = balances[owner] - clamimTkn;
386             balances[msg.sender] = balances[msg.sender] + clamimTkn;
387     
388             emit Transfer(owner, msg.sender, clamimTkn);
389             
390             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
391             people[msg.sender]._remainToken = remainToken.stage4;
392             people[msg.sender]._blocktimestamp = block.timestamp;
393             
394             return true;
395         }
396     }
397     
398     function withdrawRemainPenaltyToken() public checkUser returns (bool){
399         
400         require(msg.sender == people[msg.sender]._address);
401         require(people[msg.sender]._userState == userState.Withdraw);
402         require(people[msg.sender]._withdrawState == withdrawState.PartiallyWithdraw);
403         require(block.timestamp >= people[msg.sender]._blocktimestamp + oneyear);
404         
405         if (people[msg.sender]._remainToken == remainToken.stage1){
406             
407             uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
408              require(owner != msg.sender);
409              require(balances[owner] - clamimTkn <= balances[owner]);
410              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
411              require(clamimTkn <= transferableTokens(owner));
412         
413             balances[owner] = balances[owner] - clamimTkn;
414             balances[msg.sender] = balances[msg.sender] + clamimTkn;
415     
416             emit Transfer(owner, msg.sender, clamimTkn);
417             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
418             people[msg.sender]._remainToken = remainToken.stage4;
419             
420             return true;
421         }
422         else if (people[msg.sender]._remainToken == remainToken.stage2){
423             
424             uint256 clamimTkn = people[msg.sender]._value / 100 * 30; 
425              require(owner != msg.sender);
426              require(balances[owner] - clamimTkn <= balances[owner]);
427              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
428              require(clamimTkn <= transferableTokens(owner));
429         
430             balances[owner] = balances[owner] - clamimTkn;
431             balances[msg.sender] = balances[msg.sender] + clamimTkn;
432     
433             emit Transfer(owner, msg.sender, clamimTkn);
434             
435             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
436             people[msg.sender]._remainToken = remainToken.stage4;
437             
438             return true;
439         }
440         else if (people[msg.sender]._remainToken == remainToken.stage3){
441             
442             uint256 clamimTkn = people[msg.sender]._value / 100 * 20; 
443              require(owner != msg.sender);
444              require(balances[owner] - clamimTkn <= balances[owner]);
445              require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
446              require(clamimTkn <= transferableTokens(owner));
447         
448             balances[owner] = balances[owner] - clamimTkn;
449             balances[msg.sender] = balances[msg.sender] + clamimTkn;
450     
451             emit Transfer(owner, msg.sender, clamimTkn);
452             
453             people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
454             people[msg.sender]._remainToken = remainToken.stage4;
455             
456             return true;
457         }
458     }
459     
460     function remainPenaltyClaimDate(address  _address) public view returns (uint256 date) {
461         
462          require(_address == people[_address]._address);
463          require(people[_address]._withdrawState == withdrawState.PartiallyWithdraw);
464          require(people[_address]._userState == userState.Withdraw);
465          
466          return people[_address]._blocktimestamp + oneyear;
467         
468     }
469 }