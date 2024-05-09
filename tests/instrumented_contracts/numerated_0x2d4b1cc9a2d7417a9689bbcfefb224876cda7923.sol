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
162     string public VERSION = 'LOK1.2';
163     bool public finalised = false;
164     
165     address public wallet = 0x0;
166 
167     mapping(address => bool) public kycRequired;
168 
169     // Start - Friday, September 8, 2017 3:00:00 PM UTC (8:00:00 AM PDT GMT-07:00 DST)
170     uint public constant START_DATE = 1504882800;
171     // 3000 LOK Per ETH for the 1st 24 Hours - Till Saturday, September 9, 2017 3:00:00 PM UTC (8:00:00 AM PDT GMT-07:00 DST)
172     uint public constant BONUSONE_DATE = 1504969200;
173     // 2700 LOK Per ETH for the Next 48 Hours - Till Monday, September 11, 2017 3:00:00 PM UTC (8:00:00 AM PDT GMT-07:00 DST)
174     uint public constant BONUSTWO_DATE = 1505142000;
175     // Regular Rate - 2400 LOK Per ETH for the Remaining Part of the Crowdsale
176     // End - Sunday, October 8, 2017 3:00:00 PM UTC (8:00:00 AM PDT GMT-07:00 DST)
177     uint public constant END_DATE = 1507474800;
178 
179     uint public constant DECIMALSFACTOR = 10**uint(decimals);
180     uint public constant TOKENS_SOFT_CAP =   10000000 * DECIMALSFACTOR;
181     uint public constant TOKENS_HARD_CAP = 2000000000 * DECIMALSFACTOR;
182     uint public constant TOKENS_TOTAL =    5000000000 * DECIMALSFACTOR;
183     uint public constant INITIAL_SUPPLY = 10000000 * DECIMALSFACTOR;
184 
185     // 1 KETHER = 2,400,000 tokens
186     // 1 ETH = 2,400 tokens
187     uint public tokensPerKEther = 2400000;
188     uint public CONTRIBUTIONS_MIN = 0 ether;
189     uint public CONTRIBUTIONS_MAX = 0 ether;
190     uint public constant KYC_THRESHOLD = 100 * DECIMALSFACTOR;
191 
192     function LookRevToken() {
193       owner = msg.sender;
194       wallet = owner;
195       totalSupply = INITIAL_SUPPLY;
196       balances[owner] = totalSupply;
197     }
198 
199    // LookRev can change the crowdsale wallet address
200    function setWallet(address _wallet) onlyOwner {
201         wallet = _wallet;
202         WalletUpdated(wallet);
203     }
204     event WalletUpdated(address newWallet);
205 
206     // Accept ethers to buy tokens during the crowdsale
207     function () payable {
208         proxyPayment(msg.sender);
209     }
210 
211     // Accept ethers and exchanges to purchase tokens on behalf of user
212     // msg.value (in units of wei)
213     function proxyPayment(address participant) payable {
214 
215         require(!finalised);
216 
217         require(now <= END_DATE);
218 
219         require(msg.value > CONTRIBUTIONS_MIN);
220         require(CONTRIBUTIONS_MAX == 0 || msg.value < CONTRIBUTIONS_MAX);
221 
222          // Add in bonus during the first 24 and 48 hours of the token sale
223          if (now < START_DATE) {
224             tokensPerKEther = 2400000;
225          } else if (now < BONUSONE_DATE) {
226             tokensPerKEther = 3000000;
227          } else if (now < BONUSTWO_DATE) {
228             tokensPerKEther = 2700000;
229          } else {
230             tokensPerKEther = 2400000;
231          }
232 
233          // Calculate number of tokens for contributed ETH
234          // `18` is the ETH decimals
235          // `- decimals` is the token decimals
236          uint tokens = msg.value * tokensPerKEther / 10**uint(18 - decimals + 3);
237 
238          // Check if the hard cap will be exceeded
239          require(totalSupply + tokens <= TOKENS_HARD_CAP);
240 
241          // Add tokens purchased to account's balance and total supply
242          balances[participant] = safeAdd(balances[participant],tokens);
243          totalSupply = safeAdd(totalSupply,tokens);
244 
245          // Log the tokens purchased 
246          Transfer(0x0, participant, tokens);
247          // - buyer = participant
248          // - ethers = msg.value
249          // - participantTokenBalance = balances[participant]
250          // - tokens = tokens
251          // - newTotalSupply = totalSupply
252          // - tokensPerKEther = tokensPerKEther
253          TokensBought(participant, msg.value, balances[participant], tokens,
254               totalSupply, tokensPerKEther);
255 
256          if (msg.value > KYC_THRESHOLD) {
257              // KYC verification required before participant can transfer the tokens
258              kycRequired[participant] = true;
259          }
260 
261          // Transfer the contributed ethers to the crowdsale wallet
262          // throw is deprecated starting from Ethereum v0.9.0
263          wallet.transfer(msg.value);
264     }
265 
266     event TokensBought(address indexed buyer, uint ethers, 
267         uint participantTokenBalance, uint tokens, uint newTotalSupply, 
268         uint _tokensPerKEther);
269 
270     function finalise() onlyOwner {
271         // Can only finalise if raised > soft cap or after the end date
272         require(totalSupply >= TOKENS_SOFT_CAP || now > END_DATE);
273 
274         require(!finalised);
275 
276         finalised = true;
277     }
278 
279    function addPrecommitment(address participant, uint balance) onlyOwner {
280         require(now < START_DATE);
281         require(balance > 0);
282         balances[participant] = safeAdd(balances[participant],balance);
283         totalSupply = safeAdd(totalSupply,balance);
284         Transfer(0x0, participant, balance);
285         PrecommitmentAdded(participant, balance);
286     }
287     event PrecommitmentAdded(address indexed participant, uint balance);
288 
289     function transfer(address _to, uint _amount) returns (bool success) {
290         // Cannot transfer before crowdsale ends
291         // Allow awarding team members before, during and after crowdsale
292         require(finalised || msg.sender == owner);
293         require(!kycRequired[msg.sender]);
294         return super.transfer(_to, _amount);
295     }
296 
297    function transferFrom(address _from, address _to, uint _amount) returns (bool success)
298     {
299         // Cannot transfer before crowdsale ends
300         require(finalised);
301         require(!kycRequired[_from]);
302         return super.transferFrom(_from, _to, _amount);
303     }
304 
305     function kycVerify(address participant, bool _required) onlyOwner {
306         kycRequired[participant] = _required;
307         KycVerified(participant, kycRequired[participant]);
308     }
309     event KycVerified(address indexed participant, bool required);
310 
311     // Any account can burn _from's tokens as long as the _from account has
312     // approved the _amount to be burnt using approve(0x0, _amount)
313     function burnFrom(address _from, uint _amount) returns (bool success) {
314         require(totalSupply >= _amount);
315 
316         if (balances[_from] >= _amount
317             && allowed[_from][0x0] >= _amount
318             && _amount > 0
319             && balances[0x0] + _amount > balances[0x0]
320         ) {
321             balances[_from] = safeSub(balances[_from],_amount);
322             balances[0x0] = safeAdd(balances[0x0],_amount);
323             allowed[_from][0x0] = safeSub(allowed[_from][0x0],_amount);
324             totalSupply = safeSub(totalSupply,_amount);
325             Transfer(_from, 0x0, _amount);
326             return true;
327         } else {
328             return false;
329         }
330     }
331 
332     // LookRev can transfer out any accidentally sent ERC20 tokens
333     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success) 
334     {
335         return ERC20(tokenAddress).transfer(owner, amount);
336     }
337 }