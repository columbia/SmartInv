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
80 contract CCMToken is ERC20,Ownable{
81 	using SafeMath for uint256;
82 
83 	//the base info of the token
84 	string public constant name="Chain cell matrix";
85 	string public symbol;
86 	string public constant version = "1.0";
87 	uint256 public constant decimals = 18;
88 
89 	//总发行30亿
90 	uint256 public constant MAX_SUPPLY=3000000000*10**decimals;
91 
92 	//投资人持有1.2亿
93 	uint256 public constant PARTNER_SUPPLY=120000000*10**decimals;
94 	//已经分配给投资人的份额
95 	uint256 public totalPartnerSupply;
96 
97 	//私募9亿
98 	uint256 public constant MAX_FUNDING_SUPPLY=900000000*10**decimals;
99 	//私募比例，按eth 3000来算，1:75000的兑换比例，私募价为0.04
100 	uint256 public rate;
101 	//已经私募量
102 	uint256 public totalFundingSupply;
103 
104 	//团队奖励5.4亿
105 	uint256 public constant TEAM_KEEPING=540000000*10**decimals;
106 	bool public hasTeamKeepingWithdraw;
107 
108 	//1年解禁
109 	uint256 public constant ONE_YEAR_KEEPING=432000000*10**decimals;
110 	bool public hasOneYearWithdraw;
111 
112 	//2年解禁
113 	uint256 public constant TWO_YEAR_KEEPING=432000000*10**decimals;
114 	bool public hasTwoYearWithdraw;
115 
116 	//3年解禁
117 	uint256 public constant THREE_YEAR_KEEPING=576000000*10**decimals;	
118 	bool public hasThreeYearWithdraw;
119 
120 	//私募开始结束时间
121 	uint256 public startBlock;
122 	uint256 public endBlock;
123 	
124 
125 	//各个用户的锁仓金额
126 	mapping(address=>uint256) public lockBalance;
127 	//锁仓百分比
128 	uint256 public lockRate;
129 
130 
131 	 
132 	//ERC20的余额
133     mapping(address => uint256) balances;
134 	mapping (address => mapping (address => uint256)) allowed;
135 	
136 
137 	function CCMToken(){
138 		totalSupply = 0 ;
139 		totalFundingSupply = 0;
140 		totalPartnerSupply= 0;
141 
142 		hasTeamKeepingWithdraw=false;
143 		hasOneYearWithdraw=false;
144 		hasTwoYearWithdraw=false;
145 		hasThreeYearWithdraw=false;
146 
147 		startBlock = 4000000;
148 		endBlock = 5000000;
149 		lockRate=100;
150 		rate=75000;
151 		symbol="CCM";
152 	}
153 
154 	event CreateCCM(address indexed _to, uint256 _value);
155 
156 	modifier beforeBlock(uint256 _blockNum){
157 		assert(getCurrentBlockNum()<_blockNum);
158 		_;
159 	}
160 
161 	modifier afterBlock(uint256 _blockNum){
162 		assert(getCurrentBlockNum()>=_blockNum);
163 		_;
164 	}
165 
166 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
167 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
168 		_;
169 	}
170 
171 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
172 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
173 		_;
174 	}
175 
176 	modifier notReachPartnerWithdrawSupply(uint256 _value,uint256 _rate){
177 		assert(PARTNER_SUPPLY>=totalPartnerSupply.add(_value.mul(_rate)));
178 		_;
179 	}
180 
181 	modifier assertFalse(bool withdrawStatus){
182 		assert(!withdrawStatus);
183 		_;
184 	}
185 
186 	modifier notBeforeTime(uint256 targetTime){
187 		assert(now>targetTime);
188 		_;
189 	}
190 
191 
192 	//owner有权限提取账户中的eth
193 	function etherProceeds() external
194 		onlyOwner
195 
196 	{
197 		if(!msg.sender.send(this.balance)) revert();
198 	}
199 
200 
201 	//代币分发函数，内部使用
202 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
203 		notReachTotalSupply(_value,_rate)
204 	{
205 		uint256 amount=_value.mul(_rate);
206 		totalSupply=totalSupply.add(amount);
207 		balances[receiver] +=amount;
208 		CreateCCM(receiver,amount);
209 		Transfer(0x0, receiver, amount);
210 	}
211 
212 
213 
214 	//分配代币给股东
215 	function withdrawToPartner(address partnerAddress,uint256 _value) external
216 		onlyOwner
217 		notReachPartnerWithdrawSupply(_value,1)
218 
219 	{
220 		processFunding(partnerAddress,_value,1);
221 		//增加股东已分配份额
222 		totalPartnerSupply=totalPartnerSupply.add(_value);
223 
224 		//股东要锁仓，记录锁仓份额
225 		lockBalance[partnerAddress]=lockBalance[partnerAddress].add(_value);
226 	}
227 
228 	//私募，不超过最大私募份额,要在私募时间内
229 	function () payable external
230 		afterBlock(startBlock)
231 		beforeBlock(endBlock)
232 		notReachFundingSupply(msg.value,rate)
233 	{
234 		processFunding(msg.sender,msg.value,rate);
235 		//增加已私募份额
236 		uint256 amount=msg.value.mul(rate);
237 		totalFundingSupply = totalFundingSupply.add(amount);
238 
239 		//私募的用户，都要锁仓，记录锁仓份额
240 		lockBalance[msg.sender]=lockBalance[msg.sender].add(amount);
241 	}
242 
243 
244 
245 	//团队提币，提到owner账户，只有未提过才能提
246 	function withdrawToTeam() external
247 		onlyOwner
248 		assertFalse(hasTeamKeepingWithdraw)
249 	{
250 		processFunding(msg.sender,TEAM_KEEPING,1);
251 		//标记团队已提现
252 		hasTeamKeepingWithdraw = true;
253 	}
254 
255 	//一年解禁，提到owner账户，只有未提过才能提 ,
256 	function withdrawForOneYear() external
257 		onlyOwner
258 		assertFalse(hasOneYearWithdraw)
259 		notBeforeTime(1514736000)
260 	{
261 		processFunding(msg.sender,ONE_YEAR_KEEPING,1);
262 		//标记团队已提现
263 		hasOneYearWithdraw = true;
264 	}
265 
266 	//两年解禁，提到owner账户，只有未提过才能提
267 	function withdrawForTwoYear() external
268 		onlyOwner
269 		assertFalse(hasTwoYearWithdraw)
270 		notBeforeTime(1546272000)
271 	{
272 		processFunding(msg.sender,TWO_YEAR_KEEPING,1);
273 		//标记团队已提现
274 		hasTwoYearWithdraw = true;
275 	}
276 
277 	//三年解禁，提到owner账户，只有未提过才能提
278 	function withdrawForThreeYear() external
279 		onlyOwner
280 		assertFalse(hasThreeYearWithdraw)
281 		notBeforeTime(1577808000)
282 	{
283 		processFunding(msg.sender,THREE_YEAR_KEEPING,1);
284 		//标记团队已提现
285 		hasThreeYearWithdraw = true;
286 	}
287 
288 
289   //转账前，先校验减去转出份额后，是否大于等于锁仓份额
290   	function transfer(address _to, uint256 _value) public  returns (bool)
291  	{
292 		require(_to != address(0));
293 		require(balances[msg.sender].sub(_value)>=lockBalance[msg.sender].mul(lockRate).div(100));
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
307   //从委托人账上转出份额时，还要判断委托人的余额-转出份额是否大于等于锁仓份额
308   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
309   	{
310 		require(_to != address(0));
311 		require(balances[_from].sub(_value)>=lockBalance[_from].mul(lockRate).div(100));
312 		uint256 _allowance = allowed[_from][msg.sender];
313 
314 		balances[_from] = balances[_from].sub(_value);
315 		balances[_to] = balances[_to].add(_value);
316 		allowed[_from][msg.sender] = _allowance.sub(_value);
317 		Transfer(_from, _to, _value);
318 		return true;
319   	}
320 
321   	function approve(address _spender, uint256 _value) public returns (bool) 
322   	{
323 		allowed[msg.sender][_spender] = _value;
324 		Approval(msg.sender, _spender, _value);
325 		return true;
326   	}
327 
328   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
329   	{
330 		return allowed[_owner][_spender];
331   	}
332 
333 	function getCurrentBlockNum() internal returns (uint256)
334 	{
335 		return block.number;
336 	}
337 
338 
339 	function setSymbol(string _symbol) external
340 		onlyOwner
341 	{
342 		symbol=_symbol;
343 	}
344 
345 
346 	function setRate(uint256 _rate) external
347 		onlyOwner
348 	{
349 		rate=_rate;
350 	}
351 
352 	function setLockRate(uint256 _lockRate) external
353 		onlyOwner
354 	{
355 		lockRate=_lockRate;
356 	}
357 	
358     function setupFundingInfo(uint256 _startBlock,uint256 _endBlock) external
359         onlyOwner
360     {
361 		startBlock=_startBlock;
362 		endBlock=_endBlock;
363     }
364 	  
365 }