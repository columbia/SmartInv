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
22     
23    function transfer(address _to, uint256 _value) external;
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
52     
53     address oracle;
54     
55     function setOracle(address a) public  onlyOwner {
56         
57         oracle = a;
58     }
59 }
60 
61 interface IOracle {
62     function  ask (uint8 typeSN, string calldata idPost,string calldata idUser, bytes32 idRequest) external;
63 }
64 
65 
66 contract campaign is oracleClient {
67     
68     struct cpRatio {
69         uint256 likeRatio;
70         uint256 shareRatio;
71         uint256 viewRatio;
72     }
73     
74     struct Campaign {
75 		address advertiser;
76 		string dataUrl; 
77 		uint64 startDate;
78 		uint64 endDate;
79 		uint64 nbProms;
80 		uint64 nbValidProms;
81 		mapping (uint64 => bytes32) proms;
82 		Fund funds;
83 		mapping(uint8 => cpRatio) ratios;
84 	}
85 	
86 	
87 	struct Fund {
88 	    address token;
89 	    uint256 amount;
90 	}
91 	
92 	struct Result  {
93 	    bytes32 idProm;
94 	    uint64 likes;
95 	    uint64 shares;
96 	    uint64 views;
97 	}
98 	
99 	struct promElement {
100 	    address influencer;
101 	    bytes32 idCampaign;
102 	    bool isAccepted;
103 	    Fund funds;
104 	    uint8 typeSN;
105 	    string idPost;
106 	    string idUser;
107 	    uint64 nbResults;
108 	    mapping (uint64 => bytes32) results;
109 	    bytes32 prevResult;
110 	}
111 
112 	
113 	mapping (bytes32  => Campaign) public campaigns;
114 	mapping (bytes32  => promElement) public proms;
115 	mapping (bytes32  => Result) public results;
116 	mapping (bytes32 => bool) public isAlreadyUsed;
117 	
118 	
119 	event CampaignCreated(bytes32 indexed id,uint64 startDate,uint64 endDate,string dataUrl);
120 	event CampaignFundsSpent(bytes32 indexed id );
121 	event CampaignApplied(bytes32 indexed id ,bytes32 indexed prom );
122 	
123     
124     function createCampaign(string memory dataUrl,	uint64 startDate,uint64 endDate) public returns (bytes32 idCampaign) {
125         require(startDate > now);
126         require(endDate > now);
127         require(endDate > startDate);
128        
129         bytes32 campaignId = keccak256(abi.encodePacked(msg.sender,dataUrl,startDate,endDate,now));
130         campaigns[campaignId] = Campaign(msg.sender,dataUrl,startDate,endDate,0,0,Fund(address(0),0));
131         emit CampaignCreated(campaignId,startDate,endDate,dataUrl);
132         return campaignId;
133     }
134     
135     
136     
137     function modCampaign(bytes32 idCampaign,string memory dataUrl,	uint64 startDate,uint64 endDate) public {
138         require(campaigns[idCampaign].advertiser == msg.sender);
139         require(campaigns[idCampaign].startDate > now);
140         require(startDate > now);
141         require(endDate > now);
142         require(endDate > startDate);
143        
144         campaigns[idCampaign].dataUrl = dataUrl;
145         campaigns[idCampaign].startDate = startDate;
146         campaigns[idCampaign].endDate = endDate;
147         emit CampaignCreated(idCampaign,startDate,endDate,dataUrl);
148     }
149     
150      function priceRatioCampaign(bytes32 idCampaign,uint8 typeSN,uint256 likeRatio,uint256 shareRatio,uint256 viewRatio) public {
151         require(campaigns[idCampaign].advertiser == msg.sender);
152         require(campaigns[idCampaign].startDate > now);
153         campaigns[idCampaign].ratios[typeSN] = cpRatio(likeRatio,shareRatio,viewRatio);
154     }
155     
156   
157     
158     function fundCampaign (bytes32 idCampaign,address token,uint256 amount) public {
159         require(campaigns[idCampaign].endDate > now);
160         require(campaigns[idCampaign].funds.token == address(0) || campaigns[idCampaign].funds.token == token);
161        
162         IERC20 erc20 = IERC20(token);
163         erc20.transferFrom(msg.sender,address(this),amount);
164         uint256 prev_amount = campaigns[idCampaign].funds.amount;
165         
166         campaigns[idCampaign].funds = Fund(token,amount+prev_amount);
167       
168     }
169     
170     function createPriceFundYt(string memory dataUrl,uint64 startDate,uint64 endDate,uint256 likeRatio,uint256 viewRatio,address token,uint256 amount) public returns (bytes32 idCampaign) {
171         bytes32 campaignId = createCampaign(dataUrl,startDate,endDate);
172         priceRatioCampaign(campaignId,2,likeRatio,0,viewRatio);
173         fundCampaign(campaignId,token,amount);
174         return campaignId;
175     }
176     
177     function applyCampaign(bytes32 idCampaign,uint8 typeSN, string memory idPost, string memory idUser) public returns (bytes32 idProm) {
178         bytes32 prom = keccak256(abi.encodePacked(typeSN,idPost,idUser));
179         require(campaigns[idCampaign].endDate > now);
180         require(!isAlreadyUsed[prom]);
181         idProm = keccak256(abi.encodePacked( msg.sender,typeSN,idPost,idUser,now));
182         proms[idProm] = promElement(msg.sender,idCampaign,false,Fund(address(0),0),typeSN,idPost,idUser,0,0);
183         campaigns[idCampaign].proms[campaigns[idCampaign].nbProms++] = idProm;
184         
185         bytes32 idRequest = keccak256(abi.encodePacked(typeSN,idPost,idUser,now));
186         results[idRequest] = Result(idProm,0,0,0);
187         proms[idProm].results[0] = proms[idProm].prevResult = idRequest;
188         proms[idProm].nbResults = 1;
189         
190         //ask(typeSN,idPost,idUser,idRequest);
191         
192         isAlreadyUsed[prom] = true;
193         
194         emit CampaignApplied(idCampaign,idProm);
195         return idProm;
196     }
197     
198     function validateProm(bytes32 idProm) public {
199         Campaign storage cmp = campaigns[proms[idProm].idCampaign];
200         require(cmp.endDate > now);
201         require(cmp.advertiser == msg.sender);
202         proms[idProm].isAccepted = true;
203         cmp.nbValidProms++;
204     }
205     
206     
207     function startCampaign(bytes32 idCampaign) public  {
208          require(campaigns[idCampaign].advertiser == msg.sender || msg.sender == owner );
209          require(campaigns[idCampaign].startDate > now);
210          campaigns[idCampaign].startDate = uint64(now);
211     }
212     
213     function updateCampaignStats(bytes32 idCampaign) public onlyOwner {
214         for(uint64 i = 0;i < campaigns[idCampaign].nbProms ;i++)
215         {
216             bytes32 idProm = campaigns[idCampaign].proms[i];
217             if(proms[idProm].isAccepted) {
218                 bytes32 idRequest = keccak256(abi.encodePacked(proms[idProm].typeSN,proms[idProm].idPost,proms[idProm].idUser,now));
219                 results[idRequest] = Result(idProm,0,0,0);
220                 proms[idProm].results[proms[idProm].nbResults++] = idRequest;
221                 ask(proms[idProm].typeSN,proms[idProm].idPost,proms[idProm].idUser,idRequest);
222             }
223         }
224     }
225     
226     function endCampaign(bytes32 idCampaign) public  {
227         require(campaigns[idCampaign].endDate > now);
228         require(campaigns[idCampaign].advertiser == msg.sender || msg.sender == owner );
229         campaigns[idCampaign].endDate = uint64(now);
230     }
231     
232     
233     function ask(uint8 typeSN, string memory idPost,string memory idUser,bytes32 idRequest) public {
234         IOracle o = IOracle(oracle);
235         o.ask(typeSN,idPost,idUser,idRequest);
236     }
237     
238     
239     function update(bytes32 idRequest,uint64 likes,uint64 shares,uint64 views) external  returns (bool ok) {
240         require(msg.sender == oracle);
241        
242         results[idRequest].likes = likes;
243         results[idRequest].shares = shares;
244         results[idRequest].views = views;
245         promElement storage prom = proms[results[idRequest].idProm];
246         uint256 gain = 0;
247         
248   
249         gain = (likes - results[prom.prevResult].likes)* campaigns[prom.idCampaign].ratios[prom.typeSN].likeRatio;
250         gain += (shares - results[prom.prevResult].shares)* campaigns[prom.idCampaign].ratios[prom.typeSN].shareRatio;
251         gain += (views - results[prom.prevResult].views)* campaigns[prom.idCampaign].ratios[prom.typeSN].viewRatio;
252         prom.prevResult = idRequest;
253         
254         //
255         // warn campaign low credits
256         //
257        
258        
259         if(prom.funds.token == address(0))
260         {
261             prom.funds.token = campaigns[prom.idCampaign].funds.token;
262         }
263         if(campaigns[prom.idCampaign].funds.amount <= gain )
264         {
265             campaigns[prom.idCampaign].endDate = uint64(now);
266             prom.funds.amount += campaigns[prom.idCampaign].funds.amount;
267             campaigns[prom.idCampaign].funds.amount = 0;
268             emit CampaignFundsSpent(prom.idCampaign);
269             return true;
270         }
271         campaigns[prom.idCampaign].funds.amount -= gain;
272         prom.funds.amount += gain;
273         return true;
274     }
275     
276     function getGains(bytes32 idProm) public {
277         require(proms[idProm].influencer == msg.sender);
278         IERC20 erc20 = IERC20(proms[idProm].funds.token);
279         uint256 amount = proms[idProm].funds.amount;
280         proms[idProm].funds.amount = 0;
281         erc20.transfer(proms[idProm].influencer,amount);
282         
283     }
284     
285     function getRemainingFunds(bytes32 idCampaign) public {
286         require(campaigns[idCampaign].advertiser == msg.sender);
287         require(campaigns[idCampaign].endDate < now);
288         IERC20 erc20 = IERC20(campaigns[idCampaign].funds.token);
289         uint256 amount = campaigns[idCampaign].funds.amount;
290         campaigns[idCampaign].funds.amount = 0;
291         erc20.transfer(campaigns[idCampaign].advertiser,amount);
292     }
293     
294     function getProms (bytes32 idCampaign) public view returns (bytes32[] memory cproms)
295     {
296         uint nbProms = campaigns[idCampaign].nbProms;
297         cproms = new bytes32[](nbProms);
298         
299         for (uint64 i = 0;i<nbProms;i++)
300         {
301             cproms[i] = campaigns[idCampaign].proms[i];
302         }
303         return cproms;
304     }
305     
306     function getRatios (bytes32 idCampaign) public view returns (uint8[] memory types,uint256[] memory likeRatios,uint256[] memory shareRatios,uint256[] memory viewRatios )
307     {   
308         types = new uint8[](4);
309         likeRatios = new uint256[](4);
310         shareRatios = new uint256[](4);
311         viewRatios = new uint256[](4);
312         for (uint8 i = 0;i<4;i++)
313         {
314             types[i] = i+1;
315             likeRatios[i] = campaigns[idCampaign].ratios[i+1].likeRatio;
316             shareRatios[i] = campaigns[idCampaign].ratios[i+1].shareRatio;
317             viewRatios[i] = campaigns[idCampaign].ratios[i+1].viewRatio;
318         }
319         return (types,likeRatios,shareRatios,viewRatios);
320     }
321     
322     
323     function getResults (bytes32 idProm) public view returns (bytes32[] memory creq)
324     {
325         uint nbResults = proms[idProm].nbResults;
326         creq = new bytes32[](nbResults);
327         for (uint64 i = 0;i<nbResults;i++)
328         {
329             creq[i] = proms[idProm].results[i];
330         }
331         return creq;
332     }
333     
334     function getIsUsed(uint8 typeSN, string memory idPost, string memory idUser) public view returns (bool) {
335         bytes32 prom = keccak256(abi.encodePacked(typeSN,idPost,idUser));
336         return isAlreadyUsed[prom];
337     }
338     
339     
340 }