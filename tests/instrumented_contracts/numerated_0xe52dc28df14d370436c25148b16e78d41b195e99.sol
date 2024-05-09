1 pragma solidity ^0.4.18;
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
49 
50 
51 //  https://github.com/ethereum/EIPs/issues/179
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 // ERC20 interface, see https://github.com/ethereum/EIPs/issues/20
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 
68 // Basic version of StandardToken, with no allowances.
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     // SafeMath.sub will throw if there is not enough balance.
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * Standard ERC20 token
113  * Implementation of the basic standard token.
114  * https://github.com/ethereum/EIPs/issues/20
115  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[_from]);
131     require(_value <= allowed[_from][msg.sender]);
132 
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142    *
143    * Beware that changing an allowance with this method brings the risk that someone may use both the old
144    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint256 _value) public returns (bool) {
151     allowed[msg.sender][_spender] = _value;
152     Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(address _owner, address _spender) public view returns (uint256) {
163     return allowed[_owner][_spender];
164   }
165 
166   /**
167    * @dev Increase the amount of tokens that an owner allowed to a spender.
168    *
169    * approve should be called when allowed[_spender] == 0. To increment
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    * @param _spender The address which will spend the funds.
174    * @param _addedValue The amount of tokens to increase the allowance by.
175    */
176   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   /**
183    * @dev Decrease the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To decrement
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _subtractedValue The amount of tokens to decrease the allowance by.
191    */
192   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
193     uint oldValue = allowed[msg.sender][_spender];
194     if (_subtractedValue > oldValue) {
195       allowed[msg.sender][_spender] = 0;
196     } else {
197       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
198     }
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203 }
204 
205 
206 
207 /**
208  * @title Ownable
209  * @dev The Ownable contract has an owner address, and provides basic authorization control
210  * functions, this simplifies the implementation of "user permissions".
211  */
212 contract Ownable {
213   address public owner;
214 
215 
216   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217 
218 
219   /**
220    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
221    * account.
222    */
223   function Ownable() public {
224     owner = msg.sender;
225   }
226 
227   /**
228    * @dev Throws if called by any account other than the owner.
229    */
230   modifier onlyOwner() {
231     require(msg.sender == owner);
232     _;
233   }
234 
235   /**
236    * @dev Allows the current owner to transfer control of the contract to a newOwner.
237    * @param newOwner The address to transfer ownership to.
238    */
239   function transferOwnership(address newOwner) public onlyOwner {
240     require(newOwner != address(0));
241     OwnershipTransferred(owner, newOwner);
242     owner = newOwner;
243   }
244 
245 }
246 
247 //
248 contract EXOToken is StandardToken, Ownable {
249     uint8 constant PERCENT_BOUNTY=3;
250     uint8 constant PERCENT_TEAM=12;
251     uint8 constant PERCENT_FOUNDATION=25;
252     uint8 constant PERCENT_PRE_ICO=10;
253     uint8 constant PERCENT_ICO=50;
254     uint256 constant UNFREEZE_FOUNDATION  = 1546214400;
255     //20180901 = 1535760000
256     //20181231 = 1546214400
257     ///////////////
258     // VAR       //
259     ///////////////
260     // Implementation of frozen funds
261     mapping(address => bool) public frozenAccounts;
262 
263     string public  name;
264     string public  symbol;
265     uint8  public  decimals;
266     uint256 public UNFREEZE_TEAM_BOUNTY = 1535760000; //Plan end of ICO
267 
268     address public accForBounty;
269     address public accForTeam;
270     address public accFoundation;
271     address public accPreICO;
272     address public accICO;
273     address public currentMinter;
274 
275 
276     ///////////////
277     // EVENTS    //
278     ///////////////
279     event NewFreeze(address acc, bool isFrozen);
280     event Mint(address indexed to, uint256 amount);
281 
282     // Constructor,  
283     function EXOToken(
284         address _accForBounty, 
285         address _accForTeam, 
286         address _accFoundation, 
287         address _accPreICO, 
288         address _accICO) 
289     public 
290     {
291         name = "EXOLOVER";
292         symbol = "EXO";
293         decimals = 18;
294         totalSupply_ = 100000000 * (10 ** uint256(decimals));// All EXO tokens in the world
295         //Initial token distribution
296         balances[_accForBounty] = totalSupply()/100*PERCENT_BOUNTY;
297         balances[_accForTeam]   = totalSupply()/100*PERCENT_TEAM;
298         balances[_accFoundation]= totalSupply()/100*PERCENT_FOUNDATION;
299         balances[_accPreICO]    = totalSupply()/100*PERCENT_PRE_ICO;
300         balances[_accICO]       = totalSupply()/100*PERCENT_ICO;
301         //save for public
302         accForBounty  = _accForBounty;
303         accForTeam    = _accForTeam;
304         accFoundation = _accFoundation;
305         accPreICO     = _accPreICO;
306         accICO        = _accICO;
307         //Fixe emission
308         emit Transfer(address(0), _accForBounty,  totalSupply()/100*PERCENT_BOUNTY);
309         emit Transfer(address(0), _accForTeam,    totalSupply()/100*PERCENT_TEAM);
310         emit Transfer(address(0), _accFoundation, totalSupply()/100*PERCENT_FOUNDATION);
311         emit Transfer(address(0), _accPreICO,     totalSupply()/100*PERCENT_PRE_ICO);
312         emit Transfer(address(0), _accICO,        totalSupply()/100*PERCENT_ICO);
313 
314         frozenAccounts[accFoundation] = true;
315         emit NewFreeze(accFoundation, true);
316     }
317 
318     function isFrozen(address _acc) internal view returns(bool frozen) {
319         if (_acc == accFoundation && now < UNFREEZE_FOUNDATION) 
320             return true;
321         return (frozenAccounts[_acc] && now < UNFREEZE_TEAM_BOUNTY);    
322     }
323 
324     //Override some function for freeze functionality
325     function transfer(address _to, uint256 _value) public  returns (bool) {
326       require(!isFrozen(msg.sender));
327       assert(msg.data.length >= 64 + 4);//Short Address Attack
328       //Lets freeze any accounts, who recieve tokens from accForBounty and accForTeam
329       // - auto freeze
330       if (msg.sender == accForBounty || msg.sender == accForTeam) {
331           frozenAccounts[_to] = true;
332           emit NewFreeze(_to, true);
333       }
334       return super.transfer(_to, _value);
335     }
336 
337     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
338       require(!isFrozen(_from));
339       assert(msg.data.length >= 96 + 4); //Short Address Attack
340        if (_from == accForBounty || _from == accForTeam) {
341           frozenAccounts[_to] = true;
342           emit NewFreeze(_to, true);
343       }
344       return super.transferFrom(_from, _to, _value);
345     }
346 
347     function approve(address _spender, uint256 _value) public  returns (bool) {
348       require(!isFrozen(msg.sender));
349       return super.approve(_spender, _value);
350     }
351 
352     function increaseApproval(address _spender, uint _addedValue) public  returns (bool success) {
353       require(!isFrozen(msg.sender));
354       return super.increaseApproval(_spender, _addedValue);
355     }
356 
357     function decreaseApproval(address _spender, uint _subtractedValue) public  returns (bool success) {
358       require(!isFrozen(msg.sender));
359       return super.decreaseApproval(_spender, _subtractedValue);
360     }
361 
362     function freezeUntil(address _acc, bool _isfrozen) external onlyOwner returns (bool success){
363         require(now <= UNFREEZE_TEAM_BOUNTY);// nobody cant freeze after ICO finish
364         frozenAccounts[_acc] = _isfrozen;
365         emit NewFreeze(_acc, _isfrozen);
366         return true;
367     }
368 
369     function setMinter(address _minter) external onlyOwner returns (bool success) {
370         currentMinter = _minter;
371         return true;
372     }
373 
374     function setBountyTeamUnfreezeTime(uint256 _newDate) external onlyOwner {
375        UNFREEZE_TEAM_BOUNTY = _newDate;
376     }
377 
378     function mintTokens(address _to, uint256 _amount) external returns (bool) {
379         require(msg.sender==currentMinter);
380         totalSupply_  = totalSupply_.add(_amount);
381         balances[_to] = balances[_to].add(_amount);
382         emit Mint(_to, _amount);
383         emit Transfer(address(0), _to, _amount);
384         return true; 
385     }
386     
387     
388   //***************************************************************
389   // ERC20 part of this contract based on https://github.com/OpenZeppelin/zeppelin-solidity
390   // Adapted and amended by IBERGroup, email:maxsizmobile@iber.group; 
391   //     Telegram: https://t.me/msmobile
392   //               https://t.me/alexamuek
393   // Code released under the MIT License(see git root).
394   ////**************************************************************
395 
396 }