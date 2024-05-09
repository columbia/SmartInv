1 pragma solidity 0.5.6;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   address public delegate;
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
27     require(msg.sender == owner, "You must be owner.");
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0), "Invalid new owner address.");
37     delegate = newOwner;
38   }
39 
40   function confirmChangeOwnership() public {
41     require(msg.sender == delegate, "You must be delegate.");
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
67     require(c / a == b, "Multiplying uint256 overflow.");
68     return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers, truncating the quotient.
73   */
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b != 0, "Dividing by zero is not allowed.");
76     uint256 c = a / b;
77     return c;
78   }
79 
80   /**
81   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b <= a, "Negative uint256 is now allowed.");
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a + b;
93     require(c >= a, "Adding uint256 overflow.");
94     return c;
95   }
96 }
97 
98 
99 
100 
101 
102 
103 
104 contract TransferFilter is Ownable {
105   bool public isTransferable;
106   mapping( address => bool ) internal mapAddressPass;
107   mapping( address => bool ) internal mapAddressBlock;
108 
109   event LogSetTransferable(bool transferable);
110   event LogFilterPass(address indexed target, bool status);
111   event LogFilterBlock(address indexed target, bool status);
112 
113   // if Token transfer
114   modifier checkTokenTransfer(address source) {
115       if (isTransferable) {
116           require(!mapAddressBlock[source], "Source address is in block filter.");
117       }
118       else {
119           require(mapAddressPass[source], "Source address must be in pass filter.");
120       }
121       _;
122   }
123 
124   constructor() public {
125       isTransferable = true;
126   }
127 
128   function setTransferable(bool transferable) external onlyOwner {
129       isTransferable = transferable;
130       emit LogSetTransferable(transferable);
131   }
132 
133   function isInPassFilter(address user) external view returns (bool) {
134     return mapAddressPass[user];
135   }
136 
137   function isInBlockFilter(address user) external view returns (bool) {
138     return mapAddressBlock[user];
139   }
140 
141   function addressToPass(address[] calldata target, bool status)
142   external
143   onlyOwner
144   {
145     for( uint i = 0 ; i < target.length ; i++ ) {
146         address targetAddress = target[i];
147         bool old = mapAddressPass[targetAddress];
148         if (old != status) {
149             if (status) {
150                 mapAddressPass[targetAddress] = true;
151                 emit LogFilterPass(targetAddress, true);
152             }
153             else {
154                 delete mapAddressPass[targetAddress];
155                 emit LogFilterPass(targetAddress, false);
156             }
157         }
158     }
159   }
160 
161   function addressToBlock(address[] calldata target, bool status)
162   external
163   onlyOwner
164   {
165       for( uint i = 0 ; i < target.length ; i++ ) {
166           address targetAddress = target[i];
167           bool old = mapAddressBlock[targetAddress];
168           if (old != status) {
169               if (status) {
170                   mapAddressBlock[targetAddress] = true;
171                   emit LogFilterBlock(targetAddress, true);
172               }
173               else {
174                   delete mapAddressBlock[targetAddress];
175                   emit LogFilterBlock(targetAddress, false);
176               }
177           }
178       }
179   }
180 }
181 
182 
183 /**
184  * @title ERC20 interface
185  * @dev see https://github.com/ethereum/EIPs/issues/20
186  */
187 contract ERC20 {
188   uint256 public totalSupply;
189   function balanceOf(address who) public view returns (uint256);
190   function transfer(address to, uint256 value) public returns (bool);
191   function allowance(address owner, address spender) public view returns (uint256);
192   function transferFrom(address from, address to, uint256 value) public returns (bool);
193   function approve(address spender, uint256 value) public returns (bool);
194   event Transfer(address indexed from, address indexed to, uint256 value);
195   event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, TransferFilter {
207   using SafeMath for uint256;
208 
209   mapping(address => uint256) internal balances;
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213   modifier onlyPayloadSize(uint8 param) {
214     // Check payload size to prevent short address attack.
215     // Payload size must be longer than sum of methodID length and size of parameters.
216     require(msg.data.length >= param * 32 + 4);
217     _;
218   }
219 
220   /**
221   * @dev transfer token for a specified address
222   * @param _to The address to transfer to.
223   * @param _value The amount to be transferred.
224   */
225   function transfer(address _to, uint256 _value)
226   onlyPayloadSize(2) // number of parameters
227   checkTokenTransfer(msg.sender)
228   public returns (bool) {
229     require(_to != address(0), "Invalid destination address.");
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
254   onlyPayloadSize(3) // number of parameters
255   checkTokenTransfer(_from)
256   public returns (bool) {
257     require(_from != address(0), "Invalid source address.");
258     require(_to != address(0), "Invalid destination address.");
259 
260     balances[_from] = balances[_from].sub(_value);
261     balances[_to] = balances[_to].add(_value);
262     uint256 _allowedValue = allowed[_from][msg.sender].sub(_value);
263     allowed[_from][msg.sender] = _allowedValue;
264     emit Transfer(_from, _to, _value);
265     emit Approval(_from, msg.sender, _allowedValue);
266     return true;
267   }
268 
269   function approve(address _spender, uint256 _value)
270   onlyPayloadSize(2) // number of parameters
271   checkTokenTransfer(msg.sender)
272   public returns (bool) {
273     require(_spender != address(0), "Invalid spender address.");
274 
275     // To change the approve amount you first have to reduce the addresses`
276     //  allowance to zero by calling `approve(_spender,0)` if it is not
277     //  already 0 to mitigate the race condition described here:
278     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279     require((_value == 0) || (allowed[msg.sender][_spender] == 0), "Already approved.");
280 
281     allowed[msg.sender][_spender] = _value;
282     emit Approval(msg.sender, _spender, _value);
283     return true;
284   }
285 
286   /**
287    * @dev Function to check the amount of tokens that an owner allowed to a spender.
288    * @param _owner address The address which owns the funds.
289    * @param _spender address The address which will spend the funds.
290    * @return A uint256 specifying the amount of tokens still available for the spender.
291    */
292   function allowance(address _owner, address _spender) public view returns (uint256) {
293     return allowed[_owner][_spender];
294   }
295 }
296 
297 /**
298  * @title Mintable token
299  * @dev Simple ERC20 Token example, with mintable token creation
300  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
301  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
302  */
303 
304 contract MintableToken is StandardToken {
305   event MinterTransferred(address indexed previousMinter, address indexed newMinter);
306   event Mint(address indexed to, uint256 amount);
307   event MintFinished();
308   event Burn(address indexed from, uint256 value);
309 
310   bool public mintingFinished = false;
311   address public minter;
312 
313   constructor() public {
314     minter = msg.sender;
315     emit MinterTransferred(address(0), minter);
316   }
317 
318   modifier canMint() {
319     require(!mintingFinished, "Minting is already finished.");
320     _;
321   }
322 
323   modifier hasPermission() {
324     require(msg.sender == owner || msg.sender == minter, "You must be either owner or minter.");
325     _;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(address _to, uint256 _amount) canMint hasPermission external returns (bool) {
335     require(_to != address(0), "Invalid destination address.");
336 
337     totalSupply = totalSupply.add(_amount);
338     balances[_to] = balances[_to].add(_amount);
339     emit Mint(_to, _amount);
340     emit Transfer(address(0), _to, _amount);
341     return true;
342   }
343 
344   /**
345    * @dev Function to stop minting new tokens.
346    * @return True if the operation was successful.
347    */
348   function finishMinting() canMint onlyOwner external returns (bool) {
349     mintingFinished = true;
350     emit MintFinished();
351     return true;
352   }
353 
354   function transferMinter(address newMinter) public onlyOwner {
355     require(newMinter != address(0), "Invalid new minter address.");
356     address prevMinter = minter;
357     minter = newMinter;
358     emit MinterTransferred(prevMinter, minter);
359   }
360 
361   function burn(address _from, uint256 _amount) external hasPermission {
362     require(_from != address(0), "Invalid source address.");
363 
364     balances[_from] = balances[_from].sub(_amount);
365     totalSupply = totalSupply.sub(_amount);
366     emit Transfer(_from, address(0), _amount);
367     emit Burn(_from, _amount);
368   }
369 }
370 
371 
372 contract ZCON is MintableToken {
373   string public constant name = "ZCON Protocol"; // solium-disable-line uppercase
374   string public constant symbol = "ZCON"; // solium-disable-line uppercase
375   uint8 public constant decimals = 18; // solium-disable-line uppercase
376   /**
377    * @dev Constructor that initialize token.
378    */
379   constructor() public {
380     //totalSupply = 0;
381   }
382 }