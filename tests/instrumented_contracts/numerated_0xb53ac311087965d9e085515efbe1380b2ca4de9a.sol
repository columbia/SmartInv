1 pragma solidity ^0.4.13;
2 contract ERC20Basic {
3   uint256 public totalSupply;
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 contract ERC20 is ERC20Basic {
10   function allowance(address owner, address spender) public view returns (uint256);
11   function transferFrom(address from, address to, uint256 value) public returns (bool);
12   function approve(address spender, uint256 value) public returns (bool);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 
52 library SafeMath {
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 contract WTE is ERC20,Ownable{
82 	using SafeMath for uint256;
83 
84 	//the base info of the token
85 	string public constant name="WITEE";
86 	string public constant symbol="WTE";
87 	string public constant version = "1.0";
88 	uint256 public constant decimals = 18;
89 
90 
91 
92 	uint256 public constant MAX_PRIVATE_FUNDING_SUPPLY=648000000*10**decimals;
93 
94 
95 	uint256 public constant COOPERATE_REWARD=270000000*10**decimals;
96 
97 
98 	uint256 public constant ADVISOR_REWARD=90000000*10**decimals;
99 
100 
101 	uint256 public constant COMMON_WITHDRAW_SUPPLY=MAX_PRIVATE_FUNDING_SUPPLY+COOPERATE_REWARD+ADVISOR_REWARD;
102 
103 
104 	uint256 public constant PARTNER_SUPPLY=270000000*10**decimals;
105 
106 
107 	
108 	uint256 public constant MAX_PUBLIC_FUNDING_SUPPLY=180000000*10**decimals;
109 
110 	
111 	uint256 public constant TEAM_KEEPING=342000000*10**decimals;
112 
113 	
114 	uint256 public constant MAX_SUPPLY=COMMON_WITHDRAW_SUPPLY+PARTNER_SUPPLY+MAX_PUBLIC_FUNDING_SUPPLY+TEAM_KEEPING;
115 
116 
117 	uint256 public rate;
118 
119 
120 	mapping(address=>uint256) public publicFundingWhiteList;
121 
122 	mapping(address=>uint256) public  userPublicFundingEthCountMap;
123 
124 	uint256 public publicFundingPersonalEthLimit;
125 
126 
127 	uint256 public totalCommonWithdrawSupply;
128 
129 	uint256 public totalPartnerWithdrawSupply;
130 
131 
132 	uint256 public totalPublicFundingSupply;
133 
134 	bool public hasTeamKeepingWithdraw;
135 
136 
137 	uint256 public startTime;
138 	uint256 public endTime;
139 	
140 
141     struct epoch  {
142         uint256 lockEndTime;
143         uint256 lockAmount;
144     }
145 
146     mapping(address=>epoch[]) public lockEpochsMap;
147 	 
148 
149     mapping(address => uint256) balances;
150 	mapping (address => mapping (address => uint256)) allowed;
151 	
152 
153 	function WTE(){
154 		totalSupply = 0 ;
155 		totalCommonWithdrawSupply=0;
156 		totalPartnerWithdrawSupply=0;
157 		totalPublicFundingSupply = 0;
158 		hasTeamKeepingWithdraw=false;
159 
160 
161 		startTime = 1525104000;
162 		endTime = 1525104000;
163 		rate=18300;
164 		publicFundingPersonalEthLimit = 10000000000000000000;
165 	}
166 
167 	event CreateWTE(address indexed _to, uint256 _value);
168 
169 
170 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
171 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
172 		_;
173 	}
174 
175 	modifier notReachPublicFundingSupply(uint256 _value,uint256 _rate){
176 		assert(MAX_PUBLIC_FUNDING_SUPPLY>=totalPublicFundingSupply.add(_value.mul(_rate)));
177 		_;
178 	}
179 
180 	modifier notReachCommonWithdrawSupply(uint256 _value,uint256 _rate){
181 		assert(COMMON_WITHDRAW_SUPPLY>=totalCommonWithdrawSupply.add(_value.mul(_rate)));
182 		_;
183 	}
184 
185 
186 	modifier notReachPartnerWithdrawSupply(uint256 _value,uint256 _rate){
187 		assert(PARTNER_SUPPLY>=totalPartnerWithdrawSupply.add(_value.mul(_rate)));
188 		_;
189 	}
190 
191 
192 	modifier assertFalse(bool withdrawStatus){
193 		assert(!withdrawStatus);
194 		_;
195 	}
196 
197 	modifier notBeforeTime(uint256 targetTime){
198 		assert(now>targetTime);
199 		_;
200 	}
201 
202 	modifier notAfterTime(uint256 targetTime){
203 		assert(now<=targetTime);
204 		_;
205 	}
206 
207 	function etherProceeds() external
208 		onlyOwner
209 
210 	{
211 		if(!msg.sender.send(this.balance)) revert();
212 	}
213 
214 
215 
216 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
217 		notReachTotalSupply(_value,_rate)
218 	{
219 		uint256 amount=_value.mul(_rate);
220 		totalSupply=totalSupply.add(amount);
221 		balances[receiver] +=amount;
222 		CreateWTE(receiver,amount);
223 		Transfer(0x0, receiver, amount);
224 	}
225 
226 
227 
228 	function commonWithdraw(uint256 _value) external
229 		onlyOwner
230 		notReachCommonWithdrawSupply(_value,1)
231 
232 	{
233 		processFunding(msg.sender,_value,1);
234 
235 		totalCommonWithdrawSupply=totalCommonWithdrawSupply.add(_value);
236 	}
237 
238 
239 
240 	function withdrawToTeam() external
241 		onlyOwner
242 		assertFalse(hasTeamKeepingWithdraw)
243 		notBeforeTime(1545753600)
244 	{
245 		processFunding(msg.sender,TEAM_KEEPING,1);
246 		hasTeamKeepingWithdraw = true;
247 	}
248 
249 
250 	function withdrawToPartner(address _to,uint256 _value) external
251 		onlyOwner
252 		notReachPartnerWithdrawSupply(_value,1)
253 	{
254 		processFunding(_to,_value,1);
255 		totalPartnerWithdrawSupply=totalPartnerWithdrawSupply.add(_value);
256 		lockBalance(_to,_value,1528473600);
257 	}
258 
259 
260 	function () payable external
261 		notBeforeTime(startTime)
262 		notAfterTime(endTime)
263 		notReachPublicFundingSupply(msg.value,rate)
264 	{
265 		require(publicFundingWhiteList[msg.sender]==1);
266 		require(userPublicFundingEthCountMap[msg.sender].add(msg.value)<=publicFundingPersonalEthLimit);
267 
268 		processFunding(msg.sender,msg.value,rate);
269 
270 		uint256 amount=msg.value.mul(rate);
271 		totalPublicFundingSupply = totalPublicFundingSupply.add(amount);
272 
273 		userPublicFundingEthCountMap[msg.sender] = userPublicFundingEthCountMap[msg.sender].add(msg.value);
274 	}
275 
276 
277 
278   	function transfer(address _to, uint256 _value) public  returns (bool)
279  	{
280 		require(_to != address(0));
281 
282 		epoch[] epochs = lockEpochsMap[msg.sender];
283 		uint256 needLockBalance = 0;
284 		for(uint256 i = 0;i<epochs.length;i++)
285 		{
286 			if( now < epochs[i].lockEndTime )
287 			{
288 				needLockBalance=needLockBalance.add(epochs[i].lockAmount);
289 			}
290 		}
291 
292 		require(balances[msg.sender].sub(_value)>=needLockBalance);
293 
294 		// SafeMath.sub will throw if there is not enough balance.
295 		balances[msg.sender] = balances[msg.sender].sub(_value);
296 		balances[_to] = balances[_to].add(_value);
297 		Transfer(msg.sender, _to, _value);
298 		return true;
299   	}
300 
301   	function balanceOf(address _owner) public constant returns (uint256 balance) 
302   	{
303 		return balances[_owner];
304   	}
305 
306 
307   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
308   	{
309 		require(_to != address(0));
310 
311 		epoch[] epochs = lockEpochsMap[_from];
312 		uint256 needLockBalance = 0;
313 		for(uint256 i = 0;i<epochs.length;i++)
314 		{
315 			if( now < epochs[i].lockEndTime )
316 			{
317 				needLockBalance = needLockBalance.add(epochs[i].lockAmount);
318 			}
319 		}
320 
321 		require(balances[_from].sub(_value)>=needLockBalance);
322 
323 		uint256 _allowance = allowed[_from][msg.sender];
324 
325 		balances[_from] = balances[_from].sub(_value);
326 		balances[_to] = balances[_to].add(_value);
327 		allowed[_from][msg.sender] = _allowance.sub(_value);
328 		Transfer(_from, _to, _value);
329 		return true;
330   	}
331 
332   	function approve(address _spender, uint256 _value) public returns (bool) 
333   	{
334 		allowed[msg.sender][_spender] = _value;
335 		Approval(msg.sender, _spender, _value);
336 		return true;
337   	}
338 
339   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
340   	{
341 		return allowed[_owner][_spender];
342   	}
343 
344 
345 
346 	function lockBalance(address user, uint256 lockAmount,uint256 lockEndTime) internal
347 	{
348 		 epoch[] storage epochs = lockEpochsMap[user];
349 		 epochs.push(epoch(lockEndTime,lockAmount));
350 	}
351 
352     function addPublicFundingWhiteList(address[] _list) external
353     	onlyOwner
354     {
355         uint256 count = _list.length;
356         for (uint256 i = 0; i < count; i++) {
357         	publicFundingWhiteList[_list [i]] = 1;
358         }    	
359     }
360 
361 	function refreshRate(uint256 _rate) external
362 		onlyOwner
363 	{
364 		rate=_rate;
365 	}
366 	
367     function refreshPublicFundingTime(uint256 _startTime,uint256 _endTime) external
368         onlyOwner
369     {
370 		startTime=_startTime;
371 		endTime=_endTime;
372     }
373 
374     function refreshPublicFundingPersonalEthLimit (uint256 _publicFundingPersonalEthLimit)  external
375     	onlyOwner
376     {
377     	publicFundingPersonalEthLimit=_publicFundingPersonalEthLimit;
378     }
379 
380 	  
381 }