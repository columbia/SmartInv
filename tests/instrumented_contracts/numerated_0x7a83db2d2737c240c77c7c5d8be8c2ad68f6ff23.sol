1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // The Useless Reserve Bank Token Contract
5 //
6 // - If you need welfare support, claim your free URB token entitlements from
7 //   the gubberment.
8 //
9 //   Call the default function `()` to claim 1,000 URBs by sending a 0 value
10 //   transaction to this contract address.
11 //
12 //   NOTE that any ethers sent with this call will fill the coffers of this
13 //   gubberment's token contract.
14 //
15 // - If you consider yourself to be in the top 1%, make a donation for world
16 //   peace.
17 //
18 //   Call `philanthropise({message})` and 100,000 URBs will be sent to
19 //   your account for each ether you donate. Fractions of ethers are always
20 //   accepted.
21 //
22 //   Your message and donation amount will be etched into the blockchain
23 //   forever, to recognise your generousity. Thank you.
24 //
25 //   As you are making this world a better place, your philanthropic donation
26 //   is eligible for a special discounted 20% tax rate. Your taxes will be
27 //   shared equally among the current gubberment treasury officials.
28 //   Thank you.
29 //
30 // - If you have fallen into hard times and have accumulated some URB tokens,
31 //   you can convert your URBs into ethers.
32 //
33 //   Liquidate your URBs by calling `liquidate(amountOfTokens)`, where
34 //   1 URB is specified as 1,000,000,000,000,000,000 (18 decimal places).
35 //   You will receive 1 ether for each 30,000 URBs you liquidate.
36 //
37 //   NOTE that this treasury contract can only dish out ethers in exchange
38 //   for URB tokens **IF** there are sufficient ethers in this contract.
39 //   Only 25% of the ether balance of this contract can be claimed at any
40 //   one time.
41 //
42 // - Any gifts of ERC20 tokens send to this contract will be solemnly accepted
43 //   by the gubberment. The treasury will at it's discretion disburst these 
44 //   gifts to friendly officials. Thank you.
45 //
46 // Token Contract:
47 // - Symbol: URB
48 // - Name: Useless Reserve Bank
49 // - Decimals: 18
50 // - Contract address; 0x7a83db2d2737c240c77c7c5d8be8c2ad68f6ff23
51 // - Block: 4,000,000
52 //
53 // Usage:
54 // - Watch this contract at address:
55 //     0x7A83dB2d2737C240C77C7C5D8be8c2aD68f6FF23
56 //   with the application binary interface published at:
57 //     https://etherscan.io/address/0x7a83db2d2737c240c77c7c5d8be8c2ad68f6ff23#code
58 //   to execute this token contract functions in Ethereum Wallet / Mist or
59 //   MyEtherWallet.
60 //
61 // User Functions:
62 // - default send function ()
63 //   Users can send 0 or more ethers to this contract address and receive back
64 //   1000 URBs
65 //
66 // - philanthropise(name)
67 //   Rich users can send a non-zero ether amount, calling this function with
68 //   a name or dedication message. 100,000 URBs will be minted for each
69 //   1 ETH sent. Fractions of an ether can be sent.
70 //   Remember that your goodwill karma is related to the size of your donation.
71 //
72 // - liquidate(amountOfTokens)
73 //   URB token holders can liquidate part or all of their tokens and receive
74 //   back 1 ether for every 30,000 URBs liquidated, ONLY if the ethers to be
75 //   received is less than 25% of the outstanding ETH balance of this contract
76 //
77 // - bribe()
78 //   Send ethers directly to the gubberment treasury officials. Your ethers
79 //   will be distributed equally among the current treasury offcials.
80 //
81 // Info Functions:
82 // - currentEtherBalance()
83 //   Returns the current ether balance of this contract.
84 //
85 // - currentTokenBalance()
86 //   Returns the total supply of URB tokens, where 1 URB is represented as
87 //   1,000,000,000,000,000,000 (18 decimal places).
88 //
89 // - numberOfTreasuryOfficials()
90 //   Returns the number of officials on the payroll of the gubberment
91 //   treasury.
92 //
93 // Gubberment Functions:
94 // - pilfer(amount)
95 //   Gubberment officials can pilfer any ethers in this contract when necessary.
96 //
97 // - acceptGiftTokens(tokenAddress)
98 //   The gubberment can accept any ERC20-compliant gift tokens send to this
99 //   contract.
100 //
101 // - replaceOfficials([accounts])
102 //   The gubberment can sack and replace all it's treasury officials in one go.
103 //
104 // Standard ERC20 Functions:
105 // - balanceOf(account)
106 // - totalSupply
107 // - transfer(to, amount)
108 // - approve(spender, amount)
109 // - transferFrom(owner, spender, amount)
110 //
111 // Yes, I made it into block 4,000,000 .
112 //
113 // Remember to make love and peace, not war!
114 //
115 // (c) The Gubberment 2017. The MIT Licence.
116 // ----------------------------------------------------------------------------
117 
118 contract Gubberment {
119     address public gubberment;
120     address public newGubberment;
121     event GubbermentOverthrown(address indexed _from, address indexed _to);
122 
123     function Gubberment() {
124         gubberment = msg.sender;
125     }
126 
127     modifier onlyGubberment {
128         if (msg.sender != gubberment) throw;
129         _;
130     }
131 
132     function coupDetat(address _newGubberment) onlyGubberment {
133         newGubberment = _newGubberment;
134     }
135  
136     function gubbermentOverthrown() {
137         if (msg.sender == newGubberment) {
138             GubbermentOverthrown(gubberment, newGubberment);
139             gubberment = newGubberment;
140         }
141     }
142 }
143 
144 
145 // ERC Token Standard #20 - https://github.com/ethereum/EIPs/issues/20
146 contract ERC20Token {
147     // ------------------------------------------------------------------------
148     // Balances for each account
149     // ------------------------------------------------------------------------
150     mapping(address => uint) balances;
151 
152     // ------------------------------------------------------------------------
153     // Owner of account approves the transfer of an amount to another account
154     // ------------------------------------------------------------------------
155     mapping(address => mapping (address => uint)) allowed;
156 
157     // ------------------------------------------------------------------------
158     // Total token supply
159     // ------------------------------------------------------------------------
160     uint public totalSupply;
161 
162     // ------------------------------------------------------------------------
163     // Get the account balance of another account with address _owner
164     // ------------------------------------------------------------------------
165     function balanceOf(address _owner) constant returns (uint balance) {
166         return balances[_owner];
167     }
168 
169     // ------------------------------------------------------------------------
170     // Transfer the balance from owner's account to another account
171     // ------------------------------------------------------------------------
172     function transfer(address _to, uint _amount) returns (bool success) {
173         if (balances[msg.sender] >= _amount
174             && _amount > 0
175             && balances[_to] + _amount > balances[_to]) {
176             balances[msg.sender] -= _amount;
177             balances[_to] += _amount;
178             Transfer(msg.sender, _to, _amount);
179             return true;
180         } else {
181             return false;
182         }
183     }
184 
185     // ------------------------------------------------------------------------
186     // Allow _spender to withdraw from your account, multiple times, up to the
187     // _value amount. If this function is called again it overwrites the
188     // current allowance with _value.
189     // ------------------------------------------------------------------------
190     function approve(
191         address _spender,
192         uint _amount
193     ) returns (bool success) {
194         allowed[msg.sender][_spender] = _amount;
195         Approval(msg.sender, _spender, _amount);
196         return true;
197     }
198 
199     // ------------------------------------------------------------------------
200     // Spender of tokens transfer an amount of tokens from the token owner's
201     // balance to the spender's account. The owner of the tokens must already
202     // have approve(...)-d this transfer
203     // ------------------------------------------------------------------------
204     function transferFrom(
205         address _from,
206         address _to,
207         uint _amount
208     ) returns (bool success) {
209         if (balances[_from] >= _amount
210             && allowed[_from][msg.sender] >= _amount
211             && _amount > 0
212             && balances[_to] + _amount > balances[_to]) {
213             balances[_from] -= _amount;
214             allowed[_from][msg.sender] -= _amount;
215             balances[_to] += _amount;
216             Transfer(_from, _to, _amount);
217             return true;
218         } else {
219             return false;
220         }
221     }
222 
223     // ------------------------------------------------------------------------
224     // Returns the amount of tokens approved by the owner that can be
225     // transferred to the spender's account
226     // ------------------------------------------------------------------------
227     function allowance(
228         address _owner, 
229         address _spender
230     ) constant returns (uint remaining) {
231         return allowed[_owner][_spender];
232     }
233 
234     event Transfer(address indexed _from, address indexed _to, uint _value);
235     event Approval(address indexed _owner, address indexed _spender,
236         uint _value);
237 }
238 
239 
240 contract UselessReserveBank is ERC20Token, Gubberment {
241 
242     // ------------------------------------------------------------------------
243     // Token information
244     // ------------------------------------------------------------------------
245     string public constant symbol = "URB";
246     string public constant name = "Useless Reserve Bank";
247     uint8 public constant decimals = 18;
248     
249     uint public constant WELFARE_HANDOUT = 1000;
250     uint public constant ONEPERCENT_TOKENS_PER_ETH = 100000;
251     uint public constant LIQUIDATION_TOKENS_PER_ETH = 30000;
252 
253     address[] public treasuryOfficials;
254     uint public constant TAXRATE = 20;
255     uint public constant LIQUIDATION_RESERVE_RATIO = 75;
256 
257     uint public totalTaxed;
258     uint public totalBribery;
259     uint public totalPilfered;
260 
261     uint public constant SENDING_BLOCK = 3999998; 
262 
263     function UselessReserveBank() {
264         treasuryOfficials.push(0xDe18789c4d65DC8ecE671A4145F32F1590c4D802);
265         treasuryOfficials.push(0x8899822D031891371afC369767511164Ef21e55c);
266     }
267 
268     // ------------------------------------------------------------------------
269     // Just give the welfare handouts
270     // ------------------------------------------------------------------------
271     function () payable {
272         uint tokens = WELFARE_HANDOUT * 1 ether;
273         totalSupply += tokens;
274         balances[msg.sender] += tokens;
275         WelfareHandout(msg.sender, tokens, totalSupply, msg.value, 
276             this.balance);
277         Transfer(0x0, msg.sender, tokens);
278     }
279     event WelfareHandout(address indexed recipient, uint tokens, 
280         uint newTotalSupply, uint ethers, uint newEtherBalance);
281 
282 
283     // ------------------------------------------------------------------------
284     // If you consider yourself rich, donate for world peace
285     // ------------------------------------------------------------------------
286     function philanthropise(string name) payable {
287         // Sending something real?
288         require(msg.value > 0);
289 
290         // Calculate the number of tokens
291         uint tokens = msg.value * ONEPERCENT_TOKENS_PER_ETH;
292 
293         // Assign tokens to account and inflate total supply
294         balances[msg.sender] += tokens;
295         totalSupply += tokens;
296 
297         // Calculate and forward taxes to the treasury
298         uint taxAmount = msg.value * TAXRATE / 100;
299         if (taxAmount > 0) {
300             totalTaxed += taxAmount;
301             uint taxPerOfficial = taxAmount / treasuryOfficials.length;
302             for (uint i = 0; i < treasuryOfficials.length; i++) {
303                 treasuryOfficials[i].transfer(taxPerOfficial);
304             }
305         }
306 
307         Philanthropy(msg.sender, name, tokens, totalSupply, msg.value, 
308             this.balance, totalTaxed);
309         Transfer(0x0, msg.sender, tokens);
310     }
311     event Philanthropy(address indexed buyer, string name, uint tokens, 
312         uint newTotalSupply, uint ethers, uint newEtherBalance,
313         uint totalTaxed);
314 
315 
316     // ------------------------------------------------------------------------
317     // Liquidate your tokens for ETH, if this contract has sufficient ETH
318     // ------------------------------------------------------------------------
319     function liquidate(uint amountOfTokens) {
320         // Account must have sufficient tokens
321         require(amountOfTokens <= balances[msg.sender]);
322 
323         // Burn tokens
324         balances[msg.sender] -= amountOfTokens;
325         totalSupply -= amountOfTokens;
326 
327         // Calculate ETH to exchange
328         uint ethersToSend = amountOfTokens / LIQUIDATION_TOKENS_PER_ETH;
329 
330         // Is there sufficient ETH to support this liquidation?
331         require(ethersToSend > 0 && 
332             ethersToSend <= (this.balance * (100 - LIQUIDATION_RESERVE_RATIO) / 100));
333 
334         // Log message
335         Liquidate(msg.sender, amountOfTokens, totalSupply, 
336             ethersToSend, this.balance - ethersToSend);
337         Transfer(msg.sender, 0x0, amountOfTokens);
338 
339         // Send ETH
340         msg.sender.transfer(ethersToSend);
341     }
342     event Liquidate(address indexed seller, 
343         uint tokens, uint newTotalSupply, 
344         uint ethers, uint newEtherBalance);
345 
346 
347     // ------------------------------------------------------------------------
348     // Gubberment officials will accept 100% of bribes
349     // ------------------------------------------------------------------------
350     function bribe() payable {
351         // Briber must be offering something real
352         require(msg.value > 0);
353 
354         // Do we really need to keep track of the total bribes?
355         totalBribery += msg.value;
356         Bribed(msg.value, totalBribery);
357 
358         uint bribePerOfficial = msg.value / treasuryOfficials.length;
359         for (uint i = 0; i < treasuryOfficials.length; i++) {
360             treasuryOfficials[i].transfer(bribePerOfficial);
361         }
362     }
363     event Bribed(uint amount, uint newTotalBribery);
364 
365 
366     // ------------------------------------------------------------------------
367     // Gubberment officials can pilfer out of necessity
368     // ------------------------------------------------------------------------
369     function pilfer(uint amount) onlyGubberment {
370         // Cannot pilfer more than the contract balance
371         require(amount > this.balance);
372 
373         // Do we really need to keep track of the total pilfered amounts?
374         totalPilfered += amount;
375         Pilfered(amount, totalPilfered, this.balance - amount);
376 
377         uint amountPerOfficial = amount / treasuryOfficials.length;
378         for (uint i = 0; i < treasuryOfficials.length; i++) {
379             treasuryOfficials[i].transfer(amountPerOfficial);
380         }
381     }
382     event Pilfered(uint amount, uint totalPilfered, 
383         uint newEtherBalance);
384 
385 
386     // ------------------------------------------------------------------------
387     // Accept any ERC20 gifts
388     // ------------------------------------------------------------------------
389     function acceptGiftTokens(address tokenAddress) 
390       onlyGubberment returns (bool success) 
391     {
392         ERC20Token token = ERC20Token(tokenAddress);
393         uint amount = token.balanceOf(this);
394         return token.transfer(gubberment, amount);
395     }
396 
397 
398     // ------------------------------------------------------------------------
399     // Change gubberment officials
400     // ------------------------------------------------------------------------
401     function replaceOfficials(address[] newOfficials) onlyGubberment {
402         treasuryOfficials = newOfficials;
403     }
404 
405 
406     // ------------------------------------------------------------------------
407     // Information function
408     // ------------------------------------------------------------------------
409     function currentEtherBalance() constant returns (uint) {
410         return this.balance;
411     }
412 
413     function currentTokenBalance() constant returns (uint) {
414         return totalSupply;
415     }
416 
417     function numberOfTreasuryOfficials() constant returns (uint) {
418         return treasuryOfficials.length;
419     }
420 }