1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC20.sol
4 
5 contract ERC20 {
6   uint public totalSupply;
7 
8   function name() public view returns (string _name);
9   function symbol() public view returns (string _symbol);
10   function decimals() public view returns (uint8 _decimals);
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function allowance(address _owner, address _spender) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   function approve(address _spender, uint256 _value) public returns (bool);
16   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
17 
18   event Transfer( address indexed from, address indexed to, uint256 value);
19   event Approval( address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 // File: contracts/Ownable.sol
23 
24 contract Ownable {
25     address public owner;
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     function Ownable() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address newOwner) onlyOwner public {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 }
43 
44 // File: contracts/SafeMath.sol
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // assert(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 // File: contracts/Alohacoin.sol
80 
81 contract ContractReceiver {
82    struct TKN {
83        address sender;
84        uint value;
85        bytes data;
86        bytes4 sig;
87    }
88    function tokenFallback(address _from, uint _value, bytes _data) public pure {
89        TKN memory tkn;
90        tkn.sender = _from;
91        tkn.value = _value;
92        tkn.data = _data;
93        uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
94        tkn.sig = bytes4(u);
95    }
96 }
97 
98 contract Alohacoin is ERC20, Ownable {
99     using SafeMath for uint256;
100 
101     string public name = "ALOHA";
102     string public symbol = "ALOHA";
103     uint8 public decimals = 11;
104     uint private constant DECIMALS = 100000000000;
105     uint256 public totalSupply = 3698888800 * DECIMALS; // 36milion
106 
107     address private founder_a;
108     address private founder_b;
109     address private founder_c;
110     address private founder_d;
111     address private founder_e;
112 
113     mapping(address => uint256) public balanceOf;
114     mapping(address => mapping (address => uint256)) public allowance;
115     mapping (address => bool) public frozenAccount;
116     mapping (address => uint256) public unlockUnixTime;
117 
118     event FrozenFunds(address indexed target, bool frozen);
119     event LockedUp(address indexed target, uint256 locked);
120     event Burn(address indexed from, uint256 amount);
121 
122     /**
123      * @dev Constructor is called only once and can not be called again
124      */
125     function Alohacoin(
126       address _founder_a,
127       address _founder_b,
128       address _founder_c,
129       address _founder_d,
130       address _founder_e
131     ) public {
132         founder_a  = _founder_a;
133         founder_b  = _founder_b;
134         founder_c  = _founder_c;
135         founder_d  = _founder_d;
136         founder_e  = _founder_e;
137 
138         balanceOf[founder_a] += 1109666640 * DECIMALS; // 30%
139         balanceOf[founder_b] += 1109666640 * DECIMALS; // 30%
140         balanceOf[founder_c] += 1109666640 * DECIMALS; // 30%
141         balanceOf[founder_d] += 332899992 * DECIMALS;  // 9%
142         balanceOf[founder_e] += 36988888 * DECIMALS;   // 1%
143     }
144 
145     function name() public view returns (string _name) { return name; }
146     function symbol() public view returns (string _symbol) { return symbol; }
147     function decimals() public view returns (uint8 _decimals) { return decimals; }
148     function totalSupply() public view returns (uint256 _totalSupply) { return totalSupply; }
149     function balanceOf(address _owner) public view returns (uint256 balance) { return balanceOf[_owner]; }
150 
151     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
152         require(targets.length > 0);
153 
154         for (uint j = 0; j < targets.length; j++) {
155             require(targets[j] != 0x0);
156             frozenAccount[targets[j]] = isFrozen;
157             FrozenFunds(targets[j], isFrozen);
158         }
159     }
160 
161     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
162         require(targets.length > 0
163                 && targets.length == unixTimes.length);
164 
165         for(uint j = 0; j < targets.length; j++){
166             unlockUnixTime[targets[j]] = unixTimes[j];
167             LockedUp(targets[j], unixTimes[j]);
168         }
169     }
170 
171     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
172         require(
173           _value > 0
174           && frozenAccount[msg.sender] == false
175           && frozenAccount[_to] == false
176           && now > unlockUnixTime[msg.sender]
177           && now > unlockUnixTime[_to]
178         );
179         if (isContract(_to)) {
180             require(balanceOf[msg.sender] >= _value);
181             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
182             balanceOf[_to] = balanceOf[_to].add(_value);
183             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
184             Transfer(msg.sender, _to, _value);
185             Transfer(msg.sender, _to, _value);
186             return true;
187         } else {
188             return transferToAddress(_to, _value, _data);
189         }
190     }
191 
192     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
193         require(
194           _value > 0
195           && frozenAccount[msg.sender] == false
196           && frozenAccount[_to] == false
197           && now > unlockUnixTime[msg.sender]
198           && now > unlockUnixTime[_to]
199         );
200         if (isContract(_to)) {
201             return transferToContract(_to, _value, _data);
202         } else {
203             return transferToAddress(_to, _value, _data);
204         }
205     }
206 
207     function transfer(address _to, uint _value) public returns (bool success) {
208         require(_value > 0
209                 && frozenAccount[msg.sender] == false
210                 && frozenAccount[_to] == false
211                 && now > unlockUnixTime[msg.sender]
212                 && now > unlockUnixTime[_to]);
213 
214         bytes memory empty;
215         if (isContract(_to)) {
216             return transferToContract(_to, _value, empty);
217         } else {
218             return transferToAddress(_to, _value, empty);
219         }
220     }
221 
222     function isContract(address _addr) private view returns (bool is_contract) {
223         uint length;
224         assembly {
225             //retrieve the size of the code on target address, this needs assembly
226             length := extcodesize(_addr)
227         }
228         return (length > 0);
229     }
230 
231     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
232         require(balanceOf[msg.sender] >= _value);
233         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
234         balanceOf[_to] = balanceOf[_to].add(_value);
235         Transfer(msg.sender, _to, _value);
236         Transfer(msg.sender, _to, _value);
237         return true;
238     }
239 
240     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
241         require(balanceOf[msg.sender] >= _value);
242         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
243         balanceOf[_to] = balanceOf[_to].add(_value);
244         ContractReceiver receiver = ContractReceiver(_to);
245         receiver.tokenFallback(msg.sender, _value, _data);
246         Transfer(msg.sender, _to, _value);
247         Transfer(msg.sender, _to, _value);
248         return true;
249     }
250 
251     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
252         require(_to != address(0)
253                 && _value > 0
254                 && balanceOf[_from] >= _value
255                 && allowance[_from][msg.sender] >= _value
256                 && frozenAccount[_from] == false
257                 && frozenAccount[_to] == false
258                 && now > unlockUnixTime[_from]
259                 && now > unlockUnixTime[_to]);
260 
261         balanceOf[_from] = balanceOf[_from].sub(_value);
262         balanceOf[_to] = balanceOf[_to].add(_value);
263         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
264         Transfer(_from, _to, _value);
265         return true;
266     }
267 
268     function approve(address _spender, uint256 _value) public returns (bool success) {
269         allowance[msg.sender][_spender] = _value;
270         Approval(msg.sender, _spender, _value);
271         return true;
272     }
273 
274     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
275         return allowance[_owner][_spender];
276     }
277 
278     function burn(address _from, uint256 _unitAmount) onlyOwner public {
279         require(_unitAmount > 0
280                 && balanceOf[_from] >= _unitAmount);
281 
282         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
283         totalSupply = totalSupply.sub(_unitAmount);
284         Burn(_from, _unitAmount);
285     }
286 
287     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
288         require(addresses.length > 0
289                 && addresses.length == amounts.length
290                 && frozenAccount[msg.sender] == false
291                 && now > unlockUnixTime[msg.sender]);
292 
293         uint256 totalAmount = 0;
294 
295         for(uint j = 0; j < addresses.length; j++){
296             require(amounts[j] > 0
297                     && addresses[j] != 0x0
298                     && frozenAccount[addresses[j]] == false
299                     && now > unlockUnixTime[addresses[j]]);
300 
301             amounts[j] = amounts[j].mul(1e8);
302             totalAmount = totalAmount.add(amounts[j]);
303         }
304         require(balanceOf[msg.sender] >= totalAmount);
305 
306         for (j = 0; j < addresses.length; j++) {
307             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
308             Transfer(msg.sender, addresses[j], amounts[j]);
309         }
310         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
311         return true;
312     }
313 
314     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
315         require(addresses.length > 0 && addresses.length == amounts.length);
316         uint256 totalAmount = 0;
317 
318         for (uint j = 0; j < addresses.length; j++) {
319             require(amounts[j] > 0
320                     && addresses[j] != 0x0
321                     && frozenAccount[addresses[j]] == false
322                     && now > unlockUnixTime[addresses[j]]);
323 
324             amounts[j] = amounts[j].mul(1e8);
325             require(balanceOf[addresses[j]] >= amounts[j]);
326             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
327             totalAmount = totalAmount.add(amounts[j]);
328             Transfer(addresses[j], msg.sender, amounts[j]);
329         }
330         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
331         return true;
332     }
333 
334     function() payable public { }
335 
336 }