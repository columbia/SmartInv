1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, December 12, 2018
3  (UTC) */
4 
5 pragma solidity ^0.5.1;
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83     /// Total amount of tokens
84   uint256 public totalSupply;
85   
86   function balanceOf(address _owner) public view returns (uint256 balance);
87   
88   function transfer(address _to, uint256 _amount) public returns (bool success);
89   
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99   
100   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
101   
102   function approve(address _spender, uint256 _amount) public returns (bool success);
103   
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 /**
108  * @title Basic token
109  * @dev Basic version of StandardToken, with no allowances.
110  */
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   //balance in each address account
115   mapping(address => uint256) balances;
116   address ownerWallet;
117   bool released = false;
118 
119   enum LockupType {NOLOCK, FOUNDATION, TEAM, CONSORTIUM, PARTNER, BLACK}
120 
121   struct Lockup
122   {
123       uint256 lockupTime;
124       uint256 lockupAmount;
125       LockupType lockType;
126   }
127   Lockup lockup;
128   mapping(address=>Lockup) lockupParticipants;  
129   
130   
131   uint256 startTime;
132   function release() public {
133       require(ownerWallet == msg.sender);
134       require(!released);
135       released = true;
136   }
137 
138   function lock() public {
139       require(ownerWallet == msg.sender);
140       require(released);
141       released = false;
142   }
143 
144   function get_Release() view public returns (bool) {
145       return released;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _amount The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _amount) public returns (bool success) {
154     require(_to != address(0));
155     require(balances[msg.sender] >= _amount && _amount > 0
156         && balances[_to].add(_amount) > balances[_to]);
157 
158 
159     if (!released) { // before exchanged
160       if ( (lockupParticipants[msg.sender].lockType == LockupType.PARTNER) || (msg.sender == ownerWallet) ) {
161         // do something to the partner or ownerthing
162         // SafeMath.sub will throw if there is not enough balance.
163         balances[msg.sender] = balances[msg.sender].sub(_amount);
164         balances[_to] = balances[_to].add(_amount);
165         emit Transfer(msg.sender, _to, _amount);
166         return true;
167       //} else if (lockupParticipants[msg.sender].lockType == LockupType.BLACK ) {
168       } else {
169         // do something to the banned
170         return false;
171       } 
172     } else { // after changed
173       if (lockupParticipants[msg.sender].lockType == LockupType.BLACK ) {
174         // do something to the banned
175         return false;
176       } else 
177         if (lockupParticipants[msg.sender].lockupAmount>0) {
178             uint timePassed = now - startTime;
179             if (timePassed < lockupParticipants[msg.sender].lockupTime)
180             {
181                 require(balances[msg.sender].sub(_amount) >= lockupParticipants[msg.sender].lockupAmount);
182             }
183             // do transfer
184             // SafeMath.sub will throw if there is not enough balance.
185             balances[msg.sender] = balances[msg.sender].sub(_amount);
186             balances[_to] = balances[_to].add(_amount);
187             emit Transfer(msg.sender, _to, _amount);
188             return true;
189       } else {
190 		// do transfer
191 		// SafeMath.sub will throw if there is not enough balance.
192 		balances[msg.sender] = balances[msg.sender].sub(_amount);
193 		balances[_to] = balances[_to].add(_amount);
194 		emit Transfer(msg.sender, _to, _amount);
195 		return true;
196 	  }
197     }
198     return false;
199   }
200 
201   /**
202   * @dev Gets the balance of the specified address.
203   * @param _owner The address to query the the balance of.
204   * @return An uint256 representing the amount owned by the passed address.
205   */
206   function balanceOf(address _owner) public view returns (uint256 balance) {
207     return balances[_owner];
208   }
209 
210 }
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * @dev https://github.com/ethereum/EIPs/issues/20
217  */
218 contract StandardToken is ERC20, BasicToken {
219   
220   
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _amount uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
231     require(_to != address(0));
232     require(balances[_from] >= _amount);
233     require(allowed[_from][msg.sender] >= _amount);
234     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
235     
236     if (lockupParticipants[_from].lockupAmount>0)
237     {
238         uint timePassed = now - startTime;
239         if (timePassed < lockupParticipants[_from].lockupTime)
240         {
241             require(balances[msg.sender].sub(_amount) >= lockupParticipants[_from].lockupAmount);
242         }
243     }
244     balances[_from] = balances[_from].sub(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
247     emit Transfer(_from, _to, _amount);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    *
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param _spender The address which will spend the funds.
259    * @param _amount The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _amount) public returns (bool success) {
262     allowed[msg.sender][_spender] = _amount;
263     emit Approval(msg.sender, _spender, _amount);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
274     return allowed[_owner][_spender];
275   }
276 
277 }
278 
279 /**
280  * @title Burnable Token
281  * @dev Token that can be irreversibly burned (destroyed).
282  */
283 contract BurnableToken is StandardToken, Ownable {
284 
285     event Burn(address indexed burner, uint256 value);
286 
287     /**
288      * @dev Burns a specific amount of tokens.
289      * @param _value The amount of token to be burned.
290      */
291     function burn(uint256 _value) public onlyOwner{
292         require(_value <= balances[ownerWallet]);
293         // no need to require value <= totalSupply, since that would imply the
294         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
295 
296         balances[ownerWallet] = balances[ownerWallet].sub(_value);
297         totalSupply = totalSupply.sub(_value);
298         emit Burn(msg.sender, _value);
299     }
300 }
301 /**
302  * @title LineageCode Token
303  * @dev Token representing LineageCode.
304  */
305  contract LineageCode is BurnableToken {
306      string public name ;
307      string public symbol ;
308      uint8 public decimals;
309 
310    
311      /**
312      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
313      */
314       function () external payable {
315          revert();
316      }
317      
318      /**
319      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
320      */
321      //constructor(address wallet) public 
322      constructor() public 
323      {
324          owner = msg.sender;
325          ownerWallet = owner;
326          totalSupply = 10000000000;
327          decimals = 6;
328          totalSupply = totalSupply.mul(10 ** uint256(decimals)); //Update total supply with the decimal amount
329          name = "SOSOSOSOSO";
330          symbol = "SOSO";
331          balances[owner] = totalSupply;
332          startTime = now;
333          
334          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
335          emit Transfer(address(0), msg.sender, totalSupply);
336      }
337      
338     function lockTokensForFoundation(address foundation, uint256 daysafter) public onlyOwner
339     {
340         lockup = Lockup({
341                           lockupTime:daysafter * 1 days,
342                           lockupAmount:10000000000 * 10 ** uint256(decimals), 
343                           lockType:LockupType.FOUNDATION
344                           });
345         lockupParticipants[foundation] = lockup;
346     }
347 
348     function lockTokensForConsortium(address consortium, uint256 daysafter, uint256 amount) public onlyOwner
349     {
350         lockup = Lockup({
351                           lockupTime:daysafter * 1 days,
352                           lockupAmount:amount * 10 ** uint256(decimals), 
353                           lockType:LockupType.CONSORTIUM
354                           });
355         lockupParticipants[consortium] = lockup;
356     }
357 
358     function lockTokensForTeam(address team, uint256 daysafter, uint256 amount) public onlyOwner
359     {
360         lockup = Lockup({
361                           lockupTime:daysafter * 1 days,
362                           lockupAmount:amount * 10 ** uint256(decimals), 
363                           lockType:LockupType.TEAM
364                           });
365         lockupParticipants[team] = lockup;
366     }
367 
368     function lockTokensForBlack(address black) public onlyOwner
369     {
370         lockup = Lockup({
371                           lockupTime:9999999999 days,
372                           lockupAmount:20000000000 * 10 ** uint256(decimals), 
373                           lockType:LockupType.BLACK
374                           });
375         lockupParticipants[black] = lockup;
376     }
377 
378     function registerPartner(address partner) public onlyOwner
379     {
380         lockup = Lockup({
381                           lockupTime:0 days,
382                           lockupAmount:0 * 10 ** uint256(decimals), 
383                           lockType:LockupType.PARTNER
384                           });
385         lockupParticipants[partner] = lockup;
386     }
387 
388     function lockTokensUpdate(address addr, uint daysafter, uint256 amount, uint256 l_type) public onlyOwner
389     {
390         
391         lockup = Lockup({
392                           lockupTime:daysafter *  1 days,
393                           lockupAmount:amount * 10 ** uint256(decimals), 
394                           lockType: BasicToken.LockupType(l_type)
395                           });
396         lockupParticipants[addr] = lockup;
397     }
398  }