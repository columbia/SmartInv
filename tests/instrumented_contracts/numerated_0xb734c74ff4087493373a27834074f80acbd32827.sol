1 pragma solidity ^0.4.6;
2 
3 contract StandardToken {
4 
5     /*
6      *  Data structures
7      */
8     mapping (address => uint256) balances;
9     mapping (address => mapping (address => uint256)) allowed;
10     uint256 public totalSupply;
11 
12     /*
13      *  Events
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 
18     /*
19      *  Read and write storage functions
20      */
21     /// @dev Transfers sender's tokens to a given address. Returns success.
22     /// @param _to Address of token receiver.
23     /// @param _value Number of tokens to transfer.
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         }
31         else {
32             return false;
33         }
34     }
35 
36     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
37     /// @param _from Address from where tokens are withdrawn.
38     /// @param _to Address to where tokens are sent.
39     /// @param _value Number of tokens to transfer.
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
42             balances[_to] += _value;
43             balances[_from] -= _value;
44             allowed[_from][msg.sender] -= _value;
45             Transfer(_from, _to, _value);
46             return true;
47         }
48         else {
49             return false;
50         }
51     }
52 
53     /// @dev Returns number of tokens owned by given address.
54     /// @param _owner Address of token owner.
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     /// @dev Sets approved amount of tokens for spender. Returns success.
60     /// @param _spender Address of allowed account.
61     /// @param _value Number of approved tokens.
62     function approve(address _spender, uint256 _value) returns (bool success) {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     /*
69      * Read storage functions
70      */
71     /// @dev Returns number of allowed tokens for given address.
72     /// @param _owner Address of token owner.
73     /// @param _spender Address of token spender.
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78 }
79 
80 
81 /// @title Token contract - Implements Standard Token Interface for TokenFund.
82 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
83 contract TokenFund is StandardToken {
84 
85     /*
86      * External contracts
87      */
88     address public emissionContractAddress = 0x0;
89 
90     /*
91      * Token meta data
92      */
93     string constant public name = "TheToken Fund";
94     string constant public symbol = "TKN";
95     uint8 constant public decimals = 8;
96 
97     /*
98      * Storage
99      */
100     address public owner = 0x0;
101     bool public emissionEnabled = true;
102     bool transfersEnabled = true;
103 
104     /*
105      * Modifiers
106      */
107 
108     modifier isCrowdfundingContract() {
109         // Only emission address is allowed to proceed.
110         if (msg.sender != emissionContractAddress) {
111             throw;
112         }
113         _;
114     }
115 
116     modifier onlyOwner() {
117         // Only owner is allowed to do this action.
118         if (msg.sender != owner) {
119             throw;
120         }
121         _;
122     }
123 
124     /*
125      * Contract functions
126      */
127 
128      /// @dev TokenFund emission function.
129     /// @param _for Address of receiver.
130     /// @param tokenCount Number of tokens to issue.
131     function issueTokens(address _for, uint tokenCount)
132         external
133         isCrowdfundingContract
134         returns (bool)
135     {
136         if (emissionEnabled == false) {
137             throw;
138         }
139 
140         balances[_for] += tokenCount;
141         totalSupply += tokenCount;
142         return true;
143     }
144 
145     /// @dev Withdraws tokens for msg.sender.
146     /// @param tokenCount Number of tokens to withdraw.
147     function withdrawTokens(uint tokenCount)
148         public
149         returns (bool)
150     {
151         uint balance = balances[msg.sender];
152         if (balance < tokenCount) {
153             return false;
154         }
155         balances[msg.sender] -= tokenCount;
156         totalSupply -= tokenCount;
157         return true;
158     }
159 
160     /// @dev Function to change address that is allowed to do emission.
161     /// @param newAddress Address of new emission contract.
162     function changeEmissionContractAddress(address newAddress)
163         external
164         onlyOwner
165         returns (bool)
166     {
167         emissionContractAddress = newAddress;
168     }
169 
170     /// @dev Function that enables/disables transfers of token.
171     /// @param value True/False
172     function enableTransfers(bool value)
173         external
174         onlyOwner
175     {
176         transfersEnabled = value;
177     }
178 
179     /// @dev Function that enables/disables token emission.
180     /// @param value True/False
181     function enableEmission(bool value)
182         external
183         onlyOwner
184     {
185         emissionEnabled = value;
186     }
187 
188     /*
189      * Overriding ERC20 standard token functions to support transfer lock
190      */
191     function transfer(address _to, uint256 _value)
192         returns (bool success)
193     {
194         if (transfersEnabled == true) {
195             return super.transfer(_to, _value);
196         }
197         return false;
198     }
199 
200     function transferFrom(address _from, address _to, uint256 _value)
201         returns (bool success)
202     {
203         if (transfersEnabled == true) {
204             return super.transferFrom(_from, _to, _value);
205         }
206         return false;
207     }
208 
209 
210     /// @dev Contract constructor function sets initial token balances.
211     /// @param _owner Address of the owner of TokenFund.
212     function TokenFund(address _owner)
213     {
214         totalSupply = 0;
215         owner = _owner;
216     }
217 
218     function transferOwnership(address newOwner) onlyOwner {
219         owner = newOwner;
220     }
221 }
222 
223 contract owned {
224     address public owner;
225 
226     function owned() {
227         owner = msg.sender;
228     }
229 
230     modifier onlyOwner {
231         if (msg.sender != owner) throw;
232         _;
233     }
234 
235     function transferOwnership(address newOwner) onlyOwner {
236         owner = newOwner;
237     }
238 }
239 
240 
241 contract Fund is owned {
242 
243 	/*
244      * External contracts
245      */
246     TokenFund public tokenFund;
247 
248 	/*
249      * Storage
250      */
251     address public ethAddress;
252     address public multisig;
253     address public supportAddress;
254     uint public tokenPrice = 1 finney; // 0.001 ETH
255 
256     mapping (address => address) public referrals;
257 
258     /*
259      * Contract functions
260      */
261 
262 	/// @dev Withdraws tokens for msg.sender.
263     /// @param tokenCount Number of tokens to withdraw.
264     function withdrawTokens(uint tokenCount)
265         public
266         returns (bool)
267     {
268         return tokenFund.withdrawTokens(tokenCount);
269     }
270 
271     function issueTokens(address _for, uint tokenCount)
272     	private
273     	returns (bool)
274     {
275     	if (tokenCount == 0) {
276         return false;
277       }
278 
279       var percent = tokenCount / 100;
280 
281       // 1% goes to the fund managers
282       if (!tokenFund.issueTokens(multisig, percent)) {
283         // Tokens could not be issued.
284         throw;
285       }
286 
287 		  // 1% goes to the support team
288       if (!tokenFund.issueTokens(supportAddress, percent)) {
289         // Tokens could not be issued.
290         throw;
291       }
292 
293       if (referrals[_for] != 0) {
294       	// 3% goes to the referral
295       	if (!tokenFund.issueTokens(referrals[_for], 3 * percent)) {
296           // Tokens could not be issued.
297           throw;
298         }
299       } else {
300       	// if there is no referral, 3% goes to the fund managers
301       	if (!tokenFund.issueTokens(multisig, 3 * percent)) {
302           // Tokens could not be issued.
303           throw;
304         }
305       }
306 
307       if (!tokenFund.issueTokens(_for, tokenCount - 5 * percent)) {
308         // Tokens could not be issued.
309         throw;
310 	    }
311 
312 	    return true;
313     }
314 
315     /// @dev Issues tokens for users who made investment.
316     /// @param beneficiary Address the tokens will be issued to.
317     /// @param valueInWei investment in wei
318     function addInvestment(address beneficiary, uint valueInWei)
319         external
320         onlyOwner
321         returns (bool)
322     {
323         uint tokenCount = calculateTokens(valueInWei);
324     	return issueTokens(beneficiary, tokenCount);
325     }
326 
327     /// @dev Issues tokens for users who made direct ETH payment.
328     function fund()
329         public
330         payable
331         returns (bool)
332     {
333         // Token count is rounded down. Sent ETH should be multiples of baseTokenPrice.
334         address beneficiary = msg.sender;
335         uint tokenCount = calculateTokens(msg.value);
336         uint roundedInvestment = tokenCount * tokenPrice / 100000000;
337 
338         // Send change back to user.
339         if (msg.value > roundedInvestment && !beneficiary.send(msg.value - roundedInvestment)) {
340           throw;
341         }
342         // Send money to the fund ethereum address
343         if (!ethAddress.send(roundedInvestment)) {
344           throw;
345         }
346         return issueTokens(beneficiary, tokenCount);
347     }
348 
349     function calculateTokens(uint valueInWei)
350         public
351         constant
352         returns (uint)
353     {
354         return valueInWei * 100000000 / tokenPrice;
355     }
356 
357     function estimateTokens(uint valueInWei)
358         public
359         constant
360         returns (uint)
361     {
362         return valueInWei * 95000000 / tokenPrice;
363     }
364 
365     function setReferral(address client, address referral)
366         public
367         onlyOwner
368     {
369         referrals[client] = referral;
370     }
371 
372     function getReferral(address client)
373         public
374         constant
375         returns (address)
376     {
377         return referrals[client];
378     }
379 
380     /// @dev Sets token price (TKN/ETH) in Wei.
381     /// @param valueInWei New value.
382     function setTokenPrice(uint valueInWei)
383         public
384         onlyOwner
385     {
386         tokenPrice = valueInWei;
387     }
388 
389     function getTokenPrice()
390         public
391         constant
392         returns (uint)
393     {
394         return tokenPrice;
395     }
396 
397     function changeMultisig(address newMultisig)
398         onlyOwner
399     {
400         multisig = newMultisig;
401     }
402 
403     function changeEthAddress(address newEthAddress)
404         onlyOwner
405     {
406         ethAddress = newEthAddress;
407     }
408 
409     /// @dev Contract constructor function
410     /// @param _ethAddress Ethereum address of the TokenFund.
411     /// @param _multisig Address of the owner of TokenFund.
412     /// @param _supportAddress Address of the developers team.
413     /// @param _tokenAddress Address of the token contract.
414     function Fund(address _owner, address _ethAddress, address _multisig, address _supportAddress, address _tokenAddress)
415     {
416         owner = _owner;
417         ethAddress = _ethAddress;
418         multisig = _multisig;
419         supportAddress = _supportAddress;
420         tokenFund = TokenFund(_tokenAddress);
421     }
422 
423     /// @dev Fallback function. Calls fund() function to create tokens.
424     function () payable {
425         fund();
426     }
427 }