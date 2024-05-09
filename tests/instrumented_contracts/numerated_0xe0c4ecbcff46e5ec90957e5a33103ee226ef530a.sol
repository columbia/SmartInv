1 // SPDX-License-Identifier: MIT
2 
3 /**
4 @title iSpy Token
5 @author Masterchef@etherchef.org
6 @contents ERC-20 standard with modifications made to introduce new token standard
7 
8 @Foreward 
9 Bobs work in the space is nothing short of exceptional, so when he decided to take the 
10 plunge into this with $INEDIBLE we couldn't help but throw our hat into the ring with some flavor. 
11 Some issues we set out to solve:
12 
13 1. MEV is an issue in Crypto today. Blocking them is an option however that cuts valuable volume. 
14 Charging a nominal tax that can be used for few purposes works a little more win-win.
15 Picture a situation where a sandwich trader pays a fee for protocol development or that can be 
16 utilized to redistribute to the holders. 
17 
18 2. Long term tokenomic sustainability. Majority of the ERC-20 standards today are fixed supply. 
19 There is little innovation taking place in exploring the depths of the ERC-20 standard. 
20 Project Teams and Holders therefore are subject to tokens that are unable to sustain themselves. 
21 Some charge a tax for development and marketing however that is visibly a short term effort. 
22 Buybacks and Burns do little other than provide temporary relief as the rise in price is likely
23 going to be sold into eventually by other holders. Burning by itself is rudimentary if sent to 
24 the dead wallet because it does nothing to impact the marketcap or total supply. 
25 
26 3. Holders are disincentivized to remain invested. The above factors in addition to new concepts
27 launching on a daily basis make it difficult for the holder to remain invested for more than few days 
28 or even few hours let alone weeks. There is little happening from a protocol perspective to keep
29 holders engaged and or interested other than the hope of monetary gain. 
30 
31 With these in mind, we developed iSpy. 
32 
33 An ERC-20 token with hyper-deflationary characteristics that burns 0.5% on each transaction. 
34 This burn gets wiped off the total supply providing a cushion and floor riser effect for the Token MC.
35 An additional 0.5% is charged on each transaction, bringing the total to 1% Tax. This 0.5% is sent
36 directly to a Rewards contract where holders can claim their share proportionate to their holdings. 
37 
38 Thereby causing increased hyper-deflation by not restricting MEVs as long as their simulation returns a profit,
39 further hyper-deflation on any other transaction inclusive of buys, sells, transfers, reward claims, etc.
40 Holders are incentivized to remain engaged as they continually claim rewards.
41 Price padding for holders is achieved via the total supply reduction on the burns, and rewards claimed from the fees.
42 
43 What about the Project Teams? Uniswap V2 does not allow for claiming fees on locked tokens. V3 by itself is restrictive
44 and does not support rebase-fee tokens. Therefore the need for a custom liquidity locker where the Project Team can
45 retrieve 1% of the fees every 24 hours as an incentive to continue project development. 
46 
47 Thereby achieving the perfect trifecta straight from the MasterChef kitchen!
48 
49 @suggestions
50 We request Project Teams to feel free to use these contracts, improvize on this and help improve the space because hyper-deflation is 
51 the fastest and quickest way to survive. Incentivizing your holders is easier when you give them a method to 
52 grow their holdings passively to tide over falling charts. We bet a majority of the underwater meme token holders 
53 would have benefited from similar tokenomics to help sustain their projects and ideas for longer. 
54 A bit more flair in your contracts will save you from a world of FUD.
55 
56 We also request holders and influencers to spread the word on the strategy employed here so that many more can 
57 benefit from some of these initiatives. If we want this space to evolve beyond a laugh then we have to improve 
58 on the tech and bring out the best of available standards. 
59 
60 @about
61 iSPY is an experimental project. The Team has reserved no allocation and will add 99% of the tokens to LP.
62 1% of the Tokens will be moved to the Rewards Contract for holders to immediately begin earning at the start. 
63 Claims are set to once every 60 minutes.
64 
65 The custom liquidity locker will contain the LP tokens locked for a period of 6 months. 
66 1% fees are redeemable by us every 24 hours. 
67 
68 As such this is a demonstration of what can be done in this space without promise of any monetary gains. 
69 Please trade the token with the same risks associated with any other token on chain within your appetite.
70 
71 If some widespread adoption is visible, we will see if a partnership with Inedible is possible on setting up 
72 something along the lines of an Anti-MEV DEX that auto-locks liquidity etc protecting the users in the way we 
73 have done for iSPY. Another option would be to enable automated solidity contract reviews and audits etc. 
74 
75 @Caveat
76 Etherchef.org is not responsible for the trading dynamics of this token nor is in charge of its development.
77 This remains a method to educate and spread awareness in addition to allowing for transformation. 
78 
79 @footnotes hyper-deflation with reduced supply and claimable tax redirected to holders
80 
81 @Contact If you have an exciting idea in DeFi and want to chat, reach masterchef@etherchef.org 
82 
83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
87 +++++++++++++++++++++++++++++++++++*****##############################++++++++++++++++++++
88 ++++++++++++++++++++++++++++++**#####################################+++++++++++++++++++++
89 ++++++++++++++++++++++++++**####*****+++++++++++++++####++++++++++###+++++++++++++++++++++
90 +++++++++++++++++++++++**###**+++++++++++++++++++++*####+++++++++*##++++++++++++++++++++++
91 +++++++++++++++++++++*###*+++++++++++++++++++++++++####+++++++++++++++++++++++++++++++++++
92 +++++++++++++++++++*###*++++++++++++++++++++++++++####*+++++++++++++++++++++++++++++++++++
93 +++++++++++++++++*###*+++++++++++++++++++++++++++*####++++++++++++++++++++++++++++++++++++
94 ++++++++++++++++*###*+++++++++++++++++++++++++++*####*########*+++++++++++++++++++++++++++
95 +++++++++++++++####*++++++++++++++++++++++++++*####*+++#######*+++++++++++++++++++++++++++
96 ++++++++++++++*####+++++++++++++++++++++++++*####*++++++#*****++++++++++++++++++++++++++++
97 ++++++++++++++####++++++++++**************####**++++++++*#*+++++++++++++++++++++++++++++++
98 ++++++++++++++####+++++++++*##############*+++++++++++++*##*++++++++++++++++++++++++++++++
99 ++++++++++++++####++++++++*********#########**++++++++++*###++++++++++++++++++++++++++++++
100 ++++++++++++++####*++++++++++++++++++++**#######*+++++++###*++++++++++++++**++++++++++++++
101 ==============*####+=====================++**######*+++###*==============+*##=============
102 ===============*###*+========================++*#########+===============*##*=============
103 ================+*##*+===========================+*#######*+===========+###+==============
104 ==================+*##**+======================+*###**#######**+++++**##*+================
105 =====================+*###***+++++++++++++***###**+====++*###########*+===================
106 =========================++*****######*****+++==============+***##*+======================
107 ==========================================================================================
108 ==========================================================================================
109 
110 
111 */
112 
113 pragma solidity ^0.8.0;
114 
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 pragma solidity ^0.8.0;
126 
127 interface IERC20 {
128 
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 
133     function totalSupply() external view returns (uint256);
134 
135     function balanceOf(address account) external view returns (uint256);
136 
137     function transfer(address to, uint256 amount) external returns (bool);
138 
139     function allowance(address owner, address spender) external view returns (uint256);
140 
141     function approve(address spender, uint256 amount) external returns (bool);
142 
143     function transferFrom(
144         address from,
145         address to,
146         uint256 amount
147     ) external returns (bool);
148 }
149 
150 
151 pragma solidity ^0.8.0;
152 
153 interface IERC20Metadata is IERC20 {
154     
155     function name() external view returns (string memory);
156 
157     function symbol() external view returns (string memory);
158 
159     function decimals() external view returns (uint8);
160 }
161 
162 
163 contract Ownable is Context {
164     address private _owner;
165  
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167  
168     constructor () {
169         address msgSender = _msgSender();
170         _owner = msgSender;
171         emit OwnershipTransferred(address(0), msgSender);
172     }
173  
174     function owner() public view returns (address) {
175         return _owner;
176     }
177 
178     modifier onlyOwner() {
179         require(_owner == _msgSender(), "Ownable: caller is not the owner");
180         _;
181     }
182  
183     function renounceOwnership() public virtual onlyOwner {
184         emit OwnershipTransferred(_owner, address(0));
185         _owner = address(0);
186     }
187  
188     function transferOwnership(address newOwner) public virtual onlyOwner {
189         require(newOwner != address(0), "Ownable: new owner is the zero address");
190         emit OwnershipTransferred(_owner, newOwner);
191         _owner = newOwner;
192     }
193     }
194 
195 pragma solidity ^0.8.0;
196 
197 contract iSPY is Context, IERC20, IERC20Metadata, Ownable {
198     mapping(address => uint256) private _balances;
199 
200     mapping(address => mapping(address => uint256)) private _allowances;
201     address private _feeRecipient;
202     uint256 private _totalSupply;
203 
204     string private _name;
205     string private _symbol;
206 
207     constructor (string memory name_, string memory symbol_, uint256 totalSupply_, address feeRecipient_) {
208         _name = name_;
209         _symbol = symbol_;
210         _totalSupply = totalSupply_;
211          _feeRecipient = feeRecipient_;
212         _balances[msg.sender] = totalSupply_;
213         emit Transfer(address(0), msg.sender, totalSupply_); // Optional
214     }
215 
216     function name() public view virtual override returns (string memory) {
217         return _name;
218     }
219 
220     function symbol() public view virtual override returns (string memory) {
221         return _symbol;
222     }
223 
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     function totalSupply() public view virtual override returns (uint256) {
229         return _totalSupply;
230     }
231 
232     function balanceOf(address account) public view virtual override returns (uint256) {
233     if (account == address(0)) {
234         return 0;
235     }
236     return _balances[account];
237     }
238 
239     function setFeeRecipient(address feeRecipient) public onlyOwner {
240     require(feeRecipient != address(0), "Fee recipient cannot be the zero address");
241     _feeRecipient = feeRecipient;
242     }
243 
244     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
245     address sender = _msgSender();
246     require(sender != address(0), "ERC20: transfer from the zero address");
247 
248     uint256 senderBalance = _balances[sender];
249     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
250 
251     uint256 fee = amount / 100; // calculate 1% fee
252     uint256 burnAmount = fee / 2; // calculate burn amount (half of fee)
253     uint256 transferAmount = amount - fee; // calculate transfer amount (original amount minus fee)
254     
255     if (_feeRecipient != address(0)) {
256         uint256 feeRecipientAmount = fee - burnAmount; // calculate the feeRecipient amount (other half of the fee)
257         
258         _balances[sender] -= amount; // subtract amount from sender's balance
259         _balances[recipient] += transferAmount; // add transfer amount to recipient
260         _balances[_feeRecipient] += feeRecipientAmount; // add the feeRecipient amount to feeRecipient's balance
261         _balances[address(0)] += burnAmount; // add burn amount to the 0 address
262         
263         emit Transfer(sender, recipient, transferAmount); // emit transfer event to recipient
264         emit Transfer(sender, _feeRecipient, feeRecipientAmount); // emit transfer event for feeRecipient amount
265         emit Transfer(sender, address(0), burnAmount); // emit transfer event to burn address
266         
267         if (burnAmount > 0) {
268             _totalSupply -= burnAmount; // update total supply by burning tokens
269         }
270     } else {
271         // if feeRecipient address is not set/invalid, burn the fee instead
272         _balances[sender] -= amount; // subtract amount from sender's balance
273         _balances[recipient] += transferAmount; // add transfer amount to recipient
274         _balances[address(0)] += fee; // add burn amount to the 0 address
275         
276         emit Transfer(sender, recipient, transferAmount); // emit transfer event to recipient
277         emit Transfer(sender, address(0), fee); // emit transfer event to burn address
278         
279         _totalSupply -= fee; // update total supply by burning tokens
280     }
281     
282     return true;
283     }
284 
285     function allowance(address owner, address spender) public view virtual override returns (uint256) {
286         return _allowances[owner][spender];
287     }
288 
289     function approve(address spender, uint256 amount) public virtual override returns (bool) {
290         address owner = _msgSender();
291         _approve(owner, spender, amount);
292         return true;
293     }
294 
295     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
296     require(amount <= _allowances[sender][_msgSender()], "ERC20: transfer amount exceeds allowance");
297 
298     _allowances[sender][_msgSender()] -= amount;
299 
300     uint256 senderBalance = _balances[sender];
301     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
302 
303     uint256 fee = amount / 100;
304     uint256 burnAmount = fee / 2;
305     uint256 transferAmount = amount - fee;
306 
307     if (_feeRecipient != address(0)) {
308         uint256 feeRecipientAmount = fee - burnAmount;
309 
310         _balances[sender] -= amount;
311         _balances[recipient] += transferAmount;
312         _balances[_feeRecipient] += feeRecipientAmount;
313         _balances[address(0)] += burnAmount;
314 
315         emit Transfer(sender, recipient, transferAmount);
316         emit Transfer(sender, _feeRecipient, feeRecipientAmount);
317         emit Transfer(sender, address(0), burnAmount);
318 
319         if (burnAmount > 0) {
320             _totalSupply -= burnAmount;
321         }
322     } else {
323         _balances[sender] -= amount;
324         _balances[recipient] += transferAmount;
325         _balances[address(0)] += fee;
326 
327         emit Transfer(sender, recipient, transferAmount);
328         emit Transfer(sender, address(0), fee);
329 
330         _totalSupply -= fee;
331     }
332 
333     return true;
334     }
335 
336     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
337         address owner = _msgSender();
338         _approve(owner, spender, allowance(owner, spender) + addedValue);
339         return true;
340     }
341 
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         address owner = _msgSender();
344         uint256 currentAllowance = allowance(owner, spender);
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         unchecked {
347             _approve(owner, spender, currentAllowance - subtractedValue);
348         }
349 
350         return true;
351     }
352 
353     function _transfer(address from, address to, uint256 amount) internal virtual {
354     require(from != address(0), "ERC20: transfer from the zero address");
355         
356     _beforeTokenTransfer(from, to, amount);
357         
358     uint256 fromBalance = _balances[from];
359     require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
360     unchecked {
361         _balances[from] = fromBalance - amount;
362     }
363         
364     uint256 fee = amount / 100; // calculate 1% fee
365     uint256 burnAmount = fee / 2; // calculate burn amount (half of fee)
366     uint256 transferAmount = amount - fee; // calculate transfer amount (original amount minus fee)
367     
368     if (_feeRecipient != address(0)) {
369         uint256 feeRecipientAmount = fee - burnAmount; // calculate the feeRecipient amount (other half of the fee)
370         _balances[_feeRecipient] += feeRecipientAmount; // add the feeRecipient amount to feeRecipient's balance
371         emit Transfer(from, _feeRecipient, feeRecipientAmount); // emit transfer event for feeRecipient amount
372         if (burnAmount > 0) {
373             _totalSupply -= burnAmount; // update total supply by burning tokens
374             _balances[address(0)] += burnAmount; // add burn amount to the 0 address
375             emit Transfer(from, address(0), burnAmount); // emit burn event
376         }
377     } else {
378         // if feeRecipient address is not set/invalid, burn the fee instead
379         _totalSupply -= fee; // update total supply by burning tokens
380         _balances[address(0)] += fee; // add burn amount to the 0 address
381         emit Transfer(from, address(0), fee); // emit burn event
382     }
383         
384     _balances[to] += transferAmount; // add transfer amount to recipient
385     emit Transfer(from, to, transferAmount); // emit transfer event
386         
387     _afterTokenTransfer(from, to, amount);
388     }
389 
390     function _approve(
391         address owner,
392         address spender,
393         uint256 amount
394     ) internal virtual {
395         require(owner != address(0), "ERC20: approve from the zero address");
396         require(spender != address(0), "ERC20: approve to the zero address");
397 
398         _allowances[owner][spender] = amount;
399         emit Approval(owner, spender, amount);
400     }
401 
402     function _spendAllowance(
403         address owner,
404         address spender,
405         uint256 amount
406     ) internal virtual {
407         uint256 currentAllowance = allowance(owner, spender);
408         if (currentAllowance != type(uint256).max) {
409             require(currentAllowance >= amount, "ERC20: insufficient allowance");
410             unchecked {
411                 _approve(owner, spender, currentAllowance - amount);
412             }
413         }
414     }
415 
416     function _beforeTokenTransfer(
417         address from,
418         address to,
419         uint256 amount
420     ) internal virtual {}
421 
422     function _afterTokenTransfer(
423         address from,
424         address to,
425         uint256 amount
426     ) internal virtual {}
427 }