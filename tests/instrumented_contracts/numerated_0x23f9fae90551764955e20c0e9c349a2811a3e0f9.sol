1 pragma solidity 0.4.21;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint a, uint b) internal pure returns (uint) {
13         if (a == 0) {
14             return 0;
15         }
16         uint c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint a, uint b) internal pure returns (uint) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint a, uint b) internal pure returns (uint) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint a, uint b) internal pure returns (uint) {
43         uint c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 interface ForceToken {
51     function totalSupply() external view returns (uint);
52     function balanceOf(address _owner) external view returns (uint);
53     function serviceTransfer(address _from, address _to, uint _value) external returns (bool);
54     function transfer(address _to, uint _value) external returns (bool);
55     function approve(address _spender, uint _value) external returns (bool);
56     function allowance(address _owner, address _spender) external view returns (uint);
57     function transferFrom(address _from, address _to, uint _value) external returns (bool);
58     function holders(uint _id) external view returns (address);
59     function holdersCount() external view returns (uint);
60 }
61 
62 contract Ownable {
63     address public owner;
64     address public DAO; // DAO contract
65 
66     function Ownable() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner() {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(address _owner) public onlyMasters {
76         owner = _owner;
77     }
78 
79     function setDAO(address newDAO) public onlyMasters {
80         DAO = newDAO;
81     }
82 
83     modifier onlyMasters() {
84         require(msg.sender == owner || msg.sender == DAO);
85         _;
86     }
87 }
88 
89 contract ForceSeller is Ownable {
90     using SafeMath for uint;
91     ForceToken public forceToken;
92 
93     uint public currentRound;
94     uint public tokensOnSale;// current tokens amount on sale
95     uint public reservedTokens;
96     uint public reservedFunds;
97     uint public minSalePrice = 1000000000000000;
98     uint public recallPercent = 80;
99 
100     string public information; // info
101 
102     struct Participant {
103         uint index;
104         uint amount;
105         uint value;
106         uint change;
107         bool needReward;
108         bool needCalc;
109     }
110 
111     struct ICO {
112         uint startTime;
113         uint finishTime;
114         uint weiRaised;
115         uint change;
116         uint finalPrice;
117         uint rewardedParticipants;
118         uint calcedParticipants;
119         uint tokensDistributed;
120         uint tokensOnSale;
121         uint reservedTokens;
122         mapping(address => Participant) participants;
123         mapping(uint => address) participantsList;
124         uint totalParticipants;
125         bool active;
126     }
127 
128     mapping(uint => ICO) public ICORounds; // past ICOs
129 
130     event ICOStarted(uint round);
131     event ICOFinished(uint round);
132     event Withdrawal(uint value);
133     event Deposit(address indexed participant, uint value, uint round);
134     event Recall(address indexed participant, uint value, uint round);
135 
136     modifier whenActive(uint _round) {
137         ICO storage ico = ICORounds[_round];
138         require(ico.active);
139         _;
140     }
141     modifier whenNotActive(uint _round) {
142         ICO storage ico = ICORounds[_round];
143         require(!ico.active);
144         _;
145     }
146     modifier duringRound(uint _round) {
147         ICO storage ico = ICORounds[_round];
148         require(now >= ico.startTime && now <= ico.finishTime);
149         _;
150     }
151 
152     function ForceSeller(address _forceTokenAddress) public {
153         forceToken = ForceToken(_forceTokenAddress);
154 
155     }
156 
157     /**
158     * @dev set public information
159     */
160     function setInformation(string _information) external onlyMasters {
161         information = _information;
162     }
163 
164     /**
165     * @dev set 4TH token address
166     */
167     function setForceContract(address _forceTokenAddress) external onlyMasters {
168         forceToken = ForceToken(_forceTokenAddress);
169     }
170 
171     /**
172     * @dev set recall percent for participants
173     */
174     function setRecallPercent(uint _recallPercent) external onlyMasters {
175         recallPercent = _recallPercent;
176     }
177 
178     /**
179     * @dev set minimal token sale price
180     */
181     function setMinSalePrice(uint _minSalePrice) external onlyMasters {
182         minSalePrice = _minSalePrice;
183     }
184     // start new ico, duration in seconds
185     function startICO(uint _startTime, uint _duration, uint _amount) external whenNotActive(currentRound) onlyMasters {
186         currentRound++;
187         // first ICO - round = 1
188         ICO storage ico = ICORounds[currentRound];
189 
190         ico.startTime = _startTime;
191         ico.finishTime = _startTime.add(_duration);
192         ico.active = true;
193 
194         tokensOnSale = forceToken.balanceOf(address(this)).sub(reservedTokens);
195         //check if tokens on balance not enough, make a transfer
196         if (_amount > tokensOnSale) {
197             //TODO ? maybe better make before transfer from owner (DAO)
198             // be sure needed amount exists at token contract
199             require(forceToken.serviceTransfer(address(forceToken), address(this), _amount.sub(tokensOnSale)));
200             tokensOnSale = _amount;
201         }
202         // reserving tokens
203         ico.tokensOnSale = tokensOnSale;
204         reservedTokens = reservedTokens.add(tokensOnSale);
205         emit ICOStarted(currentRound);
206     }
207 
208     function() external payable whenActive(currentRound) duringRound(currentRound) {
209         require(msg.value >= currentPrice());
210         ICO storage ico = ICORounds[currentRound];
211         Participant storage p = ico.participants[msg.sender];
212         uint value = msg.value;
213 
214         // is it new participant?
215         if (p.index == 0) {
216             p.index = ++ico.totalParticipants;
217             ico.participantsList[ico.totalParticipants] = msg.sender;
218             p.needReward = true;
219             p.needCalc = true;
220         }
221         p.value = p.value.add(value);
222         ico.weiRaised = ico.weiRaised.add(value);
223         reservedFunds = reservedFunds.add(value);
224         emit Deposit(msg.sender, value, currentRound);
225     }
226 
227     // refunds participant if he recall their funds
228     function recall() external whenActive(currentRound) duringRound(currentRound) {
229         ICO storage ico = ICORounds[currentRound];
230         Participant storage p = ico.participants[msg.sender];
231         uint value = p.value;
232         require(value > 0);
233         //deleting participant from list
234         ico.participants[ico.participantsList[ico.totalParticipants]].index = p.index;
235         ico.participantsList[p.index] = ico.participantsList[ico.totalParticipants];
236         delete ico.participantsList[ico.totalParticipants--];
237         delete ico.participants[msg.sender];
238         //reduce weiRaised
239         ico.weiRaised = ico.weiRaised.sub(value);
240         reservedFunds = reservedFunds.sub(value);
241         msg.sender.transfer(valueFromPercent(value, recallPercent));
242         emit Recall(msg.sender, value, currentRound);
243     }
244 
245     //get current token price
246     function currentPrice() public view returns (uint) {
247         ICO storage ico = ICORounds[currentRound];
248         uint salePrice = tokensOnSale > 0 ? ico.weiRaised.div(tokensOnSale) : 0;
249         return salePrice > minSalePrice ? salePrice : minSalePrice;
250     }
251 
252     // allows to participants reward their tokens from the current round
253     function reward() external {
254         rewardRound(currentRound);
255     }
256 
257     // allows to participants reward their tokens from the specified round
258     function rewardRound(uint _round) public whenNotActive(_round) {
259         ICO storage ico = ICORounds[_round];
260         Participant storage p = ico.participants[msg.sender];
261 
262         require(p.needReward);
263         p.needReward = false;
264         ico.rewardedParticipants++;
265         if (p.needCalc) {
266             p.needCalc = false;
267             ico.calcedParticipants++;
268             p.amount = p.value.div(ico.finalPrice);
269             p.change = p.value % ico.finalPrice;
270             reservedFunds = reservedFunds.sub(p.value);
271             if (p.change > 0) {
272                 ico.weiRaised = ico.weiRaised.sub(p.change);
273                 ico.change = ico.change.add(p.change);
274             }
275         } else {
276             //assuming participant was already calced in calcICO
277             ico.reservedTokens = ico.reservedTokens.sub(p.amount);
278             if (p.change > 0) {
279                 reservedFunds = reservedFunds.sub(p.change);
280             }
281         }
282 
283         ico.tokensDistributed = ico.tokensDistributed.add(p.amount);
284         ico.tokensOnSale = ico.tokensOnSale.sub(p.amount);
285         reservedTokens = reservedTokens.sub(p.amount);
286 
287         if (ico.rewardedParticipants == ico.totalParticipants) {
288             reservedTokens = reservedTokens.sub(ico.tokensOnSale);
289             ico.tokensOnSale = 0;
290         }
291 
292         //token transfer
293         require(forceToken.transfer(msg.sender, p.amount));
294 
295         if (p.change > 0) {
296             //transfer change
297             msg.sender.transfer(p.change);
298         }
299     }
300 
301     // finish current round
302     function finishICO() external whenActive(currentRound) onlyMasters {
303         ICO storage ico = ICORounds[currentRound];
304         //avoid mistake with date in a far future
305         //require(now > ico.finishTime);
306         ico.finalPrice = currentPrice();
307         tokensOnSale = 0;
308         ico.active = false;
309         if (ico.totalParticipants == 0) {
310             reservedTokens = reservedTokens.sub(ico.tokensOnSale);
311             ico.tokensOnSale = 0;
312 
313         }
314         emit ICOFinished(currentRound);
315     }
316 
317     // calculate participants in ico round
318     function calcICO(uint _fromIndex, uint _toIndex, uint _round) public whenNotActive(_round == 0 ? currentRound : _round) onlyMasters {
319         ICO storage ico = ICORounds[_round == 0 ? currentRound : _round];
320         require(ico.totalParticipants > ico.calcedParticipants);
321         require(_toIndex <= ico.totalParticipants);
322         require(_fromIndex > 0 && _fromIndex <= _toIndex);
323 
324         for(uint i = _fromIndex; i <= _toIndex; i++) {
325             address _p = ico.participantsList[i];
326             Participant storage p = ico.participants[_p];
327             if (p.needCalc) {
328                 p.needCalc = false;
329                 p.amount = p.value.div(ico.finalPrice);
330                 p.change = p.value % ico.finalPrice;
331                 reservedFunds = reservedFunds.sub(p.value);
332                 if (p.change > 0) {
333                     ico.weiRaised = ico.weiRaised.sub(p.change);
334                     ico.change = ico.change.add(p.change);
335                     //reserving
336                     reservedFunds = reservedFunds.add(p.change);
337                 }
338                 ico.reservedTokens = ico.reservedTokens.add(p.amount);
339                 ico.calcedParticipants++;
340             }
341         }
342         //if last, free all unselled tokens
343         if (ico.calcedParticipants == ico.totalParticipants) {
344             reservedTokens = reservedTokens.sub(ico.tokensOnSale.sub(ico.reservedTokens));
345             ico.tokensOnSale = ico.reservedTokens;
346         }
347     }
348 
349     // get value percent
350     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount) {
351         uint _amount = _value.mul(_percent).div(100);
352         return (_amount);
353     }
354 
355     // available funds to withdraw
356     function availableFunds() external view returns (uint amount) {
357         return address(this).balance.sub(reservedFunds);
358     }
359 
360     //get ether amount payed by participant in specified round
361     function participantRoundValue(address _address, uint _round) external view returns (uint) {
362         ICO storage ico = ICORounds[_round == 0 ? currentRound : _round];
363         Participant storage p = ico.participants[_address];
364         return p.value;
365     }
366 
367     //get token amount rewarded to participant in specified round
368     function participantRoundAmount(address _address, uint _round) external view returns (uint) {
369         ICO storage ico = ICORounds[_round == 0 ? currentRound : _round];
370         Participant storage p = ico.participants[_address];
371         return p.amount;
372     }
373 
374     //is participant rewarded in specified round
375     function participantRoundRewarded(address _address, uint _round) external view returns (bool) {
376         ICO storage ico = ICORounds[_round == 0 ? currentRound : _round];
377         Participant storage p = ico.participants[_address];
378         return !p.needReward;
379     }
380 
381     //is participant calculated in specified round
382     function participantRoundCalced(address _address, uint _round) external view returns (bool) {
383         ICO storage ico = ICORounds[_round == 0 ? currentRound : _round];
384         Participant storage p = ico.participants[_address];
385         return !p.needCalc;
386     }
387 
388     //get participant's change in specified round
389     function participantRoundChange(address _address, uint _round) external view returns (uint) {
390         ICO storage ico = ICORounds[_round == 0 ? currentRound : _round];
391         Participant storage p = ico.participants[_address];
392         return p.change;
393     }
394 
395     // withdraw available funds from contract
396     function withdrawFunds(address _to, uint _value) external onlyMasters {
397         require(address(this).balance.sub(reservedFunds) >= _value);
398         _to.transfer(_value);
399         emit Withdrawal(_value);
400     }
401 }