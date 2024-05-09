1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4 	address public owner;
5 	address public signer;
6 
7 	constructor() public {
8 		owner = msg.sender;
9 		signer = msg.sender;
10 	}
11 
12     modifier onlyOwner {
13     	require(msg.sender == owner);
14         _;
15     }
16 
17     modifier onlySigner {
18 	require(msg.sender == signer);
19 	_;
20     }
21 
22     function transferOwnership(address newOwner) public onlyOwner {
23 	owner = newOwner;
24     }
25 
26     function transferSignership(address newSigner) public onlyOwner {
27         signer = newSigner;
28     }
29 }
30 
31 
32 contract ERC20Token {
33 
34     // Public variables of the token
35     string public name;
36     string public symbol;
37     uint8 public decimals = 18;
38 
39     uint256 public totalSupply;
40 
41     // This creates an array with all balances
42     mapping (address => uint256) public balances;
43 
44     // Mapping for allowance
45     mapping (address => mapping (address => uint256)) public allowed;
46 
47     // This generates a public event on the blockchain that will notify clients
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     // This generates a public event on the blockchain that will notify clients
51     event Approval(address indexed sender, address indexed spender, uint256 value);
52 
53     constructor(uint256 _supply, string _name, string _symbol)
54 	public
55     {
56 	//initial mint
57         totalSupply = _supply * 10**uint256(decimals);
58         balances[msg.sender] = totalSupply;
59 
60 	//set variables
61 	name=_name;
62 	symbol=_symbol;
63 
64 	//trigger event
65         emit Transfer(0x0, msg.sender, totalSupply);
66     }
67 
68 	/**
69 	 * Returns current tokens total supply
70 	 */
71     function totalSupply()
72     	public
73     	constant
74     	returns (uint256)
75     {
76 		return totalSupply;
77     }
78 
79 	/**
80      * Get the token balance for account `tokenOwner`
81      */
82     function balanceOf(address _owner)
83     	public
84     	constant
85     	returns (uint256 balance)
86     {
87         return balances[_owner];
88     }
89 
90 	/**
91      * Set allowance for other address
92      *
93      * Allows `_spender` to spend no more than `_value` tokens on your behalf
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      */
98     function approve(address _spender, uint256 _value)
99     	public
100     	returns (bool success)
101     {
102 		// To change the approve amount you first have to reduce the addresses`
103         //  allowance to zero by calling `approve(_spender,0)` if it is not
104         //  already 0 to mitigate the race condition described here:
105         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108       	//set allowance
109       	allowed[msg.sender][_spender] = _value;
110 
111 		//trigger event
112       	emit Approval(msg.sender, _spender, _value);
113 
114 		return true;
115     }
116 
117     /**
118      * Show allowance
119      */
120     function allowance(address _owner, address _spender)
121     	public
122     	constant
123     	returns (uint256 remaining)
124     {
125         return allowed[_owner][_spender];
126     }
127 
128 	/**
129      * Internal transfer, only can be called by this contract
130      */
131     function _transfer(address _from, address _to, uint256 _value)
132     	internal
133     	returns (bool success)
134     {
135 		// Do not allow transfer to 0x0 or the token contract itself or from address to itself
136 		require((_to != address(0)) && (_to != address(this)) && (_to != _from));
137 
138         // Check if the sender has enough
139         require((_value > 0) && (balances[_from] >= _value));
140 
141         // Check for overflows
142         require(balances[_to] + _value > balances[_to]);
143 
144         // Subtract from the sender
145         balances[_from] -= _value;
146 
147         // Add the same to the recipient
148         balances[_to] += _value;
149 
150         emit Transfer(_from, _to, _value);
151 
152         return true;
153     }
154 
155 	/**
156       * Transfer tokens
157       *
158       * Send `_value` tokens to `_to` from your account
159       *
160       * @param _to The address of the recipient
161       * @param _value the amount to send
162       */
163     function transfer(address _to, uint256 _value)
164     	public
165     	returns (bool success)
166     {
167     	return _transfer(msg.sender, _to, _value);
168     }
169 
170   	/**
171      * Transfer tokens from other address
172      *
173      * Send `_value` tokens to `_to` on behalf of `_from`
174      *
175      * @param _from The address of the sender
176      * @param _to The address of the recipient
177      * @param _value the amount to send
178      */
179     function transferFrom(address _from, address _to, uint256 _value)
180     	public
181     	returns (bool success)
182     {
183 		// Check allowance
184     	require(_value <= allowed[_from][msg.sender]);
185 
186 		//decrement allowance
187 		allowed[_from][msg.sender] -= _value;
188 
189     	//transfer tokens
190         return _transfer(_from, _to, _value);
191     }
192 }
193 
194 
195 /**
196  * @title SafeMath
197  * @dev Math operations with safety checks that throw on error
198  */
199 library SafeMath {
200 
201     function mul(uint256 a, uint256 b)
202         internal
203         pure
204         returns (uint256)
205     {
206         uint256 c = a * b;
207         assert(a == 0 || c / a == b);
208         return c;
209     }
210 
211     function div(uint256 a, uint256 b)
212         internal
213         pure
214         returns (uint256)
215     {
216         // assert(b > 0); // Solidity automatically throws when dividing by 0
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219         return c;
220     }
221 
222     function sub(uint256 a, uint256 b)
223         internal
224         pure
225         returns (uint256)
226     {
227         assert(b <= a);
228         return a - b;
229     }
230 
231     function add(uint256 a, uint256 b)
232         internal
233         pure
234         returns (uint256)
235     {
236         uint256 c = a + b;
237         assert(c >= a);
238         return c;
239     }
240 }
241 
242 contract CrowdSaleTeleToken is Owned {
243 
244 	using SafeMath for uint256;
245 
246 	uint256 public price;
247 
248 	ERC20Token public crowdSaleToken;
249 
250 	/**
251 	 * Constructor function
252 	 *
253 	 * Setup the owner
254 	 */
255 	constructor(uint256 _price, address _tokenAddress)
256 		public
257 	{
258 		//set initial token price
259 		price = _price;
260 
261 		//set crowdsale token
262 		crowdSaleToken = ERC20Token(_tokenAddress);
263 	}
264 
265 	/**
266 	 * Fallback function
267 	 *
268 	 * The function without name is the default function that is called whenever anyone sends funds to a contract
269 	 */
270 	function ()
271 		payable
272 		public
273 	{
274 		//calc buy amount
275 		uint256 amount = msg.value / price;
276 
277 		//check amount, it cannot be zero
278 		require(amount != 0);
279 
280 		//transfer required amount
281 		crowdSaleToken.transfer(msg.sender, amount.mul(10**18));
282 	}
283 
284 	/**
285 	 * Withdraw eth
286 	 */
287 	function withdrawalEth(uint256 _amount)
288 		public
289 		onlyOwner
290 	{
291 		//send requested amount to owner
292 		msg.sender.transfer(_amount);
293 	}
294 
295 	/**
296 	 * Withdraw tokens
297 	 */
298 	function withdrawalToken(uint256 _amount)
299 		public
300 		onlyOwner
301 	{
302 		//send requested amount to owner
303 		crowdSaleToken.transfer(msg.sender, _amount);
304 	}
305 
306 	/**
307 	 * Set token price
308 	 */
309 	function setPrice(uint256 _price)
310 		public
311 		onlyOwner
312 	{
313 		//check new price, it cannot be zero
314 		assert(_price != 0);
315 
316 		//set new crowdsale token price
317 		price = _price;
318 	}
319 }