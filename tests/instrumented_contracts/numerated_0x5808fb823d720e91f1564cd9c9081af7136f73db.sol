1 pragma solidity ^0.4.23;
2 
3 // SafeMath
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 
32 // Ownable
33 contract Ownable {
34     address public owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function transferOwnership(address newOwner) onlyOwner public {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 }
53 
54 
55 // ERC223 https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
56 contract ERC223 {
57     uint public totalSupply;
58 
59     function balanceOf(address who) public view returns (uint);
60     function totalSupply() public view returns (uint256 _supply);
61     function transfer(address to, uint value) public returns (bool ok);
62     function transfer(address to, uint value, bytes data) public returns (bool ok);
63     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
64     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
65 
66     function name() public view returns (string _name);
67     function symbol() public view returns (string _symbol);
68     function decimals() public view returns (uint8 _decimals);
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
71     function approve(address _spender, uint256 _value) public returns (bool success);
72     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint _value);
75 }
76 
77 
78  // ContractReceiver
79  contract ContractReceiver {
80 
81     struct TKN {
82         address sender;
83         uint value;
84         bytes data;
85         bytes4 sig;
86     }
87 
88     function tokenFallback(address _from, uint _value, bytes _data) public pure {
89         TKN memory tkn;
90         tkn.sender = _from;
91         tkn.value = _value;
92         tkn.data = _data;
93         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
94         tkn.sig = bytes4(u);
95 
96         /*
97          * tkn variable is analogue of msg variable of Ether transaction
98          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
99          * tkn.value the number of tokens that were sent   (analogue of msg.value)
100          * tkn.data is data of token transaction   (analogue of msg.data)
101          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
102          */
103     }
104 }
105 
106 
107 // BENGOSHICOIN
108 contract BENGOSHICOIN is ERC223, Ownable {
109     using SafeMath for uint256;
110 
111     string public name = "BENGOSHICOIN";
112     string public symbol = "BENGO";
113     uint8 public decimals = 8;
114     uint256 public totalSupply = 20e9 * 1e8;
115     bool public mintingStopped = false;
116 
117     mapping(address => uint256) public balanceOf;
118     mapping(address => mapping (address => uint256)) public allowance;
119 
120     event Burn(address indexed from, uint256 amount);
121     event Mint(address indexed to, uint256 amount);
122     event MintStopped();
123 
124     constructor () public {
125         owner = 0x17823d2B0e9f503C7ec2DE099243782ac3F7fBB1;
126         balanceOf[owner] = totalSupply;
127     }
128 
129     function name() public view returns (string _name) {
130         return name;
131     }
132 
133     function symbol() public view returns (string _symbol) {
134         return symbol;
135     }
136 
137     function decimals() public view returns (uint8 _decimals) {
138         return decimals;
139     }
140 
141     function totalSupply() public view returns (uint256 _totalSupply) {
142         return totalSupply;
143     }
144 
145     function balanceOf(address _owner) public view returns (uint256 balance) {
146         return balanceOf[_owner];
147     }
148 
149     // transfer
150     function transfer(address _to, uint _value) public returns (bool success) {
151         require(_value > 0);
152 
153         bytes memory empty;
154         if (isContract(_to)) {
155             return transferToContract(_to, _value, empty);
156         } else {
157             return transferToAddress(_to, _value, empty);
158         }
159     }
160 
161     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
162         require(_value > 0);
163 
164         if (isContract(_to)) {
165             return transferToContract(_to, _value, _data);
166         } else {
167             return transferToAddress(_to, _value, _data);
168         }
169     }
170 
171     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
172         require(_value > 0);
173 
174         if (isContract(_to)) {
175             require(balanceOf[msg.sender] >= _value);
176             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
177             balanceOf[_to] = balanceOf[_to].add(_value);
178             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
179             emit Transfer(msg.sender, _to, _value, _data);
180             emit Transfer(msg.sender, _to, _value);
181             return true;
182         } else {
183             return transferToAddress(_to, _value, _data);
184         }
185     }
186 
187     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
188     function isContract(address _addr) private view returns (bool is_contract) {
189         uint length;
190         assembly {
191             //retrieve the size of the code on target address, this needs assembly
192             length := extcodesize(_addr)
193         }
194         return (length > 0);
195     }
196 
197     // function that is called when transaction target is an address
198     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
199         require(balanceOf[msg.sender] >= _value);
200         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
201         balanceOf[_to] = balanceOf[_to].add(_value);
202         emit Transfer(msg.sender, _to, _value, _data);
203         emit Transfer(msg.sender, _to, _value);
204         return true;
205     }
206 
207     // function that is called when transaction target is a contract
208     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
209         require(balanceOf[msg.sender] >= _value);
210         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
211         balanceOf[_to] = balanceOf[_to].add(_value);
212         ContractReceiver receiver = ContractReceiver(_to);
213         receiver.tokenFallback(msg.sender, _value, _data);
214         emit Transfer(msg.sender, _to, _value, _data);
215         emit Transfer(msg.sender, _to, _value);
216         return true;
217     }
218 
219     // transferFrom
220     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
221         require(_to != address(0)
222                 && _value > 0
223                 && balanceOf[_from] >= _value
224                 && allowance[_from][msg.sender] >= _value);
225 
226         balanceOf[_from] = balanceOf[_from].sub(_value);
227         balanceOf[_to] = balanceOf[_to].add(_value);
228         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
229         emit Transfer(_from, _to, _value);
230         return true;
231     }
232 
233     // approve
234     function approve(address _spender, uint256 _value) public returns (bool success) {
235         allowance[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240     // allowance
241     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
242         return allowance[_owner][_spender];
243     }
244 
245     // burn
246     function burn(address _from, uint256 _unitAmount) onlyOwner public {
247         require(_unitAmount > 0
248                 && balanceOf[_from] >= _unitAmount);
249 
250         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
251         totalSupply = totalSupply.sub(_unitAmount);
252         emit Burn(_from, _unitAmount);
253     }
254 
255     modifier canMinting() {
256         require(!mintingStopped);
257         _;
258     }
259 
260     // mint
261     function mint(address _to, uint256 _unitAmount) onlyOwner canMinting public returns (bool) {
262         require(_unitAmount > 0);
263 
264         totalSupply = totalSupply.add(_unitAmount);
265         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
266         emit Mint(_to, _unitAmount);
267         emit Transfer(address(0), _to, _unitAmount);
268         return true;
269     }
270 
271     // stopMinting
272     function stopMinting() onlyOwner canMinting public returns (bool) {
273         mintingStopped = true;
274         emit MintStopped();
275         return true;
276     }
277 
278     // airdrop
279     function airdrop(address[] addresses, uint256 amount) public returns (bool) {
280         require(amount > 0
281                 && addresses.length > 0);
282 
283         amount = amount.mul(1e8);
284         uint256 totalAmount = amount.mul(addresses.length);
285         require(balanceOf[msg.sender] >= totalAmount);
286 
287         for (uint j = 0; j < addresses.length; j++) {
288             require(addresses[j] != 0x0);
289 
290             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
291             emit Transfer(msg.sender, addresses[j], amount);
292         }
293         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
294         return true;
295     }
296 
297     // airdropAmounts
298     function airdropAmounts(address[] addresses, uint[] amounts) public returns (bool) {
299         require(addresses.length > 0
300                 && addresses.length == amounts.length);
301 
302         uint256 totalAmount = 0;
303 
304         for(uint j = 0; j < addresses.length; j++){
305             require(amounts[j] > 0
306                     && addresses[j] != 0x0);
307 
308             amounts[j] = amounts[j].mul(1e8);
309             totalAmount = totalAmount.add(amounts[j]);
310         }
311         require(balanceOf[msg.sender] >= totalAmount);
312 
313         for (j = 0; j < addresses.length; j++) {
314             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
315             emit Transfer(msg.sender, addresses[j], amounts[j]);
316         }
317         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
318         return true;
319     }
320 
321     // collect
322     function collect(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
323         require(addresses.length > 0
324                 && addresses.length == amounts.length);
325 
326         uint256 totalAmount = 0;
327 
328         for (uint j = 0; j < addresses.length; j++) {
329             require(amounts[j] > 0
330                     && addresses[j] != 0x0);
331 
332             amounts[j] = amounts[j].mul(1e8);
333             require(balanceOf[addresses[j]] >= amounts[j]);
334             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
335             totalAmount = totalAmount.add(amounts[j]);
336             emit Transfer(addresses[j], msg.sender, amounts[j]);
337         }
338         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
339         return true;
340     }
341 }