1 pragma solidity ^0.4.19;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 // **************************
32 // import './ERC20Basic.sol';
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 // ******************
48 // import './ERC20.sol';
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 // **************************
63 // import './BasicToken.sol';
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   /**
75   * @dev transfer token for a specified address
76   * @param _to The address to transfer to.
77   * @param _value The amount to be transferred.
78   */
79   function transfer(address _to, uint256 _value) public returns (bool) {
80     require(_to != address(0));
81     require(_value <= balances[msg.sender]);
82 
83     // SafeMath.sub will throw if there is not enough balance.
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256 balance) {
96     return balances[_owner];
97   }
98 }
99 
100 
101 // *****************************
102 // import './StandardToken.sol';
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * @dev Increase the amount of tokens that an owner allowed to a spender.
162    *
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    * @param _spender The address which will spend the funds.
168    * @param _addedValue The amount of tokens to increase the allowance by.
169    */
170   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   /**
177    * @dev Decrease the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To decrement
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _subtractedValue The amount of tokens to decrease the allowance by.
185    */
186   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
187     uint oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 }
197 
198 
199 // *******************************
200 // import '../ownership/Ownable.sol';
201 
202 /**
203  * @title Ownable
204  * @dev The Ownable contract has an owner address, and provides basic authorization control
205  * functions, this simplifies the implementation of "user permissions".
206  */
207 contract Ownable {
208   address public owner;
209 
210 
211   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213 
214   /**
215    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
216    * account.
217    */
218   function Ownable() public {
219     owner = msg.sender;
220   }
221 
222 
223   /**
224    * @dev Throws if called by any account other than the owner.
225    */
226   modifier onlyOwner() {
227     require(msg.sender == owner);
228     _;
229   }
230 
231 
232   /**
233    * @dev Allows the current owner to transfer control of the contract to a newOwner.
234    * @param newOwner The address to transfer ownership to.
235    */
236   function transferOwnership(address newOwner) public onlyOwner {
237     require(newOwner != address(0));
238     OwnershipTransferred(owner, newOwner);
239     owner = newOwner;
240   }
241 }
242 
243 
244 // ************************************************************
245 // import "zeppelin-solidity/contracts/token/MintableToken.sol";
246 
247 /**
248  * @title Mintable token
249  * @dev Simple ERC20 Token example, with mintable token creation
250  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
251  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
252  */
253 
254 contract MintableToken is StandardToken, Ownable {
255   event Mint(address indexed to, uint256 amount);
256   event MintFinished();
257 
258   bool public mintingFinished = false;
259 
260 
261   modifier canMint() {
262     require(!mintingFinished);
263     _;
264   }
265 
266   /**
267    * @dev Function to mint tokens
268    * @param _to The address that will receive the minted tokens.
269    * @param _amount The amount of tokens to mint.
270    * @return A boolean that indicates if the operation was successful.
271    */
272   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
273     totalSupply = totalSupply.add(_amount);
274     balances[_to] = balances[_to].add(_amount);
275     Mint(_to, _amount);
276     Transfer(address(0), _to, _amount);
277     return true;
278   }
279 
280   /**
281    * @dev Function to stop minting new tokens.
282    * @return True if the operation was successful.
283    */
284   function finishMinting() onlyOwner canMint public returns (bool) {
285     mintingFinished = true;
286     MintFinished();
287     return true;
288   }
289 }
290 /**
291  * @title Mintable token
292  * @dev Simple ERC20 Token example, with mintable token creation
293  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
294  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
295  */
296  
297 
298  
299 contract VestopiaToken is MintableToken {
300     
301     string public constant name = "Vestopia";
302     
303     string public constant symbol = "VTP";
304     
305     uint32 public constant decimals = 18;
306     
307 }
308  
309  
310 contract Crowdsale is Ownable {
311     
312     using SafeMath for uint;
313     
314     address multisig;
315  
316     uint restrictedPercent;
317  
318     address restricted;
319  
320     VestopiaToken public token = new VestopiaToken();
321  
322     uint start;
323     
324     uint period;
325  
326     uint hardcap;
327  
328     uint rate;
329     
330     uint minPrice;
331  
332     function Crowdsale() public {
333     minPrice = 100000000000000000;
334 	multisig =0x78e904695cc97248bB18eCfd83d4dd20D73fd619 ;
335 	restricted = 0x78e904695cc97248bB18eCfd83d4dd20D73fd619;
336 	restrictedPercent = 35;
337 	rate =  5000 * (10 ** 18);
338 	start = 1516838400;
339 	period = 60;
340     hardcap = 7257000000000000000000;
341     }
342  
343     modifier saleIsOn() {
344     	require(now > start && now < start + period * 1 days);
345     	_;
346     }
347 	
348     modifier isUnderHardCap() {
349         require(multisig.balance <= hardcap);
350         _;
351     }
352     
353   function setMinPrice(uint newMinPrice) public onlyOwner {
354      minPrice = newMinPrice;
355          
356      }
357   
358     
359     function finishMinting() public onlyOwner {
360        
361 	uint issuedTokenSupply = token.totalSupply();
362 	uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
363 	token.mint(restricted, restrictedTokens);
364         token.finishMinting();
365     }
366     
367  
368   function createTokens() isUnderHardCap saleIsOn public payable {
369       require(msg.value >= minPrice);
370         multisig.transfer(msg.value);
371         uint tokens = rate.mul(msg.value).div(1 ether);
372         uint bonusTokens = 0;
373         if(now < start + (period * 1 days).div(4)) {
374           bonusTokens = tokens.div(10).mul(3);
375         } else if(now >= start + (period * 1 days).div(4) && now < start + (period * 1 days).div(4).mul(2)) {
376           bonusTokens = tokens.div(5);
377         } else if(now >= start + (period * 1 days).div(4).mul(2) && now < start + (period * 1 days).div(4).mul(3)) {
378           bonusTokens = tokens.div(100).mul(15);
379         }
380         tokens += bonusTokens;
381         token.mint(msg.sender, tokens);
382     }
383 
384  
385     function() external payable {
386         createTokens();
387     }
388     
389 }