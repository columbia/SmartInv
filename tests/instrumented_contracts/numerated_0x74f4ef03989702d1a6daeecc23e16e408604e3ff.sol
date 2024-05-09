1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   function balanceOf(address who) constant returns (uint256);
51   function transfer(address to, uint256 value) returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) constant returns (uint256);
62   function transferFrom(address from, address to, uint256 value) returns (bool);
63   function approve(address spender, uint256 value) returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
73     uint256 c = a * b;
74     assert(a == 0 || c / a == b);
75     return c;
76   }
77 
78   function div(uint256 a, uint256 b) internal constant returns (uint256) {
79     // assert(b > 0); // Solidity automatically throws when dividing by 0
80     uint256 c = a / b;
81     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82     return c;
83   }
84 
85   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   function add(uint256 a, uint256 b) internal constant returns (uint256) {
91     uint256 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances. 
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) returns (bool) {
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of. 
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amout of tokens to be transfered
148    */
149   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
150     var _allowance = allowed[_from][msg.sender];
151 
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // require (_value <= _allowance);
154 
155     balances[_to] = balances[_to].add(_value);
156     balances[_from] = balances[_from].sub(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) returns (bool) {
168 
169     // To change the approve amount you first have to reduce the addresses`
170     //  allowance to zero by calling `approve(_spender, 0)` if it is not
171     //  already 0 to mitigate the race condition described here:
172     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
174 
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifing the amount of tokens still avaible for the spender.
185    */
186   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190 }
191 
192 
193 contract PGDToken is StandardToken,Ownable{
194 
195 	//the base info of the token
196 	string public constant name="pagoda coin";
197 	string public constant symbol="PGD";
198 	string public constant version = "1.0";
199 	uint256 public constant decimals = 18;
200 
201 	uint256 public constant MAX_SUPPLY=200000000*10**decimals;
202 	uint256 public constant MAX_FUNDING_SUPPLY=100000000*10**decimals;
203 	//teamKeeping
204 	uint256 public constant TEAM_KEEPING=100000000*10**decimals;
205 
206 	uint256 public constant rate=17000;
207 	
208 	uint256 public totalFundingSupply;
209 	uint256 public totalTeamWithdrawSupply;
210 
211 	uint256 public startBlock;
212 	uint256 public endBlock;
213 	address[] public allFundingUsers;
214 
215 	mapping(address=>uint256) public fundBalance;
216 	
217 
218 	function PGDToken(){
219 		totalSupply = 0 ;
220 		totalFundingSupply = 0;
221 		totalTeamWithdrawSupply=0;
222 
223 		startBlock = 4000000;
224 		endBlock = 6000000;
225 	}
226 
227 	modifier beforeBlock(uint256 _blockNum){
228 		assert(getCurrentBlockNum()<_blockNum);
229 		_;
230 	}
231 
232 	modifier afterBlock(uint256 _blockNum){
233 		assert(getCurrentBlockNum()>=_blockNum);
234 		_;
235 	}
236 
237 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
238 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
239 		_;
240 	}
241 
242 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
243 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
244 		_;
245 	}
246 
247 	modifier notReachTeamWithdrawSupply(uint256 _value,uint256 _rate){
248 		assert(TEAM_KEEPING>=totalTeamWithdrawSupply.add(_value.mul(_rate)));
249 		_;
250 	}
251 
252 	//owner有权限提取账户中的eth
253 	function etherProceeds() external
254 		onlyOwner
255 
256 	{
257 		if(!msg.sender.send(this.balance)) revert();
258 	}
259 
260 
261 	//众筹，不超过最大众筹份额,要在众筹时间内
262 	function () payable external
263 		afterBlock(startBlock)
264 		beforeBlock(endBlock)
265 		notReachFundingSupply(msg.value,rate)
266 	{
267 			processFunding(msg.sender,msg.value,rate);
268 			//增加已众筹份额
269 			uint256 amount=msg.value.mul(rate);
270 			totalFundingSupply = totalFundingSupply.add(amount);
271 			
272 			//另外记录众筹数据，以避免受转账影响
273 			allFundingUsers.push(msg.sender);
274 			fundBalance[msg.sender]=fundBalance[msg.sender].add(amount);
275 
276 
277 	}
278 
279 	//众筹完成后，owner可以按比例给用户分发剩余代币
280 	function airdrop(address receiver,uint256 _value) external
281 	    onlyOwner
282 		afterBlock(endBlock)
283 		notReachFundingSupply(_value,1)
284 	{
285 		processFunding(receiver,_value,1);
286 		//增加已众筹份额
287 		totalFundingSupply=totalFundingSupply.add(_value);
288 	}
289 
290 	//owner有权限提取币
291 	function patformWithdraw(uint256 _value) external
292 		onlyOwner
293 		notReachTeamWithdrawSupply(_value,1)
294 
295 	{
296 		processFunding(msg.sender,_value,1);
297 		//增加团队已提现份额
298 		totalTeamWithdrawSupply=totalTeamWithdrawSupply.add(_value);
299 
300 	}
301 	//不能超过最大分发限额
302 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
303 		notReachTotalSupply(_value,_rate)
304 	{
305 		uint256 amount=_value.mul(_rate);
306 		totalSupply=totalSupply.add(amount);
307 		balances[receiver] +=amount;
308 		Transfer(0x0, receiver, amount);
309 	}
310 
311 
312 	function getCurrentBlockNum() internal returns (uint256){
313 		return block.number;
314 	}
315 
316 
317 
318     function setupFundingInfo(uint256 _startBlock,uint256 _endBlock) external
319         onlyOwner
320     {
321 		startBlock=_startBlock;
322 		endBlock=_endBlock;
323     }
324 }