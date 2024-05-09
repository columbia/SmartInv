1 pragma solidity ^0.4.23;
2 
3 /*
4                 $$$$$$$$\        $$\ $$\                     
5                 $$  _____|       $$ |$$ |                    
6                 $$ |    $$$$$$\  $$ |$$ | $$$$$$\   $$$$$$$\ 
7                 $$$$$\ $$  __$$\ $$ |$$ | \____$$\ $$  _____|
8                 $$  __|$$$$$$$$ |$$ |$$ | $$$$$$$ |\$$$$$$\  
9                 $$ |   $$   ____|$$ |$$ |$$  __$$ | \____$$\ 
10                 $$ |   \$$$$$$$\ $$ |$$ |\$$$$$$$ |$$$$$$$  |
11                 \__|    \_______|\__|\__| \_______|\_______/ 
12                                                              
13                                                         
14 */
15 
16 // SafeMath
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a / b;
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 
45 // Ownable
46 contract Ownable {
47     address public owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address newOwner) onlyOwner public {
61         require(newOwner != address(0));
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65 }
66 
67 
68 // ERC223 https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
69 contract ERC223 {
70     uint public totalSupply;
71 
72     function balanceOf(address who) public view returns (uint);
73     function totalSupply() public view returns (uint256 _supply);
74     function transfer(address to, uint value) public returns (bool ok);
75     function transfer(address to, uint value, bytes data) public returns (bool ok);
76     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
77     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
78 
79     function name() public view returns (string _name);
80     function symbol() public view returns (string _symbol);
81     function decimals() public view returns (uint8 _decimals);
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
84     function approve(address _spender, uint256 _value) public returns (bool success);
85     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87     event Approval(address indexed _owner, address indexed _spender, uint _value);
88 }
89 
90 
91  // ContractReceiver
92  contract ContractReceiver {
93 
94     struct TKN {
95         address sender;
96         uint value;
97         bytes data;
98         bytes4 sig;
99     }
100 
101     function tokenFallback(address _from, uint _value, bytes _data) public pure {
102         TKN memory tkn;
103         tkn.sender = _from;
104         tkn.value = _value;
105         tkn.data = _data;
106         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
107         tkn.sig = bytes4(u);
108 
109         /*
110          * tkn variable is analogue of msg variable of Ether transaction
111          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
112          * tkn.value the number of tokens that were sent   (analogue of msg.value)
113          * tkn.data is data of token transaction   (analogue of msg.data)
114          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
115          */
116     }
117 }
118 
119 
120 // Fellas
121 contract Fellas is ERC223, Ownable {
122     using SafeMath for uint256;
123 
124     string public name = "Fellas";
125     string public symbol = "FELLAS";
126     uint8 public decimals = 8; 
127     uint256 public totalSupply = 50e9 * 1e8;
128     bool public mintingStopped = false;
129 
130     mapping(address => uint256) public balanceOf;
131     mapping(address => mapping (address => uint256)) public allowance;
132 
133     event Burn(address indexed from, uint256 amount);
134     event Mint(address indexed to, uint256 amount);
135     event MintStopped();
136 
137     constructor () public {
138         owner = 0x2ed3C80eD58332f0C221809775eA2A071c01661a;
139         balanceOf[owner] = totalSupply;
140     }
141 
142     function name() public view returns (string _name) {
143         return name;
144     }
145 
146     function symbol() public view returns (string _symbol) {
147         return symbol;
148     }
149 
150     function decimals() public view returns (uint8 _decimals) {
151         return decimals;
152     }
153 
154     function totalSupply() public view returns (uint256 _totalSupply) {
155         return totalSupply;
156     }
157 
158     function balanceOf(address _owner) public view returns (uint256 balance) {
159         return balanceOf[_owner];
160     }
161 
162     // transfer
163     function transfer(address _to, uint _value) public returns (bool success) {
164         require(_value > 0);
165 
166         bytes memory empty;
167         if (isContract(_to)) {
168             return transferToContract(_to, _value, empty);
169         } else {
170             return transferToAddress(_to, _value, empty);
171         }
172     }
173 
174     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
175         require(_value > 0);
176 
177         if (isContract(_to)) {
178             return transferToContract(_to, _value, _data);
179         } else {
180             return transferToAddress(_to, _value, _data);
181         }
182     }
183 
184     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
185         require(_value > 0);
186 
187         if (isContract(_to)) {
188             require(balanceOf[msg.sender] >= _value);
189             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
190             balanceOf[_to] = balanceOf[_to].add(_value);
191             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
192             emit Transfer(msg.sender, _to, _value, _data);
193             emit Transfer(msg.sender, _to, _value);
194             return true;
195         } else {
196             return transferToAddress(_to, _value, _data);
197         }
198     }
199 
200     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
201     function isContract(address _addr) private view returns (bool is_contract) {
202         uint length;
203         assembly {
204             //retrieve the size of the code on target address, this needs assembly
205             length := extcodesize(_addr)
206         }
207         return (length > 0);
208     }
209 
210     // function that is called when transaction target is an address
211     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
212         require(balanceOf[msg.sender] >= _value);
213         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
214         balanceOf[_to] = balanceOf[_to].add(_value);
215         emit Transfer(msg.sender, _to, _value, _data);
216         emit Transfer(msg.sender, _to, _value);
217         return true;
218     }
219 
220     // function that is called when transaction target is a contract
221     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
222         require(balanceOf[msg.sender] >= _value);
223         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
224         balanceOf[_to] = balanceOf[_to].add(_value);
225         ContractReceiver receiver = ContractReceiver(_to);
226         receiver.tokenFallback(msg.sender, _value, _data);
227         emit Transfer(msg.sender, _to, _value, _data);
228         emit Transfer(msg.sender, _to, _value);
229         return true;
230     }
231 
232     // transferFrom
233     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
234         require(_to != address(0)
235                 && _value > 0
236                 && balanceOf[_from] >= _value
237                 && allowance[_from][msg.sender] >= _value);
238 
239         balanceOf[_from] = balanceOf[_from].sub(_value);
240         balanceOf[_to] = balanceOf[_to].add(_value);
241         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
242         emit Transfer(_from, _to, _value);
243         return true;
244     }
245 
246     // approve
247     function approve(address _spender, uint256 _value) public returns (bool success) {
248         allowance[msg.sender][_spender] = _value;
249         emit Approval(msg.sender, _spender, _value);
250         return true;
251     }
252 
253     // allowance
254     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
255         return allowance[_owner][_spender];
256     }
257 
258     // burn
259     function burn(address _from, uint256 _unitAmount) onlyOwner public {
260         require(_unitAmount > 0
261                 && balanceOf[_from] >= _unitAmount);
262 
263         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
264         totalSupply = totalSupply.sub(_unitAmount);
265         emit Burn(_from, _unitAmount);
266     }
267 
268     modifier canMinting() {
269         require(!mintingStopped);
270         _;
271     }
272 
273     // mint
274     function mint(address _to, uint256 _unitAmount) onlyOwner canMinting public returns (bool) {
275         require(_unitAmount > 0);
276 
277         totalSupply = totalSupply.add(_unitAmount);
278         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
279         emit Mint(_to, _unitAmount);
280         emit Transfer(address(0), _to, _unitAmount);
281         return true;
282     }
283 
284     // stopMinting
285     function stopMinting() onlyOwner canMinting public returns (bool) {
286         mintingStopped = true;
287         emit MintStopped();
288         return true;
289     }
290 
291     // airdrop
292     function airdrop(address[] addresses, uint256 amount) public returns (bool) {
293         require(amount > 0
294                 && addresses.length > 0);
295 
296         amount = amount.mul(1e8);
297         uint256 totalAmount = amount.mul(addresses.length);
298         require(balanceOf[msg.sender] >= totalAmount);
299 
300         for (uint j = 0; j < addresses.length; j++) {
301             require(addresses[j] != 0x0);
302 
303             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
304             emit Transfer(msg.sender, addresses[j], amount);
305         }
306         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
307         return true;
308     }
309 
310     // airdropAmounts
311     function airdropAmounts(address[] addresses, uint[] amounts) public returns (bool) {
312         require(addresses.length > 0
313                 && addresses.length == amounts.length);
314 
315         uint256 totalAmount = 0;
316 
317         for(uint j = 0; j < addresses.length; j++){
318             require(amounts[j] > 0
319                     && addresses[j] != 0x0);
320 
321             amounts[j] = amounts[j].mul(1e8);
322             totalAmount = totalAmount.add(amounts[j]);
323         }
324         require(balanceOf[msg.sender] >= totalAmount);
325 
326         for (j = 0; j < addresses.length; j++) {
327             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
328             emit Transfer(msg.sender, addresses[j], amounts[j]);
329         }
330         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
331         return true;
332     }
333 
334     // collect
335     function collect(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
336         require(addresses.length > 0
337                 && addresses.length == amounts.length);
338 
339         uint256 totalAmount = 0;
340 
341         for (uint j = 0; j < addresses.length; j++) {
342             require(amounts[j] > 0
343                     && addresses[j] != 0x0);
344 
345             amounts[j] = amounts[j].mul(1e8);
346             require(balanceOf[addresses[j]] >= amounts[j]);
347             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
348             totalAmount = totalAmount.add(amounts[j]);
349             emit Transfer(addresses[j], msg.sender, amounts[j]);
350         }
351         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
352         return true;
353     }
354 }