1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[msg.sender]);
77 
78     // SafeMath.sub will throw if there is not enough balance.
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106   mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[_from]);
118     require(_value <= allowed[_from][msg.sender]);
119 
120     balances[_from] = balances[_from].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123     Transfer(_from, _to, _value);
124     return true;
125   }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    *
130    * Beware that changing an allowance with this method brings the risk that someone may use both the old
131    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134    * @param _spender The address which will spend the funds.
135    * @param _value The amount of tokens to be spent.
136    */
137   function approve(address _spender, uint256 _value) public returns (bool) {
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifying the amount of tokens still available for the spender.
148    */
149   function allowance(address _owner, address _spender) public view returns (uint256) {
150     return allowed[_owner][_spender];
151   }
152 
153   /**
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    */
159   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185   address public owner;
186 
187 
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() public {
196     owner = msg.sender;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner);
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) public onlyOwner {
214     require(newOwner != address(0));
215     OwnershipTransferred(owner, newOwner);
216     owner = newOwner;
217   }
218 
219 }
220 
221 contract ARTL is StandardToken,Ownable{
222 
223 	//the base info of the token
224 	string public constant name="artificial";
225 	string public constant symbol="ARTL";
226 	string public constant version = "1.0";
227 	uint256 public constant decimals = 18;
228 
229 	uint256 public constant MAX_SUPPLY=80000000*10**decimals;
230 	uint256 public constant MAX_FUNDING_SUPPLY=32000000*10**decimals;
231 	//teamKeeping
232 	uint256 public constant TEAM_KEEPING=48000000*10**decimals;
233 
234 	uint256 public constant rate=20000;
235 	
236 	uint256 public totalFundingSupply;
237 	uint256 public totalTeamWithdrawSupply;
238 
239 	uint256 public startBlock;
240 	uint256 public endBlock;
241 
242 	function ARTL(){
243 		totalSupply = 0 ;
244 		totalFundingSupply = 0;
245 		totalTeamWithdrawSupply=0;
246 
247 		startBlock = 4000000;
248 		endBlock = 5000000;
249 	}
250 
251 	event CreateARTL(address indexed _to, uint256 _value);
252 
253 	modifier beforeBlock(uint256 _blockNum){
254 		assert(getCurrentBlockNum()<_blockNum);
255 		_;
256 	}
257 
258 	modifier afterBlock(uint256 _blockNum){
259 		assert(getCurrentBlockNum()>=_blockNum);
260 		_;
261 	}
262 
263 	modifier notReachTotalSupply(uint256 _value,uint256 _rate){
264 		assert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));
265 		_;
266 	}
267 
268 	modifier notReachFundingSupply(uint256 _value,uint256 _rate){
269 		assert(MAX_FUNDING_SUPPLY>=totalFundingSupply.add(_value.mul(_rate)));
270 		_;
271 	}
272 
273 	modifier notReachTeamWithdrawSupply(uint256 _value,uint256 _rate){
274 		assert(TEAM_KEEPING>=totalTeamWithdrawSupply.add(_value.mul(_rate)));
275 		_;
276 	}
277 	modifier notBeforeTime(uint256 targetTime){
278 		assert(now>targetTime);
279 		_;
280 	}
281 	//owner有权限提取账户中的eth
282 	function etherProceeds() external
283 		onlyOwner
284 
285 	{
286 		if(!msg.sender.send(this.balance)) revert();
287 	}
288 
289 
290 	//众筹，不超过最大众筹份额,要在众筹时间内
291 	function () payable external
292 		afterBlock(startBlock)
293 		beforeBlock(endBlock)
294 		notReachFundingSupply(msg.value,rate)
295 	{
296 			processFunding(msg.sender,msg.value,rate);
297 			//增加已众筹份额
298 			uint256 amount=msg.value.mul(rate);
299 			totalFundingSupply = totalFundingSupply.add(amount);
300 	}
301 
302 	//使用60%的币要锁5年，到2023年1月1日
303 	function patformWithdraw(uint256 _value) external
304 		onlyOwner
305 		notReachTeamWithdrawSupply(_value,1)
306 		notBeforeTime(1640880000)
307 
308 	{
309 		processFunding(msg.sender,_value,1);
310 		//增加团队已提现份额
311 		totalTeamWithdrawSupply=totalTeamWithdrawSupply.add(_value);
312 
313 	}
314 	//不能超过最大分发限额
315 	function processFunding(address receiver,uint256 _value,uint256 _rate) internal
316 		notReachTotalSupply(_value,_rate)
317 	{
318 		uint256 amount=_value.mul(_rate);
319 		totalSupply=totalSupply.add(amount);
320 		balances[receiver] +=amount;
321 		CreateARTL(receiver,amount);
322 		Transfer(0x0, receiver, amount);
323 	}
324 
325 
326 	function getCurrentBlockNum() internal returns (uint256){
327 		return block.number;
328 	}
329 
330 
331 
332     function setupFundingInfo(uint256 _startBlock,uint256 _endBlock) external
333         onlyOwner
334     {
335 		startBlock=_startBlock;
336 		endBlock=_endBlock;
337     }
338 }