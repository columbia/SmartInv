1 pragma solidity 0.4.25;
2 
3 contract StandardToken {
4 
5     /* Data structures */
6     mapping (address => uint256) balances;
7     mapping (address => mapping (address => uint256)) allowed;
8     uint256 public totalSupply;
9 
10     /* Events */
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 
14     /* Read and write storage functions */
15 
16     // Transfers sender's tokens to a given address. Returns success.
17     function transfer(address _to, uint256 _value) public returns (bool success) {
18         if (balances[msg.sender] >= _value && _value > 0) {
19             balances[msg.sender] -= _value;
20             balances[_to] += _value;
21             emit Transfer(msg.sender, _to, _value);
22             return true;
23         }
24         else {
25             return false;
26         }
27     }
28 
29     // Allows allowed third party to transfer tokens from one address to another. Returns success. _value Number of tokens to transfer.
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
32             balances[_to] += _value;
33             balances[_from] -= _value;
34             allowed[_from][msg.sender] -= _value;
35             emit Transfer(_from, _to, _value);
36             return true;
37         }
38         else {
39             return false;
40         }
41     }
42 
43     // Returns number of tokens owned by given address.
44     function balanceOf(address _owner) public view returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     // Sets approved amount of tokens for spender. Returns success. _value Number of approved tokens.
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         emit Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     /* Read storage functions */
56 
57     //Returns number of allowed tokens for given address. _owner Address of token owner. _spender Address of token spender.
58     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
59       return allowed[_owner][_spender];
60     }
61 
62 }
63 
64 
65 contract AltTokenFund is StandardToken {
66 
67     /* External contracts */
68 
69     address public emissionContractAddress = 0x0;
70 
71     //Token meta data
72     string constant public name = "Alt Token Fund";
73     string constant public symbol = "ATF";
74     uint8 constant public decimals = 8;
75 
76     /* Storage */
77     address public owner = 0x0;
78     bool public emissionEnabled = true;
79     bool transfersEnabled = true;
80 
81     /* Modifiers */
82 
83     modifier isCrowdfundingContract() {
84         // Only emission address to do this action
85         if (msg.sender != emissionContractAddress) {
86             revert();
87         }
88         _;
89     }
90 
91     modifier onlyOwner() {
92         // Only owner is allowed to do this action.
93         if (msg.sender != owner) {
94             revert();
95         }
96         _;
97     }
98 
99     /* Contract functions */
100 
101     // TokenFund emission function. _for is Address of receiver, tokenCount is Number of tokens to issue.
102     function issueTokens(address _for, uint tokenCount)
103         external
104         isCrowdfundingContract
105         returns (bool)
106     {
107         if (emissionEnabled == false) {
108             revert();
109         }
110 
111         balances[_for] += tokenCount;
112         totalSupply += tokenCount;
113         return true;
114     }
115 
116     // Withdraws tokens for msg.sender.
117     function withdrawTokens(uint tokenCount)
118         public
119         returns (bool)
120     {
121         uint balance = balances[msg.sender];
122         if (balance < tokenCount) {
123             return false;
124         }
125         balances[msg.sender] -= tokenCount;
126         totalSupply -= tokenCount;
127         return true;
128     }
129 
130     // Function to change address that is allowed to do emission.
131     function changeEmissionContractAddress(address newAddress)
132         external
133         onlyOwner
134     {
135         emissionContractAddress = newAddress;
136     }
137 
138     // Function that enables/disables transfers of token, value is true/false
139     function enableTransfers(bool value)
140         external
141         onlyOwner
142     {
143         transfersEnabled = value;
144     }
145 
146     // Function that enables/disables token emission.
147     function enableEmission(bool value)
148         external
149         onlyOwner
150     {
151         emissionEnabled = value;
152     }
153 
154     /* Overriding ERC20 standard token functions to support transfer lock */
155     function transfer(address _to, uint256 _value) public returns (bool success) {
156         if (transfersEnabled == true) {
157             return super.transfer(_to, _value);
158         }
159         return false;
160     }
161 
162     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
163         if (transfersEnabled == true) {
164             return super.transferFrom(_from, _to, _value);
165         }
166         return false;
167     }
168 
169 
170     // Contract constructor function sets initial token balances. _owner Address of the owner of AltTokenFund.
171     constructor (address _owner) public
172     {
173         totalSupply = 0;
174         owner = _owner;
175     }
176 
177     function transferOwnership(address newOwner) public onlyOwner {
178         owner = newOwner;
179     }
180 }
181 
182 contract Fund {
183 
184   address public owner;
185   address public SetPriceAccount;
186   address public SetReferralAccount;
187 
188   modifier onlyOwner {
189       if (msg.sender != owner) revert();
190       _;
191   }
192   
193   modifier onlySetPriceAccount {
194       if (msg.sender != SetPriceAccount) revert();
195       _;
196   }
197   
198   modifier onlySetReferralAccount {
199       if (msg.sender != SetReferralAccount) revert();
200       _;
201   }
202   
203     /* External contracts */
204     AltTokenFund public tokenFund;
205 
206     /* Events */
207     event Deposit(address indexed from, uint256 value);
208     event Withdrawal(address indexed from, uint256 value);
209     event AddInvestment(address indexed to, uint256 value);
210 
211     /* Storage */
212     address public ethAddress;
213     address public fundManagers;
214     address public supportAddress;
215     uint public tokenPrice = 1 finney; // 0.001 ETH
216     uint public managersFee = 1;
217     uint public referralFee = 3;
218     uint public supportFee = 1;
219 
220     mapping (address => address) public referrals;
221 
222 /* Contract functions */
223 
224     // Issue tokens _for address and send comissions
225 
226     function issueTokens(address _for, uint tokenCount)
227     	private
228     	returns (bool)
229     {
230     	if (tokenCount == 0) {
231         return false;
232       }
233 
234       uint percent = tokenCount / 100;
235 
236     // managersFee to the fund managers
237       if (!tokenFund.issueTokens(fundManagers, percent * managersFee)) {
238         // Tokens could not be issued.
239         revert();
240       }
241 
242     // supportFee to the support team
243       if (!tokenFund.issueTokens(supportAddress, percent * supportFee)) {
244         // Tokens could not be issued.
245         revert();
246       }
247 
248       if (referrals[_for] != 0) {
249       	// referralFee to the referral
250       	if (!tokenFund.issueTokens(referrals[_for], referralFee * percent)) {
251           // Tokens could not be issued.
252           revert();
253         }
254       } else {
255       	// if there is no referral, referralFee goes to the fund managers
256       	if (!tokenFund.issueTokens(fundManagers, referralFee * percent)) {
257           // Tokens could not be issued.
258           revert();
259         }
260       }
261 
262       if (!tokenFund.issueTokens(_for, tokenCount - (referralFee+supportFee+managersFee) * percent)) {
263         // Tokens could not be issued.
264         revert();
265 	    }
266 
267 	    return true;
268     }
269 
270     // Issues tokens for users who made investment.
271     // @param beneficiary Address the tokens will be issued to.
272     // @param valueInWei investment in wei
273     function addInvestment(address beneficiary, uint valueInWei)
274         external
275         onlyOwner
276         returns (bool)
277     {
278         uint tokenCount = calculateTokens(valueInWei);
279     	return issueTokens(beneficiary, tokenCount);
280     }
281 
282     // Issues tokens for users who made direct ETH payment.
283     function fund()
284         public
285         payable
286         returns (bool)
287     {
288         // Token count is rounded down. Sent ETH should be multiples of baseTokenPrice.
289         address beneficiary = msg.sender;
290         uint tokenCount = calculateTokens(msg.value);
291         uint roundedInvestment = tokenCount * tokenPrice / 100000000;
292 
293         // Send change back to user.
294         if (msg.value > roundedInvestment && !beneficiary.send(msg.value - roundedInvestment)) {
295           revert();
296         }
297         // Send money to the fund ethereum address
298         if (!ethAddress.send(roundedInvestment)) {
299           revert();
300         }
301         return issueTokens(beneficiary, tokenCount);
302     }
303 
304     function calculateTokens(uint valueInWei)
305         public
306         constant
307         returns (uint)
308     {
309         return valueInWei * 100000000 / tokenPrice;
310     }
311 
312     function estimateTokens(uint valueInWei)
313         public
314         constant
315         returns (uint)
316     {
317         return valueInWei * (100000000-1000000*(referralFee+supportFee+managersFee)) / tokenPrice;
318     }
319 
320     function setReferral(address client, address referral)
321         public
322         onlySetReferralAccount
323     {
324         referrals[client] = referral;
325     }
326 
327     function getReferral(address client)
328         public
329         constant
330         returns (address)
331     {
332         return referrals[client];
333     }
334 
335     /// @dev Sets token price (TKN/ETH) in Wei.
336     /// @param valueInWei New value.
337     function setTokenPrice(uint valueInWei)
338         public
339         onlySetPriceAccount
340     {
341         tokenPrice = valueInWei;
342     }
343 
344 
345     function changeComissions(uint newManagersFee, uint newSupportFee, uint newReferralFee) public
346         onlyOwner
347     {
348         managersFee = newManagersFee;
349         supportFee = newSupportFee;
350         referralFee = newReferralFee;
351     }
352 
353     function changefundManagers(address newfundManagers) public
354         onlyOwner
355     {
356         fundManagers = newfundManagers;
357     }
358 
359     function changeEthAddress(address newEthAddress) public
360         onlyOwner
361     {
362         ethAddress = newEthAddress;
363     }
364 
365     function changeSupportAddress(address newSupportAddress) public
366         onlyOwner
367     {
368         supportAddress = newSupportAddress;
369     }
370     
371     function changeSetPriceAccount(address newSetPriceAccount) public
372         onlyOwner
373     {
374         SetPriceAccount = newSetPriceAccount;
375     }
376     
377      function changeSetReferralAccount (address newSetReferralAccount) public
378         onlyOwner
379     {
380         SetReferralAccount = newSetReferralAccount;
381     }
382 
383     function transferOwnership(address newOwner) public
384       onlyOwner
385     {
386         owner = newOwner;
387     }
388 
389     // Contract constructor function
390 
391     constructor (address _owner, address _SetPriceAccount, address _SetReferralAccount, address _ethAddress, address _fundManagers, address _supportAddress, address _tokenAddress)
392     public
393     {
394         owner = _owner;
395         SetPriceAccount = _SetPriceAccount;
396         SetReferralAccount = _SetReferralAccount;
397         ethAddress = _ethAddress;
398         fundManagers = _fundManagers;
399         supportAddress = _supportAddress;
400         tokenFund = AltTokenFund(_tokenAddress);
401     }
402 
403     // Fallback function. Calls fund() function to create tokens once contract receives payment.
404     function () public payable {
405         fund();
406     }
407 }