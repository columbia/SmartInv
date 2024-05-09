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
82 contract BIU is ERC20,Ownable{
83 	using SafeMath for uint256;
84 
85 	//the base info of the token
86 	string public constant name="BigBull";
87 	string public constant symbol="BIU";
88 	string public constant version = "1.0";
89 	uint256 public constant decimals = 18;
90 
91 	//总发行2亿
92 	uint256 public constant MAX_SUPPLY=200000000*10**decimals;
93 
94 	uint256 public constant INIT_SUPPLY=20000000*10**decimals;
95 
96 	//公募1亿
97 	uint256 public constant MAX_FUNDING_SUPPLY=100000000*10**decimals;
98 
99 	//已经公募量
100 	uint256 public totalFundingSupply;
101 
102 
103 	//1年解禁
104 	uint256 public constant ONE_YEAR_KEEPING=16000000*10**decimals;
105 	bool public hasOneYearWithdraw;
106 
107 	//2年解禁
108 	uint256 public constant TWO_YEAR_KEEPING=16000000*10**decimals;
109 	bool public hasTwoYearWithdraw;
110 
111 	//3年解禁
112 	uint256 public constant THREE_YEAR_KEEPING=16000000*10**decimals;	
113 	bool public hasThreeYearWithdraw;
114 
115 
116 	//4年解禁
117 	uint256 public constant FOUR_YEAR_KEEPING=16000000*10**decimals;	
118 	bool public hasFourYearWithdraw;
119 
120 	//5年解禁
121 	uint256 public constant FIVE_YEAR_KEEPING=16000000*10**decimals;	
122 	bool public hasFiveYearWithdraw;
123 
124 
125 	//私募开始结束时间
126 	uint256 public startBlock;
127 	uint256 public endBlock;
128 	uint256 public rate;
129 
130 	 
131 	//ERC20的余额
132     mapping(address => uint256) balances;
133 	mapping (address => mapping (address => uint256)) allowed;
134 	
135 
136 	function BIU(){
137 		totalSupply = 0 ;
138 		totalFundingSupply = 0;
139 
140 		hasOneYearWithdraw=false;
141 		hasTwoYearWithdraw=false;
142 		hasThreeYearWithdraw=false;
143 		hasFourYearWithdraw=false;
144 		hasFiveYearWithdraw=false;
145 
146 		startBlock = 4000000;
147 		endBlock = 6000000;
148 		rate=8000;
149 
150 		//初始分发
151 		totalSupply=INIT_SUPPLY;
152 		balances[msg.sender] = INIT_SUPPLY;
153 		Transfer(0x0, msg.sender, INIT_SUPPLY);
154 	}
155 
156 	event CreateBIU(address indexed _to, uint256 _value);
157 
158 	modifier beforeBlock(uint256 _blockNum){
159 		assert(getCurrentBlockNum()<_blockNum);
160 		_;
161 	}
162 
163 	modifier afterBlock(uint256 _blockNum){
164 		assert(getCurrentBlockNum()>=_blockNum);
165 		_;
166 	}
167 
168 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
169 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
170 		_;
171 	}
172 
173 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
174 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
175 		_;
176 	}
177 
178 
179 	modifier assertFalse(bool withdrawStatus){
180 		assert(!withdrawStatus);
181 		_;
182 	}
183 
184 	modifier notBeforeTime(uint256 targetTime){
185 		assert(now>targetTime);
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
206 		CreateBIU(receiver,amount);
207 		Transfer(0x0, receiver, amount);
208 	}
209 
210 
211 
212 
213 	function () payable external
214 		afterBlock(startBlock)
215 		beforeBlock(endBlock)
216 		notReachFundingSupply(msg.value,rate)
217 	{
218 		processFunding(msg.sender,msg.value,rate);
219 		uint256 amount=msg.value.mul(rate);
220 		totalFundingSupply = totalFundingSupply.add(amount);
221 	}
222 
223 
224 
225 
226 	//一年解禁，提到owner账户，只有未提过才能提 ,
227 	function withdrawForOneYear() external
228 		onlyOwner
229 		assertFalse(hasOneYearWithdraw)
230 		notBeforeTime(1514736000)
231 	{
232 		processFunding(msg.sender,ONE_YEAR_KEEPING,1);
233 		//标记团队已提现
234 		hasOneYearWithdraw = true;
235 	}
236 
237 	//两年解禁，提到owner账户，只有未提过才能提
238 	function withdrawForTwoYear() external
239 		onlyOwner
240 		assertFalse(hasTwoYearWithdraw)
241 		notBeforeTime(1546272000)
242 	{
243 		processFunding(msg.sender,TWO_YEAR_KEEPING,1);
244 		//标记团队已提现
245 		hasTwoYearWithdraw = true;
246 	}
247 
248 	//三年解禁，提到owner账户，只有未提过才能提
249 	function withdrawForThreeYear() external
250 		onlyOwner
251 		assertFalse(hasThreeYearWithdraw)
252 		notBeforeTime(1577808000)
253 	{
254 		processFunding(msg.sender,THREE_YEAR_KEEPING,1);
255 		//标记团队已提现
256 		hasThreeYearWithdraw = true;
257 	}
258 
259 
260 	//四年解禁，提到owner账户，只有未提过才能提
261 	function withdrawForFourYear() external
262 		onlyOwner
263 		assertFalse(hasFourYearWithdraw)
264 		notBeforeTime(1609344000)
265 	{
266 		processFunding(msg.sender,FOUR_YEAR_KEEPING,1);
267 		//标记团队已提现
268 		hasFourYearWithdraw = true;
269 	}
270 
271 
272 	//五年解禁，提到owner账户，只有未提过才能提
273 	function withdrawForFiveYear() external
274 		onlyOwner
275 		assertFalse(hasFiveYearWithdraw)
276 		notBeforeTime(1640880000)
277 	{
278 		processFunding(msg.sender,FIVE_YEAR_KEEPING,1);
279 		//标记团队已提现
280 		hasFiveYearWithdraw = true;
281 	}	
282 
283   	function transfer(address _to, uint256 _value) public  returns (bool)
284  	{
285 		require(_to != address(0));
286 		// SafeMath.sub will throw if there is not enough balance.
287 		balances[msg.sender] = balances[msg.sender].sub(_value);
288 		balances[_to] = balances[_to].add(_value);
289 		Transfer(msg.sender, _to, _value);
290 		return true;
291   	}
292 
293   	function balanceOf(address _owner) public constant returns (uint256 balance) 
294   	{
295 		return balances[_owner];
296   	}
297 
298 
299   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
300   	{
301 		require(_to != address(0));
302 		uint256 _allowance = allowed[_from][msg.sender];
303 
304 		balances[_from] = balances[_from].sub(_value);
305 		balances[_to] = balances[_to].add(_value);
306 		allowed[_from][msg.sender] = _allowance.sub(_value);
307 		Transfer(_from, _to, _value);
308 		return true;
309   	}
310 
311   	function approve(address _spender, uint256 _value) public returns (bool) 
312   	{
313 		allowed[msg.sender][_spender] = _value;
314 		Approval(msg.sender, _spender, _value);
315 		return true;
316   	}
317 
318   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
319   	{
320 		return allowed[_owner][_spender];
321   	}
322 
323 	function getCurrentBlockNum() internal returns (uint256)
324 	{
325 		return block.number;
326 	}
327 
328 
329 	function setRate(uint256 _rate) external
330 		onlyOwner
331 	{
332 		rate=_rate;
333 	}
334 
335 	
336     function setupFundingInfo(uint256 _startBlock,uint256 _endBlock) external
337         onlyOwner
338     {
339 		startBlock=_startBlock;
340 		endBlock=_endBlock;
341     }
342 	  
343 }