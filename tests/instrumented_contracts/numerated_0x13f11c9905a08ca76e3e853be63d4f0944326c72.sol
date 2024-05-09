1 pragma solidity 0.4.11;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal constant returns(uint256) {
12       assert(x >= y);
13       return x - y;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal constant returns(uint256) {
17       uint256 z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21 
22     function safeDiv(uint256 x, uint256 y) internal constant returns (uint256) {
23       uint256 z = x / y;
24       return z;
25     }
26 
27 }
28 
29 contract Token {
30     uint256 public totalSupply;
31     function balanceOf(address _owner) constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34     function approve(address _spender, uint256 _value) returns (bool success);
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 
41 /*  ERC 20 token */
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) returns (bool success) {
45       if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
46         balances[msg.sender] -= _value;
47         balances[_to] += _value;
48         Transfer(msg.sender, _to, _value);
49         return true;
50       } else {
51         return false;
52       }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57         balances[_to] += _value;
58         balances[_from] -= _value;
59         allowed[_from][msg.sender] -= _value;
60         Transfer(_from, _to, _value);
61         return true;
62       } else {
63         return false;
64       }
65     }
66 
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78       return allowed[_owner][_spender];
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 }
84 
85 contract DIVXToken is StandardToken, SafeMath {
86 
87     // metadata
88     string public constant name = "Divi Exchange Token";
89     string public constant symbol = "DIVX";
90     uint256 public constant decimals = 18;
91     string public version = "1.0";
92 
93     // owner address
94     address public fundDeposit;      // deposit address for ETH and DIVX for the project
95 
96     // crowdsale parameters
97     bool public isPaused;
98     bool public isRedeeming;
99     uint256 public fundingStartBlock;
100     uint256 public firstXRChangeBlock;
101     uint256 public secondXRChangeBlock;
102     uint256 public thirdXRChangeBlock;
103     uint256 public fundingEndBlock;
104 
105     // Since we have different exchange rates at different stages, we need to keep track
106     // of how much ether (in units of Wei) each address contributed in case that we need
107     // to issue a refund
108     mapping (address => uint256) private weiBalances;
109 
110     // We need to keep track of how much ether (in units of Wei) has been contributed
111     uint256 public totalReceivedWei;
112 
113     uint256 public constant privateExchangeRate  = 1000; // 1000 DIVX tokens per 1 ETH
114     uint256 public constant firstExchangeRate    =  650; //  650 DIVX tokens per 1 ETH
115     uint256 public constant secondExchangeRate   =  575; //  575 DIVX tokens per 1 ETH
116     uint256 public constant thirdExchangeRate    =  500; //  500 DIVX tokens per 1 ETH
117 
118     uint256 public constant receivedWeiCap =  100 * (10**3) * 10**decimals;
119     uint256 public constant receivedWeiMin =    5 * (10**3) * 10**decimals;
120 
121     // events
122     event LogCreate(address indexed _to, uint256 _value, uint256 _tokenValue);
123     event LogRefund(address indexed _to, uint256 _value, uint256 _tokenValue);
124     event LogRedeem(address indexed _to, uint256 _value, bytes32 _diviAddress);
125 
126     // modifiers
127     modifier onlyOwner() {
128       require(msg.sender == fundDeposit);
129       _;
130     }
131 
132     modifier isNotPaused() {
133       require(isPaused == false);
134       _;
135     }
136 
137     // constructor
138     function DIVXToken(
139         address _fundDeposit,
140         uint256 _fundingStartBlock,
141         uint256 _firstXRChangeBlock,
142         uint256 _secondXRChangeBlock,
143         uint256 _thirdXRChangeBlock,
144         uint256 _fundingEndBlock) {
145 
146       isPaused    = false;
147       isRedeeming = false;
148 
149       totalSupply      = 0;
150       totalReceivedWei = 0;
151 
152       fundDeposit = _fundDeposit;
153 
154       fundingStartBlock   = _fundingStartBlock;
155       firstXRChangeBlock  = _firstXRChangeBlock;
156       secondXRChangeBlock = _secondXRChangeBlock;
157       thirdXRChangeBlock  = _thirdXRChangeBlock;
158       fundingEndBlock     = _fundingEndBlock;
159     }
160 
161     // overriden methods
162 
163     // Overridden method to check that the minimum was reached (no refund is possible
164     // after that, so transfer of tokens shouldn't be a problem)
165     function transfer(address _to, uint256 _value) returns (bool success) {
166       require(totalReceivedWei >= receivedWeiMin);
167       return super.transfer(_to, _value);
168     }
169 
170     // Overridden method to check that the minimum was reached (no refund is possible
171     // after that, so transfer of tokens shouldn't be a problem)
172     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
173       require(totalReceivedWei >= receivedWeiMin);
174       return super.transferFrom(_from, _to, _value);
175     }
176 
177     /// @dev Accepts ether and creates new DIVX tokens.
178     function createTokens() payable external isNotPaused {
179       require(block.number >= fundingStartBlock);
180       require(block.number <= fundingEndBlock);
181       require(msg.value > 0);
182 
183       // Check that this transaction wouldn't exceed the ETH cap
184       uint256 checkedReceivedWei = safeAdd(totalReceivedWei, msg.value);
185       require(checkedReceivedWei <= receivedWeiCap);
186 
187       // Calculate how many tokens (in units of Wei) should be awarded
188       // on this transaction
189       uint256 tokens = safeMult(msg.value, getCurrentTokenPrice());
190 
191       // Calculate how many tokens (in units of Wei) should be awarded to the project (20%)
192       uint256 projectTokens = safeDiv(tokens, 5);
193 
194       // Increment the total received ETH
195       totalReceivedWei = checkedReceivedWei;
196 
197       // Only update our accounting of how much ETH this contributor has sent us if
198       // we're already on the public sale (since private sale contributions are going
199       // to be used before the end of end of the sale period, they don't get a refund)
200       if (block.number >= firstXRChangeBlock) weiBalances[msg.sender] += msg.value;
201 
202       // Increment the total supply of tokens and then deposit the tokens
203       // to the contributor
204       totalSupply = safeAdd(totalSupply, tokens);
205       balances[msg.sender] += tokens;
206 
207       // Increment the total supply of tokens and then deposit the tokens
208       // to the project
209       totalSupply = safeAdd(totalSupply, projectTokens);
210       balances[fundDeposit] += projectTokens;
211 
212       LogCreate(msg.sender, msg.value, tokens);  // logs token creation
213     }
214 
215     /// @dev Allows to transfer ether from the contract to the multisig wallet
216     function withdrawWei(uint256 _value) external onlyOwner isNotPaused {
217       require(_value <= this.balance);
218 
219       // Allow withdrawal during the private sale, but after that, only allow
220       // withdrawal if we already met the minimum
221       require((block.number < firstXRChangeBlock) || (totalReceivedWei >= receivedWeiMin));
222 
223       // send the eth to the project multisig wallet
224       fundDeposit.transfer(_value);
225     }
226 
227     /// @dev Pauses the contract
228     function pause() external onlyOwner isNotPaused {
229       // Move the contract to Paused state
230       isPaused = true;
231     }
232 
233     /// @dev Resume the contract
234     function resume() external onlyOwner {
235       // Move the contract out of the Paused state
236       isPaused = false;
237     }
238 
239     /// @dev Starts the redeeming phase of the contract
240     function startRedeeming() external onlyOwner isNotPaused {
241       // Move the contract to Redeeming state
242       isRedeeming = true;
243     }
244 
245     /// @dev Stops the redeeming phase of the contract
246     function stopRedeeming() external onlyOwner isNotPaused {
247       // Move the contract out of the Redeeming state
248       isRedeeming = false;
249     }
250 
251     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign
252     function refund() external {
253       // prevents refund until sale period is over
254       require(block.number > fundingEndBlock);
255       // Refunds are only available if the minimum was not reached
256       require(totalReceivedWei < receivedWeiMin);
257 
258       // Retrieve how much DIVX (in units of Wei) this account has
259        uint256 divxVal = balances[msg.sender];
260        require(divxVal > 0);
261 
262       // Retrieve how much ETH (in units of Wei) this account contributed
263       uint256 weiVal = weiBalances[msg.sender];
264       require(weiVal > 0);
265 
266       // Destroy this contributor's tokens and reduce the total supply
267       balances[msg.sender] = 0;
268       totalSupply = safeSubtract(totalSupply, divxVal);
269 
270       // Log this refund operation
271       LogRefund(msg.sender, weiVal, divxVal);
272 
273       // Send the money back
274       msg.sender.transfer(weiVal);
275     }
276 
277     /// @dev Redeems tokens and records the address that the sender created in the new blockchain
278     function redeem(bytes32 diviAddress) external {
279       // Only allow this function to be called when on the redeeming state
280       require(isRedeeming);
281 
282       // Retrieve how much DIVX (in units of Wei) this account has
283       uint256 divxVal = balances[msg.sender];
284        require(divxVal > 0);
285 
286       // Move the tokens of the caller to the project's address
287       assert(super.transfer(fundDeposit, divxVal));
288 
289       // Log the redeeming of this tokens
290       LogRedeem(msg.sender, divxVal, diviAddress);
291     }
292 
293     /// @dev Returns the current token price
294     function getCurrentTokenPrice() private constant returns (uint256 currentPrice) {
295       if (block.number < firstXRChangeBlock) {
296         return privateExchangeRate;
297       } else if (block.number < secondXRChangeBlock) {
298         return firstExchangeRate;
299       } else if (block.number < thirdXRChangeBlock) {
300         return secondExchangeRate;
301       } else {
302         return thirdExchangeRate;
303       }
304     }
305 }