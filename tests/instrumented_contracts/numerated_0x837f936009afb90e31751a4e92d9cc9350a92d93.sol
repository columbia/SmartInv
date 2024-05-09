1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0 || b == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization
42  *      control functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the
51      *      sender account.
52      */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) onlyOwner public {
70         require(newOwner != address(0));
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 
77 
78 /**
79  * @title ERC223
80  * @dev ERC223 contract interface with ERC20 functions and events
81  *      Fully backward compatible with ERC20
82  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
83  */
84 contract ERC223 {
85     uint public totalSupply;
86 
87     // ERC223 and ERC20 functions and events
88     function balanceOf(address who) public view returns (uint);
89     function totalSupply() public view returns (uint256 _supply);
90     function transfer(address to, uint value) public returns (bool ok);
91     function transfer(address to, uint value, bytes data) public returns (bool ok);
92     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
93     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
94 
95     // ERC223 functions
96     function name() public view returns (string _name);
97     function symbol() public view returns (string _symbol);
98     function decimals() public view returns (uint8 _decimals);
99 
100     // ERC20 functions and events
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
102     function approve(address _spender, uint256 _value) public returns (bool success);
103     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint _value);
106     event Burn(address indexed from, uint256 amount);
107 }
108 
109 
110 
111 /**
112  * @title ContractReceiver
113  * @dev Contract that is working with ERC223 tokens
114  */
115  contract ContractReceiver {
116 
117     struct TKN {
118         address sender;
119         uint value;
120         bytes data;
121         bytes4 sig;
122     }
123 
124     function tokenFallback(address _from, uint _value, bytes _data) public pure {
125         TKN memory tkn;
126         tkn.sender = _from;
127         tkn.value = _value;
128         tkn.data = _data;
129         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
130         tkn.sig = bytes4(u);
131         
132         /*
133          * tkn variable is analogue of msg variable of Ether transaction
134          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
135          * tkn.value the number of tokens that were sent   (analogue of msg.value)
136          * tkn.data is data of token transaction   (analogue of msg.data)
137          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
138          */
139     }
140 }
141 
142 
143 
144 contract HiroyukiCoinDark is ERC223, Ownable {
145     using SafeMath for uint256;
146 
147     string public name = "HiroyukiCoinDark";
148     string public symbol = "HCD";
149     uint8 public decimals = 18;
150     uint256 public decimalNum = 1e18;
151     uint256 public totalSupply = 10e10 * decimalNum;
152     uint256 public presaleRate = 1e9;
153 
154     mapping(address => uint256) public balanceOf;
155     mapping(address => mapping (address => uint256)) public allowance;
156 
157 
158     /** 
159      * @dev Constructor is called only once and can not be called again
160      */
161     function HiroyukiCoinDark() public {
162         owner = msg.sender;
163         balanceOf[owner] = totalSupply;
164         Transfer(address(0), owner, totalSupply);
165     }
166 
167     function name() public view returns (string _name) {
168         return name;
169     }
170 
171     function symbol() public view returns (string _symbol) {
172         return symbol;
173     }
174 
175     function decimals() public view returns (uint8 _decimals) {
176         return decimals;
177     }
178 
179     function totalSupply() public view returns (uint256 _totalSupply) {
180         return totalSupply;
181     }
182 
183     function balanceOf(address _owner) public view returns (uint256 balance) {
184         return balanceOf[_owner];
185     }
186 
187     /**
188      * @dev Function that is called when a user or another contract wants to transfer funds
189      */
190     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
191         require(_to != address(0) && _value > 0);
192         if (isContract(_to)) {
193             require(balanceOf[msg.sender] >= _value);
194             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
195             balanceOf[_to] = balanceOf[_to].add(_value);
196             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
197             Transfer(msg.sender, _to, _value, _data);
198             Transfer(msg.sender, _to, _value);
199             return true;
200         } else {
201             return transferToAddress(_to, _value, _data);
202         }
203     }
204 
205     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
206         require(_to != address(0) && _value > 0);
207         if (isContract(_to)) {
208             return transferToContract(_to, _value, _data);
209         } else {
210             return transferToAddress(_to, _value, _data);
211         }
212     }
213 
214     /**
215      * @dev Standard function transfer similar to ERC20 transfer with no _data
216      *      Added due to backwards compatibility reasons
217      */
218     function transfer(address _to, uint _value) public returns (bool success) {
219         require(_to != address(0) && _value > 0);
220         bytes memory empty;
221         if (isContract(_to)) {
222             return transferToContract(_to, _value, empty);
223         } else {
224             return transferToAddress(_to, _value, empty);
225         }
226     }
227 
228     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
229     function isContract(address _addr) private view returns (bool is_contract) {
230         uint length;
231         assembly {
232             //retrieve the size of the code on target address, this needs assembly
233             length := extcodesize(_addr)
234         }
235         return (length > 0);
236     }
237 
238     // function that is called when transaction target is an address
239     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
240         require(balanceOf[msg.sender] >= _value);
241         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
242         balanceOf[_to] = balanceOf[_to].add(_value);
243         Transfer(msg.sender, _to, _value, _data);
244         Transfer(msg.sender, _to, _value);
245         return true;
246     }
247 
248     // function that is called when transaction target is a contract
249     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
250         require(balanceOf[msg.sender] >= _value);
251         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
252         balanceOf[_to] = balanceOf[_to].add(_value);
253         ContractReceiver receiver = ContractReceiver(_to);
254         receiver.tokenFallback(msg.sender, _value, _data);
255         Transfer(msg.sender, _to, _value, _data);
256         Transfer(msg.sender, _to, _value);
257         return true;
258     }
259 
260     /**
261      * @dev Transfer tokens from one address to another
262      *      Added due to backwards compatibility with ERC20
263      * @param _from address The address which you want to send tokens from
264      * @param _to address The address which you want to transfer to
265      * @param _value uint256 the amount of tokens to be transferred
266      */
267     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
268         require(_to != address(0) && _value > 0);
269         require(balanceOf[_from] >= _value);
270         require(allowance[_from][msg.sender] >= _value);
271         balanceOf[_from] = balanceOf[_from].sub(_value);
272         balanceOf[_to] = balanceOf[_to].add(_value);
273         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
274         Transfer(_from, _to, _value);
275         return true;
276     }
277 
278     /**
279      * @dev Allows _spender to spend no more than _value tokens in your behalf
280      *      Added due to backwards compatibility with ERC20
281      * @param _spender The address authorized to spend
282      * @param _value the max amount they can spend
283      */
284     function approve(address _spender, uint256 _value) public returns (bool success) {
285         allowance[msg.sender][_spender] = _value;
286         Approval(msg.sender, _spender, _value);
287         return true;
288     }
289 
290     /**
291      * @dev Function to check the amount of tokens that an owner allowed to a spender
292      *      Added due to backwards compatibility with ERC20
293      * @param _owner address The address which owns the funds
294      * @param _spender address The address which will spend the funds
295      */
296     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
297         return allowance[_owner][_spender];
298     }
299 
300     /**
301      * @dev Burns a specific amount of tokens.
302      * @param _unitAmount The amount of token to be burned.
303      */
304     function burn(uint256 _unitAmount) onlyOwner public {
305         require(_unitAmount > 0);
306         _unitAmount = _unitAmount.mul(decimalNum);
307         require(balanceOf[msg.sender] >= _unitAmount);
308         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_unitAmount);
309         totalSupply = totalSupply.sub(_unitAmount);
310         Burn(msg.sender, _unitAmount);
311     }
312 
313     /**
314      * @dev Function to distribute tokens to the list of addresses by the provided amount
315      */
316     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
317         require(amount > 0 && addresses.length > 0);
318         amount = amount.mul(decimalNum);
319         uint256 totalAmount = amount.mul(addresses.length);
320         require(balanceOf[msg.sender] >= totalAmount);
321         for (uint j = 0; j < addresses.length; j++) {
322             require(addresses[j] != 0x0);
323             Transfer(msg.sender, addresses[j], amount);
324             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
325         }
326         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
327         return true;
328     }
329 
330     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
331         require(addresses.length > 0);
332         require(addresses.length == amounts.length);
333         uint256 totalAmount = 0;
334         for(uint j = 0; j < addresses.length; j++){
335             require(amounts[j] > 0 && addresses[j] != 0x0);
336             amounts[j] = amounts[j].mul(decimalNum);
337             totalAmount = totalAmount.add(amounts[j]);
338         }
339         require(balanceOf[msg.sender] >= totalAmount);
340         for (j = 0; j < addresses.length; j++) {
341             require(addresses[j] != 0x0);
342             Transfer(msg.sender, addresses[j], amounts[j]);
343             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
344         }
345         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
346         return true;
347     }
348 
349     function setPresaleRate(uint256 _unitAmount) onlyOwner public {
350         presaleRate = _unitAmount;
351     }
352 
353     /**
354      * @dev fallback function
355      */
356     function() payable public {
357         require(msg.value > 0);
358         require(presaleRate > 0);
359         address _to = msg.sender;
360         uint256 numTokens = SafeMath.mul(msg.value, presaleRate);
361         require(numTokens > 0);
362         require(balanceOf[owner] >= numTokens);
363         balanceOf[_to] = balanceOf[_to].add(numTokens);
364         balanceOf[owner] = balanceOf[owner].sub(numTokens);
365         Transfer(owner, _to, numTokens);
366         owner.transfer(msg.value);
367     }
368 
369 }