1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 contract Ownable
68 {
69     bool private stopped;
70     address private _owner;
71     address private _master;
72 
73     event Stopped();
74     event Started();
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76     event MasterRoleTransferred(address indexed previousMaster, address indexed newMaster);
77 
78     constructor () internal
79     {
80         stopped = false;
81         _owner = msg.sender;
82         _master = msg.sender;
83         emit OwnershipTransferred(address(0), _owner);
84         emit MasterRoleTransferred(address(0), _master);
85     }
86 
87     function owner() public view returns (address)
88     {
89         return _owner;
90     }
91 
92     function master() public view returns (address)
93     {
94         return _master;
95     }
96 
97     modifier onlyOwner()
98     {
99         require(isOwner());
100         _;
101     }
102 
103     modifier onlyMaster()
104     {
105         require(isMaster() || isOwner());
106         _;
107     }
108 
109     modifier onlyWhenNotStopped()
110     {
111         require(!isStopped());
112         _;
113     }
114 
115     function isOwner() public view returns (bool)
116     {
117         return msg.sender == _owner;
118     }
119 
120     function isMaster() public view returns (bool)
121     {
122         return msg.sender == _master;
123     }
124 
125     function transferOwnership(address newOwner) external onlyOwner
126     {
127         _transferOwnership(newOwner);
128     }
129 
130     function transferMasterRole(address newMaster) external onlyOwner
131     {
132         _transferMasterRole(newMaster);
133     }
134 
135     function isStopped() public view returns (bool)
136     {
137         return stopped;
138     }
139 
140     function stop() public onlyOwner
141     {
142         _stop();
143     }
144 
145     function start() public onlyOwner
146     {
147         _start();
148     }
149 
150     function _transferOwnership(address newOwner) internal
151     {
152         require(newOwner != address(0));
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 
157     function _transferMasterRole(address newMaster) internal
158     {
159         require(newMaster != address(0));
160         emit MasterRoleTransferred(_master, newMaster);
161         _master = newMaster;
162     }
163 
164     function _stop() internal
165     {
166         emit Stopped();
167         stopped = true;
168     }
169 
170     function _start() internal
171     {
172         emit Started();
173         stopped = false;
174     }
175 }
176 
177 interface IERC20 {
178     function transfer(address to, uint256 value) external returns (bool);
179     function approve(address spender, uint256 value) external returns (bool);
180     function transferFrom(address from, address to, uint256 value) external returns (bool);
181     function totalSupply() external view returns (uint256);
182     function balanceOf(address who) external view returns (uint256);
183     function allowance(address owner, address spender) external view returns (uint256);
184 
185     event Transfer(address indexed from, address indexed to, uint256 value);
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 contract BaseToken is IERC20, Ownable
190 {
191     using SafeMath for uint256;
192 
193     mapping (address => uint256) public balances;
194     mapping (address => mapping ( address => uint256 )) public approvals;
195 
196     uint256 public totalTokenSupply;
197 
198     function totalSupply() view external returns (uint256)
199     {
200         return totalTokenSupply;
201     }
202 
203     function balanceOf(address _who) view external returns (uint256)
204     {
205         return balances[_who];
206     }
207 
208     function transfer(address _to, uint256 _value) external onlyWhenNotStopped returns (bool)
209     {
210         require(balances[msg.sender] >= _value);
211         require(_to != address(0));
212 
213         balances[msg.sender] = balances[msg.sender].sub(_value);
214         balances[_to] = balances[_to].add(_value);
215 
216         emit Transfer(msg.sender, _to, _value);
217 
218         return true;
219     }
220 
221     function approve(address _spender, uint256 _value) external onlyWhenNotStopped returns (bool)
222     {
223         require(balances[msg.sender] >= _value);
224 
225         approvals[msg.sender][_spender] = _value;
226 
227         emit Approval(msg.sender, _spender, _value);
228 
229         return true;
230     }
231 
232     function allowance(address _owner, address _spender) view external returns (uint256)
233     {
234         return approvals[_owner][_spender];
235     }
236 
237     function transferFrom(address _from, address _to, uint256 _value) external onlyWhenNotStopped returns (bool)
238     {
239         require(_from != address(0));
240         require(balances[_from] >= _value);
241         require(approvals[_from][msg.sender] >= _value);
242 
243         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
244         balances[_from] = balances[_from].sub(_value);
245         balances[_to]  = balances[_to].add(_value);
246 
247         emit Transfer(_from, _to, _value);
248 
249         return true;
250     }
251 }
252 
253 contract TestCToken is BaseToken
254 {
255     using SafeMath for uint256;
256 
257     string public name;
258     uint256 public decimals;
259     string public symbol;
260 
261     uint256 constant private E18 = 1000000000000000000;
262     uint256 constant private MAX_TOKEN_SUPPLY = 5000000000;
263 
264     event Deposit(address indexed from, address to, uint256 value);
265     event ReferralDrop(address indexed from, address indexed to1, uint256 value1, address indexed to2, uint256 value2);
266 
267     constructor() public
268     {
269         name        = 'Test-c';
270         decimals    = 18;
271         symbol      = 'TESTC';
272 
273         totalTokenSupply = MAX_TOKEN_SUPPLY * E18;
274 
275         balances[msg.sender] = totalTokenSupply;
276     }
277 
278     function deposit(address _to, uint256 _value) external returns (bool)
279     {
280         require(balances[msg.sender] >= _value);
281         require(_to != address(0));
282 
283         balances[msg.sender] = balances[msg.sender].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285 
286         emit Deposit(msg.sender, _to, _value);
287 
288         return true;
289     }
290 
291     function referralDrop2(address _to, uint256 _value, address _sale, uint256 _fee) external onlyWhenNotStopped returns (bool)
292     {
293         require(balances[msg.sender] >= _value + _fee);
294         require(_to != address(0));
295         require(_sale != address(0));
296 
297         balances[msg.sender] = balances[msg.sender].sub(_value + _fee);
298         balances[_to] = balances[_to].add(_value);
299         balances[_sale] = balances[_sale].add(_fee);
300 
301         emit ReferralDrop(msg.sender, _to, _value, address(0), 0);
302 
303         return true;
304     }
305 
306     function referralDrop3(address _to1, uint256 _value1, address _to2, uint256 _value2, address _sale, uint256 _fee) external onlyWhenNotStopped returns (bool)
307     {
308         require(balances[msg.sender] >= _value1 + _value2 + _fee);
309         require(_to1 != address(0));
310         require(_to2 != address(0));
311         require(_sale != address(0));
312 
313         balances[msg.sender] = balances[msg.sender].sub(_value1 + _value2 + _fee);
314         balances[_to1] = balances[_to1].add(_value1);
315         balances[_to2] = balances[_to2].add(_value2);
316         balances[_sale] = balances[_sale].add(_fee);
317 
318         emit ReferralDrop(msg.sender, _to1, _value1, _to2, _value2);
319 
320         return true;
321     }
322 }