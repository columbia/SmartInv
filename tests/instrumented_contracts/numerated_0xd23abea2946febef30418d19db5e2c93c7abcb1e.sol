1 pragma solidity ^0.4.11;
2 
3 
4 /*
5   Author: Victor Mezrin  victor@mezrin.com
6 */
7 
8 
9 /* Interface of the ERC223 token */
10 contract ERC223TokenInterface {
11     function name() constant returns (string _name);
12     function symbol() constant returns (string _symbol);
13     function decimals() constant returns (uint8 _decimals);
14     function totalSupply() constant returns (uint256 _supply);
15 
16     function balanceOf(address _owner) constant returns (uint256 _balance);
17 
18     function approve(address _spender, uint256 _value) returns (bool _success);
19     function allowance(address _owner, address spender) constant returns (uint256 _remaining);
20 
21     function transfer(address _to, uint256 _value) returns (bool _success);
22     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success);
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Transfer(address indexed from, address indexed to, uint256 value, bytes metadata);
28 }
29 
30 
31 /* Interface of the contract that is going to receive ERC223 tokens */
32 contract ERC223ContractInterface {
33     function erc223Fallback(address _from, uint256 _value, bytes _data){
34         // to avoid warnings during compilation
35         _from = _from;
36         _value = _value;
37         _data = _data;
38         // Incoming transaction code here
39         throw;
40     }
41 }
42 
43 
44 /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
45 contract SafeMath {
46     uint256 constant public MAX_UINT256 =
47     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
48 
49     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
50         if (x > MAX_UINT256 - y) throw;
51         return x + y;
52     }
53 
54     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
55         if (x < y) throw;
56         return x - y;
57     }
58 
59     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
60         if (y == 0) return 0;
61         if (x > MAX_UINT256 / y) throw;
62         return x * y;
63     }
64 }
65 
66 
67 contract ERC223Token is ERC223TokenInterface, SafeMath {
68 
69     /*
70       Storage of the contract
71     */
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowances;
75 
76     string public name;
77     string public symbol;
78     uint8 public decimals;
79     uint256 public totalSupply;
80 
81 
82     /*
83       Getters
84     */
85 
86     function name() constant returns (string _name) {
87         return name;
88     }
89 
90     function symbol() constant returns (string _symbol) {
91         return symbol;
92     }
93 
94     function decimals() constant returns (uint8 _decimals) {
95         return decimals;
96     }
97 
98     function totalSupply() constant returns (uint256 _supply) {
99         return totalSupply;
100     }
101 
102     function balanceOf(address _owner) constant returns (uint256 _balance) {
103         return balances[_owner];
104     }
105 
106 
107     /*
108       Allow to spend
109     */
110 
111     function approve(address _spender, uint256 _value) returns (bool _success) {
112         allowances[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) constant returns (uint256 _remaining) {
118         return allowances[_owner][_spender];
119     }
120 
121 
122     /*
123       Transfer
124     */
125 
126     function transfer(address _to, uint256 _value) returns (bool _success) {
127         bytes memory emptyMetadata;
128         __transfer(msg.sender, _to, _value, emptyMetadata);
129         return true;
130     }
131 
132     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success)
133     {
134         __transfer(msg.sender, _to, _value, _metadata);
135         Transfer(msg.sender, _to, _value, _metadata);
136         return true;
137     }
138 
139     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
140         if (allowances[_from][msg.sender] < _value) throw;
141 
142         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
143         bytes memory emptyMetadata;
144         __transfer(_from, _to, _value, emptyMetadata);
145         return true;
146     }
147 
148     function __transfer(address _from, address _to, uint256 _value, bytes _metadata) internal
149     {
150         if (_from == _to) throw;
151         if (_value == 0) throw;
152         if (balanceOf(_from) < _value) throw;
153 
154         balances[_from] = safeSub(balanceOf(_from), _value);
155         balances[_to] = safeAdd(balanceOf(_to), _value);
156 
157         if (isContract(_to)) {
158             ERC223ContractInterface receiverContract = ERC223ContractInterface(_to);
159             receiverContract.erc223Fallback(_from, _value, _metadata);
160         }
161 
162         Transfer(_from, _to, _value);
163     }
164 
165 
166     /*
167       Helpers
168     */
169 
170     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
171     function isContract(address _addr) internal returns (bool _isContract) {
172         _addr = _addr; // to avoid warnings during compilation
173 
174         uint256 length;
175         assembly {
176             //retrieve the size of the code on target address, this needs assembly
177             length := extcodesize(_addr)
178         }
179         return (length > 0);
180     }
181 }
182 
183 
184 
185 // ERC223 token with the ability for the owner to block any account
186 contract DASToken is ERC223Token {
187     mapping (address => bool) blockedAccounts;
188     address public secretaryGeneral;
189 
190 
191     // Constructor
192     function DASToken(
193             string _name,
194             string _symbol,
195             uint8 _decimals,
196             uint256 _totalSupply,
197             address _initialTokensHolder) {
198         secretaryGeneral = msg.sender;
199         name = _name;
200         symbol = _symbol;
201         decimals = _decimals;
202         totalSupply = _totalSupply;
203         balances[_initialTokensHolder] = _totalSupply;
204     }
205 
206 
207     modifier onlySecretaryGeneral {
208         if (msg.sender != secretaryGeneral) throw;
209         _;
210     }
211 
212 
213     // block account
214     function blockAccount(address _account) onlySecretaryGeneral {
215         blockedAccounts[_account] = true;
216     }
217 
218     // unblock account
219     function unblockAccount(address _account) onlySecretaryGeneral {
220         blockedAccounts[_account] = false;
221     }
222 
223     // check is account blocked
224     function isAccountBlocked(address _account) returns (bool){
225         return blockedAccounts[_account];
226     }
227 
228     // override transfer methods to throw on blocked accounts
229     function transfer(address _to, uint256 _value) returns (bool _success) {
230         if (blockedAccounts[msg.sender]) {
231             throw;
232         }
233         return super.transfer(_to, _value);
234     }
235 
236     function transfer(address _to, uint256 _value, bytes _metadata) returns (bool _success) {
237         if (blockedAccounts[msg.sender]) {
238             throw;
239         }
240         return super.transfer(_to, _value, _metadata);
241     }
242 
243     function transferFrom(address _from, address _to, uint256 _value) returns (bool _success) {
244         if (blockedAccounts[_from]) {
245             throw;
246         }
247         return super.transferFrom(_from, _to, _value);
248     }
249 }
250 
251 
252 
253 contract DASCrowdsale is ERC223ContractInterface {
254 
255     /* Contract state */
256     // configuration
257     address public secretaryGeneral;
258     address public crowdsaleBeneficiary;
259     address public crowdsaleDasTokensChangeBeneficiary;
260     uint256 public crowdsaleDeadline;
261     uint256 public crowdsaleTokenPriceNumerator;
262     uint256 public crowdsaleTokenPriceDenominator;
263     DASToken public dasToken;
264     // crowdsale results
265     mapping (address => uint256) public ethBalanceOf;
266     uint256 crowdsaleFundsRaised;
267 
268 
269     /* Contract events */
270     event FundsReceived(address indexed backer, uint256 indexed amount);
271 
272 
273     /* Configuration */
274     function DASCrowdsale(
275         address _secretaryGeneral,
276         address _crowdsaleBeneficiary,
277         address _crowdsaleDasTokensChangeBeneficiary,
278         uint256 _durationInSeconds,
279         uint256 _crowdsaleTokenPriceNumerator,
280         uint256 _crowdsaleTokenPriceDenominator,
281         address _dasTokenAddress
282     ) {
283         secretaryGeneral = _secretaryGeneral;
284         crowdsaleBeneficiary = _crowdsaleBeneficiary;
285         crowdsaleDasTokensChangeBeneficiary = _crowdsaleDasTokensChangeBeneficiary;
286         crowdsaleDeadline = now + _durationInSeconds * 1 seconds;
287         crowdsaleTokenPriceNumerator = _crowdsaleTokenPriceNumerator;
288         crowdsaleTokenPriceDenominator = _crowdsaleTokenPriceDenominator;
289         dasToken = DASToken(_dasTokenAddress);
290         crowdsaleFundsRaised = 0;
291     }
292 
293     function __setSecretaryGeneral(address _secretaryGeneral) onlySecretaryGeneral {
294         secretaryGeneral = _secretaryGeneral;
295     }
296 
297     function __setBeneficiary(address _crowdsaleBeneficiary) onlySecretaryGeneral {
298         crowdsaleBeneficiary = _crowdsaleBeneficiary;
299     }
300 
301     function __setBeneficiaryForDasTokensChange(address _crowdsaleDasTokensChangeBeneficiary) onlySecretaryGeneral {
302         crowdsaleDasTokensChangeBeneficiary = _crowdsaleDasTokensChangeBeneficiary;
303     }
304 
305     function __setDeadline(uint256 _durationInSeconds) onlySecretaryGeneral {
306         crowdsaleDeadline = now + _durationInSeconds * 1 seconds;
307     }
308 
309     function __setTokenPrice(
310         uint256 _crowdsaleTokenPriceNumerator,
311         uint256 _crowdsaleTokenPriceDenominator
312     )
313         onlySecretaryGeneral
314     {
315         crowdsaleTokenPriceNumerator = _crowdsaleTokenPriceNumerator;
316         crowdsaleTokenPriceDenominator = _crowdsaleTokenPriceDenominator;
317     }
318 
319 
320     /* Deposit funds */
321     function() payable onlyBeforeCrowdsaleDeadline {
322         uint256 receivedAmount = msg.value;
323 
324         ethBalanceOf[msg.sender] += receivedAmount;
325         crowdsaleFundsRaised += receivedAmount;
326 
327         dasToken.transfer(msg.sender, receivedAmount / crowdsaleTokenPriceDenominator * crowdsaleTokenPriceNumerator);
328         FundsReceived(msg.sender, receivedAmount);
329     }
330 
331     function erc223Fallback(address _from, uint256 _value, bytes _data) {
332         // blank ERC223 fallback to receive DA$ tokens
333         // to avoid warnings during compilation
334         _from = _from;
335         _value = _value;
336         _data = _data;
337     }
338 
339 
340     /* Finish the crowdsale and withdraw funds */
341     function withdraw() onlyAfterCrowdsaleDeadline {
342         uint256 ethToWithdraw = address(this).balance;
343         uint256 dasToWithdraw = dasToken.balanceOf(address(this));
344 
345         if (ethToWithdraw == 0 && dasToWithdraw == 0) throw;
346 
347         if (ethToWithdraw > 0) { crowdsaleBeneficiary.transfer(ethToWithdraw); }
348         if (dasToWithdraw > 0) { dasToken.transfer(crowdsaleDasTokensChangeBeneficiary, dasToWithdraw); }
349     }
350 
351 
352     /* Helpers */
353     modifier onlyBeforeCrowdsaleDeadline {
354         require(now <= crowdsaleDeadline);
355         _;
356     }
357 
358     modifier onlyAfterCrowdsaleDeadline {
359         require(now > crowdsaleDeadline);
360         _;
361     }
362 
363     modifier onlySecretaryGeneral {
364         if (msg.sender != secretaryGeneral) throw;
365         _;
366     }
367 }