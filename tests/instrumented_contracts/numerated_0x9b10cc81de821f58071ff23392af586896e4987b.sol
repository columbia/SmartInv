1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'AWMV' AnyWhereMobile Voucher Token
5 //
6 // Symbol      : AWMV
7 // Name        : Example Fixed Supply Token
8 // Total supply: 100,000,000,000.000000
9 // Decimals    : 6
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe math
16 // ----------------------------------------------------------------------------
17 
18 contract SafeMath {
19 
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24 
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29 
30     function mul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34 
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 
40 }
41 
42 
43 
44 // ----------------------------------------------------------------------------
45 // ERC Token Standard #20 Interface
46 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
47 // ----------------------------------------------------------------------------
48 
49 contract ERC20Interface {
50     function totalSupply() public constant returns (uint);
51     function balanceOf(address tokenOwner) public constant returns (uint balance);
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 
60     // This notifies clients about the amount burnt
61     event Burn(address indexed from, uint256 value);
62 
63     // This notifies clients about the amount minted
64     event Mint(address indexed from, uint256 value);
65     
66     // This generates a public event on the blockchain that will notify clients 
67     event FrozenFunds(address target, bool frozen);
68 }
69 
70 // ----------------------------------------------------------------------------
71 // Contract function to receive approval and execute function in one call
72 //
73 // Borrowed from MiniMeToken
74 // ----------------------------------------------------------------------------
75 contract ApproveAndCallFallBack {
76     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 // Owned contract
82 // ----------------------------------------------------------------------------
83 contract Owned {
84     address public owner;
85     address public newOwner;
86 
87     event OwnershipTransferred(address indexed _from, address indexed _to);
88 
89     function Owned() public {
90         owner = msg.sender;
91     }
92 
93     modifier onlyOwner {
94         require(msg.sender == owner);
95         _;
96     }
97 
98     function transferOwnership(address _newOwner) public onlyOwner {
99         newOwner = _newOwner;
100     }
101 
102     function acceptOwnership() public {
103         require(msg.sender == newOwner);
104         OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         newOwner = address(0);
107     }
108 }
109 
110 // ----------------------------------------------------------------------------
111 // StopTrade contract - allows owner to stop trading
112 // ----------------------------------------------------------------------------
113 contract StopTrade is Owned {
114 
115     bool public stopped = false;
116 
117     event TradeStopped(bool stopped);
118 
119     modifier stoppable {
120         assert (!stopped);
121         _;
122     }
123 
124     function stop() onlyOwner public {
125         stopped = true;
126         TradeStopped(true);
127     }
128 
129     function start() onlyOwner public {
130         stopped = false;
131         TradeStopped(false);
132     }
133 }
134 
135 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ; }
136 
137 // ----------------------------------------------------------------------------
138 // ERC20 Token, with the addition of symbol, name and decimals and an
139 // initial fixed supply
140 // ----------------------------------------------------------------------------
141 
142 contract AWMVoucher is ERC20Interface, SafeMath, StopTrade {
143 
144     string public symbol;
145     string public  name;
146     uint8 public decimals;
147     uint public _totalSupply;
148 
149     mapping(address => uint) balances;
150     mapping(address => mapping(address => uint)) allowed;
151     mapping (address => bool) public frozenAccount;
152 
153     // ------------------------------------------------------------------------
154     // Constructor
155     // ------------------------------------------------------------------------
156     function AWMVoucher() public {
157 
158         symbol = "ATEST";
159         name = "AWM Test Token";
160         decimals = 6;
161 
162         _totalSupply = 100000000000 * 10**uint(decimals);
163 
164         balances[owner] = _totalSupply;
165         Transfer(address(0), owner, _totalSupply);
166     }
167 
168     // ------------------------------------------------------------------------
169     // Total supply
170     // ------------------------------------------------------------------------
171     function totalSupply() public constant returns (uint) {
172         return _totalSupply  - balances[address(0)];
173     }
174 
175     // ------------------------------------------------------------------------
176     // Get the token balance for account `tokenOwner`
177     // ------------------------------------------------------------------------
178     function balanceOf(address tokenOwner) public constant returns (uint balance) {
179         return balances[tokenOwner];
180     }
181 
182     /**
183      * Internal transfer, only can be called by this contract
184      */
185     function _transfer(address _from, address _to, uint _value) internal {
186         // Prevent transfer to 0x0 address. Use burn() instead
187         require(_to != 0x0);
188         // Check if the sender has enough
189         require(balances[_from] >= _value);
190         // Check for overflows
191         require(balances[_to] + _value > balances[_to]);
192         require(!frozenAccount[_from]);          // Check if sender is frozen
193         require(!frozenAccount[_to]);            // Check if recipient is frozen
194 
195         // Save this for an assertion in the future
196         uint previousBalances = add(balances[_from], balances[_to]);
197 
198         // Subtract from the sender
199         balances[_from] -= _value;
200 
201         // Add the same to the recipient
202         balances[_to] += _value;
203         Transfer(_from, _to, _value);
204 
205         // Asserts are used to use static analysis to find bugs in your code. They should never fail
206         assert(balances[_from] + balances[_to] == previousBalances);
207     }
208 
209      /**
210      * Transfer tokens
211      *
212      * Send `_value` tokens to `_to` from your account
213      *
214      * @param _to The address of the recipient
215      * @param _value the amount to send
216      */
217     function transfer(address _to, uint256 _value) stoppable public returns (bool success) {
218         _transfer(msg.sender, _to, _value);
219         return true;
220     }
221 
222     /**
223      * Transfer tokens from other address
224      *
225      * Send `_value` tokens to `_to` in behalf of `_from`
226      *
227      * @param _from The address of the sender
228      * @param _to The address of the recipient
229      * @param _value the amount to send
230      */
231     function transferFrom(address _from, address _to, uint256 _value) stoppable public returns (bool success) {
232         require(_value <= allowed[_from][msg.sender]);     // Check allowance
233         allowed[_from][msg.sender] -= _value;
234         _transfer(_from, _to, _value);
235         return true;
236     }
237 
238     /**
239      * Redeem tokens
240      *
241      * Send `_value` tokens from '_from' to `_to`
242      * Used to redeem AWMVouchers for AWMDollars
243      *
244      * @param _from The address of the source
245      * @param _to The address of the recipient
246      * @param _value the amount to send
247      */
248     function redeem(address _from, address _to, uint256 _value) stoppable public onlyOwner {
249         _transfer(_from, _to, _value);
250     }
251 
252 
253 
254     /**
255      * Set allowance for other address
256      *
257      * Allows `_spender` to spend no more than `_value` tokens in your behalf
258      *
259      * @param _spender The address authorized to spend
260      * @param _value the max amount they can spend
261      */
262     function approve(address _spender, uint256 _value) public
263         returns (bool success) {
264         allowed[msg.sender][_spender] = _value;
265 	    Approval(msg.sender, _spender, _value);
266         return true;
267     }
268 
269     /**
270      * Set allowance for other address and notify
271      *
272      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
273      *
274      * @param _spender The address authorized to spend
275      * @param _value the max amount they can spend
276      * @param _extraData some extra information to send to the approved contract
277      */
278     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
279         public
280         returns (bool success) {
281         tokenRecipient spender = tokenRecipient(_spender);
282         if (approve(_spender, _value)) {
283             spender.receiveApproval(msg.sender, _value, this, _extraData);
284             return true;
285         }
286     }
287 
288 
289     // ------------------------------------------------------------------------
290     // Returns the amount of tokens approved by the owner that can be
291     // transferred to the spender's account
292     // ------------------------------------------------------------------------
293     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
294         return allowed[tokenOwner][spender];
295     }
296 
297     /**
298      * Destroy tokens
299      *
300      * Remove `_value` tokens from the system irreversibly
301      *
302      * @param _value the amount of money to burn
303      */
304     function burn(uint256 _value) stoppable onlyOwner public returns (bool success) {
305         require(balances[msg.sender] >= _value);   // Check if the sender has enough
306         balances[msg.sender] = sub(balances[msg.sender], _value); 
307         _totalSupply = sub(_totalSupply,_value);
308         Burn(msg.sender, _value);
309         return true;
310     }
311 
312     /**
313      * Destroy tokens from other account
314      *
315      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
316      *
317      * @param _from the address of the sender
318      * @param _value the amount of money to burn
319      */
320     function burnFrom(address _from, uint256 _value) stoppable onlyOwner public returns (bool success) {
321         require(balances[_from] >= _value);                // Check if the targeted balance is enough
322         require(_value <= allowed[_from][msg.sender]);    // Check allowance
323 
324         // Subtract from the targeted balance
325         balances[_from] = sub(balances[_from], _value);
326 
327         // Subtract from the sender's allowance
328         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
329 
330         //totalSupply -= _value;                              // Update totalSupply
331         _totalSupply = sub(_totalSupply, _value);
332 
333         Burn(_from, _value);
334         return true;
335     }
336 
337     /// @notice Create `mintedAmount` tokens and send it to `target`
338     /// @param _target Address to receive the tokens
339     /// @param _mintedAmount the amount of tokens it will receive
340     function mintToken(address _target, uint256 _mintedAmount) onlyOwner stoppable public {
341         require(!frozenAccount[_target]);            // Check if recipient is frozen
342 
343 	balances[_target] = add(balances[_target], _mintedAmount);
344 
345         _totalSupply = add(_totalSupply, _mintedAmount);
346 
347         Mint(_target, _mintedAmount);
348         Transfer(0, this, _mintedAmount);
349         Transfer(this, _target, _mintedAmount);
350     }
351 
352     
353 
354     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
355     /// @param _target Address to be frozen
356     /// @param _freeze either to freeze it or not
357     function freezeAccount(address _target, bool _freeze) onlyOwner public {
358         frozenAccount[_target] = _freeze;
359         FrozenFunds(_target, _freeze);
360     }
361 
362     // ------------------------------------------------------------------------
363     // Don't accept ETH
364     // ------------------------------------------------------------------------
365     function () public payable {
366         revert();
367     }
368 
369     // ------------------------------------------------------------------------
370     // Owner can transfer out any accidentally sent ERC20 tokens
371     // ------------------------------------------------------------------------
372     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
373 
374         return ERC20Interface(tokenAddress).transfer(owner, tokens);
375     }
376 
377 
378     function transferToken(address _tokenContract, address _transferTo, uint256 _value) onlyOwner external {
379 
380          // If ERC20 tokens are sent to this contract, they will be trapped forever.
381          // This function is way for us to withdraw them so we can get them back to their rightful owner
382 
383          ERC20Interface(_tokenContract).transfer(_transferTo, _value);
384     }
385 
386     function transferTokenFrom(address _tokenContract, address _transferTo, address _transferFrom, uint256 _value) onlyOwner external {
387 
388          // If ERC20 tokens are sent to this contract, they will be trapped forever.
389          // This function is way for us to withdraw them so we can get them back to their rightful owner
390 
391          ERC20Interface(_tokenContract).transferFrom(_transferTo, _transferFrom, _value);
392     }
393 
394     function approveToken(address _tokenContract, address _spender, uint256 _value) onlyOwner external {
395          // If ERC20 tokens are sent to this contract, they will be trapped forever.
396          // This function is way for us to withdraw them so we can get them back to their rightful owner
397 
398          ERC20Interface(_tokenContract).approve(_spender, _value);
399     }
400 
401 }