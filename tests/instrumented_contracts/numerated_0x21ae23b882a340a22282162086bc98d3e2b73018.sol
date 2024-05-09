1 pragma solidity ^0.4.11;
2 
3 /*
4 * LOK 'LookRev Token' crowdfunding contract
5 *
6 * Refer to https://lookrev.com/ for further information.
7 * 
8 * Developer: LookRev (TM) 2017.
9 *
10 * Audited by BokkyPooBah / Bok Consulting Pty Ltd 2017.
11 * 
12 * The MIT License.
13 *
14 */
15 
16 /*
17  * ERC20 Token Standard
18  * https://github.com/ethereum/EIPs/issues/20
19  *
20  */
21 contract ERC20 {
22   uint public totalSupply;
23   function balanceOf(address _who) constant returns (uint balance);
24   function allowance(address _owner, address _spender) constant returns (uint remaining);
25 
26   function transfer(address _to, uint _value) returns (bool ok);
27   function transferFrom(address _from, address _to, uint _value) returns (bool ok);
28   function approve(address _spender, uint _value) returns (bool ok);
29   event Transfer(address indexed _from, address indexed _to, uint _value);
30   event Approval(address indexed _owner, address indexed _spender, uint _value);
31 }
32 
33 /**
34  * Math operations with safety checks
35  */
36 contract SafeMath {
37   function safeAdd(uint a, uint b) internal returns (uint) {
38     uint c = a + b;
39     assert(c >= a && c >= b);
40     return c;
41   }
42 
43   function safeSub(uint a, uint b) internal returns (uint) {
44     assert(b <= a);
45     uint c = a - b;
46     assert(c <= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52   address public owner;
53   address public newOwner;
54 
55   function Ownable() {
56     owner = msg.sender;
57   }
58 
59   modifier onlyOwner {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   function transferOwnership(address _newOwner) onlyOwner {
65     if (_newOwner != address(0)) {
66       newOwner = _newOwner;
67     }
68   }
69 
70   function acceptOwnership() {
71     require(msg.sender == newOwner);
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75   event OwnershipTransferred(address indexed _from, address indexed _to);
76 }
77 
78 /**
79  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
80  *
81  * Based on code by InvestSeed
82  */
83 contract StandardToken is ERC20, Ownable, SafeMath {
84 
85     mapping (address => uint) balances;
86     mapping (address => mapping (address => uint)) allowed;
87 
88     function balanceOf(address _owner) constant returns (uint balance) {
89         return balances[_owner];
90     }
91 
92     function transfer(address _to, uint _amount) returns (bool success) {
93         // avoid wasting gas on 0 token transfers
94         if(_amount == 0) return true;
95 
96         if (balances[msg.sender] >= _amount
97             && _amount > 0
98             && balances[_to] + _amount > balances[_to]) {
99             balances[msg.sender] = safeSub(balances[msg.sender],_amount);
100             balances[_to] = safeAdd(balances[_to],_amount);
101             Transfer(msg.sender, _to, _amount);
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
109         // avoid wasting gas on 0 token transfers
110         if(_amount == 0) return true;
111 
112         if (balances[_from] >= _amount
113             && allowed[_from][msg.sender] >= _amount
114             && _amount > 0
115             && balances[_to] + _amount > balances[_to]) {
116             balances[_from] = safeSub(balances[_from],_amount);
117             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
118             balances[_to] = safeAdd(balances[_to],_amount);
119             Transfer(_from, _to, _amount);
120             return true;
121         } else {
122             return false;
123         }
124     }
125 
126     function approve(address _spender, uint _value) returns (bool success) {
127 
128         // To change the approve amount you first have to reduce the addresses`
129         //  allowance to zero by calling `approve(_spender, 0)` if it is not
130         //  already 0 to mitigate the race condition described here:
131         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
133            return false;
134         }
135         if (balances[msg.sender] < _value) {
136             return false;
137         }
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141      }
142 
143      function allowance(address _owner, address _spender) constant returns (uint remaining) {
144        return allowed[_owner][_spender];
145      }
146 }
147 
148 /**
149  * LookRev token initial offering.
150  *
151  * Token supply is created in the token contract creation and allocated to owner.
152  *
153  */
154 contract LookRevToken is StandardToken {
155 
156     /*
157     *  Token meta data
158     */
159     string public constant name = "LookRev";
160     string public constant symbol = "LOK";
161     uint8 public constant decimals = 18;
162     string public VERSION = 'LOK1.0';
163     bool public finalised = false;
164     
165     address public wallet = 0x0;
166 
167     mapping(address => bool) public kycRequired;
168 
169     // Start - Wednesday, August 30, 2017 10:00:00 AM GMT-07:00 DST
170     // End - Saturday, September 30, 2017 10:00:00 AM GMT-07:00 DST
171     uint public constant START_DATE = 1504112400;
172     uint public constant END_DATE = 1506790800;
173 
174     uint public constant DECIMALSFACTOR = 10**uint(decimals);
175     uint public constant TOKENS_SOFT_CAP =   10000000 * DECIMALSFACTOR;
176     uint public constant TOKENS_HARD_CAP = 2000000000 * DECIMALSFACTOR;
177     uint public constant TOKENS_TOTAL =    5000000000 * DECIMALSFACTOR;
178     uint public initialSupply = 10000000 * DECIMALSFACTOR;
179 
180     // 1 KETHER = 2,400,000 tokens
181     // 1 ETH = 2,400 tokens
182     uint public tokensPerKEther = 2400000;
183     uint public CONTRIBUTIONS_MIN = 0 ether;
184     uint public CONTRIBUTIONS_MAX = 0 ether;
185     uint public constant KYC_THRESHOLD = 1000000 * DECIMALSFACTOR;
186 
187     function LookRevToken() {
188       owner = msg.sender;
189       wallet = owner;
190       totalSupply = initialSupply;
191       balances[owner] = totalSupply;
192     }
193 
194    // LookRev can change the crowdsale wallet address
195    function setWallet(address _wallet) onlyOwner {
196         wallet = _wallet;
197         WalletUpdated(wallet);
198     }
199     event WalletUpdated(address newWallet);
200 
201     // Can only be set before the start of the crowdsale
202     // Owner can change the rate before the crowdsale starts
203     function setTokensPerKEther(uint _tokensPerKEther) onlyOwner {
204         require(now < START_DATE);
205         require(_tokensPerKEther > 0);
206         tokensPerKEther = _tokensPerKEther;
207         TokensPerKEtherUpdated(tokensPerKEther);
208     }
209     event TokensPerKEtherUpdated(uint tokensPerKEther);
210 
211     // Accept ethers to buy tokens during the crowdsale
212     function () payable {
213         proxyPayment(msg.sender);
214     }
215 
216     // Accept ethers and exchanges to purchase tokens on behalf of user
217     // msg.value (in units of wei)
218     function proxyPayment(address participant) payable {
219 
220         require(!finalised);
221 
222         require(now <= END_DATE);
223 
224         require(msg.value > CONTRIBUTIONS_MIN);
225         require(CONTRIBUTIONS_MAX == 0 || msg.value < CONTRIBUTIONS_MAX);
226 
227          // Calculate number of tokens for contributed ETH
228          // `18` is the ETH decimals
229          // `- decimals` is the token decimals
230          uint tokens = msg.value * tokensPerKEther / 10**uint(18 - decimals + 3);
231 
232          // Check if the hard cap will be exceeded
233          require(totalSupply + tokens <= TOKENS_HARD_CAP);
234 
235          // Add tokens purchased to account's balance and total supply
236          balances[participant] = safeAdd(balances[participant],tokens);
237          totalSupply = safeAdd(totalSupply,tokens);
238 
239          // Log the tokens purchased 
240          Transfer(0x0, participant, tokens);
241          // - buyer = participant
242          // - ethers = msg.value
243          // - participantTokenBalance = balances[participant]
244          // - tokens = tokens
245          // - newTotalSupply = totalSupply
246          // - tokensPerKEther = tokensPerKEther
247          TokensBought(participant, msg.value, balances[participant], tokens,
248               totalSupply, tokensPerKEther);
249 
250          if (msg.value > KYC_THRESHOLD) {
251              // KYC verification required before participant can transfer the tokens
252              kycRequired[participant] = true;
253          }
254 
255          // Transfer the contributed ethers to the crowdsale wallet
256          // throw is deprecated starting from Ethereum v0.9.0
257          wallet.transfer(msg.value);
258     }
259 
260     event TokensBought(address indexed buyer, uint ethers, 
261         uint participantTokenBalance, uint tokens, uint newTotalSupply, 
262         uint tokensPerKEther);
263 
264     function finalise() onlyOwner {
265         // Can only finalise if raised > soft cap or after the end date
266         require(totalSupply >= TOKENS_SOFT_CAP || now > END_DATE);
267 
268         require(!finalised);
269 
270         finalised = true;
271     }
272 
273    function addPrecommitment(address participant, uint balance) onlyOwner {
274         require(now < START_DATE);
275         require(balance > 0);
276         balances[participant] = safeAdd(balances[participant],balance);
277         totalSupply = safeAdd(totalSupply,balance);
278         Transfer(0x0, participant, balance);
279         PrecommitmentAdded(participant, balance);
280     }
281     event PrecommitmentAdded(address indexed participant, uint balance);
282 
283     function transfer(address _to, uint _amount) returns (bool success) {
284         // Cannot transfer before crowdsale ends
285         // Allow awarding team members before, during and after crowdsale
286         require(finalised || msg.sender == owner);
287         require(!kycRequired[msg.sender]);
288         return super.transfer(_to, _amount);
289     }
290 
291    function transferFrom(address _from, address _to, uint _amount) returns (bool success)
292     {
293         // Cannot transfer before crowdsale ends
294         require(finalised);
295         require(!kycRequired[_from]);
296         return super.transferFrom(_from, _to, _amount);
297     }
298 
299     function kycVerify(address participant, bool _required) onlyOwner {
300         kycRequired[participant] = _required;
301         KycVerified(participant, kycRequired[participant]);
302     }
303     event KycVerified(address indexed participant, bool required);
304 
305     // Any account can burn _from's tokens as long as the _from account has
306     // approved the _amount to be burnt using approve(0x0, _amount)
307     function burnFrom(address _from, uint _amount) returns (bool success) {
308         require(totalSupply >= _amount);
309 
310         if (balances[_from] >= _amount
311             && allowed[_from][0x0] >= _amount
312             && _amount > 0
313             && balances[0x0] + _amount > balances[0x0]
314         ) {
315             balances[_from] = safeSub(balances[_from],_amount);
316             balances[0x0] = safeAdd(balances[0x0],_amount);
317             allowed[_from][0x0] = safeSub(allowed[_from][0x0],_amount);
318             totalSupply = safeSub(totalSupply,_amount);
319             Transfer(_from, 0x0, _amount);
320             return true;
321         } else {
322             return false;
323         }
324     }
325 
326     // LookRev can transfer out any accidentally sent ERC20 tokens
327     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success) 
328     {
329         return ERC20(tokenAddress).transfer(owner, amount);
330     }
331 }