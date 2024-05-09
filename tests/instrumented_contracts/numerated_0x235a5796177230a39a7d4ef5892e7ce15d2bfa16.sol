1 pragma solidity ^0.4.13;
2 contract SafeMath {
3 
4     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5         uint256 z = x + y;
6         assert((z >= x) && (z >= y));
7         return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
11         assert(x >= y);
12         uint256 z = x - y;
13         return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
17         uint256 z = x * y;
18         assert((x == 0)||(z/x == y));
19         return z;
20     }
21 }
22 
23 contract Token {
24     uint256 public totalSupply;
25 
26     function balanceOf(address _owner) constant returns (uint256 balance);
27     function transfer(address _to, uint256 _value) returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29     function approve(address _spender, uint256 _value) returns (bool success);
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 /*  ERC 20 token */
37 contract StandardToken is Token, SafeMath {
38 
39     mapping (address => uint256) balances;
40     mapping (address => mapping (address => uint256)) allowed;
41 
42     modifier onlyPayloadSize(uint numwords) {
43         assert(msg.data.length == numwords * 32 + 4);
44         _;
45     }
46 
47     function transfer(address _to, uint256 _value)
48     returns (bool success)
49     {
50         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
51             balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
52             balances[_to] = safeAdd(balances[_to], _value);
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else {
56             return false;
57         }
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value)
61     returns (bool success)
62     {
63         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
64             balances[_to] = safeAdd(balances[_to], _value);
65             balances[_from] = safeSubtract(balances[_from], _value);
66             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
67             Transfer(_from, _to, _value);
68             return true;
69         } else {
70             return false;
71         }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value)
79     onlyPayloadSize(2)
80     returns (bool success)
81     {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender)
88     constant
89     onlyPayloadSize(2)
90     returns (uint256 remaining)
91     {
92         return allowed[_owner][_spender];
93     }
94 }
95 contract PrivateCityTokens {
96     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
97 }
98 
99 
100 contract PCXToken is StandardToken {
101 
102     // Token metadata
103 	string public name = "PRIVATE CITY TOKENS EXCHANGE";
104 	string public symbol = "PCTX";
105     uint256 public constant decimals = 18;
106 
107     // Deposit address of account controlled by the creators
108     address public ethFundDeposit = 0xFEfC687c084E6A77322519BEc3A9107640905445;
109     address public tokenExchangeAddress = 0x0d2d64c2c4ba21d08252661c3ca159982579b640;
110     address public tokenAccountAddress = 0xFEfC687c084E6A77322519BEc3A9107640905445;
111     //Access to token contract for vibe exchange
112     PrivateCityTokens public tokenExchange;
113 
114     // Fundraising parameters
115     enum ContractState { Fundraising, Finalized, Redeeming, Paused }
116     ContractState public state;           // Current state of the contract
117     ContractState private savedState;     // State of the contract before pause
118 
119     //start date: 08/07/2017 @ 12:00am (UTC)
120     uint public startDate = 1506521932;
121     //start date: 09/21/2017 @ 11:59pm (UTC)
122     uint public endDate = 1506635111;
123     
124     uint256 public constant ETH_RECEIVED_MIN = 0;//1 * 10**decimals; // 0 ETH
125     uint256 public constant TOKEN_MIN = 1 * 10**decimals; // 1 VIBEX
126 
127     // We need to keep track of how much ether have been contributed, since we have a cap for ETH too
128     uint256 public totalReceivedEth = 0;
129 
130     // Since we have different exchange rates at different stages, we need to keep track
131     // of how much ether each contributed in case that we need to issue a refund
132     mapping (address => uint256) private ethBalances;
133 	
134 
135     modifier isFinalized() {
136         require(state == ContractState.Finalized);
137         _;
138     }
139 
140     modifier isFundraising() {
141         require(state == ContractState.Fundraising);
142         _;
143     }
144 
145     modifier isRedeeming() {
146         require(state == ContractState.Redeeming);
147         _;
148     }
149 
150     modifier isPaused() {
151         require(state == ContractState.Paused);
152         _;
153     }
154 
155     modifier notPaused() {
156         require(state != ContractState.Paused);
157         _;
158     }
159 
160     modifier isFundraisingIgnorePaused() {
161         require(state == ContractState.Fundraising || (state == ContractState.Paused && savedState == ContractState.Fundraising));
162         _;
163     }
164 
165     modifier onlyOwner() {
166         require(msg.sender == ethFundDeposit);
167         _;
168     }
169 
170     modifier minimumReached() {
171         require(totalReceivedEth >= ETH_RECEIVED_MIN);
172         _;
173     }
174 
175     // Constructor
176     function PCXToken()
177     {
178         // Contract state
179         state = ContractState.Fundraising;
180         savedState = ContractState.Fundraising;
181         tokenExchange = PrivateCityTokens(tokenExchangeAddress);
182         totalSupply = 0;
183     }
184 
185     // Overridden method to check for end of fundraising before allowing transfer of tokens
186     function transfer(address _to, uint256 _value)
187     isFinalized // Only allow token transfer after the fundraising has ended
188     onlyPayloadSize(2)
189     returns (bool success)
190     {
191         return super.transfer(_to, _value);
192     }
193 
194 
195     // Overridden method to check for end of fundraising before allowing transfer of tokens
196     function transferFrom(address _from, address _to, uint256 _value)
197     isFinalized // Only allow token transfer after the fundraising has ended
198     onlyPayloadSize(3)
199     returns (bool success)
200     {
201         return super.transferFrom(_from, _to, _value);
202     }
203     
204     /// @dev Accepts ether and creates new VIBEX tokens
205     function ()
206     payable
207     external
208     isFundraising
209     {
210         require(now >= startDate);
211         require(now <= endDate);
212         require(msg.value > 0);
213         
214 
215         // First we check the ETH cap, as it's easier to calculate, return
216         // the contribution if the cap has been reached already
217         uint256 checkedReceivedEth = safeAdd(totalReceivedEth, msg.value);
218 
219         // If all is fine with the ETH cap, we continue to check the
220         // minimum amount of tokens
221         uint256 tokens = safeMult(msg.value, getCurrentTokenPrice());
222         require(tokens >= TOKEN_MIN);
223 
224         // Only when all the checks have passed, then we update the state (ethBalances,
225         // totalReceivedEth, totalSupply, and balances) of the contract
226         ethBalances[msg.sender] = safeAdd(ethBalances[msg.sender], msg.value);
227         totalReceivedEth = checkedReceivedEth;
228         totalSupply = safeAdd(totalSupply, tokens);
229         balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
230         
231         // Send the ETH to Vibehub Creators
232         ethFundDeposit.transfer(msg.value);
233 
234     }
235 
236 
237     /// @dev Returns the current token price
238     function getCurrentTokenPrice()
239     private
240     constant
241     returns (uint256 currentPrice)
242     {
243         return 100;//bonuses are not implied!
244     }
245 
246 
247     /// @dev Redeems VIBEs and records the Vibehub address of the sender
248     function redeemTokens()
249     external
250     isRedeeming
251     {
252         uint256 vibeVal = balances[msg.sender];
253         require(vibeVal >= TOKEN_MIN); // At least TOKEN_MIN tokens have to be redeemed
254 
255         // Move the tokens of the caller to Vibehub's address
256         //if (!super.transfer(ethFundDeposit, vibeVal)) revert();
257         balances[msg.sender]=0;
258         
259         uint256 exchangeRate = ((160200000* 10**decimals)/totalSupply);
260         uint256 numTokens = safeMult(exchangeRate, vibeVal); // Extra safe
261         if(!tokenExchange.transferFrom(tokenAccountAddress, msg.sender, numTokens)) revert();
262 
263     }
264 
265 
266 
267 
268     /// @dev Ends the fundraising period and sends the ETH to the ethFundDeposit wallet
269     function finalize()
270     external
271     isFundraising
272     minimumReached
273     onlyOwner // Only the owner of the ethFundDeposit address can finalize the contract
274     {
275         // Move the contract to Finalized state
276         state = ContractState.Finalized;
277         savedState = ContractState.Finalized;
278     }
279 
280 
281     /// @dev Starts the redeeming period
282     function startRedeeming()
283     external
284     isFinalized // The redeeming period can only be started after the contract is finalized
285     onlyOwner   // Only the owner of the ethFundDeposit address can start the redeeming period
286     {
287         // Move the contract to Redeeming state
288         state = ContractState.Redeeming;
289         savedState = ContractState.Redeeming;
290     }
291 
292 
293     /// @dev Pauses the contract
294     function pause()
295     external
296     notPaused   // Prevent the contract getting stuck in the Paused state
297     onlyOwner   // Only the owner of the ethFundDeposit address can pause the contract
298     {
299         // Move the contract to Paused state
300         savedState = state;
301         state = ContractState.Paused;
302     }
303 
304 
305     /// @dev Proceeds with the contract
306     function proceed()
307     external
308     isPaused
309     onlyOwner   // Only the owner of the ethFundDeposit address can proceed with the contract
310     {
311         // Move the contract to the previous state
312         state = savedState;
313     }
314 
315 }