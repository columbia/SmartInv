1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
50 
51 contract BitGuildToken {
52     // Public variables of the token
53     string public name = "BitGuild PLAT";
54     string public symbol = "PLAT";
55     uint8 public decimals = 18;
56     uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals); // 10 billion tokens;
57 
58     // This creates an array with all balances
59     mapping (address => uint256) public balanceOf;
60     mapping (address => mapping (address => uint256)) public allowance;
61 
62     // This generates a public event on the blockchain that will notify clients
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     // This notifies clients about the amount burnt
66     event Burn(address indexed from, uint256 value);
67 
68     /**
69      * Constructor function
70      * Initializes contract with initial supply tokens to the creator of the contract
71      */
72     function BitGuildToken() public {
73         balanceOf[msg.sender] = totalSupply;
74     }
75 
76     /**
77      * Internal transfer, only can be called by this contract
78      */
79     function _transfer(address _from, address _to, uint _value) internal {
80         // Prevent transfer to 0x0 address. Use burn() instead
81         require(_to != 0x0);
82         // Check if the sender has enough
83         require(balanceOf[_from] >= _value);
84         // Check for overflows
85         require(balanceOf[_to] + _value > balanceOf[_to]);
86         // Save this for an assertion in the future
87         uint previousBalances = balanceOf[_from] + balanceOf[_to];
88         // Subtract from the sender
89         balanceOf[_from] -= _value;
90         // Add the same to the recipient
91         balanceOf[_to] += _value;
92         Transfer(_from, _to, _value);
93         // Asserts are used to use static analysis to find bugs in your code. They should never fail
94         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
95     }
96 
97     /**
98      * Transfer tokens
99      *
100      * Send `_value` tokens to `_to` from your account
101      *
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transfer(address _to, uint256 _value) public {
106         _transfer(msg.sender, _to, _value);
107     }
108 
109     /**
110      * Transfer tokens from other address
111      *
112      * Send `_value` tokens to `_to` on behalf of `_from`
113      *
114      * @param _from The address of the sender
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
119         require(_value <= allowance[_from][msg.sender]);     // Check allowance
120         allowance[_from][msg.sender] -= _value;
121         _transfer(_from, _to, _value);
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address
127      *
128      * Allows `_spender` to spend no more than `_value` tokens on your behalf
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      */
133     function approve(address _spender, uint256 _value) public
134         returns (bool success) {
135         allowance[msg.sender][_spender] = _value;
136         return true;
137     }
138 
139     /**
140      * Set allowance for other address and notify
141      *
142      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
143      *
144      * @param _spender The address authorized to spend
145      * @param _value the max amount they can spend
146      * @param _extraData some extra information to send to the approved contract
147      */
148     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
149         public
150         returns (bool success) {
151         tokenRecipient spender = tokenRecipient(_spender);
152         if (approve(_spender, _value)) {
153             spender.receiveApproval(msg.sender, _value, this, _extraData);
154             return true;
155         }
156     }
157 
158     /**
159      * Destroy tokens
160      *
161      * Remove `_value` tokens from the system irreversibly
162      *
163      * @param _value the amount of money to burn
164      */
165     function burn(uint256 _value) public returns (bool success) {
166         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
167         balanceOf[msg.sender] -= _value;            // Subtract from the sender
168         totalSupply -= _value;                      // Updates totalSupply
169         Burn(msg.sender, _value);
170         return true;
171     }
172 
173     /**
174      * Destroy tokens from other account
175      *
176      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
177      *
178      * @param _from the address of the sender
179      * @param _value the amount of money to burn
180      */
181     function burnFrom(address _from, uint256 _value) public returns (bool success) {
182         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
183         require(_value <= allowance[_from][msg.sender]);    // Check allowance
184         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
185         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
186         totalSupply -= _value;                              // Update totalSupply
187         Burn(_from, _value);
188         return true;
189     }
190 }
191 
192 /**
193  * @title BitGuildWhitelist
194  * A small smart contract to provide whitelist functionality and storage
195  */
196 contract BitGuildWhitelist {
197 
198   address admin;
199 
200   mapping (address => bool) public whitelist;
201   uint256 public totalWhitelisted = 0;
202 
203   event AddressWhitelisted(address indexed user, bool whitelisted);
204 
205   function BitGuildWhitelist() public {
206     admin = msg.sender;
207   }
208 
209   // Doesn't accept eth
210   function () external payable {
211     revert();
212   }
213 
214   // Allows an admin to update whitelist
215   function whitelistAddress(address[] _users, bool _whitelisted) public {
216     require(msg.sender == admin);
217     for (uint i = 0; i < _users.length; i++) {
218       if (whitelist[_users[i]] == _whitelisted) continue;
219       if (_whitelisted) {
220         totalWhitelisted++;
221       } else {
222         if (totalWhitelisted > 0) {
223           totalWhitelisted--;
224         }
225       }
226       AddressWhitelisted(_users[i], _whitelisted);
227       whitelist[_users[i]] = _whitelisted;
228     }
229   }
230 }
231 
232 /**
233  * @title BitGuildCrowdsale
234  * Capped crowdsale with a stard/end date
235  */
236 contract BitGuildCrowdsale {
237   using SafeMath for uint256;
238 
239   // Token being sold
240   BitGuildToken public token;
241 
242   // Whitelist being used
243   BitGuildWhitelist public whitelist;
244 
245   // start and end timestamps where investments are allowed (both inclusive)
246   uint256 public startTime;
247   uint256 public endTime;
248 
249   // Crowdsale cap (how much can be raised total)
250   uint256 public cap = 14062.5 ether;
251 
252   // Address where funds are collected
253   address public wallet;
254 
255   // Predefined rate of PLAT to Ethereum (1/rate = crowdsale price)
256   uint256 public rate = 80000;
257 
258   // Min/max purchase
259   uint256 public minContribution = 0.5 ether;
260   uint256 public maxContribution = 1500 ether;
261 
262   // amount of raised money in wei
263   uint256 public weiRaised;
264   mapping (address => uint256) public contributions;
265 
266   // Finalization flag for when we want to withdraw the remaining tokens after the end
267   bool public crowdsaleFinalized = false;
268 
269   /**
270    * event for token purchase logging
271    * @param purchaser who paid for the tokens
272    * @param beneficiary who got the tokens
273    * @param value weis paid for purchase
274    * @param amount amount of tokens purchased
275    */
276   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
277 
278   function BitGuildCrowdsale(uint256 _startTime, uint256 _endTime, address _token, address _wallet, address _whitelist) public {
279     require(_startTime >= now);
280     require(_endTime >= _startTime);
281     require(_token != address(0));
282     require(_wallet != address(0));
283     require(_whitelist != address(0));
284 
285     startTime = _startTime;
286     endTime = _endTime;
287     token = BitGuildToken(_token);
288     wallet = _wallet;
289     whitelist = BitGuildWhitelist(_whitelist);
290   }
291 
292   // fallback function can be used to buy tokens
293   function () external payable {
294     buyTokens(msg.sender);
295   }
296 
297   // low level token purchase function
298   function buyTokens(address beneficiary) public payable {
299     require(beneficiary != address(0));
300     require(whitelist.whitelist(beneficiary));
301     require(validPurchase());
302 
303     uint256 weiAmount = msg.value;
304 
305     // calculate token amount to be created
306     uint256 tokens = getTokenAmount(weiAmount);
307 
308     // update total and individual contributions
309     weiRaised = weiRaised.add(weiAmount);
310     contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
311 
312     // Send tokens
313     token.transfer(beneficiary, tokens);
314     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
315 
316     // Send funds
317     wallet.transfer(msg.value);
318   }
319 
320   // Returns true if crowdsale event has ended
321   function hasEnded() public view returns (bool) {
322     bool capReached = weiRaised >= cap;
323     bool endTimeReached = now > endTime;
324     return capReached || endTimeReached || crowdsaleFinalized;
325   }
326 
327   // Bonuses for larger purchases (in hundredths of percent)
328   function bonusPercentForWeiAmount(uint256 weiAmount) public pure returns(uint256) {
329     if (weiAmount >= 500 ether) return 1000; // 10%
330     if (weiAmount >= 250 ether) return 750;  // 7.5%
331     if (weiAmount >= 100 ether) return 500;  // 5%
332     if (weiAmount >= 50 ether) return 375;   // 3.75%
333     if (weiAmount >= 15 ether) return 250;   // 2.5%
334     if (weiAmount >= 5 ether) return 125;    // 1.25%
335     return 0; // 0% bonus if lower than 5 eth
336   }
337 
338   // Returns you how much tokens do you get for the wei passed
339   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
340     uint256 tokens = weiAmount.mul(rate);
341     uint256 bonus = bonusPercentForWeiAmount(weiAmount);
342     tokens = tokens.mul(10000 + bonus).div(10000);
343     return tokens;
344   }
345 
346   // Returns true if the transaction can buy tokens
347   function validPurchase() internal view returns (bool) {
348     bool withinPeriod = now >= startTime && now <= endTime;
349     bool moreThanMinPurchase = msg.value >= minContribution;
350     bool lessThanMaxPurchase = contributions[msg.sender] + msg.value <= maxContribution;
351     bool withinCap = weiRaised.add(msg.value) <= cap;
352 
353     return withinPeriod && moreThanMinPurchase && lessThanMaxPurchase && withinCap && !crowdsaleFinalized;
354   }
355 
356   // Escape hatch in case the sale needs to be urgently stopped
357   function finalizeCrowdsale() public {
358     require(msg.sender == wallet);
359     crowdsaleFinalized = true;
360     // send remaining tokens back to the admin
361     uint256 tokensLeft = token.balanceOf(this);
362     token.transfer(wallet, tokensLeft);
363   }
364 }