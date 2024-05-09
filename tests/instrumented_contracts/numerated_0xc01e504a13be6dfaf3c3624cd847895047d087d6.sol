1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 
73 
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     if (a == 0) {
82       return 0;
83     }
84     uint256 c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return c;
94   }
95 
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     assert(c >= a);
104     return c;
105   }
106 }
107 contract XMB is ERC20,Ownable{
108 	using SafeMath for uint256;
109 
110 	//the base info of the token
111 	string public constant name="XMB";
112 	string public constant symbol="XMB";
113 	string public constant version = "1.0";
114 	uint256 public constant decimals = 18;
115 
116     mapping(address => uint256) balances;
117 	mapping (address => mapping (address => uint256)) allowed;
118 	//总发行10亿
119 	uint256 public constant MAX_SUPPLY=1000000000*10**decimals;
120 	//初始发行3亿，用于空投和团队保留
121 	uint256 public constant INIT_SUPPLY=300000000*10**decimals;
122 
123 	//第一阶段兑换比例
124 	uint256 public stepOneRate;
125 	//第二阶段兑换比例
126 	uint256 public stepTwoRate;
127 
128 	//第一阶段开始时间
129 	uint256 public stepOneStartTime;
130 	//第一阶段结束时间
131 	uint256 public stepOneEndTime;
132 
133 
134 	//第二阶段开始时间
135 	uint256 public stepTwoStartTime;
136 	//第二阶段结束时间
137 	uint256 public stepTwoEndTime;
138 
139 	//锁仓截止日期1
140 	uint256 public stepOneLockEndTime;
141 
142 	//锁仓截止日期2
143 	uint256 public stepTwoLockEndTime;
144 
145 	//已经空投量
146 	uint256 public airdropSupply;
147 
148 	//期数
149     struct epoch  {
150         uint256 endTime;
151         uint256 amount;
152     }
153 
154 	//各个用户的锁仓金额
155 	mapping(address=>epoch[]) public lockEpochsMap;
156 
157 
158 	function XMB(){
159 		airdropSupply = 0;
160 		//第一阶段5w个
161 		stepOneRate = 50000;
162 		//第二阶段2.5w个
163 		stepTwoRate = 25000;
164 		//20180214 00:00:00
165 		stepOneStartTime=1518537600;
166 		//20180220 00:00:00
167 		stepOneEndTime=1519056000;
168 
169 
170 		//20180220 00:00:00
171 		stepTwoStartTime=1519056000;
172 		//20180225 00:00:00
173 		stepTwoEndTime=1519488000;
174 
175 		//20180501 00:00:00
176 		stepOneLockEndTime = 1525104000;
177 
178 		//20180401 00:00:00
179 		stepTwoLockEndTime = 1522512000;
180 
181 		totalSupply = INIT_SUPPLY;
182 		balances[msg.sender] = INIT_SUPPLY;
183 		Transfer(0x0, msg.sender, INIT_SUPPLY);
184 	}
185 
186 	modifier totalSupplyNotReached(uint256 _ethContribution,uint rate){
187 		assert(totalSupply.add(_ethContribution.mul(rate)) <= MAX_SUPPLY);
188 		_;
189 	}
190 
191 
192 	//空投
193     function airdrop(address [] _holders,uint256 paySize) external
194     	onlyOwner 
195 	{
196         uint256 count = _holders.length;
197         assert(paySize.mul(count) <= balanceOf(msg.sender));
198         for (uint256 i = 0; i < count; i++) {
199             transfer(_holders [i], paySize);
200 			airdropSupply = airdropSupply.add(paySize);
201         }
202     }
203 
204 
205 	//允许用户往合约账户打币
206 	function () payable external
207 	{
208 			if(now > stepOneStartTime&&now<=stepOneEndTime){
209 				processFunding(msg.sender,msg.value,stepOneRate);
210 				//设置锁仓
211 				uint256 stepOnelockAmount = msg.value.mul(stepOneRate);
212 				lockBalance(msg.sender,stepOnelockAmount,stepOneLockEndTime);
213 			}else if(now > stepTwoStartTime&&now<=stepTwoEndTime){
214 				processFunding(msg.sender,msg.value,stepTwoRate);
215 				//设置锁仓
216 				uint256 stepTwolockAmount = msg.value.mul(stepTwoRate);
217 				lockBalance(msg.sender,stepTwolockAmount,stepTwoLockEndTime);				
218 			}else{
219 				revert();
220 			}
221 	}
222 
223 	//owner有权限提取账户中的eth
224 	function etherProceeds() external
225 		onlyOwner
226 
227 	{
228 		if(!msg.sender.send(this.balance)) revert();
229 	}
230 
231 	//设置锁仓
232 	function lockBalance(address user, uint256 amount,uint256 endTime) internal
233 	{
234 		 epoch[] storage epochs = lockEpochsMap[user];
235 		 epochs.push(epoch(endTime,amount));
236 	}
237 
238 	function processFunding(address receiver,uint256 _value,uint256 fundingRate) internal
239 		totalSupplyNotReached(_value,fundingRate)
240 
241 	{
242 		uint256 tokenAmount = _value.mul(fundingRate);
243 		totalSupply=totalSupply.add(tokenAmount);
244 		balances[receiver] += tokenAmount;  // safeAdd not needed; bad semantics to use here
245 		Transfer(0x0, receiver, tokenAmount);
246 	}
247 
248 
249 	function setStepOneRate (uint256 _rate)  external 
250 		onlyOwner
251 	{
252 		stepOneRate=_rate;
253 	}
254 	function setStepTwoRate (uint256 _rate)  external 
255 		onlyOwner
256 	{
257 		stepTwoRate=_rate;
258 	}	
259 
260 	function setStepOneTime (uint256 _stepOneStartTime,uint256 _stepOneEndTime)  external 
261 		onlyOwner
262 	{
263 		stepOneStartTime=_stepOneStartTime;
264 		stepOneEndTime = _stepOneEndTime;
265 	}	
266 
267 	function setStepTwoTime (uint256 _stepTwoStartTime,uint256 _stepTwoEndTime)  external 
268 		onlyOwner
269 	{
270 		stepTwoStartTime=_stepTwoStartTime;
271 		stepTwoEndTime = _stepTwoEndTime;
272 	}	
273 
274 	function setStepOneLockEndTime (uint256 _stepOneLockEndTime) external
275 		onlyOwner
276 	{
277 		stepOneLockEndTime = _stepOneLockEndTime;
278 	}
279 	
280 	function setStepTwoLockEndTime (uint256 _stepTwoLockEndTime) external
281 		onlyOwner
282 	{
283 		stepTwoLockEndTime = _stepTwoLockEndTime;
284 	}
285 
286   //转账前，先校验减去转出份额后，是否大于等于锁仓份额
287   	function transfer(address _to, uint256 _value) public  returns (bool)
288  	{
289 		require(_to != address(0));
290 		//计算锁仓份额
291 		epoch[] epochs = lockEpochsMap[msg.sender];
292 		uint256 needLockBalance = 0;
293 		for(uint256 i;i<epochs.length;i++)
294 		{
295 			//如果当前时间小于当期结束时间,则此期有效
296 			if( now < epochs[i].endTime )
297 			{
298 				needLockBalance=needLockBalance.add(epochs[i].amount);
299 			}
300 		}
301 
302 		require(balances[msg.sender].sub(_value)>=needLockBalance);
303 		// SafeMath.sub will throw if there is not enough balance.
304 		balances[msg.sender] = balances[msg.sender].sub(_value);
305 		balances[_to] = balances[_to].add(_value);
306 		Transfer(msg.sender, _to, _value);
307 		return true;
308   	}
309 
310   	function balanceOf(address _owner) public constant returns (uint256 balance) 
311   	{
312 		return balances[_owner];
313   	}
314 
315 
316   //从委托人账上转出份额时，还要判断委托人的余额-转出份额是否大于等于锁仓份额
317   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
318   	{
319 		require(_to != address(0));
320 
321 		//计算锁仓份额
322 		epoch[] epochs = lockEpochsMap[_from];
323 		uint256 needLockBalance = 0;
324 		for(uint256 i;i<epochs.length;i++)
325 		{
326 			//如果当前时间小于当期结束时间,则此期有效
327 			if( now < epochs[i].endTime )
328 			{
329 				needLockBalance = needLockBalance.add(epochs[i].amount);
330 			}
331 		}
332 
333 		require(balances[_from].sub(_value)>=needLockBalance);
334 		uint256 _allowance = allowed[_from][msg.sender];
335 
336 		balances[_from] = balances[_from].sub(_value);
337 		balances[_to] = balances[_to].add(_value);
338 		allowed[_from][msg.sender] = _allowance.sub(_value);
339 		Transfer(_from, _to, _value);
340 		return true;
341   	}
342 
343   	function approve(address _spender, uint256 _value) public returns (bool) 
344   	{
345 		allowed[msg.sender][_spender] = _value;
346 		Approval(msg.sender, _spender, _value);
347 		return true;
348   	}
349 
350   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
351   	{
352 		return allowed[_owner][_spender];
353   	}
354 
355 	  
356 }