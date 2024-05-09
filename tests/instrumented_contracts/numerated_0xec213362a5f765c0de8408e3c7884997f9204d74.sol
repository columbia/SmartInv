1 /* FOOToken                             */
2 /* Released on 11.11.2018 v.1.1         */
3 /* To celebrate 100 years of Polish     */
4 /* INDEPENDENCE                         */
5 /* ==================================== */
6 /* National Independence Day  is a      */
7 /* national day in Poland celebrated on */
8 /* 11 November to commemorate the       */
9 /* anniversary of the restoration of    */
10 /* Poland's sovereignty as the          */
11 /* Second Polish Republic in 1918 from  */
12 /* German, Austrian and Russian Empires */
13 /* Following the partitions in the late */
14 /* 18th century, Poland ceased to exist */
15 /* for 123 years until the end of       */
16 /* World War I, when the destruction of */
17 /* the neighbouring powers allowed the  */
18 /* country to reemerge.                 */
19 
20 library SafeMath {
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         require(c / a == b);
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0);
33         uint256 c = a / b;
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a);
46         return c;
47     }
48 
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b != 0);
51         return a % b;
52     }
53 }
54 
55 contract ERC223Interface {
56     function balanceOf(address who) public view returns (uint);
57 
58     function transfer(address _to, uint _value) public returns (bool);
59 
60     function transfer(address _to, uint _value, bytes memory _data) public returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint value, bytes data);
63 }
64 
65 contract ERC223ReceivingContract {
66     function tokenFallback(address _from, uint _value, bytes memory _data) public;
67 }
68 
69 contract Ownable {
70     address private _owner;
71 
72     event OwnershipTransferred(
73         address indexed previousOwner,
74         address indexed newOwner
75     );
76 
77     constructor() internal {
78         _owner = msg.sender;
79         emit OwnershipTransferred(address(0), _owner);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(isOwner());
88         _;
89     }
90 
91     function isOwner() public view returns (bool) {
92         return msg.sender == _owner;
93     }
94 
95     function renounceOwnership() public onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100     function transferOwnership(address newOwner) public onlyOwner {
101         _transferOwnership(newOwner);
102     }
103 
104     function _transferOwnership(address newOwner) internal {
105         require(newOwner != address(0));
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 contract Pausable is Ownable {
112     event Paused(address account);
113     event Unpaused(address account);
114 
115     bool private _paused;
116 
117     constructor() internal {
118         _paused = false;
119     }
120 
121     function paused() public view returns (bool) {
122         return _paused;
123     }
124 
125     modifier whenNotPaused() {
126         require(!_paused);
127         _;
128     }
129 
130     modifier whenPaused() {
131         require(_paused);
132         _;
133     }
134 
135     function pause() public onlyOwner whenNotPaused {
136         _paused = true;
137         emit Paused(msg.sender);
138     }
139 
140     function unpause() public onlyOwner whenPaused {
141         _paused = false;
142         emit Unpaused(msg.sender);
143     }
144 }
145 
146 interface IERC20 {
147     function totalSupply() external pure returns (uint256);
148 
149     function balanceOf(address who) external view returns (uint256);
150 
151     function allowance(address owner, address spender)
152     external view returns (uint256);
153 
154     function transfer(address to, uint256 value) external returns (bool);
155 
156     function approve(address spender, uint256 value)
157     external returns (bool);
158 
159     function transferFrom(address from, address to, uint256 value)
160     external returns (bool);
161 
162     event Transfer(
163         address indexed from,
164         address indexed to,
165         uint256 value
166     );
167 
168     event Approval(
169         address indexed owner,
170         address indexed spender,
171         uint256 value
172     );
173 }
174 
175 contract FOOToken is IERC20, ERC223Interface, Ownable, Pausable {
176     using SafeMath for uint;
177 
178     mapping(address => uint) balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowed;
181 
182     string  private constant        _name = "FOOToken";
183     string  private constant      _symbol = "FOOT";
184     uint8   private constant    _decimals = 6;
185     uint256 private constant _totalSupply = 100000000 * (10 ** 6);
186 
187     constructor() public {
188         balances[msg.sender] = balances[msg.sender].add(_totalSupply);
189         emit Transfer(address(0), msg.sender, _totalSupply);
190     }
191 
192     function totalSupply() public pure returns (uint256) {
193         return _totalSupply;
194     }
195 
196     function name() public pure returns (string memory) {
197         return _name;
198     }
199 
200     function symbol() public pure returns (string memory) {
201         return _symbol;
202     }
203 
204     function decimals() public pure returns (uint8) {
205         return _decimals;
206     }
207 
208     function balanceOf(address _owner) public view returns (uint balance) {
209         return balances[_owner];
210     }
211 
212     function allowance(address owner, address spender) public view returns (uint256)
213     {
214         return _allowed[owner][spender];
215     }
216 
217     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool)
218     {
219         require(spender != address(0));
220         _allowed[msg.sender][spender] = (
221         _allowed[msg.sender][spender].add(addedValue));
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool)
227     {
228         require(spender != address(0));
229         _allowed[msg.sender][spender] = (
230         _allowed[msg.sender][spender].sub(subtractedValue));
231         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232         return true;
233     }
234 
235     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
236         require(spender != address(0));
237         _allowed[msg.sender][spender] = value;
238         emit Approval(msg.sender, spender, value);
239         return true;
240     }
241 
242 
243     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
244         require(_value <= balances[_from]);
245         require(_value <= _allowed[_from][msg.sender]);
246         require(_to != address(0));
247         require(balances[_to] + _value > balances[_to]);
248         balances[_from] = balances[_from].sub(_value);
249         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
250         balances[_to] = balances[_to].add(_value);
251         uint codeLength;
252         bytes memory empty;
253         assembly {
254             codeLength := extcodesize(_to)
255         }
256         if (codeLength > 0) {
257             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
258             receiver.tokenFallback(_from, _value, empty);
259         }
260         emit Transfer(_from, _to, _value);
261         emit Transfer(_from, _to, _value, empty);
262         return true;
263     }
264 
265     function transfer(address _to, uint _value, bytes memory _data) public whenNotPaused returns (bool) {
266         if (isContract(_to)) {
267             return transferToContract(_to, _value, _data);
268         } else {
269             return transferToAddress(_to, _value, _data);
270         }
271     }
272 
273 
274     function transferToAddress(address _to, uint _value, bytes memory _data) internal returns (bool success) {
275         require(_value <= balances[msg.sender]);
276         require(_to != address(0));
277         require(balances[_to] + _value > balances[_to]);
278         balances[msg.sender] -= _value;
279         balances[_to] += _value;
280         emit Transfer(msg.sender, _to, _value);
281         emit Transfer(msg.sender, _to, _value, _data);
282         return true;
283     }
284 
285     function transferToContract(address _to, uint _value, bytes memory _data) internal returns (bool success) {
286         require(_value <= balances[msg.sender]);
287         require(_to != address(0));
288         require(balances[_to] + _value > balances[_to]);
289         balances[msg.sender] -= _value;
290         balances[_to] += _value;
291         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
292         receiver.tokenFallback(msg.sender, _value, _data);
293         emit Transfer(msg.sender, _to, _value);
294         emit Transfer(msg.sender, _to, _value, _data);
295         return true;
296     }
297 
298     function isContract(address _address) internal view returns (bool is_contract) {
299         uint length;
300         if (_address == address(0)) return false;
301         assembly {
302             length := extcodesize(_address)
303         }
304         if (length > 0) {
305             return true;
306         } else {
307             return false;
308         }
309     }
310 
311     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
312         bytes memory empty;
313         if (isContract(_to)) {
314             return transferToContract(_to, _value, empty);
315         } else {
316             return transferToAddress(_to, _value, empty);
317         }
318         return true;
319     }
320 
321     struct TKN {
322         address sender;
323         uint value;
324         bytes data;
325         bytes4 sig;
326     }
327 
328     function tokenFallback(address _from, uint _value, bytes memory _data) pure public {
329         TKN memory tkn;
330         tkn.sender = _from;
331         tkn.value = _value;
332         tkn.data = _data;
333         uint32 u = uint32(uint8(_data[3])) + (uint32(uint8(_data[2])) << 8) + (uint32(uint8(_data[1])) << 16) + (uint32(uint8(_data[0])) << 24);
334         tkn.sig = bytes4(u);
335     }
336 
337 }