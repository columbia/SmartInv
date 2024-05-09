1 pragma solidity ^0.6.6;
2 
3 //SPDX-License-Identifier: UNLICENSED
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint c) {
10         require(b > 0);
11         c = a + b;
12         require(c >= a);
13     }
14     function sub(uint a, uint b) internal pure returns (uint c) {
15         require(b > 0);
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 contract Owned {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed _from, address indexed _to);
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43 	/**
44 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
45 	* @param newOwner The address to transfer ownership to.
46 	*/
47 	function transferOwnership(address newOwner) public onlyOwner {
48 		if (newOwner != address(0)) {
49 			owner = newOwner;
50 			emit OwnershipTransferred(owner, newOwner);
51 		}
52 	}
53 }
54 
55 // ----------------------------------------------------------------------------
56 //Tokenlock trade
57 // ----------------------------------------------------------------------------
58 contract Tokenlock is Owned {
59   uint8 isLocked = 0;
60   event Freezed();
61   event UnFreezed();
62   modifier validLock {
63     require(isLocked == 0);
64     _;
65   }
66   function freeze() public onlyOwner {
67     isLocked = 1;
68     emit Freezed();
69   }
70   function unfreeze() public onlyOwner {
71     isLocked = 0;
72     emit UnFreezed();
73   }
74 
75 
76   mapping(address => bool) blacklist;
77   event LockUser(address indexed who);
78   event UnlockUser(address indexed who);
79 
80   modifier permissionCheck {
81     require(!blacklist[msg.sender]);
82     _;
83   }
84 
85   function lockUser(address who) public onlyOwner {
86     blacklist[who] = true;
87     emit LockUser(who);
88   }
89 
90   function unlockUser(address who) public onlyOwner {
91     blacklist[who] = false;
92     emit UnlockUser(who);
93   }
94 
95 }
96 
97 
98 contract Pact is Tokenlock {
99 
100     using SafeMath for uint;
101     string public name = "Polkadot Pact";
102     string public symbol = "PACT";
103     uint8  public decimals = 18;
104     uint  internal _rate=100;
105     uint  internal _amount;
106     uint256  public totalSupply;
107 
108     //bank
109     mapping(address => uint)  bank_balances;
110     //eth
111     mapping(address => uint) activeBalances;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
117     event Transfer(address indexed _from, address indexed _to, uint256 value);
118     event Burn(address indexed _from, uint256 value);
119 	// Called when new token are issued
120 	event Issue(uint amount);
121 	// Called when tokens are redeemed
122 	event Redeem(uint amount);
123     //Called when sent
124     event Sent(address from, address to, uint amount);
125     event FallbackCalled(address sent, uint amount);
126 
127     	/**
128 	* @dev Fix for the ERC20 short address attack.
129 	*/
130 	modifier onlyPayloadSize(uint size) {
131 		require(!(msg.data.length < size + 4));
132 		_;
133 	}
134 
135     constructor (uint totalAmount) public{
136         totalSupply =  totalAmount * 10**uint256(decimals);
137         balances[msg.sender] = totalSupply;
138         emit Transfer(address(0), msg.sender, totalSupply);
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Total supply
144     // ------------------------------------------------------------------------
145 /*    function totalSupply() public  view returns (uint) {
146         return _totalSupply.sub(balances[address(0)]);
147     }*/
148 
149     // ------------------------------------------------------------------------
150     // Get the token balance for account `tokenOwner`
151     // ------------------------------------------------------------------------
152     function balanceOfBank(address tokenOwner) public  view returns (uint balance) {
153         return bank_balances[tokenOwner];
154     }
155 
156     function balanceOfReg(address tokenOwner) public  view returns (uint balance) {
157         return activeBalances[tokenOwner];
158     }
159 
160     // ------------------------------------------------------------------------
161     // Get the token balance for account `tokenOwner`
162     // ------------------------------------------------------------------------
163     function balanceOf(address tokenOwner) public  view returns (uint balance) {
164         return balances[tokenOwner];
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ------------------------------------------------------------------------
172     function allowance(address tokenOwner, address spender) public   view returns (uint remaining) {
173         return allowed[tokenOwner][spender];
174     }
175 
176 
177 	// ------------------------------------------------------------------------
178 	// Issue a new amount of tokens
179 	// these tokens are deposited into the owner address
180 	// @param _amount Number of tokens to be issued
181 	// ------------------------------------------------------------------------
182 	function issue(uint amount) public onlyOwner {
183 		require(totalSupply + amount > totalSupply);
184 		require(balances[owner] + amount > balances[owner]);
185 
186 		balances[owner] += amount;
187 		totalSupply += amount;
188 		emit Issue(amount);
189 	}
190 	// ------------------------------------------------------------------------
191 	// Redeem tokens.
192 	// These tokens are withdrawn from the owner address
193 	// if the balance must be enough to cover the redeem
194 	// or the call will fail.
195 	// @param _amount Number of tokens to be issued
196 	// ------------------------------------------------------------------------
197 	function redeem(uint amount) public onlyOwner {
198 		require(totalSupply >= amount);
199 		require(balances[owner] >= amount);
200 
201 		totalSupply -= amount;
202 		balances[owner] -= amount;
203 		emit Redeem(amount);
204 	}
205 
206     // ------------------------------------------------------------------------
207     // Transfer the balance from token owner's account to `to` account
208     // - Owner's account must have sufficient balance to transfer
209     // - 0 value transfers are allowed
210     // ------------------------------------------------------------------------
211     function transfer(address to, uint tokens) public  validLock permissionCheck onlyPayloadSize(2 * 32) returns (bool success) {
212         require(to != address(0));
213         require(balances[msg.sender] >= tokens && tokens > 0);
214         require(balances[to] + tokens >= balances[to]);
215 
216         balances[msg.sender] = balances[msg.sender].sub(tokens);
217         balances[to] = balances[to].add(tokens);
218         emit Transfer(msg.sender, to, tokens);
219         return true;
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Token owner can approve for `spender` to transferFrom(...) `tokens`
225     // from the token owner's account
226     //
227     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
228     // recommends that there are no checks for the approval double-spend attack
229     // as this should be implemented in user interfaces
230     // ------------------------------------------------------------------------
231     function approve(address spender, uint tokens) public returns (bool success) {
232         allowed[msg.sender][spender] = tokens;
233         emit Approval(msg.sender, spender, tokens);
234         return true;
235     }
236 
237     // ------------------------------------------------------------------------
238     // Transfer `tokens` from the `from` account to the `to` account
239     //
240     // The calling account must already have sufficient tokens approve(...)-d
241     // for spending from the `from` account and
242     // - From account must have sufficient balance to transfer
243     // - Spender must have sufficient allowance to transfer
244     // - 0 value transfers are allowed
245     // ------------------------------------------------------------------------
246     function transferFrom(address from, address to, uint tokens) public  validLock permissionCheck onlyPayloadSize(3 * 32) returns (bool success) {
247         require(to != address(0));
248 
249         require(balances[from] >= tokens && tokens > 0);
250         require(balances[to] + tokens >= balances[to]);
251 
252 
253         balances[from] = balances[from].sub(tokens);
254         if(allowed[from][msg.sender] > 0)
255         {
256             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
257         }
258         balances[to] = balances[to].add(tokens);
259         emit Transfer(from, to, tokens);
260         return true;
261     }
262 
263 
264         // ------------------------------------------------------------------------
265     // Transfer `tokens` from the `from` account to the `to` account
266     //
267     // The calling account must already have sufficient tokens approve(...)-d
268     // for spending from the `from` account and
269     // - From account must have sufficient balance to transfer
270     // - Spender must have sufficient allowance to transfer
271     // - 0 value transfers are allowed
272     // ------------------------------------------------------------------------
273     function transferStore(address from, address to, uint tokens) public  validLock permissionCheck onlyPayloadSize(3 * 32) returns (bool success) {
274         require(to != address(0));
275 
276         require(balances[from] >= tokens && tokens > 0);
277         require(balances[to] + tokens >= balances[to]);
278 
279 
280         balances[from] = balances[from].sub(tokens);
281         if(allowed[from][msg.sender] > 0)
282         {
283             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
284         }
285         balances[to] = balances[to].add(tokens);
286 
287 
288         bank_balances[from] = bank_balances[from].add(tokens);
289 
290 
291         emit Transfer(from, to, tokens);
292         return true;
293     }
294 
295 
296     // ------------------------------------------------------------------------
297     // Owner can transfer out any accidentally sent ERC20 tokens
298     // ------------------------------------------------------------------------
299     function transferAnyERC20Token(address tokenAddress, uint tokens) public  onlyOwner {
300         // return ERC20Interface(tokenAddress).transfer(owner, tokens);
301         address(uint160(tokenAddress)).transfer(tokens);
302         emit Sent(owner,tokenAddress,tokens);
303     }
304 
305     // ------------------------------------------------------------------------
306     //  ERC20 withdraw
307     // -----------------------------------------
308     function withdraw() onlyOwner public {
309         msg.sender.transfer(address(this).balance);
310         _amount = 0;
311     }
312 
313     function showAmount() onlyOwner public view returns (uint) {
314         return _amount;
315     }
316 
317     function showBalance() onlyOwner public view returns (uint) {
318         return owner.balance;
319     }
320 
321     // ------------------------------------------------------------------------
322     //  ERC20 set rate
323     // -----------------------------------------
324     function set_rate(uint _vlue) public onlyOwner{
325         require(_vlue > 0);
326         _rate = _vlue;
327     }
328 
329     // ------------------------------------------------------------------------
330     //  ERC20 tokens
331     // -----------------------------------------
332     receive() external  payable{
333         /* require(balances[owner] >= msg.value && msg.value > 0);
334         balances[msg.sender] = balances[msg.sender].add(msg.value * _rate);
335 		balances[owner] = balances[owner].sub(msg.value * _rate); */
336         _amount=_amount.add(msg.value);
337         activeBalances[msg.sender] = activeBalances[msg.sender].add(msg.value);
338     }
339 
340     // ------------------------------------------------------------------------
341     //  ERC20 recharge
342     // -----------------------------------------
343     function recharge() public payable{
344         _amount=_amount.add(msg.value);
345         activeBalances[msg.sender] = activeBalances[msg.sender].add(msg.value);
346     }
347 
348 }