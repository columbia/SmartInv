1 pragma solidity ^0.4.23;
2 
3 contract IERC223Token {
4     function name() public view returns (string);
5     function symbol() public view returns (string);
6     function decimals() public view returns (uint8);
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address _holder) public view returns (uint256);
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
12     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
13     
14     event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
15 }
16 
17 contract IERC223Receiver {
18   
19    /**
20  * @dev Standard ERC223 function that will handle incoming token transfers.
21  *
22  * @param _from  Token sender address.
23  * @param _value Amount of tokens.
24  * @param _data  Transaction metadata.
25  */
26     function tokenFallback(address _from, uint _value, bytes _data) public returns(bool);
27 }
28 
29 contract IOwned {
30     // this function isn't abstract since the compiler emits automatically generated getter functions as external
31     function owner() public pure returns (address) {}
32 
33     event OwnerUpdate(address _prevOwner, address _newOwner);
34 
35     function transferOwnership(address _newOwner) public;
36     function acceptOwnership() public;
37 }
38 
39 contract ICalled is IOwned {
40     // this function isn't abstract since the compiler emits automatically generated getter functions as external
41     function callers(address) public pure returns (bool) { }
42 
43     function appendCaller(address _caller) public;  // ownerOnly
44     function removeCaller(address _caller) public;  // ownerOnly
45     
46     event AppendCaller(ICaller _caller);
47     event RemoveCaller(ICaller _caller);
48 }
49 
50 contract ICaller{
51 	function calledUpdate(address _oldCalled, address _newCalled) public;  // ownerOnly
52 	
53 	event CalledUpdate(address _oldCalled, address _newCalled);
54 }
55 
56 contract IERC20Token {
57     function name() public view returns (string);
58     function symbol() public view returns (string);
59     function decimals() public view returns (uint8);
60     function totalSupply() public view returns (uint256);
61     function balanceOf(address _holder) public view returns (uint256);
62     function allowance(address _from, address _spender) public view returns (uint256);
63 
64     function transfer(address _to, uint256 _value) public returns (bool success);
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
66     function approve(address _spender, uint256 _value) public returns (bool success);
67     
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _holder, address indexed _spender, uint256 _value);
70 }
71 
72 contract IDummyToken is IERC20Token, IERC223Token, IERC223Receiver, ICaller, IOwned{
73     // these function isn't abstract since the compiler emits automatically generated getter functions as external
74     function operator() public pure returns(ITokenOperator) {}
75     //ITokenOperator public operator;
76 }
77 
78 contract ISmartToken{
79     function disableTransfers(bool _disable) public;
80     function issue(address _to, uint256 _amount) public;
81     function destroy(address _from, uint256 _amount) public;
82 	//function() public payable;
83 }
84 
85 contract ITokenOperator is ISmartToken, ICalled, ICaller {
86     // this function isn't abstract since the compiler emits automatically generated getter functions as external
87     function dummy() public pure returns (IDummyToken) {}
88     
89 	function emitEventTransfer(address _from, address _to, uint256 _amount) public;
90 
91     function updateChanges(address) public;
92     function updateChangesByBrother(address, uint256, uint256) public;
93     
94     function token_name() public view returns (string);
95     function token_symbol() public view returns (string);
96     function token_decimals() public view returns (uint8);
97     
98     function token_totalSupply() public view returns (uint256);
99     function token_balanceOf(address _owner) public view returns (uint256);
100     function token_allowance(address _from, address _spender) public view returns (uint256);
101 
102     function token_transfer(address _from, address _to, uint256 _value) public returns (bool success);
103     function token_transfer(address _from, address _to, uint _value, bytes _data) public returns (bool success);
104     function token_transfer(address _from, address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success);
105     function token_transferFrom(address _spender, address _from, address _to, uint256 _value) public returns (bool success);
106     function token_approve(address _from, address _spender, uint256 _value) public returns (bool success);
107     
108     function fallback(address _from, bytes _data) public payable;                      		// eth input
109     function token_fallback(address _token, address _from, uint _value, bytes _data) public returns(bool);    // token input from IERC233
110 }
111 
112 contract IsContract {
113 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
114     function isContract(address _addr) internal view returns (bool is_contract) {
115         uint length;
116         assembly {
117               //retrieve the size of the code on target address, this needs assembly
118               length := extcodesize(_addr)
119         }
120         return (length>0);
121     }
122 }
123 
124 contract Owned is IOwned {
125     address public owner;
126     address public newOwner;
127 
128     /**
129         @dev constructor
130     */
131     constructor() public {
132         owner = msg.sender;
133     }
134 
135     // allows execution by the owner only
136     modifier ownerOnly {
137         assert(msg.sender == owner);
138         _;
139     }
140 
141     /**
142         @dev allows transferring the contract ownership
143         the new owner still needs to accept the transfer
144         can only be called by the contract owner
145 
146         @param _newOwner    new contract owner
147     */
148     function transferOwnership(address _newOwner) public ownerOnly {
149         require(_newOwner != owner);
150         newOwner = _newOwner;
151     }
152 
153     /**
154         @dev used by a new owner to accept an ownership transfer
155     */
156     function acceptOwnership() public {
157         require(msg.sender == newOwner);
158         emit OwnerUpdate(owner, newOwner);
159         owner = newOwner;
160         newOwner = address(0x0);
161     }
162 }
163 
164 contract Constant {
165 	bytes32 internal constant _$FM_							= "$FM";
166 	bytes32 internal constant _$FM2_						= "$FM2";
167 	bytes32 internal constant _$FI_							= "$FI";
168 	bytes32 internal constant _$FO_							= "$FO";
169 	bytes32 internal constant _$FD_							= "$FD";
170 	bytes32 internal constant _$FD2_						= "$FD2";
171 	bytes32 internal constant _$F_							= "$F";
172 	bytes32 internal constant _$F2R_						= "$F2R";
173 	bytes32 internal constant _$FR_							= "$FR";
174 	bytes32 internal constant _ETHER_						= "ETHER";//EtherToken will be registered to Data in XCoin.js => registerContract
175 	bytes32 internal constant _Eventer_						= "Eventer";//Eventer will be registered to Data in XCoin.js => registerContract
176 	
177 	bytes32 internal constant _$FOD_						= "$FOD";
178 	bytes32 internal constant _totalSupply_					= "totalSupply";
179 	bytes32 internal constant _balanceOf_					= "balanceOf";
180 	bytes32 internal constant _lastTime_					= "lastTime";
181 	bytes32 internal constant _factorDrawLots_				= "factorDrawLots";
182 	bytes32 internal constant _eraDrawLots_					= "eraDrawLots";
183 	//bytes32 internal constant _drawLots_					= "drawLots";
184 	
185 	bytes32 internal constant _weightIssue_					= "weightIssue";
186 	bytes32 internal constant _privatePlacing_				= "privatePlacing";
187 	bytes32 internal constant _priceInit_					= "priceInit";
188 	bytes32 internal constant _softCap_						= "softCap";
189 	bytes32 internal constant _ratioGiftMax_				= "ratioGiftMax";
190 	bytes32 internal constant _weightOfReserve_				= "weightOfReserve";
191 	bytes32 internal constant _weightOfTarget_				= "weightOfTarget";
192 	bytes32 internal constant _decelerationRatioDividend_	= "decelerationRatioDividend";
193 	bytes32 internal constant _ratioDividend_				= "ratioDividend";
194 	bytes32 internal constant _investmentSF_				= "investmentSF";
195 	bytes32 internal constant _investmentEth_				= "investmentEth";
196 	bytes32 internal constant _profitSF_					= "profitSF";
197 	bytes32 internal constant _profitEth_					= "profitEth";
198 	bytes32 internal constant _returnSF_					= "returnSF";
199 	bytes32 internal constant _returnEth_					= "returnEth";
200 	bytes32 internal constant _emaDailyYieldSF_				= "emaDailyYieldSF";
201 	bytes32 internal constant _emaDailyYield_				= "emaDailyYield";
202 	bytes32 internal constant _timeLastMiningSF_			= "timeLastMiningSF";
203 	bytes32 internal constant _timeLastMining_				= "timeLastMining";
204 	bytes32 internal constant _factorMining_				= "factorMining";
205 	bytes32 internal constant _projectStatus_				= "projectStatus";
206 	bytes32 internal constant _projectAddr_					= "projectAddr";
207 	bytes32 internal constant _projectID_					= "projectID";
208 	bytes32 internal constant _proposeID_					= "proposeID";
209 	bytes32 internal constant _disproposeID_				= "disproposeID";
210 	bytes32 internal constant _projects_					= "projects";
211 	bytes32 internal constant _projectsVoting_				= "projectsVoting";
212 	bytes32 internal constant _thresholdPropose_			= "thresholdPropose";
213 	bytes32 internal constant _divisorAbsent_				= "divisorAbsent";
214 	bytes32 internal constant _timePropose_					= "timePropose";
215 	bytes32 internal constant _votes_						= "votes";
216 	bytes32 internal constant _factorDividend_				= "factorDividend";
217 	bytes32 internal constant _projectIdCount_				= "projectIdCount";
218 	bytes32 internal constant _projectInfo_					= "projectInfo";
219 	bytes32 internal constant _recommenders_				= "recommenders";
220 	bytes32 internal constant _recommendations_				= "recommendations";
221 	bytes32 internal constant _rewardRecommend_				= "rewardRecommend";
222 	bytes32 internal constant _halfRewardBalanceOfRecommender_ = "halfRewardBalanceOfRecommender";
223 	bytes32 internal constant _agents_						= "agents";
224 	bytes32 internal constant _factorInvitationOfAgent_		= "factorInvitationOfAgent";
225 	bytes32 internal constant _factorPerformanceOfAgent_	=	"factorPerformanceOfAgent";
226 	bytes32 internal constant _performanceOfAgent_			= "performanceOfAgent";
227 	bytes32 internal constant _lastPerformanceOfAgent_		= "lastPerformanceOfAgent";
228 	//bytes32 internal constant _invitationOfAgentLock_		= "invitationOfAgentLock";
229 	bytes32 internal constant _invitationOfAgent_			= "invitationOfAgent";
230 	//bytes32 internal constant _lockedOfAgent_				= "lockedOfAgent";
231 	bytes32 internal constant _unlockedOfAgent_				= "unlockedOfAgent";
232     bytes32 internal constant _agentIssuable_				= "agentIssuable";
233     bytes32 internal constant _agentThreshold_              = "agentThreshold";
234     bytes32 internal constant _rewardAgent_                 = "rewardAgent";
235 	bytes32 internal constant _$FP_						    = "$FP";
236 	bytes32 internal constant _invitation_					= "invitation";
237     bytes32 internal constant _agent_						= "agent";
238 	bytes32 internal constant _channel_					    = "channel";
239 	bytes32 internal constant _channels_					= "channels";
240 	bytes32 internal constant _rewardChannel_				= "rewardChannel";
241 	bytes32 internal constant _rate0DrawLotsOrder_			= "rate0DrawLotsOrder";
242 	bytes32 internal constant _thresholdAccelDequeueOrder_	= "thresholdAccelDequeueOrder";
243 	bytes32 internal constant _periodQuotaOrder_			= "periodQuotaOrder";
244 	bytes32 internal constant _project$f_			        = "project$f";
245 	bytes32 internal constant _projectEth_			        = "projectEth";
246 	bytes32 internal constant _etherAmount_			        = "etherAmount";
247 	bytes32 internal constant _Recommend_			        = "Recommend";
248 	
249 	bytes32 internal constant _Price_						= 0xdedeab50b97b0ea258580c72638be71c84db2913f449665c5275cdb7f93c0409;	//keccak256("Price(bytes32,uint256,int256,uint256,uint256,uint256,uint256,uint256)");	
250 	// bytes32 internal constant _Weight_						= 0x3656cc39179451c68688a96cd746a26d3368cf97102e851c0c60a0bad65bfaf4;	//keccak256("Weight(bytes32,uint256,uint256,uint256,uint256,uint256,uint256,uint256)");
251 	// bytes32 internal constant _WeightIssue_					= 0xee865ae6bcc111b5853d9ac0495880f947e4aebeb181b1a6d904d58299e1cced;	//keccak256("WeightIssue(address,address,uint256,uint256,uint256,uint256)");
252 	// bytes32 internal constant _PrivatePlacement_			= 0x94eb37bbe0c54785ce84a078083aede618c2abba7d7b271e7b625ddf4d1282ee;	//keccak256("PrivatePlacement(address,address,uint256,uint256,uint256)");
253 	// bytes32 internal constant _Propose_					= 0x87ada46c836271e669e6bc9ba0bc9669495237e101c5291363d524bc8fc32568;	//keccak256("Propose(address,bytes32,bytes32,address,uint256,uint256)");
254 	// bytes32 internal constant _Dispropose_					= 0xc85e60c2ee8acdaa9f49d4541531b118e86d4018c9c2a0ff7556076a5ff01870;	//keccak256("Dispropose(address,bytes32,bytes32)");
255 	// bytes32 internal constant _UpdateProject_				= 0xa7f00da0cc536d861fb6f017f8234042f6e26699f3cd9103da6895e93c118125;	//keccak256("UpdateProject(address,bytes32,address,address)");
256 	// bytes32 internal constant _ReturnProfit_				= 0xba17bd6ee981e52122b986aa98e10567c311e15b7d6dad085bf94e896ed65e66;	//keccak256("ReturnProfit(address,bytes32,uint256,uint256)");
257 	// bytes32 internal constant _ReturnDisinvestment_			= 0x95211a7460b6a58c8ba08a59a584a7bf992e651f1c6379ed788ddefc41bee305;	//keccak256("ReturnDisinvestment(address,bytes32,uint256,uint256)");
258 	// bytes32 internal constant _RegisterRecommender_			= 0xfcb064cbe1c349ea06a55b745fcd262396cc7cdbee9589806d350b65df959bc4;	//keccak256("RegisterRecommender(address,bytes32,bool,uint256)");
259 	// bytes32 internal constant _RegisterAgent_				= 0x2afb1b2d5349ff0163b230509f92d4c12ab9854d4c76bc5f25339e2816a3d48a;	//keccak256("RegisterAgent(address,uint256,uint256)");
260 	// bytes32 internal constant _AgentAppend_					= 0x5ac70b7391396d39d0973d5ffa4bd81a1c430996801ef8c5661cc43d348c94c9;	//keccak256("AgentAppend(address,uint256,uint256)");
261 	// bytes32 internal constant _AgentLock_					= 0x12bb003ebbc79a167959a883f0e69272f5040dfc75d4b47e59fd84a803bf74a9;	//keccak256("AgentLock(address,uint256,uint256)");
262 	// bytes32 internal constant _IssueInvitationOfAgent_		= 0x03ffb74238869c35f07683aa632e0c375c3a24a1c57eb9d4c98c2aa7ec703ff7;	//keccak256("IssueInvitationOfAgent(address,uint256)");
263 	// bytes32 internal constant _AgentUnlock_					= 0xe172d5d2fe66445fce354d0d2be616095b5b12adbdb7bef4ebfba1ee9b7f2831;	//keccak256("AgentUnlock(address,uint256)");
264 	// bytes32 internal constant _BindRecommender_				= 0xe4d100017ba2dd1d43322b2387da2814945070a0503d88bf058d454061c44fca;	//keccak256("BindRecommender(address,address,bytes32,address)");
265 	// bytes32 internal constant _Transfer_					= 0x5f2147fb558c977441fbdfebcf8cd5776606adc8da5ff95566fc2a4137e54d13;	//keccak256("Transfer(address,address,uint256,address)");
266 	// bytes32 internal constant _Dequeue_					= 0x8ed4de10d9e943b936b256947298f9d79289495a4db8b55f9452da76721f0791;	//keccak256("Dequeue(address,uint256,address,uint256)");
267 	// bytes32 internal constant _DequeueOrder_				= 0xcc45326a7be89070b5e24ad2502035f73c92d306b6aab85d5116f3e9538bd9cf;	//keccak256("DequeueOrder(address,uint256,uint256)");
268 	// bytes32 internal constant _DequeueIngot_				= 0xbd1f3a5aca027a47b1833e8de51edf3d32ec6ffce34268ff5d3022f70bde1794;	//keccak256("DequeueIngot(address,uint256,uint256)");
269 	// bytes32 internal constant _Vote_						= 0xea430f6241d8ab7a4a7da7b9487de059426309628c9c8e7b3e9438f0f431f39e;	//keccak256("Vote(address,bytes32,bytes32,uint256)");
270 	// bytes32 internal constant _VoteResult_					= 0xa0de2ad353f45bfcc398ad86d3575629f76b3c353ca88ce789602fb9ae5d207c;	//keccak256("VoteResult(bytes32,bytes32,bool,uint256,uint256,uint256)");
271 	// bytes32 internal constant _Config_						= 0x4691be92868fa80845b397f0e016905e1b4322422075895b96f9b4a8f1d918cf;	//keccak256("Config(bytes32,bytes32,uint256)");
272 	// bytes32 internal constant _Invest_						= 0x130d745954fedb61791b614172f696ffb5219aa14649d625534e8ff825bd68cd;	//keccak256("Invest(bytes32,address,uint256,uint256)");
273 	// bytes32 internal constant _Disinvest_					= 0x386d6f5f13437a36e2cf423819da85f6dd09bdbc5f4be7e41c0680904b10d7fd;	//keccak256("Disinvest(bytes32,address)");
274 	// bytes32 internal constant _DepositEth_					= 0x7034bb05cfe54b0d147fc0574ed166101e7f0313eb404e113974fbe2a998ca83;	//keccak256("DepositEth(address,uint256)");
275 	// bytes32 internal constant _WithdrawEth_					= 0xb48511ae3e574699605a84740498056f77d218c60c8d7e0e1dee31b9c90fd745;	//keccak256("WithdrawEth(address,address,uint256,bool)");
276 	// bytes32 internal constant _Forging_					= 0x5409965f0a48c519c9ae4c920bd726a7d8ee91475b3d372ac7484ce2989ffc37;	//keccak256("Forging(address,uint256)");
277 	// bytes32 internal constant _Purchase_					= 0x3a53f56a211d9f64ed2c86f99e1aa48b4837ed6d63abc0f07ac29d32fe75e230;	//keccak256("Purchase(address,bytes32,uint256,bool,bool)");
278 	// bytes32 internal constant _CancelOrder_					= 0xc0e68d6b69f741c21e955cad2ae4d505b6f6735c7e7b278251b3f6283a5f07eb;	//keccak256("CancelOrder(address,uint256)");
279 	// bytes32 internal constant _Lock4Dividend_				= 0xdfd1f12277f9150ae1d758207187dfe823fe860e003119517a71ab60b3d10809;	//keccak256("Lock4Dividend(address,uint256)");
280 	// bytes32 internal constant _Unlock4Circulate_			= 0x5dd61c8c2501b31d45e1deddbdac925d30d8075094ef1d89588d6353f89a4821;	//keccak256("Unlock4Circulate(address,uint256)");
281 	// bytes32 internal constant _Apply4Redeem_				= 0xb117f62e1089a5c238e5631cb0a8903798ecfe12e1bb415d18856d168f7b70ec;	//keccak256("Apply4Redeem(address,uint256)");
282 	// bytes32 internal constant _CancelRedeem_				= 0x56d7520e387607a8daa892e3fed116badc2a636307bdc794b1c1aed97ae203f4;	//keccak256("CancelRedeem(address,uint256)");
283 	// bytes32 internal constant _Redeem_						= 0x222838db2794d11532d940e8dec38ae307ed0b63cd97c233322e221f998767a6;	//keccak256("Redeem(address,uint256)");
284 	bytes32 internal constant _RecommendPerformance_		= 0xdff59f3289527807a9634eaf83388e1f449e1f0fd75b01141ed33783d13763bb;	//keccak256("RecommendPerformance(address,address,bytes32,uint256,uint256)");
285 	bytes32 internal constant _RecommendReward_				= 0xea4e2775055f2f3a80aed6e1fd67888ab02b8cdd276b2983ac96b18965c864ca;	//keccak256("RecommendReward(address,address,bytes32,uint256,uint256,uint256)");
286 
287     //uint256 internal constant PROJECT_STATUS_PROPOSING		= uint256(bytes32("PROJECT_STATUS_PROPOSING"));
288     uint256 internal constant PROJECT_STATUS_VOTING			= uint256(bytes32("PROJECT_STATUS_VOTING"));
289     uint256 internal constant PROJECT_STATUS_FAIL			= uint256(bytes32("PROJECT_STATUS_FAIL"));
290     uint256 internal constant PROJECT_STATUS_PASS			= uint256(bytes32("PROJECT_STATUS_PASS"));
291     uint256 internal constant PROJECT_STATUS_INVESTED		= uint256(bytes32("PROJECT_STATUS_INVESTED"));
292     //uint256 internal constant PROJECT_STATUS_DISPROPOSING	= uint256(bytes32("PROJECT_STATUS_DISPROPOSING"));
293     uint256 internal constant PROJECT_STATUS_DISVOTING	    = uint256(bytes32("PROJECT_STATUS_DISVOTING"));
294     uint256 internal constant PROJECT_STATUS_DISINVESTING	= uint256(bytes32("PROJECT_STATUS_DISINVESTING"));
295     uint256 internal constant PROJECT_STATUS_DISINVESTED	= uint256(bytes32("PROJECT_STATUS_DISINVESTED"));
296     
297     //uint256 internal constant VOTE_YES                      = uint256(bytes32("VOTE_YES"));
298     //uint256 internal constant VOTE_NO                       = uint256(bytes32("VOTE_NO"));
299     //uint256 internal constant VOTE_CANCEL                   = uint256(bytes32("VOTE_CANCEL"));
300     bytes32 internal constant VOTE_YES                      = "VOTE_YES";
301     bytes32 internal constant VOTE_NO                       = "VOTE_NO";
302     bytes32 internal constant VOTE_CANCEL                   = "VOTE_CANCEL";
303     
304 }
305 
306 contract IFund {
307 	function returnProfit(bytes32 _projectID, uint256 _eth, uint256 _sf) public;
308 	function returnDisinvestment(bytes32 _projectID, uint256 _eth, uint256 _sf) public;
309 }
310 
311 contract IProject is ICaller {
312 	function invest(bytes32 _projectID, uint256 _eth, uint256 _sf) public;
313 	function disinvest() public;
314 }
315 
316 contract IData is ICalled{
317     // these function isn't abstract since the compiler emits automatically generated getter functions as external
318     function bu(bytes32) public pure returns(uint256) {}
319     function ba(bytes32) public pure returns(address) {}
320     //function bi(bytes32) public pure returns(int256) {}
321     //function bs(bytes32) public pure returns(string) {}
322     //function bb(bytes32) public pure returns(bytes) {}
323     
324     function bau(bytes32, address) public pure returns(uint256) {}
325     //function baa(bytes32, address) public pure returns(address) {}
326     //function bai(bytes32, address) public pure returns(int256) {}
327     //function bas(bytes32, address) public pure returns(string) {}
328     //function bab(bytes32, address) public pure returns(bytes) {}
329     
330     function bbu(bytes32, bytes32) public pure returns(uint256) {}
331     function bbs(bytes32, bytes32) public pure returns(string) {}
332 
333     function buu(bytes32, uint256) public pure returns(uint256) {}
334     function bua(bytes32, uint256) public pure returns(address) {}
335 	function bus(bytes32, uint256) public pure returns(string) {}
336     function bas(bytes32, address) public pure returns(string) {}
337     //function bui(bytes32, uint256) public pure returns(int256) {}
338     //function bus(bytes32, uint256) public pure returns(string) {}
339     //function bub(bytes32, uint256) public pure returns(bytes) {}
340     
341     function bauu(bytes32, address, uint256) public pure returns(uint256) {}
342 	//function baau(bytes32, address, address) public pure returns(uint256) {}
343     function bbau(bytes32, bytes32, address) public pure returns(uint256) {}
344     //function buuu(bytes32, uint256, uint256) public pure returns(uint256) {}
345     function bbaau(bytes32, bytes32, address, address) public pure returns(uint256) {}
346     
347     function setBU(bytes32 _key, uint256 _value) public;
348     function setBA(bytes32 _key, address _value) public;
349     //function setBI(bytes32 _key, int256 _value) public;
350     //function setBS(bytes32 _key, string _value) public;
351     //function setBB(bytes32 _key, bytes _value) public;
352     
353     function setBAU(bytes32 _key, address _addr, uint256 _value) public;
354     //function setBAA(bytes32 _key, address _addr, address _value) public;
355     //function setBAI(bytes32 _key, address _addr, int256 _value) public;
356     //function setBAS(bytes32 _key, address _addr, string _value) public;
357     //function setBAB(bytes32 _key, address _addr, bytes _value) public;
358     
359     function setBBU(bytes32 _key, bytes32 _id, uint256 _value) public;
360     function setBBS(bytes32 _key, bytes32 _id, string _value) public;
361 
362     function setBUU(bytes32 _key, uint256 _index, uint256 _value) public;
363     function setBUA(bytes32 _key, uint256 _index, address _addr) public;
364 	function setBUS(bytes32 _key, uint256 _index, string _str) public;
365     //function setBUI(bytes32 _key, uint256 _index, int256 _value) public;
366     //function setBUB(bytes32 _key, uint256 _index, bytes _value) public;
367 
368 	//function setBAAU(bytes32 _key, address _token, address _addr, uint256 _value) public;
369 	function setBAUU(bytes32 _key, address _addr, uint256 _index, uint256 _value) public;
370     function setBBAU(bytes32 _key, bytes32 _id, address _holder, uint256 _value) public;
371 	//function setBUUU(bytes32 _key, uint256 _index,  uint256 _index2, uint256 _value) public;
372     function setBBAAU(bytes32 _key, bytes32 _id, address _from, address _to, uint256 _value) public;
373 }
374 
375 contract I$martFund is IFund, IOwned, ICaller {
376 
377     function checkQuotaPropose(uint256 _eth, uint256 _sf) public view returns(bool);
378     function propose(bytes32 _projectID, bytes32 _proposeID, IProject _project, uint256 _eth, uint256 _sf, string _mixInfo) public;
379     function dispropose(bytes32 _projectID, bytes32 _disproposeID, string _mixInfo) public;
380 	function getVotes(bytes32 _ID, bytes32 _vote) public view returns(uint256);
381     function vote(bytes32 _ID, bytes32 _vote) public;
382 
383 	function forging(uint256 _msm) public;
384     function purchase(bool _wantDividend, bool _nonInvate, bytes32 _channel, bytes32 _recommendation) public payable;
385     function cancelOrder(uint256 _mso) public returns(uint256 eth);
386     function lock4Dividend(uint256 _msd2_ms) public returns(uint256 msd);
387     function unlock4Circulate(uint256 _msd) public returns(uint256 msd2);
388 
389     function transferMS(address _to, uint256 _ms) public returns (bool success);
390     function transferMSI(address _to, uint256 _msi) public returns (bool success);
391     function transferMSM(address _to, uint256 _msm) public returns (bool success);
392 
393     function apply4Redeem(uint256 _ms) public returns(uint256 ms2r);
394     function cancelRedeem(uint256 _ms2r_msr) public returns(uint256 ms);
395     function redeem(uint256 msr) public returns(uint256 eth);
396     
397 }
398 
399 contract SafeMath {
400     // Overflow protected math functions
401 
402     /**
403         @dev returns the sum of _x and _y, asserts if the calculation overflows
404 
405         @param _x   value 1
406         @param _y   value 2
407 
408         @return sum
409     */
410     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
411         uint256 z = _x + _y;
412         require(z >= _x);        //assert(z >= _x);
413         return z;
414     }
415 
416     /**
417         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
418 
419         @param _x   minuend
420         @param _y   subtrahend
421 
422         @return difference
423     */
424     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
425         require(_x >= _y);        //assert(_x >= _y);
426         return _x - _y;
427     }
428 
429     /**
430         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
431 
432         @param _x   factor 1
433         @param _y   factor 2
434 
435         @return product
436     */
437     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
438         uint256 z = _x * _y;
439         require(_x == 0 || z / _x == _y);        //assert(_x == 0 || z / _x == _y);
440         return z;
441     }
442 	
443 	function safeDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
444 	    // assert(b > 0); // Solidity automatically throws when dividing by 0
445         // uint256 c = a / b;
446         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
447         return _x / _y;
448 	}
449 	
450 	function ceilDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
451 		return (_x + _y - 1) / _y;
452 	}
453 }
454 
455 contract Sqrt {
456 	function sqrt(uint x)public pure returns(uint y) {
457         uint z = (x + 1) / 2;
458         y = x;
459         while (z < y) {
460             y = z;
461             z = (x / z + z) / 2;
462         }
463     }
464 }
465 
466 contract DataCaller is Owned, ICaller {
467     IData public data;
468     
469     constructor(IData _data) public {
470         data = IData(_data);
471     }
472     
473     function calledUpdate(address _oldCalled, address _newCalled) public ownerOnly {
474         if(data == _oldCalled) {
475             data = IData(_newCalled);
476             emit CalledUpdate(_oldCalled, _newCalled);
477         }
478     }
479 }
480 
481 contract GetBU is DataCaller {
482     function getBU(bytes32 _key) internal view returns(uint256) {
483         return data.bu(_key);        
484     }
485 }
486 
487 contract SetBU is DataCaller {
488     function setBU(bytes32 _key, uint256 _value) internal {
489         data.setBU(_key, _value);    
490     }
491 }
492 
493 contract Disable is Owned {
494 	bool public disabled;
495 	
496 	modifier enabled {
497 		assert(!disabled);
498 		_;
499 	}
500 	
501 	function disable(bool _disable) public ownerOnly {
502 		disabled = _disable;
503 	}
504 }
505 
506 contract IReserve is ICalled {
507     // these function isn't abstract since the compiler emits automatically generated getter functions as external
508     function balanceOfColdWallet() public pure returns(uint256) {}
509     function balanceOfShares() public pure returns(uint256) {}
510     function balanceOfOrder() public pure returns(uint256) {}
511     function balanceOfMineral() public pure returns(uint256) {}
512     function balanceOfProject() public pure returns(uint256) {}
513     function balanceOfQueue() public pure returns(uint256) {}
514     function headOfQueue() public pure returns(uint256){}
515     function tailOfQueue() public view returns(uint256);
516     
517     function setColdWallet(address _coldWallet, uint256 _ratioAutoSave, uint256 _ratioAutoRemain) public;
518 	function saveToColdWallet(uint256 _amount) public;
519     function restoreFromColdWallet() public payable;
520 
521     function depositShares() public payable;
522     function depositOrder() public payable;
523     function depositMineral() public payable;
524     function depositProject() public payable;
525     
526     function order2Shares(uint256 _amount) public;
527     function mineral2Shares(uint256 _amount) public;
528     function shares2Project(uint256 _amount)public;
529     function project2Shares(uint256 _amount)public;
530     function project2Mineral(uint256 _amount) public;
531 	
532     function withdrawShares(uint256 _amount) public returns(bool atonce);
533     function withdrawSharesTo(address _to, uint256 _amount) public returns(bool atonce);
534     function withdrawOrder(uint256 _amount) public returns(bool atonce);
535     function withdrawOrderTo(address _to, uint256 _amount) public returns(bool atonce);
536     function withdrawMineral(uint256 _amount) public returns(bool atonce);
537     function withdrawMineralTo(address _to, uint256 _amount) public returns(bool atonce);
538     function withdrawProject(uint256 _amount)public returns(bool atonce);
539     function withdrawProjectTo(address _to, uint256 _amount)public returns(bool atonce);
540     
541 	function() public payable;
542 }
543 
544 contract IFormula is IOwned, ICaller {
545     uint8 public constant MAX_PRECISION = 127;
546     uint32 public constant MAX_WEIGHT = 1000000;
547     function reserve() public pure returns(IReserve) { }
548 
549     function totalSupply() public view returns (uint256);
550     function balanceOf(address _addr)public view returns(uint256);
551     function price() view public returns(uint256);
552     //function costOfTxShares() view public returns(uint256);
553     
554 	function calcTimedQuota(uint256 _rest, uint256 _full, uint256 _timespan, uint256 _period) public pure returns (uint256);
555     function calcEma(uint256 _emaPre, uint256 _value, uint32 _timeSpan, uint256 _period) public view returns(uint256);
556     //function calcFactorReward(uint256 _dailyYield) public view returns(uint256);
557 	function calcFactorMining(uint256 _roi) public view returns(uint256);
558     
559 	function calcOrderTo$fAmount(uint256) public view returns(uint256);
560 	//function calc$martFundAmount(uint256 _amount, uint256 _factorRestrain) public view returns(uint256);
561 
562     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public constant returns (uint256);
563     function calculateRedeemReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public constant returns (uint256);
564 	
565     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) public view returns (uint256, uint8);
566     function power2(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) public view returns (uint256, uint8);
567     function ln(uint256 _numerator, uint256 _denominator) public pure returns (uint256);
568     
569 }
570 
571 contract I$martFundImpl is ICalled, ICaller {
572     uint256 public constant DEQUEUE_DEFAULT             = 0;
573     uint256 public constant DEQUEUE_ORDER               = 1;
574     uint256 public constant DEQUEUE_INGOT               = 2;
575     uint256 public constant DEQUEUE_DOUBLE              = 3;
576     uint256 public constant DEQUEUE_DOUBLE_REVERSELY    = 4;
577     uint256 public constant DEQUEUE_NONE                = 5;
578     
579 	function data() public pure returns(IData){}
580 	function reserve() public pure returns(IReserve){}
581 	function formula() public pure returns(IFormula){}
582 	
583     function dequeueOrder(uint256 gaslimit, bool force) public returns(uint256 dealt);
584     function dequeueIngot(uint256 gaslimit, bool force) public returns(uint256 dealt);
585     function dequeueAlternately(uint256 gaslimit, bool force) public returns(uint256 dealt);
586     function dequeueDouble(uint256 gaslimit, bool force) public returns(uint256 dealt);
587     function dequeue(bytes32 _when) public returns(uint256 dealt);
588 
589     function getVotes(bytes32 _ID, bytes32 _vote) public view returns(uint256);
590 	function impl_vote(address _holder, bytes32 _ID, bytes32 _vote) public;
591     function impl_forging(address _from, uint256 _msm) public;
592     function impl_purchase(address _from, bool _wantDividend, bool _nonInvate, bytes32 _channel) public payable;
593     function impl_cancelOrder(address _from, uint256 _msm) public returns(uint256 eth);
594     function impl_lock4Dividend(address _from, uint256 _msd2_ms) public returns(uint256 msd);
595     function impl_unlock4Circulate(address _from, uint256 _msd) public returns(uint256 msd2);
596 
597     function impl_quotaApply4Redeem() view public returns(uint256);
598     function impl_apply4Redeem(address _from, uint256 _ms) public returns(uint256 ms2r);
599     function impl_cancelRedeem(address _from, uint256 _ms2r_msr) public returns(uint256 ms);
600     function impl_redeem(address _from, uint256 msr) public returns(uint256 eth);
601 }
602 
603 contract Enabled is Disable, GetBU {
604 	modifier enabled2 {
605         require(!disabled && getBU("dappEnabled") != 0);
606         _;
607     }
608 }
609 
610 contract DisableDapp is SetBU {
611 	function disableDapp(bool _disable) public ownerOnly {
612 		setBU("dappEnabled", _disable ? 0 : 1);
613 	}
614 }
615     
616 contract GetBA is DataCaller {
617     function getBA(bytes32 _key) internal view returns(address) {
618         return data.ba(_key);        
619     }
620 }
621 
622 contract SetBA is DataCaller {
623     function setBA(bytes32 _key, address _value) internal {
624         data.setBA(_key, _value);    
625     }
626 }
627 
628 contract GetBAU is DataCaller {
629     function getBAU(bytes32 _key, address _addr) internal view returns(uint256) {
630         return data.bau(_key, _addr);        
631     }
632 }
633 
634 contract SetBAU is DataCaller {
635     function setBAU(bytes32 _key, address _addr, uint256 _value) internal {
636         data.setBAU(_key, _addr, _value);    
637     }
638 }
639 
640 contract GetBBU is DataCaller {
641     function getBBU(bytes32 _key, bytes32 _id) internal view returns(uint256) {
642         return data.bbu(_key, _id);
643     }
644 }
645 
646 contract SetBBU is DataCaller {
647     function setBBU(bytes32 _key, bytes32 _id, uint256 _value) internal {
648         data.setBBU(_key, _id, _value);    
649     }
650 }
651 
652 contract GetBBS is DataCaller {
653     function getBBS(bytes32 _key, bytes32 _id) internal view returns(string) {
654         return data.bbs(_key, _id);
655     }
656 }
657 
658 contract SetBBS is DataCaller {
659     function setBBS(bytes32 _key, bytes32 _id, string _value) internal {
660         data.setBBS(_key, _id, _value);    
661     }
662 }
663 
664 contract GetBUU is DataCaller {
665     function getBUU(bytes32 _key, uint256 _index) internal view returns(uint256) {
666         return data.buu(_key, _index);        
667     }
668 }
669 
670 contract SetBUU is DataCaller {
671     function setBUU(bytes32 _key, uint256 _index, uint256 _value) internal {
672         data.setBUU(_key, _index, _value);    
673     }
674 }
675 
676 contract GetBUA is DataCaller {
677 	function getBUA(bytes32 _key, uint256 _index) internal view returns(address) {
678         return data.bua(_key, _index);        
679     }
680 }
681 
682 contract SetBUA is DataCaller {
683 	function setBUA(bytes32 _key, uint256 _index, address _addr) internal {
684         data.setBUA(_key, _index, _addr);        
685     }
686 }
687 
688 contract GetBUS is DataCaller {
689 	function getBUS(bytes32 _key, uint256 _index) internal view returns(string) {
690         return data.bus(_key, _index);        
691     }
692 }
693 
694 contract SetBUS is DataCaller {
695 	function setBUS(bytes32 _key, uint256 _index, string _str) internal {
696         data.setBUS(_key, _index, _str);        
697     }
698 }
699 
700 contract GetBAUU is DataCaller {
701 	function getBAUU(bytes32 _key, address _addr, uint256 _index) internal view returns(uint256) {
702         return data.bauu(_key, _addr, _index);        
703     }
704 }
705 
706 contract SetBAUU is DataCaller {
707 	function setBAUU(bytes32 _key, address _addr, uint256 _index, uint256 _value) internal {
708         data.setBAUU(_key, _addr, _index, _value);    
709     }
710 }
711 
712 contract GetBBAU is DataCaller {
713     function getBBAU(bytes32 _key, bytes32 _id, address _holder) internal view returns(uint256) {
714         return data.bbau(_key, _id, _holder);
715     }
716 }
717 
718 contract SetBBAU is DataCaller {
719     function setBBAU(bytes32 _key, bytes32 _id, address _holder, uint256 _value) internal {
720         data.setBBAU(_key, _id, _holder, _value);    
721     }
722 }
723 
724 contract GetBBAAU is DataCaller {
725     function getBBAAU(bytes32 _key, bytes32 _id, address _from, address _to) internal view returns(uint256) {
726         return data.bbaau(_key, _id, _from, _to);        
727     }
728 }
729 
730 contract SetBBAAU is DataCaller {
731     function setBBAAU(bytes32 _key, bytes32 _id, address _from, address _to, uint256 _value) internal {
732         data.setBBAAU(_key, _id, _from, _to, _value);
733     }
734 }
735 
736 contract Destructor is Owned{
737     function destruct() public ownerOnly {
738         selfdestruct(owner);
739     }
740 }
741 
742 contract $martFund is Constant, I$martFund, IERC223Receiver, SafeMath, Sqrt, DataCaller, Enabled, DisableDapp, GetBA, GetBAU, SetBAU, GetBUA, SetBUA, GetBUU, SetBUU, GetBBU, SetBBU, GetBBAU, GetBUS, SetBUS, GetBAUU, Destructor{    //, RLPReader {
743     IReserve public reserve;
744     IFormula public formula;
745     I$martFundImpl public impl;
746     
747     constructor(IData _data, IReserve _reserve, IFormula _formula, I$martFundImpl _impl) DataCaller(_data) public {
748         reserve = _reserve;
749         formula = _formula;
750         impl = _impl;
751     }
752 
753     function calledUpdate(address _oldCalled, address _newCalled) public ownerOnly {
754         if(data == _oldCalled){
755             data = IData(_newCalled);
756         }else if(reserve == _oldCalled){
757             reserve = IReserve(_newCalled);
758         }else if(formula == _oldCalled){
759             formula = IFormula(_newCalled);
760         }else if(impl == _oldCalled){
761 			impl = I$martFundImpl(_newCalled);
762 		}else{
763             return;
764         }
765         emit CalledUpdate(_oldCalled, _newCalled);
766     }
767 
768     function updateEmaDailyYieldSF(uint256 _value) internal/*public*/ returns(uint256) {
769         uint256 ema = getBU("emaDailyYieldSF");
770         uint32 timeSpan = uint32(safeSub(now, getBU("timeLastMiningSF")));
771 		setBU("timeLastMiningSF", now);
772         ema = formula.calcEma(ema, _value, timeSpan, 1 days);
773         setBU("emaDailyYieldSF", ema);
774         return ema;
775     }
776 
777     function checkQuotaPropose(uint256 _eth, uint256 _sf) public view returns(bool) {
778 		uint256 totalSupply_ = formula.totalSupply();
779 		uint256 reserve_ = reserve.balanceOfShares();
780 		if(_sf * 1 ether > totalSupply_ * getBU("quotaPerProposeSF") || _eth * 1 ether > reserve_ * getBU("quotaPerProposeEth"))
781 			return false;
782 		for(uint256 id = getBUU(_projectsVoting_, 0x0); id != 0x0; id = getBUU(_projectsVoting_, id)) {
783 			_sf  += getBUU(_investmentSF_,  id);
784 			_eth += getBUU(_investmentEth_, id);
785 		}
786 		return _sf * 1 ether <= totalSupply_ * getBU("quotaAllProposeSF") && _eth * 1 ether <= reserve_ * getBU("quotaAllProposeEth");
787 	}
788 	
789 	event Propose(address indexed _holder, bytes32 indexed _projectID, bytes32 _proposeID, IProject _project, uint256 _eth, uint256 _sf);
790     function propose(bytes32 _projectID, bytes32 _proposeID, IProject _project, uint256 _eth, uint256 _sf, string _mixInfo) public enabled2 {
791 		emit Propose(msg.sender, _proposeID, _projectID, _project, _eth, _sf);
792 		// emitEvent(_Propose_, bytes32(msg.sender), _projectID, uint256(_proposeID), uint256(_project), _eth, _sf);
793 		IDummyToken $fd = IDummyToken(getBA(_$FD_));
794 		require($fd.balanceOf(msg.sender) * 1 ether >= $fd.totalSupply() * getBU(_thresholdPropose_));	//, "Proponent has not enough $FD!"
795 		if(address(_project) != address(0x0))
796 			require(checkQuotaPropose(_eth, _sf));			//, "Too much financing!"
797         
798         if(_projectID == _proposeID) {							// first invest of the _projectID
799             uint256 projectID = getBAU(_projectID_, _project);
800 			uint256 status = getBUU(_projectStatus_, projectID);
801 			require(projectID == 0 || status == PROJECT_STATUS_FAIL || status == PROJECT_STATUS_DISINVESTED);
802             projectID = uint256(_projectID);
803             setBAU(_projectID_, _project, projectID);
804         }else{
805             projectID = uint256(_projectID);
806 			require(getBAU(_projectID_, _project) == projectID);
807 			require(getBUU(_projectStatus_, projectID) == PROJECT_STATUS_INVESTED);	//, "Can't repropose a project which had not INVESTED!"
808 			uint256 proposeID = getBUU(_proposeID_, projectID);
809 			require(proposeID == 0 || proposeID == projectID || getBUU(_projectStatus_, proposeID) != PROJECT_STATUS_VOTING);
810 			uint256 disproposeID = getBUU(_disproposeID_, projectID);
811 			require(disproposeID == 0 || getBUU(_projectStatus_, disproposeID) == PROJECT_STATUS_FAIL);
812         }
813        
814 		proposeID = uint256(_proposeID);
815         require(getBUU(_projectStatus_, proposeID) == 0x0);	//, "Can't propose same proposeID again!"
816  		setBUU(_proposeID_, projectID, proposeID);
817 		setBUU(_projectID_, proposeID, projectID);
818         setBUU(_projectStatus_, proposeID, PROJECT_STATUS_VOTING);
819 		setBUU(_timePropose_, proposeID, now);
820 		setBUA(_projectAddr_, proposeID, _project);
821 		setBUU(_investmentSF_, proposeID, _sf);
822 		setBUU(_investmentEth_, proposeID, _eth);
823 		setBUS(_projectInfo_, proposeID, _mixInfo);
824 		
825 		setBUU(_projects_, proposeID, getBUU(_projects_, 0x0));					// join projects list
826 		setBUU(_projects_, 0x0, proposeID);
827 		setBUU(_projectsVoting_, proposeID, getBUU(_projectsVoting_, 0x0));
828 		setBUU(_projectsVoting_, 0x0, proposeID);
829 		
830 		vote(_proposeID, VOTE_YES);
831     }
832     
833     event Dispropose(address indexed _holder, bytes32 indexed _projectID, bytes32 _disproposeID);
834     function dispropose(bytes32 _projectID, bytes32 _disproposeID, string _mixInfo) public enabled2 {
835 		emit Dispropose(msg.sender, _projectID, _disproposeID);
836 		// emitEvent(_Dispropose_, bytes32(msg.sender), _projectID, uint256(_disproposeID));
837 		uint256 projectID = uint256(_projectID);
838 		require(getBUU(_projectStatus_, projectID) == PROJECT_STATUS_INVESTED);	//, "Can't dispropose a project which had not INVESTED!"
839 		uint256 proposeID = getBUU(_proposeID_, projectID);
840 		require(proposeID == 0 || proposeID == projectID || getBUU(_projectStatus_, proposeID) != PROJECT_STATUS_VOTING);
841 		uint256 disproposeID = getBUU(_disproposeID_, projectID);
842 		require(disproposeID == 0 || getBUU(_projectStatus_, disproposeID) == PROJECT_STATUS_FAIL);		//, "The dispropose of the project already exist!"
843 		disproposeID = uint256(_disproposeID);
844 		require(getBUU(_projectStatus_, disproposeID) == 0x0);						//, "Can't dispropose same disproposeID again!"
845 		setBUU(_disproposeID_, projectID, disproposeID);
846 		setBUU(_projectID_, disproposeID, projectID);
847         
848 		IDummyToken $fd = IDummyToken(getBA(_$FD_));
849 		require($fd.balanceOf(msg.sender) * 1 ether >= $fd.totalSupply() * getBU(_thresholdPropose_));	//, "Proponent has not enough $FD!"
850 		setBUU(_projectStatus_, disproposeID, PROJECT_STATUS_DISVOTING);
851 		setBUU(_timePropose_, disproposeID, now);
852 		setBUS(_projectInfo_, disproposeID, _mixInfo);
853 		
854 		setBUU(_projects_, disproposeID, getBUU(_projects_, 0x0));				// join projects list
855 		setBUU(_projects_, 0x0, disproposeID);
856 		setBUU(_projectsVoting_, disproposeID, getBUU(_projectsVoting_, 0x0));
857 		setBUU(_projectsVoting_, 0x0, disproposeID);
858 		
859 		vote(_disproposeID, VOTE_YES);
860     }
861     
862     function getVotes(bytes32 _ID, bytes32 _vote) public view returns(uint256) {
863 		return impl.getVotes(_ID, _vote);
864 	}
865 	
866     function vote(bytes32 _ID, bytes32 _vote) public enabled2 {
867 		uint256 status = getBUU(_projectStatus_, uint256(_ID));
868 		require(status == PROJECT_STATUS_VOTING || status == PROJECT_STATUS_DISVOTING);	//, "Project status is not VOTING or DISVOTING!"
869 		impl.impl_vote(msg.sender, _ID, _vote);
870     }
871     
872     function voteYes(bytes32 _projectID) public {
873 		vote(_projectID, VOTE_YES);
874 	}
875 	
876     function voteNo(bytes32 _projectID) public {
877 		vote(_projectID, VOTE_NO);
878 	}
879 	
880     function voteCancle(bytes32 _projectID) public {
881 		vote(_projectID, VOTE_CANCEL);
882 	}
883     
884 	event UpdateProject(address indexed _sender, bytes32 indexed _projectID, address _oldProject, address _newProject);
885 	function updateProject(address _oldProject, address _newProject) public ownerOnly {
886         // assert(getBU("UpdateContract") == uint256(oldProject));
887         uint256 id = getBAU(_projectID_, _oldProject);
888         setBAU(_projectID_, _newProject, id);
889         setBAU(_projectID_, _oldProject, 0);
890         setBUA(_projectAddr_, id, _newProject);
891 		emit UpdateProject(msg.sender, bytes32(id), _oldProject, _newProject);
892 		// emitEvent(_UpdateProject_, bytes32(msg.sender), bytes32(id), uint256(_oldProject), uint256(_newProject));
893     }
894     
895 	event ReturnProfit(address indexed _sender, bytes32 indexed _projectID, uint256 _eth, uint256 _sf);
896 	function returnProfit(bytes32 _projectID, uint256 _eth, uint256 _sf) public enabled2 {
897 	    emit ReturnProfit(msg.sender, _projectID, _eth, _sf);
898 		// emitEvent(_ReturnProfit_, bytes32(msg.sender), _projectID, _eth, _sf);
899 		uint256 projectID = uint256(_projectID);
900 		if(_sf > 0) {
901 			setBUU(_profitSF_, projectID, safeAdd(getBUU(_profitSF_, projectID), _sf));
902 			setBU(_profitSF_, safeAdd(getBU(_profitSF_), _sf));
903 			uint256 ema = updateEmaDailyYieldSF(_sf);
904 			I$FM2_Operator addrMSM2O = I$FM2_Operator(IDummyToken(getBA(_$FM2_)).operator());
905 			uint256 ratioDividend = addrMSM2O.updateRatioDividend(_sf, ema);
906 			uint256 dividend = _sf * ratioDividend / 1 ether;
907 			uint256 supplyOld = formula.totalSupply();
908 			uint256 supplyNew = safeSub(supplyOld+dividend, _sf);
909 			uint256 weightOld = getBU(_weightOfReserve_);
910 			uint256 weightNew = weightOld * supplyOld / supplyNew;
911 			setBU(_weightOfReserve_, weightNew);
912 			uint256 reserve_ = reserve.balanceOfShares();
913             emit Weight("returnProfit", weightNew, weightOld, reserve_, reserve_, supplyNew, supplyOld, reserve_*1 ether/weightOld*1 ether/supplyOld);
914 			// emitEvent(_Weight_, "returnProfit", bytes32(0), weightNew, weightOld, reserve_, reserve_, supplyNew, supplyOld, reserve_*1 ether/weightOld*1 ether/supplyOld);
915 			IDummyToken(getBA(_$F_)).operator().destroy(getBUA(_projectAddr_, projectID), _sf);
916 			addrMSM2O.dividend(dividend);
917 			setBU(_returnSF_, safeSub(safeAdd(getBU(_returnSF_), _sf), dividend));
918 		}
919 		if(_eth > 0) {
920 		    setBUU(_profitEth_, projectID, getBUU(_profitEth_, projectID) + _eth);
921 		    setBU(_profitEth_, getBU(_profitEth_) + _eth);
922 			reserve.project2Mineral(_eth);
923             IEtherToken(getBA(_ETHER_)).destroy(getBUA(_projectAddr_, projectID), _eth);
924 			//updateEmaDailyYield(msg.value);
925 			//updateFactorReward();
926 			//setBU("hasNonceMark", hasNonceMark ? 1 : 0);
927             setBAU(_projectID_, msg.sender, projectID);
928 			ITokenOperator(IDummyToken(getBA(_$FM_)).operator()).issue(msg.sender, _eth);
929 			impl.dequeue("dequeueWhenMining");
930 		}
931 	}
932 	
933     event Weight(bytes32 indexed _cause, uint256 _weightNew, uint256 _weightOld, uint256 _reserveNew, uint256 _reserveOld, uint256 _supplyNew, uint256 _supplyOld, uint256 _price);
934 	event ReturnDisinvestment(address indexed _sender, bytes32 indexed _projectID, uint256 _eth, uint256 _sf);
935 	function returnDisinvestment(bytes32 _projectID, uint256 _eth, uint256 _sf) public enabled2 {
936 	    emit ReturnDisinvestment(msg.sender, _projectID, _eth, _sf);
937 		// emitEvent(_ReturnDisinvestment_, bytes32(msg.sender), _projectID, _eth, _sf);
938 		setBUU(_projectStatus_, uint256(_projectID), PROJECT_STATUS_DISINVESTED);
939         setBUU(_disproposeID_, uint256(_projectID), 0);
940         address project = getBUA(_projectAddr_, uint256(_projectID));
941         setBAU(_projectID_, project, 0);//detach project with _projectID
942 		
943 		uint256 supply = formula.totalSupply();
944 		uint256 reserve_ = reserve.balanceOfShares(); 
945 		if(_sf > 0) {
946 			setBUU(_profitSF_, uint256(_projectID), safeAdd(getBUU(_profitSF_, uint256(_projectID)), _sf));
947 			setBU(_profitSF_, safeAdd(getBU(_profitSF_), _sf));
948 			setBU(_returnSF_, safeAdd(getBU(_returnSF_), _sf));
949 			uint256 weightOld = getBU(_weightOfReserve_);
950 			uint256 weightNew = weightOld * supply / safeSub(supply, _sf);
951 			setBU(_weightOfReserve_, weightNew);
952             emit Weight("returnDisinvestment", weightNew, weightOld, reserve_, reserve_, safeSub(supply, _sf), supply, reserve_*1 ether/weightOld*1 ether/supply);
953 			// emitEvent(_Weight_, "returnDisinvestment", bytes32(0), weightNew, weightOld, reserve_, reserve_, safeSub(supply, _sf), supply, reserve_*1 ether/weightOld*1 ether/supply);
954 			IDummyToken(getBA(_$F_)).operator().destroy(project, _sf);
955 		}
956 		if(_eth > 0) {
957 			setBUU(_profitEth_, uint256(_projectID), getBUU(_profitEth_, uint256(_projectID)) + _eth);
958 			setBU(_profitEth_, getBU(_profitEth_) + _eth);
959 			setBU(_returnEth_, getBU(_returnEth_) + _eth);
960 			weightOld = getBU(_weightOfReserve_);
961 			weightNew = weightOld * (reserve_+_eth) / reserve_;
962 			setBU(_weightOfReserve_, weightNew);
963             emit Weight("returnDisinvestment", weightNew, weightOld, reserve_+_eth, reserve_, supply, supply, reserve_*1 ether/weightOld*1 ether/supply);
964 			// emitEvent(_Weight_, "returnDisinvestment", bytes32(0), weightNew, weightOld, reserve_+_eth, reserve_, supply, supply, reserve_*1 ether/weightOld*1 ether/supply);
965 			// reserve.depositShares.value(_eth)();
966             IEtherToken(getBA(_ETHER_)).destroy(project, _eth);
967             reserve.project2Shares(_eth);
968 		}
969 	}
970 	
971 	function forging(uint256 _msm) public enabled {
972         return impl.impl_forging(msg.sender, _msm);
973     }
974     
975     function purchase(bool _wantDividend, bool _nonInvate, bytes32 _channel, bytes32 _recommendation) public payable enabled {
976         if(_recommendation != 0)
977             IRecommend(getBA(_Recommend_)).bindRecommenderImpl(msg.sender, _recommendation);
978 		if(msg.value > 0)
979 			return impl.impl_purchase.value(msg.value)(msg.sender, _wantDividend, _nonInvate, _channel);
980     }
981 
982     function cancelOrder(uint256 _mso) public enabled returns(uint256 eth) {
983         return impl.impl_cancelOrder(msg.sender, _mso);
984     }
985     
986     function lock4Dividend(uint256 _msd2_ms) public enabled returns(uint256 msd) {
987         return impl.impl_lock4Dividend(msg.sender, _msd2_ms);
988     }
989     
990     function unlock4Circulate(uint256 _msd) public enabled returns(uint256 msd2) {
991         return impl.impl_unlock4Circulate(msg.sender, _msd);
992     }
993     
994     event Transfer(address indexed _from, address indexed _to, uint256 _value, address _token);
995 	function transferMS(address _to, uint256 _ms) public enabled returns(bool success) {
996         return IDummyToken(getBA(_$F_)).operator().token_transfer(msg.sender, _to, _ms);
997 		emit Transfer(msg.sender, _to, _ms, getBA(_$F_));
998 		// emitEvent(_Transfer_, bytes32(msg.sender), bytes32(_to), _ms, uint256(getBA(_$F_)));
999     }
1000     
1001     function transferMSI(address _to, uint256 _msi) public enabled returns(bool success) {
1002         return IDummyToken(getBA(_$FI_)).operator().token_transfer(msg.sender, _to, _msi);
1003 		emit Transfer(msg.sender, _to, _msi, getBA(_$FI_));
1004 		// emitEvent(_Transfer_, bytes32(msg.sender), bytes32(_to), _msi, uint256(getBA(_$FI_)));
1005     }
1006     
1007     function transferMSM(address _to, uint256 _msm) public enabled returns(bool success) {
1008         return IDummyToken(getBA(_$FM_)).operator().token_transfer(msg.sender, _to, _msm);
1009 		emit Transfer(msg.sender, _to, _msm, getBA(_$FM_));
1010 		// emitEvent(_Transfer_, bytes32(msg.sender), bytes32(_to), _msm, uint256(getBA(_$FM_)));
1011     }
1012 
1013     function apply4Redeem(uint256 _ms) public enabled returns(uint256 msr) {
1014         return impl.impl_apply4Redeem(msg.sender, _ms);
1015     }
1016     
1017     function cancelRedeem(uint256 _ms2r_msr) public enabled returns(uint256 ms) {
1018         return impl.impl_cancelRedeem(msg.sender, _ms2r_msr);
1019     }
1020     
1021     function redeem(uint256 _msr) public enabled returns(uint256 eth) {
1022         return impl.impl_redeem(msg.sender, _msr);
1023     }
1024 
1025     //event Dequeue(address indexed _holder, uint256 _dealt, address _token, uint256 _gaslimit);
1026     event DequeueOrder(address indexed _holder, uint256 _dealt, uint256 _gaslimit);
1027 	function dequeueOrder(uint256 gaslimit) public enabled returns(uint256 dealt) {		// for urge order
1028 		dealt = impl.dequeueOrder(gaslimit, true);
1029 		//emit Dequeue(msg.sender, dealt, getBA(_$FO_), gaslimit);
1030 		emit DequeueOrder(msg.sender, dealt, gaslimit);
1031 		//emitEvent(_Dequeue_, bytes32(msg.sender), bytes32(0), dealt, uint256(getBA(_$FO_)), gaslimit);
1032 		// emitEvent(_DequeueOrder_, bytes32(msg.sender), bytes32(0), dealt, gaslimit);
1033 	}
1034     
1035     event DequeueIngot(address indexed _holder, uint256 _dealt, uint256 _gaslimit);
1036     function dequeueIngot(uint256 gaslimit) public enabled returns(uint256 dealt) {
1037 		dealt = impl.dequeueIngot(gaslimit, true);
1038 		//emit Dequeue(msg.sender, dealt, getBA(_$FM2_), gaslimit);
1039 		emit DequeueIngot(msg.sender, dealt, gaslimit);
1040 		//emitEvent(_Dequeue_, bytes32(msg.sender), bytes32(0), dealt, uint256(getBA(_$FM2_)), gaslimit);
1041 		// emitEvent(_DequeueIngot_, bytes32(msg.sender), bytes32(0), dealt, gaslimit);
1042 	}
1043 
1044     function nop()public{
1045     }
1046 	
1047     function tokenFallback(address _from, uint _value, bytes _data) public enabled2 returns(bool){
1048         if(msg.sender == getBA(_$F_))
1049             return true;
1050         return false;
1051         _from;  _value; _data;
1052     }
1053 	
1054     function() public payable{
1055         purchase(false, false, 0x0, 0x0);
1056     }
1057 }
1058 
1059 contract IRecommend{
1060     function bindRecommenderImpl(address _sender, bytes32 _recommendation) public returns(bool);
1061 }
1062 
1063 contract I$FM2_Operator {
1064 	function updateRatioDividend(uint256 _amount, uint256 _ema) public returns(uint256 ratioDividend);
1065     function dequeueIngot(uint256 gaslimit, bool force) public returns(uint256);
1066 	function dividend(uint256 _amount) public;
1067 }
1068 
1069 contract IEtherToken {
1070     function destroy(address _from, uint256 _eth) public;
1071 }