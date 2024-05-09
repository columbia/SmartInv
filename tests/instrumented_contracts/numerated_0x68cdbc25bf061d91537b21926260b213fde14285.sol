1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18         return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61     address public owner;
62 
63 
64     event OwnershipRenounced(address indexed previousOwner);
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70 
71     /**
72     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73     * account.
74     */
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     /**
80     * @dev Throws if called by any account other than the owner.
81     */
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     /**
88     * @dev Allows the current owner to relinquish control of the contract.
89     * @notice Renouncing to ownership will leave the contract without an owner.
90     * It will not be possible to call the functions with the `onlyOwner`
91     * modifier anymore.
92     */
93     function renounceOwnership() public onlyOwner {
94         emit OwnershipRenounced(owner);
95         owner = address(0);
96     }
97 
98     /**
99     * @dev Allows the current owner to transfer control of the contract to a newOwner.
100     * @param _newOwner The address to transfer ownership to.
101     */
102     function transferOwnership(address _newOwner) public onlyOwner {
103         _transferOwnership(_newOwner);
104     }
105 
106     /**
107     * @dev Transfers control of the contract to a newOwner.
108     * @param _newOwner The address to transfer ownership to.
109     */
110     function _transferOwnership(address _newOwner) internal {
111         require(_newOwner != address(0));
112         emit OwnershipTransferred(owner, _newOwner);
113         owner = _newOwner;
114     }
115 }
116 
117 
118 
119 /**
120  * @title ERC223
121  * @dev ERC223 contract interface with ERC20 functions and events
122  *      Fully backward compatible with ERC20
123  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
124  */
125 contract ERC223 {
126     uint public totalSupply;
127 
128     // ERC223 and ERC20 functions and events
129     function transfer(address to, uint value) public returns (bool ok);
130     function transfer(address to, uint value, bytes data) public returns (bool ok);
131     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
132 
133     // ERC20 functions and events
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
135     function approve(address _spender, uint256 _value) public returns (bool success);
136     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
137     event Transfer(address indexed _from, address indexed _to, uint256 _value);
138     event Approval(address indexed _owner, address indexed _spender, uint _value);
139 }
140 
141 
142 /**
143  * @title ContractReceiver
144  * @dev Contract that is working with ERC223 tokens
145  */
146  contract ContractReceiver {
147 
148     struct TKN {
149         address sender;
150         uint value;
151         bytes data;
152         bytes4 sig;
153     }
154 
155     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
156         TKN memory tkn;
157         tkn.sender = _from;
158         tkn.value = _value;
159         tkn.data = _data;
160         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
161         tkn.sig = bytes4(u);
162 
163         /*
164          * tkn variable is analogue of msg variable of Ether transaction
165          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
166          * tkn.value the number of tokens that were sent   (analogue of msg.value)
167          * tkn.data is data of token transaction   (analogue of msg.data)
168          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
169          */
170     }
171 }
172 
173 
174 /**
175  * @title Ecoprotech
176  * @dev Ecoprotech is an ERC223 Token with ERC20 functions and events
177  *      Fully backward compatible with ERC20
178  */
179 contract Ecoprotech is ERC223, Ownable {
180     using SafeMath for uint256;
181 
182     string public constant name = "EXEES_TBD";
183     string public constant symbol = "EXE_TBD";
184     uint8 public constant decimals = 8;
185     uint256 public constant totalSupply = 2000000000000 * 10 ** 8;
186     bool public locked = true;
187     address public marketor;
188 
189     mapping(address => uint256) public balanceOf;
190     mapping(address => mapping (address => uint256)) public allowance;
191     mapping(address => bool) public lockAccount;
192 
193     event ToggleLocked(bool _locked);
194     event LockedAccount(address indexed _to);
195 
196     /**
197      * @dev Constructor is called only once and can not be called again
198      */
199     constructor(address _owner, address _marketor1, address _marketor2) public {
200 
201         marketor = _marketor1;                                     
202         address tokenSale = 0xbc9019f01acf8e508157ced0744168bf63e2ca50;              
203         address organization = 0x6400e8f9f71d3b4d886098b19520f40502c5bbb6;           
204         address advisor = 0x62148bd0cf4d44fa045130aa39c2fcd6e7b70a20;                
205         address developer = 0xed45f100028964156800e2a24116196cd767d78b;              
206         address team = 0x2ca0da7ae78179600d476f0de59b8d22fd865bdf;                   
207         address seedInvestors = 0x13596d3bf16852b07696e535cad877d0665a6756;          
208 
209         initialize(tokenSale, 45);
210         initialize(_marketor1, 15);
211         initialize(_marketor2, 10);
212         initialize(organization, 8);
213         initialize(advisor, 7);
214         initialize(developer, 6);
215         initialize(team, 6);
216         initialize(seedInvestors, 3);
217 
218         owner = _owner;
219    }
220 
221     /**
222      * @dev allocate token to _address based on _ratio
223      * @param _address Address to initialize
224      * @param _ratio Ratio that is used to set the amount of token to _address
225      */
226     function initialize(address _address, uint256 _ratio) private {
227         uint256 tmpBalance = totalSupply.mul(_ratio).div(100);
228         balanceOf[_address] = tmpBalance;
229         emit Transfer(0x0, _address, tmpBalance);
230     }
231 
232     // Check whether msg.sender can transfer token or not
233     modifier validTransfer() {
234         if (locked && lockAccount[msg.sender])
235             revert();
236         _;
237     }
238 
239     /**
240      * @dev Toggle locked flag
241      */
242     function toggleLocked() public onlyOwner {
243         locked = !locked;
244         emit ToggleLocked(locked);
245     }
246 
247     /**
248      * @dev set lock flag to address on the specific condition
249      * @param _from Address who transfer tokens
250      * @param _to Address who receive tokens
251      */
252     function setLockToAccount(address _from, address _to) private {
253         if (_from == marketor) {
254             lockAccount[_to] = true;
255             emit LockedAccount(_to);
256         }
257     }
258 
259     /**
260      * @dev Standard function transfer based on ERC223
261      */
262     function transfer(address _to, uint _value, bytes _data) public validTransfer returns (bool success) {
263         require(_value > 0 && _to != address(0));
264 
265         setLockToAccount(msg.sender, _to);
266 
267         if (isContract(_to)) {
268             return transferToContract(_to, _value, _data);
269         } else {
270             return transferToAddress(_to, _value, _data);
271         }
272     }
273 
274     /**
275      * @dev Standard function transfer similar to ERC20 transfer with no _data
276      *      Added due to backwards compatibility reasons
277      */
278     function transfer(address _to, uint _value) public validTransfer returns (bool success) {
279         require(_value > 0 && _to != address(0));
280 
281         setLockToAccount(msg.sender, _to);
282 
283         bytes memory empty;
284         if (isContract(_to)) {
285             return transferToContract(_to, _value, empty);
286         } else {
287             return transferToAddress(_to, _value, empty);
288         }
289     }
290 
291     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
292     function isContract(address _addr) private view returns (bool is_contract) {
293         uint length;
294         assembly {
295             //retrieve the size of the code on target address, this needs assembly
296             length := extcodesize(_addr)
297         }
298         return (length > 0);
299     }
300 
301     // function that is called when transaction target is an address
302     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
303         require(balanceOf[msg.sender] >= _value);
304         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
305         balanceOf[_to] = balanceOf[_to].add(_value);
306         emit Transfer(msg.sender, _to, _value, _data);
307         emit Transfer(msg.sender, _to, _value);
308         return true;
309     }
310 
311     // function that is called when transaction target is a contract
312     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
313         require(balanceOf[msg.sender] >= _value);
314         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
315         balanceOf[_to] = balanceOf[_to].add(_value);
316         ContractReceiver receiver = ContractReceiver(_to);
317         receiver.tokenFallback(msg.sender, _value, _data);
318         emit Transfer(msg.sender, _to, _value, _data);
319         emit Transfer(msg.sender, _to, _value);
320         return true;
321     }
322 
323     /**
324      * @dev Transfer tokens from one address to another
325      *      Added due to backwards compatibility with ERC20
326      * @param _from address The address which you want to send tokens from
327      * @param _to address The address which you want to transfer to
328      * @param _value uint256 the amount of tokens to be transferred
329      */
330     function transferFrom(address _from, address _to, uint256 _value) public validTransfer returns (bool success) {
331         require(_to != address(0)
332                 && _value > 0
333                 && balanceOf[_from] >= _value
334                 && allowance[_from][msg.sender] >= _value);
335 
336         setLockToAccount(msg.sender, _to);
337 
338         balanceOf[_from] = balanceOf[_from].sub(_value);
339         balanceOf[_to] = balanceOf[_to].add(_value);
340         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
341         emit Transfer(_from, _to, _value);
342         return true;
343     }
344 
345     /**
346      * @dev Allows _spender to spend no more than _value tokens in your behalf
347      *      Added due to backwards compatibility with ERC20
348      * @param _spender The address authorized to spend
349      * @param _value the max amount they can spend
350      */
351     function approve(address _spender, uint256 _value) public returns (bool success) {
352         allowance[msg.sender][_spender] = _value;
353         emit Approval(msg.sender, _spender, _value);
354         return true;
355     }
356 
357     /**
358      * @dev Function to check the amount of tokens that an owner allowed to a spender
359      *      Added due to backwards compatibility with ERC20
360      * @param _owner address The address which owns the funds
361      * @param _spender address The address which will spend the funds
362      */
363     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
364         return allowance[_owner][_spender];
365     }
366 }