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
83 
84 contract BTMC is ERC20,Ownable{
85 	using SafeMath for uint256;
86 
87 	//the base info of the token
88 	string public constant name="MinerCoin";
89 	string public constant symbol="BTMC";
90 	string public constant version = "1.0";
91 	uint256 public constant decimals = 18;
92 
93 	//奖励2亿
94 	uint256 public constant REWARD_SUPPLY=200000000*10**decimals;
95 	//运营2亿
96 	uint256 public constant OPERATE_SUPPLY=200000000*10**decimals;
97 
98 	//可普通提现额度4亿
99 	uint256 public constant COMMON_WITHDRAW_SUPPLY=REWARD_SUPPLY+OPERATE_SUPPLY;
100 
101 	//公募5亿
102 	uint256 public constant MAX_FUNDING_SUPPLY=500000000*10**decimals;
103 
104 	//团队持有1亿
105 	uint256 public constant TEAM_KEEPING=100000000*10**decimals;	
106 
107 	//总发行10亿
108 	uint256 public constant MAX_SUPPLY=COMMON_WITHDRAW_SUPPLY+MAX_FUNDING_SUPPLY+TEAM_KEEPING;
109 
110 	//已普通提现额度
111 	uint256 public totalCommonWithdrawSupply;
112 
113 	//公募参数
114 	//已经公募量
115 	uint256 public totalFundingSupply;
116 	uint256 public stepOneStartTime;
117 	uint256 public stepTwoStartTime;
118 	uint256 public endTime;
119 	uint256 public oneStepRate;
120 	uint256 public twoStepRate;
121 
122 	//团队每次解禁
123 	uint256 public constant TEAM_UNFREEZE=20000000*10**decimals;
124 	bool public hasOneStepWithdraw;
125 	bool public hasTwoStepWithdraw;
126 	bool public hasThreeStepWithdraw;
127 	bool public hasFourStepWithdraw;
128 	bool public hasFiveStepWithdraw;
129 
130 
131 	 
132 	//ERC20的余额
133     mapping(address => uint256) balances;
134 	mapping (address => mapping (address => uint256)) allowed;
135 	
136 
137 	function BTMC(){
138 		totalCommonWithdrawSupply= 0;
139 		totalSupply = 0 ;
140 		totalFundingSupply = 0;
141 	
142 
143 		stepOneStartTime=1520352000;
144 		stepTwoStartTime=1521475200;
145 		endTime=1524153600;
146 
147 		oneStepRate=5000;
148 		twoStepRate=4000;
149 
150 		hasOneStepWithdraw=false;
151 		hasTwoStepWithdraw=false;
152 		hasThreeStepWithdraw=false;
153 		hasFourStepWithdraw=false;
154 		hasFiveStepWithdraw=false;
155 
156 	}
157 
158 	event CreateBTMC(address indexed _to, uint256 _value);
159 
160 
161 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
162 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
163 		_;
164 	}
165 
166 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
167 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
168 		_;
169 	}
170 
171 	modifier notReachCommonWithdrawSupply(uint256 _value,uint256 _rate){
172 		assert(COMMON_WITHDRAW_SUPPLY>=totalCommonWithdrawSupply.add(_value.mul(_rate)));
173 		_;
174 	}
175 
176 
177 	modifier assertFalse(bool withdrawStatus){
178 		assert(!withdrawStatus);
179 		_;
180 	}
181 
182 	modifier notBeforeTime(uint256 targetTime){
183 		assert(now>targetTime);
184 		_;
185 	}
186 
187 	modifier notAfterTime(uint256 targetTime){
188 		assert(now<=targetTime);
189 		_;
190 	}
191 
192 
193 	//owner有权限提取账户中的eth
194 	function etherProceeds() external
195 		onlyOwner
196 
197 	{
198 		if(!msg.sender.send(this.balance)) revert();
199 	}
200 
201 
202 	//代币分发函数，内部使用
203 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
204 		notReachTotalSupply(_value,_rate)
205 	{
206 		uint256 amount=_value.mul(_rate);
207 		totalSupply=totalSupply.add(amount);
208 		balances[receiver] +=amount;
209 		CreateBTMC(receiver,amount);
210 		Transfer(0x0, receiver, amount);
211 	}
212 
213 	function funding (address receiver,uint256 _value,uint256 _rate) internal 
214 		notReachFundingSupply(_value,_rate)
215 	{
216 		processFunding(receiver,_value,_rate);
217 		uint256 amount=_value.mul(_rate);
218 		totalFundingSupply = totalFundingSupply.add(amount);
219 	}
220 	
221 
222 	function () payable external
223 		notBeforeTime(stepOneStartTime)
224 		notAfterTime(endTime)
225 	{
226 		if(now>=stepOneStartTime&&now<stepTwoStartTime){
227 			funding(msg.sender,msg.value,oneStepRate);
228 		}else if(now>=stepTwoStartTime&&now<endTime){
229 			funding(msg.sender,msg.value,twoStepRate);
230 		}else {
231 			revert();
232 		}
233 
234 	}
235 
236 	//普通提币
237 	function commonWithdraw(uint256 _value) external
238 		onlyOwner
239 		notReachCommonWithdrawSupply(_value,1)
240 
241 	{
242 		processFunding(msg.sender,_value,1);
243 		//增加已经普通提现份额
244 		totalCommonWithdrawSupply=totalCommonWithdrawSupply.add(_value);
245 	}
246 	//20180907可提
247 	function withdrawForOneStep() external
248 		onlyOwner
249 		assertFalse(hasOneStepWithdraw)
250 		notBeforeTime(1536249600)
251 	{
252 		processFunding(msg.sender,TEAM_UNFREEZE,1);
253 		//标记团队已提现
254 		hasOneStepWithdraw = true;
255 	}
256 
257 	//20190307
258 	function withdrawForTwoStep() external
259 		onlyOwner
260 		assertFalse(hasTwoStepWithdraw)
261 		notBeforeTime(1551888000)
262 	{
263 		processFunding(msg.sender,TEAM_UNFREEZE,1);
264 		//标记团队已提现
265 		hasTwoStepWithdraw = true;
266 	}
267 
268 	//20190907
269 	function withdrawForThreeStep() external
270 		onlyOwner
271 		assertFalse(hasThreeStepWithdraw)
272 		notBeforeTime(1567785600)
273 	{
274 		processFunding(msg.sender,TEAM_UNFREEZE,1);
275 		//标记团队已提现
276 		hasThreeStepWithdraw = true;
277 	}
278 
279 	//20200307
280 	function withdrawForFourStep() external
281 		onlyOwner
282 		assertFalse(hasFourStepWithdraw)
283 		notBeforeTime(1583510400)
284 	{
285 		processFunding(msg.sender,TEAM_UNFREEZE,1);
286 		//标记团队已提现
287 		hasFourStepWithdraw = true;
288 	}
289 
290 	//20200907
291 	function withdrawForFiveStep() external
292 		onlyOwner
293 		assertFalse(hasFiveStepWithdraw)
294 		notBeforeTime(1599408000)
295 	{
296 		processFunding(msg.sender,TEAM_UNFREEZE,1);
297 		//标记团队已提现
298 		hasFiveStepWithdraw = true;
299 	}			
300 
301 
302   	function transfer(address _to, uint256 _value) public  returns (bool)
303  	{
304 		require(_to != address(0));
305 		// SafeMath.sub will throw if there is not enough balance.
306 		balances[msg.sender] = balances[msg.sender].sub(_value);
307 		balances[_to] = balances[_to].add(_value);
308 		Transfer(msg.sender, _to, _value);
309 		return true;
310   	}
311 
312   	function balanceOf(address _owner) public constant returns (uint256 balance) 
313   	{
314 		return balances[_owner];
315   	}
316 
317 
318   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
319   	{
320 		require(_to != address(0));
321 		uint256 _allowance = allowed[_from][msg.sender];
322 		balances[_from] = balances[_from].sub(_value);
323 		balances[_to] = balances[_to].add(_value);
324 		allowed[_from][msg.sender] = _allowance.sub(_value);
325 		Transfer(_from, _to, _value);
326 		return true;
327   	}
328 
329   	function approve(address _spender, uint256 _value) public returns (bool) 
330   	{
331 		allowed[msg.sender][_spender] = _value;
332 		Approval(msg.sender, _spender, _value);
333 		return true;
334   	}
335 
336   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
337   	{
338 		return allowed[_owner][_spender];
339   	}
340 
341 
342 	function setupFundingRate(uint256 _oneStepRate,uint256 _twoStepRate) external
343 		onlyOwner
344 	{
345 		oneStepRate=_oneStepRate;
346 		twoStepRate=_twoStepRate;
347 	}
348 
349     function setupFundingTime(uint256 _stepOneStartTime,uint256 _stepTwoStartTime,uint256 _endTime) external
350         onlyOwner
351     {
352 		stepOneStartTime=_stepOneStartTime;
353 		stepTwoStartTime=_stepTwoStartTime;
354 		endTime=_endTime;
355     }
356 	  
357 }