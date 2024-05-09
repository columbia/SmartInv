1 /**
2 * ==========================================================
3 *
4 * The Friends Tree Feeder
5 * 
6 * Website  : https://feeder.frndstree.io
7 * Telegram : https://t.me/thefriendstree_official
8 *
9 * ==========================================================
10 **/
11 
12 pragma solidity >=0.5.12 <0.7.0;
13 
14 contract TheFeeder {
15     
16     struct Matrix {
17         uint256 id;
18         uint256 referrerId;
19         uint256 earnedFromMatrix;
20         uint256 earnedFromRef;
21         uint256 reinvestCount;
22         uint256 slotLastBuyTime;
23         uint256 referrerCount;
24         address[] referrals;
25     }
26     
27     struct Slots {
28         uint256 userId;
29         address userAddress;
30         uint256 referrerId;
31         uint256 slottime;
32         uint8 eventsCount;
33     }
34            
35     modifier isEligibleBuy {
36         require((now - feeder[msg.sender].slotLastBuyTime) > 300, "Allowed to buy slot once per 5 minutes!");
37         _;
38     }
39 
40     modifier onlyOwner {
41         require(
42             msg.sender == payableOwner,
43             "Only owner can call this function."
44         );
45         _;
46     }
47 
48     event RegisterMatrixEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
49     event ReinvestSlotEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
50     event BuySlotEvent(uint256 _userid, address indexed _user, address indexed _referrerAddress, uint256 _amount, uint256 _time);
51 
52     event PaySponsorBonusEvent(uint256 amount, address indexed _sponsorAddress, address indexed _fromAddress, uint256 _time);    
53     event MatrixRefPaymentEvent(uint256 amount, address indexed _from, address indexed _to, uint256 _time);
54 
55     mapping(address => Matrix) public feeder;
56     mapping(uint256 => Slots) public slots;
57     mapping(address => uint256[]) public userSlots;
58     mapping(uint256 => address) private idToAddress;
59 
60     uint256 public newIdfeeder = 1;
61     uint256 public newSlotId = 1;
62     uint256 public activeSlot = 1;    
63     
64     address public owner;
65     address payable payableOwner;
66     
67     constructor(address _ownerAddress) public {
68         
69         owner = msg.sender;
70         payableOwner = msg.sender;
71                 
72         Matrix memory MatrixUser = Matrix({
73             id: newIdfeeder,
74             referrerId: uint256(1),
75             earnedFromMatrix: uint256(0),
76             earnedFromRef: uint256(0),
77             reinvestCount: uint256(0),
78             slotLastBuyTime: now,
79             referrerCount: uint256(0),
80             referrals: new address[](0)
81         });
82         
83         emit RegisterMatrixEvent(newIdfeeder, _ownerAddress, _ownerAddress, 0.05 ether, now);
84         
85         feeder[_ownerAddress] = MatrixUser;
86         idToAddress[newIdfeeder] = _ownerAddress;
87         
88         Slots memory newSlot = Slots({
89             userId: newIdfeeder,
90             userAddress: _ownerAddress,
91             referrerId: uint256(1),
92             slottime: now,
93             eventsCount: uint8(0)
94         });
95         
96         emit BuySlotEvent(newSlotId, _ownerAddress, _ownerAddress, 0.05 ether, now);
97         
98         slots[newSlotId] = newSlot;
99         userSlots[_ownerAddress].push(newSlotId);
100         newIdfeeder++;
101         newSlotId++;
102         
103     }
104     
105     function JoinMatrix(uint256 _referrerId) 
106       public 
107       payable 
108       isEligibleBuy()
109     {
110         require(msg.value == 0.05 ether, "Participation fee in a feeder is 0.05 ETH");
111 
112         address _userAddress = msg.sender;        
113 
114         if ((_referrerId > 0) && (!isAddressExists(_userAddress))) {
115 
116             // Main checks
117             uint32 size;
118             assembly {
119                 size := extcodesize(_userAddress)
120             }
121             require(size == 0, "cannot be a contract");
122             require(_referrerId < newIdfeeder, "Invalid referrer ID");
123             require(feeder[_userAddress].id == 0, "Already registered");
124             // Main check end
125 
126             address _sponsorAddress = idToAddress[_referrerId];
127 
128             // Register in Matrix
129             Matrix memory MatrixUser = Matrix({
130                 id: newIdfeeder,
131                 referrerId: _referrerId,
132                 earnedFromMatrix: uint256(0),
133                 earnedFromRef: uint256(0),
134                 reinvestCount: uint256(0),
135                 slotLastBuyTime: now,
136                 referrerCount: uint256(0),
137                 referrals: new address[](0)
138             });
139             
140             feeder[_userAddress] = MatrixUser;
141             idToAddress[newIdfeeder] = _userAddress;
142             newIdfeeder++;
143 
144             if (_referrerId > 0) {
145                 paySponsorBonus(_sponsorAddress);
146                 feeder[_sponsorAddress].earnedFromRef += 0.025 ether;
147             }
148             else{
149                 paySponsorBonus(idToAddress[1]);
150                 feeder[idToAddress[1]].earnedFromRef += 0.025 ether;
151             }
152 
153             emit RegisterMatrixEvent(newIdfeeder, _userAddress, _sponsorAddress, msg.value, now);
154 
155             // Push referral to sponsor
156             feeder[_sponsorAddress].referrals.push(_userAddress);
157             feeder[_sponsorAddress].referrerCount++;
158 
159             // Buy Slot
160             Slots memory newSlot = Slots({
161                 userId: feeder[_userAddress].id,
162                 userAddress: _userAddress,
163                 referrerId: _referrerId,
164                 slottime: now,
165                 eventsCount: uint8(0)
166             });
167 
168             emit BuySlotEvent(newSlotId, _userAddress, _sponsorAddress, msg.value, now);
169             
170             slots[newSlotId] = newSlot;
171             userSlots[_userAddress].push(newSlotId);
172             newSlotId++;
173 
174         } else {
175             
176             require(feeder[_userAddress].id > 0, "You must be registered, enter sponsor code to register!");
177 
178             _referrerId = feeder[_userAddress].referrerId;
179 
180             // Buy Slot
181             Slots memory newSlot = Slots({
182                 userId: feeder[_userAddress].id,
183                 userAddress: _userAddress,
184                 referrerId: _referrerId,
185                 slottime: now,
186                 eventsCount: uint8(0)
187             });
188 
189             address _sponsorAddress = idToAddress[_referrerId];    
190             emit BuySlotEvent(newSlotId, _userAddress, _sponsorAddress, msg.value, now);
191 
192             paySponsorBonus(_sponsorAddress);
193             feeder[_sponsorAddress].earnedFromRef += 0.025 ether;
194             
195             slots[newSlotId] = newSlot;
196             userSlots[_userAddress].push(newSlotId);
197             feeder[_userAddress].slotLastBuyTime = now;
198             newSlotId++;
199 
200         }
201 
202         // PUSH SLOT
203        
204         uint256 eventCount = slots[activeSlot].eventsCount;
205         uint256 newEventCount = eventCount + 1;
206 
207         if (newEventCount == 3) {
208             require(reinvestSlot(
209                 slots[activeSlot].userAddress, 
210                 slots[activeSlot].userId, 
211                 idToAddress[feeder[slots[activeSlot].userAddress].referrerId]
212             ));
213             slots[activeSlot].eventsCount++;
214         }
215 
216         if (eventCount < 2) {
217             
218             if(eventCount == 0) {
219                 payUpline(slots[activeSlot].userAddress);
220                 feeder[slots[activeSlot].userAddress].earnedFromMatrix += msg.value/2;
221             }
222             if(eventCount == 1) {
223                 if (slots[activeSlot].referrerId > 0) {
224                     payUpline(idToAddress[slots[activeSlot].referrerId]);
225                     feeder[idToAddress[slots[activeSlot].referrerId]].earnedFromRef += msg.value/2;
226                 }
227                 else {
228                     payUpline(idToAddress[1]);
229                     feeder[idToAddress[1]].earnedFromRef += msg.value/2;
230                 }
231             }
232 
233             slots[activeSlot].eventsCount++;
234             
235         }
236         
237     }
238 
239     function reinvestSlot(address _userAddress, uint256 _userId, address _sponsorAddress) private returns (bool _isReinvested) {
240 
241         uint256 _referrerId = feeder[_userAddress].referrerId;
242 
243         Slots memory _reinvestslot = Slots({
244             userId: _userId,
245             userAddress: _userAddress,
246             referrerId: _referrerId,
247             slottime: now,
248             eventsCount: uint8(0)
249         });
250         
251         feeder[slots[activeSlot].userAddress].reinvestCount++;        
252         slots[newSlotId] = _reinvestslot;
253         userSlots[_userAddress].push(newSlotId);
254         emit ReinvestSlotEvent(newSlotId, _userAddress, _sponsorAddress, msg.value, now);
255         newSlotId++;
256 
257         slots[activeSlot].eventsCount = 3;
258         uint256 _nextActiveSlot = activeSlot+1;
259 
260         payUpline(slots[_nextActiveSlot].userAddress);
261         feeder[slots[_nextActiveSlot].userAddress].earnedFromMatrix += msg.value/2;
262         activeSlot++;
263 
264         _isReinvested = true;
265 
266         return _isReinvested;
267 
268     }
269 
270     function payUpline(address _sponsorAddress) private returns (uint distributeAmount) {        
271         distributeAmount = 0.025 ether;
272         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
273             emit MatrixRefPaymentEvent(distributeAmount, msg.sender, _sponsorAddress, now);
274         }        
275         return distributeAmount;
276     }    
277 
278     function paySponsorBonus(address _sponsorAddress) private {
279         uint256 distributeAmount = 0.025 ether;
280         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
281             emit PaySponsorBonusEvent(distributeAmount, _sponsorAddress, msg.sender, now);
282         }
283     }
284 
285     function isAddressExists(address _userAddress) public view returns (bool) {
286         return (feeder[_userAddress].id != 0);
287     }
288     
289     function getTreeReferrals(address _userAddress)
290         public
291         view
292         returns (address[] memory)
293       { 
294         return feeder[_userAddress].referrals;
295       }
296 
297     function withdraw() public onlyOwner returns(bool) {
298         uint256 amount = address(this).balance;
299         payableOwner.transfer(amount);
300         return true;
301     }
302     
303 }