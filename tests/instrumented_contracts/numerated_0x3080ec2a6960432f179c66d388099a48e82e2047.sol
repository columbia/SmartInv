1 pragma solidity 0.5.17;
2 library SafeMath {
3     /**
4      * @dev Returns the addition of two unsigned integers, reverting on
5      * overflow.
6      *
7      * Counterpart to Solidity's `+` operator.
8      *
9      * Requirements:
10      *
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19  
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      *
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      *
59      * - Multiplication cannot overflow.
60      */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the integer division of two unsigned integers. Reverts on
77      * division by zero. The result is rounded towards zero.
78      *
79      * Counterpart to Solidity's `/` operator. Note: this function uses a
80      * `revert` opcode (which leaves remaining gas untouched) while Solidity
81      * uses an invalid opcode to revert (consuming all remaining gas).
82      *
83      * Requirements:
84      *
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
113      * Reverts when dividing by zero.
114      *
115      * Counterpart to Solidity's `%` operator. This function uses a `revert`
116      * opcode (which leaves remaining gas untouched) while Solidity uses an
117      * invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts with custom message when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 
146 interface ERC20 {
147     function totalSupply() external view returns (uint);
148     function balanceOf(address account) external view returns (uint);
149     function transfer(address, uint) external returns (bool);
150     function allowance(address owner, address spender) external view returns (uint);
151     function approve(address, uint) external returns (bool);
152     function transferFrom(address, address, uint) external returns (bool);
153     event Transfer(address indexed from, address indexed to, uint value);
154     event Approval(address indexed owner, address indexed spender, uint value);
155     }
156     
157 interface POWER {
158    
159    function scaledPower(uint amount) external returns(bool);
160    function totalPopping() external view returns (uint256);
161  } 
162 
163 interface OPERATORS {
164     
165    function scaledOperators(uint amount) external returns(bool);
166    function totalPopping() external view returns (uint256);
167    
168  }
169  
170     
171 //======================================POPCORN CONTRACT=========================================//
172 contract PopcornToken is ERC20 {
173     
174     using SafeMath for uint256;
175     
176 //======================================POPCORN EVENTS=========================================//
177  
178     event BurnEvent(address indexed pool, address indexed burnaddress, uint amount);
179     event AddCornEvent(address indexed _from, address indexed pool, uint value);
180     
181    
182     
183     
184    // ERC-20 Parameters
185     string public name; 
186     string public symbol;
187     uint public decimals; 
188     uint public totalSupply;
189     
190     
191      //======================================POPPING POOLS=========================================//
192     address public pool1;
193     address public pool2;
194 
195     uint256 public power;
196     uint256 public operators;
197     uint256 operatorstotalpopping;
198     uint256 powertotalpopping;
199     
200     // ERC-20 Mappings
201     mapping(address => uint) public  balanceOf;
202     mapping(address => mapping(address => uint)) public  allowance;
203     
204     
205     // Public Parameters
206     uint corns; 
207     uint  bValue;
208     uint  actualValue;
209     uint  burnAmount;
210     address administrator;
211  
212     
213      
214     // Public Mappings
215     mapping(address=>bool) public Whitelisted;
216     
217 
218     //=====================================CREATION=========================================//
219     // Constructor
220     constructor() public {
221         name = "Popcorn Token"; 
222         symbol = "CORN"; 
223         decimals = 18; 
224         corns = 1*10**decimals; 
225         totalSupply = 2000000*corns;                                 
226         
227          
228         administrator = msg.sender;
229         balanceOf[administrator] = totalSupply; 
230         emit Transfer(administrator, address(this), totalSupply);                                 
231                                                           
232         Whitelisted[administrator] = true;                                         
233         
234         
235         
236     }
237     
238 //========================================CONFIGURATIONS=========================================//
239     
240        function machineries(address _power, address _operators) public onlyAdministrator returns (bool success) {
241    
242         pool1 = _power;
243         pool2 = _operators;
244         
245         return true;
246     }
247     
248     modifier onlyAdministrator() {
249         require(msg.sender == administrator, "Ownable: caller is not the owner");
250         _;
251     }
252     
253     modifier onlyOperators() {
254         require(msg.sender == pool2, "Authorization: Only the operators pool can call on this");
255         _;
256     }
257     
258     function whitelist(address _address) public onlyAdministrator returns (bool success) {
259        Whitelisted[_address] = true;
260         return true;
261     }
262     
263     function unwhitelist(address _address) public onlyAdministrator returns (bool success) {
264       Whitelisted[_address] = false;
265         return true;
266     }
267     
268     
269     function Burn(uint _amount) public returns (bool success) {
270        
271        require(balanceOf[msg.sender] >= _amount, "You do not have the amount of tokens you wanna burn in your wallet");
272        balanceOf[msg.sender] -= _amount;
273        totalSupply -= _amount;
274        emit BurnEvent(pool2, address(0x0), _amount);
275        return true;
276        
277     }
278     
279     
280    //========================================ERC20=========================================//
281     // ERC20 Transfer function
282     function transfer(address to, uint value) public  returns (bool success) {
283         _transfer(msg.sender, to, value);
284         return true;
285     }
286     
287     
288     // ERC20 Approve function
289     function approve(address spender, uint value) public  returns (bool success) {
290         allowance[msg.sender][spender] = value;
291         emit Approval(msg.sender, spender, value);
292         return true;
293     }
294     
295     
296     // ERC20 TransferFrom function
297     function transferFrom(address from, address to, uint value) public  returns (bool success) {
298         require(value <= allowance[from][msg.sender], 'Must not send more than allowance');
299         allowance[from][msg.sender] -= value;
300         _transfer(from, to, value);
301         return true;
302     }
303     
304   
305     
306     
307     function _transfer(address _from, address _to, uint _value) private {
308         
309         require(balanceOf[_from] >= _value, 'Must not send more than balance');
310         require(balanceOf[_to] + _value >= balanceOf[_to], 'Balance overflow');
311         
312         balanceOf[_from] -= _value;
313         if(Whitelisted[msg.sender]){ 
314         
315           actualValue = _value;
316           
317         }else{
318          
319         bValue = mulDiv(_value, 10, 100); 
320        
321         actualValue = _value.sub(bValue); 
322         
323         
324         power = mulDiv(bValue, 50, 100);
325         powertotalpopping = powerTotalPopping();
326         
327         if(powertotalpopping > 0){
328                     
329                 POWER(pool1).scaledPower(power);
330                 balanceOf[pool1] += power;
331                 emit AddCornEvent(_from, pool1, power);
332                 emit Transfer(_from, pool1, power);
333                 
334                 
335                     
336                 }else{
337                   
338                  totalSupply -= power; 
339                  emit BurnEvent(_from, address(0x0), power);
340                     
341         }
342         
343         
344         
345         operators = mulDiv(bValue, 30, 100);
346         operatorstotalpopping = OperatorsTotalPopping();
347         
348         if(operatorstotalpopping > 0){
349                     
350                 OPERATORS(pool2).scaledOperators(operators);
351                 balanceOf[pool2] += operators;
352                 emit AddCornEvent(_from, pool2, operators);
353                 emit Transfer(_from, pool2, operators);
354                 
355                     
356                 }else{
357                   
358                 totalSupply -= operators; 
359                 emit BurnEvent(_from, address(0x0), operators); 
360                     
361         }
362         
363         
364         
365         burnAmount = mulDiv(bValue, 20, 100);
366         totalSupply -= burnAmount;
367         emit BurnEvent(_from, address(0x0), burnAmount);
368        
369         }
370         
371         
372        
373        balanceOf[_to] += actualValue;
374        emit Transfer(_from, _to, _value);
375        
376        
377     }
378     
379  
380   
381   
382   
383     function powerTotalPopping() public view returns(uint){
384         
385         return POWER(pool1).totalPopping();
386        
387     }
388     
389     function OperatorsTotalPopping() public view returns(uint){
390         
391         return OPERATORS(pool2).totalPopping();
392        
393     }
394     
395    
396     
397      function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
398           (uint l, uint h) = fullMul (x, y);
399           assert (h < z);
400           uint mm = mulmod (x, y, z);
401           if (mm > l) h -= 1;
402           l -= mm;
403           uint pow2 = z & -z;
404           z /= pow2;
405           l /= pow2;
406           l += h * ((-pow2) / pow2 + 1);
407           uint r = 1;
408           r *= 2 - z * r;
409           r *= 2 - z * r;
410           r *= 2 - z * r;
411           r *= 2 - z * r;
412           r *= 2 - z * r;
413           r *= 2 - z * r;
414           r *= 2 - z * r;
415           r *= 2 - z * r;
416           return l * r;
417     }
418     
419      function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
420           uint mm = mulmod (x, y, uint (-1));
421           l = x * y;
422           h = mm - l;
423           if (mm < l) h -= 1;
424     }
425     
426    
427 }