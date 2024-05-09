1 /* Copernic Space Cryptocurrency Token  */
2 /*     Released on 11.11.2018 v.1.1     */
3 /*   To celebrate 100 years of Polish   */
4 /*             INDEPENDENCE             */
5 /* ==================================== */
6 /* National Independence Day is a       */
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
20 pragma solidity 0.5.0;
21 
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         require(c / a == b);
29         return c;
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0);
33         uint256 c = a / b;
34         return c;
35     }
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39         return c;
40     }
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a);
44         return c;
45     }
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0);
48         return a % b;
49     }
50 }
51 
52 contract ERC223Interface {
53     function balanceOf(address who) public view returns (uint);
54     function transfer(address _to, uint _value) public returns (bool);
55     function transfer(address _to, uint _value, bytes memory _data) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint value, bytes data);
57 }
58 
59 contract ERC223ReceivingContract {
60     function tokenFallback(address _from, uint _value, bytes memory _data) public;
61 }
62 
63 contract Ownable {
64     address private _owner;
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69     constructor() internal {
70         _owner = msg.sender;
71         emit OwnershipTransferred(address(0), _owner);
72     }
73     function owner() public view returns (address) {
74         return _owner;
75     }
76     modifier onlyOwner() {
77         require(isOwner());
78         _;
79     }
80     function isOwner() public view returns (bool) {
81         return msg.sender == _owner;
82     }
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87     function transferOwnership(address newOwner) public onlyOwner {
88         _transferOwnership(newOwner);
89     }
90     function _transferOwnership(address newOwner) internal {
91         require(newOwner != address(0));
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 contract Pausable is Ownable {
98     event Paused(address account);
99     event Unpaused(address account);
100     bool private _paused;
101     constructor() internal {
102         _paused = false;
103     }
104     function paused() public view returns (bool) {
105         return _paused;
106     }
107     modifier whenNotPaused() {
108         require(!_paused);
109         _;
110     }
111     modifier whenPaused() {
112         require(_paused);
113         _;
114     }
115     function pause() public onlyOwner whenNotPaused {
116         _paused = true;
117         emit Paused(msg.sender);
118     }
119     function unpause() public onlyOwner whenPaused {
120         _paused = false;
121         emit Unpaused(msg.sender);
122     }
123 }
124 
125 
126 interface IERC20 {
127     function totalSupply() external pure returns (uint256);
128     function balanceOf(address who) external view returns (uint256);
129     function allowance(address owner, address spender)
130     external view returns (uint256);
131     function transfer(address to, uint256 value) external returns (bool);
132     function approve(address spender, uint256 value)
133     external returns (bool);
134     function transferFrom(address from, address to, uint256 value)
135     external returns (bool);
136     event Transfer(
137         address indexed from,
138         address indexed to,
139         uint256 value
140     );
141     event Approval(
142         address indexed owner,
143         address indexed spender,
144         uint256 value
145     );
146 }
147 
148 contract CPRToken is IERC20, ERC223Interface, Ownable, Pausable {
149     using SafeMath for uint;
150     mapping(address => uint) balances;
151     mapping(address => mapping(address => uint256)) private _allowed;
152     string  private constant        _name = "Copernic";
153     string  private constant      _symbol = "CPR";
154     uint8   private constant    _decimals = 6;
155     uint256 private constant _totalSupply = 40000000 * (10 ** 6);
156     constructor() public {
157         balances[msg.sender] = balances[msg.sender].add(_totalSupply);
158         emit Transfer(address(0), msg.sender, _totalSupply);
159     }
160     function totalSupply() public pure returns (uint256) {
161         return _totalSupply;
162     }
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169     function decimals() public pure returns (uint8) {
170         return _decimals;
171     }
172     function balanceOf(address _owner) public view returns (uint balance) {
173         return balances[_owner];
174     }
175     function allowance(address owner, address spender) public view returns (uint256)
176     {
177         return _allowed[owner][spender];
178     }
179     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool)
180     {
181         require(spender != address(0));
182         _allowed[msg.sender][spender] = (
183         _allowed[msg.sender][spender].add(addedValue));
184         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
185         return true;
186     }
187     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool)
188     {
189         require(spender != address(0));
190         _allowed[msg.sender][spender] = (
191         _allowed[msg.sender][spender].sub(subtractedValue));
192         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
193         return true;
194     }    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
195         require(spender != address(0));
196         _allowed[msg.sender][spender] = value;
197         emit Approval(msg.sender, spender, value);
198         return true;
199     }
200     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
201         require(_value <= balances[_from]);
202         require(_value <= _allowed[_from][msg.sender]);
203         require(_to != address(0));
204         require(balances[_to] + _value > balances[_to]);
205         balances[_from] = balances[_from].sub(_value);
206         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208         uint codeLength;
209         bytes memory empty;
210         assembly {
211             codeLength := extcodesize(_to)
212         }
213         if (codeLength > 0) {
214             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
215             receiver.tokenFallback(_from, _value, empty);
216         }
217         emit Transfer(_from, _to, _value);
218         emit Transfer(_from, _to, _value, empty);
219         return true;
220     }
221     function transfer(address _to, uint _value, bytes memory _data) public whenNotPaused returns (bool) {
222         if (isContract(_to)) {
223             return transferToContract(_to, _value, _data);
224         } else {
225             return transferToAddress(_to, _value, _data);
226         }
227     }
228     function transferToAddress(address _to, uint _value, bytes memory _data) internal returns (bool success) {
229         require(_value <= balances[msg.sender]);
230         require(_to != address(0));
231         require(balances[_to] + _value > balances[_to]);
232         balances[msg.sender] -= _value;
233         balances[_to] += _value;
234         emit Transfer(msg.sender, _to, _value);
235         emit Transfer(msg.sender, _to, _value, _data);
236         return true;
237     }
238     function transferToContract(address _to, uint _value, bytes memory _data) internal returns (bool success) {
239         require(_value <= balances[msg.sender]);
240         require(_to != address(0));
241         require(balances[_to] + _value > balances[_to]);
242         balances[msg.sender] -= _value;
243         balances[_to] += _value;
244         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
245         receiver.tokenFallback(msg.sender, _value, _data);
246         emit Transfer(msg.sender, _to, _value);
247         emit Transfer(msg.sender, _to, _value, _data);
248         return true;
249     }
250     function isContract(address _address) internal view returns (bool is_contract) {
251         uint length;
252         if (_address == address(0)) return false;
253         assembly {
254             length := extcodesize(_address)
255         }
256         if (length > 0) {
257             return true;
258         } else {
259             return false;
260         }
261     }
262     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
263         bytes memory empty;
264         if (isContract(_to)) {
265             return transferToContract(_to, _value, empty);
266         } else {
267             return transferToAddress(_to, _value, empty);
268         }
269         return true;
270     }
271     struct TKN {
272         address sender;
273         uint value;
274         bytes data;
275         bytes4 sig;
276     }
277     function tokenFallback(address _from, uint _value, bytes memory _data) pure public {
278         TKN memory tkn;
279         tkn.sender = _from;
280         tkn.value = _value;
281         tkn.data = _data;
282         uint32 u = uint32(uint8(_data[3])) + (uint32(uint8(_data[2])) << 8) + (uint32(uint8(_data[1])) << 16) + (uint32(uint8(_data[0])) << 24);
283         tkn.sig = bytes4(u);
284     }
285 }