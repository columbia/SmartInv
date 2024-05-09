1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     function Ownable() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) onlyOwner public {
45         require(newOwner != address(0));
46         OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 }
50 
51 contract ERC223 {
52     uint public totalSupply;
53 
54     function balanceOf(address who) public view returns (uint);
55     function totalSupply() public view returns (uint256 _supply);
56     function transfer(address to, uint value) public returns (bool ok);
57     function transfer(address to, uint value, bytes data) public returns (bool ok);
58     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
59     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
60 
61     function name() public view returns (string _name);
62     function symbol() public view returns (string _symbol);
63     function decimals() public view returns (uint8 _decimals);
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
66     function approve(address _spender, uint256 _value) public returns (bool success);
67     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint _value);
70 }
71 
72  contract ContractReceiver {
73 
74     struct TKN {
75         address sender;
76         uint value;
77         bytes data;
78         bytes4 sig;
79     }
80 
81     function tokenFallback(address _from, uint _value, bytes _data) public pure {
82         TKN memory tkn;
83         tkn.sender = _from;
84         tkn.value = _value;
85         tkn.data = _data;
86         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
87         tkn.sig = bytes4(u);
88     }
89 }
90 
91 contract WINMEDICSCOIN is ERC223, Ownable {
92     using SafeMath for uint256;
93 
94     string public name = "WinMedicsCoin";
95     string public symbol = "MEDIX";
96     uint8 public decimals = 18;
97     uint256 public totalSupply = 5e6 * 1e18;
98     uint256 public distributeAmount = 0;
99     bool public mintingFinished = false;
100     
101     mapping(address => uint256) public balanceOf;
102     mapping(address => mapping (address => uint256)) public allowance;
103     mapping (address => bool) public frozenAccount;
104     mapping (address => uint256) public unlockUnixTime;
105     
106     event FrozenFunds(address indexed target, bool frozen);
107     event LockedFunds(address indexed target, uint256 locked);
108     event Burn(address indexed from, uint256 amount);
109     event Mint(address indexed to, uint256 amount);
110     event MintFinished();
111 
112     function WINMEDICSCOIN() public {
113         balanceOf[msg.sender] = totalSupply;
114     }
115 
116     function name() public view returns (string _name) {
117         return name;
118     }
119 
120     function symbol() public view returns (string _symbol) {
121         return symbol;
122     }
123 
124     function decimals() public view returns (uint8 _decimals) {
125         return decimals;
126     }
127 
128     function totalSupply() public view returns (uint256 _totalSupply) {
129         return totalSupply;
130     }
131 
132     function balanceOf(address _owner) public view returns (uint256 balance) {
133         return balanceOf[_owner];
134     }
135 
136     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
137         require(targets.length > 0);
138 
139         for (uint j = 0; j < targets.length; j++) {
140             require(targets[j] != 0x0);
141             frozenAccount[targets[j]] = isFrozen;
142             FrozenFunds(targets[j], isFrozen);
143         }
144     }
145 
146     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
147         require(targets.length > 0
148                 && targets.length == unixTimes.length);
149                 
150         for(uint j = 0; j < targets.length; j++){
151             require(unlockUnixTime[targets[j]] < unixTimes[j]);
152             unlockUnixTime[targets[j]] = unixTimes[j];
153             LockedFunds(targets[j], unixTimes[j]);
154         }
155     }
156 
157     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
158         require(_value > 0
159                 && frozenAccount[msg.sender] == false 
160                 && frozenAccount[_to] == false
161                 && now > unlockUnixTime[msg.sender] 
162                 && now > unlockUnixTime[_to]);
163 
164         if (isContract(_to)) {
165             require(balanceOf[msg.sender] >= _value);
166             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
167             balanceOf[_to] = balanceOf[_to].add(_value);
168             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
169             Transfer(msg.sender, _to, _value, _data);
170             Transfer(msg.sender, _to, _value);
171             return true;
172         } else {
173             return transferToAddress(_to, _value, _data);
174         }
175     }
176 
177     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
178         require(_value > 0
179                 && frozenAccount[msg.sender] == false 
180                 && frozenAccount[_to] == false
181                 && now > unlockUnixTime[msg.sender] 
182                 && now > unlockUnixTime[_to]);
183 
184         if (isContract(_to)) {
185             return transferToContract(_to, _value, _data);
186         } else {
187             return transferToAddress(_to, _value, _data);
188         }
189     }
190 
191     function transfer(address _to, uint _value) public returns (bool success) {
192         require(_value > 0
193                 && frozenAccount[msg.sender] == false 
194                 && frozenAccount[_to] == false
195                 && now > unlockUnixTime[msg.sender] 
196                 && now > unlockUnixTime[_to]);
197 
198         bytes memory empty;
199         if (isContract(_to)) {
200             return transferToContract(_to, _value, empty);
201         } else {
202             return transferToAddress(_to, _value, empty);
203         }
204     }
205 
206     function isContract(address _addr) private view returns (bool is_contract) {
207         uint length;
208         assembly {
209             //retrieve the size of the code on target address, this needs assembly
210             length := extcodesize(_addr)
211         }
212         return (length > 0);
213     }
214 
215     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
216         require(balanceOf[msg.sender] >= _value);
217         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
218         balanceOf[_to] = balanceOf[_to].add(_value);
219         Transfer(msg.sender, _to, _value, _data);
220         Transfer(msg.sender, _to, _value);
221         return true;
222     }
223 
224     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
225         require(balanceOf[msg.sender] >= _value);
226         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
227         balanceOf[_to] = balanceOf[_to].add(_value);
228         ContractReceiver receiver = ContractReceiver(_to);
229         receiver.tokenFallback(msg.sender, _value, _data);
230         Transfer(msg.sender, _to, _value, _data);
231         Transfer(msg.sender, _to, _value);
232         return true;
233     }
234 
235     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
236         require(_to != address(0)
237                 && _value > 0
238                 && balanceOf[_from] >= _value
239                 && allowance[_from][msg.sender] >= _value
240                 && frozenAccount[_from] == false 
241                 && frozenAccount[_to] == false
242                 && now > unlockUnixTime[_from] 
243                 && now > unlockUnixTime[_to]);
244 
245         balanceOf[_from] = balanceOf[_from].sub(_value);
246         balanceOf[_to] = balanceOf[_to].add(_value);
247         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
248         Transfer(_from, _to, _value);
249         return true;
250     }
251 
252     function approve(address _spender, uint256 _value) public returns (bool success) {
253         allowance[msg.sender][_spender] = _value;
254         Approval(msg.sender, _spender, _value);
255         return true;
256     }
257 
258     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
259         return allowance[_owner][_spender];
260     }
261 
262     function burn(address _from, uint256 _unitAmount) onlyOwner public {
263         require(_unitAmount > 0
264                 && balanceOf[_from] >= _unitAmount);
265 
266         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
267         totalSupply = totalSupply.sub(_unitAmount);
268         Burn(_from, _unitAmount);
269     }
270 
271     modifier canMint() {
272         require(!mintingFinished);
273         _;
274     }
275 
276     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
277         require(_unitAmount > 0);
278         
279         totalSupply = totalSupply.add(_unitAmount);
280         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
281         Mint(_to, _unitAmount);
282         Transfer(address(0), _to, _unitAmount);
283         return true;
284     }
285 
286     function finishMinting() onlyOwner canMint public returns (bool) {
287         mintingFinished = true;
288         MintFinished();
289         return true;
290     }
291 
292     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
293         distributeAmount = _unitAmount;
294     }
295     
296     function autoDistribute() payable public {
297         require(distributeAmount > 0
298                 && balanceOf[owner] >= distributeAmount
299                 && frozenAccount[msg.sender] == false
300                 && now > unlockUnixTime[msg.sender]);
301         if(msg.value > 0) owner.transfer(msg.value);
302         
303         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
304         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
305         Transfer(owner, msg.sender, distributeAmount);
306     }
307 
308     function() payable public {
309         autoDistribute();
310      }
311 }