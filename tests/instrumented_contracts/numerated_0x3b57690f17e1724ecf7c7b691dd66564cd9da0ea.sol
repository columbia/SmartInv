1 pragma solidity ^ 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public totalSupply;
13     function balanceOf(address _owner) external view returns (uint256 amount);
14     function transfer(address _to, uint256 _value) external returns(bool success);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 }
18 
19 contract Burnable {
20     
21     function burn(uint256 _value) external returns(bool success);
22     function burnFrom(address _from, uint256 _value) external returns(bool success);
23     
24     // This notifies clients about the amount burnt
25     event Burn(address indexed _from, uint256 _value);
26 }
27 
28 // ----------------------------------------------------------------------------
29 // Owned contract
30 // ----------------------------------------------------------------------------
31 contract Owned {
32     
33     address public owner;
34     address public newOwner;
35 
36     modifier onlyOwner {
37         require(msg.sender == owner, "only Owner can do this");
38         _;
39     }
40 
41     function transferOwnership(address _newOwner) 
42     external onlyOwner {
43         newOwner = _newOwner;
44     }
45     
46     function acceptOwnership() 
47     external {
48         require(msg.sender == newOwner, "only new Owner can do this");
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51         newOwner = address(0);
52     }
53     
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 }
56 
57 contract Permissioned {
58     
59     function approve(address _spender, uint256 _value) public returns(bool success);
60     function transferFrom(address _from, address _to, uint256 _value) external returns(bool success);
61     function allowance(address _owner, address _spender) external view returns (uint256 amount);
62 
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 }
65 
66 /**
67 * @title SafeMath
68 * @dev Math operations with safety checks that throw on error
69 */
70 library SafeMath {
71 
72     /**
73     * @dev Multiplies two numbers, throws on overflow.
74     */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76         if (a == 0) {
77             return 0;
78         }
79         c = a * b;
80         require(c / a == b, "mul overflow");
81         return c;
82     }
83 
84     /**
85     * @dev Integer division of two numbers, truncating the quotient.
86     */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b > 0, "div by zero");
89         uint256 c = a / b;
90         return c;
91     }
92 
93     /**
94     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95     */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b <= a, "sub overflow");
98         return a - b;
99     }
100 
101     /**
102     * @dev Adds two numbers, throws on overflow.
103     */
104     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105         c = a + b;
106         require(c >= a, "add overflow");
107         return c;
108     }
109 }
110 
111 //interface for approveAndCall
112 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
113 
114 /** @title NelCoin token. */
115 contract NelCoin is ERC20Interface, Burnable, Owned, Permissioned {
116     // be aware of overflows
117     using SafeMath for uint256;
118 
119     // This creates an array with all balances
120     mapping(address => uint256) internal _balanceOf;
121     
122     // This creates an array with all allowance
123     mapping(address => mapping(address => uint256)) internal _allowance;
124 	
125 	uint public forSale;
126 
127     /**
128     * Constructor function
129     *
130     * Initializes contract with initial supply tokens to the creator of the contract
131     */
132     constructor()
133     public {
134         owner = msg.sender;
135         symbol = "NEL";
136         name = "NelCoin";
137         decimals = 2;
138         forSale = 12000000 * (10 ** uint(decimals));
139         totalSupply = 21000000 * (10 ** uint256(decimals));
140         _balanceOf[msg.sender] = totalSupply;
141         emit Transfer(address(0), msg.sender, totalSupply);
142     }
143 
144     /**
145     * Get the token balance for account
146     *
147     * Get token balance of `_owner` account
148     *
149     * @param _owner The address of the owner
150     */
151     function balanceOf(address _owner)
152     external view
153     returns(uint256 balance) {
154         return _balanceOf[_owner];
155     }
156 
157     /**
158     * Internal transfer, only can be called by this contract
159     */
160     function _transfer(address _from, address _to, uint256 _value)
161     internal {
162         // Prevent transfer to 0x0 address. Use burn() instead
163         require(_to != address(0), "use burn() instead");
164         // Check if the sender has enough
165         require(_balanceOf[_from] >= _value, "not enough balance");
166         // Subtract from the sender
167         _balanceOf[_from] = _balanceOf[_from].sub(_value);
168         // Add the same to the recipient
169         _balanceOf[_to] = _balanceOf[_to].add(_value);
170         emit Transfer(_from, _to, _value);
171     }
172 
173     /**
174     * Transfer tokens
175     *
176     * Send `_value` tokens to `_to` from your account
177     *
178     * @param _to The address of the recipient
179     * @param _value the amount to send
180     */
181     function transfer(address _to, uint256 _value)
182     external
183     returns(bool success) {
184         _transfer(msg.sender, _to, _value);
185         return true;
186     }
187 
188     /**
189     * Transfer tokens from other address
190     *
191     * Send `_value` tokens to `_to` on behalf of `_from`
192     *
193     * @param _from The address of the sender
194     * @param _to The address of the recipient
195     * @param _value the amount to send
196     */
197     function transferFrom(address _from, address _to, uint256 _value)
198     external
199     returns(bool success) {
200         require(_value <= _allowance[_from][msg.sender], "allowance too loow");     // Check allowance
201         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
202         _transfer(_from, _to, _value);
203         emit Approval(_from, _to, _allowance[_from][_to]);
204         return true;
205     }
206 
207     /**
208     * Set allowance for other address
209     *
210     * Allows `_spender` to spend no more than `_value` tokens on your behalf
211     *
212     * @param _spender The address authorized to spend
213     * @param _value the max amount they can spend
214     */
215     function approve(address _spender, uint256 _value)
216     public
217     returns(bool success) {
218         _allowance[msg.sender][_spender] = _value;
219         emit Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     /**
224     * Set allowance for other address and notify
225     *
226     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
227     *
228     * @param _spender The address authorized to spend
229     * @param _value the max amount they can spend
230     * @param _extraData some extra information to send to the approved contract
231     */
232     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
233     external
234     returns(bool success) {
235         tokenRecipient spender = tokenRecipient(_spender);
236         if (approve(_spender, _value)) {
237             spender.receiveApproval(msg.sender, _value, this, _extraData);
238             return true;
239         }
240     }
241 
242     /**
243     * @dev Function to check the amount of tokens that an owner allowed to a spender.
244     * @param _owner address The address which owns the funds.
245     * @param _spender address The address which will spend the funds.
246     * @return A uint256 specifying the amount of tokens still available for the spender.
247     */
248     function allowance(address _owner, address _spender)
249     external view
250     returns(uint256 amount) {
251         return _allowance[_owner][_spender];
252     }
253 
254     /**
255     * @dev Increase the amount of tokens that an owner allowed to a spender.
256     *
257     * approve should be called when allowed[_spender] == 0. To increment
258     * allowed value is better to use this function to avoid 2 calls (and wait until
259     * the first transaction is mined)
260     * From MonolithDAO Token.sol
261     * @param _spender The address which will spend the funds.
262     * @param _addedValue The amount of tokens to increase the allowance by.
263     */
264     function increaseApproval(address _spender, uint _addedValue)
265     external
266     returns(bool success) {
267         _allowance[msg.sender][_spender] = _allowance[msg.sender][_spender].add(_addedValue);
268         emit Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
269         return true;
270     }
271 
272     /**
273     * @dev Decrease the amount of tokens that an owner allowed to a spender.
274     *
275     * approve should be called when allowed[_spender] == 0. To decrement
276     * allowed value is better to use this function to avoid 2 calls (and wait until
277     * the first transaction is mined)
278     * From MonolithDAO Token.sol
279     * @param _spender The address which will spend the funds.
280     * @param _subtractedValue The amount of tokens to decrease the allowance by.
281     */
282     function decreaseApproval(address _spender, uint _subtractedValue)
283     external
284     returns(bool success) {
285         uint256 oldValue = _allowance[msg.sender][_spender];
286         if (_subtractedValue > oldValue) {
287             _allowance[msg.sender][_spender] = 0;
288         } else {
289             _allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290         }
291         emit Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
292         return true;
293     }
294 
295     /**
296     * @dev Destroy tokens
297     *
298     * Remove `_value` tokens from the system irreversibly
299     *
300     * @param _value the amount of money to burn
301     */
302     function burn(uint256 _value)
303     external
304     returns(bool success) {
305         _burn(msg.sender, _value);
306         return true;
307     }
308 
309     /**
310     * @dev Destroy tokens from other account
311     *
312     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
313     *
314     * @param _from the address of the sender
315     * @param _value the amount of money to burn
316     */
317     function burnFrom(address _from, uint256 _value)
318     external
319     returns(bool success) {
320         require(_value <= _allowance[_from][msg.sender], "allowance too low");                           // Check allowance
321         require(_value <= _balanceOf[_from], "balance too low");                                       // Is tehere enough coins on account
322         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);  // Subtract from the sender's allowance
323         _burn(_from, _value);
324         emit Approval(_from, msg.sender, _allowance[_from][msg.sender]);
325         return true;
326     }
327 
328     //internal burn function
329     function _burn(address _from, uint256 _value)
330     internal {
331         require(_balanceOf[_from] >= _value, "balance too low");               // Check if the targeted balance is enough
332         _balanceOf[_from] = _balanceOf[_from].sub(_value);  // Subtract from the sender
333         totalSupply = totalSupply.sub(_value);              // Updates totalSupply
334         emit Burn(msg.sender, _value);
335         emit Transfer(_from, address(0), _value);
336     }
337 
338 	//We accept intentional donations in ETH
339     event Donated(address indexed _from, uint256 _value);
340 
341 	/**
342     * Donate ETH tokens to contract (Owner)
343     */
344 	function donation() 
345     external payable 
346     returns (bool success){
347         emit Donated(msg.sender, msg.value);
348         return(true);
349     }
350     
351     //Don`t accept accidental ETH
352     function()
353     external payable
354     {
355         require(false, "Use fund() or donation()");
356     }
357     
358 	/**
359 	 * Buy NelCoin using ETH
360 	 * Contract is selling tokens at price 20000NEL/1ETH, 
361 	 * total 12000000NEL for sale
362 	 */
363 	function fund()
364 	external payable
365 	returns (uint amount){
366 		require(forSale > 0, "Sold out!");
367 		uint tokenCount = ((msg.value).mul(20000 * (10 ** uint(decimals)))).div(10**18);
368 		require(tokenCount >= 1, "Send more ETH to buy at least one token!");
369 		require(tokenCount <= forSale, "You want too much! Check forSale()");
370 		forSale -= tokenCount;
371 		_transfer(owner, msg.sender, tokenCount);
372 		return tokenCount;
373 	}
374 	
375 	/**
376     * Tranfer all ETH from contract to Owner addres.
377     */
378     function withdraw()
379     onlyOwner external
380     returns (bool success){
381         require(address(this).balance > 0, "Nothing to withdraw");
382         owner.transfer(address(this).balance);
383         return true;
384     }
385 	
386 	/**
387     * Transfer some ETH tokens from contract
388     *
389     * Transfer _value of ETH from contract to Owner addres.
390     * @param _value number of wei to trasfer
391     */
392 	function withdraw(uint _value)
393     onlyOwner external
394     returns (bool success){
395 		require(_value > 0, "provide amount pls");
396 		require(_value < address(this).balance, "Too much! Check balance()");
397 		owner.transfer(_value);
398         return true;
399 	}
400 	
401     /**
402     * Check ETH balance of contract
403     */
404 	function balance()
405 	external view
406 	returns (uint amount){
407 		return (address(this).balance);
408 	}
409     
410 	/**
411     * Transfer ERC20 tokens from contract
412     *
413     * Tranfer _amount of ERC20 from contract _tokenAddress to Owner addres.
414     *
415     * @param _amount amount of ERC20 tokens to be transferred 
416 	* @param _tokenAddress address of ERC20 token contract
417     */
418 	function transferAnyERC20Token(address _tokenAddress, uint256 _amount)
419     onlyOwner external
420     returns(bool success) {
421         return ERC20Interface(_tokenAddress).transfer(owner, _amount);
422     }
423 }