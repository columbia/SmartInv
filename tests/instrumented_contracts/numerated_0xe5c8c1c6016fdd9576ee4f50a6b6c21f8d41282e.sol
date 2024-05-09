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
107 
108 contract SeekerCoin is ERC20,Ownable{
109 	using SafeMath for uint256;
110 
111 	//the base info of the token
112 	string public constant name="Seeker Coin";
113 	string public constant symbol="SEC";
114 	string public constant version = "1.0";
115 	uint256 public constant decimals = 18;
116 
117 	uint256 public rate;
118 	uint256 public totalFundingSupply;
119 	//the max supply
120 	uint256 public MAX_SUPPLY;
121 
122 	//user's locked balance
123 	mapping(address=>epoch[]) public lockEpochsMap;
124 
125     mapping(address => uint256) balances;
126 	mapping (address => mapping (address => uint256)) allowed;
127 	struct epoch  {
128         uint256 endTime;
129         uint256 amount;
130     }
131 
132 	function SeekerCoin(){
133 		MAX_SUPPLY = 10000000000*10**decimals;
134 		rate = 0;
135 		totalFundingSupply = 0;
136 		totalSupply = 0;
137 	}
138 
139 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
140 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
141 		_;
142 	}
143 
144 	function lockBalance(address user, uint256 amount,uint256 endTime) external
145 		onlyOwner
146 	{
147 		 epoch[] storage epochs = lockEpochsMap[user];
148 		 epochs.push(epoch(endTime,amount));
149 	}
150 	
151 	function () payable external
152 	{
153 			processFunding(msg.sender,msg.value,rate);
154 			uint256 amount=msg.value.mul(rate);
155 			totalFundingSupply = totalFundingSupply.add(amount);
156 	}
157 
158 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
159 		notReachTotalSupply(_value,_rate)
160 	{
161 		uint256 amount=_value.mul(_rate);
162 		totalSupply=totalSupply.add(amount);
163 		balances[receiver] +=amount;
164 		Transfer(0x0, receiver, amount);
165 	}
166 
167     function withdrawCoinToOwner(uint256 _value) external
168 		onlyOwner
169 	{
170 		processFunding(msg.sender,_value,1);
171 	}
172 	
173 	function etherProceeds() external
174 		onlyOwner
175 
176 	{
177 		if(!msg.sender.send(this.balance)) revert();
178 	}
179 
180 
181 
182 	function setRate(uint256 _rate) external
183 		onlyOwner
184 	{
185 		rate=_rate;
186 	}
187 
188   	function transfer(address _to, uint256 _value) public  returns (bool)
189  	{
190 		require(_to != address(0));
191 		epoch[] epochs = lockEpochsMap[msg.sender];
192 		uint256 needLockBalance = 0;
193 		for(uint256 i;i<epochs.length;i++)
194 		{
195 			if( now < epochs[i].endTime )
196 			{
197 				needLockBalance=needLockBalance.add(epochs[i].amount);
198 			}
199 		}
200 
201 		require(balances[msg.sender].sub(_value)>=needLockBalance);
202 		// SafeMath.sub will throw if there is not enough balance.
203 		balances[msg.sender] = balances[msg.sender].sub(_value);
204 		balances[_to] = balances[_to].add(_value);
205 		Transfer(msg.sender, _to, _value);
206 		return true;
207   	}
208 
209   	function balanceOf(address _owner) public constant returns (uint256 balance) 
210   	{
211 		return balances[_owner];
212   	}
213 
214 
215   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
216   	{
217 		require(_to != address(0));
218 
219 		epoch[] epochs = lockEpochsMap[_from];
220 		uint256 needLockBalance = 0;
221 		for(uint256 i;i<epochs.length;i++)
222 		{
223 			if( now < epochs[i].endTime )
224 			{
225 				needLockBalance = needLockBalance.add(epochs[i].amount);
226 			}
227 		}
228 
229 		require(balances[_from].sub(_value)>=needLockBalance);
230 		uint256 _allowance = allowed[_from][msg.sender];
231 
232 		balances[_from] = balances[_from].sub(_value);
233 		balances[_to] = balances[_to].add(_value);
234 		allowed[_from][msg.sender] = _allowance.sub(_value);
235 		Transfer(_from, _to, _value);
236 		return true;
237   	}
238 
239   	function approve(address _spender, uint256 _value) public returns (bool) 
240   	{
241 		allowed[msg.sender][_spender] = _value;
242 		Approval(msg.sender, _spender, _value);
243 		return true;
244   	}
245 
246   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
247   	{
248 		return allowed[_owner][_spender];
249   	}
250 
251 	  
252 }
253 
254 contract TAKD is ERC20,Ownable{
255 	using SafeMath for uint256;
256 
257 	//the base info of the token
258 	string public constant name="America TransAKT Company Limited";
259 	string public constant symbol="TAKD";
260 	string public constant version = "1.0";
261 	uint256 public constant decimals = 18;
262 
263 	uint256 public constant MAX_SUPPLY=1000000000*10**decimals;
264 
265     struct epoch  {
266         uint256 endTime;
267         uint256 amount;
268     }
269 
270 	mapping(address=>epoch[]) public lockEpochsMap;
271 
272 
273 	 
274     mapping(address => uint256) balances;
275 	mapping (address => mapping (address => uint256)) allowed;
276 	
277 
278 	function TAKD(){
279 		totalSupply = MAX_SUPPLY;
280 		balances[msg.sender] = MAX_SUPPLY;
281 		Transfer(0x0, msg.sender, MAX_SUPPLY);
282 	}
283 
284 	function () payable external
285 	{
286 	}
287 
288 	function etherProceeds() external
289 		onlyOwner
290 
291 	{
292 		if(!msg.sender.send(this.balance)) revert();
293 	}
294 
295 	function lockBalance(address user, uint256 amount,uint256 endTime) external
296 		onlyOwner
297 	{
298 		 epoch[] storage epochs = lockEpochsMap[user];
299 		 epochs.push(epoch(endTime,amount));
300 	}
301 
302 
303 
304 
305   	function transfer(address _to, uint256 _value) public  returns (bool)
306  	{
307 		require(_to != address(0));
308 		epoch[] epochs = lockEpochsMap[msg.sender];
309 		uint256 needLockBalance = 0;
310 		for(uint256 i;i<epochs.length;i++)
311 		{
312 			if( now < epochs[i].endTime )
313 			{
314 				needLockBalance=needLockBalance.add(epochs[i].amount);
315 			}
316 		}
317 
318 		require(balances[msg.sender].sub(_value)>=needLockBalance);
319 		// SafeMath.sub will throw if there is not enough balance.
320 		balances[msg.sender] = balances[msg.sender].sub(_value);
321 		balances[_to] = balances[_to].add(_value);
322 		Transfer(msg.sender, _to, _value);
323 		return true;
324   	}
325 
326   	function balanceOf(address _owner) public constant returns (uint256 balance) 
327   	{
328 		return balances[_owner];
329   	}
330 
331 
332   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
333   	{
334 		require(_to != address(0));
335 
336 		epoch[] epochs = lockEpochsMap[_from];
337 		uint256 needLockBalance = 0;
338 		for(uint256 i;i<epochs.length;i++)
339 		{
340 			if( now < epochs[i].endTime )
341 			{
342 				needLockBalance = needLockBalance.add(epochs[i].amount);
343 			}
344 		}
345 
346 		require(balances[_from].sub(_value)>=needLockBalance);
347 		uint256 _allowance = allowed[_from][msg.sender];
348 
349 		balances[_from] = balances[_from].sub(_value);
350 		balances[_to] = balances[_to].add(_value);
351 		allowed[_from][msg.sender] = _allowance.sub(_value);
352 		Transfer(_from, _to, _value);
353 		return true;
354   	}
355 
356   	function approve(address _spender, uint256 _value) public returns (bool) 
357   	{
358 		allowed[msg.sender][_spender] = _value;
359 		Approval(msg.sender, _spender, _value);
360 		return true;
361   	}
362 
363   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
364   	{
365 		return allowed[_owner][_spender];
366   	}
367 
368 	  
369 }