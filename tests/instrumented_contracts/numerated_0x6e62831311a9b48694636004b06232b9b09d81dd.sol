1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 library SafeERC20 {
46     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
47         assert(token.transfer(to, value));
48     }
49 
50     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
51         assert(token.transferFrom(from, to, value));
52     }
53 
54     function safeApprove(ERC20 token, address spender, uint256 value) internal {
55         assert(token.approve(spender, value));
56     }
57 }
58 
59 contract Ownable {
60     address public owner;
61 
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66     /**
67      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68      * account.
69      */
70     function Ownable() public {
71         owner = msg.sender;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     /**
83      * @dev Allows the current owner to transfer control of the contract to a newOwner.
84      * @param newOwner The address to transfer ownership to.
85      */
86     function transferOwnership(address newOwner) public onlyOwner {
87         require(newOwner != address(0));
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90     }
91 }
92 
93 library Math {
94     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
95         return a >= b ? a : b;
96     }
97 
98     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
99         return a < b ? a : b;
100     }
101 
102     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a >= b ? a : b;
104     }
105 
106     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a < b ? a : b;
108     }
109 }
110 
111 contract ERC20Basic {
112     function totalSupply() public view returns (uint256);
113 
114     function balanceOf(address who) public view returns (uint256);
115 
116     function transfer(address to, uint256 value) public returns (bool);
117 
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 }
120 
121 contract ERC20 is ERC20Basic {
122     function allowance(address owner, address spender) public view returns (uint256);
123 
124     function transferFrom(address from, address to, uint256 value) public returns (bool);
125 
126     function approve(address spender, uint256 value) public returns (bool);
127 
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 
132 contract BasicToken is ERC20Basic {
133     using SafeMath for uint256;
134 
135     mapping(address => uint256) balances;
136 
137     uint256 totalSupply_;
138 
139     /**
140     * @dev total number of tokens in existence
141     */
142     function totalSupply() public view returns (uint256) {
143         return totalSupply_;
144     }
145 
146     /**
147     * @dev transfer token for a specified address
148     * @param _to The address to transfer to.
149     * @param _value The amount to be transferred.
150     */
151     function transfer(address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153         require(_value <= balances[msg.sender]);
154 
155         // SafeMath.sub will throw if there is not enough balance.
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         Transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162     /**
163     * @dev Gets the balance of the specified address.
164     * @param _owner The address to query the the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167     function balanceOf(address _owner) public view returns (uint256 balance) {
168         return balances[_owner];
169     }
170 
171 }
172 
173 contract StandardToken is ERC20, BasicToken {
174 
175     mapping(address => mapping(address => uint256)) internal allowed;
176 
177 
178     /**
179      * @dev Transfer tokens from one address to another
180      * @param _from address The address which you want to send tokens from
181      * @param _to address The address which you want to transfer to
182      * @param _value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185         require(_to != address(0));
186         require(_value <= balances[_from]);
187         require(_value <= allowed[_from][msg.sender]);
188 
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192         Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198      *
199      * Beware that changing an allowance with this method brings the risk that someone may use both the old
200      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      * @param _spender The address which will spend the funds.
204      * @param _value The amount of tokens to be spent.
205      */
206     function approve(address _spender, uint256 _value) public returns (bool) {
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param _owner address The address which owns the funds.
215      * @param _spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address _owner, address _spender) public view returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221 
222     /**
223      * @dev Increase the amount of tokens that an owner allowed to a spender.
224      *
225      * approve should be called when allowed[_spender] == 0. To increment
226      * allowed value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      * @param _spender The address which will spend the funds.
230      * @param _addedValue The amount of tokens to increase the allowance by.
231      */
232     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235         return true;
236     }
237 
238     /**
239      * @dev Decrease the amount of tokens that an owner allowed to a spender.
240      *
241      * approve should be called when allowed[_spender] == 0. To decrement
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * @param _spender The address which will spend the funds.
246      * @param _subtractedValue The amount of tokens to decrease the allowance by.
247      */
248     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249         uint oldValue = allowed[msg.sender][_spender];
250         if (_subtractedValue > oldValue) {
251             allowed[msg.sender][_spender] = 0;
252         } else {
253             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254         }
255         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256         return true;
257     }
258 
259 }
260 
261 contract EthRateOracle is Ownable {
262     uint256 public ethUsdRate;
263 
264     function update(uint256 _newValue) public onlyOwner {
265         ethUsdRate = _newValue;
266     }
267 }
268 
269 contract JokerToken is StandardToken, Ownable {
270     string public name;
271     string public symbol;
272     uint8 public decimals;
273 
274     EthRateOracle public oracle;
275     uint256 public soldTokensCount = 0;
276 
277     // first period token price
278     uint256 public tokenStartPrice;
279 
280     // second phase token cost in cents
281     uint256 public tokenSecondPeriodPrice;
282 
283     uint256 public sPerDate;
284     uint256 public sPeriodEndDate;
285     uint256 public sPeriodSoldTokensLimit;
286 
287     // not for sell vars pool
288     uint256 public nfsPoolLeft;
289     uint256 public nfsPoolCount;
290 
291     uint256 public transfersAllowDate;
292 
293     constructor() public {
294         name = "Joker.buzz token";
295         symbol = "JOKER";
296         decimals = 18;
297         // in us cents
298         tokenStartPrice = 40;
299         // not for sell
300         nfsPoolCount = 10900000 * (uint256(10) ** decimals);
301         nfsPoolLeft = nfsPoolCount;
302         // period 2, another price, and after some date
303         tokenSecondPeriodPrice = 200;
304         sPerDate = now + 179 days;
305         sPeriodEndDate = now + 284 days;
306         sPeriodSoldTokensLimit = (totalSupply_ - nfsPoolCount) - 1200000 * (uint256(10) ** decimals);
307         // transfer ability
308         transfersAllowDate = now + 284 days;
309         totalSupply_ = 20000000 * (uint256(10) ** decimals);
310     }
311 
312 
313 
314     function nfsPoolTransfer(address _to, uint256 _value) public onlyOwner returns (bool) {
315         require(nfsPoolLeft >= _value, "Value more than tokens left");
316         require(_to != address(0), "Not allowed send to trash tokens");
317 
318         nfsPoolLeft -= _value;
319         balances[_to] = balances[_to].add(_value);
320 
321         emit Transfer(address(0), _to, _value);
322 
323         return true;
324     }
325 
326     function transfer(address _to, uint256 _value) public returns (bool) {
327         require(transfersAllowDate <= now, "Function cannot be called at this time.");
328 
329         return BasicToken.transfer(_to, _value);
330     }
331 
332     function() public payable {
333         uint256 tokensCount;
334         require(150000000000000 <= msg.value, "min limit eth");
335         uint256 ethUsdRate = oracle.ethUsdRate();
336         require(sPeriodEndDate >= now, "Sell tokens all periods ended");
337         bool isSecondPeriodNow = now >= sPerDate;
338         bool isSecondPeriodTokensLimitReached = soldTokensCount >= (totalSupply_ - sPeriodSoldTokensLimit - nfsPoolCount);
339 
340         if (isSecondPeriodNow || isSecondPeriodTokensLimitReached) {
341             tokensCount = msg.value * ethUsdRate / tokenSecondPeriodPrice;
342         } else {
343             tokensCount = msg.value * ethUsdRate / tokenStartPrice;
344 
345             uint256 sPeriodTokensCount = reminderCalc(soldTokensCount + tokensCount, totalSupply_ - sPeriodSoldTokensLimit - nfsPoolCount);
346 
347             if (sPeriodTokensCount > 0) {
348                 tokensCount -= sPeriodTokensCount;
349 
350                 uint256 weiLeft = sPeriodTokensCount * tokenStartPrice / ethUsdRate;
351 
352                 tokensCount += weiLeft * ethUsdRate / tokenSecondPeriodPrice;
353             }
354         }
355         require(tokensCount > 0, "tokens count must be positive");
356         require((soldTokensCount + tokensCount) <= (totalSupply_ - nfsPoolCount), "tokens limit");
357 
358         balances[msg.sender] += tokensCount;
359         soldTokensCount += tokensCount;
360 
361         emit Transfer(address(0), msg.sender, tokensCount);
362     }
363 
364     function reminderCalc(uint256 x, uint256 y) internal pure returns (uint256) {
365         if (y >= x) {
366             return 0;
367         }
368         return x - y;
369     }
370 
371     function setOracleAddress(address _oracleAddress) public onlyOwner {
372         oracle = EthRateOracle(_oracleAddress);
373     }
374 
375     function weiBalance() public constant returns (uint weiBal) {
376         return address(this).balance;
377     }
378 
379     function weiToOwner(address _address, uint amount) public onlyOwner {
380         require(amount <= address(this).balance);
381         _address.transfer(amount);
382     }
383 
384     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
385         require(transfersAllowDate <= now);
386 
387         return StandardToken.transferFrom(_from, _to, _value);
388     }
389 }