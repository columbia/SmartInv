1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4   //internals
5 
6   function safeMul(uint a, uint b) internal returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeSub(uint a, uint b) internal returns (uint) {
13     assert(b <= a);
14     return a - b;
15   }
16 
17   function safeAdd(uint a, uint b) internal returns (uint) {
18     uint c = a + b;
19     assert(c>=a && c>=b);
20     return c;
21   }
22 
23   function safeDiv(uint a, uint b) internal returns (uint) {
24       assert(b > 0);
25       uint c = a / b;
26       assert(a == b * c + a % b);
27       return c;
28   }
29 }
30 
31 // ERC 20 Token
32 // https://github.com/ethereum/EIPs/issues/20
33 
34 contract Token {
35     /* This is a slight change to the ERC20 base standard.
36     function totalSupply() constant returns (uint256 supply);
37     is replaced with:
38     uint256 public totalSupply;
39     This automatically creates a getter function for the totalSupply.
40     This is moved to the base contract since public getter functions are not
41     currently recognised as an implementation of the matching abstract
42     function by the compiler.
43     */
44     /// total amount of tokens
45     uint256 public totalSupply;
46 
47     /// @param _owner The address from which the balance will be retrieved
48     /// @return The balance
49     function balanceOf(address _owner) constant returns (uint256 balance);
50 
51     /// @notice send `_value` token to `_to` from `msg.sender`
52     /// @param _to The address of the recipient
53     /// @param _value The amount of token to be transferred
54     /// @return Whether the transfer was successful or not
55     function transfer(address _to, uint256 _value) returns (bool success);
56 
57     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
58     /// @param _from The address of the sender
59     /// @param _to The address of the recipient
60     /// @param _value The amount of token to be transferred
61     /// @return Whether the transfer was successful or not
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
63 
64     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
65     /// @param _spender The address of the account able to transfer the tokens
66     /// @param _value The amount of tokens to be approved for transfer
67     /// @return Whether the approval was successful or not
68     function approve(address _spender, uint256 _value) returns (bool success);
69 
70     /// @param _owner The address of the account owning tokens
71     /// @param _spender The address of the account able to transfer the tokens
72     /// @return Amount of remaining tokens allowed to spent
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 }
78 
79 contract StandardToken is Token {
80 
81     function transfer(address _to, uint256 _value) returns (bool success) {
82         //Default assumes totalSupply can't be over max (2^256 - 1).
83         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
84         //Replace the if with this one instead.
85         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
86         if (balances[msg.sender] >= _value && _value > 0) {
87             balances[msg.sender] -= _value;
88             balances[_to] += _value;
89             Transfer(msg.sender, _to, _value);
90             return true;
91         } else { return false; }
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         //same as above. Replace this line with the following if you want to protect against wrapping uints.
96         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
97         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
98             balances[_to] += _value;
99             balances[_from] -= _value;
100             allowed[_from][msg.sender] -= _value;
101             Transfer(_from, _to, _value);
102             return true;
103         } else { return false; }
104     }
105 
106     function balanceOf(address _owner) constant returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110     function approve(address _spender, uint256 _value) returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117       return allowed[_owner][_spender];
118     }
119 
120     mapping (address => uint256) balances;
121     mapping (address => mapping (address => uint256)) allowed;
122 }
123 
124 
125 /**
126  * MoldCoin pre-sell contract.
127  *
128  */
129 contract MoldCoin is StandardToken, SafeMath {
130 
131     string public name = "MOLD";
132     string public symbol = "MLD";
133     uint public decimals = 18;
134 
135     uint public startDatetime; //pre-sell start datetime seconds
136     uint public firstStageDatetime; //first 120 hours pre-sell in seconds
137     uint public secondStageDatetime; //second stage, 240 hours of pre-sell in seconds.
138     uint public endDatetime; //pre-sell end datetime seconds (set in constructor)
139 
140     // Initial founder address (set in constructor)
141     // All deposited ETH will be instantly forwarded to this address.
142     address public founder;
143 
144     // administrator address
145     address public admin;
146 
147     uint public coinAllocation = 20 * 10**8 * 10**decimals; //2000M tokens supply for pre-sell
148     uint public angelAllocation = 2 * 10**8 * 10**decimals; // 200M of token supply allocated angel investor
149     uint public founderAllocation = 3 * 10**8 * 10**decimals; //300M of token supply allocated for the founder allocation
150 
151     bool public founderAllocated = false; //this will change to true when the founder fund is allocated
152 
153     uint public saleTokenSupply = 0; //this will keep track of the token supply created during the pre-sell
154     uint public salesVolume = 0; //this will keep track of the Ether raised during the pre-sell
155 
156     uint public angelTokenSupply = 0; //this will keep track of the token angel supply
157 
158     bool public halted = false; //the admin address can set this to true to halt the pre-sell due to emergency
159 
160     event Buy(address indexed sender, uint eth, uint tokens);
161     event AllocateFounderTokens(address indexed sender, uint tokens);
162     event AllocateAngelTokens(address indexed sender, address to, uint tokens);
163     event AllocateUnsoldTokens(address indexed sender, address holder, uint tokens);
164 
165     modifier onlyAdmin {
166         require(msg.sender == admin);
167         _;
168     }
169 
170     modifier duringCrowdSale {
171         require(block.timestamp >= startDatetime && block.timestamp <= endDatetime);
172         _;
173     }
174 
175     /**
176      *
177      * Integer value representing the number of seconds since 1 January 1970 00:00:00 UTC
178      */
179     function MoldCoin(uint startDatetimeInSeconds, address founderWallet) {
180 
181         admin = msg.sender;
182         founder = founderWallet;
183         startDatetime = startDatetimeInSeconds;
184         firstStageDatetime = startDatetime + 120 * 1 hours;
185         secondStageDatetime = firstStageDatetime + 240 * 1 hours;
186         endDatetime = secondStageDatetime + 2040 * 1 hours;
187 
188     }
189 
190     /**
191      * Price for crowdsale by time
192      */
193     function price(uint timeInSeconds) constant returns(uint) {
194         if (timeInSeconds < startDatetime) return 0;
195         if (timeInSeconds <= firstStageDatetime) return 15000; //120 hours
196         if (timeInSeconds <= secondStageDatetime) return 12000; //240 hours
197         if (timeInSeconds <= endDatetime) return 10000; //2040 hours
198         return 0;
199     }
200 
201     /**
202      * allow anyone sends funds to the contract
203      */
204     function buy() payable {
205         buyRecipient(msg.sender);
206     }
207 
208     function() payable {
209         buyRecipient(msg.sender);
210     }
211 
212     /**
213      * Main token buy function.
214      * Buy for the sender itself or buy on the behalf of somebody else (third party address).
215      */
216     function buyRecipient(address recipient) duringCrowdSale payable {
217         require(!halted);
218 
219         uint tokens = safeMul(msg.value, price(block.timestamp));
220         require(safeAdd(saleTokenSupply,tokens)<=coinAllocation );
221 
222         balances[recipient] = safeAdd(balances[recipient], tokens);
223 
224         totalSupply = safeAdd(totalSupply, tokens);
225         saleTokenSupply = safeAdd(saleTokenSupply, tokens);
226         salesVolume = safeAdd(salesVolume, msg.value);
227 
228         if (!founder.call.value(msg.value)()) revert(); //immediately send Ether to founder address
229 
230         Buy(recipient, msg.value, tokens);
231     }
232 
233     /**
234      * Set up founder address token balance.
235      */
236     function allocateFounderTokens() onlyAdmin {
237         require( block.timestamp > endDatetime );
238         require(!founderAllocated);
239 
240         balances[founder] = safeAdd(balances[founder], founderAllocation);
241         totalSupply = safeAdd(totalSupply, founderAllocation);
242         founderAllocated = true;
243 
244         AllocateFounderTokens(msg.sender, founderAllocation);
245     }
246 
247     /**
248      * Set up angel address token balance.
249      */
250     function allocateAngelTokens(address angel, uint tokens) onlyAdmin {
251 
252         require(safeAdd(angelTokenSupply,tokens) <= angelAllocation );
253 
254         balances[angel] = safeAdd(balances[angel], tokens);
255         angelTokenSupply = safeAdd(angelTokenSupply, tokens);
256         totalSupply = safeAdd(totalSupply, tokens);
257 
258         AllocateAngelTokens(msg.sender, angel, tokens);
259     }
260 
261     /**
262      * Emergency Stop crowdsale.
263      */
264     function halt() onlyAdmin {
265         halted = true;
266     }
267 
268     function unhalt() onlyAdmin {
269         halted = false;
270     }
271 
272     /**
273      * Change admin address.
274      */
275     function changeAdmin(address newAdmin) onlyAdmin  {
276         admin = newAdmin;
277     }
278 
279     /**
280      * arrange unsold coins
281      */
282     function arrangeUnsoldTokens(address holder, uint256 tokens) onlyAdmin {
283         require( block.timestamp > endDatetime );
284         require( safeAdd(saleTokenSupply,tokens) <= coinAllocation );
285         require( balances[holder] >0 );
286 
287         balances[holder] = safeAdd(balances[holder], tokens);
288         saleTokenSupply = safeAdd(saleTokenSupply, tokens);
289         totalSupply = safeAdd(totalSupply, tokens);
290 
291         AllocateUnsoldTokens(msg.sender, holder, tokens);
292 
293     }
294 
295 }