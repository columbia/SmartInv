1 /* solium-disable-next-line linebreak-style */
2 pragma solidity 0.4.24;
3 
4 // ----------------------------------------------------------------------------
5 // Math - Implement Math Library
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 r = a + b;
11 
12         require(r >= a, 'Require r >= a');
13 
14         return r;
15     }
16 
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(a >= b, 'Require a >= b');
20 
21         return a - b;
22     }
23 
24 
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 r = a * b;
31 
32         require(r / a == b, 'Require r / a == b');
33 
34         return r;
35     }
36 
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a / b;
40     }
41 }
42 
43 // ----------------------------------------------------------------------------
44 // ERC20Interface - Standard ERC20 Interface Definition
45 // Based on the final ERC20 specification at:
46 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
47 // ----------------------------------------------------------------------------
48 contract ERC20Interface {
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 
53     function balanceOf(address _owner) public view returns (uint256 balance);
54     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
55 
56     function transfer(address _to, uint256 _value) public returns (bool success);
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
58     function approve(address _spender, uint256 _value) public returns (bool success);
59 }
60 
61 // ----------------------------------------------------------------------------
62 // ERC20Token - Standard ERC20 Implementation
63 // ----------------------------------------------------------------------------
64 contract ERC20Token is ERC20Interface {
65 
66     using SafeMath for uint256;
67 
68     string public  name;
69     string public symbol;
70     uint8 public decimals;
71     uint256 public totalSupply;
72 
73     mapping(address => uint256) internal balances;
74     mapping(address => mapping (address => uint256)) allowed;
75 
76 
77     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
78         name = _name;
79         symbol = _symbol;
80         decimals = _decimals;
81         totalSupply = _totalSupply;
82 
83         // The initial balance of tokens is assigned to the given token holder address.
84         balances[_initialTokenHolder] = _totalSupply;
85         allowed[_initialTokenHolder][_initialTokenHolder] = balances[_initialTokenHolder];
86 
87         // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
88         emit Transfer(0x0, _initialTokenHolder, _totalSupply);
89     }
90 
91     function transfer(address _to, uint256 _value)  public returns (bool success) {
92         require(balances[msg.sender] >= _value, 'Sender`s balance is not enough');
93         require(balances[_to] + _value > balances[_to], 'Value is invalid');
94         require(_to != address(0), '_to address is invalid');
95 
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98 
99         emit Transfer(msg.sender, _to, _value);
100 
101         return true;
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(balances[_from] >= _value, 'Owner`s balance is not enough');
106         require(allowed[_from][msg.sender] >= _value, 'Sender`s allowance is not enough');
107         require(balances[_to] + _value > balances[_to], 'Token amount value is invalid');
108         require(_to != address(0), '_to address is invalid');
109 
110         balances[_from] = balances[_from].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113 
114         emit Transfer(_from, _to, _value);
115 
116         return true;
117     }
118 
119     function balanceOf(address _owner) public view returns (uint256 balance) {
120         return balances[_owner];
121     }
122 
123 
124     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
125         return allowed[_owner][_spender];
126     }
127 
128     function approve(address _spender, uint256 _value) public returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130 
131         emit Approval(msg.sender, _spender, _value);
132 
133         return true;
134     }
135 
136     /**
137      * approve should be called when allowed[_spender] == 0. To increment
138      * allowed value is better to use this function to avoid 2 calls (and wait until
139      * the first transaction is mined)
140      * From MonolithDAO Token.sol
141      */
142     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
143         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145         return true;
146     }
147 
148     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
149         uint256 oldValue = allowed[msg.sender][_spender];
150         if (_subtractedValue > oldValue) {
151             allowed[msg.sender][_spender] = 0;
152         } else {
153             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154         }
155         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158 }
159 
160 
161 // Implements a simple ownership model with 2-phase transfer.
162 contract Owned {
163 
164     address public owner;
165     address public proposedOwner;
166 
167     constructor() public
168     {
169         owner = msg.sender;
170     }
171 
172 
173     modifier onlyOwner() {
174         require(isOwner(msg.sender) == true, 'Require owner to execute transaction');
175         _;
176     }
177 
178 
179     function isOwner(address _address) public view returns (bool result) {
180         return (_address == owner);
181     }
182 
183 
184     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool success) {
185         require(_proposedOwner != address(0), 'Require proposedOwner != address(0)');
186         require(_proposedOwner != address(this), 'Require proposedOwner != address(this)');
187         require(_proposedOwner != owner, 'Require proposedOwner != owner');
188 
189         proposedOwner = _proposedOwner;
190         return true;
191     }
192 
193 
194     function completeOwnershipTransfer() public returns (bool success) {
195         require(msg.sender == proposedOwner, 'Require msg.sender == proposedOwner');
196 
197         owner = msg.sender;
198         proposedOwner = address(0);
199 
200         return true;
201     }
202 }
203 
204 // ----------------------------------------------------------------------------
205 // OpsManaged - Implements an Owner and Ops Permission Model
206 // ----------------------------------------------------------------------------
207 contract OpsManaged is Owned {
208 
209     address public opsAddress;
210 
211 
212     constructor() public
213         Owned()
214     {
215     }
216 
217 
218     modifier onlyOwnerOrOps() {
219         require(isOwnerOrOps(msg.sender), 'Require only owner or ops');
220         _;
221     }
222 
223 
224     function isOps(address _address) public view returns (bool result) {
225         return (opsAddress != address(0) && _address == opsAddress);
226     }
227 
228 
229     function isOwnerOrOps(address _address) public view returns (bool result) {
230         return (isOwner(_address) || isOps(_address));
231     }
232 
233 
234     function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool success) {
235         require(_newOpsAddress != owner, 'Require newOpsAddress != owner');
236         require(_newOpsAddress != address(this), 'Require newOpsAddress != address(this)');
237 
238         opsAddress = _newOpsAddress;
239 
240         return true;
241     }
242 }
243 
244 // ----------------------------------------------------------------------------
245 // Finalizable - Implement Finalizable (Crowdsale) model
246 // ----------------------------------------------------------------------------
247 contract Finalizable is OpsManaged {
248 
249     FinalizeState public finalized;
250 
251     enum FinalizeState {
252         None,
253         Finalized
254     }
255 
256     event Finalized();
257 
258 
259     constructor() public OpsManaged()
260     {
261         finalized = FinalizeState.None;
262     }
263 
264 
265     function finalize() public onlyOwner returns (bool success) {
266         require(finalized == FinalizeState.None, 'Require !finalized');
267 
268         finalized = FinalizeState.Finalized;
269 
270         emit Finalized();
271 
272         return true;
273     }
274 }
275 
276 
277 // ----------------------------------------------------------------------------
278 // FinalizableToken - Extension to ERC20Token with ops and finalization
279 // ----------------------------------------------------------------------------
280 //
281 // ERC20 token with the following additions:
282 //    1. Owner/Ops Ownership
283 //    2. Finalization
284 //
285 contract FinalizableToken is ERC20Token, Finalizable {
286 
287     using SafeMath for uint256;
288 
289 
290     // The constructor will assign the initial token supply to the owner (msg.sender).
291     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
292         ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
293         Finalizable()
294     {
295     }
296 
297 
298     function transfer(address _to, uint256 _value) public returns (bool success) {
299         validateTransfer(msg.sender, _to);
300 
301         return super.transfer(_to, _value);
302     }
303 
304 
305     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
306         validateTransfer(msg.sender, _to);
307 
308         return super.transferFrom(_from, _to, _value);
309     }
310 
311 
312     function validateTransfer(address _sender, address _to) internal view {
313         // Once the token is finalized, everybody can transfer tokens.
314         if (finalized == FinalizeState.Finalized) {
315             return;
316         }
317 
318         if (isOwner(_to)) {
319             return;
320         }
321 
322         require(_to != opsAddress, 'Ops cannot recieve token');
323 
324         // Before the token is finalized, only owner and ops are allowed to initiate transfers.
325         // This allows them to move tokens while the sale is still in private sale.
326         require(isOwnerOrOps(_sender), 'Require is owner or ops allowed to initiate transfer');
327     }
328 }
329 
330 
331 
332 // ----------------------------------------------------------------------------
333 // Token Contract Configuration
334 // ----------------------------------------------------------------------------
335 contract TokenConfig {
336 
337     string  internal constant TOKEN_SYMBOL      = 'SLS';
338     string  internal constant TOKEN_NAME        = 'SKILLSH';
339     uint8   internal constant TOKEN_DECIMALS    = 8;
340 
341     uint256 internal constant DECIMALS_FACTOR    = 10 ** uint256(TOKEN_DECIMALS);
342     uint256 internal constant TOKEN_TOTAL_SUPPLY = 500000000 * DECIMALS_FACTOR;
343 }
344 
345 
346 
347 // ----------------------------------------------------------------------------
348 // Token Contract
349 // ----------------------------------------------------------------------------
350 contract SLSToken is FinalizableToken, TokenConfig {
351 
352     enum HaltState {
353         Unhalted,
354         Halted
355     }
356 
357     HaltState public halts;
358 
359     constructor() public
360         FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTAL_SUPPLY)
361     {
362         halts = HaltState.Unhalted;
363         finalized = FinalizeState.None;
364     }
365 
366     function transfer(address _to, uint256 _value) public returns (bool success) {
367         require(halts == HaltState.Unhalted, 'Require smart contract is not in halted state');
368 
369         if(isOps(msg.sender)) {
370             return super.transferFrom(owner, _to, _value);
371         }
372 
373         return super.transfer(_to, _value);
374     }
375 
376     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
377         require(halts == HaltState.Unhalted, 'Require smart contract is not in halted state');
378         return super.transferFrom(_from, _to, _value);
379     }
380 
381     // Allows a token holder to burn tokens. Once burned, tokens are permanently
382     // removed from the total supply.
383     function burn(uint256 _amount) public returns (bool success) {
384         require(_amount > 0, 'Token amount to burn must be larger than 0');
385 
386         address account = msg.sender;
387         require(_amount <= balanceOf(account), 'You cannot burn token you dont have');
388 
389         balances[account] = balances[account].sub(_amount);
390         totalSupply = totalSupply.sub(_amount);
391         return true;
392     }
393 
394     /* Halts or unhalts direct trades without the sell/buy functions below */
395     function haltsTrades() public onlyOwnerOrOps returns (bool success) {
396         halts = HaltState.Halted;
397         return true;
398     }
399 
400     function unhaltsTrades() public onlyOwnerOrOps returns (bool success) {
401         halts = HaltState.Unhalted;
402         return true;
403     }
404 
405 }