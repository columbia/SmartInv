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
81 contract MINC is ERC20,Ownable{
82 	using SafeMath for uint256;
83 
84 	//the base info of the token
85 	string public constant name="MinerCoin";
86 	string public constant symbol="MINC";
87 	string public constant version = "1.0";
88 	uint256 public constant decimals = 18;
89 
90 	//奖励2亿
91 	uint256 public constant REWARD_SUPPLY=200000000*10**decimals;
92 	//运营2亿
93 	uint256 public constant OPERATE_SUPPLY=200000000*10**decimals;
94 
95 	//可普通提现额度4亿
96 	uint256 public constant COMMON_WITHDRAW_SUPPLY=REWARD_SUPPLY+OPERATE_SUPPLY;
97 
98 	//公募5亿
99 	uint256 public constant MAX_FUNDING_SUPPLY=500000000*10**decimals;
100 
101 	//团队持有1亿
102 	uint256 public constant TEAM_KEEPING=100000000*10**decimals;	
103 
104 	//总发行10亿
105 	uint256 public constant MAX_SUPPLY=COMMON_WITHDRAW_SUPPLY+MAX_FUNDING_SUPPLY+TEAM_KEEPING;
106 
107 	//已普通提现额度
108 	uint256 public totalCommonWithdrawSupply;
109 
110 	//公募参数
111 	//已经公募量
112 	uint256 public totalFundingSupply;
113 	uint256 public stepOneStartTime;
114 	uint256 public stepTwoStartTime;
115 	uint256 public endTime;
116 	uint256 public oneStepRate;
117 	uint256 public twoStepRate;
118 
119 	//团队每次解禁
120 	uint256 public constant TEAM_UNFREEZE=20000000*10**decimals;
121 	bool public hasOneStepWithdraw;
122 	bool public hasTwoStepWithdraw;
123 	bool public hasThreeStepWithdraw;
124 	bool public hasFourStepWithdraw;
125 	bool public hasFiveStepWithdraw;
126 
127 
128 	 
129 	//ERC20的余额
130     mapping(address => uint256) balances;
131 	mapping (address => mapping (address => uint256)) allowed;
132 	
133 
134 	function MINC(){
135 		totalCommonWithdrawSupply= 0;
136 		totalSupply = 0 ;
137 		totalFundingSupply = 0;
138 	
139 
140 		stepOneStartTime=1520352000;
141 		stepTwoStartTime=1521475200;
142 		endTime=1524153600;
143 
144 		oneStepRate=5000;
145 		twoStepRate=4000;
146 
147 		hasOneStepWithdraw=false;
148 		hasTwoStepWithdraw=false;
149 		hasThreeStepWithdraw=false;
150 		hasFourStepWithdraw=false;
151 		hasFiveStepWithdraw=false;
152 
153 	}
154 
155 	event CreateMINC(address indexed _to, uint256 _value);
156 
157 
158 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
159 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
160 		_;
161 	}
162 
163 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
164 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
165 		_;
166 	}
167 
168 	modifier notReachCommonWithdrawSupply(uint256 _value,uint256 _rate){
169 		assert(COMMON_WITHDRAW_SUPPLY>=totalCommonWithdrawSupply.add(_value.mul(_rate)));
170 		_;
171 	}
172 
173 
174 	modifier assertFalse(bool withdrawStatus){
175 		assert(!withdrawStatus);
176 		_;
177 	}
178 
179 	modifier notBeforeTime(uint256 targetTime){
180 		assert(now>targetTime);
181 		_;
182 	}
183 
184 	modifier notAfterTime(uint256 targetTime){
185 		assert(now<=targetTime);
186 		_;
187 	}
188 
189 
190 	//owner有权限提取账户中的eth
191 	function etherProceeds() external
192 		onlyOwner
193 
194 	{
195 		if(!msg.sender.send(this.balance)) revert();
196 	}
197 
198 
199 	//代币分发函数，内部使用
200 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
201 		notReachTotalSupply(_value,_rate)
202 	{
203 		uint256 amount=_value.mul(_rate);
204 		totalSupply=totalSupply.add(amount);
205 		balances[receiver] +=amount;
206 		CreateMINC(receiver,amount);
207 		Transfer(0x0, receiver, amount);
208 	}
209 
210 	function funding (address receiver,uint256 _value,uint256 _rate) internal 
211 		notReachFundingSupply(_value,_rate)
212 	{
213 		processFunding(receiver,_value,_rate);
214 		uint256 amount=_value.mul(_rate);
215 		totalFundingSupply = totalFundingSupply.add(amount);
216 	}
217 	
218 
219 	function () payable external
220 		notBeforeTime(stepOneStartTime)
221 		notAfterTime(endTime)
222 	{
223 		if(now>=stepOneStartTime&&now<stepTwoStartTime){
224 			funding(msg.sender,msg.value,oneStepRate);
225 		}else if(now>=stepTwoStartTime&&now<endTime){
226 			funding(msg.sender,msg.value,twoStepRate);
227 		}else {
228 			revert();
229 		}
230 
231 	}
232 
233 	//普通提币
234 	function commonWithdraw(uint256 _value) external
235 		onlyOwner
236 		notReachCommonWithdrawSupply(_value,1)
237 
238 	{
239 		processFunding(msg.sender,_value,1);
240 		//增加已经普通提现份额
241 		totalCommonWithdrawSupply=totalCommonWithdrawSupply.add(_value);
242 	}
243 	//20180907可提
244 	function withdrawForOneStep() external
245 		onlyOwner
246 		assertFalse(hasOneStepWithdraw)
247 		notBeforeTime(1536249600)
248 	{
249 		processFunding(msg.sender,TEAM_UNFREEZE,1);
250 		//标记团队已提现
251 		hasOneStepWithdraw = true;
252 	}
253 
254 	//20190307
255 	function withdrawForTwoStep() external
256 		onlyOwner
257 		assertFalse(hasTwoStepWithdraw)
258 		notBeforeTime(1551888000)
259 	{
260 		processFunding(msg.sender,TEAM_UNFREEZE,1);
261 		//标记团队已提现
262 		hasTwoStepWithdraw = true;
263 	}
264 
265 	//20190907
266 	function withdrawForThreeStep() external
267 		onlyOwner
268 		assertFalse(hasThreeStepWithdraw)
269 		notBeforeTime(1567785600)
270 	{
271 		processFunding(msg.sender,TEAM_UNFREEZE,1);
272 		//标记团队已提现
273 		hasThreeStepWithdraw = true;
274 	}
275 
276 	//20200307
277 	function withdrawForFourStep() external
278 		onlyOwner
279 		assertFalse(hasFourStepWithdraw)
280 		notBeforeTime(1583510400)
281 	{
282 		processFunding(msg.sender,TEAM_UNFREEZE,1);
283 		//标记团队已提现
284 		hasFourStepWithdraw = true;
285 	}
286 
287 	//20200907
288 	function withdrawForFiveStep() external
289 		onlyOwner
290 		assertFalse(hasFiveStepWithdraw)
291 		notBeforeTime(1599408000)
292 	{
293 		processFunding(msg.sender,TEAM_UNFREEZE,1);
294 		//标记团队已提现
295 		hasFiveStepWithdraw = true;
296 	}			
297 
298 
299   	function transfer(address _to, uint256 _value) public  returns (bool)
300  	{
301 		require(_to != address(0));
302 		// SafeMath.sub will throw if there is not enough balance.
303 		balances[msg.sender] = balances[msg.sender].sub(_value);
304 		balances[_to] = balances[_to].add(_value);
305 		Transfer(msg.sender, _to, _value);
306 		return true;
307   	}
308 
309   	function balanceOf(address _owner) public constant returns (uint256 balance) 
310   	{
311 		return balances[_owner];
312   	}
313 
314 
315   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
316   	{
317 		require(_to != address(0));
318 		uint256 _allowance = allowed[_from][msg.sender];
319 		balances[_from] = balances[_from].sub(_value);
320 		balances[_to] = balances[_to].add(_value);
321 		allowed[_from][msg.sender] = _allowance.sub(_value);
322 		Transfer(_from, _to, _value);
323 		return true;
324   	}
325 
326   	function approve(address _spender, uint256 _value) public returns (bool) 
327   	{
328 		allowed[msg.sender][_spender] = _value;
329 		Approval(msg.sender, _spender, _value);
330 		return true;
331   	}
332 
333   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
334   	{
335 		return allowed[_owner][_spender];
336   	}
337 
338 
339 	function setupFundingRate(uint256 _oneStepRate,uint256 _twoStepRate) external
340 		onlyOwner
341 	{
342 		oneStepRate=_oneStepRate;
343 		twoStepRate=_twoStepRate;
344 	}
345 
346     function setupFundingTime(uint256 _stepOneStartTime,uint256 _stepTwoStartTime,uint256 _endTime) external
347         onlyOwner
348     {
349 		stepOneStartTime=_stepOneStartTime;
350 		stepTwoStartTime=_stepTwoStartTime;
351 		endTime=_endTime;
352     }
353 	  
354 }