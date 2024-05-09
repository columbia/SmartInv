1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC223
6  * @dev Interface for ERC223
7  */
8 interface ERC223 {
9 
10     // functions
11     function balanceOf(address _owner) external constant returns (uint256);
12     function transfer(address _to, uint256 _value) external returns (bool success);
13     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
15     function approve(address _spender, uint256 _value) external returns (bool success);
16     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
17 
18 
19 
20     // Getters
21     function name() external constant returns  (string _name);
22     function symbol() external constant returns  (string _symbol);
23     function decimals() external constant returns (uint8 _decimals);
24     function totalSupply() external constant returns (uint256 _totalSupply);
25 
26 
27     // Events
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
30     event Approval(address indexed _owner, address indexed _spender, uint _value);
31     event Burn(address indexed burner, uint256 value);
32 }
33 
34 
35 /**
36  * @notice A contract will throw tokens if it does not inherit this
37  * @title ERC223ReceivingContract
38  * @dev Contract for ERC223 token fallback
39  */
40 contract ERC223ReceivingContract {
41 
42     TKN internal fallback;
43 
44     struct TKN {
45         address sender;
46         uint value;
47         bytes data;
48         bytes4 sig;
49     }
50 
51     function tokenFallback(address _from, uint256 _value, bytes _data) external pure {
52         TKN memory tkn;
53         tkn.sender = _from;
54         tkn.value = _value;
55         tkn.data = _data;
56         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
57         tkn.sig = bytes4(u);
58 
59         /*
60          * tkn variable is analogue of msg variable of Ether transaction
61          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
62          * tkn.value the number of tokens that were sent   (analogue of msg.value)
63          * tkn.data is data of token transaction   (analogue of msg.data)
64          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
65          */
66 
67 
68     }
69 }
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78     /**
79      * @dev Multiplies two numbers, throws on overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         c = a * b;
90         assert(c / a == b);
91         return c;
92     }
93 
94     /**
95      * @dev Integer division of two numbers, truncating the quotient.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         // assert(b > 0); // Solidity automatically throws when dividing by 0
99         // uint256 c = a / b;
100         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101         return a / b;
102     }
103 
104     /**
105      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         assert(b <= a);
109         return a - b;
110     }
111 
112     /**
113      * @dev Adds two numbers, throws on overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
116         c = a + b;
117         assert(c >= a);
118         return c;
119     }
120     
121 }
122 
123 
124 /**
125  * @title Ownable
126  * @dev The Ownable contract has an owner address, and provides basic authorization control
127  * functions, this simplifies the implementation of "user permissions".
128  */
129 contract Ownable {
130     address public owner;
131 
132 
133     event OwnershipTransferred(
134       address indexed previousOwner,
135       address indexed newOwner
136     );
137 
138 
139     /**
140      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
141      * account.
142      */
143     constructor() public {
144         owner = msg.sender;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(msg.sender == owner);
152         _;
153     }
154 
155 
156     /**
157      * @dev Allows the current owner to transfer control of the contract to a newOwner.
158      * @param _newOwner The address to transfer ownership to.
159      */
160     function transferOwnership(address _newOwner) public onlyOwner {
161         _transferOwnership(_newOwner);
162     }
163 
164     /**
165      * @dev Transfers control of the contract to a newOwner.
166      * @param _newOwner The address to transfer ownership to.
167      */
168     function _transferOwnership(address _newOwner) internal {
169         require(_newOwner != address(0));
170         emit OwnershipTransferred(owner, _newOwner);
171         owner = _newOwner;
172     }
173 }
174 
175 
176 
177 /**
178  * @title C3Coin
179  * @dev C3Coin is an ERC223 Token with ERC20 functions and events
180  *      Fully backward compatible with ERC20
181  */
182 contract C3Coin is ERC223, Ownable {
183     using SafeMath for uint;
184 
185 
186     string public name = "C3coin";
187     string public symbol = "CCC";
188     uint8 public decimals = 18;
189     uint256 public totalSupply = 10e10 * 1e18;
190 
191 
192     constructor() public {
193         balances[msg.sender] = totalSupply; 
194     }
195 
196 
197     mapping (address => uint256) public balances;
198 
199     mapping(address => mapping (address => uint256)) public allowance;
200 
201 
202     /**
203      * @dev Getters
204      */
205     // Function to access name of token .
206     function name() external constant returns (string _name) {
207         return name;
208     }
209     // Function to access symbol of token .
210     function symbol() external constant returns (string _symbol) {
211         return symbol;
212     }
213     // Function to access decimals of token .
214     function decimals() external constant returns (uint8 _decimals) {
215         return decimals;
216     }
217     // Function to access total supply of tokens .
218     function totalSupply() external constant returns (uint256 _totalSupply) {
219         return totalSupply;
220     }
221 
222 
223     /**
224      * @dev Get balance of a token owner
225      * @param _owner The address which one owns tokens
226      */
227     function balanceOf(address _owner) external constant returns (uint256 balance) {
228         return balances[_owner];
229     }
230 
231 
232     /**
233      * @notice This function is modified for erc223 standard
234      * @dev ERC20 transfer function added for backward compatibility.
235      * @param _to Address of token receiver
236      * @param _value Number of tokens to send
237      */
238     function transfer(address _to, uint _value) public returns (bool success) {
239         bytes memory empty = hex"00000000";
240         if (isContract(_to)) {
241             return transferToContract(_to, _value, empty);
242         } else {
243             return transferToAddress(_to, _value, empty);
244         }
245     }
246 
247 
248     /**
249      * @dev ERC223 transfer function
250      * @param _to Address of token receiver
251      * @param _value Number of tokens to send
252      * @param _data Data equivalent to tx.data from ethereum transaction
253      */
254     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
255 
256         if (isContract(_to)) {
257             return transferToContract(_to, _value, _data);
258         } else {
259             return transferToAddress(_to, _value, _data);
260         }
261     }
262 
263 
264     function isContract(address _addr) private view returns (bool is_contract) {
265         uint length;
266         assembly {
267             //retrieve the size of the code on target address, this needs assembly
268             length := extcodesize(_addr)
269         }
270         return (length > 0);
271     }
272 
273 
274     // function which is called when transaction target is an address
275     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
276         require(balances[msg.sender] >= _value);
277         balances[msg.sender] = balances[msg.sender].sub(_value);
278         balances[_to] = balances[_to].add(_value);
279         emit ERC223Transfer(msg.sender, _to, _value, _data);
280         emit Transfer(msg.sender, _to, _value);
281         return true;
282     }
283 
284 
285     // function which is called when transaction target is a contract
286     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
287         require(balances[msg.sender] >= _value);
288         balances[msg.sender] = balances[msg.sender].sub(_value);
289         balances[_to] = balances[_to].add(_value);
290         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
291         receiver.tokenFallback(msg.sender, _value, _data);
292         emit ERC223Transfer(msg.sender, _to, _value, _data);
293         emit Transfer(msg.sender, _to, _value);
294         return true;
295     }
296 
297 
298     /**
299      * @dev Transfer tokens from one address to another
300      *      Added due to backwards compatibility with ERC20
301      * @param _from address The address which you want to send tokens from
302      * @param _to address The address which you want to transfer to
303      * @param _value uint256 The amount of tokens to be transferred
304      */
305     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
306 
307         balances[_from] = balances[_from].sub(_value);
308         balances[_to] = balances[_to].add(_value);
309         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
310         emit Transfer(_from, _to, _value);
311         return true;
312     }
313 
314 
315     /**
316      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
317      * Beware that changing an allowance with this method brings the risk that someone may use both the old
318      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
319      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
320      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321      * @param _spender The address which will spend the funds.
322      * @param _value The amount of tokens to be spent.
323      */
324     function approve(address _spender, uint256 _value) external returns (bool success) {
325         allowance[msg.sender][_spender] = 0; // mitigate the race condition
326         allowance[msg.sender][_spender] = _value;
327         emit Approval(msg.sender, _spender, _value);
328         return true;
329     }
330 
331 
332     /**
333      * @dev Function to check the amount of tokens that an owner allowed to a spender.
334      * @param _owner Address The address which owns the funds.
335      * @param _spender Address The address which will spend the funds.
336      * @return A uint256 specifying the amount of tokens still available for the spender.
337      */
338     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
339         return allowance[_owner][_spender];
340     }
341 
342 
343     /**
344      * @dev Function to distribute tokens to the list of addresses by the provided uniform amount
345      * @param _addresses List of addresses
346      * @param _amount Uniform amount of tokens
347      */
348     function multiTransfer(address[] _addresses, uint256 _amount) public returns (bool) {
349 
350         uint256 totalAmount = _amount.mul(_addresses.length);
351         require(balances[msg.sender] >= totalAmount);
352 
353         for (uint j = 0; j < _addresses.length; j++) {
354             balances[msg.sender] = balances[msg.sender].sub(_amount);
355             balances[_addresses[j]] = balances[_addresses[j]].add(_amount);
356             emit Transfer(msg.sender, _addresses[j], _amount);
357         }
358         return true;
359     }
360 
361 
362     /**
363      * @dev Function to distribute tokens to the list of addresses by the provided various amount
364      * @param _addresses List of addresses
365      * @param _amounts List of token amounts
366      */
367     function multiTransfer(address[] _addresses, uint256[] _amounts) public returns (bool) {
368 
369         uint256 totalAmount = 0;
370 
371         for(uint j = 0; j < _addresses.length; j++){
372 
373             totalAmount = totalAmount.add(_amounts[j]);
374         }
375         require(balances[msg.sender] >= totalAmount);
376 
377         for (j = 0; j < _addresses.length; j++) {
378             balances[msg.sender] = balances[msg.sender].sub(_amounts[j]);
379             balances[_addresses[j]] = balances[_addresses[j]].add(_amounts[j]);
380             emit Transfer(msg.sender, _addresses[j], _amounts[j]);
381         }
382         return true;
383     }
384 
385 
386     /**
387      * @dev Burns a specific amount of tokens.
388      * @param _value The amount of token to be burned.
389      */
390     function burn(uint256 _value) onlyOwner public {
391         _burn(msg.sender, _value);
392     }
393 
394     function _burn(address _owner, uint256 _value) internal {
395         require(_value <= balances[_owner]);
396         // no need to require value <= totalSupply, since that would imply the
397         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
398 
399         balances[_owner] = balances[_owner].sub(_value);
400         totalSupply = totalSupply.sub(_value);
401         emit Burn(_owner, _value);
402         emit Transfer(_owner, address(0), _value);
403     }
404 
405     /**
406      * @dev Default payable function executed after receiving ether
407      */
408     function () public payable {
409         // does not accept ether
410     }
411 }