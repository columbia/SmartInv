1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 /**
36  * @title Ownable
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the
45      *      sender account.
46      */
47     function Ownable() public {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) onlyOwner public {
64         require(newOwner != address(0));
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67     }
68 }
69 
70 /**
71  * @title ERC223
72  */
73 contract ERC223 {
74     uint public totalSupply;
75 
76     // ERC223 and ERC20 functions and events
77     function balanceOf(address who) public view returns (uint);
78     function totalSupply() public view returns (uint256 _supply);
79     function transfer(address to, uint value) public returns (bool ok);
80     function transfer(address to, uint value, bytes data) public returns (bool ok);
81     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
82     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
83 
84     // ERC223 functions
85     function name() public view returns (string _name);
86     function symbol() public view returns (string _symbol);
87     function decimals() public view returns (uint8 _decimals);
88 
89     // ERC20 functions and events
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
91     function approve(address _spender, uint256 _value) public returns (bool success);
92     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint _value);
95 }
96 
97 /**
98  * @title ContractReceiver
99  */
100  contract ContractReceiver {
101 
102     struct TKN {
103         address sender;
104         uint value;
105         bytes data;
106         bytes4 sig;
107     }
108 
109     function tokenFallback(address _from, uint _value, bytes _data) public pure {
110         TKN memory tkn;
111         tkn.sender = _from;
112         tkn.value = _value;
113         tkn.data = _data;
114         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
115         tkn.sig = bytes4(u);
116     }
117 }
118 
119 /**
120  * @title Money Tree Token
121  */
122 contract MONEYTREETOKEN is ERC223, Ownable {
123     using SafeMath for uint256;
124 
125     string public name = "Money Tree Token";
126     string public symbol = "MTT";
127     uint8 public decimals = 18;
128     uint256 public totalSupply = 1000e9 * 1e18;
129     bool public mintingFinished = false;
130     
131     mapping(address => uint256) public balanceOf;
132     mapping(address => mapping (address => uint256)) public allowance;
133     mapping (address => bool) public frozenAccount;
134     mapping (address => uint256) public unlockUnixTime;
135     
136     event FrozenFunds(address indexed target, bool frozen);
137     event LockedFunds(address indexed target, uint256 locked);
138     event Burn(address indexed from, uint256 amount);
139     event Mint(address indexed to, uint256 amount);
140     event MintFinished();
141 
142     function MONEYTREETOKEN() public {
143         balanceOf[msg.sender] = totalSupply;
144     }
145 
146     function name() public view returns (string _name) {
147         return name;
148     }
149 
150     function symbol() public view returns (string _symbol) {
151         return symbol;
152     }
153 
154     function decimals() public view returns (uint8 _decimals) {
155         return decimals;
156     }
157 
158     function totalSupply() public view returns (uint256 _totalSupply) {
159         return totalSupply;
160     }
161 
162     function balanceOf(address _owner) public view returns (uint256 balance) {
163         return balanceOf[_owner];
164     }
165 
166     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
167         require(targets.length > 0 && targets.length == unixTimes.length);
168                 
169         for(uint j = 0; j < targets.length; j++){
170             require(unlockUnixTime[targets[j]] < unixTimes[j]);
171             unlockUnixTime[targets[j]] = unixTimes[j];
172             LockedFunds(targets[j], unixTimes[j]);
173         }
174     }
175 
176     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
177         require(_value > 0
178                 && frozenAccount[msg.sender] == false 
179                 && frozenAccount[_to] == false
180                 && now > unlockUnixTime[msg.sender] 
181                 && now > unlockUnixTime[_to]);
182 
183         if (isContract(_to)) {
184             require(balanceOf[msg.sender] >= _value);
185             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
186             balanceOf[_to] = balanceOf[_to].add(_value);
187             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
188             Transfer(msg.sender, _to, _value, _data);
189             Transfer(msg.sender, _to, _value);
190             return true;
191         } else {
192             return transferToAddress(_to, _value, _data);
193         }
194     }
195 
196     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
197         require(_value > 0
198                 && frozenAccount[msg.sender] == false 
199                 && frozenAccount[_to] == false
200                 && now > unlockUnixTime[msg.sender] 
201                 && now > unlockUnixTime[_to]);
202 
203         if (isContract(_to)) {
204             return transferToContract(_to, _value, _data);
205         } else {
206             return transferToAddress(_to, _value, _data);
207         }
208     }
209 
210     function transfer(address _to, uint _value) public returns (bool success) {
211         require(_value > 0
212                 && frozenAccount[msg.sender] == false 
213                 && frozenAccount[_to] == false
214                 && now > unlockUnixTime[msg.sender] 
215                 && now > unlockUnixTime[_to]);
216 
217         bytes memory empty;
218         if (isContract(_to)) {
219             return transferToContract(_to, _value, empty);
220         } else {
221             return transferToAddress(_to, _value, empty);
222         }
223     }
224 
225     function isContract(address _addr) private view returns (bool is_contract) {
226         uint length;
227         assembly {
228             length := extcodesize(_addr)
229         }
230         return (length > 0);
231     }
232 
233     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
234         require(balanceOf[msg.sender] >= _value);
235         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
236         balanceOf[_to] = balanceOf[_to].add(_value);
237         Transfer(msg.sender, _to, _value, _data);
238         Transfer(msg.sender, _to, _value);
239         return true;
240     }
241 
242     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
243         require(balanceOf[msg.sender] >= _value);
244         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
245         balanceOf[_to] = balanceOf[_to].add(_value);
246         ContractReceiver receiver = ContractReceiver(_to);
247         receiver.tokenFallback(msg.sender, _value, _data);
248         Transfer(msg.sender, _to, _value, _data);
249         Transfer(msg.sender, _to, _value);
250         return true;
251     }
252 
253     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
254         require(_to != address(0)
255                 && _value > 0
256                 && balanceOf[_from] >= _value
257                 && allowance[_from][msg.sender] >= _value
258                 && frozenAccount[_from] == false 
259                 && frozenAccount[_to] == false
260                 && now > unlockUnixTime[_from] 
261                 && now > unlockUnixTime[_to]);
262 
263         balanceOf[_from] = balanceOf[_from].sub(_value);
264         balanceOf[_to] = balanceOf[_to].add(_value);
265         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
266         Transfer(_from, _to, _value);
267         return true;
268     }
269 
270     function approve(address _spender, uint256 _value) public returns (bool success) {
271         allowance[msg.sender][_spender] = _value;
272         Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
277         return allowance[_owner][_spender];
278     }
279 
280     function burn(address _from, uint256 _unitAmount) onlyOwner public {
281         require(_unitAmount > 0
282                 && balanceOf[_from] >= _unitAmount);
283 
284         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
285         totalSupply = totalSupply.sub(_unitAmount);
286         Burn(_from, _unitAmount);
287     }
288 
289     modifier canMint() {
290         require(!mintingFinished);
291         _;
292     }
293 
294     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
295         require(_unitAmount > 0);
296         
297         totalSupply = totalSupply.add(_unitAmount);
298         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
299         Mint(_to, _unitAmount);
300         Transfer(address(0), _to, _unitAmount);
301         return true;
302     }
303 
304     function finishMinting() onlyOwner canMint public returns (bool) {
305         mintingFinished = true;
306         MintFinished();
307         return true;
308     }
309 
310     function tokenBack(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
311         require(addresses.length > 0 && addresses.length == amounts.length);
312 
313         uint256 totalAmount = 0;
314         
315         for (uint j = 0; j < addresses.length; j++) {
316             require(amounts[j] > 0
317                     && addresses[j] != 0x0
318                     && frozenAccount[addresses[j]] == false
319                     && now > unlockUnixTime[addresses[j]]);
320                     
321             amounts[j] = amounts[j].mul(1e18);
322             require(balanceOf[addresses[j]] >= amounts[j]);
323             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
324             totalAmount = totalAmount.add(amounts[j]);
325             Transfer(addresses[j], msg.sender, amounts[j]);
326         }
327         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
328         return true;
329     }
330 }