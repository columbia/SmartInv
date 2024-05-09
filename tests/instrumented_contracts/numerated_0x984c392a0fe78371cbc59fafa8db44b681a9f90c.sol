1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract crowdfund {
50 
51 Idea[] public ideas;
52 
53 uint256 public PROPOSED_STATUS;
54 uint256 public UNDERWAY_STATUS;
55 uint256 public SUFFICIENT_STATUS;
56 uint256 public FAILED_STATUS;
57 uint256 public REQUEST_CANCELED_BY_CREATOR;
58 uint256 public REQUEST_REJECTED_BY_HOST; 
59 uint256 public DISTRIBUTED_STATUS; 
60 
61 uint256 public MAX_FUNDING_AMOUNT;
62 uint256 public MAX_HOST_PERCENT;
63 
64 event ProposalCreatedAtIndex(uint256 index);
65 event SetNewCreator(address newCreator,uint256 index);
66 event ProposalCanceledByCreatorAtIndex(uint256 index);
67 event ProposalCanceledByHostAtIndex(uint256 index);
68 event ProposalAcceptedAtIndex(uint256 index);
69 event UserPledgedAmountAtIndex(address user,uint256 amount,uint256 index);
70 event ProposalAtIndexFailed(uint256 index);
71 event UserRegainedAmountAtIndex(address user,uint256 amount,uint256 index);
72 event TokensDistributed(uint256 hostCut,uint256 creatorCut,uint256 index);
73 event MaxGoalReachedAtIndex(uint256 hostCut,uint256 creatorCut,uint256 index);
74 event SufficientFundingReached(uint256 index);
75 
76 struct Idea {
77 	string title;
78 	uint256 minGoal; 
79 	uint256 maxGoal; 
80 	uint256 hostCut; 
81 	uint256 duration; 
82 	uint256 startTime;
83 	uint256 status;
84 	uint256 amountRaisedSoFar;
85 	address host;
86 	address tokenAddress; 
87 	address creator;
88 	mapping(address => uint256) amountPledged; 
89 	mapping(address => bool) reclaimed; 
90 }
91 
92 function crowdfund() {
93 
94 	PROPOSED_STATUS=1;
95 	UNDERWAY_STATUS=2;
96 	SUFFICIENT_STATUS=3;
97 	FAILED_STATUS=4;
98 	REQUEST_CANCELED_BY_CREATOR=5;
99 	REQUEST_REJECTED_BY_HOST=6; 
100 	DISTRIBUTED_STATUS=7;
101 
102 	MAX_FUNDING_AMOUNT = 100000000000000000000000000000;
103 	MAX_HOST_PERCENT=100000000000000000000;
104 }
105 
106 function makeProposal(string title,uint256 minGoal,uint256 maxGoal,uint256 hostCut,uint256 duration,address host,address tokenAddress) public returns(uint256)	{
107 
108 	if (maxGoal==0 || minGoal==0 || maxGoal>MAX_FUNDING_AMOUNT) revert(); 
109 	if (minGoal>maxGoal) revert();
110 	if (hostCut>MAX_HOST_PERCENT) revert(); 
111 	if (duration<5 || duration>225257142) revert();  
112 	
113 	if (!(tokenAddress==0xc8C6A31A4A806d3710A7B38b7B296D2fABCCDBA8)) revert();
114 	
115 	uint256 status=PROPOSED_STATUS;
116 	address creator=msg.sender;
117 	
118 	Idea memory newIdea=Idea(title,minGoal,maxGoal,hostCut,duration,0,status,0,host,tokenAddress,creator);
119 	ideas.push(newIdea);
120 	
121 	emit ProposalCreatedAtIndex(ideas.length-1);
122 	
123 	return ideas.length-1; 
124 }
125 
126 function setNewCreator(address newCreator,uint256 index) public returns(bool)	{
127 	if (ideas[index].creator==msg.sender && ideas[index].status==PROPOSED_STATUS)	{
128 		ideas[index].creator=newCreator;
129 		emit SetNewCreator(newCreator,index);
130 		return true;
131 	}
132 	return false;
133 }
134 
135 function cancelProposalByCreator(uint256 index) public	{
136  	if (msg.sender==ideas[index].creator && ideas[index].status==PROPOSED_STATUS)	{ 
137  		ideas[index].status=REQUEST_CANCELED_BY_CREATOR;
138  		emit ProposalCanceledByCreatorAtIndex(index);
139  	}
140 }
141 
142 function rejectProposalAsHost(uint256 index) public	{
143 	if (msg.sender==ideas[index].host && ideas[index].status==PROPOSED_STATUS)	{ 
144 		ideas[index].status=REQUEST_REJECTED_BY_HOST;
145 		emit ProposalCanceledByHostAtIndex(index);
146 	}
147 }
148 
149 function acceptProposal(uint256 index,address currCreator) public returns(bool)	{
150 
151 	if (ideas[index].status==PROPOSED_STATUS && msg.sender==ideas[index].host && currCreator==ideas[index].creator)	{
152 		ideas[index].status=UNDERWAY_STATUS;
153 		ideas[index].startTime=block.number;
154 		emit ProposalAcceptedAtIndex(index);
155 		return true;
156 	}
157 	return false;
158 }
159 
160 function maxGoalReached(uint256 index) private {
161 	ideas[index].status=DISTRIBUTED_STATUS;
162 	uint256 hostCut;
163 	uint256 creatorCut;
164 	(hostCut, creatorCut) = returnHostAndCreatorCut(index);
165 	emit MaxGoalReachedAtIndex(hostCut,creatorCut,index);
166 	if(! token(ideas[index].tokenAddress).transfer(ideas[index].creator,creatorCut)) revert();
167 	if(! token(ideas[index].tokenAddress).transfer(ideas[index].host,hostCut)) revert();
168 	
169 }
170 
171 function distributeSuccessfulCampaignFunds(uint256 index) public returns(bool)	{
172 	if ((msg.sender==ideas[index].creator) || (msg.sender==ideas[index].host))	{
173 		if (ideas[index].status==SUFFICIENT_STATUS && block.number> SafeMath.add(ideas[index].startTime,ideas[index].duration) )	{ 
174 			uint256 hostCut;
175 			uint256 creatorCut;
176 			(hostCut, creatorCut) = returnHostAndCreatorCut(index);
177 			ideas[index].status=DISTRIBUTED_STATUS;
178 			emit TokensDistributed(hostCut,creatorCut,index);
179 			if(! token(ideas[index].tokenAddress).transfer(ideas[index].creator,creatorCut)) revert();
180 			if(! token(ideas[index].tokenAddress).transfer(ideas[index].host,hostCut)) revert();
181 			return true;
182 		}
183 	}
184 	return false;
185 }
186 
187 function returnHostAndCreatorCut(uint256 index) private returns(uint256, uint256)	{
188 	uint256 hostCut = SafeMath.div( SafeMath.mul(ideas[index].amountRaisedSoFar, ideas[index].hostCut), MAX_HOST_PERCENT );
189 	uint256 creatorCut = SafeMath.sub(ideas[index].amountRaisedSoFar, hostCut );
190 	return ( hostCut, creatorCut );
191 }
192 
193 function stateFail(uint256 index) public	{
194 	if (block.number> SafeMath.add(ideas[index].startTime,ideas[index].duration) && ideas[index].amountRaisedSoFar<ideas[index].minGoal && ideas[index].status==UNDERWAY_STATUS) {
195 		ideas[index].status=FAILED_STATUS;
196 		emit ProposalAtIndexFailed(index);
197 	}
198 }
199 
200 function reclaimTokens(uint256 index) public	{
201 	if (ideas[index].status==FAILED_STATUS)	{
202 	    if (!ideas[index].reclaimed[msg.sender])    { 
203 	        uint256 reclaimAmount=ideas[index].amountPledged[msg.sender];
204 		    if (reclaimAmount>0)    { 
205 		    	ideas[index].reclaimed[msg.sender]=true; 
206 		        emit UserRegainedAmountAtIndex(msg.sender,reclaimAmount,index);
207 		        if(! token(ideas[index].tokenAddress).transfer(msg.sender,reclaimAmount)) revert();
208 		    }
209 	    }
210 	}
211 }
212 
213 function redistributeTokensForAddresses(uint256 index,address[] addresses) public	{
214 	if ((msg.sender==ideas[index].creator) || (msg.sender==ideas[index].host))	{
215 		if (ideas[index].status==FAILED_STATUS)	{
216 			for(uint256 i = 0; i < addresses.length; i++) {
217 				address addr=addresses[i];
218 	    		if (!ideas[index].reclaimed[addr])    { 
219 	        		uint256 reclaimAmount=ideas[index].amountPledged[addr];
220 		    		if (reclaimAmount>0)    { 
221 		    			ideas[index].reclaimed[addr]=true; 
222 		        		emit UserRegainedAmountAtIndex(addr,reclaimAmount,index);
223 		        		if(! token(ideas[index].tokenAddress).transfer(addr,reclaimAmount)) revert();
224 		    		}
225 	    		}
226 	    	}    
227 		}
228 	}
229 }
230 
231 function pledgeTokens(uint256 amount,uint256 index) public returns(bool)	{
232     if (msg.sender==ideas[index].creator || msg.sender==ideas[index].host) revert(); 
233     if (amount==0 || amount>MAX_FUNDING_AMOUNT) revert(); 
234 	if ((ideas[index].status==UNDERWAY_STATUS) || (ideas[index].status==SUFFICIENT_STATUS))	{ 
235 	    if (block.number<= SafeMath.add(ideas[index].startTime, ideas[index].duration))   { 
236 	        uint256 amountAvailable= SafeMath.sub(ideas[index].maxGoal, ideas[index].amountRaisedSoFar); 
237 			if (amount>amountAvailable)	revert(); 
238 			ideas[index].amountRaisedSoFar = SafeMath.add(ideas[index].amountRaisedSoFar, amount); 
239 			ideas[index].amountPledged[msg.sender] = SafeMath.add(ideas[index].amountPledged[msg.sender], amount); 
240 			if (!token(ideas[index].tokenAddress).transferFrom(msg.sender,address(this),amount)) revert(); 
241 			if (ideas[index].amountRaisedSoFar==ideas[index].maxGoal)  { 
242 			    maxGoalReached(index); 
243 			}
244 			else if ((ideas[index].amountRaisedSoFar>=ideas[index].minGoal) && (ideas[index].status==UNDERWAY_STATUS))   { 
245 			   ideas[index].status=SUFFICIENT_STATUS;
246 			   emit SufficientFundingReached(index);
247 			}
248 			emit UserPledgedAmountAtIndex(msg.sender,amount,index);
249 			return true;
250 	    }
251 	}
252 	return false;
253 }
254 
255 function returnMinGoal(uint256 index) public returns(uint256)	{
256 	return ideas[index].minGoal;
257 }
258 
259 function returnMaxGoal(uint256 index) public returns(uint256)	{
260 	return ideas[index].maxGoal;
261 }
262 
263 function returnHostCut(uint256 index) public returns(uint256)	{
264 	return ideas[index].hostCut;
265 }
266 
267 function returnDuration(uint256 index) public returns(uint256)	{
268 	return ideas[index].duration;
269 }
270 
271 function returnStartTime(uint256 index) public returns(uint256)	{
272 	return ideas[index].startTime;
273 }
274 
275 function returnStatus(uint256 index) public returns(uint256)	{
276 	return ideas[index].status;
277 }
278 
279 function returnAmountRaisedSoFar(uint256 index) public returns(uint256)	{
280 	return ideas[index].amountRaisedSoFar;
281 }
282 
283 function returnHost(uint256 index) public returns(address)	{
284 	return ideas[index].host;
285 }
286 
287 function returnTokenAddress(uint256 index) public returns(address)	{
288 	return ideas[index].tokenAddress;
289 }
290 
291 function returnCreator(uint256 index) public returns(address)	{
292 	return ideas[index].creator;
293 }
294 
295 function returnAmountPledged(uint256 index,address addr) public returns(uint256)	{
296 	return ideas[index].amountPledged[addr];
297 }
298 
299 function returnReclaimed(uint256 index,address addr) public returns(bool)	{
300 	return ideas[index].reclaimed[addr];
301 }	
302 
303 function getProposalsCount() public returns(uint256) {
304     return ideas.length;
305 }
306 
307 }
308 
309 contract token	{
310 	function transfer(address _to, uint256 _amount) returns (bool success);
311 	function transferFrom(address _from,address _to,uint256 _amount) returns (bool success);
312 }