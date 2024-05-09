1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
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
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }   
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 }
86 
87 /** 
88  * @title Based on the 'final' ERC20 token standard as specified at:
89  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md 
90  */
91 contract ERC20Interface {
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 
95     function name() public view returns (string);
96     function symbol() public view returns (string);
97     function decimals() public view returns (uint8);
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address _owner) public view returns (uint256);
100     function allowance(address _owner, address _spender) public view returns (uint256);
101     function transfer(address _to, uint256 _value) public returns (bool);
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
103     function approve(address _spender, uint256 _value) public returns (bool);
104 }
105 
106 /**
107  * @title TestToken
108  * @dev The TestToken contract provides the token functionality of the IPT Global token
109  * and allows the admin to distribute frozen tokens which requires defrosting to become transferable.
110  */
111 contract TestToken is ERC20Interface, Ownable {
112     using SafeMath for uint256;
113     
114     //Name of the token.
115     string  internal constant NAME = "Test Token";
116     
117     //Symbol of the token.
118     string  internal constant SYMBOL = "TEST";     
119     
120     //Granularity of the token.
121     uint8   internal constant DECIMALS = 8;        
122     
123     //Factor for numerical calculations.
124     uint256 internal constant DECIMALFACTOR = 10 ** uint(DECIMALS); 
125     
126     //Total supply of IPT Global tokens.
127     uint256 internal constant TOTAL_SUPPLY = 300000000 * uint256(DECIMALFACTOR);  
128     
129     //Base defrosting value used to calculate fractional percentage of 0.2 %
130     uint8 internal constant standardDefrostingValue = 2;
131     
132     //Base defrosting numerator used to calculate fractional percentage of 0.2 %
133     uint8 internal constant standardDefrostingNumerator = 10;
134 
135     
136     //Stores all frozen TEST Global token holders.
137     mapping(address => bool)    public frostbite;
138     
139     //Stores received frozen IPT Global tokens in an accumulated fashion. 
140     mapping(address => uint256) public frozenTokensReceived;
141     
142     //Stores and tracks frozen IPT Global token balances.
143     mapping(address => uint256) public frozenBalance;
144     
145     //Stores custom frozen IPT Global token defrosting % rates. 
146     mapping(address => uint8) public customDefrostingRate;
147     
148     //Stores the balance of IPT Global holders (complies with ERC-Standard).
149     mapping(address => uint256) internal balances; 
150     
151     //Stores any allowances given to other IPT Global holders.
152     mapping(address => mapping(address => uint256)) internal allowed; 
153     
154     
155     //Event which allows for logging of frostbite granting activities.
156     event FrostbiteGranted(
157         address recipient, 
158         uint256 frozenAmount, 
159         uint256 defrostingRate);
160     
161     //Event which allows for logging of frostbite terminating activities.
162     event FrostBiteTerminated(
163         address recipient,
164         uint256 frozenBalance);
165     
166     //Event which allows for logging of frozen token transfer activities.
167     event FrozenTokensTransferred(
168         address owner, 
169         address recipient, 
170         uint256 frozenAmount, 
171         uint256 defrostingRate);
172     
173     //Event which allows for logging of custom frozen token defrosting activities.   
174     event CustomTokenDefrosting(
175         address owner,
176         uint256 percentage,
177         uint256 defrostedAmount);
178         
179     //Event which allows for logging of calculated frozen token defrosting activities.   
180     event CalculatedTokenDefrosting(
181         address owner,
182         uint256 defrostedAmount);
183     
184     //Event which allows for logging of complete recipient recovery activities.
185     event RecipientRecovered(
186         address recipient,
187         uint256 customDefrostingRate,
188         uint256 frozenBalance,
189         bool frostbite);
190      
191     //Event which allows for logging of recipient balance recovery activities.   
192     event FrozenBalanceDefrosted(
193         address recipient,
194         uint256 frozenBalance,
195         bool frostbite);
196     
197     //Event which allows for logging of defrostingrate-adjusting activities.
198     event DefrostingRateChanged(
199         address recipient,
200         uint256 defrostingRate);
201         
202     //Event which allows for logging of frozenBalance-adjusting activities.
203     event FrozenBalanceChanged(
204         address recipient, 
205         uint256 defrostedAmount);
206     
207     
208     /**
209      * @dev constructor sets initialises and configurates the smart contract.
210      * More specifically, it grants the smart contract owner the total supply
211      * of IPT Global tokens.
212      */
213     constructor() public {
214         balances[msg.sender] = TOTAL_SUPPLY;
215     }
216 
217 
218     /**
219      * @dev frozenTokenTransfer function allows the owner of the smart contract to Transfer
220      * frozen tokens (untransferable till melted) to a particular recipient.
221      * @param _recipient the address which will receive the frozen tokens.
222      * @param _frozenAmount the value which will be sent to the _recipient.
223      * @param _customDefrostingRate the rate at which the tokens will be melted.
224      * @return a boolean representing whether the function was executed succesfully.
225      */
226     function frozenTokenTransfer(address _recipient, uint256 _frozenAmount, uint8 _customDefrostingRate) external onlyOwner returns (bool) {
227         require(_recipient != address(0));
228         require(_frozenAmount <= balances[msg.sender]);
229         
230         frozenTokensReceived[_recipient] = _frozenAmount;
231                frozenBalance[_recipient] = _frozenAmount;
232         customDefrostingRate[_recipient] = _customDefrostingRate;
233                    frostbite[_recipient] = true;
234 
235         balances[msg.sender] = balances[msg.sender].sub(_frozenAmount);
236         balances[_recipient] = balances[_recipient].add(_frozenAmount);
237         
238         emit FrozenTokensTransferred(msg.sender, _recipient, _frozenAmount, customDefrostingRate[_recipient]);
239         return true;
240     }
241     
242     /**
243      * @dev changeCustomDefrostingRate function allows the owner of the smart contract to change individual custom defrosting rates.
244      * @param _recipient the address whose defrostingRate will be adjusted.
245      * @param _newCustomDefrostingRate the new defrosting rate which will be placed on the recipient.
246      * @return a boolean representing whether the function was executed succesfully.
247      */
248     function changeCustomDefrostingRate(address _recipient, uint8 _newCustomDefrostingRate) external onlyOwner returns (bool) {
249         require(_recipient != address(0));
250         require(frostbite[_recipient]);
251         
252         customDefrostingRate[_recipient] = _newCustomDefrostingRate;
253         
254         emit DefrostingRateChanged(_recipient, _newCustomDefrostingRate);
255         return true;
256     }
257     
258     /**
259      * @dev changeFrozenBalance function allows the owner of the smart contract to change individual particular frozen balances.
260      * @param _recipient the address whose defrostingRate will be adjusted.
261      * @param _defrostedAmount the defrosted/subtracted amount of an existing particular frozen balance..
262      * @return a boolean representing whether the function was executed succesfully.
263      */
264     function changeFrozenBalance(address _recipient, uint256 _defrostedAmount) external onlyOwner returns (bool) {
265         require(_recipient != address(0));
266         require(_defrostedAmount <= frozenBalance[_recipient]);
267         require(frostbite[_recipient]);
268         
269         frozenBalance[_recipient] = frozenBalance[_recipient].sub(_defrostedAmount);
270         
271         emit FrozenBalanceChanged(_recipient, _defrostedAmount);
272         return true;
273     }
274     
275     /**
276      * @dev removeFrozenTokenConfigurations function allows the owner of the smart contract to remove all 
277      * frostbites, frozenbalances and defrosting rates of an array of recipient addresses < 50.
278      * @param _recipients the address(es) which will be recovered.
279      * @return a boolean representing whether the function was executed succesfully.
280      */
281     function removeFrozenTokenConfigurations(address[] _recipients) external onlyOwner returns (bool) {
282         
283         for (uint256 i = 0; i < _recipients.length; i++) {
284             if (frostbite[_recipients[i]]) {
285                 customDefrostingRate[_recipients[i]] = 0;
286                        frozenBalance[_recipients[i]] = 0;
287                            frostbite[_recipients[i]] = false;
288                 
289                 emit RecipientRecovered(_recipients[i], customDefrostingRate[_recipients[i]], frozenBalance[_recipients[i]], false);
290             }
291         }
292         return true;
293     }
294     
295     /**
296      * @dev standardTokenDefrosting function allows the owner of the smart contract to defrost
297      * frozen tokens based on a base defrosting Rate of 0.2 % (from multiple recipients at once if desired) of particular recipient addresses < 50.
298      * @param _recipients the address(es) which will receive defrosting of frozen tokens.
299      * @return a boolean representing whether the function was executed succesfully.
300      */
301     function standardTokenDefrosting(address[] _recipients) external onlyOwner returns (bool) {
302         
303         for (uint256 i = 0; i < _recipients.length; i++) {
304             if (frostbite[_recipients[i]]) {
305                 uint256 defrostedAmount = (frozenTokensReceived[_recipients[i]].mul(standardDefrostingValue).div(standardDefrostingNumerator)).div(100);
306                 
307                 frozenBalance[_recipients[i]] = frozenBalance[_recipients[i]].sub(defrostedAmount);
308                 
309                 emit CalculatedTokenDefrosting(msg.sender, defrostedAmount);
310             }
311             if (frozenBalance[_recipients[i]] == 0) {
312                          frostbite[_recipients[i]] = false;
313                          
314                 emit FrozenBalanceDefrosted(_recipients[i], frozenBalance[_recipients[i]], false);
315             }
316         }
317         return true;
318     }
319     
320     /**
321      * @dev customTokenDefrosting function allows the owner of the smart contract to defrost
322      * frozen tokens based on custom defrosting Rates (from multiple recipients at once if desired) of particular recipient addresses < 50.
323      * @param _recipients the address(es) which will receive defrosting of frozen tokens.
324      * @return a boolean representing whether the function was executed succesfully.
325      */
326     function customTokenDefrosting(address[] _recipients) external onlyOwner returns (bool) {
327         
328         for (uint256 i = 0; i < _recipients.length; i++) {
329             if (frostbite[_recipients[i]]) {
330                 uint256 defrostedAmount = (frozenTokensReceived[_recipients[i]].mul(customDefrostingRate[_recipients[i]])).div(100);
331                 
332                 frozenBalance[_recipients[i]] = frozenBalance[_recipients[i]].sub(defrostedAmount);
333                
334                 emit CustomTokenDefrosting(msg.sender, customDefrostingRate[_recipients[i]], defrostedAmount);
335             }
336             if (frozenBalance[_recipients[i]] == 0) {
337                          frostbite[_recipients[i]] = false;
338                          
339                     emit FrozenBalanceDefrosted(_recipients[i], frozenBalance[_recipients[i]], false);
340             }
341         }
342         return true;
343     }
344     
345     /**
346      * @dev Transfer token for a specified address
347      * @param _to The address to transfer to.
348      * @param _value The amount to be transferred.
349      * @return a boolean representing whether the function was executed succesfully.
350      */
351     function transfer(address _to, uint256 _value) public returns (bool) {
352         require(_to != address(0));
353         require(_value <= balances[msg.sender]);
354         
355         if (frostbite[msg.sender]) {
356             require(_value <= balances[msg.sender].sub(frozenBalance[msg.sender]));
357         }
358         
359         balances[msg.sender] = balances[msg.sender].sub(_value);
360         balances[_to] = balances[_to].add(_value);
361         emit Transfer(msg.sender, _to, _value);
362         return true;
363          
364     }
365     
366     /**
367      * @dev Transfer tokens from one address to another
368      * @param _from address The address which you want to send tokens from
369      * @param _to address The address which you want to transfer to
370      * @param _value uint256 the amount of tokens to be transferred
371      * @return a boolean representing whether the function was executed succesfully.
372      */
373     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
374         require(_to != address(0));
375         require(_value <= balances[_from]);
376         require(_value <= allowed[_from][msg.sender]);
377         
378         if (frostbite[_from]) {
379             require(_value <= balances[_from].sub(frozenBalance[_from]));
380             require(_value <= allowed[_from][msg.sender]);
381         }
382 
383         balances[_from] = balances[_from].sub(_value);
384         balances[_to] = balances[_to].add(_value);
385         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
386         emit Transfer(_from, _to, _value);
387         return true;
388     }
389 
390     /**
391      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
392      * Beware that changing an allowance with this method brings the risk that someone may use both the old
393      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
394      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
396      * @param _spender The address which will spend the funds.
397      * @param _value The amount of tokens to be spent.
398      * @return a boolean representing whether the function was executed succesfully.
399      */
400     function approve(address _spender, uint256 _value) public returns (bool) {
401         allowed[msg.sender][_spender] = _value;
402         emit Approval(msg.sender, _spender, _value);
403         return true;
404     }
405     
406     /**
407      * @dev balanceOf function gets the balance of the specified address.
408      * @param _owner The address to query the balance of.
409      * @return An uint256 representing the token balance of the passed address.
410      */
411     function balanceOf(address _owner) public view returns (uint256 balance) {
412         return balances[_owner];
413     }
414         
415     /**
416      * @dev allowance function checks the amount of tokens allowed by an owner for a spender to spend.
417      * @param _owner address is the address which owns the spendable funds.
418      * @param _spender address is the address which will spend the owned funds.
419      * @return A uint256 specifying the amount of tokens which are still available for the spender.
420      */
421     function allowance(address _owner, address _spender) public view returns (uint256) {
422         return allowed[_owner][_spender];
423     }
424     
425     /**
426      * @dev totalSupply function returns the total supply of tokens.
427      */
428     function totalSupply() public view returns (uint256) {
429         return TOTAL_SUPPLY;
430     }
431     
432     /** 
433      * @dev decimals function returns the decimal units of the token. 
434      */
435     function decimals() public view returns (uint8) {
436         return DECIMALS;
437     }
438             
439     /** 
440      * @dev symbol function returns the symbol ticker of the token. 
441      */
442     function symbol() public view returns (string) {
443         return SYMBOL;
444     }
445     
446     /** 
447      * @dev name function returns the name of the token. 
448      */
449     function name() public view returns (string) {
450         return NAME;
451     }
452 }