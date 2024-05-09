1 library SafeMath
2 {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) 
4   {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) 
11   {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) 
19   {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) 
25   {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable 
33 {
34     address public owner;
35     
36     //  @dev The Ownable constructor sets the original `owner` of the contract to the sender
37     //  account.
38     function Ownable() public 
39     {
40         owner = msg.sender;
41     }
42 
43     //  @dev Throws if called by any account other than the owner. 
44     modifier onlyOwner() 
45     {
46         require(msg.sender == owner);
47         _;
48     }
49     
50     //  @dev Allows the current owner to transfer control of the contract to a newOwner.
51     //  @param newOwner The address to transfer ownership to. 
52     function transferOwnership(address newOwner) public onlyOwner
53     {
54         if (newOwner != address(0)) 
55         {
56             owner = newOwner;
57         }
58     }
59 }
60 
61 contract BasicToken
62 {
63     using SafeMath for uint256;
64     
65      //  Total number of Tokens
66     uint totalCoinSupply;
67     
68     //  allowance map
69     //  ( owner => (spender => amount ) ) 
70     mapping (address => mapping (address => uint256)) public AllowanceLedger;
71     
72     //  ownership map
73     //  ( owner => value )
74     mapping (address => uint256) public balanceOf;
75 
76     //  @dev transfer token for a specified address
77     //  @param _to The address to transfer to.
78     //  @param _value The amount to be transferred.
79     function transfer( address _recipient, uint256 _value ) public 
80         returns( bool success )
81     {
82         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
83         balanceOf[_recipient] = balanceOf[_recipient].add(_value);
84         Transfer(msg.sender, _recipient, _value);
85         return true;
86     }
87     
88     function transferFrom( address _owner, address _recipient, uint256 _value ) 
89         public returns( bool success )
90     {
91         var _allowance = AllowanceLedger[_owner][msg.sender];
92         // Check is not needed because sub(_allowance, _value) will already 
93         //  throw if this condition is not met
94         // require (_value <= _allowance);
95 
96         balanceOf[_recipient] = balanceOf[_recipient].add(_value);
97         balanceOf[_owner] = balanceOf[_owner].sub(_value);
98         AllowanceLedger[_owner][msg.sender] = _allowance.sub(_value);
99         Transfer(_owner, _recipient, _value);
100         return true;
101     }
102     
103     function approve( address _spender, uint256 _value ) 
104         public returns( bool success )
105     {
106         //  _owner is the address of the owner who is giving approval to
107         //  _spender, who can then transact coins on the behalf of _owner
108         address _owner = msg.sender;
109         AllowanceLedger[_owner][_spender] = _value;
110         
111         //  Fire off Approval event
112         Approval( _owner, _spender, _value);
113         return true;
114     }
115     
116     function allowance( address _owner, address _spender ) public constant 
117         returns ( uint256 remaining )
118     {
119         //  returns the amount _spender can transact on behalf of _owner
120         return AllowanceLedger[_owner][_spender];
121     }
122     
123     function totalSupply() public constant returns( uint256 total )
124     {  
125         return totalCoinSupply;
126     }
127 
128     //  @dev Gets the balance of the specified address.
129     //  @param _owner The address to query the the balance of. 
130     //  @return An uint256 representing the amount owned by the passed address.
131     function balanceOf(address _owner) public constant returns (uint256 balance)
132     {
133         return balanceOf[_owner];
134     }
135     
136     event Transfer( address indexed _owner, address indexed _recipient, uint256 _value );
137     event Approval( address _owner, address _spender, uint256 _value );
138 
139 }
140 
141 contract AnkorusToken is BasicToken, Ownable
142 {
143     using SafeMath for uint256;
144     
145     // Token Cap for each rounds
146     uint256 public saleCap;
147 
148     // Address where funds are collected.
149     address public wallet;
150     
151     // Sale period.
152     uint256 public startDate;
153     uint256 public endDate;
154 
155     // Amount of raised money in wei.
156     uint256 public weiRaised;
157     
158     //  Tokens rate formule
159     uint256 public tokensSold = 0;
160     uint256 public tokensPerTrunche = 2000000;
161     
162     //  Whitelist approval mapping
163     mapping (address => bool) public whitelist;
164     bool public finalized = false;
165     
166    //  This is the 'Ticker' symbol and name for our Token.
167     string public constant symbol = "ANK";
168     string public constant name = "AnkorusToken";
169     
170     //  This is for how your token can be fracionalized. 
171     uint8 public decimals = 18; 
172     
173     // Events
174     event TokenPurchase(address indexed purchaser, uint256 value, 
175         uint256 tokenAmount);
176     event CompanyTokenPushed(address indexed beneficiary, uint256 amount);
177     event Burn( address burnAddress, uint256 amount);
178     
179     function AnkorusToken() public 
180     {
181     }
182     
183     //  @dev gets the sale pool balance
184     //  @return tokens in the pool
185     function supply() internal constant returns (uint256) 
186     {
187         return balanceOf[0xb1];
188     }
189 
190     modifier uninitialized() 
191     {
192         require(wallet == 0x0);
193         _;
194     }
195 
196     //  @dev gets the current time
197     //  @return current time
198     function getCurrentTimestamp() public constant returns (uint256) 
199     {
200         return now;
201     }
202     
203     //  @dev gets the current rate of tokens per ether contributed
204     //  @return number of tokens per ether
205     function getRateAt() public constant returns (uint256)
206     {
207         uint256 traunch = tokensSold.div(tokensPerTrunche);
208         
209         //  Price curve based on function at:
210         //  https://github.com/AnkorusTokenIco/Smart-Contract/blob/master/Price_curve.png
211         if     ( traunch == 0 )  {return 600;}
212         else if( traunch == 1 )  {return 598;}
213         else if( traunch == 2 )  {return 596;}
214         else if( traunch == 3 )  {return 593;}
215         else if( traunch == 4 )  {return 588;}
216         else if( traunch == 5 )  {return 583;}
217         else if( traunch == 6 )  {return 578;}
218         else if( traunch == 7 )  {return 571;}
219         else if( traunch == 8 )  {return 564;}
220         else if( traunch == 9 )  {return 556;}
221         else if( traunch == 10 ) {return 547;}
222         else if( traunch == 11 ) {return 538;}
223         else if( traunch == 12 ) {return 529;}
224         else if( traunch == 13 ) {return 519;}
225         else if( traunch == 14 ) {return 508;}
226         else if( traunch == 15 ) {return 498;}
227         else if( traunch == 16 ) {return 487;}
228         else if( traunch == 17 ) {return 476;}
229         else if( traunch == 18 ) {return 465;}
230         else if( traunch == 19 ) {return 454;}
231         else if( traunch == 20 ) {return 443;}
232         else if( traunch == 21 ) {return 432;}
233         else if( traunch == 22 ) {return 421;}
234         else if( traunch == 23 ) {return 410;}
235         else if( traunch == 24 ) {return 400;}
236         else return 400;
237     }
238     
239     //  @dev Initialize wallet parms, can only be called once
240     //  @param _wallet - address of multisig wallet which receives contributions
241     //  @param _start - start date of sale
242     //  @param _end - end date of sale
243     //  @param _saleCap - amount of coins for sale
244     //  @param _totalSupply - total supply of coins
245     function initialize(address _wallet, uint256 _start, uint256 _end,
246                         uint256 _saleCap, uint256 _totalSupply)
247                         public onlyOwner uninitialized
248     {
249         require(_start >= getCurrentTimestamp());
250         require(_start < _end);
251         require(_wallet != 0x0);
252         require(_totalSupply > _saleCap);
253 
254         finalized = false;
255         startDate = _start;
256         endDate = _end;
257         saleCap = _saleCap;
258         wallet = _wallet;
259         totalCoinSupply = _totalSupply;
260 
261         //  Set balance of company stock
262         balanceOf[wallet] = _totalSupply.sub(saleCap);
263         
264         //  Log transfer of tokens to company wallet
265         Transfer(0x0, wallet, balanceOf[wallet]);
266         
267         //  Set balance of sale pool
268         balanceOf[0xb1] = saleCap;
269         
270         //  Log transfer of tokens to ICO sale pool
271         Transfer(0x0, 0xb1, saleCap);
272     }
273     
274     //  Fallback function is entry point to buy tokens
275     function () public payable
276     {
277         buyTokens(msg.sender, msg.value);
278     }
279 
280     //  @dev Internal token purchase function
281     //  @param beneficiary - The address of the purchaser 
282     //  @param value - Value of contribution, in ether
283     function buyTokens(address beneficiary, uint256 value) internal
284     {
285         require(beneficiary != 0x0);
286         require(value >= 0.1 ether);
287         
288         // Calculate token amount to be purchased
289         uint256 weiAmount = value;
290         uint256 actualRate = getRateAt();
291         uint256 tokenAmount = weiAmount.mul(actualRate);
292 
293         //  Check our supply
294         //  Potentially redundant as balanceOf[0xb1].sub(tokenAmount) will
295         //  throw with insufficient supply
296         require(supply() >= tokenAmount);
297 
298         //  Check conditions for sale
299         require(saleActive());
300         
301         // Transfer
302         balanceOf[0xb1] = balanceOf[0xb1].sub(tokenAmount);
303         balanceOf[beneficiary] = balanceOf[beneficiary].add(tokenAmount);
304         TokenPurchase(msg.sender, weiAmount, tokenAmount);
305         
306         //  Log the transfer of tokens
307         Transfer(0xb1, beneficiary, tokenAmount);
308         
309         // Update state.
310         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
311         
312         //  Get the base value of tokens
313         uint256 base = tokenAmount.div(1 ether);
314         uint256 updatedTokensSold = tokensSold.add(base);
315         weiRaised = updatedWeiRaised;
316         tokensSold = updatedTokensSold;
317 
318         // Forward the funds to fund collection wallet.
319         wallet.transfer(msg.value);
320     }
321     
322     //  @dev whitelist a batch of addresses. Note:Expensive
323     //  @param [] beneficiarys - Array set to whitelist
324     function batchApproveWhitelist(address[] beneficiarys) 
325         public onlyOwner
326     {
327         for (uint i=0; i<beneficiarys.length; i++) 
328         {
329             whitelist[beneficiarys[i]] = true;
330         }
331     }
332     
333     //  @dev Set whitelist for specified address
334     //  @param beneficiary - The address to whitelist
335     //  @param value - value to set (can set address to true or false)
336     function setWhitelist(address beneficiary, bool inList) public onlyOwner
337     {
338         whitelist[beneficiary] = inList;
339     }
340     
341     //  @dev Time remaining until official sale begins
342     //  @returns time remaining, in seconds
343     function getTimeUntilStart() public constant returns (uint256)
344     {
345         if(getCurrentTimestamp() >= startDate)
346             return 0;
347             
348         return startDate.sub(getCurrentTimestamp());
349     }
350     
351     
352     //  @dev transfer tokens from one address to another
353     //  @param _recipient - The address to receive tokens
354     //  @param _value - number of coins to send
355     //  @return true if no requires thrown
356     function transfer( address _recipient, uint256 _value ) public returns(bool)
357     {
358         //  Check to see if the sale has ended
359         require(finalized);
360         
361         //  transfer
362         super.transfer(_recipient, _value);
363         
364         return true;
365     }
366     
367     //  @dev push tokens from treasury stock to specified address
368     //  @param beneficiary - The address to receive tokens
369     //  @param amount - number of coins to push
370     //  @param lockout - lockout time 
371     function push(address beneficiary, uint256 amount) public 
372         onlyOwner 
373     {
374         require(balanceOf[wallet] >= amount);
375 
376         // Transfer
377         balanceOf[wallet] = balanceOf[wallet].sub(amount);
378         balanceOf[beneficiary] = balanceOf[beneficiary].add(amount);
379         
380         //  Log transfer of tokens
381         CompanyTokenPushed(beneficiary, amount);
382         Transfer(wallet, beneficiary, amount);
383     }
384     
385     //  @dev Burns tokens from sale pool remaining after the sale
386     function finalize() public onlyOwner 
387     {
388         //  Can only finalize after after sale is completed
389         require(getCurrentTimestamp() > endDate);
390 
391         //  Set finalized
392         finalized = true;
393 
394         // Burn tokens remaining
395         Burn(0xb1, balanceOf[0xb1]);
396         totalCoinSupply = totalCoinSupply.sub(balanceOf[0xb1]);
397         
398         //  Log transfer to burn address
399         Transfer(0xb1, 0x0, balanceOf[0xb1]);
400         
401         balanceOf[0xb1] = 0;
402     }
403 
404     //  @dev check to see if the sale period is active
405     //  @return true if sale active, false otherwise
406     function saleActive() public constant returns (bool) 
407     {
408         //  Ability to purchase has begun for this purchaser with either 2 
409         //  conditions: Sale has started 
410         //  Or purchaser has been whitelisted to purchase tokens before The start date
411         //  and the whitelistDate is active
412         bool checkSaleBegun = (whitelist[msg.sender] && 
413             getCurrentTimestamp() >= (startDate.sub(2 days))) || 
414                 getCurrentTimestamp() >= startDate;
415         
416         //  Sale of tokens can not happen after the ico date or with no
417         //  supply in any case
418         bool canPurchase = checkSaleBegun && 
419             getCurrentTimestamp() < endDate &&
420             supply() > 0;
421             
422         return(canPurchase);
423     }
424 }