1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32     function toUINT112(uint256 a) internal constant returns(uint112) {
33     assert(uint112(a) == a);
34     return uint112(a);
35   }
36 
37   function toUINT120(uint256 a) internal constant returns(uint120) {
38     assert(uint120(a) == a);
39     return uint120(a);
40   }
41 
42   function toUINT128(uint256 a) internal constant returns(uint128) {
43     assert(uint128(a) == a);
44     return uint128(a);
45   }
46 
47   function percent(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = (b*a/100) ;
49     assert(c <= a);
50     return c;
51   }
52 }
53 
54 contract Owned {
55 
56     address public owner;
57 
58     function Owned() {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function setOwner(address _newOwner) onlyOwner {
68         owner = _newOwner;
69     }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function balanceOf(address who) public constant returns (uint256);
79   function transfer(address to, uint256 value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   struct Account {
102       uint256 balances;
103       uint256 rawTokens;
104       uint32 lastMintedTimestamp;
105     }
106 
107     // Balances for each account
108     mapping(address => Account) accounts;
109 
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= accounts[msg.sender].balances);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     accounts[msg.sender].balances = accounts[msg.sender].balances.sub(_value);
122     accounts[_to].balances = accounts[_to].balances.add(_value);
123     Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public constant returns (uint256 balance) {
133     return accounts[_owner].balances;
134   }
135 
136 }
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= accounts[_from].balances);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     accounts[_from].balances = accounts[_from].balances.sub(_value);
162     accounts[_to].balances = accounts[_to].balances.add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    */
200   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 
219 contract Infocash is StandardToken, Owned {
220     string public constant name    = "Infocash";  
221     uint8 public constant decimals = 8;               
222     string public constant symbol  = "ICC";
223     bool public canClaimToken = false;
224     uint256 public constant maxSupply  = 86000000*10**uint256(decimals);
225     uint256 public constant dateInit=1514073600  ;
226     uint256 public constant dateICO=dateInit + 30 days;
227     uint256 public constant dateIT=dateICO + 365 days;
228     uint256 public constant dateMarketing=dateIT + 365 days;
229     uint256 public constant dateEco=dateMarketing + 365 days;
230     uint256 public constant dateManager=dateEco + 365 days; 
231     uint256 public constant dateAdmin=dateManager + 365 days;                              
232     
233     enum Stage {
234         NotCreated,
235         ICO,
236         IT,
237         Marketing,
238         Eco,
239         MgmtSystem,
240         Admin,
241         Finalized
242     }
243     // packed to 256bit to save gas usage.
244     struct Supplies {
245         // uint128's max value is about 3e38.
246         // it's enough to present amount of tokens
247         uint256 total;
248         uint256 rawTokens;
249     }
250 
251     //the stage for releasing Tokens
252     struct StageRelease {
253       Stage stage;
254       uint256 rawTokens;
255       uint256 dateRelease;
256     }
257 
258     Supplies supplies;
259     StageRelease public  stageICO=StageRelease(Stage.ICO, maxSupply.percent(35), dateICO);
260     StageRelease public stageIT=StageRelease(Stage.IT, maxSupply.percent(18), dateIT);
261     StageRelease public stageMarketing=StageRelease(Stage.Marketing, maxSupply.percent(18), dateMarketing);
262     StageRelease public stageEco=StageRelease(Stage.Eco, maxSupply.percent(18), dateEco);
263     StageRelease public stageMgmtSystem=StageRelease(Stage.MgmtSystem, maxSupply.percent(9), dateManager);
264     StageRelease public stageAdmin=StageRelease(Stage.Admin, maxSupply.percent(2), dateAdmin);
265 
266     // Send back ether 
267     function () {
268       revert();
269     }
270     //getter totalSupply
271     function totalSupply() public constant returns (uint256 total) {
272       return supplies.total;
273     }
274     
275     function mintToken(address _owner, uint256 _amount, bool _isRaw) onlyOwner internal {
276       require(_amount.add(supplies.total)<=maxSupply);
277       if (_isRaw) {
278         accounts[_owner].rawTokens=_amount.add(accounts[_owner].rawTokens);
279         supplies.rawTokens=_amount.add(supplies.rawTokens);
280       } else {
281         accounts[_owner].balances=_amount.add(accounts[_owner].balances);
282       }
283       supplies.total=_amount.add(supplies.total);
284       Transfer(0, _owner, _amount);
285     }
286 
287     function transferRaw(address _to, uint256 _value) public returns (bool) {
288     require(_to != address(0));
289     require(_value <= accounts[msg.sender].rawTokens);
290     
291 
292     // SafeMath.sub will throw if there is not enough balance.
293     accounts[msg.sender].rawTokens = accounts[msg.sender].rawTokens.sub(_value);
294     accounts[_to].rawTokens = accounts[_to].rawTokens.add(_value);
295     Transfer(msg.sender, _to, _value);
296     return true;
297   }
298 
299   function setClaimToken(bool approve) onlyOwner public returns (bool) {
300     canClaimToken=true;
301     return canClaimToken;
302   }
303 
304     function claimToken(address _owner) public returns (bool amount) {
305       require(accounts[_owner].rawTokens!=0);
306       require(canClaimToken);
307 
308       uint256 amountToken = accounts[_owner].rawTokens;
309       accounts[_owner].rawTokens = 0;
310       accounts[_owner].balances = amountToken + accounts[_owner].balances;
311       return true;
312     }
313 
314     function balanceOfRaws(address _owner) public constant returns (uint256 balance) {
315       return accounts[_owner].rawTokens;
316     }
317 
318     function blockTime() constant returns (uint32) {
319         return uint32(block.timestamp);
320     }
321 
322     function stage() constant returns (Stage) { 
323       if(blockTime()<=dateInit) {
324         return Stage.NotCreated;
325       }
326 
327       if(blockTime()<=dateICO) {
328         return Stage.ICO;
329       }
330         
331       if(blockTime()<=dateIT) {
332         return Stage.IT;
333       }
334 
335       if(blockTime()<=dateMarketing) {
336         return Stage.Marketing;
337       }
338 
339       if(blockTime()<=dateEco) {
340         return Stage.Eco;
341       }
342 
343       if(blockTime()<=dateManager) {
344         return Stage.MgmtSystem;
345       }
346 
347       if(blockTime()<=dateAdmin) {
348         return Stage.Admin;
349       }
350       
351       return Stage.Finalized;
352     }
353 
354     function releaseStage (uint256 amount, StageRelease storage stageRelease, bool isRaw) internal returns (uint256) {
355       if(stageRelease.rawTokens>0) {
356         int256 remain=int256(stageRelease.rawTokens - amount);
357         if(remain<0)
358           amount=stageRelease.rawTokens;
359         stageRelease.rawTokens=stageRelease.rawTokens.sub(amount);
360         mintToken(owner, amount, isRaw);
361         return amount;
362       }
363       return 0;
364     }
365 
366     function release(uint256 amount, bool isRaw) onlyOwner public returns (uint256) {
367       uint256 amountSum=0;
368 
369       if(stage()==Stage.NotCreated) {
370         throw;
371       }
372 
373       if(stage()==Stage.ICO) {
374         releaseStage(amount, stageICO, isRaw);
375         amountSum=amountSum.add(amount);
376         return amountSum;
377       }
378 
379       if(stage()==Stage.IT) {
380         releaseStage(amount, stageIT, isRaw);
381         amountSum=amountSum.add(amount);
382         return amountSum;
383       }
384 
385       if(stage()==Stage.Marketing) {
386         releaseStage(amount, stageMarketing, isRaw);
387         amountSum=amountSum.add(amount);
388         return amountSum;
389       }
390 
391       if(stage()==Stage.Eco) {
392         releaseStage(amount, stageEco, isRaw);
393         amountSum=amountSum.add(amount);
394         return amountSum;
395       }
396 
397       if(stage()==Stage.MgmtSystem) {
398         releaseStage(amount, stageMgmtSystem, isRaw);
399         amountSum=amountSum.add(amount);
400         return amountSum;
401       }
402       
403       if(stage()==Stage.Admin ) {
404         releaseStage(amount, stageAdmin, isRaw);
405         amountSum=amountSum.add(amount);
406         return amountSum;
407       }
408       
409       if(stage()==Stage.Finalized) {
410         owner=0;
411         return 0;
412       }
413       return amountSum;
414     }
415 }