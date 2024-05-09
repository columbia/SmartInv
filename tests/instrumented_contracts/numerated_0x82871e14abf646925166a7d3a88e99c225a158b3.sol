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
93         if (balances[msg.sender] >= _amount
94             && _amount > 0
95             && balances[_to] + _amount > balances[_to]) {
96             balances[msg.sender] = safeSub(balances[msg.sender],_amount);
97             balances[_to] = safeAdd(balances[_to],_amount);
98             Transfer(msg.sender, _to, _amount);
99             return true;
100         } else {
101             return false;
102         }
103     }
104 
105     function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
106         if (balances[_from] >= _amount
107             && allowed[_from][msg.sender] >= _amount
108             && _amount > 0
109             && balances[_to] + _amount > balances[_to]) {
110             balances[_from] = safeSub(balances[_from],_amount);
111             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
112             balances[_to] = safeAdd(balances[_to],_amount);
113             Transfer(_from, _to, _amount);
114             return true;
115         } else {
116             return false;
117         }
118     }
119 
120     function approve(address _spender, uint _value) returns (bool success) {
121 
122         // To change the approve amount you first have to reduce the addresses`
123         //  allowance to zero by calling `approve(_spender, 0)` if it is not
124         //  already 0 to mitigate the race condition described here:
125         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
127            return false;
128         }
129         if (balances[msg.sender] < _value) {
130             return false;
131         }
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135      }
136 
137      function allowance(address _owner, address _spender) constant returns (uint remaining) {
138        return allowed[_owner][_spender];
139      }
140 }
141 
142 /**
143  * LookRev token initial offering.
144  *
145  * Token supply is created in the token contract creation and allocated to owner.
146  *
147  */
148 contract LookRevToken is StandardToken {
149 
150     /*
151     *  Token meta data
152     */
153     string public constant name = "LookRev";
154     string public constant symbol = "LOK";
155     uint8 public constant decimals = 18;
156     string public VERSION = 'LOK1.0';
157     bool public finalised = false;
158     
159     address public wallet;
160 
161     mapping(address => bool) public kycRequired;
162 
163     // Start - Wednesday, August 16, 2017 10:00:00 AM GMT-07:00 DST
164     // End - Saturday, September 16, 2017 10:00:00 AM GMT-07:00 DST
165     uint public constant START_DATE = 1502902800;
166     uint public constant END_DATE = 1505581200;
167 
168     uint public constant DECIMALSFACTOR = 10**uint(decimals);
169     uint public constant TOKENS_SOFT_CAP =   10000000 * DECIMALSFACTOR;
170     uint public constant TOKENS_HARD_CAP = 2000000000 * DECIMALSFACTOR;
171     uint public constant TOKENS_TOTAL =    4000000000 * DECIMALSFACTOR;
172 
173     // 1 KETHER = 2,400,000 tokens
174     // 1 ETH = 2,400 tokens
175     // Presale 20% discount 1 ETH = 3,000 tokens
176     // Presale 10% discount 1 ETH = 2,667 tokens
177     uint public tokensPerKEther = 3000000;
178     uint public CONTRIBUTIONS_MIN = 0 ether;
179     uint public CONTRIBUTIONS_MAX = 0 ether;
180     uint public constant KYC_THRESHOLD = 10000 * DECIMALSFACTOR;
181 
182     function LookRevToken(address _wallet, uint _initialSupply) {
183       wallet = _wallet;
184       owner = msg.sender;
185       totalSupply = _initialSupply;
186       balances[owner] = totalSupply;
187     }
188 
189    // LookRev can change the crowdsale wallet address
190    function setWallet(address _wallet) onlyOwner {
191         wallet = _wallet;
192         WalletUpdated(wallet);
193     }
194     event WalletUpdated(address newWallet);
195 
196     // Can only be set before the start of the crowdsale
197     // Owner can change the rate before the crowdsale starts
198     function setTokensPerKEther(uint _tokensPerKEther) onlyOwner {
199         require(now < START_DATE);
200         require(_tokensPerKEther > 0);
201         tokensPerKEther = _tokensPerKEther;
202         TokensPerKEtherUpdated(tokensPerKEther);
203     }
204     event TokensPerKEtherUpdated(uint tokensPerKEther);
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
222          // Calculate number of tokens for contributed ETH
223          // `18` is the ETH decimals
224          // `- decimals` is the token decimals
225          uint tokens = msg.value * tokensPerKEther / 10**uint(18 - decimals + 3);
226 
227          // Check if the hard cap will be exceeded
228          require(totalSupply + tokens <= TOKENS_HARD_CAP);
229 
230          // Add tokens purchased to account's balance and total supply
231          balances[participant] = safeAdd(balances[participant],tokens);
232          totalSupply = safeAdd(totalSupply,tokens);
233 
234          // Log the tokens purchased 
235          Transfer(0x0, participant, tokens);
236          // - buyer = participant
237          // - ethers = msg.value
238          // - participantTokenBalance = balances[participant]
239          // - tokens = tokens
240          // - newTotalSupply = totalSupply
241          // - tokensPerKEther = tokensPerKEther
242          TokensBought(participant, msg.value, balances[participant], tokens,
243               totalSupply, tokensPerKEther);
244 
245          if (msg.value > KYC_THRESHOLD) {
246              // KYC verification required before participant can transfer the tokens
247              kycRequired[participant] = true;
248          }
249 
250          // Transfer the contributed ethers to the crowdsale wallet
251          // throw is deprecated starting from Ethereum v0.9.0
252          wallet.transfer(msg.value);
253     }
254 
255     event TokensBought(address indexed buyer, uint ethers, 
256         uint participantTokenBalance, uint tokens, uint newTotalSupply, 
257         uint tokensPerKEther);
258 
259     function finalise() onlyOwner {
260         // Can only finalise if raised > soft cap or after the end date
261         require(totalSupply >= TOKENS_SOFT_CAP || now > END_DATE);
262 
263         require(!finalised);
264 
265         finalised = true;
266     }
267 
268    function addPrecommitment(address participant, uint balance) onlyOwner {
269         require(now < START_DATE);
270         require(balance > 0);
271         balances[participant] = safeAdd(balances[participant],balance);
272         totalSupply = safeAdd(totalSupply,balance);
273         Transfer(0x0, participant, balance);
274         PrecommitmentAdded(participant, balance);
275     }
276     event PrecommitmentAdded(address indexed participant, uint balance);
277 
278     function transfer(address _to, uint _amount) returns (bool success) {
279         // Cannot transfer before crowdsale ends
280         // Allow awarding team members before, during and after crowdsale
281         require(finalised || msg.sender == owner);
282         require(!kycRequired[msg.sender]);
283         return super.transfer(_to, _amount);
284     }
285 
286    function transferFrom(address _from, address _to, uint _amount) returns (bool success)
287     {
288         // Cannot transfer before crowdsale ends
289         require(finalised);
290         require(!kycRequired[_from]);
291         return super.transferFrom(_from, _to, _amount);
292     }
293 
294     function kycVerify(address participant, bool _required) onlyOwner {
295         kycRequired[participant] = _required;
296         KycVerified(participant, kycRequired[participant]);
297     }
298     event KycVerified(address indexed participant, bool required);
299 
300     // Any account can burn _from's tokens as long as the _from account has
301     // approved the _amount to be burnt using approve(0x0, _amount)
302     function burnFrom(address _from, uint _amount) returns (bool success) {
303         require(totalSupply >= _amount);
304 
305         if (balances[_from] >= _amount
306             && allowed[_from][0x0] >= _amount
307             && _amount > 0
308             && balances[0x0] + _amount > balances[0x0]
309         ) {
310             balances[_from] = safeSub(balances[_from],_amount);
311             balances[0x0] = safeAdd(balances[0x0],_amount);
312             allowed[_from][0x0] = safeSub(allowed[_from][0x0],_amount);
313             totalSupply = safeSub(totalSupply,_amount);
314             Transfer(_from, 0x0, _amount);
315             return true;
316         } else {
317             return false;
318         }
319     }
320 
321     // LookRev can transfer out any accidentally sent ERC20 tokens
322     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success) 
323     {
324         return ERC20(tokenAddress).transfer(owner, amount);
325     }
326 }