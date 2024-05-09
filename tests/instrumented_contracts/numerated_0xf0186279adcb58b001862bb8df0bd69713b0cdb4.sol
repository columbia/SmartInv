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
36 /**
37  * @title Basic token
38  * @dev Basic version of StandardToken, with no allowances. 
39  */
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   /**
46   * @dev transfer token for a specified address
47   * @param _to The address to transfer to.
48   * @param _value The amount to be transferred.
49   */
50   function transfer(address _to, uint256 _value) returns (bool) {
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   /**
58   * @dev Gets the balance of the specified address.
59   * @param _owner The address to query the the balance of. 
60   * @return An uint256 representing the amount owned by the passed address.
61   */
62   function balanceOf(address _owner) constant returns (uint256 balance) {
63     return balances[_owner];
64   }
65 
66 }
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) constant returns (uint256);
75   function transferFrom(address from, address to, uint256 value) returns (bool);
76   function approve(address spender, uint256 value) returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 /**
81  * @title Standard ERC20 token
82  *
83  * @dev Implementation of the basic standard token.
84  * @dev https://github.com/ethereum/EIPs/issues/20
85  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
86  */
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) allowed;
90 
91 
92   /**
93    * @dev Transfer tokens from one address to another
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amout of tokens to be transfered
97    */
98   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
99     var _allowance = allowed[_from][msg.sender];
100 
101     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
102     // require (_value <= _allowance);
103 
104     balances[_to] = balances[_to].add(_value);
105     balances[_from] = balances[_from].sub(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    * @param _spender The address which will spend the funds.
114    * @param _value The amount of tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) returns (bool) {
117 
118     // To change the approve amount you first have to reduce the addresses`
119     //  allowance to zero by calling `approve(_spender, 0)` if it is not
120     //  already 0 to mitigate the race condition described here:
121     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
123 
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifing the amount of tokens still avaible for the spender.
134    */
135   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136     return allowed[_owner][_spender];
137   }
138 
139 }
140 
141 contract Ownable {
142   address public owner;
143 
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   function Ownable() {
150     owner = msg.sender;
151   }
152 
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(msg.sender == owner);
159     _;
160   }
161 
162 
163   /**
164    * @dev Allows the current owner to transfer control of the contract to a newOwner.
165    * @param newOwner The address to transfer ownership to.
166    */
167   function transferOwnership(address newOwner) onlyOwner {
168     if (newOwner != address(0)) {
169       owner = newOwner;
170     }
171   }
172 
173 }
174 
175 contract MintableToken is StandardToken, Ownable {
176   event Mint(address indexed to, uint256 amount);
177   event MintFinished();
178 
179   bool public mintingFinished = false;
180 
181 
182   modifier canMint() {
183     require(!mintingFinished);
184     _;
185   }
186 
187   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
188     totalSupply = totalSupply.add(_amount);
189     balances[_to] = balances[_to].add(_amount);
190     Mint(_to, _amount);
191     return true;
192   }
193 
194   function finishMinting() onlyOwner returns (bool) {
195     mintingFinished = true;
196     MintFinished();
197     return true;
198   }
199 }
200 
201 contract VanilCoin is MintableToken {
202   	
203 	string public name = "Vanil";
204   	string public symbol = "VAN";
205   	uint256 public decimals = 18;
206   
207   	// tokens locked for one week after ICO, 8 Oct 2017, 0:0:0 GMT: 1507420800
208   	uint public releaseTime = 1507420800;
209   
210 	modifier canTransfer(address _sender, uint256 _value) {
211 		require(_value <= transferableTokens(_sender, now));
212 	   	_;
213 	}
214 	
215 	function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
216 		return super.transfer(_to, _value);
217 	}
218 	
219 	function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
220 		return super.transferFrom(_from, _to, _value);
221 	}
222 	
223 	function transferableTokens(address holder, uint time) constant public returns (uint256) {
224 		
225 		uint256 result = 0;
226 				
227 		if(time > releaseTime){
228 			result = balanceOf(holder);
229 		}
230 		
231 		return result;
232 	}
233 	
234 }
235 
236 
237 
238 contract ETH888CrowdsaleS1 {
239 
240 	using SafeMath for uint256;
241 	
242 	// The token being sold
243 	MintableToken public token;
244 	
245 	// address where funds are collected
246 	address public wallet;
247 	
248 	// how many token units a buyer gets per wei
249 	uint256 public rate = 1250;
250 	
251 	// timestamps for ICO starts and ends
252 	uint public startTimestamp;
253 	uint public endTimestamp;
254 	
255 	// amount of raised money in wei
256 	uint256 public weiRaised;
257 	
258 	// first round ICO cap
259 	uint256 public cap;
260 	
261 	/**
262 	   * event for token purchase logging
263 	   * @param purchaser who paid for the tokens
264 	   * @param beneficiary who got the tokens
265 	   * @param value weis paid for purchase
266 	   * @param amount amount of tokens purchased
267 	   */ 
268 	event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
269 	
270 	function ETH888CrowdsaleS1(address _wallet) {
271 		
272 		require(_wallet != 0x0);
273 		
274 		// 11 Aug 2017, 00:00:00 GMT: 1502409600
275 		startTimestamp = 1502409600;
276 		
277 		// 30 Sep 2017, 23:59:59 GMT: 1506815999
278 		endTimestamp = 1506815999;
279 		
280 		token = createTokenContract();
281 		
282 		// maximum 8000 ETH for this stage 1 crowdsale
283 		cap = 8000 ether;
284 		
285 		wallet = _wallet;
286 	}
287 		
288 	// fallback function can be used to buy tokens
289 	function () payable {
290 	    buyTokens(msg.sender);
291 	}
292 	
293 	// low level token purchase function
294 	function buyTokens(address beneficiary) payable {
295 		require(beneficiary != 0x0);
296 		require(validPurchase());
297 
298 		uint256 weiAmount = msg.value;
299 
300 		// calculate token amount to be created
301 		uint256 tokens = weiAmount.mul(rate);
302 
303 		// update state
304 		weiRaised = weiRaised.add(weiAmount);
305 
306 		token.mint(beneficiary, tokens);
307 		TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
308 
309 		forwardFunds();
310 	}
311 
312 	// send ether to the fund collection wallet
313 	function forwardFunds() internal {
314 		wallet.transfer(msg.value);
315 	}	
316 	
317 	// @return true if investors can buy at the moment
318 	function validPurchase() internal constant returns (bool) {
319 		bool withinCap = weiRaised.add(msg.value) <= cap;
320 		
321 		uint current = now;
322 		bool withinPeriod = current >= startTimestamp && current <= endTimestamp;
323 		bool nonZeroPurchase = msg.value != 0;
324 		
325 		return withinPeriod && nonZeroPurchase && withinCap && msg.value >= 1000 szabo;
326 	}
327 
328 	// @return true if crowdsale event has ended
329 	function hasEnded() public constant returns (bool) {
330 		bool capReached = weiRaised >= cap;
331 		
332 		return now > endTimestamp || capReached;
333 	}
334 	
335 	// creates the token to be sold.
336 	function createTokenContract() internal returns (MintableToken) {
337 		return new VanilCoin();
338 	}
339 	
340 }