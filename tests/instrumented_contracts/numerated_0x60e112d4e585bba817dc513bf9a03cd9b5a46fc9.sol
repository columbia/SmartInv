1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // BokkyPooBah's Autonomous Refundathon Facility Token Contract
5 //
6 // A system to incentivise The DAO token holders to withdraw their refunds
7 //
8 // Based on Vlad's Safe Token Sale Mechanism Contract
9 // - https://medium.com/@Vlad_Zamfir/a-safe-token-sale-mechanism-8d73c430ddd1
10 //
11 // Enjoy. (c) Bok Consulting Pty Ltd 2017. The MIT Licence.
12 // ----------------------------------------------------------------------------------------------
13 
14 
15 contract Owned {
16     address public owner;
17     event OwnershipTransferred(address indexed _from, address indexed _to);
18 
19     function Owned() {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         if (msg.sender != owner) throw;
25         _;
26     }
27 
28     function transferOwnership(address newOwner) onlyOwner {
29         OwnershipTransferred(owner, newOwner);
30         owner = newOwner;
31     }
32 }
33 
34 
35 // ERC Token Standard #20 - https://github.com/ethereum/EIPs/issues/20
36 contract ERC20Token is Owned {
37     uint256 _totalSupply = 0;
38 
39     // Balances for each account
40     mapping(address => uint256) balances;
41 
42     // Owner of account approves the transfer of an amount to another account
43     mapping(address => mapping (address => uint256)) allowed;
44 
45     // Get the total token supply
46     function totalSupply() constant returns (uint256 totalSupply) {
47         totalSupply = _totalSupply;
48     }
49 
50     // Get the account balance of another account with address _owner
51     function balanceOf(address _owner) constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55     // Send _value amount of tokens to address _to
56     function transfer(address _to, uint256 _amount) returns (bool success) {
57         if (balances[msg.sender] >= _amount
58             && _amount > 0
59             && balances[_to] + _amount > balances[_to]) {
60             balances[msg.sender] -= _amount;
61             balances[_to] += _amount;
62             Transfer(msg.sender, _to, _amount);
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
70     // If this function is called again it overwrites the current allowance with _value.
71     // this function is required for some DEX functionality
72     function approve(address _spender, uint256 _amount) returns (bool success) {
73         allowed[msg.sender][_spender] = _amount;
74         Approval(msg.sender, _spender, _amount);
75         return true;
76     }
77 
78     // Spender of tokens transfer an amount of tokens from the token owner's
79     // balance to the spender's account. The owner of the tokens must already
80     // have approve(...)-d this transfer
81     function transferFrom(
82         address _from,
83         address _to,
84         uint256 _amount
85     ) returns (bool success) {
86         if (balances[_from] >= _amount
87             && allowed[_from][msg.sender] >= _amount
88             && _amount > 0
89             && balances[_to] + _amount > balances[_to]) {
90             balances[_from] -= _amount;
91             allowed[_from][msg.sender] -= _amount;
92             balances[_to] += _amount;
93             Transfer(_from, _to, _amount);
94             return true;
95         } else {
96             return false;
97         }
98     }
99 
100     // Returns the amount of tokens approved by the owner that can be transferred
101     // to the spender's account
102     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103         return allowed[_owner][_spender];
104     }
105 
106     event Transfer(address indexed _from, address indexed _to, uint256 _value);
107     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
108 }
109 
110 
111 contract BokkyPooBahsAutonomousRefundathonFacility is ERC20Token {
112 
113     // ------ Token information ------
114     string public constant symbol = "BARF";
115     string public constant name = "BokkyPooBah Autonomous Refundathon Facility";
116     uint8 public constant decimals = 18;
117 
118     uint256 public deployedAt;
119 
120     function BokkyPooBahsAutonomousRefundathonFund() {
121         deployedAt = now;
122     }
123 
124     // Members buy tokens from this contract at this price
125     //
126     // This is a maximum price that the tokens should be bought for buyers
127     // can always buy tokens from this contract for this price
128     //
129     // Check out the BARF prices on https://cryptoderivatives.market/ to see
130     // if you can buy these tokens for less than this maximum price
131     function buyPrice() constant returns (uint256) {
132         // Members buy tokens initially at 1 BARF = 0.01 ETH
133         if (now < (deployedAt + 2 days)) {
134             return 1 * 10**16;
135         // Price increase to 1 BARF = 0.02 ETH after 2 days and before 1 week
136         } else if (now < (deployedAt + 7 days)) {
137             return 2 * 10**16;
138         // Price increase to 1 BARF = 0.04 ETH after 1 week and before 30 days
139         } else if (now < (deployedAt + 30 days)) {
140             return 4 * 10**16;
141         // Price increase to 1 BARF = 0.06 ETH after 30 days and before 60 days
142         } else if (now < (deployedAt + 60 days)) {
143             return 6 * 10**16;
144         // Price increase to 1 BARF = 0.08 ETH after 60 days and before 90 days
145         } else if (now < (deployedAt + 90 days)) {
146             return 8 * 10**16;
147         // Price increase to 1 BARF = 10 ETH after 90 days and before 365 days (1 year)
148         } else if (now < (deployedAt + 365 days)) {
149             return 1 * 10**19;
150         // Price increase to 1 BARF = 1,000 ETH after 365 days and before 3652 days (10 years)
151         } else if (now < (deployedAt + 3652 days)) {
152             return 1 * 10**22;
153         // Price increase to 1 BARF = 1,000,000 ETH after 3652 days (10 years). Effectively free floating ceiling
154         } else {
155             return 1 * 10**24;
156         }
157     }
158 
159     // Members can always sell to the contract at 1 BARF = 0.01 ETH
160     //
161     // This is a minimum price that the tokens should sell for as the owner of
162     // the token can always sell tokens to this contract at this price
163     //
164     // Check out the BARF prices on https://cryptoderivatives.market/ to see
165     // if you can sell these tokens for more than this minimum price
166     function sellPrice() constant returns (uint256) {
167         return 10**16;
168     }
169 
170     // ------ Owner Withdrawal ------
171     function amountOfEthersOwnerCanWithdraw() constant returns (uint256) {
172         uint256 etherBalance = this.balance;
173         uint256 ethersSupportingTokens = _totalSupply * sellPrice() / 1 ether;
174         if (etherBalance > ethersSupportingTokens) {
175             return etherBalance - ethersSupportingTokens;
176         } else {
177             return 0;
178         }
179     }
180 
181     function ownerWithdraw(uint256 amount) onlyOwner {
182         uint256 maxWithdrawalAmount = amountOfEthersOwnerCanWithdraw();
183         if (amount > maxWithdrawalAmount) {
184             amount = maxWithdrawalAmount;
185         }
186         if (!owner.send(amount)) throw;
187         Withdrawn(amount, maxWithdrawalAmount - amount);
188     }
189     event Withdrawn(uint256 amount, uint256 remainingWithdrawal);
190 
191 
192     // ------ Member Buy and Sell tokens below ------
193     function () payable {
194         memberBuyToken();
195     }
196 
197     function memberBuyToken() payable {
198         if (msg.value > 0) {
199             uint tokens = msg.value * 1 ether / buyPrice();
200             _totalSupply += tokens;
201             balances[msg.sender] += tokens;
202             MemberBoughtToken(msg.sender, msg.value, this.balance, tokens, _totalSupply,
203                 buyPrice());
204         }
205     }
206     event MemberBoughtToken(address indexed buyer, uint256 ethers, uint256 newEtherBalance,
207         uint256 tokens, uint256 newTotalSupply, uint256 buyPrice);
208 
209     function memberSellToken(uint256 amountOfTokens) {
210         if (amountOfTokens > balances[msg.sender]) throw;
211         balances[msg.sender] -= amountOfTokens;
212         _totalSupply -= amountOfTokens;
213         uint256 ethersToSend = amountOfTokens * sellPrice() / 1 ether;
214         if (!msg.sender.send(ethersToSend)) throw;
215         MemberSoldToken(msg.sender, ethersToSend, this.balance, amountOfTokens,
216             _totalSupply, sellPrice());
217     }
218     event MemberSoldToken(address indexed seller, uint256 ethers, uint256 newEtherBalance,
219         uint256 tokens, uint256 newTotalSupply, uint256 sellPrice);
220 
221 
222     // ------ Information function ------
223     function currentEtherBalance() constant returns (uint256) {
224         return this.balance;
225     }
226 
227     function currentTokenBalance() constant returns (uint256) {
228         return _totalSupply;
229     }
230 }