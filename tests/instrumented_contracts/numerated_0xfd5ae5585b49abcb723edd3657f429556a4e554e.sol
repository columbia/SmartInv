1 pragma solidity ^0.5;
2 pragma experimental ABIEncoderV2;
3 
4 contract owned {
5     address payable public owner;
6 
7     constructor () public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address payable newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 interface IERC20 {
22    function transfer(address _to, uint256 _value) external;
23    
24    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
25 }
26 
27 contract ERC20Holder is owned {
28     mapping (address => bool) acceptedTokens;
29     function modToken(address token,bool accepted) public onlyOwner {
30         acceptedTokens[token] = accepted;
31     }
32     
33     function tokenFallback(address _from, uint _value, bytes memory _data) pure public returns (bytes32 hash) {
34         bytes32 tokenHash = keccak256(abi.encodePacked(_from,_value,_data));
35         return tokenHash;
36     }
37     
38     function() external  payable {}
39     
40     function withdraw() onlyOwner public {
41         owner.transfer(address(this).balance);
42     }
43     
44     function transferToken (address token,address to,uint256 val) public onlyOwner {
45         IERC20 erc20 = IERC20(token);
46         erc20.transfer(to,val);
47     }
48     
49 }
50 
51 contract oracleClient is ERC20Holder {
52     address oracle;
53     
54     function setOracle(address a) public  onlyOwner {
55         
56         oracle = a;
57     }
58 }
59 
60 interface IOracle {
61     function  ask (uint8 typeSN, string calldata idPost,string calldata idUser, bytes32 idRequest) external;
62 }
63 
64 
65 contract campaign is oracleClient {
66     
67     enum status {NotExists,Prepared,Validated,Running,Ended}
68     enum promStatus {NotExists,Inited,Validated,Rejected,Paid}
69     enum RewardType {None,Ratio,Reach}
70     
71     struct cpRatio {
72         uint256 likeRatio;
73         uint256 shareRatio;
74         uint256 viewRatio;
75     }
76     
77     struct Reach {
78         uint256 likeReach;
79         uint256 shareReach;
80         uint256 viewReach;
81         uint256 reward;
82     }
83     
84     struct Campaign {
85 		address advertiser;
86 		string dataUrl; // IPFS link hosted by us
87 		uint64 startDate;
88 		uint64 endDate;
89 		status campaignState;
90 		RewardType rewardType;
91 		uint64 nbProms;
92 		uint64 nbValidProms;
93 		mapping (uint64 => bytes32) proms;
94 		Fund funds;
95 		mapping(uint8 => cpRatio) ratios;
96 		mapping(uint8 => Reach) reachs;
97 		uint256 reserve;
98 	}
99 	
100 	
101 	struct Fund {
102 	    address token;
103 	    uint256 amount;
104 	}
105 	
106 	struct Result  {
107 	    bytes32 idProm;
108 	    uint64 likes;
109 	    uint64 shares;
110 	    uint64 views;
111 	}
112 	
113 	struct promElement {
114 	    address influencer;
115 	    bytes32 idCampaign;
116 	    Fund funds;
117 	    promStatus status;
118 	    uint8 typeSN;
119 	    string idPost;
120 	    string idUser;
121 	    uint64 nbResults;
122 	    mapping (uint64 => bytes32) results;
123 	    bytes32 prevResult;
124 	}
125 
126 	
127 	mapping (bytes32  => Campaign) public campaigns;
128 	mapping (bytes32  => promElement) public proms;
129 	mapping (bytes32  => Result) public results;
130 	mapping (bytes32 => bool) public isAlreadyUsed;
131 	
132 	
133 	event CampaignCreated(bytes32 indexed id,uint64 startDate,uint64 endDate,string dataUrl,uint8 rewardType);
134 	event CampaignStarted(bytes32 indexed id );
135 	event CampaignEnded(bytes32 indexed id );
136 	event CampaignFundsSpent(bytes32 indexed id );
137 	event CampaignApplied(bytes32 indexed id ,bytes32 indexed prom );
138 	
139 	event OracleResult( bytes32 idRequest,uint64 likes,uint64 shares,uint64 views);
140 	
141 	
142     
143     function createCampaign(string memory dataUrl,	uint64 startDate,uint64 endDate,uint8 reward) public returns (bytes32 idCampaign) {
144         require(startDate > now);
145         require(endDate > now);
146         require(endDate > startDate);
147         require(reward > 0 && reward < 3);
148         bytes32 campaignId = keccak256(abi.encodePacked(msg.sender,dataUrl,startDate,endDate,now));
149         campaigns[campaignId] = Campaign(msg.sender,dataUrl,startDate,endDate,status.Prepared,RewardType(reward),0,0,Fund(address(0),0),0);
150         emit CampaignCreated(campaignId,startDate,endDate,dataUrl,reward);
151         return campaignId;
152     }
153     
154     
155     
156     function modCampaign(bytes32 idCampaign,string memory dataUrl,	uint64 startDate,uint64 endDate,uint8 reward) public {
157         require(campaigns[idCampaign].advertiser == msg.sender);
158         require(startDate > now);
159         require(endDate > now);
160         require(endDate > startDate);
161         require(campaigns[idCampaign].campaignState == status.Prepared);
162         require(reward > 0 && reward < 3);
163         campaigns[idCampaign].dataUrl = dataUrl;
164         campaigns[idCampaign].startDate = startDate;
165         campaigns[idCampaign].endDate = endDate;
166         campaigns[idCampaign].rewardType = RewardType(reward);
167         emit CampaignCreated(idCampaign,startDate,endDate,dataUrl,reward);
168     }
169     
170      function priceRatioCampaign(bytes32 idCampaign,uint8 typeSN,uint256 likeRatio,uint256 shareRatio,uint256 viewRatio) public {
171         require(campaigns[idCampaign].advertiser == msg.sender);
172         require(campaigns[idCampaign].campaignState == status.Prepared);
173         require(campaigns[idCampaign].rewardType == RewardType.Ratio);
174         campaigns[idCampaign].ratios[typeSN] = cpRatio(likeRatio,shareRatio,viewRatio);
175     }
176     
177     function priceReachCampaign(bytes32 idCampaign,uint8 typeSN,uint256 likeReach,uint256 shareReach,uint256 viewReach,uint256 rewardAmount) public {
178         require(campaigns[idCampaign].advertiser == msg.sender);
179         require(campaigns[idCampaign].campaignState == status.Prepared);
180         require(campaigns[idCampaign].rewardType == RewardType.Reach);
181         campaigns[idCampaign].reachs[typeSN] = Reach(likeReach,shareReach,viewReach,rewardAmount);
182     }
183     
184     function fundCampaign (bytes32 idCampaign,address token,uint256 amount) public {
185         require(campaigns[idCampaign].campaignState == status.Prepared || campaigns[idCampaign].campaignState == status.Running);
186         require(campaigns[idCampaign].funds.token == address(0) || campaigns[idCampaign].funds.token == token);
187        
188         IERC20 erc20 = IERC20(token);
189         erc20.transferFrom(msg.sender,address(this),amount);
190         uint256 prev_amount = campaigns[idCampaign].funds.amount;
191         
192         campaigns[idCampaign].funds = Fund(token,amount+prev_amount);
193         campaigns[idCampaign].reserve += amount;
194     }
195     
196     function createPriceFundYt(string memory dataUrl,uint64 startDate,uint64 endDate,uint256 likeRatio,uint256 viewRatio,address token,uint256 amount) public returns (bytes32 idCampaign) {
197         bytes32 campaignId = createCampaign(dataUrl,startDate,endDate,1);
198         priceRatioCampaign(campaignId,2,likeRatio,0,viewRatio);
199         fundCampaign(campaignId,token,amount);
200         return campaignId;
201     }
202     
203     function applyCampaign(bytes32 idCampaign,uint8 typeSN, string memory idPost, string memory idUser) public returns (bytes32 idProm) {
204         bytes32 prom = keccak256(abi.encodePacked(typeSN,idPost,idUser));
205         require(campaigns[idCampaign].campaignState == status.Prepared || campaigns[idCampaign].campaignState == status.Running);
206         require(!isAlreadyUsed[prom]);
207         idProm = keccak256(abi.encodePacked( msg.sender,typeSN,idPost,idUser,now));
208         proms[idProm] = promElement(msg.sender,idCampaign,Fund(address(0),0),promStatus.NotExists,typeSN,idPost,idUser,0,0);
209         campaigns[idCampaign].proms[campaigns[idCampaign].nbProms++] = idProm;
210         
211         bytes32 idRequest = keccak256(abi.encodePacked(typeSN,idPost,idUser,now));
212         results[idRequest] = Result(idProm,0,0,0);
213         proms[idProm].results[0] = proms[idProm].prevResult = idRequest;
214         proms[idProm].nbResults = 1;
215         
216         //ask(typeSN,idPost,idUser,idRequest);
217         
218         isAlreadyUsed[prom] = true;
219         
220         emit CampaignApplied(idCampaign,idProm);
221         return idProm;
222     }
223     
224     function validateProm(bytes32 idCampaign,bytes32 idProm,bool accepted) public {
225         require(campaigns[idCampaign].campaignState == status.Prepared || campaigns[idCampaign].campaignState == status.Running);
226         require(campaigns[idCampaign].advertiser == msg.sender);
227         require(proms[idProm].idCampaign == idCampaign);
228         
229         if(accepted)
230         {
231             proms[idProm].status = promStatus.Validated;
232             campaigns[idCampaign].nbValidProms++;
233         }
234         else
235             proms[idProm].status = promStatus.Rejected;
236         
237         if(campaigns[idCampaign].rewardType == RewardType.Reach)
238         {
239             uint256 amount = campaigns[idCampaign].reachs[proms[idProm].typeSN].reward;
240             require(campaigns[idCampaign].reserve > amount);
241             campaigns[idCampaign].reserve -= amount;
242         }
243         
244     }
245     
246     
247     function startCampaign(bytes32 idCampaign) public  {
248          require(campaigns[idCampaign].advertiser == msg.sender || msg.sender == owner );
249          require(campaigns[idCampaign].campaignState == status.Prepared);
250          campaigns[idCampaign].campaignState = status.Running;
251          campaigns[idCampaign].startDate = uint32(now);
252          emit CampaignStarted(idCampaign);
253     }
254     
255     function updateCampaignStats(bytes32 idCampaign) public onlyOwner {
256         require(campaigns[idCampaign].campaignState == status.Running);
257         for(uint64 i = 0;i < campaigns[idCampaign].nbProms ;i++)
258         {
259             bytes32 idProm = campaigns[idCampaign].proms[i];
260             if(proms[idProm].status == promStatus.Validated ) {
261                 bytes32 idRequest = keccak256(abi.encodePacked(proms[idProm].typeSN,proms[idProm].idPost,proms[idProm].idUser,now));
262                 results[idRequest] = Result(idProm,0,0,0);
263                 proms[idProm].results[proms[idProm].nbResults++] = idRequest;
264                 ask(proms[idProm].typeSN,proms[idProm].idPost,proms[idProm].idUser,idRequest);
265             }
266         }
267     }
268     
269     function endCampaign(bytes32 idCampaign) public  {
270         require(campaigns[idCampaign].campaignState == status.Running);
271         if(campaigns[idCampaign].rewardType == RewardType.Reach) {
272             require(msg.sender == owner );
273         }
274         require(campaigns[idCampaign].advertiser == msg.sender || msg.sender == owner );
275         campaigns[idCampaign].campaignState = status.Ended;
276         campaigns[idCampaign].endDate = uint32(now);
277         emit CampaignEnded(idCampaign);
278     }
279     
280     
281     function ask(uint8 typeSN, string memory idPost,string memory idUser,bytes32 idRequest) public {
282         IOracle o = IOracle(oracle);
283         o.ask(typeSN,idPost,idUser,idRequest);
284     }
285     
286     
287     function update(bytes32 idRequest,uint64 likes,uint64 shares,uint64 views) external  returns (bool ok) {
288         require(msg.sender == oracle);
289         emit OracleResult(idRequest,likes,shares,views);
290         results[idRequest].likes = likes;
291         results[idRequest].shares = shares;
292         results[idRequest].views = views;
293         promElement storage prom = proms[results[idRequest].idProm];
294         uint256 gain = 0;
295         
296         if(campaigns[prom.idCampaign].rewardType == RewardType.Ratio)
297         {
298             gain = (likes - results[prom.prevResult].likes)* campaigns[prom.idCampaign].ratios[prom.typeSN].likeRatio;
299             gain += (shares - results[prom.prevResult].shares)* campaigns[prom.idCampaign].ratios[prom.typeSN].shareRatio;
300             gain += (views - results[prom.prevResult].views)* campaigns[prom.idCampaign].ratios[prom.typeSN].viewRatio;
301             prom.prevResult = idRequest;
302             //
303             // warn campaign low credits
304             //
305         }
306         /*if(campaigns[prom.idCampaign].rewardType == RewardType.Reach)
307         {
308             uint64 likesDiff = likes - results[prom.prevResult].likes;
309             uint64 sharesDiff = shares - results[prom.prevResult].shares;
310             uint64 viewsDiff = views - results[prom.prevResult].views;
311             
312             if(campaigns[prom.idCampaign].reachs[prom.typeSN].likeReach > 0 )
313             {
314                 if( campaigns[prom.idCampaign].reachs[prom.typeSN].likeReach <= likesDiff )
315                 {
316                     gain = campaigns[prom.idCampaign].reachs[prom.typeSN].reward;
317                 }
318             }
319             if(campaigns[prom.idCampaign].reachs[prom.typeSN].shareReach > 0 )
320             {
321                 if( campaigns[prom.idCampaign].reachs[prom.typeSN].shareReach <= sharesDiff )
322                 {
323                     gain = campaigns[prom.idCampaign].reachs[prom.typeSN].reward;
324                 }
325             }
326             if(campaigns[prom.idCampaign].reachs[prom.typeSN].viewReach > 0 )
327             {
328                 if( campaigns[prom.idCampaign].reachs[prom.typeSN].viewReach <= viewsDiff )
329                 {
330                     gain = campaigns[prom.idCampaign].reachs[prom.typeSN].reward;
331                 }
332             }
333             prom.status = promStatus.Paid;
334             
335         }*/
336         
337         if(prom.funds.token == address(0))
338         {
339             prom.funds.token = campaigns[prom.idCampaign].funds.token;
340         }
341         if(campaigns[prom.idCampaign].funds.amount <= gain )
342         {
343             campaigns[prom.idCampaign].campaignState = status.Ended;
344             prom.funds.amount += campaigns[prom.idCampaign].funds.amount;
345             campaigns[prom.idCampaign].funds.amount = 0;
346             emit CampaignEnded(prom.idCampaign);
347             emit CampaignFundsSpent(prom.idCampaign);
348             return true;
349         }
350         campaigns[prom.idCampaign].funds.amount -= gain;
351         prom.funds.amount += gain;
352         return true;
353     }
354     
355     function getGains(bytes32 idProm) public {
356         require(proms[idProm].influencer == msg.sender);
357         IERC20 erc20 = IERC20(proms[idProm].funds.token);
358         uint256 amount = proms[idProm].funds.amount;
359         proms[idProm].funds.amount = 0;
360         erc20.transfer(proms[idProm].influencer,amount);
361         
362     }
363     
364     function getRemainingFunds(bytes32 idCampaign) public {
365         require(campaigns[idCampaign].advertiser == msg.sender);
366         require(campaigns[idCampaign].rewardType != RewardType.Reach || campaigns[idCampaign].campaignState != status.Running);
367         IERC20 erc20 = IERC20(campaigns[idCampaign].funds.token);
368         uint256 amount = campaigns[idCampaign].funds.amount;
369         campaigns[idCampaign].funds.amount = 0;
370         erc20.transfer(campaigns[idCampaign].advertiser,amount);
371     }
372     
373     function getProms (bytes32 idCampaign) public view returns (bytes32[] memory cproms)
374     {
375         uint nbProms = campaigns[idCampaign].nbProms;
376         cproms = new bytes32[](nbProms);
377         
378         for (uint64 i = 0;i<nbProms;i++)
379         {
380             cproms[i] = campaigns[idCampaign].proms[i];
381         }
382         return cproms;
383     }
384     
385     function getRatios (bytes32 idCampaign) public view returns (uint8[] memory types,uint256[] memory likeRatios,uint256[] memory shareRatios,uint256[] memory viewRatios )
386     {   
387         types = new uint8[](4);
388         likeRatios = new uint256[](4);
389         shareRatios = new uint256[](4);
390         viewRatios = new uint256[](4);
391         for (uint8 i = 0;i<4;i++)
392         {
393             types[i] = i+1;
394             likeRatios[i] = campaigns[idCampaign].ratios[i+1].likeRatio;
395             shareRatios[i] = campaigns[idCampaign].ratios[i+1].shareRatio;
396             viewRatios[i] = campaigns[idCampaign].ratios[i+1].viewRatio;
397         }
398         return (types,likeRatios,shareRatios,viewRatios);
399     }
400     
401      function getReachs (bytes32 idCampaign) public view returns (uint8[] memory typesR,uint256[] memory likeReach,uint256[] memory shareReach,uint256[] memory viewReach,uint256[] memory rewardAmount )
402     {   
403         typesR = new uint8[](4);
404         likeReach = new uint256[](4);
405         shareReach = new uint256[](4);
406         viewReach = new uint256[](4);
407         for (uint8 i = 0;i<4;i++)
408         {
409             typesR[i] = i+1;
410             likeReach[i] = campaigns[idCampaign].reachs[i+1].likeReach;
411             shareReach[i] = campaigns[idCampaign].reachs[i+1].shareReach;
412             viewReach[i] = campaigns[idCampaign].reachs[i+1].viewReach;
413             rewardAmount[i] = campaigns[idCampaign].reachs[i+1].reward;
414         }
415         return (typesR,likeReach,shareReach,viewReach,rewardAmount);
416     }
417     
418     function getResults (bytes32 idProm) public view returns (bytes32[] memory creq)
419     {
420         uint nbResults = proms[idProm].nbResults;
421         creq = new bytes32[](nbResults);
422         for (uint64 i = 0;i<nbResults;i++)
423         {
424             creq[i] = proms[idProm].results[i];
425         }
426         return creq;
427     }
428     
429 }