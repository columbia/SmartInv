1 pragma solidity >=0.5.6;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   address delegate;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20     emit OwnershipTransferred(address(0), owner);
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     delegate = newOwner;
38   }
39 
40   function confirmChangeOwnership() public {
41     require(msg.sender == delegate);
42     emit OwnershipTransferred(owner, delegate);
43     owner = delegate;
44     delegate = address(0);
45   }
46 }
47 
48 
49 
50 
51 
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58 
59   /**
60   * @dev Multiplies two numbers, throws on overflow.
61   */
62   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63     if (a == 0) {
64       return 0;
65     }
66     uint256 c = a * b;
67     assert(c / a == b);
68     return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers, truncating the quotient.
73   */
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     // assert(b > 0); // Solidity automatically throws when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78     return c;
79   }
80 
81   /**
82   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
83   */
84   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85     assert(b <= a);
86     return a - b;
87   }
88 
89   /**
90   * @dev Adds two numbers, throws on overflow.
91   */
92   function add(uint256 a, uint256 b) internal pure returns (uint256) {
93     uint256 c = a + b;
94     assert(c >= a);
95     return c;
96   }
97 }
98 
99 
100 
101 
102 
103 
104 
105 contract TransferFilter is Ownable {
106   bool public isTransferable;
107   mapping( address => bool ) public mapAddressPass;
108   mapping( address => bool ) public mapAddressBlock;
109 
110   event LogSetTransferable(bool transferable);
111   event LogFilterPass(address indexed target, bool status);
112   event LogFilterBlock(address indexed target, bool status);
113 
114   // if Token transfer
115   modifier checkTokenTransfer(address source) {
116       if (isTransferable == true) {
117           require(mapAddressBlock[source] == false);
118       }
119       else {
120           require(mapAddressPass[source] == true);
121       }
122       _;
123   }
124 
125   constructor() public {
126       isTransferable = true;
127   }
128 
129   function setTransferable(bool transferable) public onlyOwner {
130       isTransferable = transferable;
131       emit LogSetTransferable(transferable);
132   }
133 
134   function isInPassFilter(address user) public view returns (bool) {
135     return mapAddressPass[user];
136   }
137 
138   function isInBlockFilter(address user) public view returns (bool) {
139     return mapAddressBlock[user];
140   }
141 
142   function addressToPass(address[] memory target, bool status)
143   public
144   onlyOwner
145   {
146     for( uint i = 0 ; i < target.length ; i++ ) {
147         address targetAddress = target[i];
148         bool old = mapAddressPass[targetAddress];
149         if (old != status) {
150             if (status == true) {
151                 mapAddressPass[targetAddress] = true;
152                 emit LogFilterPass(targetAddress, true);
153             }
154             else {
155                 delete mapAddressPass[targetAddress];
156                 emit LogFilterPass(targetAddress, false);
157             }
158         }
159     }
160   }
161 
162   function addressToBlock(address[] memory target, bool status)
163   public
164   onlyOwner
165   {
166       for( uint i = 0 ; i < target.length ; i++ ) {
167           address targetAddress = target[i];
168           bool old = mapAddressBlock[targetAddress];
169           if (old != status) {
170               if (status == true) {
171                   mapAddressBlock[targetAddress] = true;
172                   emit LogFilterBlock(targetAddress, true);
173               }
174               else {
175                   delete mapAddressBlock[targetAddress];
176                   emit LogFilterBlock(targetAddress, false);
177               }
178           }
179       }
180   }
181 }
182 
183 
184 /**
185  * @title ERC20 interface
186  * @dev see https://github.com/ethereum/EIPs/issues/20
187  */
188 contract ERC20 {
189   uint256 public totalSupply;
190   function balanceOf(address who) public view returns (uint256);
191   function transfer(address to, uint256 value) public returns (bool);
192   function allowance(address owner, address spender) public view returns (uint256);
193   function transferFrom(address from, address to, uint256 value) public returns (bool);
194   function approve(address spender, uint256 value) public returns (bool);
195   event Transfer(address indexed from, address indexed to, uint256 value);
196   event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, TransferFilter {
208   using SafeMath for uint256;
209 
210   mapping(address => uint256) balances;
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214   modifier onlyPayloadSize(uint size) {
215     require(msg.data.length >= size + 4);
216     _;
217   }
218 
219   /**
220   * @dev transfer token for a specified address
221   * @param _to The address to transfer to.
222   * @param _value The amount to be transferred.
223   */
224   function transfer(address _to, uint256 _value)
225   onlyPayloadSize(2 * 32)
226   checkTokenTransfer(msg.sender)
227   public returns (bool) {
228     require(_to != address(0));
229     require(_value <= balances[msg.sender]);
230 
231     // SafeMath.sub will throw if there is not enough balance.
232     balances[msg.sender] = balances[msg.sender].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     emit Transfer(msg.sender, _to, _value);
235     return true;
236   }
237 
238   /**
239   * @dev Gets the balance of the specified address.
240   * @param _owner The address to query the the balance of.
241   * @return An uint256 representing the amount owned by the passed address.
242   */
243   function balanceOf(address _owner) public view returns (uint256 balance) {
244     return balances[_owner];
245   }
246 
247   /**
248    * @dev Transfer tokens from one address to another
249    * @param _from address The address which you want to send tokens from
250    * @param _to address The address which you want to transfer to
251    * @param _value uint256 the amount of tokens to be transferred
252    */
253   function transferFrom(address _from, address _to, uint256 _value)
254   onlyPayloadSize(3 * 32)
255   checkTokenTransfer(_from)
256   public returns (bool) {
257     require(_to != address(0));
258     require(_value <= balances[_from]);
259     require(_value <= allowed[_from][msg.sender]);
260 
261     balances[_from] = balances[_from].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     uint256 _allowedValue = allowed[_from][msg.sender].sub(_value);
264     allowed[_from][msg.sender] = _allowedValue;
265     emit Transfer(_from, _to, _value);
266     emit Approval(_from, msg.sender, _allowedValue);
267     return true;
268   }
269 
270   function approve(address _spender, uint256 _value)
271   onlyPayloadSize(2 * 32)
272   checkTokenTransfer(msg.sender)
273   public returns (bool) {
274     // To change the approve amount you first have to reduce the addresses`
275     //  allowance to zero by calling `approve(_spender,0)` if it is not
276     //  already 0 to mitigate the race condition described here:
277     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
279 
280     allowed[msg.sender][_spender] = _value;
281     emit Approval(msg.sender, _spender, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Function to check the amount of tokens that an owner allowed to a spender.
287    * @param _owner address The address which owns the funds.
288    * @param _spender address The address which will spend the funds.
289    * @return A uint256 specifying the amount of tokens still available for the spender.
290    */
291   function allowance(address _owner, address _spender) public view returns (uint256) {
292     return allowed[_owner][_spender];
293   }
294 }
295 
296 contract BurnableToken is StandardToken {
297   event Burn(address indexed from, uint256 value);
298 
299   function burn(address _from, uint256 _amount) public onlyOwner {
300     require(_amount <= balances[_from]);
301     totalSupply = totalSupply.sub(_amount);
302     balances[_from] = balances[_from].sub(_amount);
303     emit Transfer(_from, address(0), _amount);
304     emit Burn(_from, _amount);
305   }
306 }
307 
308 /**
309  * @title Mintable token
310  * @dev Simple ERC20 Token example, with mintable token creation
311  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 
315 contract MintableToken is BurnableToken {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320   address public minter;
321 
322   constructor() public {
323     minter = msg.sender;
324   }
325 
326   modifier canMint() {
327     require(!mintingFinished);
328     _;
329   }
330 
331   modifier hasPermission() {
332     require(msg.sender == owner || msg.sender == minter);
333     _;
334   }
335 
336   function () external payable {
337     require(false);
338   }
339 
340   /**
341    * @dev Function to mint tokens
342    * @param _to The address that will receive the minted tokens.
343    * @param _amount The amount of tokens to mint.
344    * @return A boolean that indicates if the operation was successful.
345    */
346   function mint(address _to, uint256 _amount) canMint hasPermission public returns (bool) {
347     totalSupply = totalSupply.add(_amount);
348     balances[_to] = balances[_to].add(_amount);
349     emit Mint(_to, _amount);
350     emit Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() canMint onlyOwner public returns (bool) {
359     mintingFinished = true;
360     emit MintFinished();
361     return true;
362   }
363 }
364 
365 
366 contract Candy is MintableToken {
367   string public constant name = "Candy"; // solium-disable-line uppercase
368   string public constant symbol = "CAD"; // solium-disable-line uppercase
369   uint8 public constant decimals = 18; // solium-disable-line uppercase
370   /**
371    * @dev Constructor that gives msg.sender all of existing tokens.
372    */
373   constructor() public {
374     totalSupply = 0;
375   }
376 }