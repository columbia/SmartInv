1 /*
2  * Etherus Token smart contract
3  *
4  * Supports ERC20 standard
5  *
6  * The EtherusToken is mintable during Token Sale. On Token Sale finalization it
7  * will be minted up to the cap and minting will be finished forever
8  *
9  */
10 
11 
12 pragma solidity ^0.4.21;
13 
14 
15 /**
16  * @title ERC20Basic
17  * @dev Simpler version of ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/179
19  */
20 contract ERC20Basic {
21   uint256 public totalSupply;
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 
28 
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
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
98 
99 }
100 
101 
102 
103 
104 
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) internal allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public view returns (uint256) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /**
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _subtractedValue The amount of tokens to decrease the allowance by.
201    */
202   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 
216 
217 
218 /**
219  * @title Ownable
220  * @dev The Ownable contract has an owner address, and provides basic authorization control
221  * functions, this simplifies the implementation of "user permissions".
222  */
223 contract Ownable {
224   address public owner;
225 
226 
227   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229 
230   /**
231    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232    * account.
233    */
234   function Ownable() public {
235     owner = msg.sender;
236   }
237 
238 
239   /**
240    * @dev Throws if called by any account other than the owner.
241    */
242   modifier onlyOwner() {
243     require(msg.sender == owner);
244     _;
245   }
246 
247 
248   /**
249    * @dev Allows the current owner to transfer control of the contract to a newOwner.
250    * @param newOwner The address to transfer ownership to.
251    */
252   function transferOwnership(address newOwner) public onlyOwner {
253     require(newOwner != address(0));
254     OwnershipTransferred(owner, newOwner);
255     owner = newOwner;
256   }
257 
258 }
259 
260 
261 /**
262  * Mintable token
263  */
264 
265 contract MintableToken is StandardToken, Ownable {
266     uint public totalSupply = 0;
267     address private minter;
268     bool public mintingEnabled = true;
269 
270     modifier onlyMinter() {
271         require(minter == msg.sender);
272         _;
273     }
274 
275     function setMinter(address _minter) public onlyOwner {
276         minter = _minter;
277     }
278 
279     function mint(address _to, uint _amount) public onlyMinter {
280         require(mintingEnabled);
281         totalSupply = totalSupply.add(_amount);
282         balances[_to] = balances[_to].add(_amount);
283         Transfer(address(0x0), _to, _amount);
284     }
285 
286     function stopMinting() public onlyMinter {
287         mintingEnabled = false;
288     }
289 }
290 
291 
292 
293 
294 
295 
296 
297 
298 
299 
300 /*
301  * ERC23
302  * ERC23 interface
303  * see https://github.com/ethereum/EIPs/issues/223
304  */
305 contract ERC23 is ERC20Basic {
306     function transfer(address to, uint value, bytes data) public;
307 
308     event TransferData(address indexed from, address indexed to, uint value, bytes data);
309 }
310 
311 
312 
313 /*
314 * Contract that is working with ERC223 tokens
315 */
316 
317 contract ERC23PayableReceiver {
318     function tokenFallback(address _from, uint _value, bytes _data) public payable;
319 }
320 
321 
322 /**  https://github.com/Dexaran/ERC23-tokens/blob/master/token/ERC223/ERC223BasicToken.sol
323  *
324  */
325 contract ERC23PayableToken is BasicToken, ERC23 {
326     // Function that is called when a user or another contract wants to transfer funds .
327     function transfer(address to, uint value, bytes data) public {
328         transferAndPay(to, value, data);
329     }
330 
331     // Standard function transfer similar to ERC20 transfer with no _data .
332     // Added due to backwards compatibility reasons .
333     function transfer(address to, uint value) public returns (bool) {
334         bytes memory empty;
335         transfer(to, value, empty);
336         return true;
337     }
338 
339     function transferAndPay(address to, uint value, bytes data) public payable {
340         // Standard function transfer similar to ERC20 transfer with no _data .
341         // Added due to backwards compatibility reasons .
342         uint codeLength;
343 
344         assembly {
345             // Retrieve the size of the code on target address, this needs assembly .
346             codeLength := extcodesize(to)
347         }
348 
349         balances[msg.sender] = balances[msg.sender].sub(value);
350         balances[to] = balances[to].add(value);
351 
352         if (codeLength > 0) {
353             ERC23PayableReceiver receiver = ERC23PayableReceiver(to);
354             receiver.tokenFallback.value(msg.value)(msg.sender, value, data);
355         }else if (msg.value > 0) {
356             to.transfer(msg.value);
357         }
358 
359         Transfer(msg.sender, to, value);
360         if (data.length > 0)
361             TransferData(msg.sender, to, value, data);
362     }
363 }
364 
365 
366 contract EtherusToken is MintableToken, ERC23PayableToken {
367     string public constant name = "EtherusToken";
368     string public constant symbol = "ETR";
369     uint public constant decimals = 18;
370 
371     bool public transferEnabled = false;
372 
373     //The cap is 15 mln ETR
374     uint private constant CAP = 15*(10**6)*(10**decimals);
375 
376     function EtherusToken(address multisigOwner) public {
377         //Transfer ownership on the token to multisig on creation
378         transferOwnership(multisigOwner);
379     }
380 
381     function mint(address _to, uint _amount) public {
382         require(totalSupply.add(_amount) <= CAP);
383         super.mint(_to, _amount);
384     }
385 
386     /**
387     * Overriding all transfers to check if transfers are enabled
388     */
389     function transferAndPay(address to, uint value, bytes data) public payable {
390         require(transferEnabled);
391         super.transferAndPay(to, value, data);
392     }
393 
394     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
395         require(transferEnabled);
396         return super.transferFrom(_from, _to, _value);
397     }
398 
399     function enableTransfer(bool enabled) public onlyOwner {
400         transferEnabled = enabled;
401     }
402 
403     //Take Ether instead of tokens
404     function withdrawFrom(address from) private {
405         uint tokens = balanceOf(from);
406         require(tokens > 0);
407         balances[from] = 0;
408         totalSupply = totalSupply.sub(tokens);
409         from.transfer(tokens);
410         Transfer(from, 0, tokens);
411     }
412 
413     function withdraw() public {
414         withdrawFrom(msg.sender);
415     }
416 
417     function withdrawFor(address to) public onlyOwner {
418         withdrawFrom(to);
419     }
420 
421     function withdrawForMany(address[] tos) public onlyOwner {
422         for(uint i=0; i<tos.length; ++i){
423             withdrawFrom(tos[i]);
424         }
425     }
426 
427     function () public payable {
428         //We should accept Ether to make withdraw possible
429     }
430 }