1 pragma solidity ^0.4.11;
2 
3 
4 
5 
6 // ----------------------------------------------------------------------------------------------
7 // @title MatchPay Token (MPY)
8 // (c) Federico Capello.
9 // ----------------------------------------------------------------------------------------------
10 
11 contract MPY {
12 
13     string public constant name = "MatchPay Token";
14     string public constant symbol = "MPY";
15     uint256 public constant decimals = 18;
16 
17     address owner;
18 
19     uint256 public fundingStartBlock;
20     uint256 public fundingEndBlock;
21 
22     mapping (address => uint256) balances;
23     mapping (address => mapping (address => uint256)) allowed;
24 
25     uint256 public constant tokenExchangeRate = 10; // 1 MPY per 0.1 ETH
26     uint256 public maxCap = 30 * (10**3) * (10**decimals); // Maximum part for offering
27     uint256 public totalSupply; // Total part for offering
28     uint256 public minCap = 10 * (10**2) * (10**decimals); // Minimum part for offering
29     uint256 public ownerTokens = 3 * (10**2) * (10**decimals);
30 
31     bool public isFinalized = false;
32 
33 
34     // Triggered when tokens are transferred
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36 
37 
38     // Triggered whenever approve(address _spender, uint256 _value) is called.
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 
42     // Triggered when _owner gets tokens
43     event MPYCreation(address indexed _owner, uint256 _value);
44 
45 
46     // Triggered when _owner gets refund
47     event MPYRefund(address indexed _owner, uint256 _value);
48 
49 
50     // -------------------------------------------------------------------------------------------
51 
52 
53     // Check if ICO is open
54     modifier is_live() { require(block.number >= fundingStartBlock && block.number <= fundingEndBlock); _; }
55 
56 
57     // Only owmer
58     modifier only_owner(address _who) { require(_who == owner); _; }
59 
60 
61     // -------------------------------------------------------------------------------------------
62 
63 
64     // safely add
65     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
66         uint256 z = x + y;
67         assert((z >= x) && (z >= y));
68         return z;
69     }
70 
71     // safely subtract
72     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
73       assert(x >= y);
74       uint256 z = x - y;
75       return z;
76     }
77 
78     // safely multiply
79     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
80       uint256 z = x * y;
81       assert((x == 0)||(z/x == y));
82       return z;
83     }
84 
85 
86     // -------------------------------------------------------------------------------------------
87 
88 
89     // Constructor
90     function MPY(
91       uint256 _fundingStartBlock,
92       uint256 _fundingEndBlock
93     ) {
94 
95         owner = msg.sender;
96 
97         fundingStartBlock = _fundingStartBlock;
98         fundingEndBlock = _fundingEndBlock;
99 
100     }
101 
102 
103     /// @notice Return the address balance
104     /// @param _owner The owner
105     function balanceOf(address _owner) constant returns (uint256) {
106       return balances[_owner];
107     }
108 
109 
110     /// @notice Transfer tokens to account
111     /// @param _to Beneficiary
112     /// @param _amount Number of tokens
113     function transfer(address _to, uint256 _amount) returns (bool success) {
114       if (balances[msg.sender] >= _amount
115           && _amount > 0
116           && balances[_to] + _amount > balances[_to]) {
117 
118               balances[msg.sender] -= _amount;
119               balances[_to] += _amount;
120 
121               Transfer(msg.sender, _to, _amount);
122 
123               return true;
124       } else {
125           return false;
126       }
127     }
128 
129 
130     /// @notice Transfer tokens on behalf of _from
131     /// @param _from From address
132     /// @param _to To address
133     /// @param _amount Amount of tokens
134     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
135       if (balances[_from] >= _amount
136           && allowed[_from][msg.sender] >= _amount
137           && _amount > 0
138           && balances[_to] + _amount > balances[_to]) {
139 
140               balances[_from] -= _amount;
141               allowed[_from][msg.sender] -= _amount;
142               balances[_to] += _amount;
143 
144               Transfer(_from, _to, _amount);
145 
146               return true;
147           } else {
148               return false;
149           }
150     }
151 
152 
153     /// @notice Approve transfer of tokens on behalf of _from
154     /// @param _spender Whom to approve
155     /// @param _amount For how many tokens
156     function approve(address _spender, uint256 _amount) returns (bool success) {
157       allowed[msg.sender][_spender] = _amount;
158       Approval(msg.sender, _spender, _amount);
159       return true;
160     }
161 
162 
163     /// @notice Find allowance
164     /// @param _owner The owner
165     /// @param _spender The approved spender
166     function allowance(address _owner, address _spender) constant returns (uint256) {
167         return allowed[_owner][_spender];
168     }
169 
170 
171     // -------------------------------------------------------------------------------------------
172 
173 
174     function getStats() constant returns (uint256, uint256, uint256, uint256) {
175         return (minCap, maxCap, totalSupply, fundingEndBlock);
176     }
177 
178     function getSupply() constant returns (uint256) {
179         return totalSupply;
180     }
181 
182 
183     // -------------------------------------------------------------------------------------------
184 
185 
186     /// @notice Get Tokens: 0.1 ETH per 1 MPY token
187     function() is_live() payable {
188         if (msg.value == 0) revert();
189         if (isFinalized) revert();
190 
191         uint256 tokens = safeMult(msg.value, tokenExchangeRate);   // calculate num of tokens purchased
192         uint256 checkedSupply = safeAdd(totalSupply, tokens);      // calculate total supply if purchased
193 
194         if (maxCap < checkedSupply) revert();                         // if exceeding token max, cancel order
195 
196         totalSupply = checkedSupply;                               // update totalSupply
197         balances[msg.sender] += tokens;                            // update token balance for payer
198         MPYCreation(msg.sender, tokens);                           // logs token creation event
199     }
200 
201 
202     // generic function to pay this contract
203     function emergencyPay() external payable {}
204 
205 
206     // wrap up crowdsale after end block
207     function finalize() external {
208         if (msg.sender != owner) revert();                                         // check caller is ETH deposit address
209         if (totalSupply < minCap) revert();                                        // check minimum is met
210         if (block.number <= fundingEndBlock && totalSupply < maxCap) revert();     // check past end block unless at creation cap
211 
212         if (!owner.send(this.balance)) revert();                                   // send account balance to ETH deposit address
213 
214         balances[owner] += ownerTokens;
215         totalSupply += ownerTokens;
216 
217         isFinalized = true;                                                     // update crowdsale state to true
218     }
219 
220 
221     // legacy code to enable refunds if min token supply not met (not possible with fixed supply)
222     function refund() external {
223         if (isFinalized) revert();                               // check crowdsale state is false
224         if (block.number <= fundingEndBlock) revert();           // check crowdsale still running
225         if (totalSupply >= minCap) revert();                     // check creation min was not met
226         if (msg.sender == owner) revert();                       // do not allow dev refund
227 
228         uint256 mpyVal = balances[msg.sender];                // get callers token balance
229         if (mpyVal == 0) revert();                               // check caller has tokens
230 
231         balances[msg.sender] = 0;                             // set callers tokens to zero
232         totalSupply = safeSubtract(totalSupply, mpyVal);      // subtract callers balance from total supply
233         uint256 ethVal = mpyVal / tokenExchangeRate;          // calculate ETH from token exchange rate
234         MPYRefund(msg.sender, ethVal);                        // log refund event
235 
236         if (!msg.sender.send(ethVal)) revert();                  // send caller their refund
237     }
238 }