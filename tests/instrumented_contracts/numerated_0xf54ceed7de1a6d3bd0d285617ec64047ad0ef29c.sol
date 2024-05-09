1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20
5  * @dev ERC20 interface
6  */
7 contract ERC20 {
8     function balanceOf(address who) public constant returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function allowance(address owner, address spender) public constant returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   constructor() public{
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a * b;
66     assert(a == 0 || c / a == b);
67     return c;
68   }
69 
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * The WPPToken contract does this and that...
91  */
92 contract WPPToken is ERC20, Ownable {
93 
94 	using SafeMath for uint256;
95 
96 	uint256  public  totalSupply = 5000000000 * 1 ether;
97 
98 
99 	mapping  (address => uint256)             public          _balances;
100     mapping  (address => mapping (address => uint256)) public  _approvals;
101 
102     string   public  name = "WPPTOKEN";
103     string   public  symbol = "WPP";
104     uint256  public  decimals = 18;
105 
106     event Transfer(address indexed from, address indexed to, uint256 value);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108     
109 
110     constructor () public{
111 		_balances[owner] = totalSupply;
112 	}
113 
114     function totalSupply() public constant returns (uint256) {
115         return totalSupply;
116     }
117     function balanceOf(address src) public constant returns (uint256) {
118         return _balances[src];
119     }
120     function allowance(address src, address guy) public constant returns (uint256) {
121         return _approvals[src][guy];
122     }
123     
124     function transfer(address dst, uint256 wad) public returns (bool) {
125         assert(_balances[msg.sender] >= wad);
126         
127         _balances[msg.sender] = _balances[msg.sender].sub(wad);
128         _balances[dst] = _balances[dst].add(wad);
129         
130         emit Transfer(msg.sender, dst, wad);
131         
132         return true;
133     }
134     
135     function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
136         assert(_balances[src] >= wad);
137         assert(_approvals[src][msg.sender] >= wad);
138         
139         _approvals[src][msg.sender] = _approvals[src][msg.sender].sub(wad);
140         _balances[src] = _balances[src].sub(wad);
141         _balances[dst] = _balances[dst].add(wad);
142         
143         emit Transfer(src, dst, wad);
144         
145         return true;
146     }
147     
148     function approve(address guy, uint256 wad) public returns (bool) {
149         _approvals[msg.sender][guy] = wad;
150         
151         emit Approval(msg.sender, guy, wad);
152         
153         return true;
154     }
155 
156 }
157 
158 /**
159  * The WPPPresale contract does this and that...
160  */
161 
162 
163  
164  
165  
166  
167  
168 contract WPPPresale is Ownable{
169 	using SafeMath for uint256;
170 	WPPToken public wpp;
171 	uint256 public tokencap = 250000000 * 1 ether;
172 	// softcap : 5M WPP
173 	uint256 public  hardcap = 250000000 * 1 ether;
174 	bool    public  reached = false;
175 	uint    public  startTime ;
176 	uint    public  endTime ;
177 	uint256 public   rate = 2700;
178 	uint256 public   remain;
179 
180 	address public multisigwallet;
181 
182 	mapping(address => bool) public isWhitelisted;
183 	mapping(address => bool) public isAdminlisted;
184 
185 	event BuyTokens(address indexed beneficiary, uint256 value, uint256 amount, uint time);
186 	event WhitelistSet(address indexed _address, bool _state);
187 	event AdminlistSet(address indexed _address, bool _state);
188 	event TreatRemainToken();
189 
190 	constructor(address token, uint _startTime, uint _endTime, address _multi) public{
191 		wpp = WPPToken(token);
192 		// wpp.transfer(address(this), tokencap);
193 		require (wpp.owner() == msg.sender);
194 		
195 		startTime = _startTime; // 1531659600 2018-07-15 8:AM EST->1:PM UTC
196 		endTime = _endTime; // 1537016400 2018-09-15 8:AM EST->1:PM UTC
197 		remain = hardcap;
198 		multisigwallet = _multi;
199 	}
200 
201 	modifier onlyOwners() { 
202 		require (isAdminlisted[msg.sender] == true || msg.sender == owner); 
203 		_; 
204 	}
205 
206 	modifier onlyWhitelisted() { 
207 		require (isWhitelisted[msg.sender] == true); 
208 		_; 
209 	}
210 	
211 
212 	  // fallback function can be used to buy tokens
213 	function () public payable onlyWhitelisted {
214 		buyTokens(msg.sender);
215 	}
216 
217 	// low level token purchase function
218 	function buyTokens(address beneficiary) public payable onlyWhitelisted {
219 		buyTokens(beneficiary, msg.value);
220 	}
221 
222 	// implementation of low level token purchase function
223 	function buyTokens(address beneficiary, uint256 weiAmount) internal {
224 		require(beneficiary != 0x0);
225 		require(validPurchase(weiAmount));
226 
227 		// calculate token amount to be sent
228 		uint256 tokens = calcBonus(weiAmount.mul(rate));
229 		
230 		if(remain.sub(tokens) <= 0){
231 			reached = true;
232 
233 			uint256 real = remain;
234 
235 			remain = 0;
236 
237 			uint256 refund = weiAmount - real.mul(100).div(110).div(rate);
238 
239 			beneficiary.transfer(refund);
240 
241 			transferToken(beneficiary, real);
242 
243 			forwardFunds(weiAmount.sub(refund));
244 
245 			emit BuyTokens(beneficiary, weiAmount.sub(refund), real, now);
246 		} else{
247 
248 			remain = remain.sub(tokens);
249 
250 			transferToken(beneficiary, tokens);
251 
252 			forwardFunds(weiAmount);
253 
254 			emit BuyTokens(beneficiary, weiAmount, tokens, now);
255 		}
256 
257 	}
258 
259 	function calcBonus(uint256 token_amount) internal constant returns (uint256) {
260 		if(now > startTime && now <= (startTime + 3 days))
261 			return token_amount * 110 / 100;
262 		return token_amount;
263 	}
264 
265 	// low level transfer token
266 	// override to create custom token transfer mechanism, eg. pull pattern
267 	function transferToken(address beneficiary, uint256 tokenamount) internal {
268 		wpp.transfer(beneficiary, tokenamount);
269 		// address(wpp).call(bytes4(keccak256("transfer(address, uint256)")), beneficiary,tokenamount);
270 	}
271 
272 	// send ether to the fund collection wallet
273 	// override to create custom fund forwarding mechanisms
274 	function forwardFunds(uint256 weiAmount) internal {
275 		multisigwallet.transfer(weiAmount);
276 	}
277 
278 	// @return true if the transaction can buy tokens
279 	function validPurchase(uint256 weiAmount) internal constant returns (bool) {
280 		bool withinPeriod = now > startTime && now <= endTime;
281 		bool nonZeroPurchase = weiAmount >= 0.5 ether;
282 		bool withinSale = reached ? false : true;
283 		return withinPeriod && nonZeroPurchase && withinSale;
284 	} 
285 
286 	function setAdminlist(address _addr, bool _state) public onlyOwner {
287 		isAdminlisted[_addr] = _state;
288 		emit AdminlistSet(_addr, _state);
289 	}
290 
291 	function setWhitelist(address _addr) public onlyOwners {
292         require(_addr != address(0));
293         isWhitelisted[_addr] = true;
294         emit WhitelistSet(_addr, true);
295     }
296 
297     /// @notice Set whitelist state for multiple addresses
298     function setManyWhitelist(address[] _addr) public onlyOwners {
299         for (uint256 i = 0; i < _addr.length; i++) {
300             setWhitelist(_addr[i]);
301         }
302     }
303 
304 	// @return true if presale event has ended
305 	function hasEnded() public constant returns (bool) {
306 		return now > endTime;
307 	}
308 
309 	// @return true if presale has started
310 	function hasStarted() public constant returns (bool) {
311 		return now >= startTime;
312 	}
313 
314 	function setRate(uint256 _rate) public onlyOwner returns (bool) {
315 		require (now >= startTime && now <= endTime);
316 		rate = _rate;
317 	}
318 
319 	function treatRemaintoken() public onlyOwner returns (bool) {
320 		require(now > endTime);
321 		require(remain > 0);
322 		wpp.transfer(multisigwallet, remain);
323 		remain = 0;
324 		emit TreatRemainToken();
325 		return true;
326 
327 	}
328 
329 	function kill() public onlyOwner{
330         selfdestruct(owner);
331     }
332 	
333 }