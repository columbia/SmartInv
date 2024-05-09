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
79 // File: contracts/Xmalltoken.sol
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
98 contract Xmalltoken is ERC20, Ownable {
99     using SafeMath for uint256;
100 
101     string public name = "cryptomall token";
102     string public symbol = "XMALL";
103     uint8 public decimals = 18;
104     uint private constant DECIMALS = 1000000000000000000;
105     uint256 public totalSupply = 50000000000 * DECIMALS; // 50milion
106 
107     address private founder;
108 
109     mapping(address => uint256) public balanceOf;
110     mapping(address => mapping (address => uint256)) public allowance;
111     mapping (address => bool) public frozenAccount;
112     mapping (address => uint256) public unlockUnixTime;
113 
114     event FrozenFunds(address indexed target, bool frozen);
115     event LockedUp(address indexed target, uint256 locked);
116     event Burn(address indexed from, uint256 amount);
117 
118     /**
119      * @dev Constructor is called only once and can not be called again
120      */
121     function Xmalltoken(
122       address _address
123     ) public {
124         founder  = _address;
125         balanceOf[founder] += 50000000000 * DECIMALS;
126     }
127 
128     function name() public view returns (string _name) { return name; }
129     function symbol() public view returns (string _symbol) { return symbol; }
130     function decimals() public view returns (uint8 _decimals) { return decimals; }
131     function totalSupply() public view returns (uint256 _totalSupply) { return totalSupply; }
132     function balanceOf(address _owner) public view returns (uint256 balance) { return balanceOf[_owner]; }
133 
134     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
135         require(targets.length > 0);
136 
137         for (uint j = 0; j < targets.length; j++) {
138             require(targets[j] != 0x0);
139             frozenAccount[targets[j]] = isFrozen;
140             FrozenFunds(targets[j], isFrozen);
141         }
142     }
143 
144     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
145         require(targets.length > 0
146                 && targets.length == unixTimes.length);
147 
148         for(uint j = 0; j < targets.length; j++){
149             unlockUnixTime[targets[j]] = unixTimes[j];
150             LockedUp(targets[j], unixTimes[j]);
151         }
152     }
153 
154     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
155         require(
156           _value > 0
157           && frozenAccount[msg.sender] == false
158           && frozenAccount[_to] == false
159           && now > unlockUnixTime[msg.sender]
160           && now > unlockUnixTime[_to]
161         );
162         if (isContract(_to)) {
163             require(balanceOf[msg.sender] >= _value);
164             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
165             balanceOf[_to] = balanceOf[_to].add(_value);
166             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
167             Transfer(msg.sender, _to, _value);
168             Transfer(msg.sender, _to, _value);
169             return true;
170         } else {
171             return transferToAddress(_to, _value, _data);
172         }
173     }
174 
175     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
176         require(
177           _value > 0
178           && frozenAccount[msg.sender] == false
179           && frozenAccount[_to] == false
180           && now > unlockUnixTime[msg.sender]
181           && now > unlockUnixTime[_to]
182         );
183         if (isContract(_to)) {
184             return transferToContract(_to, _value, _data);
185         } else {
186             return transferToAddress(_to, _value, _data);
187         }
188     }
189 
190     function transfer(address _to, uint _value) public returns (bool success) {
191         require(_value > 0
192                 && frozenAccount[msg.sender] == false
193                 && frozenAccount[_to] == false
194                 && now > unlockUnixTime[msg.sender]
195                 && now > unlockUnixTime[_to]);
196 
197         bytes memory empty;
198         if (isContract(_to)) {
199             return transferToContract(_to, _value, empty);
200         } else {
201             return transferToAddress(_to, _value, empty);
202         }
203     }
204 
205     function isContract(address _addr) private view returns (bool is_contract) {
206         uint length;
207         assembly {
208             //retrieve the size of the code on target address, this needs assembly
209             length := extcodesize(_addr)
210         }
211         return (length > 0);
212     }
213 
214     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
215         require(balanceOf[msg.sender] >= _value);
216         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
217         balanceOf[_to] = balanceOf[_to].add(_value);
218         Transfer(msg.sender, _to, _value);
219         Transfer(msg.sender, _to, _value);
220         return true;
221     }
222 
223     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
224         require(balanceOf[msg.sender] >= _value);
225         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
226         balanceOf[_to] = balanceOf[_to].add(_value);
227         ContractReceiver receiver = ContractReceiver(_to);
228         receiver.tokenFallback(msg.sender, _value, _data);
229         Transfer(msg.sender, _to, _value);
230         Transfer(msg.sender, _to, _value);
231         return true;
232     }
233 
234     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
235         require(_to != address(0)
236                 && _value > 0
237                 && balanceOf[_from] >= _value
238                 && allowance[_from][msg.sender] >= _value
239                 && frozenAccount[_from] == false
240                 && frozenAccount[_to] == false
241                 && now > unlockUnixTime[_from]
242                 && now > unlockUnixTime[_to]);
243 
244         balanceOf[_from] = balanceOf[_from].sub(_value);
245         balanceOf[_to] = balanceOf[_to].add(_value);
246         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
247         Transfer(_from, _to, _value);
248         return true;
249     }
250 
251     function approve(address _spender, uint256 _value) public returns (bool success) {
252         allowance[msg.sender][_spender] = _value;
253         Approval(msg.sender, _spender, _value);
254         return true;
255     }
256 
257     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
258         return allowance[_owner][_spender];
259     }
260 
261     function burn(address _from, uint256 _unitAmount) onlyOwner public {
262         require(_unitAmount > 0
263                 && balanceOf[_from] >= _unitAmount);
264 
265         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
266         totalSupply = totalSupply.sub(_unitAmount);
267         Burn(_from, _unitAmount);
268     }
269 
270     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
271         require(addresses.length > 0
272                 && addresses.length == amounts.length
273                 && frozenAccount[msg.sender] == false
274                 && now > unlockUnixTime[msg.sender]);
275 
276         uint256 totalAmount = 0;
277 
278         for(uint j = 0; j < addresses.length; j++){
279             require(amounts[j] > 0
280                     && addresses[j] != 0x0
281                     && frozenAccount[addresses[j]] == false
282                     && now > unlockUnixTime[addresses[j]]);
283 
284             amounts[j] = amounts[j].mul(1e8);
285             totalAmount = totalAmount.add(amounts[j]);
286         }
287         require(balanceOf[msg.sender] >= totalAmount);
288 
289         for (j = 0; j < addresses.length; j++) {
290             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
291             Transfer(msg.sender, addresses[j], amounts[j]);
292         }
293         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
294         return true;
295     }
296 
297     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
298         require(addresses.length > 0 && addresses.length == amounts.length);
299         uint256 totalAmount = 0;
300 
301         for (uint j = 0; j < addresses.length; j++) {
302             require(amounts[j] > 0
303                     && addresses[j] != 0x0
304                     && frozenAccount[addresses[j]] == false
305                     && now > unlockUnixTime[addresses[j]]);
306 
307             amounts[j] = amounts[j].mul(1e8);
308             require(balanceOf[addresses[j]] >= amounts[j]);
309             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
310             totalAmount = totalAmount.add(amounts[j]);
311             Transfer(addresses[j], msg.sender, amounts[j]);
312         }
313         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
314         return true;
315     }
316 
317     function() payable public { }
318 
319 }