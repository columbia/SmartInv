1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 contract Distributable is Ownable {
40 
41     address public distributor;
42 
43     function setDistributor(address _distributor) public onlyOwner {
44         distributor = _distributor;
45     }
46 
47     modifier onlyOwnerOrDistributor(){
48         require(msg.sender == owner || msg.sender == distributor);
49         _;
50     }
51 }
52 
53 library SafeMath {
54 
55   /**
56   * @dev Multiplies two numbers, throws on overflow.
57   */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     if (a == 0) {
60       return 0;
61     }
62     uint256 c = a * b;
63     assert(c / a == b);
64     return c;
65   }
66 
67   /**
68   * @dev Integer division of two numbers, truncating the quotient.
69   */
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   /**
78   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   /**
86   * @dev Adds two numbers, throws on overflow.
87   */
88   function add(uint256 a, uint256 b) internal pure returns (uint256) {
89     uint256 c = a + b;
90     assert(c >= a);
91     return c;
92   }
93 }
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 contract ERC223Interface {
114     function transfer(address to, uint value, bytes data) returns (bool);
115     // event Transfer(address indexed from, address indexed to, uint value, bytes data);
116 }
117 
118 
119 contract ERC223ReceivingContract {
120 /**
121  * @dev Standard ERC223 function that will handle incoming token transfers.
122  *
123  * @param _from  Token sender address.
124  * @param _value Amount of tokens.
125  * @param _data  Transaction metadata.
126  */
127     function tokenFallback(address _from, uint _value, bytes _data);
128 }
129 
130 
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     // SafeMath.sub will throw if there is not enough balance.
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) public view returns (uint256 balance) {
172     return balances[_owner];
173   }
174 
175 }
176 
177 
178 
179 /**
180  * @title Standard ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * @dev https://github.com/ethereum/EIPs/issues/20
184  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  */
186 contract StandardToken is ERC20, BasicToken {
187 
188   mapping (address => mapping (address => uint256)) internal allowed;
189 
190 
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    *
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param _spender The address which will spend the funds.
217    * @param _value The amount of tokens to be spent.
218    */
219   function approve(address _spender, uint256 _value) public returns (bool) {
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param _owner address The address which owns the funds.
228    * @param _spender address The address which will spend the funds.
229    * @return A uint256 specifying the amount of tokens still available for the spender.
230    */
231   function allowance(address _owner, address _spender) public view returns (uint256) {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _addedValue The amount of tokens to increase the allowance by.
244    */
245   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
262     uint oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 
275 
276 /**
277  * @title Reference implementation of the ERC223 standard token.
278  */
279 contract ERC223Token is ERC223Interface, StandardToken {
280     using SafeMath for uint;
281     bool public transfersEnabled = false;
282 
283     /**
284      * @dev Transfer the specified amount of tokens to the specified address.
285      *      Invokes the `tokenFallback` function if the recipient is a contract.
286      *      The token transfer fails if the recipient is a contract
287      *      but does not implement the `tokenFallback` function
288      *      or the fallback function to receive funds.
289      *
290      * @param _to    Receiver address.
291      * @param _value Amount of tokens that will be transferred.
292      * @param _data  Transaction metadata.
293      */
294     function transfer(address _to, uint _value, bytes _data) returns (bool) {
295         require(transfersEnabled);
296         // Standard function transfer similar to ERC20 transfer with no _data .
297         // Added due to backwards compatibility reasons .
298         uint codeLength;
299 
300         assembly {
301             // Retrieve the size of the code on target address, this needs assembly .
302             codeLength := extcodesize(_to)
303         }
304 
305         balances[msg.sender] = balances[msg.sender].sub(_value);
306         balances[_to] = balances[_to].add(_value);
307         if (codeLength > 0) {
308             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
309             receiver.tokenFallback(msg.sender, _value, _data);
310         }
311         Transfer(msg.sender, _to, _value);
312         return true;
313     }
314 
315     /**
316      * @dev Transfer the specified amount of tokens to the specified address.
317      *      This function works the same with the previous one
318      *      but doesn't contain `_data` param.
319      *      Added due to backwards compatibility reasons.
320      *
321      * @param _to    Receiver address.
322      * @param _value Amount of tokens that will be transferred.
323      */
324     function transfer(address _to, uint _value) returns (bool) {
325         require(transfersEnabled);
326         // Standard function transfer similar to ERC20 transfer with no _data .
327         // Added due to backwards compatibility reasons .
328         bytes memory empty;
329         return transfer(_to, _value, empty);
330     }
331 
332 
333     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
334         require(transfersEnabled);
335         return super.transferFrom(_from, _to, _value);
336     }
337 
338     function approve(address _spender, uint256 _value) public returns (bool) {
339         require(transfersEnabled);
340         return super.approve(_spender, _value);
341     }
342 
343     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
344         require(transfersEnabled);
345         return super.increaseApproval(_spender, _addedValue);
346     }
347 
348     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
349         require(transfersEnabled);
350         return super.decreaseApproval(_spender, _subtractedValue);
351     }
352 
353 }
354 
355 contract COSSToken is ERC223Token, Ownable, Distributable {
356 
357     event RevenueShareIdentifierCreated (
358         address indexed _address,
359         string _identifier);
360 
361     string public name    = "COSS";
362     string public symbol  = "COSS";
363     uint256 public decimals = 18;
364 
365     using SafeMath for uint;
366 
367     address public oldTokenAddress;
368 
369     mapping (address => string) public revenueShareIdentifierList;
370 
371     function COSSToken() {
372         owner = msg.sender;
373         totalSupply_ = 200000000 * (10 ** decimals);
374     }
375 
376     function setOldTokenAddress(address _oldTokenAddress) public onlyOwner {
377         oldTokenAddress = _oldTokenAddress;
378     }
379 
380     function replaceToken(address[] _addresses) public onlyOwnerOrDistributor {
381         uint256 addressCount = _addresses.length;
382         for (uint256 i = 0; i < addressCount; i++) {
383             address currentAddress = _addresses[i];
384             uint256 balance = ERC20(oldTokenAddress).balanceOf(currentAddress);
385             balances[currentAddress] = balance;
386         }
387     }
388     
389     function replaceTokenFix(address[] _addresses, uint256[] _balances) public onlyOwnerOrDistributor {
390         uint256 addressCount = _addresses.length;
391         for (uint256 i = 0; i < addressCount; i++) {
392             address currentAddress = _addresses[i];
393             uint256 balance = _balances[i];
394             balances[currentAddress] = balance;
395         }
396     }
397 
398     function() payable {
399 
400     }
401 
402     function activateRevenueShareIdentifier(string _revenueShareIdentifier) {
403         revenueShareIdentifierList[msg.sender] = _revenueShareIdentifier;
404         RevenueShareIdentifierCreated(msg.sender, _revenueShareIdentifier);
405     }
406 
407     function sendTokens(address _destination, address _token, uint256 _amount) public onlyOwnerOrDistributor {
408          ERC20(_token).transfer(_destination, _amount);
409     }
410 
411     function sendEther(address _destination, uint256 _amount) payable public onlyOwnerOrDistributor {
412         _destination.transfer(_amount);
413     }
414 
415     function setTransfersEnabled() public onlyOwner {
416         transfersEnabled = true;
417     }
418 
419 }