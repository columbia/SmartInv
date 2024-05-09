1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 
4 pragma solidity ^0.4.17;
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
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 /*
52 You should inherit from StandardToken or, for a token like you would want to
53 deploy in something like Mist, see HumanStandardToken.sol.
54 (This implements ONLY the standard functions and NOTHING else.
55 If you deploy this, you won't have anything useful.)
56 
57 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
58 .*/
59 
60 contract StandardToken is Token {
61 
62     uint256 constant MAX_UINT256 = 2**256 - 1;
63 
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         //Default assumes totalSupply can't be over max (2^256 - 1).
66         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
67         //Replace the if with this one instead.
68         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
69         require(balances[msg.sender] >= _value);
70         balances[msg.sender] -= _value;
71         balances[_to] += _value;
72         Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         //same as above. Replace this line with the following if you want to protect against wrapping uints.
78         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
79         uint256 allowance = allowed[_from][msg.sender];
80         require(balances[_from] >= _value && allowance >= _value);
81         balances[_to] += _value;
82         balances[_from] -= _value;
83         if (allowance < MAX_UINT256) {
84             allowed[_from][msg.sender] -= _value;
85         }
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function balanceOf(address _owner) view public returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) public returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender)
101     view public returns (uint256 remaining) {
102       return allowed[_owner][_spender];
103     }
104 
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107 }
108 
109 /*
110 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md) 
111 as well as the following OPTIONAL extras intended for use by humans.
112 .*/
113 
114 contract CharitySpaceToken is StandardToken {
115 
116   /* Public variables of the token */
117   string public name;                   //fancy name: eg Simon Bucks
118   uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
119   string public symbol;                 //An identifier: eg SBX
120 
121   address public owner;
122   address private icoAddress;
123 
124   function CharitySpaceToken(address _icoAddress, address _teamAddress, address _advisorsAddress, address _bountyAddress, address _companyAddress) public {
125     totalSupply =  20000000 * 10**18;                    // Update total supply 20.000.000 CHT
126     uint256 publicSaleSupply = 16000000 * 10**18;        // Update public sale supply 16.000.000 CHT
127     uint256 teamSupply = 1500000 * 10**18;               // Update charitySPACE team supply 1.500.000 CHT
128     uint256 advisorsSupply = 700000 * 10**18;            // Update projects advisors supply 700.000 CHT
129     uint256 bountySupply = 800000 * 10**18;              // Update projects bounty program supply 800.000 CHT
130     uint256 companySupply = 1000000 * 10**18;            // Update charitySPACE company supply 1.000.000 CHT
131     name = "charityTOKEN";
132     decimals = 18;
133     symbol = "CHT";
134 
135     balances[_icoAddress] = publicSaleSupply;
136     Transfer(0, _icoAddress, publicSaleSupply);
137 
138     balances[_teamAddress] = teamSupply;
139     Transfer(0, _teamAddress, teamSupply);
140 
141     balances[_advisorsAddress] = advisorsSupply;
142     Transfer(0, _advisorsAddress, advisorsSupply);
143 
144     balances[_bountyAddress] = bountySupply;
145     Transfer(0, _bountyAddress, bountySupply);
146 
147     balances[_companyAddress] = companySupply;
148     Transfer(0, _companyAddress, companySupply);
149 
150     owner = msg.sender;
151     icoAddress = _icoAddress;
152   }
153 
154   function destroyUnsoldTokens() public {
155     require(msg.sender == icoAddress || msg.sender == owner);
156     uint256 value = balances[icoAddress];
157     totalSupply -= value;
158     balances[icoAddress] = 0;
159   }
160 }
161 
162 /*
163 The Crowdsale contract.
164 .*/
165 
166 contract CharitySpace {
167   
168   struct Tier {
169     uint256 tokens;
170     uint256 tokensSold;
171     uint256 price;
172   }
173   
174   // Events
175   event ReceivedETH(address addr, uint value);
176   event ReceivedBTC(address addr, uint value, string txid);
177   event ReceivedBCH(address addr, uint value, string txid);
178   event ReceivedLTC(address addr, uint value, string txid);
179   
180   // Public variables
181   CharitySpaceToken public charitySpaceToken;
182   address public owner;
183   address public donationsAddress;
184   uint public startDate;
185   uint public endDate;
186   uint public preIcoEndDate;
187   uint256 public tokensSold = 0;
188   bool public setuped = false;
189   bool public started = false;
190   bool public live = false;
191   uint public preIcoMaxLasts = 7 days;
192   // Ico tiers variables
193   Tier[] public tiers;
194   
195   // Alt currencies hash
196   bytes32 private btcHash = keccak256('BTC');
197   bytes32 private bchHash = keccak256('BCH');
198   
199   // Interceptors
200   modifier onlyBy(address a) {
201     require(msg.sender == a); 
202     _;
203   }
204   
205   modifier respectTimeFrame() {
206     require((now > startDate) && (now < endDate));
207     _;
208   }
209   
210   function CharitySpace(address _donationsAddress) public {
211     owner = msg.sender;
212     donationsAddress = _donationsAddress; //address where eth's are holded
213   }
214   
215   function setup(address _charitySpaceToken) public onlyBy(owner) {
216     require(started == false);
217     require(setuped == false);
218     charitySpaceToken = CharitySpaceToken(_charitySpaceToken);
219     Tier memory preico = Tier(2500000 * 10**18, 0, 0.0007 * 10**18);
220     Tier memory tier1 = Tier(3000000 * 10**18, 0, 0.001 * 10**18);
221     Tier memory tier2 = Tier(3500000 * 10**18, 0, 0.0015 * 10**18);
222     Tier memory tier3 = Tier(7000000 * 10**18, 0, 0.002 * 10**18);
223     tiers.push(preico);
224     tiers.push(tier1);
225     tiers.push(tier2);
226     tiers.push(tier3);
227     setuped = true;
228   }
229   
230   // Start CharitySPACE ico!
231   function start() public onlyBy(owner) {
232     require(started == false);
233     startDate = now;            
234     endDate = now + 30 days + 2 hours; // ico duration + backup time
235     preIcoEndDate = now + preIcoMaxLasts;
236     live = true;
237     started = true;
238   }
239   
240   function end() public onlyBy(owner) {
241     require(started == true);
242     require(live == true);
243     require(now > endDate);
244     charitySpaceToken.destroyUnsoldTokens();
245     live = false;
246     started = true;
247   }
248   
249   function receiveDonation() public payable respectTimeFrame {
250     uint256 _value = msg.value;
251     uint256 _tokensToTransfer = 0;
252     require(_value > 0);
253     
254     uint256 _tokens = 0;
255     if(preIcoEndDate > now) {
256       _tokens = _value * 10**18 / tiers[0].price;
257       if((tiers[0].tokens - tiers[0].tokensSold) < _tokens) {
258         _tokens = (tiers[0].tokens - tiers[0].tokensSold);
259         _value -= ((_tokens * tiers[0].price) / 10**18);
260       } else {
261         _value = 0;
262       }
263       tiers[0].tokensSold += _tokens;
264       _tokensToTransfer += _tokens;
265     }
266     if(_value > 0) {
267       for (uint i = 1; i < tiers.length; ++i) {
268         if(_value > 0 && (tiers[i].tokens > tiers[i].tokensSold)) {
269           _tokens = _value * 10**18 / tiers[i].price;
270           if((tiers[i].tokens - tiers[i].tokensSold) < _tokens) {
271             _tokens = (tiers[i].tokens - tiers[i].tokensSold);
272             _value -= ((_tokens * tiers[i].price) / 10**18);
273           } else {
274             _value = 0;
275           }
276           tiers[i].tokensSold += _tokens;
277           _tokensToTransfer += _tokens;
278         }
279       }
280     }
281     
282     assert(_tokensToTransfer > 0);
283     assert(_value == 0);  // Yes, you can't donate 100000 ETH and receive all tokens.
284     
285     tokensSold += _tokensToTransfer;
286     
287     assert(charitySpaceToken.transfer(msg.sender, _tokensToTransfer));
288     assert(donationsAddress.send(msg.value));
289     
290     ReceivedETH(msg.sender, msg.value);
291   }
292   
293   // Confirm donation in BTC, BCH (BCC), LTC, DASH
294   // All donation has txid from foregin blockchain. In the end of ico we transfer all donations to single address (will be written down on project site) for each block chain. You may easly check that this method was used only to confirm real transactions.
295   function manuallyConfirmDonation(address donatorAddress, uint256 tokens, uint256 altValue, string altCurrency, string altTx) public onlyBy(owner) respectTimeFrame {
296     uint256 _remainingTokens = tokens;
297     uint256 _tokens = 0;
298     
299     if(preIcoEndDate > now) {
300        if((tiers[0].tokens - tiers[0].tokensSold) < _remainingTokens) {
301         _tokens = (tiers[0].tokens - tiers[0].tokensSold);
302       } else {
303         _tokens = _remainingTokens;
304       }
305       tiers[0].tokensSold += _tokens;
306       _remainingTokens -= _tokens;
307     }
308     if(_remainingTokens > 0) {
309       for (uint i = 1; i < tiers.length; ++i) {
310         if(_remainingTokens > 0 && (tiers[i].tokens > tiers[i].tokensSold)) {
311           if ((tiers[i].tokens - tiers[i].tokensSold) < _remainingTokens) {
312             _tokens = (tiers[i].tokens - tiers[i].tokensSold);
313           } else {
314             _tokens = _remainingTokens;
315           }
316           tiers[i].tokensSold += _tokens;
317           _remainingTokens -= _tokens;
318         }
319       }
320     }
321     
322     assert(_remainingTokens == 0); //to no abuse method when no tokens available. 
323     tokensSold += tokens;
324     assert(charitySpaceToken.transfer(donatorAddress, tokens));
325     
326     bytes32 altCurrencyHash = keccak256(altCurrency);
327     if(altCurrencyHash == btcHash) {
328       ReceivedBTC(donatorAddress, altValue, altTx);
329     } else if(altCurrencyHash == bchHash) {
330       ReceivedBCH(donatorAddress, altValue, altTx);
331     } else {
332       ReceivedLTC(donatorAddress, altValue, altTx);
333     }
334   }
335   
336   function () public payable respectTimeFrame {
337     receiveDonation();
338   }
339 }