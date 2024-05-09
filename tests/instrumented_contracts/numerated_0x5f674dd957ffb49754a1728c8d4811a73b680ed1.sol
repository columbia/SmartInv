1 pragma solidity ^0.4.22;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11   address delegate;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23     emit OwnershipTransferred(address(0), owner);
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     delegate = newOwner;
41   }
42 
43   function confirmChangeOwnership() public {
44     require(msg.sender == delegate);
45     emit OwnershipTransferred(owner, delegate);
46     owner = delegate;
47     delegate = 0;
48   }
49 
50 }
51 
52 
53 
54 
55 
56 
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, throws on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     if (a == 0) {
69       return 0;
70     }
71     uint256 c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return c;
84   }
85 
86   /**
87   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 
105 
106 
107 
108 
109 
110 contract TransferFilter is Ownable {
111   bool public isTransferable;
112   mapping( address => bool ) public mapAddressPass;
113   mapping( address => bool ) public mapAddressBlock;
114 
115   event LogFilterPass(address indexed target, bool status);
116   event LogFilterBlock(address indexed target, bool status);
117 
118   // if Token transfer
119   modifier checkTokenTransfer(address source) {
120       if (isTransferable == true) {
121           require(mapAddressBlock[source] == false);
122       }
123       else {
124           require(mapAddressPass[source] == true);
125       }
126       _;
127   }
128 
129   constructor() public {
130       isTransferable = true;
131   }
132 
133   function setTransferable(bool status) public onlyOwner {
134       isTransferable = status;
135   }
136 
137   function isInPassFilter(address user) public view returns (bool) {
138     return mapAddressPass[user];
139   }
140 
141   function isInBlockFilter(address user) public view returns (bool) {
142     return mapAddressBlock[user];
143   }
144 
145   function addressToPass(address[] target, bool status)
146   public
147   onlyOwner
148   {
149     for( uint i = 0 ; i < target.length ; i++ ) {
150         address targetAddress = target[i];
151         bool old = mapAddressPass[targetAddress];
152         if (old != status) {
153             if (status == true) {
154                 mapAddressPass[targetAddress] = true;
155                 emit LogFilterPass(targetAddress, true);
156             }
157             else {
158                 delete mapAddressPass[targetAddress];
159                 emit LogFilterPass(targetAddress, false);
160             }
161         }
162     }
163   }
164 
165   function addressToBlock(address[] target, bool status)
166   public
167   onlyOwner
168   {
169       for( uint i = 0 ; i < target.length ; i++ ) {
170           address targetAddress = target[i];
171           bool old = mapAddressBlock[targetAddress];
172           if (old != status) {
173               if (status == true) {
174                   mapAddressBlock[targetAddress] = true;
175                   emit LogFilterBlock(targetAddress, true);
176               }
177               else {
178                   delete mapAddressBlock[targetAddress];
179                   emit LogFilterBlock(targetAddress, false);
180               }
181           }
182       }
183   }
184 }
185 
186 
187 /**
188  * @title ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/20
190  */
191 contract ERC20 {
192   uint256 public totalSupply;
193   function balanceOf(address who) public view returns (uint256);
194   function transfer(address to, uint256 value) public returns (bool);
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Transfer(address indexed from, address indexed to, uint256 value);
199   event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 
203 /**
204  * @title Standard ERC20 token
205  *
206  * @dev Implementation of the basic standard token.
207  * @dev https://github.com/ethereum/EIPs/issues/20
208  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
209  */
210 contract StandardToken is ERC20, TransferFilter {
211   using SafeMath for uint256;
212 
213   mapping(address => uint256) balances;
214 
215   mapping (address => mapping (address => uint256)) internal allowed;
216 
217   modifier onlyPayloadSize(uint size) {
218     require(msg.data.length >= size + 4);
219     _;
220   }
221 
222   /**
223   * @dev transfer token for a specified address
224   * @param _to The address to transfer to.
225   * @param _value The amount to be transferred.
226   */
227   function transfer(address _to, uint256 _value)
228   onlyPayloadSize(2 * 32)
229   checkTokenTransfer(msg.sender)
230   public returns (bool) {
231     require(_to != address(0));
232     require(_value <= balances[msg.sender]);
233 
234     // SafeMath.sub will throw if there is not enough balance.
235     balances[msg.sender] = balances[msg.sender].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     emit Transfer(msg.sender, _to, _value);
238     return true;
239   }
240 
241   /**
242   * @dev Gets the balance of the specified address.
243   * @param _owner The address to query the the balance of.
244   * @return An uint256 representing the amount owned by the passed address.
245   */
246   function balanceOf(address _owner) public view returns (uint256 balance) {
247     return balances[_owner];
248   }
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param _from address The address which you want to send tokens from
253    * @param _to address The address which you want to transfer to
254    * @param _value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(address _from, address _to, uint256 _value)
257   onlyPayloadSize(3 * 32)
258   checkTokenTransfer(_from)
259   public returns (bool) {
260     require(_to != address(0));
261     require(_value <= balances[_from]);
262     require(_value <= allowed[_from][msg.sender]);
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     emit Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   function approve(address _spender, uint256 _value)
272   onlyPayloadSize(2 * 32)
273   checkTokenTransfer(msg.sender)
274   public returns (bool) {
275     // To change the approve amount you first have to reduce the addresses`
276     //  allowance to zero by calling `approve(_spender,0)` if it is not
277     //  already 0 to mitigate the race condition described here:
278     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
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
297 contract BurnableToken is StandardToken {
298   event Burn(address indexed from, uint256 value);
299 
300   function burn(address _from, uint256 _amount) public onlyOwner {
301     require(_amount <= balances[_from]);
302     totalSupply = totalSupply.sub(_amount);
303     balances[_from] = balances[_from].sub(_amount);
304     emit Transfer(_from, address(0), _amount);
305     emit Burn(_from, _amount);
306   }
307 }
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 
316 contract MintableToken is BurnableToken {
317   event Mint(address indexed to, uint256 amount);
318   event MintFinished();
319 
320   bool public mintingFinished = false;
321   address public minter;
322 
323   constructor() public {
324     minter = msg.sender;
325   }
326 
327   modifier canMint() {
328     require(!mintingFinished);
329     _;
330   }
331 
332   modifier hasPermission() {
333     require(msg.sender == owner || msg.sender == minter);
334     _;
335   }
336 
337   function () public payable {
338     require(false);
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) canMint hasPermission public returns (bool) {
348     totalSupply = totalSupply.add(_amount);
349     balances[_to] = balances[_to].add(_amount);
350     emit Mint(_to, _amount);
351     emit Transfer(address(0), _to, _amount);
352     return true;
353   }
354 
355   /**
356    * @dev Function to stop minting new tokens.
357    * @return True if the operation was successful.
358    */
359   function finishMinting() canMint onlyOwner public returns (bool) {
360     mintingFinished = true;
361     emit MintFinished();
362     return true;
363   }
364 }
365 
366 
367 contract VoltraCoin is MintableToken {
368 
369   string public constant name = "VoltraCoin"; // solium-disable-line uppercase
370   string public constant symbol = "VLT"; // solium-disable-line uppercase
371   uint8 public constant decimals = 18; // solium-disable-line uppercase
372   /**
373    * @dev Constructor that gives msg.sender all of existing tokens.
374    */
375   constructor() public {
376     totalSupply = 0;
377   }
378 }