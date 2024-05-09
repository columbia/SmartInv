1 pragma solidity ^0.4.16;
2 
3 pragma solidity ^0.4.16;
4 
5 pragma solidity ^0.4.16;
6 
7 
8 contract ERC20 {
9 
10     uint256 public totalSupply;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     function balanceOf(address who) public view returns (uint256);
16     function transfer(address to, uint256 value) public returns (bool);
17 
18     function allowance(address owner, address spender) public view returns (uint256);
19     function approve(address spender, uint256 value) public returns (bool);
20     function transferFrom(address from, address to, uint256 value) public returns (bool);
21 
22 }
23 pragma solidity ^0.4.16;
24 
25 
26 //////////////////////////////////////////////////
27 
28 contract Ownable {
29     address public owner;
30 
31     event OwnerChanged(address oldOwner, address newOwner);
32 
33     function Ownable() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address newOwner) onlyOwner public {
43         require(newOwner != owner && newOwner != address(0x0));
44         address oldOwner = owner;
45         owner = newOwner;
46         OwnerChanged(oldOwner, newOwner);
47     }
48 }
49 
50 
51 contract CrowdSale is Ownable {
52 
53     // ERC20 Token
54     ERC20 public token;
55 
56     // address where receives funds
57     address public beneficiary;
58     // address where provides tokens
59     address public tokenHolder;
60 
61     // how many token units per wei
62     uint public rate;
63 
64     // amount of goal in wei
65     uint public amountGoal;
66 
67     // amount of current raised money in wei
68     uint public amountRaised;
69 
70     // amount of tokens issued
71     uint public amountTokenIssued;
72 
73     // Important Time
74     uint public startTime;
75     uint public endTime;
76 
77     // Stages Info
78     struct Stage {
79         uint duration;      // Duration in second of current stage
80         uint rate;          // 100 = 100%
81     }
82     Stage[] public icoStages;
83     Stage[] public lockStages;
84 
85 
86     // Purchaser Info
87     struct PurchaserInfo {
88         uint amountEtherSpent;
89         uint amountTokenTaken;
90         uint[] lockedToken;
91     }
92     mapping(address => PurchaserInfo) public purchasers;
93 
94     address[] public purchaserList;
95 
96 
97     // ----- Events -----
98     event TokenPurchase(address purchaser, uint value, uint buyTokens, uint bonusTokens);
99     event GoalReached(uint totalAmountRaised, uint totalTokenIssued);
100     event FundingWithdrawn(address beneficiaryAddress, uint value);
101     event UnlockToken(address purchaser, uint amountUnlockedTokens);
102 
103 
104     // ----- Modifiers -----
105     modifier afterEnded {
106         require(isEnded());
107         _;
108     }
109 
110     modifier onlyOpenTime {
111         require(isStarted());
112         require(!isEnded());
113         _;
114     }
115 
116 
117     // ----- Functions -----
118     function CrowdSale(address beneficiaryAddr, address tokenHolderAddr, address tokenAddr, uint tokenRate) public {
119         require(beneficiaryAddr != address(0));
120         require(tokenHolderAddr != address(0));
121         require(tokenAddr != address(0));
122         require(tokenRate > 0);
123 
124         beneficiary = beneficiaryAddr;
125         tokenHolder = tokenHolderAddr;
126         token = ERC20(tokenAddr);
127         rate = tokenRate;
128 
129         _initStages();
130     }
131 
132     function _initStages() internal;   //Need override
133 
134     function getTokenAddress() public view returns(address) {
135         return token;
136     }
137 
138     function getLockedToken(address _purchaser, uint stageIdx) public view returns(uint) {
139         if(stageIdx >= purchasers[_purchaser].lockedToken.length) {
140             return 0;
141         }
142         return purchasers[_purchaser].lockedToken[stageIdx];
143     }
144 
145     function canTokenUnlocked(uint stageIndex) public view returns(bool) {
146         if(0 <= stageIndex && stageIndex < lockStages.length){
147             uint stageEndTime = endTime;
148             for(uint i = 0; i <= stageIndex; i++) {
149                 stageEndTime += lockStages[i].duration;
150             }//for
151             return now > stageEndTime;
152         }
153         return false;
154     }
155 
156     function isStarted() public view returns(bool) {
157         return 0 < startTime && startTime <= now;
158     }
159 
160     function isReachedGoal() public view returns(bool) {
161         return amountRaised >= amountGoal;
162     }
163 
164     function isEnded() public view returns(bool) {
165         return now > endTime || isReachedGoal();
166     }
167 
168     function getCurrentStage() public view returns(int) {
169         int stageIdx = -1;
170         uint stageEndTime = startTime;
171         for(uint i = 0; i < icoStages.length; i++) {
172             stageEndTime += icoStages[i].duration;
173             if (now <= stageEndTime) {
174                 stageIdx = int(i);
175                 break;
176             }
177         }
178         return stageIdx;
179     }
180 
181     function getRemainingTimeInSecond() public view returns(uint) {
182         if(endTime == 0)
183             return 0;
184         return endTime - now;
185     }
186 
187     function _addPurchaser(address purchaser) internal {
188         require(purchaser != address(0));
189 
190 //        for (uint i = 0; i < purchaserList.length; i++) {
191 //            if (purchaser == purchaserList[i]){
192 //                return;
193 //            }
194 //        }
195         purchaserList.push(purchaser);
196     }
197 
198     function start(uint fundingGoalInEther) public onlyOwner {
199         require(!isStarted());
200         require(fundingGoalInEther > 0);
201         amountGoal = fundingGoalInEther * 1 ether;
202 
203         startTime = now;
204 
205         uint duration = 0;
206         for(uint i = 0; i < icoStages.length; i++){
207             duration += icoStages[i].duration;
208         }
209 
210         endTime = startTime + duration;
211     }
212 
213     function stop() public onlyOwner {
214         require(isStarted());
215         endTime = now;
216     }
217 
218     function () payable public onlyOpenTime {
219         require(msg.value > 0);
220 
221         uint amount = msg.value;
222         var (buyTokenCount, bonusTokenCount) = _getTokenCount(amount);
223 
224         PurchaserInfo storage pi = purchasers[msg.sender];
225         pi.amountEtherSpent += amount;
226         pi.amountTokenTaken += buyTokenCount;
227 
228         if (pi.lockedToken.length == 0) {
229             pi.lockedToken = new uint[](lockStages.length);
230         }
231 
232         for(uint i = 0; i < lockStages.length; i++) {
233             Stage storage stage = lockStages[i];
234             pi.lockedToken[i] += stage.rate * bonusTokenCount / 100;
235         }
236 
237 
238         amountRaised += amount;
239         amountTokenIssued += buyTokenCount;
240 
241         token.transferFrom(tokenHolder, msg.sender, buyTokenCount);
242         TokenPurchase(msg.sender, amount, buyTokenCount, bonusTokenCount);
243 
244         _addPurchaser(msg.sender);
245 
246         if(isReachedGoal()){
247             endTime = now;
248         }
249     }
250 
251     function _getTokenCount(uint amountInWei) internal view returns(uint buyTokenCount, uint bonusTokenCount) {
252         buyTokenCount = amountInWei * rate;
253 
254         int stageIdx = getCurrentStage();
255         assert(stageIdx >= 0 && uint(stageIdx) < icoStages.length);
256         bonusTokenCount = buyTokenCount * icoStages[uint(stageIdx)].rate / 100;
257     }
258 
259 
260     function safeWithdrawal() public onlyOwner {
261         require(beneficiary != address(0));
262         beneficiary.transfer(amountRaised);
263         FundingWithdrawn(beneficiary, amountRaised);
264     }
265 
266     function unlockBonusTokens(uint stageIndex, uint purchaserStartIdx, uint purchaserEndIdx) public afterEnded onlyOwner {
267         require(0 <= purchaserStartIdx && purchaserStartIdx < purchaserEndIdx && purchaserEndIdx <= purchaserList.length);
268         require(canTokenUnlocked(stageIndex));
269 
270         for (uint j = purchaserStartIdx; j < purchaserEndIdx; j++) {
271             address purchaser = purchaserList[j];
272             if(purchaser != address(0)){
273                 PurchaserInfo storage pi = purchasers[purchaser];
274                 uint unlockedToken = pi.lockedToken[stageIndex];
275                 if (unlockedToken > 0) {
276                     pi.lockedToken[stageIndex] = 0;
277                     pi.amountTokenTaken += unlockedToken;
278 
279                     amountTokenIssued += unlockedToken;
280 
281                     token.transferFrom(tokenHolder, purchaser, unlockedToken);
282                     UnlockToken(purchaser, unlockedToken);
283                 }
284             }
285         }//for
286 
287     }
288 
289 }
290 
291 
292 contract FairGameCrowdSale is CrowdSale {
293     function FairGameCrowdSale(address beneficiaryAddr, address tokenHolderAddr, address tokenAddr)
294         CrowdSale(beneficiaryAddr, tokenHolderAddr, tokenAddr, 10000) public {
295 
296     }
297 
298     function _initStages() internal {
299         delete icoStages;
300 
301         icoStages.push(Stage({rate: 20, duration: 1 hours}));
302         icoStages.push(Stage({rate: 10, duration: 1 hours}));
303         icoStages.push(Stage({rate: 0,  duration: 1 hours}));
304 
305 
306         delete lockStages;
307 
308         lockStages.push(Stage({rate: 33, duration: 30 seconds}));
309         lockStages.push(Stage({rate: 33, duration: 30 seconds}));
310         lockStages.push(Stage({rate: 34, duration: 30 seconds}));
311     }
312 }