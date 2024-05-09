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
64     //event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
65     event Transfer(address indexed from, address indexed to, uint value, bytes data);
66 
67     function name() public view returns (string _name);
68     function symbol() public view returns (string _symbol);
69     function decimals() public view returns (uint8 _decimals);
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
72     function approve(address _spender, uint256 _value) public returns (bool success);
73     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint _value);
76 }
77 
78 
79  // ContractReceiver
80  contract ContractReceiver {
81 
82     struct TKN {
83         address sender;
84         uint value;
85         bytes data;
86         bytes4 sig;
87     }
88 
89     function tokenFallback(address _from, uint _value, bytes _data) public pure {
90         TKN memory tkn;
91         tkn.sender = _from;
92         tkn.value = _value;
93         tkn.data = _data;
94         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
95         tkn.sig = bytes4(u);
96 
97     }
98 }
99 
100 
101 // ISYSTOKEN
102 contract Token is ERC223, Ownable {
103     using SafeMath for uint256;
104 
105     string public name = "RON";
106     string public symbol = "RON";
107     uint8 public decimals = 18;
108     uint256 public totalSupply = 10e10 * 1e18;
109     bool public mintingStopped = false;
110 
111     mapping(address => uint256) public balanceOf;
112     mapping(address => mapping (address => uint256)) public allowance;
113 
114     event Burn(address indexed from, uint256 amount);
115     event Mint(address indexed to, uint256 amount);
116     event MintStopped();
117 
118     constructor () public {
119         balanceOf[msg.sender] = totalSupply;
120     }
121 
122     function name() public view returns (string _name) {
123         return name;
124     }
125 
126     function symbol() public view returns (string _symbol) {
127         return symbol;
128     }
129 
130     function decimals() public view returns (uint8 _decimals) {
131         return decimals;
132     }
133 
134     function totalSupply() public view returns (uint256 _totalSupply) {
135         return totalSupply;
136     }
137 
138     function balanceOf(address _owner) public view returns (uint256 balance) {
139         return balanceOf[_owner];
140     }
141 
142     // transfer
143     function transfer(address _to, uint _value) public returns (bool success) {
144         require(_value > 0);
145 
146         bytes memory empty;
147         if (isContract(_to)) {
148             return transferToContract(_to, _value, empty);
149         } else {
150             return transferToAddress(_to, _value, empty);
151         }
152     }
153 
154     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
155         require(_value > 0);
156 
157         if (isContract(_to)) {
158             return transferToContract(_to, _value, _data);
159         } else {
160             return transferToAddress(_to, _value, _data);
161         }
162     }
163 
164     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
165         require(_value > 0);
166 
167         if (isContract(_to)) {
168             require(balanceOf[msg.sender] >= _value);
169             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
170             balanceOf[_to] = balanceOf[_to].add(_value);
171             assert(_to.call.value(0)(bytes4(keccak256(abi.encodePacked(_custom_fallback))), msg.sender, _value, _data));
172             emit Transfer(msg.sender, _to, _value, _data);
173             emit Transfer(msg.sender, _to, _value);
174             return true;
175         } else {
176             return transferToAddress(_to, _value, _data);
177         }
178     }
179 
180     function isContract(address _addr) private view returns (bool is_contract) {
181         uint length;
182         assembly {
183             length := extcodesize(_addr)
184         }
185         return (length > 0);
186     }
187 
188     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
189         require(balanceOf[msg.sender] >= _value);
190         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
191         balanceOf[_to] = balanceOf[_to].add(_value);
192         emit Transfer(msg.sender, _to, _value, _data);
193         emit Transfer(msg.sender, _to, _value);
194         return true;
195     }
196 
197     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
198         require(balanceOf[msg.sender] >= _value);
199         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
200         balanceOf[_to] = balanceOf[_to].add(_value);
201         ContractReceiver receiver = ContractReceiver(_to);
202         receiver.tokenFallback(msg.sender, _value, _data);
203         emit Transfer(msg.sender, _to, _value, _data);
204         emit Transfer(msg.sender, _to, _value);
205         return true;
206     }
207 
208     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
209         require(_to != address(0)
210                 && _value > 0
211                 && balanceOf[_from] >= _value
212                 && allowance[_from][msg.sender] >= _value);
213 
214         balanceOf[_from] = balanceOf[_from].sub(_value);
215         balanceOf[_to] = balanceOf[_to].add(_value);
216         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
217         emit Transfer(_from, _to, _value);
218         return true;
219     }
220 
221     // approve
222     function approve(address _spender, uint256 _value) public returns (bool success) {
223         allowance[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value);
225         return true;
226     }
227 
228     // allowance
229     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
230         return allowance[_owner][_spender];
231     }
232 
233     // burn
234     function burn(address _from, uint256 _unitAmount) onlyOwner public {
235         require(_unitAmount > 0
236                 && balanceOf[_from] >= _unitAmount);
237 
238         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
239         totalSupply = totalSupply.sub(_unitAmount);
240         emit Burn(_from, _unitAmount);
241     }
242 
243     modifier canMinting() {
244         require(!mintingStopped);
245         _;
246     }
247 
248     // mint
249     function mint(address _to, uint256 _unitAmount) onlyOwner canMinting public returns (bool) {
250         require(_unitAmount > 0);
251 
252         totalSupply = totalSupply.add(_unitAmount);
253         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
254         emit Mint(_to, _unitAmount);
255         emit Transfer(address(0), _to, _unitAmount);
256         return true;
257     }
258 
259     // stopMinting
260     function stopMinting() onlyOwner canMinting public returns (bool) {
261         mintingStopped = true;
262         emit MintStopped();
263         return true;
264     }
265 
266     // airdrop
267     function airdrop(address[] addresses, uint256 amount) public returns (bool) {
268         require(amount > 0
269                 && addresses.length > 0);
270 
271         amount = amount.mul(1e8);
272         uint256 totalAmount = amount.mul(addresses.length);
273         require(balanceOf[msg.sender] >= totalAmount);
274 
275         for (uint j = 0; j < addresses.length; j++) {
276             require(addresses[j] != 0x0);
277 
278             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
279             emit Transfer(msg.sender, addresses[j], amount);
280         }
281         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
282         return true;
283     }
284 
285     // airdropAmounts
286     function airdropAmounts(address[] addresses, uint[] amounts) public returns (bool) {
287         require(addresses.length > 0
288                 && addresses.length == amounts.length);
289 
290         uint256 totalAmount = 0;
291 
292         for(uint j = 0; j < addresses.length; j++){
293             require(amounts[j] > 0
294                     && addresses[j] != 0x0);
295 
296             amounts[j] = amounts[j].mul(1e8);
297             totalAmount = totalAmount.add(amounts[j]);
298         }
299         require(balanceOf[msg.sender] >= totalAmount);
300 
301         for (j = 0; j < addresses.length; j++) {
302             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
303             emit Transfer(msg.sender, addresses[j], amounts[j]);
304         }
305         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
306         return true;
307     }
308 
309     // collect
310     function collect(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
311         require(addresses.length > 0
312                 && addresses.length == amounts.length);
313 
314         uint256 totalAmount = 0;
315 
316         for (uint j = 0; j < addresses.length; j++) {
317             require(amounts[j] > 0
318                     && addresses[j] != 0x0);
319 
320             amounts[j] = amounts[j].mul(1e8);
321             require(balanceOf[addresses[j]] >= amounts[j]);
322             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
323             totalAmount = totalAmount.add(amounts[j]);
324             emit Transfer(addresses[j], msg.sender, amounts[j]);
325         }
326         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
327         return true;
328     }
329 }