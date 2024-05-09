1 pragma solidity ^0.4.24;
2 
3 // File: contracts/GanaEightCoinToken.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19         return 0;
20         }
21 
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
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
117 /**
118  * @title ERC223
119  * @dev ERC223 contract interface with ERC20 functions and events
120  *      Fully backward compatible with ERC20
121  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
122  */
123 contract ERC223 {
124     uint public totalSupply;
125 
126     // ERC223 and ERC20 functions and events
127     function transfer(address to, uint value) public returns (bool ok);
128     function transfer(address to, uint value, bytes data) public returns (bool ok);
129     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
130 
131     // ERC20 functions and events
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
133     function approve(address _spender, uint256 _value) public returns (bool success);
134     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
135     event Transfer(address indexed _from, address indexed _to, uint256 _value);
136     event Approval(address indexed _owner, address indexed _spender, uint _value);
137 }
138 
139 
140 /**
141  * @title ContractReceiver
142  * @dev Contract that is working with ERC223 tokens
143  */
144  contract ContractReceiver {
145 
146     struct TKN {
147         address sender;
148         uint value;
149         bytes data;
150         bytes4 sig;
151     }
152 
153     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
154         TKN memory tkn;
155         tkn.sender = _from;
156         tkn.value = _value;
157         tkn.data = _data;
158         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
159         tkn.sig = bytes4(u);
160 
161         /*
162          * tkn variable is analogue of msg variable of Ether transaction
163          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
164          * tkn.value the number of tokens that were sent   (analogue of msg.value)
165          * tkn.data is data of token transaction   (analogue of msg.data)
166          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
167          */
168     }
169 }
170 
171 
172 /**
173  * @title GanaEightCoinToken
174  * @dev GanaEightCoinToken is an ERC223 Token with ERC20 functions and events
175  *      Fully backward compatible with ERC20
176  */
177 contract GanaEightCoinToken is ERC223, Ownable {
178     using SafeMath for uint256;
179 
180     string public constant name = "G8C";
181     string public constant symbol = "GAEC";
182     uint8 public constant decimals = 8;
183     uint256 public totalSupply = 7000000000000 * 10 ** 8;
184 
185     bool public mintingFinished = false;
186     
187     mapping(address => uint256) public balanceOf;
188     mapping(address => mapping (address => uint256)) public allowance;
189         
190     // This token is locked on the initial condition
191     // This is the mapping of unlocked whiteList
192     mapping( address => bool ) public whiteList;
193 
194     event Mint(address indexed to, uint256 amount);
195     event WhiteList(address indexed to, bool lock);
196     event MintFinished();
197 
198     // This is a modifier whether transfering token is available or not
199     modifier isValidTransfer() {
200         require(whiteList[msg.sender]);
201         _;
202     }
203 
204     modifier canMint() {
205         require(!mintingFinished);
206         _;
207     }
208 
209     /**
210     * @dev constructor
211     */
212     constructor(address _owner) public {
213 
214         // set the owner address
215         owner = _owner;
216 
217         // the tokens of 60% of the totalSupply is set to the sale address
218         address sale = 0x0301e60b967A088aAd7b6a0Dd3745608068c2574;
219         balanceOf[sale] = totalSupply.mul(60).div(100);
220         emit Transfer(0x0, sale, balanceOf[sale]);
221 
222         // the tokens of 15% of the totalSupply is set to the team address
223         address team = 0x2EeF18D08B3278f7d9C76Ffb50C279490f54c6B3;
224         balanceOf[team] = totalSupply.mul(15).div(100);
225         emit Transfer(0x0, team, balanceOf[team]);
226 
227         // the tokens of 12% of the totalSupply is set to the marketor address
228         address marketor = 0x76FA8c2952CcA46f874a598A6064C699C634CdAA;
229         balanceOf[marketor] = totalSupply.mul(12).div(100);
230         emit Transfer(0x0, marketor, balanceOf[marketor]);
231         
232         // the tokens of 10% of the totalSupply is set to the advisor address
233         address advisor = 0xCCbc32321baeBa72f35590B084D38adC77e74123;
234         balanceOf[advisor] = totalSupply.mul(10).div(100);
235         emit Transfer(0x0, advisor, balanceOf[advisor]);
236 
237         // the tokens of 3% of the totalSupply is set to the developer address
238         address developer = 0x80459F7e1139d4cc97673131f2986000C024248e;
239         balanceOf[developer] = totalSupply.mul(3).div(100);
240         emit Transfer(0x0, developer, balanceOf[developer]);
241     }
242 
243     /**
244     * @dev Owner can unlock the feature to transfer token
245     */
246     function setUnLocked(address _to, bool _unLocked) onlyOwner public {
247         whiteList[_to] = _unLocked;
248         WhiteList(_to, _unLocked);
249     }
250 
251    /**
252      * @dev Standard function transfer based on ERC223
253      */
254     function transfer(address _to, uint _value, bytes _data) public isValidTransfer returns (bool success) {
255         require(_value > 0 && _to != address(0));
256 
257         if (isContract(_to)) {
258             return transferToContract(_to, _value, _data);
259         } else {
260             return transferToAddress(_to, _value, _data);
261         }
262     }
263 
264     /**
265      * @dev Standard function transfer similar to ERC20 transfer with no _data
266      *      Added due to backwards compatibility reasons
267      */
268     function transfer(address _to, uint _value) public isValidTransfer returns (bool success) {
269         require(_value > 0 && _to != address(0));
270 
271         bytes memory empty;
272         if (isContract(_to)) {
273             return transferToContract(_to, _value, empty);
274         } else {
275             return transferToAddress(_to, _value, empty);
276         }
277     }
278 
279     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
280     function isContract(address _addr) private view returns (bool is_contract) {
281         uint length;
282         assembly {
283             //retrieve the size of the code on target address, this needs assembly
284             length := extcodesize(_addr)
285         }
286         return (length > 0);
287     }
288 
289     // function that is called when transaction target is an address
290     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
291         require(balanceOf[msg.sender] >= _value);
292         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
293         balanceOf[_to] = balanceOf[_to].add(_value);
294         emit Transfer(msg.sender, _to, _value, _data);
295         emit Transfer(msg.sender, _to, _value);
296         return true;
297     }
298 
299     // function that is called when transaction target is a contract
300     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
301         require(balanceOf[msg.sender] >= _value);
302         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
303         balanceOf[_to] = balanceOf[_to].add(_value);
304         ContractReceiver receiver = ContractReceiver(_to);
305         receiver.tokenFallback(msg.sender, _value, _data);
306         emit Transfer(msg.sender, _to, _value, _data);
307         emit Transfer(msg.sender, _to, _value);
308         return true;
309     }
310     
311     /**
312      * @dev Transfer tokens from one address to another
313      *      Added due to backwards compatibility with ERC20
314      * @param _from address The address which you want to send tokens from
315      * @param _to address The address which you want to transfer to
316      * @param _value uint256 the amount of tokens to be transferred
317      */
318     function transferFrom(address _from, address _to, uint256 _value) public isValidTransfer returns (bool success) {
319         require(_to != address(0)
320                 && _value > 0
321                 && balanceOf[_from] >= _value
322                 && allowance[_from][msg.sender] >= _value);
323 
324         balanceOf[_from] = balanceOf[_from].sub(_value);
325         balanceOf[_to] = balanceOf[_to].add(_value);
326         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
327         emit Transfer(_from, _to, _value);
328         return true;
329     }
330 
331     /**
332      * @dev Allows _spender to spend no more than _value tokens in your behalf
333      *      Added due to backwards compatibility with ERC20
334      * @param _spender The address authorized to spend
335      * @param _value the max amount they can spend
336      */
337     function approve(address _spender, uint256 _value) public returns (bool success) {
338         allowance[msg.sender][_spender] = _value;
339         emit Approval(msg.sender, _spender, _value);
340         return true;
341     }
342 
343     /**
344      * @dev Function to check the amount of tokens that an owner allowed to a spender
345      *      Added due to backwards compatibility with ERC20
346      * @param _owner address The address which owns the funds
347      * @param _spender address The address which will spend the funds
348      */
349     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
350         return allowance[_owner][_spender];
351     }
352 
353     /**
354      * @dev Function to mint tokens
355      * @param _to The address that will receive the minted tokens.
356      * @param _unitAmount The amount of tokens to mint.
357      */
358     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
359         require(_unitAmount > 0);
360 
361         totalSupply = totalSupply.add(_unitAmount);
362         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
363         emit Mint(_to, _unitAmount);
364         emit Transfer(address(0), _to, _unitAmount);
365         return true;
366     }
367 
368     /**
369      * @dev Function to stop minting new tokens.
370      */
371     function finishMinting() onlyOwner canMint public returns (bool) {
372         mintingFinished = true;
373         emit MintFinished();
374         return true;
375     }
376 }