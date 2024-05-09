1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  /*
7  * Tie Token smart contract
8  *
9  * Supports ERC20, ERC223 stadards
10  *
11  * The TieToken is mintable during Token Sale. On Token Sale finalization it
12  * will be minted up to the cap and minting will be finished forever
13  *
14  * @author Dmitry Kochin <k@ties.network>
15  */
16 
17 
18 pragma solidity ^0.4.14;
19 
20 
21 /*************************************************************************
22  * import "./include/MintableToken.sol" : start
23  *************************************************************************/
24 
25 /*************************************************************************
26  * import "zeppelin/contracts/token/StandardToken.sol" : start
27  *************************************************************************/
28 
29 
30 /*************************************************************************
31  * import "./BasicToken.sol" : start
32  *************************************************************************/
33 
34 
35 /*************************************************************************
36  * import "./ERC20Basic.sol" : start
37  *************************************************************************/
38 
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) constant returns (uint256);
48   function transfer(address to, uint256 value) returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 /*************************************************************************
52  * import "./ERC20Basic.sol" : end
53  *************************************************************************/
54 /*************************************************************************
55  * import "../math/SafeMath.sol" : start
56  *************************************************************************/
57 
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a * b;
66     assert(a == 0 || c / a == b);
67     return c;
68   }
69 
70   function div(uint256 a, uint256 b) internal constant returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76 
77   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   function add(uint256 a, uint256 b) internal constant returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 /*************************************************************************
89  * import "../math/SafeMath.sol" : end
90  *************************************************************************/
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances. 
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) returns (bool) {
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of. 
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) constant returns (uint256 balance) {
120     return balances[_owner];
121   }
122 
123 }
124 /*************************************************************************
125  * import "./BasicToken.sol" : end
126  *************************************************************************/
127 /*************************************************************************
128  * import "./ERC20.sol" : start
129  *************************************************************************/
130 
131 
132 
133 
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender) constant returns (uint256);
141   function transferFrom(address from, address to, uint256 value) returns (bool);
142   function approve(address spender, uint256 value) returns (bool);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 /*************************************************************************
146  * import "./ERC20.sol" : end
147  *************************************************************************/
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159   mapping (address => mapping (address => uint256)) allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amout of tokens to be transfered
167    */
168   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
169     var _allowance = allowed[_from][msg.sender];
170 
171     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
172     // require (_value <= _allowance);
173 
174     balances[_to] = balances[_to].add(_value);
175     balances[_from] = balances[_from].sub(_value);
176     allowed[_from][msg.sender] = _allowance.sub(_value);
177     Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) returns (bool) {
187 
188     // To change the approve amount you first have to reduce the addresses`
189     //  allowance to zero by calling `approve(_spender, 0)` if it is not
190     //  already 0 to mitigate the race condition described here:
191     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
193 
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifing the amount of tokens still avaible for the spender.
204    */
205   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
206     return allowed[_owner][_spender];
207   }
208 
209 }
210 /*************************************************************************
211  * import "zeppelin/contracts/token/StandardToken.sol" : end
212  *************************************************************************/
213 /*************************************************************************
214  * import "zeppelin/contracts/ownership/Ownable.sol" : start
215  *************************************************************************/
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
227   /**
228    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
229    * account.
230    */
231   function Ownable() {
232     owner = msg.sender;
233   }
234 
235 
236   /**
237    * @dev Throws if called by any account other than the owner.
238    */
239   modifier onlyOwner() {
240     require(msg.sender == owner);
241     _;
242   }
243 
244 
245   /**
246    * @dev Allows the current owner to transfer control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function transferOwnership(address newOwner) onlyOwner {
250     if (newOwner != address(0)) {
251       owner = newOwner;
252     }
253   }
254 
255 }
256 /*************************************************************************
257  * import "zeppelin/contracts/ownership/Ownable.sol" : end
258  *************************************************************************/
259 
260 /**
261  * Mintable token
262  */
263 
264 contract MintableToken is StandardToken, Ownable {
265     uint public totalSupply = 0;
266     address private minter;
267 
268     modifier onlyMinter(){
269         require(minter == msg.sender);
270         _;
271     }
272 
273     function setMinter(address _minter) onlyOwner {
274         minter = _minter;
275     }
276 
277     function mint(address _to, uint _amount) onlyMinter {
278         totalSupply = totalSupply.add(_amount);
279         balances[_to] = balances[_to].add(_amount);
280         Transfer(address(0x0), _to, _amount);
281     }
282 }
283 /*************************************************************************
284  * import "./include/MintableToken.sol" : end
285  *************************************************************************/
286 /*************************************************************************
287  * import "./include/ERC23PayableToken.sol" : start
288  *************************************************************************/
289 
290 
291 
292 /*************************************************************************
293  * import "./ERC23.sol" : start
294  *************************************************************************/
295 
296 
297 
298 
299 /*
300  * ERC23
301  * ERC23 interface
302  * see https://github.com/ethereum/EIPs/issues/223
303  */
304 contract ERC23 is ERC20Basic {
305     function transfer(address to, uint value, bytes data);
306 
307     event TransferData(address indexed from, address indexed to, uint value, bytes data);
308 }
309 /*************************************************************************
310  * import "./ERC23.sol" : end
311  *************************************************************************/
312 /*************************************************************************
313  * import "./ERC23PayableReceiver.sol" : start
314  *************************************************************************/
315 
316 /*
317 * Contract that is working with ERC223 tokens
318 */
319 
320 contract ERC23PayableReceiver {
321     function tokenFallback(address _from, uint _value, bytes _data) payable;
322 }/*************************************************************************
323  * import "./ERC23PayableReceiver.sol" : end
324  *************************************************************************/
325 
326 /**  https://github.com/Dexaran/ERC23-tokens/blob/master/token/ERC223/ERC223BasicToken.sol
327  *
328  */
329 contract ERC23PayableToken is BasicToken, ERC23{
330     // Function that is called when a user or another contract wants to transfer funds .
331     function transfer(address to, uint value, bytes data){
332         transferAndPay(to, value, data);
333     }
334 
335     // Standard function transfer similar to ERC20 transfer with no _data .
336     // Added due to backwards compatibility reasons .
337     function transfer(address to, uint value) returns (bool){
338         bytes memory empty;
339         transfer(to, value, empty);
340         return true;
341     }
342 
343     function transferAndPay(address to, uint value, bytes data) payable {
344         // Standard function transfer similar to ERC20 transfer with no _data .
345         // Added due to backwards compatibility reasons .
346         uint codeLength;
347 
348         assembly {
349             // Retrieve the size of the code on target address, this needs assembly .
350             codeLength := extcodesize(to)
351         }
352 
353         balances[msg.sender] = balances[msg.sender].sub(value);
354         balances[to] = balances[to].add(value);
355 
356         if(codeLength>0) {
357             ERC23PayableReceiver receiver = ERC23PayableReceiver(to);
358             receiver.tokenFallback.value(msg.value)(msg.sender, value, data);
359         }else if(msg.value > 0){
360             to.transfer(msg.value);
361         }
362 
363         Transfer(msg.sender, to, value);
364         if(data.length > 0)
365             TransferData(msg.sender, to, value, data);
366     }
367 }/*************************************************************************
368  * import "./include/ERC23PayableToken.sol" : end
369  *************************************************************************/
370 
371 
372 contract TieToken is MintableToken, ERC23PayableToken {
373     string public constant name = "TieToken";
374     string public constant symbol = "TIE";
375     uint public constant decimals = 18;
376 
377     bool public transferEnabled = false;
378 
379     //The cap is 200 mln TIEs
380     uint private constant CAP = 200*(10**6)*(10**decimals);
381 
382     function mint(address _to, uint _amount){
383         require(totalSupply.add(_amount) <= CAP);
384         super.mint(_to, _amount);
385     }
386 
387     function TieToken(address multisigOwner) {
388         //Transfer ownership on the token to multisig on creation
389         transferOwnership(multisigOwner);
390     }
391 
392     /**
393     * Overriding all transfers to check if transfers are enabled
394     */
395     function transferAndPay(address to, uint value, bytes data) payable{
396         require(transferEnabled);
397         super.transferAndPay(to, value, data);
398     }
399 
400     function enableTransfer(bool enabled) onlyOwner{
401         transferEnabled = enabled;
402     }
403 
404 }