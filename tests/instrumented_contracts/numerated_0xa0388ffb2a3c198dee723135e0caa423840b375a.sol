1 pragma solidity ^0.4.4;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 contract Token {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 //File: /Users/jbaylina/git/MVP/StandardToken.sol
52 pragma solidity ^0.4.4;
53 /*
54 You should inherit from StandardToken or, for a token like you would want to
55 deploy in something like Mist, see HumanStandardToken.sol.
56 (This implements ONLY the standard functions and NOTHING else.
57 If you deploy this, you won't have anything useful.)
58 
59 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
60 .*/
61 
62 
63 
64 contract StandardToken is Token {
65 
66     function transfer(address _to, uint256 _value) returns (bool success) {
67         //Default assumes totalSupply can't be over max (2^256 - 1).
68         //If your token leaves out totalSupply and can issue more tokens as time
69         //goes on, you need to check if it doesn't wrap.
70         //Replace the if with this one instead.
71         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
72         if (balances[msg.sender] >= _value && _value > 0) {
73             balances[msg.sender] -= _value;
74             balances[_to] += _value;
75             Transfer(msg.sender, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81         //same as above. Replace this line with the following if you want to protect against wrapping uints.
82         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
83         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
84             balances[_to] += _value;
85             balances[_from] -= _value;
86             allowed[_from][msg.sender] -= _value;
87             Transfer(_from, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function balanceOf(address _owner) constant returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96     function approve(address _spender, uint256 _value) returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103       return allowed[_owner][_spender];
104     }
105 
106     mapping (address => uint256) balances;
107     mapping (address => mapping (address => uint256)) allowed;
108 }
109 
110 //File: /Users/jbaylina/git/MVP/HumanStandardToken.sol
111 pragma solidity ^0.4.4;
112 
113 /*
114 This Token Contract implements the standard token functionality
115 (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL
116 extras intended for use by humans.
117 
118 In other words. This is intended for deployment in something like a Token
119 Factory or Mist wallet, and then used by humans.
120 Imagine coins, currencies, shares, voting weight, etc.
121 Machine-based, rapid creation of many tokens would not necessarily need these
122 extra features or will be minted in other manners.
123 
124 1) Initial Finite Supply (upon creation one specifies how much is minted).
125 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
126 3) Optional approveAndCall() functionality to notify a contract if an approval()
127 has occurred.
128 
129 */
130 
131 
132 
133 contract HumanStandardToken is StandardToken {
134 
135     function () {
136         //if ether is sent to this address, send it back.
137         throw;
138     }
139 
140     /* Public variables of the token */
141 
142     /*
143     NOTE:
144     The following variables are OPTIONAL vanities. One does not have to include
145     them.
146     They allow one to customise the token contract & in no way influences the
147     core functionality.
148     Some wallets/interfaces might not even bother to look at this information.
149     */
150     string public name;                   //fancy name: eg Simon Bucks
151     uint8 public decimals;                //How many decimals to show.
152     string public symbol;                 //An identifier: eg SBX
153     string public version = 'H0.1';       //An arbitrary versioning scheme.
154 
155     function HumanStandardToken(
156         uint256 _initialAmount,
157         string _tokenName,
158         uint8 _decimalUnits,
159         string _tokenSymbol
160         ) {
161         balances[msg.sender] = _initialAmount; // Give the creator all initial tokens
162         totalSupply = _initialAmount;          // Update total supply
163         name = _tokenName;                     // Set the name for display purposes
164         decimals = _decimalUnits;              // Amount of decimals for display purposes
165         symbol = _tokenSymbol;                 // Set the symbol for display purposes
166     }
167 /*
168     / * Approves and then calls the receiving contract * /
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
170         allowed[msg.sender][_spender] = _value;
171         Approval(msg.sender, _spender, _value);
172 
173         //call the receiveApproval function on the contract you want to be
174         //notified. This crafts the function signature manually so one doesn't
175         //have to include a contract in here just for this.
176         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
177         //it is assumed that when does this that the call *should* succeed,
178         //otherwise one would use vanilla approve instead.
179         if(!_spender.call(
180         bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))),
181         msg.sender,
182         _value,
183         this,
184         _extraData)) { throw; }
185         return true;
186     }
187 */
188 }
189 
190 //File: /Users/jbaylina/git/MVP/CampaignToken.sol
191 pragma solidity ^0.4.4;
192 
193 
194 
195 /// @title CampaignToken Contract
196 /// @author Jordi Baylina
197 /// @dev This token contract is a clone of ConsenSys's HumanStandardToken with
198 /// the approveAndCall function omitted; it is ERC 20 compliant.
199 
200 contract CampaignToken is HumanStandardToken {
201 
202 /// @dev The tokenController is the address that deployed the CampaignToken, for this
203 /// token it will be it will be the Campaign Contract
204 
205     address public tokenController;
206 
207 /// @dev The onlyController modifier only allows the tokenController to call the function
208 
209     modifier onlyController { if (msg.sender != tokenController) throw; _; }
210 
211 /// @notice `CampaignToken()` is the function that deploys a new
212 /// HumanStandardToken with the parameters of 0 initial tokens, the name
213 /// "CharityDAO Token" the decimal place of the smallest unit being 18, and the
214 /// call sign being "GIVE". It will set the tokenController to be the contract that
215 /// calls the function.
216 
217     function CampaignToken() HumanStandardToken(0,"CharityDAO Token",18,"GIVE") {
218         tokenController = msg.sender;
219     }
220 
221 /// @notice `createTokens()` will create tokens if the campaign has not been
222 /// sealed.
223 /// @dev `createTokens()` is called by the campaign contract when
224 /// someone sends ether to that contract or calls `doPayment()`
225 /// @param beneficiary The address receiving the tokens
226 /// @param amount The amount of tokens the address is receiving
227 /// @return True if tokens are created
228 
229     function createTokens(address beneficiary, uint amount
230     ) onlyController returns (bool success) {
231         if (sealed()) throw;
232         balances[beneficiary] += amount;  // Create tokens for the beneficiary
233         totalSupply += amount;            // Update total supply
234         Transfer(0, beneficiary, amount); // Create an Event for the creation
235         return true;
236     }
237 
238 /// @notice `seal()` ends the Campaign by making it impossible to create more
239 /// tokens.
240 /// @dev `seal()` changes the tokenController to 0 and therefore can only be called by
241 /// the tokenCreator contract once
242 /// @return True if the Campaign is sealed
243 
244     function seal() onlyController returns (bool success)  {
245         tokenController = 0;
246         return true;
247     }
248 
249 /// @notice `sealed()` checks to see if the the Campaign has been sealed
250 /// @return True if the Campaign has been sealed and can't receive funds
251 
252     function sealed() constant returns (bool) {
253         return tokenController == 0;
254     }
255 }
256 
257 //File: /Users/jbaylina/git/MVP/Campaign.sol
258 pragma solidity ^0.4.4;
259 
260 
261 
262 /// @title CampaignToken Contract
263 /// @author Jordi Baylina
264 /// @dev This is designed to control the ChairtyToken contract.
265 
266 contract Campaign {
267 
268     uint public startFundingTime;       // In UNIX Time Format
269     uint public endFundingTime;         // In UNIX Time Format
270     uint public maximumFunding;         // In wei
271     uint public totalCollected;         // In wei
272     CampaignToken public tokenContract;  // The new token for this Campaign
273     address public vaultContract;       // The address to hold the funds donated
274 
275 /// @notice 'Campaign()' initiates the Campaign by setting its funding
276 /// parameters and creating the deploying the token contract
277 /// @dev There are several checks to make sure the parameters are acceptable
278 /// @param _startFundingTime The UNIX time that the Campaign will be able to
279 /// start receiving funds
280 /// @param _endFundingTime The UNIX time that the Campaign will stop being able
281 /// to receive funds
282 /// @param _maximumFunding In wei, the Maximum amount that the Campaign can
283 /// receive (currently the max is set at 10,000 ETH for the beta)
284 /// @param _vaultContract The address that will store the donated funds
285 
286     function Campaign(
287         uint _startFundingTime,
288         uint _endFundingTime,
289         uint _maximumFunding,
290         address _vaultContract
291     ) {
292         if ((_endFundingTime < now) ||                // Cannot start in the past
293             (_endFundingTime <= _startFundingTime) ||
294             (_maximumFunding > 10000 ether) ||        // The Beta is limited
295             (_vaultContract == 0))                    // To prevent burning ETH
296             {
297             throw;
298             }
299         startFundingTime = _startFundingTime;
300         endFundingTime = _endFundingTime;
301         maximumFunding = _maximumFunding;
302         tokenContract = new CampaignToken (); // Deploys the Token Contract
303         vaultContract = _vaultContract;
304     }
305 
306 /// @dev The fallback function is called when ether is sent to the contract, it
307 /// simply calls `doPayment()` with the address that sent the ether as the
308 /// `_owner`. Payable is a required solidity modifier for functions to receive
309 /// ether, without this modifier they will throw
310 
311     function ()  payable {
312         doPayment(msg.sender);
313     }
314 
315 /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
316 /// have the CampaignTokens created in an address of their choosing
317 /// @param _owner The address that will hold the newly created CampaignTokens
318 
319     function proxyPayment(address _owner) payable {
320         doPayment(_owner);
321     }
322 
323 /// @dev `doPayment()` is an internal function that sends the ether that this
324 /// contract receives to the `vaultContract` and creates campaignTokens in the
325 /// address of the `_owner` assuming the Campaign is still accepting funds
326 /// @param _owner The address that will hold the newly created CampaignTokens
327 
328     function doPayment(address _owner) internal {
329 
330 // First we check that the Campaign is allowed to receive this donation
331         if ((now<startFundingTime) ||
332             (now>endFundingTime) ||
333             (tokenContract.tokenController() == 0) ||           // Extra check
334             (msg.value == 0) ||
335             (totalCollected + msg.value > maximumFunding))
336         {
337             throw;
338         }
339 
340 //Track how much the Campaign has collected
341         totalCollected += msg.value;
342 
343 //Send the ether to the vaultContract
344         if (!vaultContract.send(msg.value)) {
345             throw;
346         }
347 
348 // Creates an equal amount of CampaignTokens as ether sent. The new CampaignTokens
349 // are created in the `_owner` address
350         if (!tokenContract.createTokens(_owner, msg.value)) {
351             throw;
352         }
353 
354         return;
355     }
356 
357 /// @notice `seal()` ends the Campaign by calling `seal()` in the CampaignToken
358 /// contract
359 /// @dev `seal()` can only be called after the end of the funding period.
360 
361     function seal() {
362         if (now < endFundingTime) throw;
363         tokenContract.seal();
364     }
365 
366 }