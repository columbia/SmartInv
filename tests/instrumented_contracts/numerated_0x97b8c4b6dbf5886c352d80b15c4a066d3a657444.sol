1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28 }
29 
30 contract ERC20 {
31     uint256 public totalSupply;
32 
33     bool public transfersEnabled;
34 
35     function balanceOf(address _owner) public constant returns (uint256 balance);
36 
37     function transfer(address _to, uint256 _value) public returns (bool success);
38 
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 
41     function approve(address _spender, uint256 _value) public returns (bool success);
42 
43     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46 
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract ERC223Basic {
51     uint256 public totalSupply;
52 
53     bool public transfersEnabled;
54 
55     function balanceOf(address who) public view returns (uint256);
56 
57     function transfer(address to, uint256 value) public returns (bool);
58 
59     function transfer(address to, uint256 value, bytes data) public;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
62 
63 }
64 
65 contract ERC223ReceivingContract {
66     /**
67      * @dev Standard ERC223 function that will handle incoming token transfers.
68      *
69      * @param _from  Token sender address.
70      * @param _value Amount of tokens.
71      * @param _data  Transaction metadata.
72      */
73     function tokenFallback(address _from, uint _value, bytes _data) public;
74 }
75 
76 contract ERC223Token is ERC20, ERC223Basic {
77     using SafeMath for uint256;
78 
79     mapping(address => uint256) balances; // List of user balances.
80 
81     /**
82     * @dev protection against short address attack
83     */
84     modifier onlyPayloadSize(uint numwords) {
85         assert(msg.data.length == numwords * 32 + 4);
86         _;
87     }
88 
89     /**
90      * @dev Transfer the specified amount of tokens to the specified address.
91      *      Invokes the `tokenFallback` function if the recipient is a contract.
92      *      The token transfer fails if the recipient is a contract
93      *      but does not implement the `tokenFallback` function
94      *      or the fallback function to receive funds.
95      *
96      * @param _to    Receiver address.
97      * @param _value Amount of tokens that will be transferred.
98      * @param _data  Transaction metadata.
99      */
100     function transfer(address _to, uint _value, bytes _data) public onlyPayloadSize(3) {
101         // Standard function transfer similar to ERC20 transfer with no _data .
102         // Added due to backwards compatibility reasons .
103         uint codeLength;
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106         require(transfersEnabled);
107 
108         assembly {
109         // Retrieve the size of the code on target address, this needs assembly .
110             codeLength := extcodesize(_to)
111         }
112 
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         if(codeLength>0) {
116             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
117             receiver.tokenFallback(msg.sender, _value, _data);
118         }
119         emit Transfer(msg.sender, _to, _value, _data);
120     }
121 
122     /**
123      * @dev Transfer the specified amount of tokens to the specified address.
124      *      This function works the same with the previous one
125      *      but doesn't contain `_data` param.
126      *      Added due to backwards compatibility reasons.
127      *
128      * @param _to    Receiver address.
129      * @param _value Amount of tokens that will be transferred.
130      */
131     function transfer(address _to, uint _value) public onlyPayloadSize(2) returns(bool) {
132         uint codeLength;
133         bytes memory empty;
134         require(_to != address(0));
135         require(_value <= balances[msg.sender]);
136         require(transfersEnabled);
137 
138         assembly {
139         // Retrieve the size of the code on target address, this needs assembly .
140             codeLength := extcodesize(_to)
141         }
142 
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         if(codeLength>0) {
146             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
147             receiver.tokenFallback(msg.sender, _value, empty);
148         }
149         emit Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153 
154     /**
155      * @dev Returns balance of the `_owner`.
156      *
157      * @param _owner   The address whose balance will be returned.
158      * @return balance Balance of the `_owner`.
159      */
160     function balanceOf(address _owner) public constant returns (uint256 balance) {
161         return balances[_owner];
162     }
163 }
164 
165 contract StandardToken is ERC223Token {
166 
167     mapping(address => mapping(address => uint256)) internal allowed;
168 
169     /**
170      * @dev Transfer tokens from one address to another
171      * @param _from address The address which you want to send tokens from
172      * @param _to address The address which you want to transfer to
173      * @param _value uint256 the amount of tokens to be transferred
174      */
175     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
176         require(_to != address(0));
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179         require(transfersEnabled);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184         emit Transfer(_from, _to, _value);
185         return true;
186     }
187 
188     /**
189      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190      *
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215      * approve should be called when allowed[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      */
220     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
227         uint oldValue = allowed[msg.sender][_spender];
228         if (_subtractedValue > oldValue) {
229             allowed[msg.sender][_spender] = 0;
230         } else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237 }
238 
239 contract TRIPLER is StandardToken {
240 
241     string public constant name = "TRIPLER";
242     string public constant symbol = "TPR";
243     uint8 public constant decimals = 18;
244     uint256 public constant INITIAL_SUPPLY = 2000000000000000000000000000;
245     address public owner;
246     mapping (address => bool) public contractUsers;
247     bool public mintingFinished;
248     uint256 public tokenAllocated = 0;
249     // list of valid claim` 
250     mapping (address => uint) public countClaimsToken;
251 
252     uint256 public priceToken = 950000;
253     uint256 public priceClaim = 0.0005 ether;
254     uint256 public numberClaimToken = 500 * (10**uint256(decimals));
255     uint256 public startTimeDay = 1;
256     uint256 public endTimeDay = 86400;
257 
258     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
259     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
260     event TokenLimitReached(uint256 tokenRaised, uint256 purchasedToken);
261     event MinWeiLimitReached(address indexed sender, uint256 weiAmount);
262     event Mint(address indexed to, uint256 amount);
263     event MintFinished();
264 
265     constructor(address _owner) public {
266         totalSupply = INITIAL_SUPPLY;
267         owner = _owner;
268         //owner = msg.sender; // for test's
269         balances[owner] = INITIAL_SUPPLY;
270         transfersEnabled = true;
271         mintingFinished = false;
272     }
273 
274     // fallback function can be used to buy tokens
275     function() payable public {
276         buyTokens(msg.sender);
277     }
278 
279     function buyTokens(address _investor) public payable returns (uint256){
280         require(_investor != address(0));
281         uint256 weiAmount = msg.value;
282         uint256 tokens = validPurchaseTokens(weiAmount);
283         if (tokens == 0) {revert();}
284         tokenAllocated = tokenAllocated.add(tokens);
285         mint(_investor, tokens, owner);
286 
287         emit TokenPurchase(_investor, weiAmount, tokens);
288         owner.transfer(weiAmount);
289         return tokens;
290     }
291 
292     function validPurchaseTokens(uint256 _weiAmount) public returns (uint256) {
293         uint256 addTokens = _weiAmount.mul(priceToken);
294         if (_weiAmount < 0.05 ether) {
295             emit MinWeiLimitReached(msg.sender, _weiAmount);
296             return 0;
297         }
298         if (tokenAllocated.add(addTokens) > balances[owner]) {
299             emit TokenLimitReached(tokenAllocated, addTokens);
300             return 0;
301         }
302         return addTokens;
303     }
304 
305     modifier onlyOwner() {
306         require(msg.sender == owner);
307         _;
308     }
309 
310     modifier canMint() {
311         require(!mintingFinished);
312         _;
313     }
314 
315     /**
316      * @dev Function to stop minting new tokens.
317      * @return True if the operation was successful.
318      */
319     function finishMinting() onlyOwner canMint public returns (bool) {
320         mintingFinished = true;
321         emit MintFinished();
322         return true;
323     }
324 
325     function changeOwner(address _newOwner) onlyOwner public returns (bool){
326         require(_newOwner != address(0));
327         emit OwnerChanged(owner, _newOwner);
328         owner = _newOwner;
329         return true;
330     }
331 
332     function enableTransfers(bool _transfersEnabled) onlyOwner public {
333         transfersEnabled = _transfersEnabled;
334     }
335 
336     /**
337      * @dev Function to mint tokens
338      * @param _to The address that will receive the minted tokens.
339      * @param _amount The amount of tokens to mint.
340      * @return A boolean that indicates if the operation was successful.
341      */
342     function mint(address _to, uint256 _amount, address _owner) canMint internal returns (bool) {
343         require(_to != address(0));
344         require(_amount <= balances[owner]);
345         require(!mintingFinished);
346         balances[_to] = balances[_to].add(_amount);
347         balances[_owner] = balances[_owner].sub(_amount);
348         emit Mint(_to, _amount);
349         emit Transfer(_owner, _to, _amount);
350         return true;
351     }
352 
353     function claim() canMint public payable returns (bool) {
354         uint256 currentTime = now;
355         //currentTime = 1540037100; //for test's
356         require(validPurchaseTime(currentTime));
357         require(msg.value >= priceClaim);
358         address beneficiar = msg.sender;
359         require(beneficiar != address(0));
360         require(!mintingFinished);
361 
362         uint256 amount = calcAmount(beneficiar);
363         require(amount <= balances[owner]);
364 
365         balances[beneficiar] = balances[beneficiar].add(amount);
366         balances[owner] = balances[owner].sub(amount);
367         tokenAllocated = tokenAllocated.add(amount);
368         owner.transfer(msg.value);
369         emit Mint(beneficiar, amount);
370         emit Transfer(owner, beneficiar, amount);
371         return true;
372     }
373 
374     //function calcAmount(address _beneficiar) canMint public returns (uint256 amount) { //for test's
375     function calcAmount(address _beneficiar) canMint internal returns (uint256 amount) {
376         if (countClaimsToken[_beneficiar] == 0) {
377             countClaimsToken[_beneficiar] = 1;
378         }
379         if (countClaimsToken[_beneficiar] >= 1000) {
380             return 0;
381         }
382         uint step = countClaimsToken[_beneficiar];
383         amount = numberClaimToken.mul(105 - 5*step).div(100);
384         countClaimsToken[_beneficiar] = countClaimsToken[_beneficiar].add(1);
385     }
386 
387     function validPurchaseTime(uint256 _currentTime) canMint public view returns (bool) {
388         uint256 dayTime = _currentTime % 1 days;
389         if (startTimeDay <= dayTime && dayTime <=  endTimeDay) {
390             return true;
391         }
392         return false;
393     }
394 
395     function changeTime(uint256 _newStartTimeDay, uint256 _newEndTimeDay) public {
396         require(0 < _newStartTimeDay && 0 < _newEndTimeDay);
397         startTimeDay = _newStartTimeDay;
398         endTimeDay = _newEndTimeDay;
399     }
400 
401     /**
402      * Peterson's Law Protection
403      * Claim tokens
404      */
405     function claimTokensToOwner(address _token) public onlyOwner {
406         if (_token == 0x0) {
407             owner.transfer(address(this).balance);
408             return;
409         }
410         TRIPLER token = TRIPLER(_token);
411         uint256 balance = token.balanceOf(this);
412         token.transfer(owner, balance);
413         emit Transfer(_token, owner, balance);
414     }
415 
416     function setPriceClaim(uint256 _newPriceClaim) external onlyOwner {
417         require(_newPriceClaim > 0);
418         priceClaim = _newPriceClaim;
419     }
420 
421     function setNumberClaimToken(uint256 _newNumClaimToken) external onlyOwner {
422         require(_newNumClaimToken > 0);
423         numberClaimToken = _newNumClaimToken;
424     }
425 
426 }