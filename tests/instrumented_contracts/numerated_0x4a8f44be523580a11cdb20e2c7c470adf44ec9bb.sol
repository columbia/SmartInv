1 pragma solidity ^0.4.13;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeMath {
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 contract Pausable is Ownable {
84   event Pause();
85   event Unpause();
86 
87   bool public paused = false;
88 
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is not paused.
92    */
93   modifier whenNotPaused() {
94     require(!paused);
95     _;
96   }
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is paused.
100    */
101   modifier whenPaused() {
102     require(paused);
103     _;
104   }
105 
106   /**
107    * @dev called by the owner to pause, triggers stopped state
108    */
109   function pause() onlyOwner whenNotPaused public {
110     paused = true;
111     Pause();
112   }
113 
114   /**
115    * @dev called by the owner to unpause, returns to normal state
116    */
117   function unpause() onlyOwner whenPaused public {
118     paused = false;
119     Unpause();
120   }
121 }
122 
123 
124 contract BTMC is ERC20,Ownable,Pausable{
125 	using SafeMath for uint256;
126 
127 	//the base info of the token
128 	string public constant name="MinerCoin";
129 	string public constant symbol="BTMC";
130 	string public constant version = "1.0";
131 	uint256 public constant decimals = 18;
132 
133 	//1亿团队持有
134 	uint256 public constant INIT_SUPPLY=100000000*10**decimals;
135 
136 	//挖矿5亿（代币阶段先不生成）
137 	uint256 public constant MINING_SUPPLY=500000000*10**decimals;
138 
139 
140 	//公募2亿
141 	uint256 public constant MAX_FUNDING_SUPPLY=200000000*10**decimals;
142 
143 	//团队锁定2亿
144 	uint256 public constant TEAM_KEEPING=200000000*10**decimals;	
145 
146 	//总发行10亿
147 	uint256 public constant MAX_SUPPLY=INIT_SUPPLY+MINING_SUPPLY+MAX_FUNDING_SUPPLY+TEAM_KEEPING;
148 
149 	//公募参数
150 	//已经公募量
151 	uint256 public totalFundingSupply;
152 	uint256 public startTime;
153 	uint256 public endTime;
154 	uint256 public rate;
155 
156 	//团队每次解禁
157 	uint256 public constant TEAM_UNFREEZE=40000000*10**decimals;
158 	bool public hasOneStepWithdraw;
159 	bool public hasTwoStepWithdraw;
160 	bool public hasThreeStepWithdraw;
161 	bool public hasFourStepWithdraw;
162 	bool public hasFiveStepWithdraw;
163 
164 
165 	 
166 	//ERC20的余额
167     mapping(address => uint256) balances;
168 	mapping (address => mapping (address => uint256)) allowed;
169 	
170 	function BTMC(){
171 		totalSupply=INIT_SUPPLY;
172 		balances[msg.sender] = INIT_SUPPLY;
173 		Transfer(0x0, msg.sender, INIT_SUPPLY);
174 		totalFundingSupply = 0;
175 	
176 		//20180423 235959
177 		startTime=1524499199;
178 		//20180515 000000
179 		endTime=1526313600;
180 		rate=5000;
181 
182 		hasOneStepWithdraw=false;
183 		hasTwoStepWithdraw=false;
184 		hasThreeStepWithdraw=false;
185 		hasFourStepWithdraw=false;
186 		hasFiveStepWithdraw=false;
187 
188 
189 
190 
191 	}
192 
193 	event CreateBTMC(address indexed _to, uint256 _value);
194 
195 
196 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
197 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
198 		_;
199 	}
200 
201 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
202 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
203 		_;
204 	}
205 	modifier assertFalse(bool withdrawStatus){
206 		assert(!withdrawStatus);
207 		_;
208 	}
209 
210 	modifier notBeforeTime(uint256 targetTime){
211 		assert(now>targetTime);
212 		_;
213 	}
214 
215 	modifier notAfterTime(uint256 targetTime){
216 		assert(now<=targetTime);
217 		_;
218 	}
219 
220 
221 	//owner有权限提取账户中的eth
222 	function etherProceeds() external
223 		onlyOwner
224 
225 	{
226 		if(!msg.sender.send(this.balance)) revert();
227 	}
228 
229 
230 	//代币分发函数，内部使用
231 	function processFunding(address receiver,uint256 _value,uint256 _rate)  internal
232 		notReachTotalSupply(_value,_rate)
233 	{
234 		uint256 amount=_value.mul(_rate);
235 		totalSupply=totalSupply.add(amount);
236 		balances[receiver] +=amount;
237 		CreateBTMC(receiver,amount);
238 		Transfer(0x0, receiver, amount);
239 	}
240 
241 	function funding (address receiver,uint256 _value,uint256 _rate) whenNotPaused internal 
242 		notReachFundingSupply(_value,_rate)
243 	{
244 		processFunding(receiver,_value,_rate);
245 		uint256 amount=_value.mul(_rate);
246 		totalFundingSupply = totalFundingSupply.add(amount);
247 	}
248 	
249 
250 	function () payable external
251 		notBeforeTime(startTime)
252 		notAfterTime(endTime)
253 	{
254 			funding(msg.sender,msg.value,rate);
255 	}
256 
257 
258 	//20200423 000000可提
259 	function withdrawForOneStep() external
260 		onlyOwner
261 		assertFalse(hasOneStepWithdraw)
262 		notBeforeTime(1587571200)
263 	{
264 		processFunding(msg.sender,TEAM_UNFREEZE,1);
265 		//标记团队已提现
266 		hasOneStepWithdraw = true;
267 	}
268 
269 	//20201023 000000
270 	function withdrawForTwoStep() external
271 		onlyOwner
272 		assertFalse(hasTwoStepWithdraw)
273 		notBeforeTime(1603382400)
274 	{
275 		processFunding(msg.sender,TEAM_UNFREEZE,1);
276 		//标记团队已提现
277 		hasTwoStepWithdraw = true;
278 	}
279 
280 	//20210423 000000
281 	function withdrawForThreeStep() external
282 		onlyOwner
283 		assertFalse(hasThreeStepWithdraw)
284 		notBeforeTime(1619107200)
285 	{
286 		processFunding(msg.sender,TEAM_UNFREEZE,1);
287 		//标记团队已提现
288 		hasThreeStepWithdraw = true;
289 	}
290 
291 	//20211023 000000
292 	function withdrawForFourStep() external
293 		onlyOwner
294 		assertFalse(hasFourStepWithdraw)
295 		notBeforeTime(1634918400)
296 	{
297 		processFunding(msg.sender,TEAM_UNFREEZE,1);
298 		//标记团队已提现
299 		hasFourStepWithdraw = true;
300 	}
301 
302 	//20220423 000000
303 	function withdrawForFiveStep() external
304 		onlyOwner
305 		assertFalse(hasFiveStepWithdraw)
306 		notBeforeTime(1650643200)
307 	{
308 		processFunding(msg.sender,TEAM_UNFREEZE,1);
309 		//标记团队已提现
310 		hasFiveStepWithdraw = true;
311 	}			
312 
313 
314   	function transfer(address _to, uint256 _value) whenNotPaused public  returns (bool)
315  	{
316 		require(_to != address(0));
317 		// SafeMath.sub will throw if there is not enough balance.
318 		balances[msg.sender] = balances[msg.sender].sub(_value);
319 		balances[_to] = balances[_to].add(_value);
320 		Transfer(msg.sender, _to, _value);
321 		return true;
322   	}
323 
324   	function balanceOf(address _owner) public constant returns (uint256 balance) 
325   	{
326 		return balances[_owner];
327   	}
328 
329 
330   	function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) 
331   	{
332 		require(_to != address(0));
333 		uint256 _allowance = allowed[_from][msg.sender];
334 		balances[_from] = balances[_from].sub(_value);
335 		balances[_to] = balances[_to].add(_value);
336 		allowed[_from][msg.sender] = _allowance.sub(_value);
337 		Transfer(_from, _to, _value);
338 		return true;
339   	}
340 
341   	function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) 
342   	{
343 		allowed[msg.sender][_spender] = _value;
344 		Approval(msg.sender, _spender, _value);
345 		return true;
346   	}
347 
348   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
349   	{
350 		return allowed[_owner][_spender];
351   	}
352 
353 
354 	function setupFundingRate(uint256 _rate) external
355 		onlyOwner
356 	{
357 		rate=_rate;
358 	}
359 
360     function setupFundingTime(uint256 _startTime,uint256 _endTime) external
361         onlyOwner
362     {
363 		startTime=_startTime;
364 		endTime=_endTime;
365     }
366 	  
367 }