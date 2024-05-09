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
52 
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 contract OOGToken is ERC20,Ownable{
82 	using SafeMath for uint256;
83 
84 	//the base info of the token
85 	string public constant name="bitoog token";
86 	string public symbol;
87 	string public constant version = "1.0";
88 	uint256 public constant decimals = 18;
89 
90 	uint256 public constant MAX_SUPPLY=100000000*10**decimals;
91 
92 	uint256 public constant MAX_FUNDING_SUPPLY=20000000*10**decimals;
93 	uint256 public rate;
94 	uint256 public totalFundingSupply;
95 
96 
97 	uint256 public constant ONE_YEAR_KEEPING=24000000*10**decimals;
98 	bool public hasOneYearWithdraw;
99 
100 	uint256 public constant TWO_YEAR_KEEPING=24000000*10**decimals;
101 	bool public hasTwoYearWithdraw;
102 
103 	
104 	uint256 public constant THREE_YEAR_KEEPING=32000000*10**decimals;	
105 	bool public hasThreeYearWithdraw;
106 
107 
108 	uint256 public startBlock;
109 	uint256 public endBlock;
110 	
111     mapping(address => uint256) balances;
112 	mapping (address => mapping (address => uint256)) allowed;
113 	
114 
115 	function OOGToken(){
116 		totalSupply = 0 ;
117 		totalFundingSupply = 0;
118 
119 		hasOneYearWithdraw=false;
120 		hasTwoYearWithdraw=false;
121 		hasThreeYearWithdraw=false;
122 
123 		startBlock = 4000000;
124 		endBlock = 5000000;
125 		rate=10000;
126 		symbol="OOG";
127 	}
128 
129 	event CreateOOG(address indexed _to, uint256 _value);
130 
131 	modifier beforeBlock(uint256 _blockNum){
132 		assert(getCurrentBlockNum()<_blockNum);
133 		_;
134 	}
135 
136 	modifier afterBlock(uint256 _blockNum){
137 		assert(getCurrentBlockNum()>=_blockNum);
138 		_;
139 	}
140 
141 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
142 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
143 		_;
144 	}
145 
146 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
147 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
148 		_;
149 	}
150 
151 
152 
153 	modifier assertFalse(bool withdrawStatus){
154 		assert(!withdrawStatus);
155 		_;
156 	}
157 
158 	modifier notBeforeTime(uint256 targetTime){
159 		assert(now>targetTime);
160 		_;
161 	}
162 
163 
164 	function etherProceeds() external
165 		onlyOwner
166 
167 	{
168 		if(!msg.sender.send(this.balance)) revert();
169 	}
170 
171 
172 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
173 		notReachTotalSupply(_value,_rate)
174 	{
175 		uint256 amount=_value.mul(_rate);
176 		totalSupply=totalSupply.add(amount);
177 		balances[receiver] +=amount;
178 		CreateOOG(receiver,amount);
179 		Transfer(0x0, receiver, amount);
180 	}
181 
182 
183 
184 
185 	function () payable external
186 		afterBlock(startBlock)
187 		beforeBlock(endBlock)
188 		notReachFundingSupply(msg.value,rate)
189 	{
190 		processFunding(msg.sender,msg.value,rate);
191 		uint256 amount=msg.value.mul(rate);
192 		totalFundingSupply = totalFundingSupply.add(amount);
193 	}
194 
195 
196 
197 	function withdrawForOneYear() external
198 		onlyOwner
199 		assertFalse(hasOneYearWithdraw)
200 		notBeforeTime(1514736000)
201 	{
202 		processFunding(msg.sender,ONE_YEAR_KEEPING,1);
203 		hasOneYearWithdraw = true;
204 	}
205 
206 	function withdrawForTwoYear() external
207 		onlyOwner
208 		assertFalse(hasTwoYearWithdraw)
209 		notBeforeTime(1546272000)
210 	{
211 		processFunding(msg.sender,TWO_YEAR_KEEPING,1);
212 		hasTwoYearWithdraw = true;
213 	}
214 
215 	function withdrawForThreeYear() external
216 		onlyOwner
217 		assertFalse(hasThreeYearWithdraw)
218 		notBeforeTime(1577808000)
219 	{
220 		processFunding(msg.sender,THREE_YEAR_KEEPING,1);
221 		hasThreeYearWithdraw = true;
222 	}
223 
224 
225   	function transfer(address _to, uint256 _value) public  returns (bool)
226  	{
227 		require(_to != address(0));
228 		// SafeMath.sub will throw if there is not enough balance.
229 		balances[msg.sender] = balances[msg.sender].sub(_value);
230 		balances[_to] = balances[_to].add(_value);
231 		Transfer(msg.sender, _to, _value);
232 		return true;
233   	}
234 
235   	function balanceOf(address _owner) public constant returns (uint256 balance) 
236   	{
237 		return balances[_owner];
238   	}
239 
240 
241   	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
242   	{
243 		require(_to != address(0));
244 		uint256 _allowance = allowed[_from][msg.sender];
245 
246 		balances[_from] = balances[_from].sub(_value);
247 		balances[_to] = balances[_to].add(_value);
248 		allowed[_from][msg.sender] = _allowance.sub(_value);
249 		Transfer(_from, _to, _value);
250 		return true;
251   	}
252 
253   	function approve(address _spender, uint256 _value) public returns (bool) 
254   	{
255 		allowed[msg.sender][_spender] = _value;
256 		Approval(msg.sender, _spender, _value);
257 		return true;
258   	}
259 
260   	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
261   	{
262 		return allowed[_owner][_spender];
263   	}
264 
265 	function getCurrentBlockNum() internal returns (uint256)
266 	{
267 		return block.number;
268 	}
269 
270 
271 	function setSymbol(string _symbol) external
272 		onlyOwner
273 	{
274 		symbol=_symbol;
275 	}
276 
277 
278 	function setRate(uint256 _rate) external
279 		onlyOwner
280 	{
281 		rate=_rate;
282 	}
283 
284 	
285     function setupFundingInfo(uint256 _startBlock,uint256 _endBlock) external
286         onlyOwner
287     {
288 		startBlock=_startBlock;
289 		endBlock=_endBlock;
290     }
291 	  
292 }