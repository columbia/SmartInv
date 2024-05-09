1 pragma solidity ^0.4.4;
2 
3 
4 /// @title Bitplus Token (BPNT) - crowdfunding code for Bitplus Project
5 contract BitplusToken {
6     string public constant name = "Bitplus Token";
7     string public constant symbol = "BPNT";
8     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
9 
10     uint256 public constant tokenCreationRate = 1000;
11 
12     // The funding cap in weis.
13     uint256 public constant tokenCreationCap = 25000 ether * tokenCreationRate;
14     uint256 public constant tokenCreationMin = 2500 ether * tokenCreationRate;
15 
16     uint256 public fundingStartBlock;
17     uint256 public fundingEndBlock;
18 
19     // The flag indicates if the contract is in Funding state.
20     bool public funding = true;
21 
22     // Receives ETH
23     address public bitplusAddress;
24 
25     // The current total token supply.
26     uint256 totalTokens;
27 
28     mapping (address => uint256) balances;
29     
30     // Owner of account approves the transfer of an amount to another account
31     mapping(address => mapping (address => uint256)) allowed;
32     
33     struct EarlyBackerCondition {
34         address backerAddress;
35         uint256 deposited;
36         uint256 agreedPercentage;
37         uint256 agreedEthPrice;
38     }
39     
40     EarlyBackerCondition[] public earlyBackers;
41     
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Refund(address indexed _from, uint256 _value);
44     event EarlyBackerDeposit(address indexed _from, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint _value);
46 
47     function BitplusToken(uint256 _fundingStartBlock,
48                           uint256 _fundingEndBlock) {
49 
50         address _bitplusAddress = 0x286e0060d9DBEa0231389485D455A80f14648B3c;
51         if (_bitplusAddress == 0) throw;
52         if (_fundingStartBlock <= block.number) throw;
53         if (_fundingEndBlock   <= _fundingStartBlock) throw;
54         
55         // special conditions for the early backers
56         earlyBackers.push(EarlyBackerCondition({
57             backerAddress: 0xa1cfc9ebdffbffe9b27d741ae04cfc2e78af527a,
58             deposited: 0,
59             agreedPercentage: 1000,
60             agreedEthPrice: 250 ether
61         }));
62         
63         // conditions for the company / developers
64         earlyBackers.push(EarlyBackerCondition({
65             backerAddress: 0x37ef1168252f274D4cA5b558213d7294085BCA08,
66             deposited: 0,
67             agreedPercentage: 500,
68             agreedEthPrice: 0.1 ether
69         }));
70         
71         earlyBackers.push(EarlyBackerCondition({
72             backerAddress: 0x246604643ac38e96526b66ba91c1b2ec0c39d8de,
73             deposited: 0,
74             agreedPercentage: 500,
75             agreedEthPrice: 0.1 ether
76         }));        
77         
78         bitplusAddress = _bitplusAddress;
79         fundingStartBlock = _fundingStartBlock;
80         fundingEndBlock = _fundingEndBlock;
81     }
82 
83     /// @notice Transfer `_value` BPNT tokens from sender's account
84     /// `msg.sender` to provided account address `_to`.
85     /// @notice This function is disabled during the funding.
86     /// @dev Required state: Operational
87     /// @param _to The address of the tokens recipient
88     /// @param _value The amount of token to be transferred
89     /// @return Whether the transfer was successful or not
90     function transfer(address _to, uint256 _value) returns (bool) {
91         // Abort if not in Operational state.
92         if (funding) throw;
93 
94         var senderBalance = balances[msg.sender];
95         if (senderBalance >= _value && _value > 0) {
96             senderBalance -= _value;
97             balances[msg.sender] = senderBalance;
98             balances[_to] += _value;
99             Transfer(msg.sender, _to, _value);
100             return true;
101         }
102         return false;
103     }
104     
105     function transferFrom(
106          address _from,
107          address _to,
108          uint256 _amount
109      ) returns (bool success) {
110         // Abort if not in Operational state.
111         if (funding) throw;         
112          
113          if (balances[_from] >= _amount
114              && allowed[_from][msg.sender] >= _amount
115              && _amount > 0) {
116              balances[_from] -= _amount;
117              allowed[_from][msg.sender] -= _amount;
118              balances[_to] += _amount;
119              return true;
120          } else {
121              return false;
122          }
123     }    
124 
125     function totalSupply() external constant returns (uint256) {
126         return totalTokens;
127     }
128 
129     function balanceOf(address _owner) external constant returns (uint256) {
130         return balances[_owner];
131     }
132 
133     /// @notice Create tokens when funding is active.
134     /// @dev Required state: Funding Active
135     /// @dev State transition: -> Funding Success (only if cap reached)
136     function create() payable external {
137         // Abort if not in Funding Active state.
138         // The checks are split (instead of using or operator) because it is
139         // cheaper this way.
140         if (!funding) throw;
141         if (block.number < fundingStartBlock) throw;
142         if (block.number > fundingEndBlock) throw;
143 
144         // Do not allow creating 0 tokens.
145         if (msg.value == 0) throw;
146         
147         bool isEarlyBacker = false;
148         
149         for (uint i = 0; i < earlyBackers.length; i++) {
150             if(earlyBackers[i].backerAddress == msg.sender) {
151                 earlyBackers[i].deposited += msg.value;
152                 isEarlyBacker = true;
153                 EarlyBackerDeposit(msg.sender, msg.value);
154             }
155         }
156         
157         
158         if(!isEarlyBacker) {
159             // do not allow to create more then cap tokens
160             if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
161                 throw;
162 
163             var numTokens = msg.value * tokenCreationRate;
164             totalTokens += numTokens;
165 
166             // Assign new tokens to the sender
167             balances[msg.sender] += numTokens;
168             
169             // Log token creation event
170             Transfer(0, msg.sender, numTokens);            
171         }
172     }
173 
174     /// @notice Finalize crowdfunding
175     /// @dev If cap was reached or crowdfunding has ended then:
176     /// create BPNT for the early backers,
177     /// transfer ETH to the Bitplus address.
178     /// @dev Required state: Funding Success
179     /// @dev State transition: -> Operational Normal
180     function finalize() external {
181         // Abort if not in Funding Success state.
182         if (!funding) throw;
183         if ((block.number <= fundingEndBlock ||
184              totalTokens < tokenCreationMin) &&
185              totalTokens < tokenCreationCap) throw;
186 
187         // Switch to Operational state. This is the only place this can happen.
188         funding = false;
189         // Transfer ETH to the Bitplus address.
190         if (!bitplusAddress.send(this.balance)) throw;
191         
192         for (uint i = 0; i < earlyBackers.length; i++) {
193             if(earlyBackers[i].deposited != uint256(0)) {
194                 uint256 percentage = (earlyBackers[i].deposited * earlyBackers[i].agreedPercentage / earlyBackers[i].agreedEthPrice);
195                 uint256 additionalTokens = totalTokens * percentage / (10000 - percentage);
196                 address backerAddr = earlyBackers[i].backerAddress;
197                 balances[backerAddr] = additionalTokens;
198                 totalTokens += additionalTokens;
199                 Transfer(0, backerAddr, additionalTokens);
200 			}
201         }
202     }
203 
204     /// @notice Get back the ether sent during the funding in case the funding
205     /// has not reached the minimum level.
206     /// @dev Required state: Funding Failure
207     function refund() external {
208         // Abort if not in Funding Failure state.
209         if (!funding) throw;
210         if (block.number <= fundingEndBlock) throw;
211         if (totalTokens >= tokenCreationMin) throw;
212         
213         bool isEarlyBacker = false;
214         uint256 ethValue;
215         for (uint i = 0; i < earlyBackers.length; i++) {
216             if(earlyBackers[i].backerAddress == msg.sender) {
217                 isEarlyBacker = true;
218                 ethValue = earlyBackers[i].deposited;
219                 if (ethValue == 0) throw;
220             }
221         }
222 
223         if(!isEarlyBacker) {
224             var bpntValue = balances[msg.sender];
225             if (bpntValue == 0) throw;
226             balances[msg.sender] = 0;
227             totalTokens -= bpntValue;
228             ethValue = bpntValue / tokenCreationRate;
229         }
230         
231         Refund(msg.sender, ethValue);
232         if (!msg.sender.send(ethValue)) throw;
233     }
234     
235     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
236     // If this function is called again it overwrites the current allowance with _value.
237     function approve(address _spender, uint256 _amount) returns (bool success) {
238         allowed[msg.sender][_spender] = _amount;
239         Approval(msg.sender, _spender, _amount);
240         return true;
241     }
242     
243     // Just a safeguard for people who might invest and then loose the key
244     // If 2 weeks after an unsuccessful end of the campaign there are unclaimed
245     // funds, transfer those to Bitplus address - the funds will be returned to 
246     // respective owners from it
247     function safeguard() {
248         if(block.number > (fundingEndBlock + 71000)) {
249             if (!bitplusAddress.send(this.balance)) throw;
250         }
251     }
252 }