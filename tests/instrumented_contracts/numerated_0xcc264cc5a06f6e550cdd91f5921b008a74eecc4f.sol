1 pragma solidity ^0.5.0;
2 
3 interface tokenRecipient
4 {
5     function receiveApproval (address wallet, uint256 amount, address sender, bytes calldata extra) external;
6 }
7 
8 library safemath
9 {
10 	function mul (uint256 _a, uint256 _b) internal pure returns (uint256)
11 	{
12 		if (_a == 0) return 0;
13 
14 		uint256 c = _a * _b;
15 		require (c / _a == _b);
16 
17 		return c;
18 	}
19 
20 	function div (uint256 _a, uint256 _b) internal pure returns (uint256)
21 	{
22 		require (_b > 0);
23 		uint256 c = _a / _b;
24 
25 		return c;
26 	}
27 
28 	function sub (uint256 _a, uint256 _b) internal pure returns (uint256)
29 	{
30 		require (_b <= _a);
31 		uint256 c = _a - _b;
32 
33 		return c;
34 	}
35 
36 	function add (uint256 _a, uint256 _b) internal pure returns (uint256)
37 	{
38 		uint256 c = _a + _b;
39 		require (c >= _a);
40 
41 		return c;
42 	}
43 }
44 
45 contract upishki
46 {
47 	using	safemath for uint;
48 
49 	string	public name = "upishki";
50 	string	public symbol = "ups";
51 	uint8	public decimals = 0;
52 
53 	address	public owner = address (0);
54 
55 	uint256	public totalAllowed = 24000000;
56 	uint256	public totalSupply = 0;
57 
58 	bool	public transferAllowed = true;
59 
60 	uint256	public price = 2691000000000000;
61 
62 	mapping (address => holder_t) public holder;
63 	address	[] public holders;
64 
65 	bool	private locker = false;
66 
67 	modifier locked {require (locker == false); locker = true; _; locker = false;}
68 	modifier owners {require (msg.sender == owner); _;}
69 
70 	event	Transfer (address indexed From, address indexed To, uint256 Tokens);
71 	event	Approval (address indexed ownerWallet, address indexed spenderWallet, uint256 amount);
72     event	Burn (address indexed Wallet, uint256 Amount);
73 
74     event   HolderLocked (address Wallet, string Reason);
75     event   HolderUnlocked (address Wallet, string Reason);
76 
77     event   TransferAllowed (string Reason);
78     event   TransferDisallowed (string Reason);
79 
80     event   AllowedTokensValueChanged (uint256 AllowedTokensCount, string Reason);
81 
82     event   PriceChanged (uint256 NewPrice, string Reason);
83 
84     event   ContractOwnerChanged (address NewOwner);
85 
86 	constructor () public
87 	{
88 		owner = msg.sender;
89 
90 		holders.push (msg.sender);
91 		holder [msg.sender] = holder_t (msg.sender, 0, 0, true);
92 	}
93 
94 	function holdersCount () public view returns (uint256 Count)
95 	{
96 		return holders.length;
97 	}
98 
99 	function balanceOf (address wallet) public view returns (uint256 Balance)
100 	{
101 		return holder [wallet].tokens;
102 	}
103 
104 	function isHolderExists (address wallet) public view returns (bool Exists)
105 	{
106 		if (holder [wallet].wallet != address (0)) return true;
107 
108 		return false;
109 	}
110 
111 	function isHolderLocked (address wallet) public view returns (bool IsLocked)
112 	{
113 		return holder [wallet].active;
114 	}
115 
116 	function setHolderLockedState (address wallet, bool locking, string memory reason) public owners locked
117 	{
118 		if (holder [wallet].wallet != address (0) && holder [wallet].active != locking)
119 		{
120 			holder [wallet].active = locking;
121 
122 			if (locking == true) emit HolderLocked (wallet, reason);
123 			else emit HolderUnlocked (wallet, reason);
124 		}
125 	}
126 
127 	function setTransferAllowedState (bool allowed, string memory reason) public owners locked
128 	{
129 		if (transferAllowed != allowed)
130 		{
131 			transferAllowed = allowed;
132 
133 			if (allowed == true) emit TransferAllowed (reason);
134 			else emit TransferDisallowed (reason);
135 		}
136 	}
137 
138 	function setPrice (uint256 new_price, string memory reason) public owners locked
139 	{
140 		if (new_price > 0 && new_price != price)
141 		{
142 			price = new_price;
143 
144 			emit PriceChanged (new_price, reason);
145 		}
146 	}
147 
148     function transfer (address recipient, uint256 amount) public returns (bool Success)
149     {
150         return _transfer (msg.sender, recipient, amount);
151     }
152 
153     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool Success)
154     {
155 	    if (holder [msg.sender].wallet == msg.sender && holder [sender].allowed [msg.sender] >= amount)
156 	    {
157 		    holder [sender].allowed [msg.sender] = holder [sender].allowed [msg.sender].sub (amount);
158 
159 		    return _transfer (sender, recipient, amount);
160 	    }
161 
162 	    return false;
163     }
164 
165     function approve (address spender, uint256 amount) public returns (bool Success)
166     {
167         return _approve (spender, amount);
168     }
169 
170     function approveAndCall (address spender, uint256 amount, bytes memory extra) public returns (bool Success)
171     {
172         tokenRecipient recipient = tokenRecipient (spender);
173 
174         if (_approve (spender, amount) == true)
175         {
176             recipient.receiveApproval (msg.sender, amount, address (this), extra);
177 
178             return true;
179         }
180 
181         return false;
182     }
183 
184     function burn (address wallet, uint256 value) public owners locked returns (bool success)
185     {
186         if (holder [wallet].wallet == wallet && holder [wallet].tokens >= value)
187         {
188             holder [wallet].tokens = holder [wallet].tokens.sub (value);
189             totalSupply = totalSupply.sub (value);
190 
191             emit Burn (msg.sender, value);
192 
193             return true;
194         }
195 
196         return false;
197     }
198 
199     function burnFrom (address wallet, uint256 amount) public locked returns (bool Success)
200     {
201         if (holder [wallet].wallet == wallet && holder [wallet].tokens >= amount && holder [wallet].allowed [msg.sender] >= amount)
202         {
203 		    holder [wallet].tokens = holder [wallet].tokens.sub (amount);
204 
205 		    holder [wallet].allowed [msg.sender] = holder [wallet].allowed [msg.sender].sub (amount);
206 
207 		    totalSupply = totalSupply.sub (amount);
208 		    totalAllowed = totalAllowed.add (amount);
209 
210 		    emit Burn (wallet, amount);
211 
212 		    return true;
213         }
214 
215         return false;
216     }
217 
218 	function () external payable locked
219 	{
220 		_sale (msg.sender, msg.value);
221 	}
222 
223 	/*	**************************************************************	*/
224 	/*																	*/
225 	/*		INTERNAL METHODS											*/
226 	/*																	*/
227 	/*	**************************************************************	*/
228 
229 	function _sale (address target, uint256 value) internal returns (bool success, uint256 count, uint256 cost)
230 	{
231 		require (value >= price);
232 
233 		if (holder [target].wallet == address (0))
234 		{
235 			holders.push (target);
236 			holder [target] = holder_t (target, 0, 0, true);
237 		}
238 
239 		require (holder [target].active == true);
240 
241 		uint256 tokens = value.div (price);
242 
243 		if (tokens > totalAllowed) tokens = totalAllowed;
244 
245 		uint256 calc_price = tokens.mul (price);
246 
247 		totalAllowed = totalAllowed.sub (tokens);
248 		totalSupply = totalSupply.add (tokens);
249 
250 		holder [target].tokens = holder [target].tokens.add (tokens);
251 
252 		if (value > calc_price) address (uint160 (target)).transfer (value.sub (calc_price));
253 		if (address (this).balance > 0) address (uint160 (owner)).transfer (address (this).balance);
254 
255 		emit Transfer (address (this), target, tokens);
256 
257 		return (true, tokens, calc_price);
258 	}
259 
260     function _approve (address spender, uint256 amount) internal returns (bool Success)
261     {
262         if (holder [msg.sender].wallet != address (0))
263         {
264             holder [msg.sender].allowed [spender] = amount;
265 
266             emit Approval (msg.sender, spender, amount);
267 
268             return true;
269         }
270 
271         return false;
272     }
273 
274 	function _transfer (address from, address to, uint value) internal returns (bool Success)
275 	{
276         require (transferAllowed == true && to != address (0x0) && holder [from].wallet != address (0) && ((from != address (this) && holder [from].tokens >= value) || (from == address (this) && totalAllowed >= value)));
277 
278         if (holder [to].wallet == address (0))
279         {
280 	        holder [to] = holder_t (to, 0, 0, true);
281 			holders.push (to);
282         }
283 
284 		require (holder [from].active == true && holder [to].active == true);
285 
286         holder [to].tokens = holder [to].tokens.add (value);
287 
288 		if (from != address (this)) holder [from].tokens = holder [from].tokens.sub (value);
289 		else
290 		{
291 			totalAllowed = totalAllowed.sub (value);
292 			totalSupply = totalSupply.add (value);
293 		}
294 
295         emit Transfer (from, to, value);
296 
297         return true;
298     }
299 
300 	function _contract (address contract_address) internal view returns (bool)
301 	{
302 		uint codeLength;
303 
304 		if (contract_address == address (0)) return false;
305 
306 		assembly {codeLength := extcodesize (contract_address)}
307 
308 		if (codeLength > 0) return true;
309 		else return false;
310 	}
311 
312 	struct holder_t
313 	{
314 		address	wallet;
315 		uint256	tokens;
316 		uint256 locked;
317 		bool	active;
318 		mapping (address => uint256) allowed;
319 	}
320 }