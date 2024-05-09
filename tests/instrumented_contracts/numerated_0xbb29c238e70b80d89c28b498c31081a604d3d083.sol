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
80 contract WEE is ERC20,Ownable{
81 	using SafeMath for uint256;
82 
83 	//the base info of the token
84 	string public constant name="WITEE TOKEN";
85 	string public constant symbol="WEE";
86 	string public constant version = "1.0";
87 	uint256 public constant decimals = 18;
88 
89 
90 	uint256 public constant PARTNER_SUPPLY=270000000*10**decimals;
91 
92 	uint256 public constant MAX_PRIVATE_FUNDING_SUPPLY=648000000*10**decimals;
93 
94 	uint256 public constant COOPERATE_REWARD=270000000*10**decimals;
95 
96 	uint256 public constant ADVISOR_REWARD=90000000*10**decimals;
97 
98 	uint256 public constant COMMON_WITHDRAW_SUPPLY=PARTNER_SUPPLY+MAX_PRIVATE_FUNDING_SUPPLY+COOPERATE_REWARD+ADVISOR_REWARD;
99 
100 	uint256 public constant MAX_PUBLIC_FUNDING_SUPPLY=180000000*10**decimals;
101 
102 	uint256 public constant TEAM_KEEPING=342000000*10**decimals;
103 
104 	uint256 public constant MAX_SUPPLY=COMMON_WITHDRAW_SUPPLY+MAX_PUBLIC_FUNDING_SUPPLY+TEAM_KEEPING;
105 
106 
107 	uint256 public rate;
108 
109 	mapping(address=>uint256) public publicFundingWhiteList;
110 	mapping(address=>uint256) public  userPublicFundingEthCountMap;
111 	
112 	uint256 public publicFundingPersonalEthLimit;
113 
114 
115 	uint256 public totalCommonWithdrawSupply;
116 
117 	uint256 public totalPublicFundingSupply;
118 
119 	bool public hasTeamKeepingWithdraw;
120 
121 	uint256 public startTime;
122 	uint256 public endTime;
123 	
124     struct epoch  {
125         uint256 lockEndTime;
126         uint256 lockAmount;
127     }
128 
129     mapping(address=>epoch[]) public lockEpochsMap;
130 	 
131     mapping(address => uint256) balances;
132 	mapping (address => mapping (address => uint256)) allowed;
133 	
134 
135 	function WEE(){
136 		totalSupply = 0 ;
137 		totalCommonWithdrawSupply=0;
138 		totalPublicFundingSupply = 0;
139 		hasTeamKeepingWithdraw=false;
140 
141 		startTime = 1525104000;
142 		endTime = 1525104000;
143 		rate=18300;
144 		publicFundingPersonalEthLimit = 10000000000000000000;
145 	}
146 
147 	event CreateWEE(address indexed _to, uint256 _value);
148 
149 
150 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
151 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
152 		_;
153 	}
154 
155 	modifier notReachPublicFundingSupply(uint256 _value,uint256 _rate){
156 		assert(MAX_PUBLIC_FUNDING_SUPPLY>=totalPublicFundingSupply.add(_value.mul(_rate)));
157 		_;
158 	}
159 
160 	modifier notReachCommonWithdrawSupply(uint256 _value,uint256 _rate){
161 		assert(COMMON_WITHDRAW_SUPPLY>=totalCommonWithdrawSupply.add(_value.mul(_rate)));
162 		_;
163 	}
164 
165 	modifier assertFalse(bool withdrawStatus){
166 		assert(!withdrawStatus);
167 		_;
168 	}
169 
170 	modifier notBeforeTime(uint256 targetTime){
171 		assert(now>targetTime);
172 		_;
173 	}
174 
175 	modifier notAfterTime(uint256 targetTime){
176 		assert(now<=targetTime);
177 		_;
178 	}
179 	function etherProceeds() external
180 		onlyOwner
181 
182 	{
183 		if(!msg.sender.send(this.balance)) revert();
184 	}
185 
186 
187 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
188 		notReachTotalSupply(_value,_rate)
189 	{
190 		uint256 amount=_value.mul(_rate);
191 		totalSupply=totalSupply.add(amount);
192 		balances[receiver] +=amount;
193 		CreateWEE(receiver,amount);
194 		Transfer(0x0, receiver, amount);
195 	}
196 
197 
198 
199 	function commonWithdraw(uint256 _value) external
200 		onlyOwner
201 		notReachCommonWithdrawSupply(_value,1)
202 
203 	{
204 		processFunding(msg.sender,_value,1);
205 		totalCommonWithdrawSupply=totalCommonWithdrawSupply.add(_value);
206 	}
207 
208 
209 	function withdrawToTeam() external
210 		onlyOwner
211 		assertFalse(hasTeamKeepingWithdraw)
212 		notBeforeTime(1545753600)
213 	{
214 		processFunding(msg.sender,TEAM_KEEPING,1);
215 		hasTeamKeepingWithdraw = true;
216 	}
217 
218 
219 
220 	function () payable external
221 		notBeforeTime(startTime)
222 		notAfterTime(endTime)
223 		notReachPublicFundingSupply(msg.value,rate)
224 	{
225 		require(publicFundingWhiteList[msg.sender]==1);
226 
227 		require(userPublicFundingEthCountMap[msg.sender].add(msg.value)<=publicFundingPersonalEthLimit);
228 
229 		processFunding(msg.sender,msg.value,rate);
230 		uint256 amount=msg.value.mul(rate);
231 		totalPublicFundingSupply = totalPublicFundingSupply.add(amount);
232 
233 		userPublicFundingEthCountMap[msg.sender] = userPublicFundingEthCountMap[msg.sender].add(msg.value);
234 	}
235 
236 
237 
238   	function transfer(address _to, uint256 _value) public  returns (bool)
239  	{
240 		require(_to != address(0));
241 
242 		//计算锁仓份额
243 		epoch[] epochs = lockEpochsMap[msg.sender];
244 		uint256 needLockBalance = 0;
245 		for(uint256 i;i<epochs.length;i++)
246 		{
247 			if( now < epochs[i].lockEndTime )
248 			{
249 				needLockBalance=needLockBalance.add(epochs[i].lockAmount);
250 			}
251 		}
252 
253 		require(balances[msg.sender].sub(_value)>=needLockBalance);
254 
255 		// SafeMath.sub will throw if there is not enough balance.
256 		balances[msg.sender] = balances[msg.sender].sub(_value);
257 		balances[_to] = balances[_to].add(_value);
258 		Transfer(msg.sender, _to, _value);
259 		return true;
260   	}
261 
262   	function balanceOf(address _owner) public constant returns (uint256 balance) 
263   	{
264 		return balances[_owner];
265   	}
266 
267 
268   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
269   	{
270 		require(_to != address(0));
271 
272 		epoch[] epochs = lockEpochsMap[_from];
273 		uint256 needLockBalance = 0;
274 		for(uint256 i;i<epochs.length;i++)
275 		{
276 			if( now < epochs[i].lockEndTime )
277 			{
278 				needLockBalance = needLockBalance.add(epochs[i].lockAmount);
279 			}
280 		}
281 
282 		require(balances[_from].sub(_value)>=needLockBalance);
283 
284 		uint256 _allowance = allowed[_from][msg.sender];
285 
286 		balances[_from] = balances[_from].sub(_value);
287 		balances[_to] = balances[_to].add(_value);
288 		allowed[_from][msg.sender] = _allowance.sub(_value);
289 		Transfer(_from, _to, _value);
290 		return true;
291   	}
292 
293   	function approve(address _spender, uint256 _value) public returns (bool) 
294   	{
295 		allowed[msg.sender][_spender] = _value;
296 		Approval(msg.sender, _spender, _value);
297 		return true;
298   	}
299 
300   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
301   	{
302 		return allowed[_owner][_spender];
303   	}
304 
305 	function lockBalance(address user, uint256 lockAmount,uint256 lockEndTime) external
306 		onlyOwner
307 	{
308 		 epoch[] storage epochs = lockEpochsMap[user];
309 		 epochs.push(epoch(lockEndTime,lockAmount));
310 	}
311 
312     function addPublicFundingWhiteList(address[] _list) external
313     	onlyOwner
314     {
315         uint256 count = _list.length;
316         for (uint256 i = 0; i < count; i++) {
317         	publicFundingWhiteList[_list [i]] = 1;
318         }    	
319     }
320 
321 	function refreshRate(uint256 _rate) external
322 		onlyOwner
323 	{
324 		rate=_rate;
325 	}
326 	
327     function refreshPublicFundingTime(uint256 _startTime,uint256 _endTime) external
328         onlyOwner
329     {
330 		startTime=_startTime;
331 		endTime=_endTime;
332     }
333 
334     function refreshPublicFundingPersonalEthLimit (uint256 _publicFundingPersonalEthLimit)  external
335     	onlyOwner
336     {
337     	publicFundingPersonalEthLimit=_publicFundingPersonalEthLimit;
338     }
339 
340 }