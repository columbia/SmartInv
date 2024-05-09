1 contract Owned {
2     /// @dev `owner` is the only address that can call a function with this
3     /// modifier
4     modifier onlyOwner() {
5         require(msg.sender == owner) ;
6         _;
7     }
8 
9     address public owner;
10 
11     /// @notice The Constructor assigns the message sender to be `owner`
12     function Owned() {
13         owner = msg.sender;
14     }
15 
16     address public newOwner;
17 
18     /// @notice `owner` can step down and assign some other address to this role
19     /// @param _newOwner The address of the new owner. 0x0 can be used to create
20     ///  an unowned neutral vault, however that cannot be undone
21     function changeOwner(address _newOwner) onlyOwner {
22         newOwner = _newOwner;
23     }
24 
25     function acceptOwnership() {
26         if (msg.sender == newOwner) {
27             owner = newOwner;
28         }
29     }
30 }
31 
32 contract SafeMath {
33     
34     /*
35     standard uint256 functions
36      */
37 
38     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         assert((z = x + y) >= x);
40     }
41 
42     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
43         assert((z = x - y) <= x);
44     }
45 
46     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
47         assert((z = x * y) >= x);
48     }
49 
50     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
51         z = x / y;
52     }
53 
54     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
55         return x <= y ? x : y;
56     }
57     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
58         return x >= y ? x : y;
59     }
60 
61     /*
62     uint128 functions (h is for half)
63      */
64 
65 
66     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
67         assert((z = x + y) >= x);
68     }
69 
70     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
71         assert((z = x - y) <= x);
72     }
73 
74     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
75         assert((z = x * y) >= x);
76     }
77 
78     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
79         z = x / y;
80     }
81 
82     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
83         return x <= y ? x : y;
84     }
85     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
86         return x >= y ? x : y;
87     }
88 
89 
90     /*
91     int256 functions
92      */
93 
94     function imin(int256 x, int256 y) constant internal returns (int256 z) {
95         return x <= y ? x : y;
96     }
97     function imax(int256 x, int256 y) constant internal returns (int256 z) {
98         return x >= y ? x : y;
99     }
100 
101     /*
102     WAD math
103      */
104 
105     uint128 constant WAD = 10 ** 18;
106 
107     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
108         return hadd(x, y);
109     }
110 
111     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
112         return hsub(x, y);
113     }
114 
115     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
116         z = cast((uint256(x) * y + WAD / 2) / WAD);
117     }
118 
119     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
120         z = cast((uint256(x) * WAD + y / 2) / y);
121     }
122 
123     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
124         return hmin(x, y);
125     }
126     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
127         return hmax(x, y);
128     }
129 
130     /*
131     RAY math
132      */
133 
134     uint128 constant RAY = 10 ** 27;
135 
136     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
137         return hadd(x, y);
138     }
139 
140     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
141         return hsub(x, y);
142     }
143 
144     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
145         z = cast((uint256(x) * y + RAY / 2) / RAY);
146     }
147 
148     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
149         z = cast((uint256(x) * RAY + y / 2) / y);
150     }
151 
152     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
153         // This famous algorithm is called "exponentiation by squaring"
154         // and calculates x^n with x as fixed-point and n as regular unsigned.
155         //
156         // It's O(log n), instead of O(n) for naive repeated multiplication.
157         //
158         // These facts are why it works:
159         //
160         //  If n is even, then x^n = (x^2)^(n/2).
161         //  If n is odd,  then x^n = x * x^(n-1),
162         //   and applying the equation for even x gives
163         //    x^n = x * (x^2)^((n-1) / 2).
164         //
165         //  Also, EVM division is flooring and
166         //    floor[(n-1) / 2] = floor[n / 2].
167 
168         z = n % 2 != 0 ? x : RAY;
169 
170         for (n /= 2; n != 0; n /= 2) {
171             x = rmul(x, x);
172 
173             if (n % 2 != 0) {
174                 z = rmul(z, x);
175             }
176         }
177     }
178 
179     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
180         return hmin(x, y);
181     }
182     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
183         return hmax(x, y);
184     }
185 
186     function cast(uint256 x) constant internal returns (uint128 z) {
187         assert((z = uint128(x)) == x);
188     }
189 
190 }
191 contract ERC20Token {
192     /* This is a slight change to the ERC20 base standard.
193     function totalSupply() constant returns (uint256 supply);
194     is replaced with:
195     uint256 public totalSupply;
196     This automatically creates a getter function for the totalSupply.
197     This is moved to the base contract since public getter functions are not
198     currently recognised as an implementation of the matching abstract
199     function by the compiler.
200     */
201     /// total amount of tokens
202     uint256 public totalSupply;
203 
204     /// @param _owner The address from which the balance will be retrieved
205     /// @return The balance
206     function balanceOf(address _owner) constant returns (uint256 balance);
207 
208     /// @notice send `_value` token to `_to` from `msg.sender`
209     /// @param _to The address of the recipient
210     /// @param _value The amount of token to be transferred
211     /// @return Whether the transfer was successful or not
212     function transfer(address _to, uint256 _value) returns (bool success);
213 
214     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
215     /// @param _from The address of the sender
216     /// @param _to The address of the recipient
217     /// @param _value The amount of token to be transferred
218     /// @return Whether the transfer was successful or not
219     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
220 
221     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
222     /// @param _spender The address of the account able to transfer the tokens
223     /// @param _value The amount of tokens to be approved for transfer
224     /// @return Whether the approval was successful or not
225     function approve(address _spender, uint256 _value) returns (bool success);
226 
227     /// @param _owner The address of the account owning tokens
228     /// @param _spender The address of the account able to transfer the tokens
229     /// @return Amount of remaining tokens allowed to spent
230     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
231 
232     event Transfer(address indexed _from, address indexed _to, uint256 _value);
233     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
234 }
235 
236 contract StandardToken is ERC20Token {
237     function transfer(address _to, uint256 _value) returns (bool success) {
238         if (balances[msg.sender] >= _value && _value > 0) {
239             balances[msg.sender] -= _value;
240             balances[_to] += _value;
241             Transfer(msg.sender, _to, _value);
242             return true;
243         } else {
244             return false;
245         }
246     }
247 
248     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
249         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
250             balances[_to] += _value;
251             balances[_from] -= _value;
252             allowed[_from][msg.sender] -= _value;
253             Transfer(_from, _to, _value);
254             return true;
255         } else {
256             return false;
257         }
258     }
259 
260     function balanceOf(address _owner) constant returns (uint256 balance) {
261         return balances[_owner];
262     }
263 
264     function approve(address _spender, uint256 _value) returns (bool success) {
265         // To change the approve amount you first have to reduce the addresses`
266         //  allowance to zero by calling `approve(_spender,0)` if it is not
267         //  already 0 to mitigate the race condition described here:
268         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269         require ((_value==0) || (allowed[msg.sender][_spender] ==0));
270 
271         allowed[msg.sender][_spender] = _value;
272         Approval(msg.sender, _spender, _value);
273         return true;
274     }
275 
276     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
277         return allowed[_owner][_spender];
278     }
279 
280     mapping (address => uint256) public balances;
281     mapping (address => mapping (address => uint256)) allowed;
282 }
283 contract ATMToken is StandardToken, Owned {
284     // metadata
285     string public constant name = "Attention Token of Media";
286     string public constant symbol = "ATM";
287     string public version = "1.0";
288     uint256 public constant decimals = 8;
289     bool public disabled;
290     mapping(address => bool) public isATMHolder;
291     address[] public ATMHolders;
292     // constructor
293     function ATMToken(uint256 _amount) {
294         totalSupply = _amount; //设置当前ATM发行总量
295         balances[msg.sender] = _amount;
296     }
297 
298     function getATMTotalSupply() external constant returns(uint256) {
299         return totalSupply;
300     }
301     function getATMHoldersNumber() external constant returns(uint256) {
302         return ATMHolders.length;
303     }
304 
305     //在数据迁移时,需要先停止ATM交易
306     function setDisabled(bool flag) external onlyOwner {
307         disabled = flag;
308     }
309 
310     function transfer(address _to, uint256 _value) returns (bool success) {
311         require(!disabled);
312         if(isATMHolder[_to] == false){
313             isATMHolder[_to] = true;
314             ATMHolders.push(_to);
315         }
316         return super.transfer(_to, _value);
317     }
318 
319     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
320         require(!disabled);
321         if(isATMHolder[_to] == false){
322             isATMHolder[_to] = true;
323             ATMHolders.push(_to);
324         }
325         return super.transferFrom(_from, _to, _value);
326     }
327     function kill() external onlyOwner {
328         selfdestruct(owner);
329     }
330 }