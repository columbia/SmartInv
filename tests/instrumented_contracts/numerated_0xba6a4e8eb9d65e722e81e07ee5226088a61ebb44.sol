1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4     using SafeMath for uint256;
5 
6     // Address of the owner
7     address public owner;
8 
9     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11     /**
12      * @dev Throws if called by any account other than the owner.
13      */
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     /**
20      * @dev Allows the current owner to transfer control of the contract to a newOwner.
21      * @param newOwner The address to transfer ownership to.
22      */
23     function transferOwnership(address newOwner) public onlyOwner {
24         require(newOwner != address(0));
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27     }
28 
29     // Token being sold
30     Token public token;
31 
32     // start and end timestamps where investments are allowed (both inclusive)
33     //  uint256 public startTime = 1524245400;
34     uint256 public startTime = 1523842200;
35     uint256 public endTime = 1525973400;
36 
37     // Crowdsale cap (how much can be raised total)
38     uint256 public cap = 25000 ether;
39 
40     // Address where funds are collected
41     address public wallet = 0xff2A97D65E486cA7Bd209f55Fa1dA38B6D5Bf260;
42 
43     // Predefined rate of token to Ethereum (1/rate = crowdsale price)
44     uint256 public rate = 200000;
45 
46     // Min/max purchase
47     uint256 public minSale = 0.0001 ether;
48     uint256 public maxSale = 1000 ether;
49 
50     // amount of raised money in wei
51     uint256 public weiRaised;
52     mapping(address => uint256) public contributions;
53 
54     // Finalization flag for when we want to withdraw the remaining tokens after the end
55     bool public finished = false;
56 
57     /**
58      * event for token purchase logging
59      * @param purchaser who paid for the tokens
60      * @param beneficiary who got the tokens
61      * @param value weis paid for purchase
62      * @param amount amount of tokens purchased
63      */
64     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
65 
66     function Crowdsale(address _token) public {
67         require(_token != address(0));
68         owner = msg.sender;
69         token = Token(_token);
70     }
71 
72     // fallback function can be used to buy tokens
73     function() external payable {
74         buyTokens(msg.sender);
75     }
76 
77 
78     // low level token purchase function
79     function buyTokens(address beneficiary) public payable {
80         require(beneficiary != address(0));
81         require(validPurchase());
82 
83         uint256 weiAmount = msg.value;
84 
85         // calculate token amount to be created
86         uint256 tokens = getTokenAmount(weiAmount);
87 
88         // update total and individual contributions
89         weiRaised = weiRaised.add(weiAmount);
90         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
91 
92         // Send tokens
93         token.transfer(beneficiary, tokens);
94         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
95 
96         // Send funds
97         wallet.transfer(msg.value);
98     }
99 
100     // Returns true if crowdsale event has ended
101     function hasEnded() public view returns (bool) {
102         bool capReached = weiRaised >= cap;
103         bool endTimeReached = now > endTime;
104         return capReached || endTimeReached || finished;
105     }
106 
107     // Bonuses for larger purchases (in hundredths of percent)
108     function bonusPercentForWeiAmount(uint256 weiAmount) public pure returns (uint256) {
109         if (weiAmount >= 500 ether) return 1000;
110         // 10%
111         if (weiAmount >= 250 ether) return 750;
112         // 7.5%
113         if (weiAmount >= 100 ether) return 500;
114         // 5%
115         if (weiAmount >= 50 ether) return 375;
116         // 3.75%
117         if (weiAmount >= 15 ether) return 250;
118         // 2.5%
119         if (weiAmount >= 5 ether) return 125;
120         // 1.25%
121         return 0;
122         // 0% bonus if lower than 5 eth
123     }
124 
125     // Returns you how much tokens do you get for the wei passed
126     function getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
127         uint256 tokens = weiAmount.mul(rate);
128         uint256 bonus = bonusPercentForWeiAmount(weiAmount);
129         tokens = tokens.mul(10000 + bonus).div(10000);
130         return tokens;
131     }
132 
133     // Returns true if the transaction can buy tokens
134     function validPurchase() internal view returns (bool) {
135         bool withinPeriod = now >= startTime && now <= endTime;
136         bool moreThanMinPurchase = msg.value >= minSale;
137         bool lessThanMaxPurchase = contributions[msg.sender] + msg.value <= maxSale;
138         bool withinCap = weiRaised.add(msg.value) <= cap;
139 
140         return withinPeriod && moreThanMinPurchase && lessThanMaxPurchase && withinCap && !finished;
141     }
142 
143     // Escape hatch in case the sale needs to be urgently stopped
144     function endSale() public onlyOwner {
145         finished = true;
146         // send remaining tokens back to the owner
147         uint256 tokensLeft = token.balanceOf(this);
148         token.transfer(owner, tokensLeft);
149     }
150 
151     // set rate for gray so we can handle time based sales rates
152     function setRate(uint256 _rate) public onlyOwner {
153         rate = _rate;
154     }
155 
156     // set start time
157     function setStartTime(uint256 _startTime) public onlyOwner {
158         startTime = _startTime;
159     }
160 
161     // set end time
162     function setEndTime(uint256 _endTime) public onlyOwner {
163         endTime = _endTime;
164     }
165 
166     // set finalized time so contract can be paused
167     function setFinished(bool _finished) public onlyOwner {
168         finished = _finished;
169     }
170 
171     // set cap time so contract cap can be adjusted as bonus vary
172     function setCap(uint256 _cap) public onlyOwner {
173         cap = _cap * 1 ether;
174     }
175 
176     // set Min Contribution
177     function setMinSale(uint256 _min) public onlyOwner {
178         minSale = _min * 1 ether;
179     }
180 
181     // set Max Contribution
182     function setMaxSale(uint256 _max) public onlyOwner {
183         maxSale = _max * 1 ether;
184     }
185 
186 
187 }
188 
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195     if (a == 0) {
196       return 0;
197     }
198     uint256 c = a * b;
199     assert(c / a == b);
200     return c;
201   }
202 
203   /**
204   * @dev Integer division of two numbers, truncating the quotient.
205   */
206   function div(uint256 a, uint256 b) internal pure returns (uint256) {
207     // assert(b > 0); // Solidity automatically throws when dividing by 0
208     uint256 c = a / b;
209     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210     return c;
211   }
212 
213   /**
214   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
215   */
216   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217     assert(b <= a);
218     return a - b;
219   }
220 
221   /**
222   * @dev Adds two numbers, throws on overflow.
223   */
224   function add(uint256 a, uint256 b) internal pure returns (uint256) {
225     uint256 c = a + b;
226     assert(c >= a);
227     return c;
228   }
229 }
230 
231 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
232 
233 contract Token {
234     // Public variables of the token
235     string public name = "VoxelX GRAY";
236     string public symbol = "GRAY";
237     uint8 public decimals = 18;
238     uint256 public totalSupply = 10000000000 * 10 ** uint256(decimals); // 10 billion tokens;
239 
240     // This creates an array with all balances
241     mapping (address => uint256) public balanceOf;
242     mapping (address => mapping (address => uint256)) public allowance;
243 
244     // This generates a public event on the blockchain that will notify clients
245     event Transfer(address indexed from, address indexed to, uint256 value);
246 
247     // This notifies clients about the amount burnt
248     event Burn(address indexed from, uint256 value);
249 
250     /**
251      * Constructor function
252      * Initializes contract with initial supply tokens to the creator of the contract
253      */
254     function Token() public {
255         balanceOf[msg.sender] = totalSupply;
256     }
257 
258     /**
259      * Internal transfer, only can be called by this contract
260      */
261     function _transfer(address _from, address _to, uint _value) internal {
262         // Prevent transfer to 0x0 address. Use burn() instead
263         require(_to != 0x0);
264         // Check if the sender has enough
265         require(balanceOf[_from] >= _value);
266         // Check for overflows
267         require(balanceOf[_to] + _value > balanceOf[_to]);
268         // Save this for an assertion in the future
269         uint previousBalances = balanceOf[_from] + balanceOf[_to];
270         // Subtract from the sender
271         balanceOf[_from] -= _value;
272         // Add the same to the recipient
273         balanceOf[_to] += _value;
274         emit Transfer(_from, _to, _value);
275         // Asserts are used to use static analysis to find bugs in your code. They should never fail
276         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
277     }
278 
279     /**
280      * Transfer tokens
281      *
282      * Send `_value` tokens to `_to` from your account
283      *
284      * @param _to The address of the recipient
285      * @param _value the amount to send
286      */
287     function transfer(address _to, uint256 _value) public {
288         _transfer(msg.sender, _to, _value);
289     }
290 
291     /**
292      * Transfer tokens from other address
293      *
294      * Send `_value` tokens to `_to` on behalf of `_from`
295      *
296      * @param _from The address of the sender
297      * @param _to The address of the recipient
298      * @param _value the amount to send
299      */
300     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
301         require(_value <= allowance[_from][msg.sender]);     // Check allowance
302         allowance[_from][msg.sender] -= _value;
303         _transfer(_from, _to, _value);
304         return true;
305     }
306 
307     /**
308      * Set allowance for other address
309      *
310      * Allows `_spender` to spend no more than `_value` tokens on your behalf
311      *
312      * @param _spender The address authorized to spend
313      * @param _value the max amount they can spend
314      */
315     function approve(address _spender, uint256 _value) public
316         returns (bool success) {
317         allowance[msg.sender][_spender] = _value;
318         return true;
319     }
320 
321     /**
322      * Set allowance for other address and notify
323      *
324      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
325      *
326      * @param _spender The address authorized to spend
327      * @param _value the max amount they can spend
328      * @param _extraData some extra information to send to the approved contract
329      */
330     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
331         public
332         returns (bool success) {
333         tokenRecipient spender = tokenRecipient(_spender);
334         if (approve(_spender, _value)) {
335             spender.receiveApproval(msg.sender, _value, this, _extraData);
336             return true;
337         }
338     }
339 
340     /**
341      * Destroy tokens
342      *
343      * Remove `_value` tokens from the system irreversibly
344      *
345      * @param _value the amount of money to burn
346      */
347     function burn(uint256 _value) public returns (bool success) {
348         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
349         balanceOf[msg.sender] -= _value;            // Subtract from the sender
350         totalSupply -= _value;                      // Updates totalSupply
351         emit Burn(msg.sender, _value);
352         return true;
353     }
354 
355     /**
356      * Destroy tokens from other account
357      *
358      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
359      *
360      * @param _from the address of the sender
361      * @param _value the amount of money to burn
362      */
363     function burnFrom(address _from, uint256 _value) public returns (bool success) {
364         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
365         require(_value <= allowance[_from][msg.sender]);    // Check allowance
366         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
367         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
368         totalSupply -= _value;                              // Update totalSupply
369         emit Burn(_from, _value);
370         return true;
371     }
372 }