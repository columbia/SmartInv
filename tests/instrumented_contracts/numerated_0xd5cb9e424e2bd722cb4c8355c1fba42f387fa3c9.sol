1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14   /**
15   * @dev transfer token for a specified address
16   * @param _to The address to transfer to.
17   * @param _value The amount to be transferred.
18   */
19   function transfer(address _to, uint256 _value) public returns (bool) {
20     require(_to != address(0));
21 
22     // SafeMath.sub will throw if there is not enough balance.
23     balances[msg.sender] = balances[msg.sender].sub(_value);
24     balances[_to] = balances[_to].add(_value);
25     Transfer(msg.sender, _to, _value);
26     return true;
27   }
28 
29   /**
30   * @dev Gets the balance of the specified address.
31   * @param _owner The address to query the the balance of.
32   * @return An uint256 representing the amount owned by the passed address.
33   */
34   function balanceOf(address _owner) public constant returns (uint256 balance) {
35     return balances[_owner];
36   }
37 
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public constant returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract MartinLarbaoui2 is Ownable  {
85     using SafeMath for uint256;
86 
87     
88 
89     
90     /*Variables about the token contract */    
91     Peculium public pecul; // The Peculium token
92     bool public initPecul; // boolean to know if the Peculium token address has been init
93     
94     event InitializedToken(address contractToken);
95     
96     /*Variables about the client manager */
97     address public clientmanager ; // address of the client manager 
98     uint256 public clientmanagerShare; // nb token for the clientmanager
99     bool public First_pay_clientmanager; // boolean to test if the first pay has been send to the clientmanager
100     uint256 public first_pay; // pourcent of the first pay rate
101     uint256 public montly_pay; // pourcent of the montly pay rate
102     bool public clientInit; // boolean to know if the client address has been init
103     uint256 public payday; // Day when the client manager is paid
104     uint256 public nbMonthsPay; // The montly pay is sent for 6 months
105 
106     event InitializedManager(address ManagerAdd);
107     event FirstPaySend(uint256 first,address receiver);
108     event MonthlyPaySend(uint256 monthPay,address receiverMonthly);
109     
110     
111     //Constructor
112     function Larbaoui() {
113         
114         clientmanagerShare = SafeMath.mul(7000000,(10**8)); // we allocate 72 million token to the client manager (maybe to change)
115         
116         first_pay = SafeMath.div(SafeMath.mul(40,clientmanagerShare),100); // first pay is 40%
117         montly_pay = SafeMath.div(SafeMath.mul(10,clientmanagerShare),100); // other pay are 10%
118         nbMonthsPay = 0;
119         
120         First_pay_clientmanager=true;
121         initPecul = false;
122         clientInit==false;
123         
124 
125     }
126     
127     
128     /***  Functions of the contract ***/
129     
130     function InitPeculiumAdress(address peculAdress) onlyOwner 
131     { // We init the address of the token
132     
133         pecul = Peculium(peculAdress);
134         payday = now;
135         initPecul = true;
136         InitializedToken(peculAdress);
137     
138     }
139     
140     function change_client_manager (address public_key) onlyOwner 
141     { // to change the client manager address
142     
143         clientmanager = public_key;
144         clientInit=true;
145         InitializedManager(public_key);
146     
147     }
148     
149     function transferManager() onlyOwner Initialize clientManagerInit 
150     { // Transfer pecul for the client manager
151         
152         require(now > payday);
153     
154         if(First_pay_clientmanager==false && nbMonthsPay < 6)
155         {
156 
157             pecul.transfer(clientmanager,montly_pay);
158             payday = payday.add( 31 days);
159             nbMonthsPay=nbMonthsPay.add(1);
160             MonthlyPaySend(montly_pay,clientmanager);
161         
162         }
163         
164         if(First_pay_clientmanager==true)
165         {
166 
167             pecul.transfer(clientmanager,first_pay);
168             payday = payday.add( 31 days);
169             First_pay_clientmanager=false;
170             FirstPaySend(first_pay,clientmanager);
171         
172         }
173 
174 
175         
176     }
177         /***  Modifiers of the contract ***/
178     
179     modifier Initialize { // We need to initialize first the token contract
180         require (initPecul==true);
181         _;
182         }
183         modifier clientManagerInit { // We need to initialize first the address of the clientManager
184         require (clientInit==true);
185         _;
186         } 
187 
188 }
189 
190 library SafeERC20 {
191   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
192     assert(token.transfer(to, value));
193   }
194 
195   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
196     assert(token.transferFrom(from, to, value));
197   }
198 
199   function safeApprove(ERC20 token, address spender, uint256 value) internal {
200     assert(token.approve(spender, value));
201   }
202 }
203 
204 library SafeMath {
205   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
206     uint256 c = a * b;
207     assert(a == 0 || c / a == b);
208     return c;
209   }
210 
211   function div(uint256 a, uint256 b) internal constant returns (uint256) {
212     // assert(b > 0); // Solidity automatically throws when dividing by 0
213     uint256 c = a / b;
214     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215     return c;
216   }
217 
218   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
219     assert(b <= a);
220     return a - b;
221   }
222 
223   function add(uint256 a, uint256 b) internal constant returns (uint256) {
224     uint256 c = a + b;
225     assert(c >= a);
226     return c;
227   }
228 }
229 
230 contract StandardToken is ERC20, BasicToken {
231 
232   mapping (address => mapping (address => uint256)) internal allowed;
233 
234 
235   /**
236    * @dev Transfer tokens from one address to another
237    * @param _from address The address which you want to send tokens from
238    * @param _to address The address which you want to transfer to
239    * @param _value uint256 the amount of tokens to be transferred
240    */
241   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {
242     require(_to != address(0));
243 
244     uint256 _allowance = allowed[_from][msg.sender];
245 
246     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
247     // require (_value <= _allowance);
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     allowed[_from][msg.sender] = _allowance.sub(_value);
252     Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    *
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender The address which will spend the funds.
264    * @param _value The amount of tokens to be spent.
265    */
266   function approve(address _spender, uint256 _value) public returns (bool) {
267     allowed[msg.sender][_spender] = _value;
268     Approval(msg.sender, _spender, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    */
288   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 contract BurnableToken is StandardToken {
308 
309     event Burn(address indexed burner, uint256 value);
310 
311     /**
312      * @dev Burns a specific amount of tokens.
313      * @param _value The amount of token to be burned.
314      */
315     function burn(uint256 _value) public {
316         require(_value > 0);
317         require(_value <= balances[msg.sender]);
318         // no need to require value <= totalSupply, since that would imply the
319         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
320 
321         address burner = msg.sender;
322         balances[burner] = balances[burner].sub(_value);
323         totalSupply = totalSupply.sub(_value);
324         Burn(burner, _value);
325     }
326 }
327 
328 contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
329 
330     using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
331     using SafeERC20 for ERC20Basic; 
332 
333         /* Public variables of the token for ERC20 compliance */
334     string public name = "Peculium"; //token name 
335         string public symbol = "PCL"; // token symbol
336         uint256 public decimals = 8; // token number of decimal
337         
338         /* Public variables specific for Peculium */
339         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
340 
341     uint256 public dateStartContract; // The date of the deployment of the token
342     mapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens
343     uint256 public dateDefrost; // The date when the owners of token can defrost their tokens
344 
345 
346         /* Event for the freeze of account */
347      event FrozenFunds(address target, bool frozen);          
348          event Defroze(address msgAdd, bool freeze);
349     
350 
351 
352    
353     //Constructor
354     function Peculium() {
355         totalSupply = MAX_SUPPLY_NBTOKEN;
356         balances[owner] = totalSupply; // At the beginning, the owner has all the tokens. 
357         balancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.
358         
359         dateStartContract=now;
360         dateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)
361 
362     }
363 
364     /*** Public Functions of the contract ***/    
365     
366     function defrostToken() public 
367     { // Function to defrost your own token, after the date of the defrost
368     
369         require(now>dateDefrost);
370         balancesCanSell[msg.sender]=true;
371         Defroze(msg.sender,true);
372     }
373                 
374     function transfer(address _to, uint256 _value) public returns (bool) 
375     { // We overright the transfer function to allow freeze possibility
376     
377         require(balancesCanSell[msg.sender]);
378         return BasicToken.transfer(_to,_value);
379     
380     }
381     
382     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
383     { // We overright the transferFrom function to allow freeze possibility (need to allow before)
384     
385         require(balancesCanSell[msg.sender]);    
386         return StandardToken.transferFrom(_from,_to,_value);
387     
388     }
389 
390     /***  Owner Functions of the contract ***/    
391 
392        function freezeAccount(address target, bool canSell) onlyOwner 
393        {
394         
395             balancesCanSell[target] = canSell;
396             FrozenFunds(target, canSell);
397         
398         }
399 
400 
401     /*** Others Functions of the contract ***/    
402     
403     /* Approves and then calls the receiving contract */
404     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
405         allowed[msg.sender][_spender] = _value;
406         Approval(msg.sender, _spender, _value);
407 
408         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
409             return true;
410     }
411 
412       function getBlockTimestamp() constant returns (uint256)
413       {
414         
415             return now;
416       
417       }
418 
419       function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  
420       { // Return info about the public address and balance of the account of the owner of the contract
421         
422             ownerAddr = owner;
423         ownerBalance = balanceOf(ownerAddr);
424       
425       }
426 
427 }