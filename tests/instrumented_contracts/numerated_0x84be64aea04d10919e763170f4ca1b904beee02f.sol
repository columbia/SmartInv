1 /**
2 * ==========================================================
3 *
4 * The Friends Tree
5 * Why can't we be friends?
6 * 
7 * Website  : https://frndstree.io
8 * Telegram : https://t.me/thefriendstree_official
9 *
10 * ==========================================================
11 **/
12 
13 pragma solidity >=0.5.12 <0.7.0;
14 
15 contract TheFriendsTree {
16 
17     struct Tree {
18         uint256 id;
19         uint256 referrerCount;
20         uint256 referrerId;
21         uint256 earnedFromRef;
22         uint256 earnedFromPayplan;
23         uint256 lastslottime;
24         address[] referrals;
25     }
26     
27     struct PayPlan {
28         uint256 id;
29         uint256 referrerId;
30         uint256 reinvestCount;
31     }
32     
33     struct Slots {
34         uint256 id;
35         address userAddress;
36         uint256 referrerId;
37         uint256 slottime;
38         uint8 eventsCount;
39     }
40         
41     modifier validReferrerId(uint256 _referrerId) {
42         require((_referrerId > 0) && (_referrerId < newTreeId), "Invalid referrer ID");
43         _;
44     }
45 
46     modifier onlyOwner {
47         require(
48             msg.sender == ownerWallet,
49             "Only owner can call this function."
50         );
51         _;
52     }
53     
54     modifier isEligibleBuy {
55         require((now - entrance[msg.sender].lastslottime) > 60, "Allowed to buy slot once per minute!");
56         _;
57     }
58 
59     event RegisterTreeEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
60     event RegisterPayPlanEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
61     event ReinvestSlotEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
62 
63     event PayDirectRefBonusEvent(uint256 amount, address indexed _sponsorAddress, address indexed _fromAddress, uint256 _time);
64     event PaySponsorBonusEvent(uint256 amount, address indexed _sponsorAddress, address indexed _fromAddress, uint256 _time);    
65     event PayPlanRefPaymentEvent(uint256 amount, address indexed _from, address indexed _to, uint256 _time);
66     event TreeRefPaymentEvent(uint256 amount, address indexed _sponsorAddress, address indexed _fromAddress, uint256 _level, uint256 _time);
67 
68 
69     mapping(address => Tree) public entrance;
70     mapping(address => PayPlan) public treePayPlan;
71     mapping(uint256 => Slots) public slots;
72 
73     mapping(uint256 => address) private idToAddress;
74     mapping (uint8 => uint8) public uplineAmount;
75     
76     uint256 public newTreeId = 1;
77     uint256 public newTreeIdPayPlan = 1;
78 
79     uint256 public newSlotId = 1;
80     uint256 public activeSlot = 1;
81     
82     address public owner;
83     address payable ownerWallet;
84     
85     constructor(address _ownerAddress) public {
86         
87         uplineAmount[1] = 10;
88         uplineAmount[2] = 10;
89         uplineAmount[3] = 10;
90         uplineAmount[4] = 10;
91         uplineAmount[5] = 10;
92         uplineAmount[6] = 10;
93         uplineAmount[7] = 10;
94         uplineAmount[8] = 10;
95         uplineAmount[9] = 10;
96         uplineAmount[10] = 10;
97         
98         owner = _ownerAddress;
99         ownerWallet = msg.sender;
100         
101         Tree memory user = Tree({
102             id: newTreeId,
103             referrerCount: uint256(0),
104             referrerId: uint256(0),
105             earnedFromRef: uint256(0),
106             earnedFromPayplan: uint256(0),
107             lastslottime: now,
108             referrals: new address[](0)
109         });
110         
111         entrance[_ownerAddress] = user;
112         idToAddress[newTreeId] = _ownerAddress;
113         
114         newTreeId++;
115         
116         //////
117         
118         PayPlan memory payPlanUser = PayPlan({
119             id: newSlotId,
120             referrerId: uint256(0),
121             reinvestCount: uint256(0)
122         });
123         
124         treePayPlan[_ownerAddress] = payPlanUser;
125         
126         Slots memory newSlot = Slots({
127             id: newSlotId,
128             userAddress: _ownerAddress,
129             referrerId: uint256(0),
130             slottime: now,
131             eventsCount: uint8(0)
132         });
133         
134         slots[newSlotId] = newSlot;
135         newTreeIdPayPlan++;
136         newSlotId++;
137         
138     }
139     
140     function joinTree(uint256 _referrerId) 
141       public 
142       payable 
143       validReferrerId(_referrerId) 
144     {
145         
146         require(msg.value == 0.15 ether, "Joining amount is 0.15 ETH");
147         require(!isTreeExists(msg.sender), "Already registered in a Tree");
148 
149         address _userAddress = msg.sender;
150         address sponsorAddress = idToAddress[_referrerId];
151         
152         uint32 size;
153         assembly {
154             size := extcodesize(_userAddress)
155         }
156         require(size == 0, "cannot be a contract");
157                
158         entrance[_userAddress] = Tree({
159             id: newTreeId,
160             referrerCount: uint256(0),
161             referrerId: _referrerId,
162             earnedFromRef: uint256(0),
163             earnedFromPayplan: uint256(0),
164             lastslottime: now,
165             referrals: new address[](0)
166         });
167         idToAddress[newTreeId] = _userAddress;
168 
169         emit RegisterTreeEvent(newTreeId, msg.sender, sponsorAddress, msg.value, now);
170         
171         newTreeId++;
172         
173         entrance[sponsorAddress].referrals.push(_userAddress);
174         entrance[sponsorAddress].referrerCount++;
175         
176         if ( isTreeExists(sponsorAddress) ) {
177             payDirectRefBonus(sponsorAddress);
178             entrance[sponsorAddress].earnedFromRef += 0.05 ether;
179         } else {
180             payDirectRefBonus(idToAddress[1]);
181             entrance[idToAddress[1]].earnedFromRef += 0.05 ether;
182         }
183 
184         uint256 amountToDistribute = 0.1 ether;
185 
186         sponsorAddress = idToAddress[entrance[sponsorAddress].referrerId];
187 
188         for (uint8 i = 1; i <= 10; i++) {
189             
190             if ( isTreeExists(sponsorAddress) ) {
191 
192                 uint256 paid = payRefTree(sponsorAddress, i);
193                 amountToDistribute -= paid;
194                 entrance[sponsorAddress].earnedFromRef += paid;
195                 address _nextSponsorAddress = idToAddress[entrance[sponsorAddress].referrerId];
196                 sponsorAddress = _nextSponsorAddress;
197             }
198             
199         }
200         
201         if (amountToDistribute > 0) {
202             payDirectReferral(idToAddress[1], amountToDistribute);
203             entrance[idToAddress[1]].earnedFromRef += amountToDistribute;
204         }
205         
206     }
207     
208     function JoinPayPlan() 
209       public 
210       payable 
211       isEligibleBuy()
212     {
213         require(msg.value == 1 ether, "Participation fee in Pay Plan is 1 ETH");
214         require(isTreeExists(msg.sender), "Not registered in Tree");
215 
216         uint256 eventCount = slots[activeSlot].eventsCount;
217         uint256 newEventCount = eventCount + 1;
218 
219         if (newEventCount == 3) {
220             require(reinvestSlot(
221                 slots[activeSlot].userAddress, 
222                 slots[activeSlot].id, 
223                 idToAddress[entrance[slots[activeSlot].userAddress].referrerId]
224             ));
225             slots[activeSlot].eventsCount++;
226         }
227         
228         uint256 _referrerId = entrance[msg.sender].referrerId;
229 
230         PayPlan memory payPlanUser = PayPlan({
231             id: newSlotId,
232             referrerId: _referrerId,
233             reinvestCount: uint256(0)
234         });
235         treePayPlan[msg.sender] = payPlanUser;
236         
237         Slots memory _newSlot = Slots({
238             id: newSlotId,
239             userAddress: msg.sender,
240             referrerId: _referrerId,
241             slottime: now,
242             eventsCount: uint8(0)
243         });
244 
245         entrance[msg.sender].lastslottime = now;
246         
247         slots[newSlotId] = _newSlot;
248         newTreeIdPayPlan++;
249         
250         emit RegisterPayPlanEvent(newSlotId, msg.sender, idToAddress[_referrerId], msg.value, now);
251         
252         if (_referrerId > 0) {
253             paySponsorBonus(idToAddress[_referrerId]);
254             entrance[idToAddress[_referrerId]].earnedFromRef += 0.5 ether;
255         }
256         else{
257             paySponsorBonus(idToAddress[1]);
258             entrance[idToAddress[1]].earnedFromRef += 0.5 ether;
259         }
260 
261         newSlotId++;
262 
263         if (eventCount < 2) {
264             
265             if(eventCount == 0) {
266                 payUpline(slots[activeSlot].userAddress);
267                 entrance[slots[activeSlot].userAddress].earnedFromPayplan += msg.value/2;
268             }
269             if(eventCount == 1) {
270                 if (slots[activeSlot].referrerId > 0) {
271                     payUpline(idToAddress[slots[activeSlot].referrerId]);
272                     entrance[idToAddress[slots[activeSlot].referrerId]].earnedFromRef += msg.value/2;
273                 }
274                 else {
275                     payUpline(idToAddress[1]);
276                     entrance[idToAddress[1]].earnedFromRef += msg.value/2;
277                 }
278             }
279 
280             slots[activeSlot].eventsCount++;
281             
282         }
283         
284     }
285 
286     function reinvestSlot(address _userAddress, uint256 _userId, address _sponsorAddress) private returns (bool _isReinvested) {
287 
288         uint256 _referrerId = entrance[_userAddress].referrerId;
289 
290         Slots memory _reinvestslot = Slots({
291             id: _userId,
292             userAddress: _userAddress,
293             referrerId: _referrerId,
294             slottime: now,
295             eventsCount: uint8(0)
296         });
297         
298         treePayPlan[slots[activeSlot].userAddress].reinvestCount++;        
299         slots[newSlotId] = _reinvestslot;
300         emit ReinvestSlotEvent(newSlotId, _userAddress, _sponsorAddress, msg.value, now);
301         newSlotId++;
302 
303         slots[activeSlot].eventsCount = 3;
304         uint256 _nextActiveSlot = activeSlot+1;
305 
306         payUpline(slots[_nextActiveSlot].userAddress);
307         entrance[slots[_nextActiveSlot].userAddress].earnedFromPayplan += msg.value/2;
308         activeSlot++;
309 
310         _isReinvested = true;
311 
312         return _isReinvested;
313 
314     }
315 
316     function payUpline(address _sponsorAddress) private returns (uint distributeAmount) {        
317         distributeAmount = 0.5 ether;
318         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
319             emit PayPlanRefPaymentEvent(distributeAmount, msg.sender, _sponsorAddress, now);
320         }        
321         return distributeAmount;
322     }    
323 
324     function paySponsorBonus(address _sponsorAddress) private {
325         uint256 distributeAmount = 0.5 ether;
326         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
327             emit PaySponsorBonusEvent(distributeAmount, _sponsorAddress, msg.sender, now);
328         }
329     }
330     
331     // Pays to Ref LEvels from Tree
332     function payRefTree(address _sponsorAddress, uint8 _refLevel) private returns (uint256 distributeAmount) {        
333         require( _refLevel <= 10);
334         distributeAmount = 0.1 ether / 100 * uplineAmount[_refLevel];
335         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
336             emit TreeRefPaymentEvent(distributeAmount, _sponsorAddress, msg.sender, _refLevel, now);
337         }        
338         return distributeAmount;
339     }
340 
341     // Pay direct ref bonus from Tree
342     function payDirectRefBonus(address _sponsorAddress) private {
343         uint256 distributeAmount = 0.05 ether;
344         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
345             emit PayDirectRefBonusEvent(distributeAmount, _sponsorAddress, msg.sender, now);
346         }
347     }
348     
349     // Pay to ID 1 from Tree
350     function payDirectReferral(address _sponsorAddress, uint256 payAmount) private returns (uint256 distributeAmount) {        
351         distributeAmount = payAmount;
352         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
353             emit PayDirectRefBonusEvent(distributeAmount, _sponsorAddress, msg.sender, now);
354         }        
355         return distributeAmount;        
356     }
357     
358     function isTreeExists(address _userAddress) public view returns (bool) {
359         return (entrance[_userAddress].id != 0);
360     }
361     
362     function getTreeReferrals(address _userAddress)
363         public
364         view
365         returns (address[] memory)
366       {
367         return entrance[_userAddress].referrals;
368       }
369     
370 }