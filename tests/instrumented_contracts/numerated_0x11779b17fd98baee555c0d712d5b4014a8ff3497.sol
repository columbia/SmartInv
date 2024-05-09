1 pragma solidity ^0.4.19;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     emit OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79     /// Total amount of tokens
80   uint256 public totalSupply;
81   
82   function balanceOf(address _owner) public view returns (uint256 balance);
83   
84   function transfer(address _to, uint256 _amount) public returns (bool success);
85   
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
95   
96   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
97   
98   function approve(address _spender, uint256 _amount) public returns (bool success);
99   
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   //balance in each address account
111   mapping(address => uint256) balances;
112   address ownerWallet;
113   bool released = false;
114 
115   enum LockupType {NOLOCK, FOUNDATION, TEAM, CONSORTIUM, PARTNER, BLACK}
116 
117   struct Lockup
118   {
119       uint256 lockupTime;
120       uint256 lockupAmount;
121       LockupType lockType;
122   }
123   Lockup lockup;
124   mapping(address=>Lockup) lockupParticipants;  
125   
126   
127   uint256 startTime;
128   function release() public {
129       require(ownerWallet == msg.sender);
130       require(!released);
131       released = true;
132   }
133 
134   function lock() public {
135       require(ownerWallet == msg.sender);
136       require(released);
137       released = false;
138   }
139 
140   function get_Release() view public returns (bool) {
141       return released;
142   }
143 
144   /**
145   * @dev transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _amount The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _amount) public returns (bool success) {
150     require(_to != address(0));
151     require(balances[msg.sender] >= _amount && _amount > 0
152         && balances[_to].add(_amount) > balances[_to]);
153 
154 
155     if (!released) { // before exchanged
156       if ( (lockupParticipants[msg.sender].lockType == LockupType.PARTNER) || (msg.sender == ownerWallet) ) {
157         // do something to the partner or ownerthing
158         // SafeMath.sub will throw if there is not enough balance.
159         balances[msg.sender] = balances[msg.sender].sub(_amount);
160         balances[_to] = balances[_to].add(_amount);
161         emit Transfer(msg.sender, _to, _amount);
162         return true;
163       //} else if (lockupParticipants[msg.sender].lockType == LockupType.BLACK ) {
164       } else {
165         // do something to the banned
166         return false;
167       } 
168     } else { // after changed
169       if (lockupParticipants[msg.sender].lockType == LockupType.BLACK ) {
170         // do something to the banned
171         return false;
172       } else if (lockupParticipants[msg.sender].lockupAmount>0) {
173             uint timePassed = now - startTime;
174             if (timePassed < lockupParticipants[msg.sender].lockupTime)
175             {
176                 require(balances[msg.sender].sub(_amount) >= lockupParticipants[msg.sender].lockupAmount);
177             }
178             // do transfer
179             // SafeMath.sub will throw if there is not enough balance.
180             balances[msg.sender] = balances[msg.sender].sub(_amount);
181             balances[_to] = balances[_to].add(_amount);
182             emit Transfer(msg.sender, _to, _amount);
183             return true;
184       }
185     }
186     return false;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256 balance) {
195     return balances[_owner];
196   }
197 
198 }
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  */
206 contract StandardToken is ERC20, BasicToken {
207   
208   
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _amount uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
219     require(_to != address(0));
220     require(balances[_from] >= _amount);
221     require(allowed[_from][msg.sender] >= _amount);
222     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
223     
224     if (lockupParticipants[_from].lockupAmount>0)
225     {
226         uint timePassed = now - startTime;
227         if (timePassed < lockupParticipants[_from].lockupTime)
228         {
229             require(balances[msg.sender].sub(_amount) >= lockupParticipants[_from].lockupAmount);
230         }
231     }
232     balances[_from] = balances[_from].sub(_amount);
233     balances[_to] = balances[_to].add(_amount);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
235     emit Transfer(_from, _to, _amount);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    *
242    * Beware that changing an allowance with this method brings the risk that someone may use both the old
243    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246    * @param _spender The address which will spend the funds.
247    * @param _amount The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _amount) public returns (bool success) {
250     allowed[msg.sender][_spender] = _amount;
251     emit Approval(msg.sender, _spender, _amount);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
262     return allowed[_owner][_spender];
263   }
264 
265 }
266 
267 /**
268  * @title Burnable Token
269  * @dev Token that can be irreversibly burned (destroyed).
270  */
271 contract BurnableToken is StandardToken, Ownable {
272 
273     event Burn(address indexed burner, uint256 value);
274 
275     /**
276      * @dev Burns a specific amount of tokens.
277      * @param _value The amount of token to be burned.
278      */
279     function burn(uint256 _value) public onlyOwner{
280         require(_value <= balances[ownerWallet]);
281         // no need to require value <= totalSupply, since that would imply the
282         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
283 
284         balances[ownerWallet] = balances[ownerWallet].sub(_value);
285         totalSupply = totalSupply.sub(_value);
286         emit Burn(msg.sender, _value);
287     }
288 }
289 /**
290  * @title LineageCode Token
291  * @dev Token representing LineageCode.
292  */
293  contract LineageCode is BurnableToken {
294      string public name ;
295      string public symbol ;
296      uint8 public decimals =  6;
297      
298    
299      /**
300      *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
301      */
302      function ()public payable {
303          revert();
304      }
305      
306      /**
307      * @dev Constructor function to initialize the initial supply of token to the creator of the contract
308      */
309      //constructor(address wallet) public 
310      constructor() public 
311      {
312          owner = msg.sender;
313          ownerWallet = owner;
314          totalSupply = 20000000000;
315          totalSupply = totalSupply.mul(10 ** uint256(decimals)); //Update total supply with the decimal amount
316          name = "LineageCode";
317          symbol = "LIN";
318          balances[owner] = totalSupply;
319          startTime = now;
320          
321          //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
322          emit Transfer(address(0), msg.sender, totalSupply);
323      }
324      
325      /**
326      *@dev helper method to get token details, name, symbol and totalSupply in one go
327      */
328     function getTokenDetail() public view returns (string, string, uint256) {
329 	    return (name, symbol, totalSupply);
330     }
331     
332     function lockTokensForFoundation(address foundation, uint256 daysafter) public onlyOwner
333     {
334         lockup = Lockup({
335                           lockupTime:daysafter * 1 days,
336                           lockupAmount:10000000000 * 10 ** uint256(decimals), 
337                           lockType:LockupType.FOUNDATION
338                           });
339         lockupParticipants[foundation] = lockup;
340     }
341 
342     function lockTokensForConsortium(address consortium, uint256 daysafter, uint256 amount) public onlyOwner
343     {
344         lockup = Lockup({
345                           lockupTime:daysafter * 1 days,
346                           lockupAmount:amount * 10 ** uint256(decimals), 
347                           lockType:LockupType.CONSORTIUM
348                           });
349         lockupParticipants[consortium] = lockup;
350     }
351 
352     function lockTokensForTeam(address team, uint256 daysafter, uint256 amount) public onlyOwner
353     {
354         lockup = Lockup({
355                           lockupTime:daysafter * 1 days,
356                           lockupAmount:amount * 10 ** uint256(decimals), 
357                           lockType:LockupType.TEAM
358                           });
359         lockupParticipants[team] = lockup;
360     }
361 
362     function lockTokensForBlack(address black) public onlyOwner
363     {
364         lockup = Lockup({
365                           lockupTime:9999999999 days,
366                           lockupAmount:20000000000 * 10 ** uint256(decimals), 
367                           lockType:LockupType.BLACK
368                           });
369         lockupParticipants[black] = lockup;
370     }
371 
372     function registerPartner(address partner) public onlyOwner
373     {
374         lockup = Lockup({
375                           lockupTime:0 days,
376                           lockupAmount:0 * 10 ** uint256(decimals), 
377                           lockType:LockupType.PARTNER
378                           });
379         lockupParticipants[partner] = lockup;
380     }
381 
382     function lockTokensUpdate(address addr, uint daysafter, uint256 amount, uint256 l_type) public onlyOwner
383     {
384         
385         lockup = Lockup({
386                           lockupTime:daysafter *  1 days,
387                           lockupAmount:amount * 10 ** uint256(decimals), 
388                           lockType: BasicToken.LockupType(l_type)
389                           });
390         lockupParticipants[addr] = lockup;
391     }
392  }