1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'ALS' 'Akilos' token contract
5 //
6 // Symbol      : ALS
7 // Name        : Akilos
8 // Total supply: 15,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
64 }
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71 
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 }
81 
82 // ----------------------------------------------------------------------------
83 // Withdraw Confirmation contract
84 // ----------------------------------------------------------------------------
85 contract WithdrawConfirmation is Owned {
86 	event Confirmation(address indexed sender, uint indexed withdrawId);
87 	event OwnerAddition(address indexed owner);
88     event OwnerRemoval(address indexed owner);
89 	event WithdrawCreated(address indexed destination, uint indexed value, uint indexed id);
90 	event Execution(uint indexed withdrawId);
91 	event ExecutionFailure(uint indexed withdrawId);
92 
93 	mapping(address => bool) public isOwner;
94 	mapping(uint => Withdraw) public withdraws;
95 	mapping(uint => mapping(address => bool)) public confirmations;
96 	address[] public owners;
97 	uint public withdrawCount;
98 	
99 	struct Withdraw {
100 		address destination;
101 		uint value;
102 		bool executed;
103 	}
104 	
105 	modifier hasPermission() {
106         require(isOwner[msg.sender]);
107         _;
108     }
109 	
110 	modifier ownerDoesNotExist(address _owner) {
111         require(!isOwner[_owner]);
112         _;
113     }
114 	
115 	modifier ownerExists(address _owner) {
116         require(isOwner[_owner]);
117         _;
118     }
119 	
120 	modifier notNull(address _address) {
121         require(_address != 0);
122         _;
123     }
124 	
125 	modifier notConfirmed(uint withdrawId, address _owner) {
126         require(!confirmations[withdrawId][_owner]);
127         _;
128     }
129 	
130 	modifier withdrawExists(uint withdrawId) {
131         require(withdraws[withdrawId].destination != 0);
132         _;
133     }
134 	
135 	modifier confirmed(uint withdrawId, address _owner) {
136         require(confirmations[withdrawId][_owner]);
137         _;
138     }
139 	
140 	modifier notExecuted(uint withdrawId) {
141         require(!withdraws[withdrawId].executed);
142         _;
143     }
144 	
145 	constructor() public {
146 		owners.push(owner);
147 		isOwner[owner] = true;
148 	}
149 	
150 	function addOwner(address _owner) public ownerDoesNotExist(_owner) hasPermission {
151 		isOwner[_owner] = true;
152 		owners.push(_owner);
153 		emit OwnerAddition(_owner);
154 	}
155 	
156 	function removeOwner(address _owner) public ownerExists(_owner) hasPermission {
157 		require(_owner != owner);
158         isOwner[_owner] = false;
159         for(uint i=0; i < owners.length - 1; i++) {
160             if(owners[i] == _owner) {
161                 owners[i] = owners[owners.length - 1];
162                 break;
163             }
164 		}
165         owners.length -= 1;
166         emit OwnerRemoval(_owner);
167     }
168 	
169 	function createWithdraw(address to, uint value) public ownerExists(msg.sender) notNull(to) {
170 		uint withdrawId = withdrawCount;
171 		withdraws[withdrawId] = Withdraw({
172 			destination: to,
173 			value: value,
174 			executed: false
175 		});
176 		withdrawCount += 1;
177 		confirmations[withdrawId][msg.sender] = true;
178 		emit WithdrawCreated(to, value, withdrawId);
179 		executeWithdraw(withdrawId);
180 	}
181 	
182 	function isConfirmed(uint withdrawId) public constant returns(bool) {
183 		for(uint i=0; i < owners.length; i++) {
184             if(!confirmations[withdrawId][owners[i]])
185                 return false;
186         }
187 		return true;
188 	}
189 	
190 	function confirmWithdraw(uint withdrawId) public ownerExists(msg.sender) withdrawExists(withdrawId) notConfirmed(withdrawId, msg.sender) {
191 		confirmations[withdrawId][msg.sender] = true;
192 		emit Confirmation(msg.sender, withdrawId);
193 		executeWithdraw(withdrawId);
194 	}
195 	
196 	function executeWithdraw(uint withdrawId) public ownerExists(msg.sender) confirmed(withdrawId, msg.sender) notExecuted(withdrawId) {
197 		if(isConfirmed(withdrawId)) {
198 			Withdraw storage with = withdraws[withdrawId];
199 			with.executed = true;
200 			if(with.destination.send(with.value))
201 				emit Execution(withdrawId);
202 			else {
203 				emit ExecutionFailure(withdrawId);
204                 with.executed = false;
205 			}
206 		}
207 	}
208 }
209 
210 // ----------------------------------------------------------------------------
211 // ERC20 Token, with the addition of symbol, name and decimals and a
212 // fixed supply
213 // ----------------------------------------------------------------------------
214 contract AkilosToken is ERC20Interface, Owned, WithdrawConfirmation {
215     using SafeMath for uint;
216 
217     string public symbol;
218     string public  name;
219     uint8 public decimals;
220     uint _totalSupply;
221 	
222 	bool public started = false;
223 	uint public currentRate;
224 	uint public minimalInvestment = 0.1 ether;
225 	uint public currentRoundSales;
226 	uint public roundNumber;
227 	uint public roundOneTotal;
228 	uint public roundTwoTotal;
229 	
230 	mapping(address => uint) balances;
231 	mapping(address => mapping(address => uint)) allowed;
232 
233 	/* This notifies clients about the amount burnt */
234     event Burn(address indexed from, uint value);
235 
236     // ------------------------------------------------------------------------
237     // Constructor
238     // ------------------------------------------------------------------------
239     constructor() public {
240         symbol = "ALS";
241         name = "Akilos";
242         decimals = 18;
243         _totalSupply = 15000000 * 10**uint(decimals);
244 		roundOneTotal = 3000000 * 10**uint(decimals);
245 		roundTwoTotal = 7000000 * 10**uint(decimals);
246         balances[owner] = _totalSupply;
247         emit Transfer(address(0), owner, _totalSupply);
248     }
249 	
250 	function setCurrentRate(uint _rate) public onlyOwner () {
251 		currentRate = _rate;
252 	}
253 	
254 	function setStarted(bool _started) public onlyOwner () {
255 		started = _started;
256 	}
257 	
258 	function setRoundNumber(uint _roundNumber) public onlyOwner () {
259 		roundNumber = _roundNumber;
260 	}
261 	
262 	function resetCurrentRoundSales() public onlyOwner () {
263 		currentRoundSales = 0;
264 	}
265 
266     // ------------------------------------------------------------------------
267     // Total supply
268     // ------------------------------------------------------------------------
269     function totalSupply() public view returns (uint) {
270         return _totalSupply.sub(balances[address(0)]);
271     }
272 
273 
274     // ------------------------------------------------------------------------
275     // Get the token balance for account `tokenOwner`
276     // ------------------------------------------------------------------------
277     function balanceOf(address tokenOwner) public view returns (uint balance) {
278         return balances[tokenOwner];
279     }
280 
281 
282     // ------------------------------------------------------------------------
283     // Transfer the balance from token owner's account to `to` account
284     // - Owner's account must have sufficient balance to transfer
285     // - 0 value transfers are allowed
286     // ------------------------------------------------------------------------
287     function transfer(address to, uint tokens) public returns (bool success) {
288         balances[msg.sender] = balances[msg.sender].sub(tokens);
289         balances[to] = balances[to].add(tokens);
290         emit Transfer(msg.sender, to, tokens);
291         return true;
292     }
293 
294 
295     // ------------------------------------------------------------------------
296     // Token owner can approve for `spender` to transferFrom(...) `tokens`
297     // from the token owner's account
298     //
299     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
300     // recommends that there are no checks for the approval double-spend attack
301     // as this should be implemented in user interfaces 
302     // ------------------------------------------------------------------------
303     function approve(address spender, uint tokens) public returns (bool success) {
304         allowed[msg.sender][spender] = tokens;
305         emit Approval(msg.sender, spender, tokens);
306         return true;
307     }
308 
309 
310     // ------------------------------------------------------------------------
311     // Transfer `tokens` from the `from` account to the `to` account
312     // 
313     // The calling account must already have sufficient tokens approve(...)-d
314     // for spending from the `from` account and
315     // - From account must have sufficient balance to transfer
316     // - Spender must have sufficient allowance to transfer
317     // - 0 value transfers are allowed
318     // ------------------------------------------------------------------------
319     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
320         balances[from] = balances[from].sub(tokens);
321         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
322         balances[to] = balances[to].add(tokens);
323         emit Transfer(from, to, tokens);
324         return true;
325     }
326 
327 
328     // ------------------------------------------------------------------------
329     // Returns the amount of tokens approved by the owner that can be
330     // transferred to the spender's account
331     // ------------------------------------------------------------------------
332     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
333         return allowed[tokenOwner][spender];
334     }
335 
336 
337     // ------------------------------------------------------------------------
338     // Token owner can approve for `spender` to transferFrom(...) `tokens`
339     // from the token owner's account. The `spender` contract function
340     // `receiveApproval(...)` is then executed
341     // ------------------------------------------------------------------------
342     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
343         allowed[msg.sender][spender] = tokens;
344         emit Approval(msg.sender, spender, tokens);
345         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
346         return true;
347     }
348 
349 
350     // ------------------------------------------------------------------------
351     // Accept Ether
352     // ------------------------------------------------------------------------
353     function () public payable {
354 		require(started);
355 		require(msg.value >= minimalInvestment);
356 		require(currentRate != 0);
357 		require(roundNumber != 0);
358 		uint tokens;
359 		tokens = msg.value * currentRate;
360 		if(roundNumber == 1) {
361 			require(currentRoundSales.add(tokens) <= roundOneTotal);
362 		}
363 		if(roundNumber == 2) {
364 			require(currentRoundSales.add(tokens) <= roundTwoTotal);
365 		}
366         balances[msg.sender] = balances[msg.sender].add(tokens);
367 		balances[owner] = balances[owner].sub(tokens);
368 		currentRoundSales = currentRoundSales.add(tokens);
369         emit Transfer(owner, msg.sender, tokens);
370     }
371 
372 
373     // ------------------------------------------------------------------------
374     // Owner can transfer out any accidentally sent ERC20 tokens
375     // ------------------------------------------------------------------------
376     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
377         return ERC20Interface(tokenAddress).transfer(owner, tokens);
378     }
379 	
380 	// ------------------------------------------------------------------------
381     // Burn
382     // ------------------------------------------------------------------------
383     function burn(uint _value) public returns (bool success) {
384 		require(balances[msg.sender] >= _value); // Check if the sender has enough
385 		require(_value > 0); // Check if the sender has enough
386         balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
387         _totalSupply = _totalSupply.sub(_value); // Updates totalSupply
388         emit Burn(msg.sender, _value);
389         return true;
390     }
391 }