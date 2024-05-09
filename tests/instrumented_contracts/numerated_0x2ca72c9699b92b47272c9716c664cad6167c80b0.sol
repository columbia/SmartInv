1 pragma solidity ^0.4.11;
2 
3 /*
4     Copyright 2017, Shaun Shull
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 /// @title GUNS Crowdsale Contract - GeoFounders.com
21 /// @author Shaun Shull
22 /// @dev Simple single crowdsale contract for fixed supply, single-rate, 
23 ///  block-range crowdsale. Additional token cleanup functionality.
24 
25 
26 /// @dev Generic ERC20 Token Interface, totalSupply made to var for compiler
27 contract Token {
28     uint256 public totalSupply;
29     function balanceOf(address _owner) constant returns (uint256 balance);
30     function transfer(address _to, uint256 _value) returns (bool success);
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32     function approve(address _spender, uint256 _value) returns (bool success);
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 
39 /// @dev ERC20 Standard Token Contract
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         if (balances[msg.sender] >= _value && _value > 0) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             Transfer(msg.sender, _to, _value);
47             return true;
48         } else {
49             return false;
50         }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
55             balances[_to] += _value;
56             balances[_from] -= _value;
57             allowed[_from][msg.sender] -= _value;
58             Transfer(_from, _to, _value);
59             return true;
60         } else {
61             return false;
62         }
63     }
64 
65     function balanceOf(address _owner) constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77     }
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81 }
82 
83 
84 /// @dev Primary Token Contract
85 contract GUNS is StandardToken {
86 
87     // metadata
88     string public constant name = "GeoUnits";
89     string public constant symbol = "GUNS";
90     uint256 public constant decimals = 18;
91     string public version = "1.0";
92 
93     // contracts
94     address public hostAccount;       // address that kicks off the crowdsale
95     address public ethFundDeposit;    // deposit address for ETH for GeoFounders
96     address public gunsFundDeposit;   // deposit address for GeoFounders Tokens - GeoUnits (GUNS)
97 
98     // crowdsale parameters
99     bool public isFinalized;                                                      // false until crowdsale finalized
100     uint256 public fundingStartBlock;                                             // start block
101     uint256 public fundingEndBlock;                                               // end block
102     uint256 public constant gunsFund = 35 * (10**6) * 10**decimals;               // 35m GUNS reserved for devs
103     uint256 public constant tokenExchangeRate = 1000;                             // 1000 GUNS per 1 ETH
104     uint256 public constant tokenCreationCap =  100 * (10**6) * 10**decimals;     // 100m GUNS fixed supply
105     uint256 public constant tokenCreationMin =  1 * (10**6) * 10**decimals;       // 1m minimum must be in supply (legacy code)
106 
107     // events
108     event LogRefund(address indexed _to, uint256 _value);   // event for refund
109     event CreateGUNS(address indexed _to, uint256 _value);  // event for token creation
110 
111     // safely add
112     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
113         uint256 z = x + y;
114         assert((z >= x) && (z >= y));
115         return z;
116     }
117 
118     // safely subtract
119     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
120       assert(x >= y);
121       uint256 z = x - y;
122       return z;
123     }
124 
125     // safely multiply
126     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
127       uint256 z = x * y;
128       assert((x == 0)||(z/x == y));
129       return z;
130     }
131 
132     // constructor
133     function GUNS() {}
134 
135     // initialize deployed contract
136     function initialize(
137         address _ethFundDeposit,
138         address _gunsFundDeposit,
139         uint256 _fundingStartBlock,
140         uint256 _fundingEndBlock
141     ) public {
142         require(address(hostAccount) == 0x0);     // one time initialize
143         hostAccount = msg.sender;                 // assign initializer var
144         isFinalized = false;                      // crowdsale state
145         ethFundDeposit = _ethFundDeposit;         // set final ETH deposit address
146         gunsFundDeposit = _gunsFundDeposit;       // set final GUNS dev deposit address
147         fundingStartBlock = _fundingStartBlock;   // block number to start crowdsale
148         fundingEndBlock = _fundingEndBlock;       // block number to end crowdsale
149         totalSupply = gunsFund;                   // update totalSupply to reserve
150         balances[gunsFundDeposit] = gunsFund;     // deposit reserve tokens to dev address
151         CreateGUNS(gunsFundDeposit, gunsFund);    // logs token creation event
152     }
153 
154     // enable people to pay contract directly
155     function () public payable {
156         require(address(hostAccount) != 0x0);                      // initialization check
157 
158         if (isFinalized) throw;                                    // crowdsale state check
159         if (block.number < fundingStartBlock) throw;               // within start block check
160         if (block.number > fundingEndBlock) throw;                 // within end block check
161         if (msg.value == 0) throw;                                 // person actually sent ETH check
162 
163         uint256 tokens = safeMult(msg.value, tokenExchangeRate);   // calculate num of tokens purchased
164         uint256 checkedSupply = safeAdd(totalSupply, tokens);      // calculate total supply if purchased
165 
166         if (tokenCreationCap < checkedSupply) throw;               // if exceeding token max, cancel order
167 
168         totalSupply = checkedSupply;                               // update totalSupply
169         balances[msg.sender] += tokens;                            // update token balance for payer
170         CreateGUNS(msg.sender, tokens);                            // logs token creation event
171     }
172 
173     // generic function to pay this contract
174     function emergencyPay() external payable {}
175 
176     // wrap up crowdsale after end block
177     function finalize() external {
178         //if (isFinalized) throw;                                                        // check crowdsale state is false
179         if (msg.sender != ethFundDeposit) throw;                                         // check caller is ETH deposit address
180         //if (totalSupply < tokenCreationMin) throw;                                     // check minimum is met
181         if (block.number <= fundingEndBlock && totalSupply < tokenCreationCap) throw;    // check past end block unless at creation cap
182 
183         if (!ethFundDeposit.send(this.balance)) throw;                                   // send account balance to ETH deposit address
184         
185         uint256 remainingSupply = safeSubtract(tokenCreationCap, totalSupply);           // calculate remaining tokens to reach fixed supply
186         if (remainingSupply > 0) {                                                       // if remaining supply left
187             uint256 updatedSupply = safeAdd(totalSupply, remainingSupply);               // calculate total supply with remaining supply
188             totalSupply = updatedSupply;                                                 // update totalSupply
189             balances[gunsFundDeposit] += remainingSupply;                                // manually update devs token balance
190             CreateGUNS(gunsFundDeposit, remainingSupply);                                // logs token creation event
191         }
192 
193         isFinalized = true;                                                              // update crowdsale state to true
194     }
195 
196     // legacy code to enable refunds if min token supply not met (not possible with fixed supply)
197     function refund() external {
198         if (isFinalized) throw;                               // check crowdsale state is false
199         if (block.number <= fundingEndBlock) throw;           // check crowdsale still running
200         if (totalSupply >= tokenCreationMin) throw;           // check creation min was not met
201         if (msg.sender == gunsFundDeposit) throw;             // do not allow dev refund
202 
203         uint256 gunsVal = balances[msg.sender];               // get callers token balance
204         if (gunsVal == 0) throw;                              // check caller has tokens
205 
206         balances[msg.sender] = 0;                             // set callers tokens to zero
207         totalSupply = safeSubtract(totalSupply, gunsVal);     // subtract callers balance from total supply
208         uint256 ethVal = gunsVal / tokenExchangeRate;         // calculate ETH from token exchange rate
209         LogRefund(msg.sender, ethVal);                        // log refund event
210 
211         if (!msg.sender.send(ethVal)) throw;                  // send caller their refund
212     }
213 
214     // clean up mistaken tokens sent to this contract
215     // also check empty address for tokens and clean out
216     // (GUNS only, does not support 3rd party tokens)
217     function mistakenTokens() external {
218         if (msg.sender != ethFundDeposit) throw;                // check caller is ETH deposit address
219         
220         if (balances[this] > 0) {                               // if contract has tokens
221             Transfer(this, gunsFundDeposit, balances[this]);    // log transfer event
222             balances[gunsFundDeposit] += balances[this];        // send tokens to dev tokens address
223             balances[this] = 0;                                 // zero out contract token balance
224         }
225 
226         if (balances[0x0] > 0) {                                // if empty address has tokens
227             Transfer(0x0, gunsFundDeposit, balances[0x0]);      // log transfer event
228             balances[gunsFundDeposit] += balances[0x0];         // send tokens to dev tokens address
229             balances[0x0] = 0;                                  // zero out empty address token balance
230         }
231     }
232 
233 }