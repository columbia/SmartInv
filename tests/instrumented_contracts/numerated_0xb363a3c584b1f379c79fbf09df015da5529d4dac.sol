1 pragma solidity ^0.4.16;
2 
3 contract Owned {
4 	address public owner;
5 	address public signer;
6 
7     function Owned() public {
8     	owner = msg.sender;
9     	signer = msg.sender;
10     }
11 
12     modifier onlyOwner {
13     	require(msg.sender == owner);
14         _;
15     }
16 
17 	modifier onlySigner {
18     	require(msg.sender == signer);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) public onlyOwner {
23     	owner = newOwner;
24 	}
25 
26 	function transferSignership(address newSigner) public onlyOwner {
27         signer = newSigner;
28     }
29 }
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37 
38     function mul(uint256 a, uint256 b)
39         internal
40         pure
41         returns (uint256)
42     {
43         uint256 c = a * b;
44         assert(a == 0 || c / a == b);
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b)
49         internal
50         pure
51         returns (uint256)
52     {
53         // assert(b > 0); // Solidity automatically throws when dividing by 0
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56         return c;
57     }
58 
59     function sub(uint256 a, uint256 b)
60         internal
61         pure
62         returns (uint256)
63     {
64         assert(b <= a);
65         return a - b;
66     }
67 
68     function add(uint256 a, uint256 b)
69         internal
70         pure
71         returns (uint256)
72     {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 
80 contract ERC20Token {
81 
82     // Public variables of the token
83     string public name;
84     string public symbol;
85     uint8 public decimals = 18;
86 
87     uint256 public totalSupply;
88 
89     // This creates an array with all balances
90     mapping (address => uint256) public balances;
91 
92 	// Mapping for allowance
93     mapping (address => mapping (address => uint256)) public allowed;
94 
95     // This generates a public event on the blockchain that will notify clients
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     // This generates a public event on the blockchain that will notify clients
99     event Approval(address indexed sender, address indexed spender, uint256 value);
100 
101 	function ERC20Token(uint256 _supply, string _name, string _symbol)
102 		public
103 	{
104 		//initial mint
105         totalSupply = _supply * 10**uint256(decimals);
106         balances[msg.sender] = totalSupply;
107 
108 		//set variables
109 		name=_name;
110 		symbol=_symbol;
111 
112     	//trigger event
113         Transfer(0x0, msg.sender, totalSupply);
114 	}
115 
116 	/**
117 	 * Returns current tokens total supply
118 	 */
119     function totalSupply()
120     	public
121     	constant
122     	returns (uint256)
123     {
124 		return totalSupply;
125     }
126 
127 	/**
128      * Get the token balance for account `tokenOwner`
129      */
130     function balanceOf(address _owner)
131     	public
132     	constant
133     	returns (uint256 balance)
134     {
135         return balances[_owner];
136     }
137 
138 	/**
139      * Set allowance for other address
140      *
141      * Allows `_spender` to spend no more than `_value` tokens on your behalf
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      */
146     function approve(address _spender, uint256 _value)
147     	public
148     	returns (bool success)
149     {
150 		// To change the approve amount you first have to reduce the addresses`
151         //  allowance to zero by calling `approve(_spender,0)` if it is not
152         //  already 0 to mitigate the race condition described here:
153         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
155 
156       	//set allowance
157       	allowed[msg.sender][_spender] = _value;
158 
159 		//trigger event
160       	Approval(msg.sender, _spender, _value);
161 
162 		return true;
163     }
164 
165     /**
166      * Show allowance
167      */
168     function allowance(address _owner, address _spender)
169     	public
170     	constant
171     	returns (uint256 remaining)
172     {
173         return allowed[_owner][_spender];
174     }
175 
176 	/**
177      * Internal transfer, only can be called by this contract
178      */
179     function _transfer(address _from, address _to, uint256 _value)
180     	internal
181     	returns (bool success)
182     {
183 		// Do not allow transfer to 0x0 or the token contract itself or from address to itself
184 		require((_to != address(0)) && (_to != address(this)) && (_to != _from));
185 
186         // Check if the sender has enough
187         require((_value > 0) && (balances[_from] >= _value));
188 
189         // Check for overflows
190         require(balances[_to] + _value > balances[_to]);
191 
192         // Subtract from the sender
193         balances[_from] -= _value;
194 
195         // Add the same to the recipient
196         balances[_to] += _value;
197 
198         Transfer(_from, _to, _value);
199 
200         return true;
201     }
202 
203 	/**
204       * Transfer tokens
205       *
206       * Send `_value` tokens to `_to` from your account
207       *
208       * @param _to The address of the recipient
209       * @param _value the amount to send
210       */
211     function transfer(address _to, uint256 _value)
212     	public
213     	returns (bool success)
214     {
215     	return _transfer(msg.sender, _to, _value);
216     }
217 
218   	/**
219      * Transfer tokens from other address
220      *
221      * Send `_value` tokens to `_to` on behalf of `_from`
222      *
223      * @param _from The address of the sender
224      * @param _to The address of the recipient
225      * @param _value the amount to send
226      */
227     function transferFrom(address _from, address _to, uint256 _value)
228     	public
229     	returns (bool success)
230     {
231 		// Check allowance
232     	require(_value <= allowed[_from][msg.sender]);
233 
234 		//decrement allowance
235 		allowed[_from][msg.sender] -= _value;
236 
237     	//transfer tokens
238         return _transfer(_from, _to, _value);
239     }
240 }
241 
242 
243 
244 contract MiracleTeleToken is ERC20Token, Owned {
245 
246     using SafeMath for uint256;
247 
248     // Mapping for allowance
249     mapping (address => uint8) public delegations;
250 
251 	mapping (address => uint256) public contributions;
252 
253     // This generates a public event on the blockchain that will notify clients
254     event Delegate(address indexed from, address indexed to);
255     event UnDelegate(address indexed from, address indexed to);
256 
257     // This generates a public event on the blockchain that will notify clients
258     event Contribute(address indexed from, uint256 indexed value);
259     event Reward(address indexed from, uint256 indexed value);
260 
261     /**
262 	 * Initializes contract with initial supply tokens to the creator of the contract
263 	 */
264     function MiracleTeleToken(uint256 _supply) ERC20Token(_supply, "MiracleTele", "TELE") public {}
265 
266 	/**
267 	 * Mint new tokens
268 	 *
269 	 * @param _value the amount of new tokens
270 	 */
271     function mint(uint256 _value)
272         public
273         onlyOwner
274     {
275     	// Prevent mine 0 tokens
276         require(_value > 0);
277 
278     	// Check overflow
279     	balances[owner] = balances[owner].add(_value);
280         totalSupply = totalSupply.add(_value);
281 
282         Transfer(address(0), owner, _value);
283     }
284 
285     function delegate(uint8 _v, bytes32 _r, bytes32 _s)
286         public
287         onlySigner
288     {
289 		address allowes = ecrecover(getPrefixedHash(signer), _v, _r, _s);
290 
291         delegations[allowes]=1;
292 
293         Delegate(allowes, signer);
294     }
295 
296 	function unDelegate(uint8 _v, bytes32 _r, bytes32 _s)
297         public
298         onlySigner
299     {
300     	address allowes = ecrecover(getPrefixedHash(signer), _v, _r, _s);
301 
302         delegations[allowes]=0;
303 
304         UnDelegate(allowes, signer);
305     }
306 
307 	/**
308      * Show delegation
309      */
310     function delegation(address _owner)
311     	public
312     	constant
313     	returns (uint8 status)
314     {
315         return delegations[_owner];
316     }
317 
318     /**
319      * @notice Hash a hash with `"\x19Ethereum Signed Message:\n32"`
320      * @param _message Data to ign
321      * @return signHash Hash to be signed.
322      */
323     function getPrefixedHash(address _message)
324         pure
325         public
326         returns(bytes32 signHash)
327     {
328         signHash = keccak256("\x19Ethereum Signed Message:\n20", _message);
329     }
330 
331     /**
332      * Transfer tokens from other address
333      *
334      * Send `_value` tokens to `_to` on behalf of `_from`
335      *
336      * @param _from The address of the sender
337      * @param _to The address of the recipient
338      * @param _value the amount to send
339      */
340     function transferDelegated(address _from, address _to, uint256 _value)
341         public
342         onlySigner
343         returns (bool success)
344     {
345         // Check delegate
346     	require(delegations[_from]==1);
347 
348     	//transfer tokens
349         return _transfer(_from, _to, _value);
350     }
351 
352 	/**
353       * Contribute tokens from delegated address
354       *
355       * Contribute `_value` tokens `_from` address
356       *
357       * @param _from The address of the sender
358 	  * @param _value the amount to send
359       */
360     function contributeDelegated(address _from, uint256 _value)
361         public
362         onlySigner
363     {
364         // Check delegate
365     	require(delegations[_from]==1);
366 
367         // Check if the sender has enough
368         require((_value > 0) && (balances[_from] >= _value));
369 
370         // Subtract from the sender
371         balances[_from] = balances[_from].sub(_value);
372 
373         contributions[_from] = contributions[_from].add(_value);
374 
375         Contribute(_from, _value);
376     }
377 
378 	/**
379       * Reward tokens from delegated address
380       *
381       * Reward `_value` tokens to `_from` address
382       *
383       * @param _from The address of the sender
384 	  * @param _value the amount to send
385       */
386     function reward(address _from, uint256 _value)
387         public
388         onlySigner
389     {
390         require(contributions[_from]>=_value);
391 
392         contributions[_from] = contributions[_from].sub(_value);
393 
394         balances[_from] = balances[_from].add(_value);
395 
396         Reward(_from, _value);
397     }
398 
399     /**
400      * Don't accept ETH, it is utility token
401      */
402 	function ()
403 	    public
404 	    payable
405 	{
406 		revert();
407 	}
408 }