1 pragma solidity ^0.4.21;
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
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 
217 /**
218  * @title Ownable
219  * @dev The Ownable contract has an owner address, and provides basic authorization control
220  * functions, this simplifies the implementation of "user permissions".
221  */
222 contract Ownable {
223   address public owner;
224 
225 
226   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228 
229   /**
230    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231    * account.
232    */
233   function Ownable() public {
234     owner = msg.sender;
235   }
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245   /**
246    * @dev Allows the current owner to transfer control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function transferOwnership(address newOwner) public onlyOwner {
250     require(newOwner != address(0));
251     OwnershipTransferred(owner, newOwner);
252     owner = newOwner;
253   }
254 
255 }
256 
257 
258 /**
259  * @title Ownable
260  * @dev The Ownable contract has an owner address, and provides basic authorization control
261  * functions, this simplifies the implementation of "user permissions".
262  */
263 contract OwnedByContract is Ownable{
264     address public ownerContract;
265 
266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
267 
268     /**
269     * @dev Throws if called by any account other than the owner.
270     */
271     modifier onlyOwnerContract() {
272         require(msg.sender == ownerContract);
273         _;
274     }
275 
276     /**
277     * @dev Allows the current owner to set the minter contract to a new smart contract.
278     * @param newOwner The address to set the minter. Throws an error if the address is an EOA.
279     */
280     function setMinterContract(address newOwner) public onlyOwner {
281         require(newOwner != address(0));
282         require(isContract(newOwner));
283         emit OwnershipTransferred(ownerContract, newOwner);
284         ownerContract = newOwner;
285     }
286 
287     /**
288     * @dev Checks if the address is a smart contract.
289     * @param addr The address that required to be checked.
290     * @return True if the account in the address is a smart contract, False if the address is an EOA.
291     */
292     function isContract(address addr) internal view returns (bool) {
293         uint size;
294         assembly { 
295           size := extcodesize(addr)
296         }
297         return size > 0;
298     }
299 
300 }
301 
302 
303 
304 /**
305  * @title Mintable by another contract.
306  * Minting is only allowed to another contract. 
307  */
308 contract MintableToken is StandardToken, OwnedByContract {
309     event Mint(address indexed to, uint256 amount);
310     event MintFinished();
311 
312     bool public mintingFinished = false;
313 
314     modifier canMint() {
315         require(!mintingFinished);
316         _;
317     }
318 
319     /**
320     * @dev Function to mint tokens
321     * @param _to The address that will receive the minted tokens.
322     * @param _amount The amount of tokens to mint.
323     * @return A boolean that indicates if the operation was successful.
324     */
325     function mint(address _to, uint256 _amount) onlyOwnerContract canMint public returns (bool) {
326         totalSupply_ = totalSupply_.add(_amount);
327         balances[_to] = balances[_to].add(_amount);
328         Mint(_to, _amount);
329         Transfer(address(0), _to, _amount);
330         return true;
331     }
332 
333     /**
334     * @dev Function to stop minting new tokens.
335     * @return True if the operation was successful.
336     */
337     function finishMinting() onlyOwnerContract canMint public returns (bool) {
338         mintingFinished = true;
339         MintFinished();
340         return true;
341     }
342 }
343 
344 contract Jcoin is MintableToken {
345     string public name = "Jcoin";
346     string public symbol = "JCO";
347     uint8 public decimals = 18;
348     
349     address private constant COMPANY_ADDRESS = 0x695e23819F9F307318c471Ea698Bb1aa0C40Df25;
350     address private constant REWARDS_ADDRESS = 0x9a1FD2632ad10d2e329312C7e947ee3Ba05663a5;
351     address private constant ADVISORS_ADDRESS = 0x82d39148389837B7F5f9eC8B425EdaBc8F0edFA5;
352     address private constant TEAM_ADDRESS = 0x83426931a7986D590b4B8633217EBf95c13Fa655;
353     address private constant PRE_ICO_ADDRESS = 0x535FC3d183C7feCDB730F11cc276000880b373Cc;
354     address private constant ICO_ADDRESS = 0xa17536ae64eb311cfdD9DB8bDf1c1997C691c383;
355     
356     uint256 private constant COMPANY_AMOUNT = 13860000;
357     uint256 private constant REWARDS_AMOUNT = 6300000;
358     uint256 private constant ADVISORS_AMOUNT = 4410000;
359     uint256 private constant TEAM_AMOUNT = 6930000;
360     uint256 private constant PRE_ICO_AMOUNT = 10500000;
361     uint256 private constant ICO_AMOUNT = 21000000;
362     uint256 private constant SUPPLY_AMOUNT = 63000000;
363     
364     function Jcoin() public {
365         uint256 decimalPlace = 10 ** uint(decimals);
366         
367         totalSupply_ = SUPPLY_AMOUNT * decimalPlace;
368         
369         initialTransfer(COMPANY_ADDRESS, COMPANY_AMOUNT, decimalPlace);
370         initialTransfer(REWARDS_ADDRESS, REWARDS_AMOUNT, decimalPlace);
371         initialTransfer(ADVISORS_ADDRESS, ADVISORS_AMOUNT, decimalPlace);
372         initialTransfer(TEAM_ADDRESS, TEAM_AMOUNT, decimalPlace);
373         initialTransfer(PRE_ICO_ADDRESS, PRE_ICO_AMOUNT, decimalPlace);
374         initialTransfer(ICO_ADDRESS, ICO_AMOUNT, decimalPlace);
375     }
376     
377     /**
378     * @dev Function Transfers the funds to accounts described in the whitepaper.
379     */
380     function initialTransfer(address _to, uint256 _amount, uint256 _decimalPlace) private { 
381         balances[_to] = _amount.mul(_decimalPlace);
382         Transfer(address(0), _to, balances[_to]);
383     }
384 }