1 // File: openzeppelin-solidity\contracts\ownership\Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
77 
78 pragma solidity ^0.5.0;
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 interface IERC20 {
85     function transfer(address to, uint256 value) external returns (bool);
86 
87     function approve(address spender, uint256 value) external returns (bool);
88 
89     function transferFrom(address from, address to, uint256 value) external returns (bool);
90 
91     function totalSupply() external view returns (uint256);
92 
93     function balanceOf(address who) external view returns (uint256);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
103 
104 pragma solidity ^0.5.0;
105 
106 /**
107  * @title SafeMath
108  * @dev Unsigned math operations with safety checks that revert on error
109  */
110 library SafeMath {
111     /**
112     * @dev Multiplies two unsigned integers, reverts on overflow.
113     */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b);
124 
125         return c;
126     }
127 
128     /**
129     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
130     */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         // Solidity only automatically asserts when dividing by 0
133         require(b > 0);
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
142     */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         require(b <= a);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151     * @dev Adds two unsigned integers, reverts on overflow.
152     */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a);
156 
157         return c;
158     }
159 
160     /**
161     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
162     * reverts when dividing by zero.
163     */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         require(b != 0);
166         return a % b;
167     }
168 }
169 
170 // File: contracts\Furance.sol
171 
172 pragma solidity >=0.5.2;
173 
174 /**
175 This is hackathon edition of our Furance contract. Will be replaced with production version later.
176  */
177 
178 
179 
180 
181 
182 interface IPyroToken {
183   function mint(address, uint) external returns(bool);
184 }
185 
186 
187 contract Furance is Ownable {
188   event Burn(address indexed sender, address indexed token, uint value, uint pyroValue);
189   using SafeMath for uint;
190   
191   bool public extinguished;
192   uint public ashes;
193   IPyroToken public pyro;
194 
195   uint constant alpha = 999892503784850936; // decay per block corresponds 0.5 decay per day
196   uint constant DECIMAL_MULTIPLIER=1e18;
197   uint constant DECIMAL_HALFMULTIPLIER=1e9;
198 
199 
200   function _sqrt(uint x) internal pure returns (uint y) {
201     uint z = (x + 1) >> 1;
202     if ( x+1 == 0) z = 1<<255;
203     y = x;
204     while (z < y) {
205       y = z;
206       z = (x / z + z) >> 1;
207     }
208     y = y * DECIMAL_HALFMULTIPLIER;
209   }
210 
211   /* solium-disable-next-line */
212   function _pown(uint x, uint z) internal pure returns(uint) {
213     uint res = DECIMAL_MULTIPLIER;
214     uint t = z;
215     uint bit;
216     while (true) {
217       t = z >> 1;
218       bit = z - (t << 1);
219       if (bit == 1)
220         res = res.mul(x).div(DECIMAL_MULTIPLIER);
221       if (t==0) break;
222       z = t; 
223       x = x.mul(x).div(DECIMAL_MULTIPLIER);
224     }
225     return res;
226   }
227 
228 
229   struct token {
230     bool enabled;
231     uint a; //mintable performance parameter, depending for market capitalization
232     uint b; //tokens burned
233     uint c; //tokens minted
234     uint r; //burnrate
235     uint kappa_0; //initial kappa
236     uint w; //weight of initial kappa
237     uint blockNumber;
238   }
239 
240   mapping(address=>token) tokens;
241 
242   modifier notExitgushed {
243     require(!extinguished);
244     _;
245   }
246 
247   function exitgush() public onlyOwner notExitgushed returns(bool) {
248     extinguished=true;
249     return true;
250   }
251 
252 
253   function bind() public returns(bool) {
254     require(address(0) == address(pyro));
255     pyro = IPyroToken(msg.sender);
256     return true;
257   }
258 
259   function _kappa(token storage t) internal view returns(uint) {
260     return (t.c + t.kappa_0 * t.w / DECIMAL_MULTIPLIER) * DECIMAL_MULTIPLIER / (t.b + t.w);
261   }
262 
263 
264   function estimateMintAmount(address token_, uint value) public view returns(uint) {
265     token storage t = tokens[token_];
266     uint b_i = value;
267     uint r_is = t.r * _pown(alpha, block.number - t.blockNumber) / DECIMAL_MULTIPLIER;
268     uint r_i = r_is + value;
269     uint c_i = t.a*(_sqrt(r_i) - _sqrt(r_is))/ DECIMAL_MULTIPLIER;
270     uint kappa = _kappa(t);
271     if (c_i > b_i*kappa/DECIMAL_MULTIPLIER) c_i = b_i*kappa/DECIMAL_MULTIPLIER;
272     return c_i;
273   }
274 
275   function getTokenState(address token_) public view returns(uint, uint, uint, uint, uint, uint) {
276     token storage t = tokens[token_];
277     return (t.a, t.b, t.c, t.r, _kappa(t), t.blockNumber);
278   }
279 
280   function burn(address token_, uint value, uint minimalPyroValue) public notExitgushed returns (bool) {
281     require(value > 0);
282     require(IERC20(token_).transferFrom(msg.sender, address(this), value));
283     token storage t = tokens[token_];
284     require(t.enabled);
285     uint b_i = value;
286     uint r_is = t.r * _pown(alpha, block.number - t.blockNumber) / DECIMAL_MULTIPLIER;
287     uint r_i = r_is + b_i;
288     uint c_i = t.a*(_sqrt(r_i) - _sqrt(r_is)) / DECIMAL_MULTIPLIER;
289     uint kappa = _kappa(t);
290     if (c_i > b_i*kappa/DECIMAL_MULTIPLIER) c_i = b_i*kappa/DECIMAL_MULTIPLIER;
291     require(c_i >= minimalPyroValue);
292     t.b += b_i;
293     t.c += c_i;
294     t.r = r_i;
295     t.blockNumber = block.number;
296     if (IERC20(token_).balanceOf(msg.sender)==0) ashes+=1;
297     pyro.mint(msg.sender, c_i);
298     emit Burn(msg.sender, token_, b_i, c_i);
299     return true;
300   } 
301 
302   function addFuel(address token_, uint a, uint kappa0, uint w) public onlyOwner notExitgushed returns (bool) {
303     tokens[token_] = token(true, a, 0, 0, 0, kappa0, w, block.number);
304   }
305 
306 }