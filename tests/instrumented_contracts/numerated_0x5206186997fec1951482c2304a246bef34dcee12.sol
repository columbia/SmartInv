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
73 
74 
75   function Ownable() public {
76 
77     owner = msg.sender;
78 
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
104 
105   bool public paused = false;
106 
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is not paused.
110    */
111   modifier whenNotPaused() {
112     require(!paused);
113     _;
114   }
115 
116   /**
117    * @dev Modifier to make a function callable only when the contract is paused.
118    */
119   modifier whenPaused() {
120     require(paused);
121     _;
122   }
123 
124   /**
125    * @dev called by the owner to pause, triggers stopped state
126    */
127   function pause() onlyOwner whenNotPaused public {
128     paused = true;
129     Pause();
130   }
131 
132   /**
133    * @dev called by the owner to unpause, returns to normal state
134    */
135   function unpause() onlyOwner whenPaused public {
136     paused = false;
137     Unpause();
138   }
139 }
140 
141 // File: contracts/ERC20Token.sol
142 
143 /*
144 
145     Copyright 2018, All rights reserved.
146      _      _
147     \ \    / / ___   ___  _ __
148      \ \  / / / _ \ / _ \| '_ \
149       \ \/ / |  __/|  __/| | | |
150        \__/   \___| \___||_| |_|
151 
152     @title Veen Token Contract.
153     @author Dohyeon Lee
154     @description ERC-20 Interface
155 
156 */
157 
158 interface ERC20Token {
159 
160     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
161     function approve(address spender, uint tokens) public returns (bool success);
162     function transferFrom(address from, address to, uint tokens) public returns (bool success);
163 
164     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
165 }
166 
167 // File: contracts/ERC223.sol
168 
169 interface ERC223 {
170 
171     function totalSupply() public constant returns (uint);
172     function balanceOf(address who) public constant returns (uint);
173     function transfer(address to, uint value) public returns (bool);
174 
175 }
176 
177 // File: contracts/Receiver_Interface.sol
178 
179 /*
180  * Contract that is working with ERC223 tokens
181  */
182  
183  contract ContractReceiver {
184      
185     struct TKN {
186         address sender;
187         uint value;
188         bytes data;
189         bytes4 sig;
190     }
191     
192     
193     function tokenFallback(address _from, uint _value, bytes _data) public pure {
194       TKN memory tkn;
195       tkn.sender = _from;
196       tkn.value = _value;
197       tkn.data = _data;
198       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
199       tkn.sig = bytes4(u);
200       
201       /* tkn variable is analogue of msg variable of Ether transaction
202       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
203       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
204       *  tkn.data is data of token transaction   (analogue of msg.data)
205       *  tkn.sig is 4 bytes signature of function
206       *  if data of token transaction is a function execution
207       */
208     }
209 }
210 
211 // File: contracts/Veen.sol
212 
213 /*
214     Copyright 2018, All rights reserved.
215      _      _
216     \ \    / / ___   ___  _ __
217      \ \  / / / _ \ / _ \| '_ \
218       \ \/ / |  __/|  __/| | | |
219        \__/   \___| \___||_| |_|
220 
221     @title Veen Token Contract.
222     @author Dohyeon Lee
223     @description Veen token is a ERC20-compliant token.
224 
225 */
226 
227 contract Veen is ERC20Token, Pausable, ERC223{
228 
229     using SafeMath for uint;
230 
231     string public constant name = "Veen";
232     string public constant symbol = "VEEN";
233     uint8 public constant decimals = 18;
234     uint private _tokenSupply;
235     uint private _totalSupply;
236     mapping(address => uint256) private _balances;
237     mapping(address => mapping(address => uint256)) private _allowed;
238     event MintedLog(address to, uint256 amount);
239     event Transfer(address indexed from, address indexed to, uint value);
240 
241 
242     function Veen() public {
243         _tokenSupply = 0;
244         _totalSupply = 15000000000 * (uint256(10) ** decimals);
245 
246     }
247 
248     function totalSupply() public constant returns (uint256) {
249         return _tokenSupply;
250     }
251 
252     function mint(address to, uint256 amount) onlyOwner public returns (bool){
253 
254         amount = amount * (uint256(10) ** decimals);
255         if(_totalSupply + 1 > (_tokenSupply+amount)){
256             _tokenSupply = _tokenSupply.add(amount);
257             _balances[to]= _balances[to].add(amount);
258             emit MintedLog(to, amount);
259             return true;
260         }
261 
262         return false;
263     }
264 
265     function dist_list_set(address[] dist_list, uint256[] token_list) onlyOwner external{
266 
267         for(uint i=0; i < dist_list.length ;i++){
268             transfer(dist_list[i],token_list[i]);
269         }
270 
271     }
272     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
273         return _balances[tokenOwner];
274     }
275 
276     function transfer(address to, uint tokens) whenNotPaused public returns(bool success){
277     bytes memory empty;
278     	if(isContract(to)) {
279         	return transferToContract(to, tokens, empty);
280     	}
281     	else {
282         	return transferToAddress(to, tokens, empty);
283     	}
284     }
285 
286 
287     function approve(address spender, uint256 tokens) public returns (bool success) {
288 
289         if (tokens > 0 && balanceOf(msg.sender) >= tokens) {
290             _allowed[msg.sender][spender] = tokens;
291             emit Approval(msg.sender, spender, tokens);
292             return true;
293         }
294 
295         return false;
296     }
297 
298     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
299         return _allowed[tokenOwner][spender];
300     }
301 
302     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
303         if (tokens > 0 && balanceOf(from) >= tokens && _allowed[from][msg.sender] >= tokens) {
304             _balances[from] = _balances[from].sub(tokens);
305             _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);
306             _balances[to] = _balances[to].add(tokens);
307             emit Transfer(msg.sender, to, tokens);
308             return true;
309         }
310         return false;
311     }
312 
313     function burn(uint256 tokens) public returns (bool success) {
314         if ( tokens > 0 && balanceOf(msg.sender) >= tokens ) {
315             _balances[msg.sender] = _balances[msg.sender].sub(tokens);
316             _tokenSupply = _tokenSupply.sub(tokens);
317             return true;
318         }
319 
320         return false;
321     }
322   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
323     if (balanceOf(msg.sender) < _value) revert();
324     _balances[msg.sender] = balanceOf(msg.sender).sub(_value);
325     _balances[_to] = balanceOf(_to).add(_value);
326     emit Transfer(msg.sender, _to, _value);
327     return true;
328   }
329   
330   //function that is called when transaction target is a contract
331   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
332     if (balanceOf(msg.sender) < _value) revert();
333     _balances[msg.sender] = balanceOf(msg.sender).sub(_value);
334     _balances[_to] = balanceOf(_to).add(_value);
335     ContractReceiver receiver = ContractReceiver(_to);
336     receiver.tokenFallback(msg.sender, _value, _data);
337     emit Transfer(msg.sender, _to, _value);
338     return true;
339 }
340 
341 
342 
343     function isContract(address _addr) view returns (bool is_contract){
344       uint length;
345       assembly {
346             length := extcodesize(_addr)
347       }
348       return (length>0);
349     }
350 
351     function () public payable {
352         throw;
353 
354     }
355 }