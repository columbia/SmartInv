1 pragma solidity ^0.4.21;
2 
3 // File: contracts/CCLToken.sol
4 
5 // modified from Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017.
6 // The MIT Licence.
7 
8 contract SafeMath {
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint a, uint b) public pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint a, uint b) public pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint a, uint b) public pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 contract ERC20Interface {
29     function totalSupply() public constant returns (uint);
30     function balanceOf(address tokenOwner) public constant returns (uint balance);
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 
41 contract ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
43 }
44 
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 contract CCLToken is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81 
82     function CCLToken() public {
83         symbol = "CCL";
84         name = "CyClean Token";
85         decimals = 18;
86         _totalSupply = 4000000000000000000000000000; //4,000,000,000
87         balances[0xf835bF0285c99102eaedd684b4401272eF36aF65] = _totalSupply;
88         Transfer(address(0), 0xf835bF0285c99102eaedd684b4401272eF36aF65, _totalSupply);
89     }
90 
91 
92     function totalSupply() public constant returns (uint) {
93         return _totalSupply  - balances[address(0)];
94     }
95 
96 
97     function balanceOf(address tokenOwner) public constant returns (uint balance) {
98         return balances[tokenOwner];
99     }
100 
101 
102     function transfer(address to, uint tokens) public returns (bool success) {
103         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109 
110     function approve(address spender, uint tokens) public returns (bool success) {
111         allowed[msg.sender][spender] = tokens;
112         Approval(msg.sender, spender, tokens);
113         return true;
114     }
115 
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         balances[from] = safeSub(balances[from], tokens);
119         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         Transfer(from, to, tokens);
122         return true;
123     }
124 
125 
126     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
127         return allowed[tokenOwner][spender];
128     }
129 
130 
131     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
132         allowed[msg.sender][spender] = tokens;
133         Approval(msg.sender, spender, tokens);
134         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
135         return true;
136     }
137 
138 
139     function () public payable {
140         revert();
141     }
142 
143 
144     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
145         return ERC20Interface(tokenAddress).transfer(owner, tokens);
146     }
147 }
148 
149 // File: contracts/ICOEngineInterface.sol
150 
151 contract ICOEngineInterface {
152 
153     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
154     function started() public view returns(bool);
155 
156     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
157     function ended() public view returns(bool);
158 
159     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
160     function startTime() public view returns(uint);
161 
162     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
163     function endTime() public view returns(uint);
164 
165     // Optional function, can be implemented in place of startTime
166     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
167     // function startBlock() public view returns(uint);
168 
169     // Optional function, can be implemented in place of endTime
170     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
171     // function endBlock() public view returns(uint);
172 
173     // returns the total number of the tokens available for the sale, must not change when the ico is started
174     function totalTokens() public view returns(uint);
175 
176     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
177     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
178     function remainingTokens() public view returns(uint);
179 
180     // return the price as number of tokens released for each ether
181     function price() public view returns(uint);
182 }
183 
184 // File: contracts/SafeMath.sol
185 
186 library SafeMathLib {
187     function add(uint a, uint b) internal pure returns (uint) {
188         uint c = a + b;
189         assert(c>=a && c>=b);
190         return c;
191     }
192 
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         if (a == 0) {
195             return 0;
196         }
197         uint256 c = a * b;
198         assert(c / a == b);
199         return c;
200     }
201 
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         assert(b <= a);
204         return a - b;
205     }
206 }
207 
208 // File: contracts/KYCBase.sol
209 
210 // Abstract base contract
211 contract KYCBase {
212     using SafeMathLib for uint256;
213 
214     mapping (address => bool) public isKycSigner;
215     mapping (uint64 => uint256) public alreadyPayed;
216 
217     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
218     event ThisCheck(KYCBase base, address sender);
219     constructor ( address[] kycSigners) internal {
220         for (uint i = 0; i < kycSigners.length; i++) {
221             isKycSigner[kycSigners[i]] = true;
222         }
223     }
224 
225     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
226     function releaseTokensTo(address buyer) internal returns(bool);
227 
228     // This method can be overridden to enable some sender to buy token for a different address
229     function senderAllowedFor(address buyer)
230         internal view returns(bool)
231     {
232         return buyer == msg.sender;
233     }
234 
235     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
236         public payable returns (bool)
237     {
238         require(senderAllowedFor(buyerAddress));
239         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
240     }
241 
242     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
243         public payable returns (bool)
244     {
245         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
246     }
247 
248     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
249         private returns (bool)
250     {
251         // check the signature
252         bytes32 hash = sha256(abi.encodePacked("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount));
253         emit ThisCheck(this, msg.sender);
254         //bytes32 hash = sha256("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount);
255         address signer = ecrecover(hash, v, r, s);
256         if (!isKycSigner[signer]) {
257             revert();
258         } else {
259             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
260             require(totalPayed <= maxAmount);
261             alreadyPayed[buyerId] = totalPayed;
262             emit KycVerified(signer, buyerAddress, buyerId, maxAmount);
263             return releaseTokensTo(buyerAddress);
264         }
265     }
266 
267     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
268     function () public {
269         revert();
270     }
271 }
272 
273 // File: contracts/TokenSale.sol
274 
275 contract TokenSale is ICOEngineInterface, KYCBase {
276     using SafeMathLib for uint;
277 
278     event ReleaseTokensToCalled(address buyer);
279 
280     event ReleaseTokensToCalledDetail(address wallet, address buyer, uint amount, uint remainingTokensValue);
281     event SenderCheck(address sender);
282 
283     CCLToken public token;
284     address public wallet;
285 
286     // from ICOEngineInterface
287     uint private priceValue;
288     function price() public view returns(uint) {
289         return priceValue;
290     }
291 
292     // from ICOEngineInterface
293     uint private startTimeValue;
294     function startTime() public view returns(uint) {
295         return startTimeValue;
296     }
297 
298     // from ICOEngineInterface
299     uint private endTimeValue;
300     function endTime() public view returns(uint) {
301         return endTimeValue;
302     }
303     // from ICOEngineInterface
304     uint private totalTokensValue;
305     function totalTokens() public view returns(uint) {
306         return totalTokensValue;
307     }
308 
309     // from ICOEngineInterface
310     uint private remainingTokensValue;
311     function remainingTokens() public view returns(uint) {
312         return remainingTokensValue;
313     }
314 
315 
316     /**
317      *  After you deployed the SampleICO contract, you have to call the ERC20
318      *  approve() method from the _wallet account to the deployed contract address to assign
319      *  the tokens to be sold by the ICO.
320      */
321     constructor ( address[] kycSigner, CCLToken _token, address _wallet, uint _startTime, uint _endTime, uint _price, uint _totalTokens)
322         public KYCBase(kycSigner)
323     {
324         token = _token;
325         wallet = _wallet;
326         //emit WalletCheck(_wallet);
327         startTimeValue = _startTime;
328         endTimeValue = _endTime;
329         priceValue = _price;
330         totalTokensValue = _totalTokens;
331         remainingTokensValue = _totalTokens;
332     }
333 
334     // from KYCBase
335     function releaseTokensTo(address buyer) internal returns(bool) {
336         //emit SenderCheck(msg.sender);
337         require(now >= startTimeValue && now < endTimeValue);
338         uint amount = msg.value.mul(priceValue);
339         remainingTokensValue = remainingTokensValue.sub(amount);
340         emit ReleaseTokensToCalledDetail(wallet, buyer, amount, remainingTokensValue);
341 
342         wallet.transfer(msg.value);
343         //require(this == token.owner());
344         token.transferFrom(wallet, buyer, amount);
345         emit ReleaseTokensToCalled(buyer);
346         return true;
347     }
348 
349     // from ICOEngineInterface
350     function started() public view returns(bool) {
351         return now >= startTimeValue;
352     }
353 
354     // from ICOEngineInterface
355     function ended() public view returns(bool) {
356         return now >= endTimeValue || remainingTokensValue == 0;
357     }
358 
359     function senderAllowedFor(address buyer)
360         internal view returns(bool)
361     {
362         bool value = super.senderAllowedFor(buyer);
363         return value;
364     }
365 }