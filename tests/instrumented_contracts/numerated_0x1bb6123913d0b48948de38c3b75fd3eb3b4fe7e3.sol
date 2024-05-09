1 contract EtherAds {
2     // define some events
3     event BuyAd(address etherAddress, uint amount, string href, string anchor, string imgId, uint headerColor, uint8 countryId, address referral);
4     event ResetContract();
5     event PayoutEarnings(address etherAddress, uint amount, uint8 referralLevel);
6     struct Ad {
7         address etherAddress;
8         uint amount;
9         string href;
10         string anchor;
11         string imgId;
12         uint8 countryId;
13         int refId;
14     }
15     struct charityFundation {
16         string href;
17         string anchor;
18         string imgId;
19     }
20     charityFundation[] public charityFundations;
21     uint public charityFoundationIdx = 0;
22     string public officialWebsite;
23     Ad[] public ads;
24     uint public payoutIdx = 0;
25     uint public balance = 0;
26     uint public fees = 0;
27     uint public contractExpirationTime;
28     uint public headerColor = 0x000000;
29     uint public maximumDeposit = 42 ether;
30     // keep prices levels
31     uint[7] public txsThreshold = [10, 20, 50, 100, 200, 500, 1000];
32     // prolongate hours for each txs level
33     uint[8] public prolongH = [
34         336 hours, 168 hours, 67 hours, 33 hours,
35         16 hours, 6 hours, 3 hours, 1 hours
36     ];
37     // minimal deposits for each txs level
38     uint[8] public minDeposits = [
39         100 szabo, 400 szabo, 2500 szabo, 10 finney,
40         40 finney, 250 finney, 1 ether, 5 ether
41     ];
42     // this array stores number of txs per each hour
43     uint[24] public txsPerHour;
44     uint public lastHour; // store last hour for txs number calculation
45     uint public frozenMinDeposit = 0;
46     // owners
47     address[3] owners;
48     // simple onlyowners function modifier
49     modifier onlyowners {
50         if (msg.sender == owners[0] || msg.sender == owners[1] || msg.sender == owners[2]) _
51     }
52     // create contract with 3 owners
53     function EtherAds(address owner0, address owner1, address owner2) {
54         owners[0] = owner0;
55         owners[1] = owner1;
56         owners[2] = owner2;
57     }
58     // // dont allow to waste money
59     // function() {
60     //     // the creators are like Satoshi
61     //     // Bitcoin is important,
62     //     // but Ethereum is better :-)
63     //     throw;
64     // }
65     // buy add for charity fundation if just ethers was sent
66     function() {
67         buyAd(
68             charityFundations[charityFoundationIdx].href,
69             charityFundations[charityFoundationIdx].anchor,
70             charityFundations[charityFoundationIdx].imgId,
71             0xff8000,
72             0, // charity flag
73             msg.sender
74         );
75         charityFoundationIdx += 1;
76         if (charityFoundationIdx >= charityFundations.length) {
77             charityFoundationIdx = 0;
78         }
79     }
80     // buy add
81     function buyAd(string href, string anchor, string imgId, uint _headerColor, uint8 countryId, address referral) {
82         uint value = msg.value;
83         uint minimalDeposit = getMinimalDeposit();
84         // dont allow to get in with too low deposit
85         if (value < minimalDeposit) throw;
86         // dont allow to invest more than 42
87         if (value > maximumDeposit) {
88             msg.sender.send(value - maximumDeposit);
89             value = maximumDeposit;
90         }
91         // cancel buy if strings are too long
92         if (bytes(href).length > 100 || bytes(anchor).length > 50) throw;
93         // reset ads if last transaction reached outdateDuration
94         resetContract();
95         // store new ad id
96         uint id = ads.length;
97         // add new ad entry in storage
98         ads.length += 1;
99         ads[id].etherAddress = msg.sender;
100         ads[id].amount = value;
101         ads[id].href = href;
102         ads[id].imgId = imgId;
103         ads[id].anchor = anchor;
104         ads[id].countryId = countryId;
105         // add sent value to balance
106         balance += value;
107         // set header color
108         headerColor = _headerColor;
109         // call event
110         BuyAd(msg.sender, value, href, anchor, imgId, _headerColor, countryId, referral);
111         updateTxStats();
112         // find referral id in ads and keep its id in storage
113         setReferralId(id, referral);
114         distributeEarnings();
115     }
116     function prolongateContract() private {
117         uint level = getCurrentLevel();
118         contractExpirationTime = now + prolongH[level];
119     }
120     function getMinimalDeposit() returns (uint) {
121         uint txsThresholdIndex = getCurrentLevel();
122         if (minDeposits[txsThresholdIndex] > frozenMinDeposit) {
123             frozenMinDeposit = minDeposits[txsThresholdIndex];
124         }
125         return frozenMinDeposit;
126     }
127     function getCurrentLevel() returns (uint) {
128         uint txsPerLast24hours = 0;
129         uint i = 0;
130         while (i < 24) {
131             txsPerLast24hours += txsPerHour[i];
132             i += 1;
133         }
134         i = 0;
135         while (txsPerLast24hours > txsThreshold[i]) {
136             i = i + 1;
137         }
138         return i;
139     }
140     function updateTxStats() private {
141         uint currtHour = now / (60 * 60);
142         uint txsCounter = txsPerHour[currtHour];
143         if (lastHour < currtHour) {
144             txsCounter = 0;
145             lastHour = currtHour;
146         }
147         txsCounter += 1;
148         txsPerHour[currtHour] = txsCounter;
149     }
150     // distribute earnings to participants
151     function distributeEarnings() private {
152         // start infinite payout while ;)
153         while (true) {
154             // calculate doubled payout
155             uint amount = ads[payoutIdx].amount * 2;
156             // if balance is enough to pay participant
157             if (balance >= amount) {
158                 // send earnings - fee to participant
159                 ads[payoutIdx].etherAddress.send(amount / 100 * 80);
160                 PayoutEarnings(ads[payoutIdx].etherAddress, amount / 100 * 80, 0);
161                 // collect 15% fees
162                 fees += amount / 100 * 15;
163                 // calculate 5% 3-levels fees
164                 uint level0Fee = amount / 1000 * 25; // 2.5%
165                 uint level1Fee = amount / 1000 * 15; // 1.5%
166                 uint level2Fee = amount / 1000 * 10; // 1.0%
167                 // find 
168                 int refId = ads[payoutIdx].refId;
169                 if (refId == -1) {
170                     // no refs, no fun :-)
171                     balance += level0Fee + level1Fee + level2Fee;
172                 } else {
173                     ads[uint(refId)].etherAddress.send(level0Fee);
174                     PayoutEarnings(ads[uint(refId)].etherAddress, level0Fee, 1);
175                     
176                     refId = ads[uint(refId)].refId;
177                     if (refId == -1) {
178                         // no grand refs, no grand fun
179                         balance += level1Fee + level2Fee;
180                     } else {
181                         // have grand children :-)
182                         ads[uint(refId)].etherAddress.send(level1Fee);
183                         PayoutEarnings(ads[uint(refId)].etherAddress, level1Fee, 2);
184                      
185                         refId = ads[uint(refId)].refId;
186                         if (refId == -1) {
187                             // no grand grand refs, no grand grand fun (great grandfather - satoshi is drunk)
188                             balance += level2Fee;
189                         } else {
190                             // have grand grand children :-)
191                             ads[uint(refId)].etherAddress.send(level2Fee);
192                             PayoutEarnings(ads[uint(refId)].etherAddress, level2Fee, 3);
193                         }
194                     }
195                 }
196                 balance -= amount;
197                 payoutIdx += 1;
198             } else {
199                 // if there was no any payouts (too low balance), cancel while loop
200                 // YOU CANNOT GET BLOOD OUT OF A STONE :-)
201                 break;
202             }
203         }
204     }
205     // check if contract is outdate which means there was no any transacions
206     // since (now - outdateDuration) seconds and its going to reset
207     function resetContract() private {
208         // like in bible, the last are the first :-)
209         if (now > contractExpirationTime) {
210             // pay 50% of balance to last investor
211             balance = balance / 2;
212             ads[ads.length-1].etherAddress.send(balance);
213             // clear ads storage
214             ads.length = 0;
215             // reset payout counter
216             payoutIdx = 0;
217             contractExpirationTime = now + 14 days;
218             frozenMinDeposit = 0;
219             // clear txs counter
220             uint i = 0;
221             while (i < 24) {
222                 txsPerHour[i] = 0;
223                 i += 1;
224             }
225             // call event
226             ResetContract();
227         }
228     }
229     // find and set referral Id
230     function setReferralId(uint id, address referral) private {
231         uint i = 0;
232         // if referral address will be not found than keep -1 value
233         // which means that ad purshared was not referred by anyone
234         int refId = -1;
235         // go through all ads and try to find referral address in this array
236         while (i < ads.length) {
237             // if ref was found end while
238             if (ads[i].etherAddress == referral) {
239                 refId = int(i);
240                 break;
241             }
242             i += 1;
243         }
244         // if ref was not found than we have -1 value here
245         ads[id].refId = refId;
246     }
247 
248     // send fees to all contract owners
249     function collectFees() onlyowners {
250         if (fees == 0) return; // buy more ads
251         uint sharedFee = fees / 3;
252         uint i = 0;
253         while (i < 3) {
254             owners[i].send(sharedFee);
255             i += 1;
256         }
257         // reset fees counter
258         fees = 0;
259     }
260     // change single ownership
261     function changeOwner(address newOwner) onlyowners {
262         uint i = 0;
263         while (i < 3) {
264             // check if you are owner
265             if (msg.sender == owners[i]) {
266                 // change ownership
267                 owners[i] = newOwner;
268             }
269             i += 1;
270         }
271     }
272     // set official contract front-end website
273     function setOfficialWebsite(string url) onlyowners {
274         officialWebsite = url;
275     }
276     // add new charity foundation to the list
277     function addCharityFundation(string href, string anchor, string imgId) onlyowners {
278         uint id = charityFundations.length;
279         // add new ad entry in storage
280         charityFundations.length += 1;
281         charityFundations[id].href = href;
282         charityFundations[id].anchor = anchor;
283         charityFundations[id].imgId = imgId;
284     }
285     // clear charity foundations list, to make new one
286     function resetFoundationtList() onlyowners {
287         charityFundations.length = 0;
288     }
289     function giveMeat() onlyowners {
290         // add free financig to contract, lets FUN!
291         balance += msg.value;
292     }
293 }