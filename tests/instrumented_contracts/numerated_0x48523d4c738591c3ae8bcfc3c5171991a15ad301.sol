1 pragma solidity ^0.4.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract MyFirstEthereumToken {
6     // The keyword "public" makes those variables
7     // readable from outside.
8     address public owner;
9 	// Public variables of the token
10     string public name = "MyFirstEthereumToken";
11     string public symbol = "MFET";
12     uint8 public decimals = 18;	// 18 decimals is the strongly suggested default, avoid changing it
13  
14     uint256 public totalSupply; 
15 	uint256 public totalExtraTokens = 0;
16 	uint256 public totalContributed = 0;
17 	
18 	bool public onSale = false;
19 
20 	/* This creates an array with all balances */
21     mapping (address => uint256) public balances;
22 	mapping (address => mapping (address => uint256)) public allowance;
23 
24     // Events allow light clients to react on
25     // changes efficiently.
26     event Sent(address from, address to, uint amount);
27 	// This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     // This notifies clients about the amount burnt
30     event Burn(address indexed from, uint256 value);	
31 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 
33 	function name() public constant returns (string) { return name; }
34     function symbol() public constant returns (string) { return symbol; }
35     function decimals() public constant returns (uint8) { return decimals; }
36 	function totalSupply() public constant returns (uint256) { return totalSupply; }
37 	function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }
38 	
39     /**
40      * Constructor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function MyFirstEthereumToken(uint256 initialSupply) public payable
45 	{
46 		owner = msg.sender;
47 		
48 		// Update total supply with the decimal amount
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50 		//totalSupply = initialSupply;  
51 		// Give the creator all initial tokens
52         balances[msg.sender] = totalSupply; 
53 		// Give the creator all initial tokens		
54         //balanceOf[msg.sender] = initialSupply;  
55     }
56 
57     /**
58      * Transfer tokens
59      *
60      * Send `_value` tokens to `_to` from your account
61      *
62      * @param _to The address of the recipient
63      * @param _value the amount to send
64      */
65     function transfer(address _to, uint256 _value) public returns (bool success)
66 	{
67         return _transfer(msg.sender, _to, _value);
68     }
69 	
70     /**
71      * Internal transfer, only can be called by this contract
72      */
73     function _transfer(address _from, address _to, uint _value) internal returns (bool success)
74 	{
75 		// mitigates the ERC20 short address attack
76 		//require(msg.data.length >= (2 * 32) + 4);
77 		// checks for minimum transfer amount
78 		require(_value > 0);
79 		// Prevent transfer to 0x0 address. Use burn() instead  
80         require(_to != 0x0);	      
81 		// Check if the sender has enough
82         require(balances[_from] >= _value);	
83 		// Check for overflows
84         require(balances[_to] + _value > balances[_to]);	// Check for overflows
85         // Save this for an assertion in the future
86         uint previousBalances = balances[_from] + balances[_to];
87         // Subtract from the sender
88         balances[_from] -= _value;
89         // Add the same to the recipient
90         balances[_to] += _value;
91 		// Call for Event
92         Transfer(_from, _to, _value);
93         // Asserts are used to use static analysis to find bugs in your code. They should never fail
94         assert(balances[_from] + balances[_to] == previousBalances);
95 		
96 		return true;
97     }
98 
99     /**
100      * Send tokens
101      *
102      * Send `_value` tokens to `_to` from your account
103      *
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function send(address _to, uint256 _value) public 
108 	{
109         _send(_to, _value);
110     }
111 	
112     /**
113      * Internal send, only can be called by this contract
114      */
115     function _send(address _to, uint256 _value) internal 
116 	{	
117 		address _from = msg.sender;
118 		
119 		// mitigates the ERC20 short address attack
120 		//require(msg.data.length >= (2 * 32) + 4);
121 		// checks for minimum transfer amount
122 		require(_value > 0);
123 		// Prevent transfer to 0x0 address. Use burn() instead  
124         require(_to != 0x0);	      
125 		// Check if the sender has enough
126         require(balances[_from] >= _value);	
127 		// Check for overflows
128         require(balances[_to] + _value > balances[_to]);	// Check for overflows
129         // Save this for an assertion in the future
130         uint previousBalances = balances[_from] + balances[_to];
131         // Subtract from the sender
132         balances[_from] -= _value;
133         // Add the same to the recipient
134         balances[_to] += _value;
135 		// Call for Event
136         Sent(_from, _to, _value);
137         // Asserts are used to use static analysis to find bugs in your code. They should never fail
138         assert(balances[_from] + balances[_to] == previousBalances);
139     }
140 
141    /**
142      * Transfer tokens from other address
143      *
144      * Send `_value` tokens to `_to` on behalf of `_from`
145      *
146      * @param _from The address of the sender
147      * @param _to The address of the recipient
148      * @param _value the amount to send
149      */
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
151 	{
152         require(_value <= allowance[_from][msg.sender]);     // Check allowance
153         allowance[_from][msg.sender] -= _value;
154         _transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * Set allowance for other address
160      *
161      * Allows `_spender` to spend no more than `_value` tokens on your behalf
162      *
163      * @param _spender The address authorized to spend
164      * @param _value the max amount they can spend
165      */
166     function approve(address _spender, uint256 _value) public returns (bool success) 
167 	{
168         allowance[msg.sender][_spender] = _value;
169         return true;
170     }
171 
172     /**
173      * Set allowance for other address and notify
174      *
175      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
176      *
177      * @param _spender The address authorized to spend
178      * @param _value the max amount they can spend
179      * @param _extraData some extra information to send to the approved contract
180      */
181     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) 
182 	{
183         tokenRecipient spender = tokenRecipient(_spender);
184 		
185         if (approve(_spender, _value)) {
186             spender.receiveApproval(msg.sender, _value, this, _extraData);
187             return true;
188         }
189     }
190 	
191 	/**
192      * Create tokens
193      *
194      * Create `_amount` tokens to `owner` account
195      *
196      * @param _amount the amount to create
197      */	
198     function createTokens(uint256 _amount) public
199 	{
200 	    require(msg.sender == owner);
201         //if (msg.sender != owner) return;
202         
203         balances[owner] += _amount; 
204         totalSupply += _amount;
205 		
206         Transfer(0, owner, _amount);
207     }
208 
209 	/**
210      * Withdraw funds
211      *
212      * Transfers the total amount of funds to ownwer account minus gas fee
213      *
214      */	
215     function safeWithdrawAll() public returns (bool)
216 	{
217 	    require(msg.sender == owner);
218 		
219 		uint256 _gasPrice = 30000000000;
220 		
221 		require(this.balance > _gasPrice);
222 		
223 		uint256 _totalAmount = this.balance - _gasPrice;
224 		
225 		owner.transfer(_totalAmount);
226 		
227 		return true;
228     }
229 	
230 	/**
231      * Withdraw funds
232      *
233      * Create `_amount` tokens to `owner` account
234      *
235      * @param _amount the amount to create
236      */	
237     function safeWithdraw(uint256 _amount) public returns (bool)
238 	{
239 	    require(msg.sender == owner);
240 		
241 		uint256 _gasPrice = 30000000000;
242 		
243 		require(_amount > 0);
244 		
245 		uint256 totalAmount = _amount + _gasPrice; 
246 		
247 		require(this.balance >= totalAmount);
248 		
249 		owner.transfer(totalAmount);
250 		
251 		return true;
252     }
253     
254 	function getBalanceContract() public constant returns(uint)
255 	{
256 		require(msg.sender == owner);
257 		
258         return this.balance;
259     }
260 	
261 	/**
262      * Destroy tokens
263      *
264      * Remove `_value` tokens from the system irreversibly
265      *
266      * @param _value the amount of money to burn
267      */
268     function burn(uint256 _value) public returns (bool success) {
269         require(balances[msg.sender] >= _value);   // Check if the sender has enough
270         balances[msg.sender] -= _value;            // Subtract from the sender
271         totalSupply -= _value;                      // Updates totalSupply
272         Burn(msg.sender, _value);
273         return true;
274     }
275 
276     /**
277      * Destroy tokens from other account
278      *
279      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
280      *
281      * @param _from the address of the sender
282      * @param _value the amount of money to burn
283      */
284     function burnFrom(address _from, uint256 _value) public returns (bool success) {
285         require(balances[_from] >= _value);                // Check if the targeted balance is enough
286         require(_value <= allowance[_from][msg.sender]);    // Check allowance
287         balances[_from] -= _value;                         // Subtract from the targeted balance
288         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
289         totalSupply -= _value;                              // Update totalSupply
290         Burn(_from, _value);
291         return true;
292     }
293 	
294 	// A function to buy tokens accesible by any address
295 	// The payable keyword allows the contract to accept ethers
296 	// from the transactor. The ethers to be deposited is entered as msg.value
297 	// (which will get clearer when we will call the functions in browser-solidity)
298 	// and the corresponding tokens are stored in balance[msg.sender] mapping.
299 	// underflows and overflows are security consideration which are
300 	// not checked in the process. But lets not worry about them for now.
301 
302 	function buyTokens () public payable 
303 	{
304 		// checks for minimum transfer amount
305 		require(msg.value > 0);
306 		
307 		require(onSale == true);
308 		
309 		owner.transfer(msg.value);
310 			
311 		totalContributed += msg.value;
312 		
313 		uint256 tokensAmount = msg.value * 1000;
314 		
315 		if(totalContributed >= 1 ether)
316 		{
317 			
318 			uint256 multiplier = (totalContributed / 1 ether);
319 			
320 			uint256 extraTokens = (tokensAmount * multiplier) / 10;
321 			
322 			totalExtraTokens += extraTokens;
323 			
324 			tokensAmount += extraTokens;
325 		}
326 			
327 		balances[msg.sender] += tokensAmount;
328 		
329 		totalSupply += tokensAmount;
330         
331         Transfer(address(this), msg.sender, tokensAmount);
332 	}
333 	
334 	/**
335      * EnableSale Function
336      *
337      */	
338 	function enableSale() public
339 	{
340 		require(msg.sender == owner);
341 
342         onSale = true;
343     }
344 	
345 	/**
346      * DisableSale Function
347      *
348      */	
349 	function disableSale() public 
350 	{
351 		require(msg.sender == owner);
352 
353         onSale = false;
354     }
355 	
356     /**
357      * Kill Function
358      *
359      */	
360     function kill() public
361 	{
362 	    require(msg.sender == owner);
363 	
364 		onSale = false;
365 	
366         selfdestruct(owner);
367     }
368 	
369     /**
370      * Fallback Function
371      *
372      */	
373 	function() public payable 
374 	{
375 		buyTokens();
376 		//totalContributed += msg.value;
377 	}
378 }