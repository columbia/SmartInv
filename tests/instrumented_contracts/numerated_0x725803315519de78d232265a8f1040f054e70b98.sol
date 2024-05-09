1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // Dao.Casino Crowdsale Token Contract (Under Consideration)
5 //
6 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017
7 // The MIT Licence (Under Consideration).
8 // ----------------------------------------------------------------------------
9 
10 
11 // ----------------------------------------------------------------------------
12 // Safe maths, borrowed from OpenZeppelin
13 // ----------------------------------------------------------------------------
14 library SafeMath {
15 
16     // ------------------------------------------------------------------------
17     // Add a number to another number, checking for overflows
18     // ------------------------------------------------------------------------
19     function add(uint a, uint b) internal returns (uint) {
20         uint c = a + b;
21         assert(c >= a && c >= b);
22         return c;
23     }
24 
25     // ------------------------------------------------------------------------
26     // Subtract a number from another number, checking for underflows
27     // ------------------------------------------------------------------------
28     function sub(uint a, uint b) internal returns (uint) {
29         assert(b <= a);
30         return a - b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // Owned contract
37 // ----------------------------------------------------------------------------
38 contract Owned {
39     address public owner;
40     address public newOwner;
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     function Owned() {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         if (msg.sender != owner) throw;
49         _;
50     }
51 
52     function transferOwnership(address _newOwner) onlyOwner {
53         newOwner = _newOwner;
54     }
55  
56     function acceptOwnership() {
57         if (msg.sender == newOwner) {
58             OwnershipTransferred(owner, newOwner);
59             owner = newOwner;
60         }
61     }
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // ERC20 Token, with the addition of symbol, name and decimals
67 // https://github.com/ethereum/EIPs/issues/20
68 // ----------------------------------------------------------------------------
69 contract ERC20Token is Owned {
70     using SafeMath for uint;
71 
72     // ------------------------------------------------------------------------
73     // Total Supply
74     // ------------------------------------------------------------------------
75     uint256 _totalSupply = 0;
76 
77     // ------------------------------------------------------------------------
78     // Balances for each account
79     // ------------------------------------------------------------------------
80     mapping(address => uint256) balances;
81 
82     // ------------------------------------------------------------------------
83     // Owner of account approves the transfer of an amount to another account
84     // ------------------------------------------------------------------------
85     mapping(address => mapping (address => uint256)) allowed;
86 
87     // ------------------------------------------------------------------------
88     // Get the total token supply
89     // ------------------------------------------------------------------------
90     function totalSupply() constant returns (uint256 totalSupply) {
91         totalSupply = _totalSupply;
92     }
93 
94     // ------------------------------------------------------------------------
95     // Get the account balance of another account with address _owner
96     // ------------------------------------------------------------------------
97     function balanceOf(address _owner) constant returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     // ------------------------------------------------------------------------
102     // Transfer the balance from owner's account to another account
103     // ------------------------------------------------------------------------
104     function transfer(address _to, uint256 _amount) returns (bool success) {
105         if (balances[msg.sender] >= _amount                // User has balance
106             && _amount > 0                                 // Non-zero transfer
107             && balances[_to] + _amount > balances[_to]     // Overflow check
108         ) {
109             balances[msg.sender] = balances[msg.sender].sub(_amount);
110             balances[_to] = balances[_to].add(_amount);
111             Transfer(msg.sender, _to, _amount);
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     // ------------------------------------------------------------------------
119     // Allow _spender to withdraw from your account, multiple times, up to the
120     // _value amount. If this function is called again it overwrites the
121     // current allowance with _value.
122     // ------------------------------------------------------------------------
123     function approve(
124         address _spender,
125         uint256 _amount
126     ) returns (bool success) {
127         allowed[msg.sender][_spender] = _amount;
128         Approval(msg.sender, _spender, _amount);
129         return true;
130     }
131 
132     // ------------------------------------------------------------------------
133     // Spender of tokens transfer an amount of tokens from the token owner's
134     // balance to the spender's account. The owner of the tokens must already
135     // have approve(...)-d this transfer
136     // ------------------------------------------------------------------------
137     function transferFrom(
138         address _from,
139         address _to,
140         uint256 _amount
141     ) returns (bool success) {
142         if (balances[_from] >= _amount                  // From a/c has balance
143             && allowed[_from][msg.sender] >= _amount    // Transfer approved
144             && _amount > 0                              // Non-zero transfer
145             && balances[_to] + _amount > balances[_to]  // Overflow check
146         ) {
147             balances[_from] = balances[_from].sub(_amount);
148             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
149             balances[_to] = balances[_to].add(_amount);
150             Transfer(_from, _to, _amount);
151             return true;
152         } else {
153             return false;
154         }
155     }
156 
157     // ------------------------------------------------------------------------
158     // Returns the amount of tokens approved by the owner that can be
159     // transferred to the spender's account
160     // ------------------------------------------------------------------------
161     function allowance(
162         address _owner, 
163         address _spender
164     ) constant returns (uint256 remaining) {
165         return allowed[_owner][_spender];
166     }
167 
168     event Transfer(address indexed _from, address indexed _to, uint256 _value);
169     event Approval(address indexed _owner, address indexed _spender,
170         uint256 _value);
171 }
172 
173 
174 contract DaoCasinoToken is ERC20Token {
175 
176     // ------------------------------------------------------------------------
177     // Token information
178     // ------------------------------------------------------------------------
179     string public constant symbol = "BET";
180     string public constant name = "Dao.Casino";
181     uint8 public constant decimals = 18;
182 
183     // Do not use `now` here
184     uint256 public STARTDATE;
185     uint256 public ENDDATE;
186 
187     // Cap USD 25mil @ 296.1470 ETH/USD
188     uint256 public CAP;
189 
190     // Cannot have a constant address here - Solidity bug
191     // https://github.com/ethereum/solidity/issues/2441
192     address public multisig;
193 
194     function DaoCasinoToken(uint256 _start, uint256 _end, uint256 _cap, address _multisig) {
195         STARTDATE = _start;
196         ENDDATE   = _end;
197         CAP       = _cap;
198         multisig  = _multisig;
199     }
200 
201     // > new Date("2017-06-29T13:00:00").getTime()/1000
202     // 1498741200
203 
204     uint256 public totalEthers;
205 
206     // ------------------------------------------------------------------------
207     // Tokens per ETH
208     // Day  1    : 2,000 BET = 1 Ether
209     // Days 2–14 : 1,800 BET = 1 Ether
210     // Days 15–17: 1,700 BET = 1 Ether
211     // Days 18–20: 1,600 BET = 1 Ether
212     // Days 21–23: 1,500 BET = 1 Ether
213     // Days 24–26: 1,400 BET = 1 Ether
214     // Days 27–28: 1,300 BET = 1 Ether
215     // ------------------------------------------------------------------------
216     function buyPrice() constant returns (uint256) {
217         return buyPriceAt(now);
218     }
219 
220     function buyPriceAt(uint256 at) constant returns (uint256) {
221         if (at < STARTDATE) {
222             return 0;
223         } else if (at < (STARTDATE + 1 days)) {
224             return 2000;
225         } else if (at < (STARTDATE + 15 days)) {
226             return 1800;
227         } else if (at < (STARTDATE + 18 days)) {
228             return 1700;
229         } else if (at < (STARTDATE + 21 days)) {
230             return 1600;
231         } else if (at < (STARTDATE + 24 days)) {
232             return 1500;
233         } else if (at < (STARTDATE + 27 days)) {
234             return 1400;
235         } else if (at <= ENDDATE) {
236             return 1300;
237         } else {
238             return 0;
239         }
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Buy tokens from the contract
245     // ------------------------------------------------------------------------
246     function () payable {
247         proxyPayment(msg.sender);
248     }
249 
250 
251     // ------------------------------------------------------------------------
252     // Exchanges can buy on behalf of participant
253     // ------------------------------------------------------------------------
254     function proxyPayment(address participant) payable {
255         // No contributions before the start of the crowdsale
256         require(now >= STARTDATE);
257         // No contributions after the end of the crowdsale
258         require(now <= ENDDATE);
259         // No 0 contributions
260         require(msg.value > 0);
261 
262         // Add ETH raised to total
263         totalEthers = totalEthers.add(msg.value);
264         // Cannot exceed cap
265         require(totalEthers <= CAP);
266 
267         // What is the BET to ETH rate
268         uint256 _buyPrice = buyPrice();
269 
270         // Calculate #BET - this is safe as _buyPrice is known
271         // and msg.value is restricted to valid values
272         uint tokens = msg.value * _buyPrice;
273 
274         // Check tokens > 0
275         require(tokens > 0);
276         // Compute tokens for foundation 30%
277         // Number of tokens restricted so maths is safe
278         uint multisigTokens = tokens * 3 / 7;
279 
280         // Add to total supply
281         _totalSupply = _totalSupply.add(tokens);
282         _totalSupply = _totalSupply.add(multisigTokens);
283 
284         // Add to balances
285         balances[participant] = balances[participant].add(tokens);
286         balances[multisig] = balances[multisig].add(multisigTokens);
287 
288         // Log events
289         TokensBought(participant, msg.value, totalEthers, tokens,
290             multisigTokens, _totalSupply, _buyPrice);
291         Transfer(0x0, participant, tokens);
292         Transfer(0x0, multisig, multisigTokens);
293 
294         // Move the funds to a safe wallet
295         multisig.transfer(msg.value);
296     }
297     event TokensBought(address indexed buyer, uint256 ethers, 
298         uint256 newEtherBalance, uint256 tokens, uint256 multisigTokens, 
299         uint256 newTotalSupply, uint256 buyPrice);
300 
301 
302     // ------------------------------------------------------------------------
303     // Owner to add precommitment funding token balance before the crowdsale
304     // commences
305     // ------------------------------------------------------------------------
306     function addPrecommitment(address participant, uint balance) onlyOwner {
307         require(now < STARTDATE);
308         require(balance > 0);
309         balances[participant] = balances[participant].add(balance);
310         _totalSupply = _totalSupply.add(balance);
311         Transfer(0x0, participant, balance);
312     }
313 
314 
315     // ------------------------------------------------------------------------
316     // Transfer the balance from owner's account to another account, with a
317     // check that the crowdsale is finalised
318     // ------------------------------------------------------------------------
319     function transfer(address _to, uint _amount) returns (bool success) {
320         // Cannot transfer before crowdsale ends or cap reached
321         require(now > ENDDATE || totalEthers == CAP);
322         // Standard transfer
323         return super.transfer(_to, _amount);
324     }
325 
326 
327     // ------------------------------------------------------------------------
328     // Spender of tokens transfer an amount of tokens from the token owner's
329     // balance to another account, with a check that the crowdsale is
330     // finalised
331     // ------------------------------------------------------------------------
332     function transferFrom(address _from, address _to, uint _amount) 
333         returns (bool success)
334     {
335         // Cannot transfer before crowdsale ends or cap reached
336         require(now > ENDDATE || totalEthers == CAP);
337         // Standard transferFrom
338         return super.transferFrom(_from, _to, _amount);
339     }
340 
341 
342     // ------------------------------------------------------------------------
343     // Owner can transfer out any accidentally sent ERC20 tokens
344     // ------------------------------------------------------------------------
345     function transferAnyERC20Token(address tokenAddress, uint amount)
346       onlyOwner returns (bool success) 
347     {
348         return ERC20Token(tokenAddress).transfer(owner, amount);
349     }
350 }