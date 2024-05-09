1 pragma solidity ^0.4.18;
2 
3 // File: contracts/SafeMath.sol
4 
5 /*
6 
7     Copyright 2018, All rights reserved.
8      _      _
9     \ \    / / ___   ___  _ __
10      \ \  / / / _ \ / _ \| '_ \
11       \ \/ / |  __/|  __/| | | |
12        \__/   \___| \___||_| |_|
13 
14     @title SafeMath
15     @author OpenZeppelin
16     @dev Math operations with safety checks that throw on error
17 
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 // File: contracts/Ownable.sol
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 
69 contract Ownable {
70   address public owner;
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72   using SafeMath for uint256;
73   uint256 public startdate;
74 
75   function Ownable() public {
76 
77     owner = msg.sender;
78     startdate = now;
79   }
80 
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 
93 }
94 
95 // File: contracts/Pausable.sol
96 
97 /**
98  * @title Pausable
99  * @dev Base contract which allows children to implement an emergency stop mechanism.
100  */
101 contract Pausable is Ownable {
102   event Pause();
103   event Unpause();
104   mapping(address => uint256) private _lock_list_period;
105   mapping(address => bool) private _lock_list;
106   bool public paused = false;
107   mapping(address => uint256) internal _balances;
108   uint256 internal _tokenSupply;
109 
110   /**
111    * @dev Modifier to make a function callable only when the contract is not paused.
112    */
113   modifier whenNotPaused() {
114     require(!paused);
115     _;
116   }
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is paused.
120    */
121   modifier whenPaused() {
122     require(paused);
123     _;
124   }
125   /**
126    *
127    */
128 
129 
130 
131   modifier isLockAddress() {
132     check_lock_period(msg.sender);
133     if(_lock_list[msg.sender]){
134         revert();
135     }
136 
137     _;
138 
139   }
140 
141   function check_lock_period(address check_address) {
142       if(now > _lock_list_period[check_address] && _lock_list[check_address]){
143         _lock_list[check_address] = false;
144         _tokenSupply = _tokenSupply.add(_balances[check_address]);
145       }
146 
147   }
148 
149   function check_period(address check_address) constant public returns(uint256){
150       return _lock_list_period[check_address];
151 
152   }
153 
154   function check_lock(address check_address) constant public returns(bool){
155 
156       return _lock_list[check_address];
157 
158   }
159   /**
160    *
161    */
162   function set_lock_list(address lock_address, uint period) onlyOwner external {
163       _lock_list_period[lock_address] = startdate + (period * 1 minutes);
164       _lock_list[lock_address]  = true;
165       _tokenSupply = _tokenSupply.sub(_balances[lock_address]);
166   }
167 
168   /**
169    * @dev called by the owner to pause, triggers stopped state
170    */
171   function pause() onlyOwner whenNotPaused public {
172     paused = true;
173     Pause();
174   }
175   /**
176    * @dev called by the owner to unpause, returns to normal state
177    */
178   function unpause() onlyOwner whenPaused public {
179     paused = false;
180     Unpause();
181   }
182 }
183 
184 // File: contracts/ERC20Token.sol
185 
186 /*
187 
188     Copyright 2018, All rights reserved.
189      _      _
190     \ \    / / ___   ___  _ __
191      \ \  / / / _ \ / _ \| '_ \
192       \ \/ / |  __/|  __/| | | |
193        \__/   \___| \___||_| |_|
194 
195     @title Veen Token Contract.
196     @description ERC-20 Interface
197 
198 */
199 
200 interface ERC20Token {
201 
202     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
203     function approve(address spender, uint tokens) public returns (bool success);
204     function transferFrom(address from, address to, uint tokens) public returns (bool success);
205 
206     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
207 }
208 
209 // File: contracts/ERC223.sol
210 
211 interface ERC223 {
212 
213     function totalSupply() public constant returns (uint);
214     function balanceOf(address who) public constant returns (uint);
215     function transfer(address to, uint value) public returns (bool);
216 
217 }
218 
219 // File: contracts/Receiver_Interface.sol
220 
221 /*
222  * Contract that is working with ERC223 tokens
223  */
224 
225  contract ContractReceiver {
226 
227     struct TKN {
228         address sender;
229         uint value;
230         bytes data;
231         bytes4 sig;
232     }
233 
234 
235     function tokenFallback(address _from, uint _value, bytes _data) public pure {
236       TKN memory tkn;
237       tkn.sender = _from;
238       tkn.value = _value;
239       tkn.data = _data;
240       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
241       tkn.sig = bytes4(u);
242 
243       /* tkn variable is analogue of msg variable of Ether transaction
244       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
245       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
246       *  tkn.data is data of token transaction   (analogue of msg.data)
247       *  tkn.sig is 4 bytes signature of function
248       *  if data of token transaction is a function execution
249       */
250     }
251 }
252 
253 // File: contracts/Veen.sol
254 
255 /*
256     Copyright 2018, All rights reserved.
257      _      _
258     \ \    / / ___   ___  _ __
259      \ \  / / / _ \ / _ \| '_ \
260       \ \/ / |  __/|  __/| | | |
261        \__/   \___| \___||_| |_|
262 
263     @title Veen Token Contract.
264     @description Veen token is a ERC20-compliant token.
265 
266 */
267 
268 contract Veen is ERC20Token, Pausable, ERC223{
269 
270     using SafeMath for uint;
271 
272     string public constant name = "Veen";
273     string public constant symbol = "VEEN";
274     uint8 public constant decimals = 18;
275 
276     uint private _totalSupply;
277 
278     mapping(address => mapping(address => uint256)) private _allowed;
279     event MintedLog(address to, uint256 amount);
280     event Transfer(address indexed from, address indexed to, uint value);
281 
282 
283     function Veen() public {
284         _tokenSupply = 0;
285         _totalSupply = 15000000000 * (uint256(10) ** decimals);
286 
287     }
288 
289     function totalSupply() public constant returns (uint256) {
290         return _tokenSupply;
291     }
292 
293     function mint(address to, uint256 amount) onlyOwner public returns (bool){
294 
295         amount = amount * (uint256(10) ** decimals);
296         if(_totalSupply + 1 > (_tokenSupply+amount)){
297             _tokenSupply = _tokenSupply.add(amount);
298             _balances[to]= _balances[to].add(amount);
299             emit MintedLog(to, amount);
300             return true;
301         }
302 
303         return false;
304     }
305 
306     function dist_list_set(address[] dist_list, uint256[] token_list) onlyOwner external{
307 
308         for(uint i=0; i < dist_list.length ;i++){
309             transfer(dist_list[i],token_list[i]);
310         }
311 
312     }
313     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
314         return _balances[tokenOwner];
315     }
316 
317     function transfer(address to, uint tokens) whenNotPaused isLockAddress public returns(bool success){
318     bytes memory empty;
319     	if(isContract(to)) {
320         	return transferToContract(to, tokens, empty);
321     	}
322     	else {
323         	return transferToAddress(to, tokens, empty);
324     	}
325     }
326 
327 
328     function approve(address spender, uint256 tokens) public returns (bool success) {
329 
330         if (tokens > 0 && balanceOf(msg.sender) >= tokens) {
331             _allowed[msg.sender][spender] = tokens;
332             emit Approval(msg.sender, spender, tokens);
333             return true;
334         }
335 
336         return false;
337     }
338 
339     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
340         return _allowed[tokenOwner][spender];
341     }
342 
343     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
344         if (tokens > 0 && balanceOf(from) >= tokens && _allowed[from][msg.sender] >= tokens) {
345             _balances[from] = _balances[from].sub(tokens);
346             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);
347             _balances[to] = _balances[to].add(tokens);
348             emit Transfer(msg.sender, to, tokens);
349             return true;
350         }
351         return false;
352     }
353 
354     function burn(uint256 tokens) public returns (bool success) {
355         if ( tokens > 0 && balanceOf(msg.sender) >= tokens ) {
356             _balances[msg.sender] = _balances[msg.sender].sub(tokens);
357             _tokenSupply = _tokenSupply.sub(tokens);
358             return true;
359         }
360 
361         return false;
362     }
363   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
364     if (balanceOf(msg.sender) < _value) revert();
365     _balances[msg.sender] = balanceOf(msg.sender).sub(_value);
366     _balances[_to] = balanceOf(_to).add(_value);
367     emit Transfer(msg.sender, _to, _value);
368     return true;
369   }
370 
371   //function that is called when transaction target is a contract
372   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
373     if (balanceOf(msg.sender) < _value) revert();
374     _balances[msg.sender] = balanceOf(msg.sender).sub(_value);
375     _balances[_to] = balanceOf(_to).add(_value);
376     ContractReceiver receiver = ContractReceiver(_to);
377     receiver.tokenFallback(msg.sender, _value, _data);
378     emit Transfer(msg.sender, _to, _value);
379     return true;
380 }
381 
382 
383 
384     function isContract(address _addr) view returns (bool is_contract){
385       uint length;
386       assembly {
387             length := extcodesize(_addr)
388       }
389       return (length>0);
390     }
391 
392     function () public payable {
393         throw;
394 
395     }
396 }