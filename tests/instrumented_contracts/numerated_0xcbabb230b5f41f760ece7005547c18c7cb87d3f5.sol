1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) returns (bool) {
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   /**
54   * @dev Gets the balance of the specified address.
55   * @param _owner The address to query the the balance of. 
56   * @return An uint256 representing the amount owned by the passed address.
57   */
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) constant returns (uint256);
66   function transferFrom(address from, address to, uint256 value) returns (bool);
67   function approve(address spender, uint256 value) returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amout of tokens to be transfered
81    */
82   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83     var _allowance = allowed[_from][msg.sender];
84 
85     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86     // require (_value <= _allowance);
87 
88     balances[_to] = balances[_to].add(_value);
89     balances[_from] = balances[_from].sub(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    * @param _spender The address which will spend the funds.
98    * @param _value The amount of tokens to be spent.
99    */
100   function approve(address _spender, uint256 _value) returns (bool) {
101 
102     // To change the approve amount you first have to reduce the addresses`
103     //  allowance to zero by calling `approve(_spender, 0)` if it is not
104     //  already 0 to mitigate the race condition described here:
105     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifing the amount of tokens still avaible for the spender.
118    */
119   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123 }
124 
125 contract Ownable {
126   address public owner;
127 
128 
129   /**
130    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
131    * account.
132    */
133   function Ownable() {
134     owner = msg.sender;
135   }
136 
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146 
147   /**
148    * @dev Allows the current owner to transfer control of the contract to a newOwner.
149    * @param newOwner The address to transfer ownership to.
150    */
151   function transferOwnership(address newOwner) onlyOwner {
152     if (newOwner != address(0)) {
153       owner = newOwner;
154     }
155   }
156 
157 }
158 
159 contract MintableToken is StandardToken, Ownable {
160   event Mint(address indexed to, uint256 amount);
161   event MintFinished();
162 
163   bool public mintingFinished = false;
164 
165 
166   modifier canMint() {
167     require(!mintingFinished);
168     _;
169   }
170 
171   /**
172    * @dev Function to mint tokens
173    * @param _to The address that will recieve the minted tokens.
174    * @param _amount The amount of tokens to mint.
175    * @return A boolean that indicates if the operation was successful.
176    */
177   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
178     totalSupply = totalSupply.add(_amount);
179     balances[_to] = balances[_to].add(_amount);
180     Mint(_to, _amount);
181     return true;
182   }
183 
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() onlyOwner returns (bool) {
189     mintingFinished = true;
190     MintFinished();
191     return true;
192   }
193 }
194 
195 contract VanilCoin is MintableToken {
196   	
197 	string public name = "Vanil";
198   	string public symbol = "VAN";
199   	uint256 public decimals = 18;
200   
201   	// tokens locked for one week after ICO, 8 Oct 2017, 0:0:0 GMT: 1507420800
202   	uint public releaseTime = 1507420800;
203   
204 	modifier canTransfer(address _sender, uint256 _value) {
205 		require(_value <= transferableTokens(_sender, now));
206 	   	_;
207 	}
208 	
209 	function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
210 		return super.transfer(_to, _value);
211 	}
212 	
213 	function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
214 		return super.transferFrom(_from, _to, _value);
215 	}
216 	
217 	function transferableTokens(address holder, uint time) constant public returns (uint256) {
218 		
219 		uint256 result = 0;
220 				
221 		if(time > releaseTime){
222 			result = balanceOf(holder);
223 		}
224 		
225 		return result;
226 	}
227 	
228 }
229 
230 contract ETH888CrowdsaleS2 {
231 
232 	using SafeMath for uint256;
233 	
234 	// The token being sold
235 	address public vanilAddress;
236 	VanilCoin public vanilCoin;
237 	
238 	// address where funds are collected
239 	address public wallet;
240 	
241 	// how many token units a buyer gets per wei
242 	uint256 public rate = 400;
243 	
244 	// timestamps for ICO starts and ends
245 	uint public startTimestamp;
246 	uint public endTimestamp;
247 	
248 	// amount of raised money in wei
249 	uint256 public weiRaised;
250 	
251 	mapping(uint8 => uint64) public rates;
252 	// week 2, 5 May 2018, 000:00:00 GMT
253 	uint public timeTier1 = 1525478400;
254 	// week 3, 12 May 2018, 000:00:00 GMT
255 	uint public timeTier2 = 1526083200;
256 	// week 4, 19 May 2018, 000:00:00 GMT
257 	uint public timeTier3 = 1526688000;
258 
259 	/**
260 	   * event for token purchase logging
261 	   * @param purchaser who paid for the tokens
262 	   * @param beneficiary who got the tokens
263 	   * @param value weis paid for purchase
264 	   * @param amount amount of tokens purchased
265 	   */ 
266 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
267 
268 	function ETH888CrowdsaleS2(address _wallet, address _vanilAddress) {
269 		
270 		require(_wallet != 0x0 && _vanilAddress != 0x0);
271 		
272 		// 28 April 2018, 00:00:00 GMT: 1524873600
273 		startTimestamp = 1524873600;
274 		
275 		// 28 May 2018, 00:00:00 GMT: 1527465600
276 		endTimestamp = 1527465600;
277 		
278 		rates[0] = 400;
279 		rates[1] = 300;
280 		rates[2] = 200;
281 		rates[3] = 100;
282 
283 		wallet = _wallet;
284 		vanilAddress = _vanilAddress;
285 		vanilCoin = VanilCoin(vanilAddress);
286 	}
287 		
288 	// fallback function can be used to buy tokens
289 	function () payable {
290 	    buyTokens(msg.sender);
291 	}
292 	
293 	// low level token purchase function
294 	function buyTokens(address beneficiary) payable {
295 		require(beneficiary != 0x0 && validPurchase() && validAmount());
296 
297 		if(now < timeTier1)
298 			rate = rates[0];
299 		else if(now < timeTier2)
300 			rate = rates[1];
301 		else if(now < timeTier3)
302 			rate = rates[2];
303 		else
304 			rate = rates[3];
305 
306 		uint256 weiAmount = msg.value;
307 		uint256 tokens = weiAmount.mul(rate);
308 
309 		// update state
310 		weiRaised = weiRaised.add(weiAmount);
311 		vanilCoin.transfer(beneficiary, tokens);
312 
313 		TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
314 
315 		forwardFunds();
316 	}
317 
318 	function totalSupply() public constant returns (uint)
319 	{
320 		return vanilCoin.totalSupply();
321 	}
322 
323 	function vanilAddress() public constant returns (address)
324 	{
325 		return vanilAddress;
326 	}
327 
328 	// send ether to the fund collection wallet
329 	function forwardFunds() internal {
330 		wallet.transfer(msg.value);
331 	}	
332 	
333 	function validAmount() internal constant returns (bool)
334 	{
335 		uint256 weiAmount = msg.value;
336 		uint256 tokens = weiAmount.mul(rate);
337 
338 		return (vanilCoin.balanceOf(this) >= tokens);
339 	}
340 
341 	// @return true if investors can buy at the moment
342 	function validPurchase() internal constant returns (bool) {
343 		
344 		uint current = now;
345 		bool withinPeriod = current >= startTimestamp && current <= endTimestamp;
346 		bool nonZeroPurchase = msg.value != 0;
347 		
348 		return withinPeriod && nonZeroPurchase && msg.value >= 1000 szabo;
349 	}
350 
351 	// @return true if crowdsale event has ended
352 	function hasEnded() public constant returns (bool) {
353 		
354 		return now > endTimestamp;
355 	}
356 	
357 }