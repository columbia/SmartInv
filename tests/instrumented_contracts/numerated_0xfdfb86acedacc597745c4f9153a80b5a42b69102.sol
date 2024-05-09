1 pragma solidity 0.4.25;
2 
3 contract Ownable {
4 
5     address public owner;
6     address public newOwner;
7 
8     event OwnershipTransferred(address indexed _from, address indexed _to);
9 
10     constructor () public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address _newOwner) public onlyOwner {
20         newOwner = _newOwner;
21     }
22 
23     function acceptOwnership() public {
24         require(msg.sender == newOwner);
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27         newOwner = address(0);
28     }
29 }
30 
31 contract Pausable is Ownable {
32 
33     event Pause();
34     event Unpause();
35 
36     bool public paused = false;
37 
38     /**
39      * @dev modifier to allow actions only when the contract IS paused
40      */
41     modifier whenNotPaused() {
42         require(!paused);
43         _;
44     }
45 
46     /**
47      * @dev modifier to allow actions only when the contract IS NOT paused
48      */
49     modifier whenPaused {
50         require(paused);
51         _;
52     }
53 
54     /**
55      * @dev called by the owner to pause, triggers stopped state
56      */
57     function pause() onlyOwner whenNotPaused public returns (bool) {
58         paused = true;
59         emit Pause();
60         return true;
61     }
62 
63     /**
64      * @dev called by the owner to unpause, returns to normal state
65      */
66     function unpause() onlyOwner whenPaused public returns (bool) {
67         paused = false;
68         emit Unpause();
69         return true;
70     }
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79     /**
80     * @dev Multiplies two numbers, throws on overflow.
81     */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83         if (a == 0) {
84             return 0;
85         }
86         c = a * b;
87         assert(c / a == b);
88         return c;
89     }
90 
91     /**
92     * @dev Integer division of two numbers, truncating the quotient.
93     */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         // assert(b > 0); // Solidity automatically throws when dividing by 0
96         // uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98         return a / b;
99     }
100 
101     /**
102     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103     */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         assert(b <= a);
106         return a - b;
107     }
108 
109     /**
110     * @dev Adds two numbers, throws on overflow.
111     */
112     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113         c = a + b;
114         assert(c >= a);
115         return c;
116     }
117 }
118 
119 library ContractLib {
120     /*
121     * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
122     */
123     function isContract(address _addr) internal view returns (bool) {
124         uint length;
125         assembly {
126             //retrieve the size of the code on target address, this needs assembly
127             length := extcodesize(_addr)
128         }
129         return (length>0);
130     }
131 }
132 
133 /*
134 * Contract that is working with ERC223 tokens
135 */
136 contract ContractReceiver {
137     function tokenFallback(address _from, uint _value, bytes _data) public pure;
138 }
139 
140 // ----------------------------------------------------------------------------
141 // ERC Token Standard #20 Interface
142 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
143 // ----------------------------------------------------------------------------
144 contract ERC20Interface {
145 
146     function totalSupply() public constant returns (uint);
147     function balanceOf(address tokenOwner) public constant returns (uint);
148     function allowance(address tokenOwner, address spender) public constant returns (uint);
149     function transfer(address to, uint tokens) public returns (bool);
150     function approve(address spender, uint tokens) public returns (bool);
151     function transferFrom(address from, address to, uint tokens) public returns (bool);
152 
153     function name() public constant returns (string);
154     function symbol() public constant returns (string);
155     function decimals() public constant returns (uint8);
156 
157     event Transfer(address indexed from, address indexed to, uint tokens);
158     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
159 
160 }
161 
162 
163 /**
164 * ERC223 token by Dexaran
165 *
166 * https://github.com/Dexaran/ERC223-token-standard
167 */
168 
169 /* New ERC223 contract interface */
170 contract ERC223 is ERC20Interface {
171 
172     function transfer(address to, uint value, bytes data) public returns (bool);
173 
174     event Transfer(address indexed from, address indexed to, uint tokens);
175     event Transfer(address indexed from, address indexed to, uint value, bytes data);
176 
177 }
178 
179 contract LANDA is ERC223, Pausable {
180 
181     using SafeMath for uint256;
182     using ContractLib for address;
183 
184     mapping(address => uint) balances;
185     mapping(address => mapping(address => uint)) allowed;
186 
187     string public name;
188     string public symbol;
189     uint8 public decimals;
190     uint256 public totalSupply;
191 
192     event Burn(address indexed from, uint256 value);
193 
194     // ------------------------------------------------------------------------
195     // Constructor
196     // ------------------------------------------------------------------------
197     constructor() public {
198         symbol      = "LANDA";
199         name        = "LANDA";
200         decimals    = 18;
201         totalSupply = 20000000 * 10**uint(decimals);
202         balances[msg.sender] = totalSupply;
203         // emit Transfer(address(0), msg.sender, totalSupply);
204     }
205 
206     // Function to access name of token .
207     function name() public constant returns (string) {
208         return name;
209     }
210 
211     // Function to access symbol of token .
212     function symbol() public constant returns (string) {
213         return symbol;
214     }
215 
216     // Function to access decimals of token .
217     function decimals() public constant returns (uint8) {
218         return decimals;
219     }
220 
221     // Function to access total supply of tokens .
222     function totalSupply() public constant returns (uint256) {
223         return totalSupply;
224     }
225 
226     // Function that is called when a user or another contract wants to transfer funds .
227     function transfer(address _to, uint _value, bytes _data) public whenNotPaused returns (bool) {
228         // require(_to != 0x0);
229         if(_to.isContract()) {
230             return transferToContract(_to, _value, _data);
231         }
232         else {
233             return transferToAddress(_to, _value, _data);
234         }
235     }
236 
237     // Standard function transfer similar to ERC20 transfer with no _data .
238     // Added due to backwards compatibility reasons .
239     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
240         //standard function transfer similar to ERC20 transfer with no _data
241         //added due to backwards compatibility reasons
242         // require(_to != 0x0);
243 
244         bytes memory empty;
245         if(_to.isContract()) {
246             return transferToContract(_to, _value, empty);
247         }
248         else {
249             return transferToAddress(_to, _value, empty);
250         }
251     }
252 
253     // function that is called when transaction target is an address
254     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
255         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
256         balances[_to]        = balanceOf(_to).add(_value);
257         emit Transfer(msg.sender, _to, _value);
258         emit Transfer(msg.sender, _to, _value, _data);
259         return true;
260     }
261 
262     // function that is called when transaction target is a contract
263     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
264         balances[msg.sender]      = balanceOf(msg.sender).sub(_value);
265         balances[_to]             = balanceOf(_to).add(_value);
266         ContractReceiver receiver = ContractReceiver(_to);
267         receiver.tokenFallback(msg.sender, _value, _data);
268         emit Transfer(msg.sender, _to, _value);
269         emit Transfer(msg.sender, _to, _value, _data);
270         return true;
271     }
272 
273     // get the address of balance
274     function balanceOf(address _owner) public constant returns (uint) {
275         return balances[_owner];
276     }  
277 
278     function burn(uint256 _value) public whenNotPaused returns (bool) {
279         require (_value > 0); 
280         require (balanceOf(msg.sender) >= _value);                      // Check if the sender has enough
281         balances[msg.sender] = balanceOf(msg.sender).sub(_value);       // Subtract from the sender
282         totalSupply = totalSupply.sub(_value);                          // Updates totalSupply
283         emit Burn(msg.sender, _value);
284         return true;
285     }
286 
287     // ------------------------------------------------------------------------
288     // Token owner can approve for `spender` to transferFrom(...) `tokens`
289     // from the token owner's account
290     //
291     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
292     // recommends that there are no checks for the approval double-spend attack
293     // as this should be implemented in user interfaces 
294     // ------------------------------------------------------------------------
295     function approve(address spender, uint tokens) public whenNotPaused returns (bool) {
296         allowed[msg.sender][spender] = tokens;
297         emit Approval(msg.sender, spender, tokens);
298         return true;
299     }
300 
301     function increaseApproval (address _spender, uint _addedValue) public whenNotPaused
302         returns (bool success) {
303         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
304         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305         return true;
306     }
307 
308     function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused
309         returns (bool success) {
310         uint oldValue = allowed[msg.sender][_spender];
311         if (_subtractedValue > oldValue) {
312           allowed[msg.sender][_spender] = 0;
313         } else {
314           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
315         }
316         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
317         return true;
318     }
319 
320     // ------------------------------------------------------------------------
321     // Transfer `tokens` from the `from` account to the `to` account
322     // 
323     // The calling account must already have sufficient tokens approve(...)-d
324     // for spending from the `from` account and
325     // - From account must have sufficient balance to transfer
326     // - Spender must have sufficient allowance to transfer
327     // - 0 value transfers are allowed
328     // ------------------------------------------------------------------------
329     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool) {
330         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
331         balances[from]            = balances[from].sub(tokens);
332         balances[to]              = balances[to].add(tokens);
333         emit Transfer(from, to, tokens);
334         return true;
335     }
336 
337     // ------------------------------------------------------------------------
338     // Returns the amount of tokens approved by the owner that can be
339     // transferred to the spender's account
340     // ------------------------------------------------------------------------
341     function allowance(address tokenOwner, address spender) public constant returns (uint) {
342         return allowed[tokenOwner][spender];
343     }
344 
345     // ------------------------------------------------------------------------
346     // Don't accept ETH
347     // ------------------------------------------------------------------------
348     function () public payable {
349         revert();
350     }
351 
352     // ------------------------------------------------------------------------
353     // Owner can transfer out any accidentally sent ERC20 tokens
354     // ------------------------------------------------------------------------
355     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool) {
356         return ERC20Interface(tokenAddress).transfer(owner, tokens);
357     }
358 
359 }