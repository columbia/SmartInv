1 //
2 pragma solidity 0.4.23;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) internal balances;
70 
71     uint256 internal totalSupply_;
72 
73     /**
74     * @dev total number of tokens in existence
75     */
76     function totalSupply() public view returns (uint256) {
77         return totalSupply_;
78     }
79 
80     /**
81     * @dev transfer token for a specified address
82     * @param _to The address to transfer to.
83     * @param _value The amount to be transferred.
84     */
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         // SafeMath.sub will throw if there is not enough balance.
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         emit Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111     function allowance(address owner, address spender) public view returns (uint256);
112     function transferFrom(address from, address to, uint256 value) public returns (bool);
113     function approve(address spender, uint256 value) public returns (bool);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126     mapping (address => mapping (address => uint256)) internal allowed;
127 
128     /**
129      * @dev Transfer tokens from one address to another
130      * @param _from address The address which you want to send tokens from
131      * @param _to address The address which you want to transfer to
132      * @param _value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      */
178     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 }
195 
196 /**
197  * @title SafeERC20
198  * @dev Wrappers around ERC20 operations that throw on failure.
199  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
200  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
201  */
202 library SafeERC20 {
203     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
204         assert(token.transfer(to, value));
205     }
206 
207     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
208         assert(token.transferFrom(from, to, value));
209     }
210 
211     function safeApprove(ERC20 token, address spender, uint256 value) internal {
212         assert(token.approve(spender, value));
213     }
214 }
215 
216 /**
217  * @title SafeERC20
218  * @dev Wrappers around ERC20 operations that throw on failure.
219  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
220  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
221  */
222 contract NLCToken is StandardToken {
223     ///
224     using SafeMath for uint256;
225 
226     ///
227     string public constant name = "Nutrilife OU";
228     string public constant symbol = "NLC";
229     uint8 public constant decimals = 18;  
230     
231     /// The owner of this address will distrbute the locked and vested tokens
232     address public nlcAdminAddress;
233     uint256 public weiRaised;
234     uint256 public rate;
235 
236     modifier onlyAdmin {
237         require(msg.sender == nlcAdminAddress);
238         _;
239     }
240     
241     /**
242     * Event for token purchase logging
243     * @param investor invest into the token
244     * @param value weis paid for purchase
245     */
246     event Investment(address indexed investor, uint256 value);
247     event TokenPurchaseRequestFromInvestment(address indexed investor, uint256 token);
248     event ApproveTokenPurchaseRequest(address indexed investor, uint256 token);
249     
250     /// Initial tokens to be allocated (500 million)
251     uint256 public constant INITIAL_SUPPLY = 500000000 * 10**uint256(decimals);
252     mapping(address => uint256) public _investorsVault;
253     mapping(address => uint256) public _investorsInvestmentInToken;
254 
255     ///
256     constructor(address _nlcAdminAddress, uint256 _rate) public {
257         require(_nlcAdminAddress != address(0));
258         
259         nlcAdminAddress = _nlcAdminAddress;
260         totalSupply_ = INITIAL_SUPPLY;
261         rate = _rate;
262 
263         balances[_nlcAdminAddress] = totalSupply_;
264     }
265 
266 
267     /**
268     * @dev fallback function ***DO NOT OVERRIDE***
269     */
270     function () external payable {
271         investFund(msg.sender);
272     }
273 
274     /**
275       * @dev low level token purchase ***DO NOT OVERRIDE***
276       * @param _investor Address performing the token purchase
277       */
278     function investFund(address _investor) public payable {
279         //
280         uint256 weiAmount = msg.value;
281         
282         _preValidatePurchase(_investor, weiAmount);
283         
284         weiRaised = weiRaised.add(weiAmount);
285         
286         _trackVault(_investor, weiAmount);
287         
288         _forwardFunds();
289 
290         emit Investment(_investor, weiAmount);
291     }
292     
293     /**
294     * @dev Gets the invested fund specified address.
295     * @param _investor The address to query the the balance of invested amount.
296     * @return An uint256 representing the invested amount by the passed address.
297     */
298     function investmentOf(address _investor) public view returns (uint256) {
299         return _investorsVault[_investor];
300     }
301 
302     /**
303     * @dev token request from invested ETH.
304     * @param _ethInWei investor want to invest ether amount.
305     * @return An uint256 representing the invested amount by the passed address.
306     */
307     function purchaseTokenFromInvestment(uint256 _ethInWei) public {
308             ///
309             require(_investorsVault[msg.sender] != 0);
310 
311             ///
312             uint256 _token = _getTokenAmount(_ethInWei);
313             
314             _investorsVault[msg.sender] = _investorsVault[msg.sender].sub(_ethInWei);
315 
316             _investorsInvestmentInToken[msg.sender] = _investorsInvestmentInToken[msg.sender].add(_token);
317             
318             emit TokenPurchaseRequestFromInvestment(msg.sender, _token);
319     }
320 
321     /**
322     * @dev Gets the investment token request for token.
323     * @param _investor The address to query the the balance of invested amount.
324     * @return An uint256 representing the invested amount by the passed address.
325     */
326     function tokenInvestmentRequest(address _investor) public view returns (uint256) {
327         return _investorsInvestmentInToken[_investor];
328     }
329 
330     /**
331     * @dev Gets the invested fund specified address.
332     * @param _investor The address to query the the balance of invested amount.
333     * @return An uint256 representing the invested amount by the passed address.
334     */
335     function approveTokenInvestmentRequest(address _investor) public onlyAdmin {
336         //
337         uint256 token = _investorsInvestmentInToken[_investor];
338         require(token != 0);
339         //
340         super.transfer(_investor, _investorsInvestmentInToken[_investor]);
341         
342         _investorsInvestmentInToken[_investor] = _investorsInvestmentInToken[_investor].sub(token);
343         
344         emit ApproveTokenPurchaseRequest(_investor, token);
345     }
346 
347    /**
348     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
349     * @param _beneficiary Address performing the token purchase
350     * @param _weiAmount Value in wei involved in the purchase
351     */
352     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal pure {
353         require(_beneficiary != address(0));
354         require(_weiAmount != 0);
355         
356         // must be greater than 1/2 ETH.
357         require(_weiAmount >= 0.5 ether);
358     }
359 
360    /**
361     * @dev tracing of incoming fund from investors.
362     * @param _investor Address performing the token purchase
363     * @param _weiAmount Value in wei involved in the purchase
364     */
365     function _trackVault(address _investor, uint256 _weiAmount) internal {
366         _investorsVault[_investor] = _investorsVault[_investor].add(_weiAmount);
367     }
368 
369     /**
370     * @dev Determines how ETH is stored/forwarded on investment.
371     */
372     function _forwardFunds() internal {
373         nlcAdminAddress.transfer(msg.value);
374     }
375 
376     /**
377     * @dev Override to extend the way in which ether is converted to tokens.
378     * @param _weiAmount Value in wei to be converted into tokens
379     * @return Number of tokens that can be purchased with the specified _weiAmount
380     */
381     function _getTokenAmount(uint256 _weiAmount)
382         internal view returns (uint256)
383     {
384         return _weiAmount.mul(rate).div(1 ether);
385     }
386 
387 }