1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------
4 // BokkyPooBah's Ether Refundable Prize
5 //
6 // A gift token backed by ethers. Designed to incentivise The DAO refund
7 // withdrawals, but can be used for any other purposes
8 //
9 // These tokens can be bought from this contract at the Buy Price.
10 //
11 // These tokens can be sold back to this contract at the Sell Price.
12 // 
13 // Period                                ETH per BERP
14 // ------------------------- ------------------------
15 // From         To               Buy Price Sell Price
16 // ------------ ------------ ------------- ----------
17 // start        +7 days             0.0010     0.0010
18 // +7 days      +30 days            0.0011     0.0010
19 // +30 days     +60 days            0.0012     0.0010
20 // +60 days     +90 days            0.0013     0.0010
21 // +90 days     +365 days           0.0015     0.0010
22 // +365 days    forever          1000.0000     0.0010
23 //
24 // Based on Vlad's Safe Token Sale Mechanism Contract
25 // - https://medium.com/@Vlad_Zamfir/a-safe-token-sale-mechanism-8d73c430ddd1
26 //
27 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
28 // ----------------------------------------------------------------------------
29 
30 contract Owned {
31     address public owner;
32     event OwnershipTransferred(address indexed _from, address indexed _to);
33 
34     function Owned() {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         if (msg.sender != owner) throw;
40         _;
41     }
42 
43     function transferOwnership(address newOwner) onlyOwner {
44         OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46     }
47 }
48 
49 
50 // ERC Token Standard #20 - https://github.com/ethereum/EIPs/issues/20
51 contract ERC20Token is Owned {
52     uint256 _totalSupply = 0;
53 
54     // Balances for each account
55     mapping(address => uint256) balances;
56 
57     // Owner of account approves the transfer of an amount to another account
58     mapping(address => mapping (address => uint256)) allowed;
59 
60     // Get the total token supply
61     function totalSupply() constant returns (uint256 totalSupply) {
62         totalSupply = _totalSupply;
63     }
64 
65     // Get the account balance of another account with address _owner
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     // Send _value amount of tokens to address _to
71     function transfer(address _to, uint256 _amount) returns (bool success) {
72         if (balances[msg.sender] >= _amount
73             && _amount > 0
74             && balances[_to] + _amount > balances[_to]) {
75             balances[msg.sender] -= _amount;
76             balances[_to] += _amount;
77             Transfer(msg.sender, _to, _amount);
78             return true;
79         } else {
80             return false;
81         }
82     }
83 
84     // Allow _spender to withdraw from your account, multiple times, up to the
85     // _value amount. If this function is called again it overwrites the
86     // current allowance with _value.
87     function approve(
88         address _spender,
89         uint256 _amount
90     ) returns (bool success) {
91         allowed[msg.sender][_spender] = _amount;
92         Approval(msg.sender, _spender, _amount);
93         return true;
94     }
95 
96     // Spender of tokens transfer an amount of tokens from the token owner's
97     // balance to the spender's account. The owner of the tokens must already
98     // have approve(...)-d this transfer
99     function transferFrom(
100         address _from,
101         address _to,
102         uint256 _amount
103     ) returns (bool success) {
104         if (balances[_from] >= _amount
105             && allowed[_from][msg.sender] >= _amount
106             && _amount > 0
107             && balances[_to] + _amount > balances[_to]) {
108             balances[_from] -= _amount;
109             allowed[_from][msg.sender] -= _amount;
110             balances[_to] += _amount;
111             Transfer(_from, _to, _amount);
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     // Returns the amount of tokens approved by the owner that can be
119     // transferred to the spender's account
120     function allowance(
121         address _owner, 
122         address _spender
123     ) constant returns (uint256 remaining) {
124         return allowed[_owner][_spender];
125     }
126 
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Approval(address indexed _owner, address indexed _spender,
129         uint256 _value);
130 }
131 
132 
133 contract BokkyPooBahsEtherRefundablePrize is ERC20Token {
134 
135     // ------------------------------------------------------------------------
136     // Token information
137     // ------------------------------------------------------------------------
138     string public constant symbol = "BERP";
139     string public constant name = "BokkyPooBah´s Ether Refundable Prize";
140     uint8 public constant decimals = 18;
141 
142     uint256 public deployedAt;
143 
144     function BokkyPooBahsEtherRefundablePrize() {
145         deployedAt = now;
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Members buy tokens from this contract at this price
151     //
152     // This is a maximum price that the tokens should be bought at, as buyers
153     // can always buy tokens from this contract for this price
154     //
155     // Check out the BERP prices on https://cryptoderivatives.market/ to see
156     // if you can buy these tokens for less than this maximum price
157     // ------------------------------------------------------------------------
158     function buyPrice() constant returns (uint256) {
159         return buyPriceAt(now);
160     }
161 
162     function buyPriceAt(uint256 at) constant returns (uint256) {
163         if (at < (deployedAt + 7 days)) {
164             return 10 * 10**14;
165         } else if (at < (deployedAt + 30 days)) {
166             return 11 * 10**14;
167         } else if (at < (deployedAt + 60 days)) {
168             return 12 * 10**15;
169         } else if (at < (deployedAt + 90 days)) {
170             return 13 * 10**15;
171         } else if (at < (deployedAt + 365 days)) {
172             return 15 * 10**16;
173         } else {
174             return 10**21;
175         }
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Members can always sell to the contract at 1 BERP = 0.001 ETH
181     //
182     // This is a minimum price that the tokens should sell for, as the owner of
183     // the token can always sell tokens to this contract at this price
184     //
185     // Check out the BERP prices on https://cryptoderivatives.market/ to see
186     // if you can sell these tokens for more than this minimum price
187     // ------------------------------------------------------------------------
188     function sellPrice() constant returns (uint256) {
189         return 10**15;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Buy tokens from the contract
195     // ------------------------------------------------------------------------
196     function () payable {
197         buyTokens();
198     }
199 
200     function buyTokens() payable {
201         if (msg.value > 0) {
202             uint tokens = msg.value * 1 ether / buyPrice();
203             _totalSupply += tokens;
204             balances[msg.sender] += tokens;
205             TokensBought(msg.sender, msg.value, this.balance, tokens,
206                  _totalSupply, buyPrice());
207         }
208     }
209     event TokensBought(address indexed buyer, uint256 ethers, 
210         uint256 newEtherBalance, uint256 tokens, uint256 newTotalSupply, 
211         uint256 buyPrice);
212 
213 
214     // ------------------------------------------------------------------------
215     // Sell tokens to the contract
216     // ------------------------------------------------------------------------
217     function sellTokens(uint256 amountOfTokens) {
218         if (amountOfTokens > balances[msg.sender]) throw;
219         balances[msg.sender] -= amountOfTokens;
220         _totalSupply -= amountOfTokens;
221         uint256 ethersToSend = amountOfTokens * sellPrice() / 1 ether;
222         if (!msg.sender.send(ethersToSend)) throw;
223         TokensSold(msg.sender, ethersToSend, this.balance, amountOfTokens,
224             _totalSupply, sellPrice());
225     }
226     event TokensSold(address indexed seller, uint256 ethers, 
227         uint256 newEtherBalance, uint256 tokens, uint256 newTotalSupply, 
228         uint256 sellPrice);
229 
230 
231     // ------------------------------------------------------------------------
232     // Receive deposits. This could be a free donation, or fees earned by
233     // a system of payments backing this contract
234     // ------------------------------------------------------------------------
235     function deposit() payable {
236         Deposited(msg.value, this.balance);
237     }
238     event Deposited(uint256 amount, uint256 balance);
239 
240 
241     // ------------------------------------------------------------------------
242     // Owner Withdrawal
243     // ------------------------------------------------------------------------
244     function ownerWithdraw(uint256 amount) onlyOwner {
245         uint256 maxWithdrawalAmount = amountOfEthersOwnerCanWithdraw();
246         if (amount > maxWithdrawalAmount) {
247             amount = maxWithdrawalAmount;
248         }
249         if (!owner.send(amount)) throw;
250         Withdrawn(amount, maxWithdrawalAmount - amount);
251     }
252     event Withdrawn(uint256 amount, uint256 remainingWithdrawal);
253 
254 
255     // ------------------------------------------------------------------------
256     // Information function
257     // ------------------------------------------------------------------------
258     function amountOfEthersOwnerCanWithdraw() constant returns (uint256) {
259         uint256 etherBalance = this.balance;
260         uint256 ethersSupportingTokens = _totalSupply * sellPrice() / 1 ether;
261         if (etherBalance > ethersSupportingTokens) {
262             return etherBalance - ethersSupportingTokens;
263         } else {
264             return 0;
265         }
266     }
267 
268     function currentEtherBalance() constant returns (uint256) {
269         return this.balance;
270     }
271 
272     function currentTokenBalance() constant returns (uint256) {
273         return _totalSupply;
274     }
275 }