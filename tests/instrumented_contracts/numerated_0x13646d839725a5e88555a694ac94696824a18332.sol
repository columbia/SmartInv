1 /**
2   * Legenrich LeRT token 
3   *
4   * More at https://legenrich.com
5   *
6   * Smart contract and payment gateway developed by https://smart2be.com, 
7   * Premium ICO campaign managing company
8   *
9   **/
10 
11 pragma solidity ^0.4.19;
12 
13 contract owned {
14     address public owner;
15 
16     function owned() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26         owner = newOwner;
27     }
28 }
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     if (a == 0) {
42       return 0;
43     }
44     uint256 c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   /**
50   * @dev Integer division of two numbers, truncating the quotient.
51   */
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   /**
60   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   /**
68   * @dev Adds two numbers, throws on overflow.
69   */
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
78 
79 
80 contract TokenERC20 is owned {
81     using SafeMath for uint256;
82  
83     bool public mintingFinished = false;
84 
85      modifier canMint {
86         require(!mintingFinished);
87         _;
88     }
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     // Public variables of the token
95     string public name;
96     string public symbol;
97     uint8 public decimals = 18;
98     uint256 public totalSupply;
99 
100     // This creates an array with all balances
101     mapping (address => uint256) public balanceOf;
102     mapping (address => mapping (address => uint256)) public allowed;
103      // List of Team and Founders account's frozen till 15 November 2018
104     mapping (address => uint256) public frozenAccount;
105 
106     // This generates a public event on the blockchain that will notify clients
107     event Transfer(address indexed from, address indexed to, uint256 value);
108     event Approval(address indexed from, address indexed spender, uint256 value);
109     event Frozen(address indexed from, uint256 till);
110 
111     // This notifies clients about the amount burnt
112     event Burn(address indexed from, uint256 value);
113     // Minting 
114     event Mint(address indexed to, uint256 amount);
115     event MintStarted();
116     event MintFinished();
117 
118     /**
119      * Constrctor function
120      *
121      * Initializes contract with initial supply tokens to the creator of the contract
122      */
123     function TokenERC20(
124         uint256 initialSupply,
125         string tokenName,
126         string tokenSymbol
127     ) public {
128         totalSupply = initialSupply * 10 ** uint256(decimals);      // Update total supply with the decimal amount
129         balanceOf[msg.sender] = totalSupply;                        // Give the creator all initial tokens
130         name = tokenName;                                           // Set the name for display purposes
131         symbol = tokenSymbol;                                       // Set the symbol for display purposes
132     }
133 
134     /* Returns total supply of issued tokens */
135     function totalSupply() constant public returns (uint256 supply) {
136         return totalSupply;
137     }
138     /* Returns balance of  _owner 
139      *   
140      * @param _owner Address to check balance   
141      *   
142      */
143     function balanceOf(address _owner) constant public returns (uint256 balance) {
144         return balanceOf[_owner];
145     }
146 
147     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
148       return allowed[_owner][_spender];
149     }
150     /**
151       * Transfer tokens
152       *
153       * Send `_value` tokens to `_to` from your account
154       *
155       * @param _to The address of the recipient
156       * @param _value the amount to send
157       */   
158     function transfer(address _to, uint256 _value) public returns (bool) {
159         require(_to != address(0));
160         require(_value <= balanceOf[msg.sender]);
161         require(frozenAccount[msg.sender] < now);                   // Check if sender is frozen
162         if (frozenAccount[msg.sender] < now) frozenAccount[msg.sender] = 0;
163         // SafeMath.sub will throw if there is not enough balance.
164         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
165         balanceOf[_to] = balanceOf[_to].add(_value);
166         Transfer(msg.sender, _to, _value);
167         return true;
168     }
169    
170     /**
171       * @dev Transfer tokens from one address to another
172       * @param _from address The address which you want to send tokens from
173       * @param _to address The address which you want to transfer to
174       * @param _value uint256 the amount of tokens to be transferred
175       */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177         require(_to != address(0));
178         require(_value <= balanceOf[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180         require(frozenAccount[_from] < now);                   // Check if sender is frozen
181         if (frozenAccount[_from] < now) frozenAccount[_from] = 0;
182         balanceOf[_from] = balanceOf[_from].sub(_value);
183         balanceOf[_to] = balanceOf[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190      * Set allowed for other address
191      *
192      * Allows `_spender` to spend no more than `_value` tokens in your behalf
193      *
194      * @param _spender The address authorized to spend
195      * @param _value the max amount they can spend
196      */
197 
198     function approve(address _spender, uint256 _value) public returns (bool) {
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205       * approve should be called when allowed[_spender] == 0. To increment
206       * allowed value is better to use this function to avoid 2 calls (and wait until
207       * the first transaction is mined)
208       * From MonolithDAO Token.sol
209       */
210     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
211         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219               allowed[msg.sender][_spender] = 0;
220         } else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }   
223         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227     /**
228      * Burns tokens
229      *
230      * Remove `_value` tokens from the system irreversibly
231      *
232      * @param _value the amount of money to burn
233      */
234     function burn(uint256 _value) public returns (bool success) {
235         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
236         balanceOf[msg.sender] -= _value;            // Subtract from the sender
237         totalSupply -= _value;                      // Updates totalSupply
238         Burn(msg.sender, _value);
239         return true;
240     }
241 
242     /**
243      * Destroy tokens from other account
244      *
245      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
246      *
247      * @param _from the address of the sender
248      * @param _value the amount of money to burn
249      */
250     function burnFrom(address _from, uint256 _value) public returns (bool success) {
251         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
252         require(_value <= allowed[_from][msg.sender]);    // Check allowed
253         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
254         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowed
255         totalSupply -= _value;                              // Update totalSupply
256         Burn(_from, _value);
257         return true;
258     }
259     /**
260      * Create new tokens
261      *
262      * Create `_value` tokens on behalf of Owner.
263      *
264      * @param _value the amount of money to burn
265      */
266     function _mint(uint256 _value) canMint internal  {
267         totalSupply = totalSupply.add(_value);
268         balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
269     }
270     
271     /**
272       * @dev Function to stop minting new tokens.
273       * @return True if the operation was successful.
274       */
275     function finishMinting() onlyOwner canMint public returns (bool) {
276         mintingFinished = true;
277         MintFinished();
278         return true;
279     }
280     /**
281       * @dev Function to start minting new tokens.
282       * @return True if the operation was successful.
283       */
284     function startMinting() onlyOwner  public returns (bool) {
285         mintingFinished = false;
286         MintStarted();
287         return true;
288     }  
289 
290     /**
291       * @notice Freezes from sending & receiving tokens. For users protection can't be used after 1542326399
292       * and will not allow corrections.
293       *           
294       * @param _from  Founders and Team account we are freezing from sending
295       * @param _till Timestamp till the end of freeze
296       *
297       */
298    function freezeAccount(address _from, uint256 _till) onlyOwner public {
299         require(frozenAccount[_from] == 0);
300         frozenAccount[_from] = _till;                  
301     }
302 
303 }
304 
305 
306 contract LeRT is TokenERC20 {
307 
308  
309 
310     // This is time for next Profit Equivalent
311     struct periodTerms { 
312         uint256 periodTime;
313         uint periodBonus;   // In Procents
314     }
315     
316     uint256 public priceLeRT = 100000000000000; // Starting Price 1 ETH = 10000 LeRT
317 
318     uint public currentPeriod = 0;
319     
320     mapping (uint => periodTerms) public periodTable;
321 
322     // List of Team and Founders account's frozen till 01 May 2019
323     mapping (address => uint256) public frozenAccount;
324 
325     
326     /* Handles incoming payments to contract's address */
327     function() payable canMint public {
328         if (now > periodTable[currentPeriod].periodTime) currentPeriod++;
329         require(currentPeriod != 7);
330         
331         uint256 newTokens;
332         require(priceLeRT > 0);
333         // calculate new tokens
334         newTokens = msg.value / priceLeRT * 10 ** uint256(decimals);
335         // calculate bonus tokens
336         newTokens += newTokens/100 * periodTable[currentPeriod].periodBonus; 
337         _mint(newTokens);
338         owner.transfer(msg.value); 
339     }
340 
341     /* Initializes contract with initial supply tokens to the creator of the contract */
342     function LeRT(
343         uint256 initialSupply,
344         string tokenName,
345         string tokenSymbol
346     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
347         // set periods on startup
348         periodTable[0].periodTime = 1519084800;
349         periodTable[0].periodBonus = 50;
350         periodTable[1].periodTime = 1519343999;
351         periodTable[1].periodBonus = 45;
352         periodTable[2].periodTime = 1519689599;
353         periodTable[2].periodBonus = 40;
354         periodTable[3].periodTime = 1520294399;
355         periodTable[3].periodBonus = 35;
356         periodTable[4].periodTime = 1520899199;
357         periodTable[4].periodBonus = 30;
358         periodTable[5].periodTime = 1522108799;
359         periodTable[5].periodBonus = 20;
360         periodTable[6].periodTime = 1525132799;
361         periodTable[6].periodBonus = 15;
362         periodTable[7].periodTime = 1527811199;
363         periodTable[7].periodBonus = 0;}
364 
365     function setPrice(uint256 _value) public onlyOwner {
366         priceLeRT = _value;
367     }
368     function setPeriod(uint _period, uint256 _periodTime, uint256 _periodBouns) public onlyOwner {
369         periodTable[_period].periodTime = _periodTime;
370         periodTable[_period].periodBonus = _periodBouns;
371     }
372     
373     function setCurrentPeriod(uint _period) public onlyOwner {
374         currentPeriod = _period;
375     }
376     
377     function mintOther(address _to, uint256 _value) public onlyOwner {
378         uint256 newTokens;
379         newTokens = _value + _value/100 * periodTable[currentPeriod].periodBonus; 
380         balanceOf[_to] += newTokens;
381         totalSupply += newTokens;
382     }
383 }