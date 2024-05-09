1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract ERC20Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract Owned {
51     /// @dev `owner` is the only address that can call a function with this
52     /// modifier
53     modifier onlyOwner() {
54         require(msg.sender == owner) ;
55         _;
56     }
57 
58     address public owner;
59 
60     /// @notice The Constructor assigns the message sender to be `owner`
61     function Owned() {
62         owner = msg.sender;
63     }
64 
65     address public newOwner;
66 
67     /// @notice `owner` can step down and assign some other address to this role
68     /// @param _newOwner The address of the new owner. 0x0 can be used to create
69     ///  an unowned neutral vault, however that cannot be undone
70     function changeOwner(address _newOwner) onlyOwner {
71         newOwner = _newOwner;
72     }
73 
74     function acceptOwnership() {
75         if (msg.sender == newOwner) {
76             owner = newOwner;
77         }
78     }
79 }
80 
81 contract SafeMath {
82     
83     /*
84     standard uint256 functions
85      */
86 
87     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
88         assert((z = x + y) >= x);
89     }
90 
91     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
92         assert((z = x - y) <= x);
93     }
94 
95     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
96         assert((z = x * y) >= x);
97     }
98 
99     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
100         z = x / y;
101     }
102 
103     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
104         return x <= y ? x : y;
105     }
106     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
107         return x >= y ? x : y;
108     }
109 
110     /*
111     uint128 functions (h is for half)
112      */
113 
114 
115     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
116         assert((z = x + y) >= x);
117     }
118 
119     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
120         assert((z = x - y) <= x);
121     }
122 
123     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
124         assert((z = x * y) >= x);
125     }
126 
127     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
128         z = x / y;
129     }
130 
131     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
132         return x <= y ? x : y;
133     }
134     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
135         return x >= y ? x : y;
136     }
137 
138 
139     /*
140     int256 functions
141      */
142 
143     function imin(int256 x, int256 y) constant internal returns (int256 z) {
144         return x <= y ? x : y;
145     }
146     function imax(int256 x, int256 y) constant internal returns (int256 z) {
147         return x >= y ? x : y;
148     }
149 
150     /*
151     WAD math
152      */
153 
154     uint128 constant WAD = 10 ** 18;
155 
156     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
157         return hadd(x, y);
158     }
159 
160     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
161         return hsub(x, y);
162     }
163 
164     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
165         z = cast((uint256(x) * y + WAD / 2) / WAD);
166     }
167 
168     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
169         z = cast((uint256(x) * WAD + y / 2) / y);
170     }
171 
172     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
173         return hmin(x, y);
174     }
175     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
176         return hmax(x, y);
177     }
178 
179     /*
180     RAY math
181      */
182 
183     uint128 constant RAY = 10 ** 27;
184 
185     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
186         return hadd(x, y);
187     }
188 
189     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
190         return hsub(x, y);
191     }
192 
193     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
194         z = cast((uint256(x) * y + RAY / 2) / RAY);
195     }
196 
197     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
198         z = cast((uint256(x) * RAY + y / 2) / y);
199     }
200 
201     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
202         // This famous algorithm is called "exponentiation by squaring"
203         // and calculates x^n with x as fixed-point and n as regular unsigned.
204         //
205         // It's O(log n), instead of O(n) for naive repeated multiplication.
206         //
207         // These facts are why it works:
208         //
209         //  If n is even, then x^n = (x^2)^(n/2).
210         //  If n is odd,  then x^n = x * x^(n-1),
211         //   and applying the equation for even x gives
212         //    x^n = x * (x^2)^((n-1) / 2).
213         //
214         //  Also, EVM division is flooring and
215         //    floor[(n-1) / 2] = floor[n / 2].
216 
217         z = n % 2 != 0 ? x : RAY;
218 
219         for (n /= 2; n != 0; n /= 2) {
220             x = rmul(x, x);
221 
222             if (n % 2 != 0) {
223                 z = rmul(z, x);
224             }
225         }
226     }
227 
228     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
229         return hmin(x, y);
230     }
231     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
232         return hmax(x, y);
233     }
234 
235     function cast(uint256 x) constant internal returns (uint128 z) {
236         assert((z = uint128(x)) == x);
237     }
238 
239 }
240 
241 contract StandardToken is ERC20Token {
242     function transfer(address _to, uint256 _value) returns (bool success) {
243         if (balances[msg.sender] >= _value && _value > 0) {
244             balances[msg.sender] -= _value;
245             balances[_to] += _value;
246             Transfer(msg.sender, _to, _value);
247             return true;
248         } else {
249             return false;
250         }
251     }
252 
253     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
254         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
255             balances[_to] += _value;
256             balances[_from] -= _value;
257             allowed[_from][msg.sender] -= _value;
258             Transfer(_from, _to, _value);
259             return true;
260         } else {
261             return false;
262         }
263     }
264 
265     function balanceOf(address _owner) constant returns (uint256 balance) {
266         return balances[_owner];
267     }
268 
269     function approve(address _spender, uint256 _value) returns (bool success) {
270         // To change the approve amount you first have to reduce the addresses`
271         //  allowance to zero by calling `approve(_spender,0)` if it is not
272         //  already 0 to mitigate the race condition described here:
273         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
274         if ((_value!=0) && (allowed[msg.sender][_spender] !=0)) throw;
275 
276         allowed[msg.sender][_spender] = _value;
277         Approval(msg.sender, _spender, _value);
278         return true;
279     }
280 
281     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
282         return allowed[_owner][_spender];
283     }
284 
285     mapping (address => uint256) public balances;
286     mapping (address => mapping (address => uint256)) allowed;
287 }
288 
289 contract MHToken is StandardToken, Owned {
290     // metadata
291     string public constant name = "Medicine Health Token";
292     string public constant symbol = "MHT";
293     string public version = "1.0";
294     uint256 public constant decimals = 4;
295     bool public disabled;
296     mapping(address => bool) public isMHTHolder;
297     address[] public MHTHolders;
298     // constructor
299     function MHToken(uint256 _amount) {
300         totalSupply = _amount; 
301         balances[msg.sender] = _amount;
302     }
303 
304     function getMHTTotalSupply() external constant returns(uint256) {
305         return totalSupply;
306     }
307     function getMHTHoldersNumber() external constant returns(uint256) {
308         return MHTHolders.length;
309     }
310 
311     function setDisabled(bool flag) external onlyOwner {
312         disabled = flag;
313     }
314 
315     function transfer(address _to, uint256 _value) returns (bool success) {
316         require(!disabled);
317         if(isMHTHolder[_to] == false){
318             isMHTHolder[_to] = true;
319             MHTHolders.push(_to);
320         }
321         return super.transfer(_to, _value);
322     }
323 
324     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
325         require(!disabled);
326         if(isMHTHolder[_to] == false){
327             isMHTHolder[_to] = true;
328             MHTHolders.push(_to);
329         }
330         return super.transferFrom(_from, _to, _value);
331     }
332 }