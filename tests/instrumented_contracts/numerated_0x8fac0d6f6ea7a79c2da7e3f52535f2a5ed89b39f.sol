1 contract ERC20 {
2     function totalSupply() public view returns (uint256);
3     function balanceOf(address who) public view returns (uint256);
4     function transfer(address to, uint256 value) public returns (bool);
5     event Transfer(address indexed from, address indexed to, uint256 value);
6     function allowance(address owner, address spender) public view returns (uint256);
7 
8     function transferFrom(address from, address to, uint256 value) public returns (bool);
9 
10     function approve(address spender, uint256 value) public returns (bool);
11     event Approval(
12       address indexed owner,
13       address indexed spender,
14       uint256 value
15     );
16 }library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
23     // benefit is lost if 'b' is also tested.
24     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
25     if (a == 0) {
26       return 0;
27     }
28 
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }contract PostboyToken is ERC20 {
61     using SafeMath for uint256;
62 
63     struct Account {
64         uint256 balance;
65         uint256 lastDividends;
66     }
67 
68     string public constant name = "PostboyToken"; // solium-disable-line uppercase
69     string public constant symbol = "PBY"; // solium-disable-line uppercase
70     uint8 public constant decimals = 0; // solium-disable-line uppercase
71 
72     uint256 public constant INITIAL_SUPPLY = 100000;
73 
74     uint256 public totalDividends;
75     uint256 totalSupply_;
76     
77     mapping (address => Account) accounts;
78     mapping (address => mapping (address => uint256)) internal allowed;
79 
80     address public admin;
81     address public payer;
82 
83   /**
84    * @dev Constructor that gives msg.sender all of existing tokens.
85    */
86     constructor() public {
87         totalSupply_ = INITIAL_SUPPLY;
88         totalDividends = 0;
89         accounts[msg.sender].balance = INITIAL_SUPPLY;
90         admin = msg.sender;
91         payer = address(0);
92         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
93     }
94 
95     /**
96     * @dev Total number of tokens in existence
97     */
98     function totalSupply() public view returns (uint256) {
99         return totalSupply_;
100     }
101 
102     /**
103     * @dev Transfer token for a specified address
104     * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106     */
107     function transfer(address _to, uint256 _value) public returns (bool) {
108         _transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     /**
113     * @dev Transfer tokens from one address to another
114     * @param _from address The address which you want to send tokens from
115     * @param _to address The address which you want to transfer to
116     * @param _value uint256 the amount of tokens to be transferred
117     */
118     function transferFrom(
119         address _from,
120         address _to,
121         uint256 _value
122     )
123       public
124       returns (bool)
125     {
126         require(_value <= allowed[_from][msg.sender]);
127 
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         _transfer(_from, _to, _value);
130 
131         return true;
132     }
133 
134     /**
135     * @dev Gets the balance of the specified address.
136     * @param _owner The address to query the the balance of.
137     * @return An uint256 representing the amount owned by the passed address.
138     */
139     function balanceOf(address _owner) public view returns (uint256) {
140         return accounts[_owner].balance;
141     }
142 
143     /**
144     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145     * Beware that changing an allowance with this method brings the risk that someone may use both the old
146     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149     * @param _spender The address which will spend the funds.
150     * @param _value The amount of tokens to be spent.
151     */
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     /**
159     * @dev Function to check the amount of tokens that an owner allowed to a spender.
160     * @param _owner address The address which owns the funds.
161     * @param _spender address The address which will spend the funds.
162     * @return A uint256 specifying the amount of tokens still available for the spender.
163     */
164     function allowance(
165         address _owner,
166         address _spender
167     )
168       public
169       view
170       returns (uint256)
171     {
172         return allowed[_owner][_spender];
173     }
174 
175     /**
176     * @dev Increase the amount of tokens that an owner allowed to a spender.
177     * approve should be called when allowed[_spender] == 0. To increment
178     * allowed value is better to use this function to avoid 2 calls (and wait until
179     * the first transaction is mined)
180     * From MonolithDAO Token.sol
181     * @param _spender The address which will spend the funds.
182     * @param _addedValue The amount of tokens to increase the allowance by.
183     */
184     function increaseApproval(
185         address _spender,
186         uint256 _addedValue
187     )
188       public
189       returns (bool)
190     {
191         allowed[msg.sender][_spender] = (
192             allowed[msg.sender][_spender].add(_addedValue));
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 
197     /**
198     * @dev Decrease the amount of tokens that an owner allowed to a spender.
199     * approve should be called when allowed[_spender] == 0. To decrement
200     * allowed value is better to use this function to avoid 2 calls (and wait until
201     * the first transaction is mined)
202     * From MonolithDAO Token.sol
203     * @param _spender The address which will spend the funds.
204     * @param _subtractedValue The amount of tokens to decrease the allowance by.
205     */
206     function decreaseApproval(
207         address _spender,
208         uint256 _subtractedValue
209     )
210       public
211       returns (bool)
212     {
213         uint256 oldValue = allowed[msg.sender][_spender];
214         if (_subtractedValue > oldValue) {
215             allowed[msg.sender][_spender] = 0;
216         } else {
217             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218         }
219         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220         return true;
221     }
222 
223     /**
224     * @dev Get dividents sum by address
225     */
226     function dividendBalanceOf(address account) public view returns (uint256) {
227         uint256 newDividends = totalDividends.sub(accounts[account].lastDividends);
228         uint256 product = accounts[account].balance.mul(newDividends);
229         return product.div(totalSupply_);
230     }
231 
232     /**
233     * @dev Withdraw dividends
234     */
235     function claimDividend() public {
236         uint256 owing = dividendBalanceOf(msg.sender);
237         if (owing > 0) {
238             accounts[msg.sender].lastDividends = totalDividends;
239             msg.sender.transfer(owing);
240         }
241     }
242 
243 
244     /**
245     * @dev Tokens transfer will not work if sender or recipient has dividends
246     */
247     function _transfer(address _from, address _to, uint256 _value) internal {
248         require(_to != address(0));
249         require(_value <= accounts[_from].balance);
250         require(accounts[_to].balance + _value >= accounts[_to].balance);
251     
252         uint256 fromOwing = dividendBalanceOf(_from);
253         uint256 toOwing = dividendBalanceOf(_to);
254         require(fromOwing <= 0 && toOwing <= 0);
255     
256         accounts[_from].balance = accounts[_from].balance.sub(_value);
257         accounts[_to].balance = accounts[_to].balance.add(_value);
258     
259         accounts[_to].lastDividends = accounts[_from].lastDividends;
260     
261         emit Transfer(_from, _to, _value);
262     }
263 
264     function changePayer(address _payer) public returns (bool) {
265         require(msg.sender == admin);
266         payer = _payer;
267     }
268 
269     function sendDividends() public payable {
270         require(msg.sender == payer);
271         
272         totalDividends = totalDividends.add(msg.value);
273     }
274 
275     function () external payable {
276         require(false);
277     }
278 }contract PostboyTokenCrowdsale {
279     using SafeMath for uint256;
280 
281     // The token being sold
282     PostboyToken public token;
283 
284     address public adminAddress;
285 
286     uint256 public tokenPrice;
287 
288     uint256 public tokenStart;
289     uint256 public tokenSold;
290     bool public isActive;
291 
292     modifier isAdmin() {
293         require(msg.sender == adminAddress);
294         _;
295     }
296 
297     /**
298     * Event for token purchase logging
299     * @param purchaser who paid for the tokens
300     * @param beneficiary who got the tokens
301     * @param value weis paid for purchase
302     * @param amount amount of tokens purchased
303     */
304     event TokenPurchase(
305         address indexed purchaser,
306         address indexed beneficiary,
307         uint256 value,
308         uint256 amount
309     );
310 
311     constructor(uint256 _price, address _adminAddress, uint256 _startTokenCount, PostboyToken _token) public {
312         require(_price > 0);
313         require(_adminAddress != address(0));
314         require(_token != address(0));
315 
316         tokenPrice = _price;
317         adminAddress = _adminAddress;
318         token = _token;
319         tokenStart = _startTokenCount;
320         tokenSold = 0;
321         isActive = true;
322     }
323 
324     function () external payable {
325     }
326 
327     /**
328     * @dev low level token purchase ***DO NOT OVERRIDE***
329     * @param _beneficiary Address performing the token purchase
330     */
331     function buyTokens(address _beneficiary) public payable {
332         require(isActive);
333         uint256 weiAmount = msg.value;
334 
335         require(_beneficiary != address(0));
336         require(weiAmount != 0);
337 
338         // calculate token amount to be created
339         uint256 tokenAmount = weiAmount.div(tokenPrice);
340 
341         require(tokenAmount <= tokenStart.sub(tokenSold));
342 
343         tokenSold = tokenSold.add(tokenAmount);
344 
345         token.transfer(_beneficiary, tokenAmount);
346 
347         emit TokenPurchase(
348             msg.sender,
349             _beneficiary,
350             weiAmount,
351             tokenAmount
352         );
353     }
354 
355     function closeCrowdsale() isAdmin public {
356 
357         uint256 tokenAmount = tokenStart.sub(tokenSold);
358         isActive = false;
359 
360         token.transfer(msg.sender, tokenAmount);
361     }
362 
363     function withdrawEther() isAdmin public {
364         msg.sender.transfer(address(this).balance);
365     }
366 
367     function withdrawDividends() isAdmin public {
368         token.claimDividend();
369     }
370 
371     function getStatus() public view returns (uint256 crowdsaleBalance, uint256 tokenStartCount, uint256 tokenSoldCount, uint256 price, bool active) {
372         return (address(this).balance, tokenStart, tokenSold, tokenPrice, isActive);
373     }
374 }