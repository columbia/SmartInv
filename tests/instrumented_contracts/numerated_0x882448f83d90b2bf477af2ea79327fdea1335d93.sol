1 contract SafeMath {
2 
3     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
4         uint256 z = x + y;
5         assert((z >= x) && (z >= y));
6         return z;
7     }
8 
9     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
10         assert(x >= y);
11         uint256 z = x - y;
12         return z;
13     }
14 
15     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
16         uint256 z = x * y;
17         assert((x == 0)||(z/x == y));
18         return z;
19     }
20 }
21 
22 contract Token {
23     uint256 public totalSupply;
24 
25     function balanceOf(address _owner) constant returns (uint256 balance);
26     function transfer(address _to, uint256 _value) returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
28     function approve(address _spender, uint256 _value) returns (bool success);
29     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 /*  ERC 20 token */
36 contract StandardToken is Token, SafeMath {
37 
38     mapping (address => uint256) balances;
39     mapping (address => mapping (address => uint256)) allowed;
40 
41     modifier onlyPayloadSize(uint numwords) {
42         assert(msg.data.length == numwords * 32 + 4);
43         _;
44     }
45 
46     function transfer(address _to, uint256 _value)
47     returns (bool success)
48     {
49         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
50             balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
51             balances[_to] = safeAdd(balances[_to], _value);
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else {
55             return false;
56         }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value)
60     returns (bool success)
61     {
62         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
63             balances[_to] = safeAdd(balances[_to], _value);
64             balances[_from] = safeSubtract(balances[_from], _value);
65             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
66             Transfer(_from, _to, _value);
67             return true;
68         } else {
69             return false;
70         }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value)
78     onlyPayloadSize(2)
79     returns (bool success)
80     {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender)
87     constant
88     onlyPayloadSize(2)
89     returns (uint256 remaining)
90     {
91         return allowed[_owner][_spender];
92     }
93 }
94 contract VibeCoin {
95     function transferFrom(address _from, address _to, uint256 _value)
96     returns (bool success)
97     {}
98 }
99 
100 
101 contract VIBEXToken is StandardToken {
102 
103     // Token metadata
104     string public constant name = "VIBEX Exchange Token";
105     string public constant symbol = "VIBEX";
106     uint256 public constant decimals = 18;
107 
108     // Deposit address of account controlled by the creators
109     address public ethFundDeposit = 0xFC1CCdcA6b4670516504409341A31e444FF6f43F;
110     address public tokenExchangeAddress = 0xe8ff5c9c75deb346acac493c463c8950be03dfba;
111     address public tokenAccountAddress = 0xFC1CCdcA6b4670516504409341A31e444FF6f43F;
112     //Access to token contract for vibe exchange
113     VibeCoin public tokenExchange;
114 
115     // Fundraising parameters
116     enum ContractState { Fundraising, Finalized, Redeeming, Paused }
117     ContractState public state;           // Current state of the contract
118     ContractState private savedState;     // State of the contract before pause
119 
120     //start date: 08/07/2017 @ 12:00am (UTC)
121     uint public startDate = 1502064000;
122     //start date: 09/21/2017 @ 11:59pm (UTC)
123     uint public endDate = 1506038399;
124     //deadlines 1: 08/21/2017 @ 11:59pm (UTC) +30%
125     //deadlines 2: 08/28/2017 @ 11:59pm (UTC) +20%
126     //deadlines 3: 09/05/2017 @ 11:59pm (UTC) +10%
127     //deadlines 4: 09/12/2017 @ 11:59pm (UTC) +5%
128     //deadlines 5: 09/21/2017 @ 11:59pm (UTC) +0%
129     uint[5] public deadlines = [1503359999, 1503964799, 1504655999, 1505260799, 1506038399];
130 	uint[5] public prices = [130, 120, 110, 105, 100];
131     
132     uint256 public constant ETH_RECEIVED_CAP = 115 * (10**3) * 10**decimals; // 115 000 ETH
133     uint256 public constant ETH_RECEIVED_MIN = 0;//1 * 10**decimals; // 0 ETH
134     uint256 public constant TOKEN_MIN = 1 * 10**decimals; // 1 VIBEX
135     uint256 public constant MIN_ETH_TRANS = 25 * 10**decimals; // 25 ETH
136 
137     // We need to keep track of how much ether have been contributed, since we have a cap for ETH too
138     uint256 public totalReceivedEth = 0;
139 
140     // Since we have different exchange rates at different stages, we need to keep track
141     // of how much ether each contributed in case that we need to issue a refund
142     mapping (address => uint256) private ethBalances;
143 
144     // Events used for logging
145     event LogCreateVIBEX(address indexed _to, uint256 _value);
146     event LogRedeemVIBE(address indexed _to, uint256 _value, uint256 _value2, uint256 _value3);
147 
148     modifier isFinalized() {
149         require(state == ContractState.Finalized);
150         _;
151     }
152 
153     modifier isFundraising() {
154         require(state == ContractState.Fundraising);
155         _;
156     }
157 
158     modifier isRedeeming() {
159         require(state == ContractState.Redeeming);
160         _;
161     }
162 
163     modifier isPaused() {
164         require(state == ContractState.Paused);
165         _;
166     }
167 
168     modifier notPaused() {
169         require(state != ContractState.Paused);
170         _;
171     }
172 
173     modifier isFundraisingIgnorePaused() {
174         require(state == ContractState.Fundraising || (state == ContractState.Paused && savedState == ContractState.Fundraising));
175         _;
176     }
177 
178     modifier onlyOwner() {
179         require(msg.sender == ethFundDeposit);
180         _;
181     }
182 
183     modifier minimumReached() {
184         require(totalReceivedEth >= ETH_RECEIVED_MIN);
185         _;
186     }
187 
188     // Constructor
189     function VIBEXToken()
190     {
191         // Contract state
192         state = ContractState.Fundraising;
193         savedState = ContractState.Fundraising;
194         tokenExchange = VibeCoin(tokenExchangeAddress);
195         totalSupply = 0;
196     }
197 
198     // Overridden method to check for end of fundraising before allowing transfer of tokens
199     function transfer(address _to, uint256 _value)
200     isFinalized // Only allow token transfer after the fundraising has ended
201     onlyPayloadSize(2)
202     returns (bool success)
203     {
204         return super.transfer(_to, _value);
205     }
206 
207 
208     // Overridden method to check for end of fundraising before allowing transfer of tokens
209     function transferFrom(address _from, address _to, uint256 _value)
210     isFinalized // Only allow token transfer after the fundraising has ended
211     onlyPayloadSize(3)
212     returns (bool success)
213     {
214         return super.transferFrom(_from, _to, _value);
215     }
216     
217     /// @dev Accepts ether and creates new VIBEX tokens
218     function ()
219     payable
220     external
221     isFundraising
222     {
223         require(now >= startDate);
224         require(now <= endDate);
225         require(msg.value > 0);
226         
227         if(msg.value < MIN_ETH_TRANS && now < deadlines[0]) throw;
228 
229         // First we check the ETH cap, as it's easier to calculate, return
230         // the contribution if the cap has been reached already
231         uint256 checkedReceivedEth = safeAdd(totalReceivedEth, msg.value);
232         require(checkedReceivedEth <= ETH_RECEIVED_CAP);
233 
234         // If all is fine with the ETH cap, we continue to check the
235         // minimum amount of tokens
236         uint256 tokens = safeMult(msg.value, getCurrentTokenPrice());
237         require(tokens >= TOKEN_MIN);
238 
239         // Only when all the checks have passed, then we update the state (ethBalances,
240         // totalReceivedEth, totalSupply, and balances) of the contract
241         ethBalances[msg.sender] = safeAdd(ethBalances[msg.sender], msg.value);
242         totalReceivedEth = checkedReceivedEth;
243         totalSupply = safeAdd(totalSupply, tokens);
244         balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
245         
246         // Send the ETH to Vibehub Creators
247         ethFundDeposit.transfer(msg.value);
248 
249         // Log the creation of this tokens
250         LogCreateVIBEX(msg.sender, tokens);
251     }
252 
253 
254     /// @dev Returns the current token price
255     function getCurrentTokenPrice()
256     private
257     constant
258     returns (uint256 currentPrice)
259     {
260         for(var i = 0; i < deadlines.length; i++)
261             if(now<=deadlines[i])
262                 return prices[i];
263         return prices[prices.length-1];//should never be returned, but to be sure to not divide by 0
264     }
265 
266 
267     /// @dev Redeems VIBEs and records the Vibehub address of the sender
268     function redeemTokens()
269     external
270     isRedeeming
271     {
272         uint256 vibeVal = balances[msg.sender];
273         require(vibeVal >= TOKEN_MIN); // At least TOKEN_MIN tokens have to be redeemed
274 
275         // Move the tokens of the caller to Vibehub's address
276         //if (!super.transfer(ethFundDeposit, vibeVal)) throw;
277         balances[msg.sender]=0;
278         
279         uint256 exchangeRate = ((160200000* 10**decimals)/totalSupply);
280         uint256 numTokens = safeMult(exchangeRate, vibeVal); // Extra safe
281         if(!tokenExchange.transferFrom(tokenAccountAddress, msg.sender, numTokens)) throw;
282 
283         // Log the redeeming of this tokens
284         LogRedeemVIBE(msg.sender, numTokens, vibeVal, exchangeRate);
285     }
286 
287 
288 
289 
290     /// @dev Ends the fundraising period and sends the ETH to the ethFundDeposit wallet
291     function finalize()
292     external
293     isFundraising
294     minimumReached
295     onlyOwner // Only the owner of the ethFundDeposit address can finalize the contract
296     {
297         require(now > endDate || totalReceivedEth >= ETH_RECEIVED_CAP); // Only allow to finalize the contract before the ending block if we already reached any of the caps
298 
299         // Move the contract to Finalized state
300         state = ContractState.Finalized;
301         savedState = ContractState.Finalized;
302     }
303 
304 
305     /// @dev Starts the redeeming period
306     function startRedeeming()
307     external
308     isFinalized // The redeeming period can only be started after the contract is finalized
309     onlyOwner   // Only the owner of the ethFundDeposit address can start the redeeming period
310     {
311         // Move the contract to Redeeming state
312         state = ContractState.Redeeming;
313         savedState = ContractState.Redeeming;
314     }
315 
316 
317     /// @dev Pauses the contract
318     function pause()
319     external
320     notPaused   // Prevent the contract getting stuck in the Paused state
321     onlyOwner   // Only the owner of the ethFundDeposit address can pause the contract
322     {
323         // Move the contract to Paused state
324         savedState = state;
325         state = ContractState.Paused;
326     }
327 
328 
329     /// @dev Proceeds with the contract
330     function proceed()
331     external
332     isPaused
333     onlyOwner   // Only the owner of the ethFundDeposit address can proceed with the contract
334     {
335         // Move the contract to the previous state
336         state = savedState;
337     }
338 
339 }