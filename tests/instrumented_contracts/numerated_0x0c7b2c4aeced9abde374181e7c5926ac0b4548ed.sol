1 pragma solidity 0.5.0;
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
110   event LogFilterPass(address indexed target, bool status);
111   event LogFilterBlock(address indexed target, bool status);
112 
113   // if Token transfer
114   modifier checkTokenTransfer(address source) {
115       if (isTransferable == true) {
116           require(mapAddressBlock[source] == false);
117       }
118       else {
119           require(mapAddressPass[source] == true);
120       }
121       _;
122   }
123 
124   constructor() public {
125       isTransferable = true;
126   }
127 
128   function setTransferable(bool status) public onlyOwner {
129       isTransferable = status;
130   }
131 
132   function isInPassFilter(address user) public view returns (bool) {
133     return mapAddressPass[user];
134   }
135 
136   function isInBlockFilter(address user) public view returns (bool) {
137     return mapAddressBlock[user];
138   }
139 
140   function addressToPass(address[] memory target, bool status)
141   public
142   onlyOwner
143   {
144     for( uint i = 0 ; i < target.length ; i++ ) {
145         address targetAddress = target[i];
146         bool old = mapAddressPass[targetAddress];
147         if (old != status) {
148             if (status == true) {
149                 mapAddressPass[targetAddress] = true;
150                 emit LogFilterPass(targetAddress, true);
151             }
152             else {
153                 delete mapAddressPass[targetAddress];
154                 emit LogFilterPass(targetAddress, false);
155             }
156         }
157     }
158   }
159 
160   function addressToBlock(address[] memory target, bool status)
161   public
162   onlyOwner
163   {
164       for( uint i = 0 ; i < target.length ; i++ ) {
165           address targetAddress = target[i];
166           bool old = mapAddressBlock[targetAddress];
167           if (old != status) {
168               if (status == true) {
169                   mapAddressBlock[targetAddress] = true;
170                   emit LogFilterBlock(targetAddress, true);
171               }
172               else {
173                   delete mapAddressBlock[targetAddress];
174                   emit LogFilterBlock(targetAddress, false);
175               }
176           }
177       }
178   }
179 }
180 
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 {
187   uint256 public totalSupply;
188   function balanceOf(address who) public view returns (uint256);
189   function transfer(address to, uint256 value) public returns (bool);
190   function allowance(address owner, address spender) public view returns (uint256);
191   function transferFrom(address from, address to, uint256 value) public returns (bool);
192   function approve(address spender, uint256 value) public returns (bool);
193   event Transfer(address indexed from, address indexed to, uint256 value);
194   event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/20
203  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
204  */
205 contract StandardToken is ERC20, TransferFilter {
206   using SafeMath for uint256;
207 
208   mapping(address => uint256) balances;
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212   modifier onlyPayloadSize(uint size) {
213     require(msg.data.length >= size + 4);
214     _;
215   }
216 
217   /**
218   * @dev transfer token for a specified address
219   * @param _to The address to transfer to.
220   * @param _value The amount to be transferred.
221   */
222   function transfer(address _to, uint256 _value)
223   onlyPayloadSize(2 * 32)
224   checkTokenTransfer(msg.sender)
225   public returns (bool) {
226     require(_to != address(0));
227     require(_value <= balances[msg.sender]);
228 
229     // SafeMath.sub will throw if there is not enough balance.
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     emit Transfer(msg.sender, _to, _value);
233     return true;
234   }
235 
236   /**
237   * @dev Gets the balance of the specified address.
238   * @param _owner The address to query the the balance of.
239   * @return An uint256 representing the amount owned by the passed address.
240   */
241   function balanceOf(address _owner) public view returns (uint256 balance) {
242     return balances[_owner];
243   }
244 
245   /**
246    * @dev Transfer tokens from one address to another
247    * @param _from address The address which you want to send tokens from
248    * @param _to address The address which you want to transfer to
249    * @param _value uint256 the amount of tokens to be transferred
250    */
251   function transferFrom(address _from, address _to, uint256 _value)
252   onlyPayloadSize(3 * 32)
253   checkTokenTransfer(_from)
254   public returns (bool) {
255     require(_to != address(0));
256     require(_value <= balances[_from]);
257     require(_value <= allowed[_from][msg.sender]);
258 
259     balances[_from] = balances[_from].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262     emit Transfer(_from, _to, _value);
263     return true;
264   }
265 
266   function approve(address _spender, uint256 _value)
267   onlyPayloadSize(2 * 32)
268   checkTokenTransfer(msg.sender)
269   public returns (bool) {
270     // To change the approve amount you first have to reduce the addresses`
271     //  allowance to zero by calling `approve(_spender,0)` if it is not
272     //  already 0 to mitigate the race condition described here:
273     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
274     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
275 
276     allowed[msg.sender][_spender] = _value;
277     emit Approval(msg.sender, _spender, _value);
278     return true;
279   }
280 
281   /**
282    * @dev Function to check the amount of tokens that an owner allowed to a spender.
283    * @param _owner address The address which owns the funds.
284    * @param _spender address The address which will spend the funds.
285    * @return A uint256 specifying the amount of tokens still available for the spender.
286    */
287   function allowance(address _owner, address _spender) public view returns (uint256) {
288     return allowed[_owner][_spender];
289   }
290 }
291 
292 contract BurnableToken is StandardToken {
293   event Burn(address indexed from, uint256 value);
294 
295   function burn(address _from, uint256 _amount) public onlyOwner {
296     require(_amount <= balances[_from]);
297     totalSupply = totalSupply.sub(_amount);
298     balances[_from] = balances[_from].sub(_amount);
299     emit Transfer(_from, address(0), _amount);
300     emit Burn(_from, _amount);
301   }
302 }
303 
304 /**
305  * @title Mintable token
306  * @dev Simple ERC20 Token example, with mintable token creation
307  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
308  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
309  */
310 
311 contract MintableToken is BurnableToken {
312   event Mint(address indexed to, uint256 amount);
313   event MintFinished();
314 
315   bool public mintingFinished = false;
316   address public minter;
317 
318   constructor() public {
319     minter = msg.sender;
320   }
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   modifier hasPermission() {
328     require(msg.sender == owner || msg.sender == minter);
329     _;
330   }
331 
332   function () external payable {
333     require(false);
334   }
335 
336   /**
337    * @dev Function to mint tokens
338    * @param _to The address that will receive the minted tokens.
339    * @param _amount The amount of tokens to mint.
340    * @return A boolean that indicates if the operation was successful.
341    */
342   function mint(address _to, uint256 _amount) canMint hasPermission public returns (bool) {
343     totalSupply = totalSupply.add(_amount);
344     balances[_to] = balances[_to].add(_amount);
345     emit Mint(_to, _amount);
346     emit Transfer(address(0), _to, _amount);
347     return true;
348   }
349 
350   /**
351    * @dev Function to stop minting new tokens.
352    * @return True if the operation was successful.
353    */
354   function finishMinting() canMint onlyOwner public returns (bool) {
355     mintingFinished = true;
356     emit MintFinished();
357     return true;
358   }
359 }
360 
361 
362 contract SkinRich is MintableToken {
363   string public constant name = "SkinRich"; // solium-disable-line uppercase
364   string public constant symbol = "SKIN"; // solium-disable-line uppercase
365   uint8 public constant decimals = 18; // solium-disable-line uppercase
366   /**
367    * @dev Constructor that gives msg.sender all of existing tokens.
368    */
369   constructor() public {
370     totalSupply = 0;
371   }
372 }