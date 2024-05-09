1 pragma solidity ^0.4.11;
2 
3 /*
4 * LOK 'LookRev Token' crowdfunding contract Version 2.0
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
52   address owner;
53   address newOwner;
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
95         if (msg.sender == _to) return false;
96 
97         if (balances[msg.sender] >= _amount
98             && _amount > 0
99             && balances[_to] + _amount > balances[_to]) {
100             balances[msg.sender] = safeSub(balances[msg.sender],_amount);
101             balances[_to] = safeAdd(balances[_to],_amount);
102             Transfer(msg.sender, _to, _amount);
103             return true;
104         } else {
105             return false;
106         }
107     }
108 
109     function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
110         // avoid wasting gas on 0 token transfers
111         if(_amount == 0) return true;
112         if(_from == _to) return false;
113 
114         if (balances[_from] >= _amount
115             && allowed[_from][msg.sender] >= _amount
116             && _amount > 0
117             && balances[_to] + _amount > balances[_to]) {
118             balances[_from] = safeSub(balances[_from],_amount);
119             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
120             balances[_to] = safeAdd(balances[_to],_amount);
121             Transfer(_from, _to, _amount);
122             return true;
123         } else {
124             return false;
125         }
126     }
127 
128     function approve(address _spender, uint _value) returns (bool success) {
129 
130         // To change the approve amount you first have to reduce the addresses`
131         //  allowance to zero by calling `approve(_spender, 0)` if it is not
132         //  already 0 to mitigate the race condition described here:
133         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
135            return false;
136         }
137         if (balances[msg.sender] < _value) {
138             return false;
139         }
140         allowed[msg.sender][_spender] = _value;
141         Approval(msg.sender, _spender, _value);
142         return true;
143      }
144 
145      function allowance(address _owner, address _spender) constant returns (uint remaining) {
146        return allowed[_owner][_spender];
147      }
148 }
149 
150 /**
151  * LookRev token initial offering.
152  *
153  * Token supply is created in the token contract creation and allocated to owner.
154  *
155  */
156 contract LookRevToken is StandardToken {
157 
158     /*
159     *  Token meta data
160     */
161     string public constant name = "LookRev";
162     string public constant symbol = "LOOK";
163     uint8 public constant decimals = 18;
164     string public VERSION = 'LOK2.0';
165     bool public finalised = false;
166     
167     address wallet = 0x0;
168 
169     mapping(address => bool) public kycRequired;
170 
171     // Start - Sunday, October 8, 2017 3:00:01 PM (8:00:01 AM GMT-07:00 DST)
172     uint public constant START_DATE = 1507474801;
173 
174     uint public constant DECIMALSFACTOR = 10**uint(decimals);
175     uint public constant TOKENS_SOFT_CAP =   10000000 * DECIMALSFACTOR;
176     uint public constant TOKENS_HARD_CAP = 4500000000 * DECIMALSFACTOR;
177     uint public constant TOKENS_TOTAL =    5000000000 * DECIMALSFACTOR;
178     uint public constant INITIAL_SUPPLY = 10000000 * DECIMALSFACTOR;
179 
180     // 1 KETHER = 2,400,000 tokens
181     // 1 ETH = 2,400 tokens
182     uint public tokensPerKEther = 2400000;
183     uint public CONTRIBUTIONS_MIN = 0 ether;
184     uint public CONTRIBUTIONS_MAX = 0 ether;
185     uint public constant KYC_THRESHOLD = 100 * DECIMALSFACTOR;
186 
187     function LookRevToken() {
188       owner = msg.sender;
189       wallet = owner;
190       totalSupply = INITIAL_SUPPLY;
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
201     // Accept ethers to buy tokens during the crowdsale
202     function () payable {
203         proxyPayment(msg.sender);
204     }
205 
206     // Accept ethers and exchanges to purchase tokens on behalf of user
207     // msg.value (in units of wei)
208     function proxyPayment(address participant) payable {
209 
210          require(!finalised);
211 
212          require(msg.value > CONTRIBUTIONS_MIN);
213          require(CONTRIBUTIONS_MAX == 0 || msg.value < CONTRIBUTIONS_MAX);
214 
215          // Calculate number of tokens for contributed ETH
216          // `18` is the ETH decimals
217          // `- decimals` is the token decimals
218          uint tokens = msg.value * tokensPerKEther / 10**uint(18 - decimals + 3);
219 
220          // Check if the hard cap will be exceeded
221          require(totalSupply + tokens <= TOKENS_HARD_CAP);
222 
223          // Add tokens purchased to account's balance and total supply
224          balances[participant] = safeAdd(balances[participant],tokens);
225          totalSupply = safeAdd(totalSupply,tokens);
226 
227          // Log the tokens purchased 
228          Transfer(0x0, participant, tokens);
229          // - buyer = participant
230          // - ethers = msg.value
231          // - participantTokenBalance = balances[participant]
232          // - tokens = tokens
233          // - newTotalSupply = totalSupply
234          // - tokensPerKEther = tokensPerKEther
235          TokensBought(participant, msg.value, balances[participant], tokens,
236               totalSupply, tokensPerKEther);
237 
238          if (msg.value > KYC_THRESHOLD) {
239              // KYC verification required before participant can transfer the tokens
240              kycRequired[participant] = true;
241          }
242 
243          // Transfer the contributed ethers to the crowdsale wallet
244          // throw is deprecated starting from Ethereum v0.9.0
245          wallet.transfer(msg.value);
246     }
247 
248     event TokensBought(address indexed buyer, uint ethers, 
249         uint participantTokenBalance, uint tokens, uint newTotalSupply, 
250         uint tokensPerKEther);
251 
252     function finalise() onlyOwner {
253         // Can only finalise if raised > soft cap
254         require(totalSupply >= TOKENS_SOFT_CAP);
255 
256         require(!finalised);
257 
258         finalised = true;
259     }
260 
261     // Tokens purchased using other types of cryptocurrency
262     function addPrecommitment(address participant, uint balance) onlyOwner {
263         require(balance > 0);
264         balances[participant] = safeAdd(balances[participant],balance);
265         totalSupply = safeAdd(totalSupply,balance);
266         Transfer(0x0, participant, balance);
267         PrecommitmentAdded(participant, balance);
268     }
269     event PrecommitmentAdded(address indexed participant, uint balance);
270 
271     function transfer(address _to, uint _amount) returns (bool success) {
272         // Allow token transfer
273         require(!kycRequired[msg.sender] || msg.sender == owner);
274         return super.transfer(_to, _amount);
275     }
276 
277    function transferFrom(address _from, address _to, uint _amount) returns (bool success)
278     {
279         require(!kycRequired[_from] || msg.sender == owner);
280         return super.transferFrom(_from, _to, _amount);
281     }
282 
283     function kycVerify(address participant, bool _required) onlyOwner {
284         kycRequired[participant] = _required;
285         KycVerified(participant, kycRequired[participant]);
286     }
287     event KycVerified(address indexed participant, bool required);
288 
289     // Any account can burn _from's tokens as long as the _from account has
290     // approved the _amount to be burnt using approve(0x0, _amount)
291     function burnFrom(address _from, uint _amount) returns (bool success) {
292         require(totalSupply >= _amount);
293 
294         if (balances[_from] >= _amount
295             && allowed[_from][0x0] >= _amount
296             && _amount > 0
297             && balances[0x0] + _amount > balances[0x0]
298         ) {
299             balances[_from] = safeSub(balances[_from],_amount);
300             balances[0x0] = safeAdd(balances[0x0],_amount);
301             allowed[_from][0x0] = safeSub(allowed[_from][0x0],_amount);
302             totalSupply = safeSub(totalSupply,_amount);
303             Transfer(_from, 0x0, _amount);
304             return true;
305         } else {
306             return false;
307         }
308     }
309 
310     // LookRev can transfer out any accidentally sent ERC20 tokens
311     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success) 
312     {
313         return ERC20(tokenAddress).transfer(owner, amount);
314     }
315 }