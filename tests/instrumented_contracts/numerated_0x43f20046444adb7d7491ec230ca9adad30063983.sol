1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) public onlyOwner {
29     require(newOwner != address(0));
30     emit OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33 }
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/179
39  */
40 contract ERC20Basic {
41   function totalSupply() external view returns (uint256);
42   function balanceOf(address who) external view returns (uint256);
43   function transfer(address to, uint256 value) external returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address holder, address spender) external view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) external returns (bool);
54   function approve(address spender, uint256 value) external returns (bool);
55   event Approval(address indexed holder, address indexed spender, uint256 value);
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, throws on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     if (a == 0) {
69       return 0;
70     }
71     uint256 c = a * b;
72     require(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // require(b > 0); // Solidity automatically throws when dividing by 0
81     uint256 c = a / b;
82     // require(a == b * c + a % b); // There is no case in which this doesn't hold
83     return c;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     require(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     require(c >= a);
100     return c;
101   }
102 }
103 
104 contract SpindleToken is ERC20, Ownable {
105 
106     using SafeMath for uint256;
107 
108     string public constant name = 'SPINDLE';
109     string public constant symbol = 'SPD';
110     uint8 public constant decimals = 18;
111 
112     uint256 constant TOTAL_SPD = 10000000000;
113     uint256 constant TOTAL_SUPPLY = TOTAL_SPD * (uint256(10) ** decimals);
114 
115     uint64 constant ICO_START_TIME = 1526083200; // 2018-05-12
116     uint64 constant RELEASE_B = ICO_START_TIME + 30 days;
117     uint64 constant RELEASE_C = ICO_START_TIME + 60 days;
118     uint64 constant RELEASE_D = ICO_START_TIME + 90 days;
119     uint64 constant RELEASE_E = ICO_START_TIME + 180 days;
120     uint64 constant RELEASE_F = ICO_START_TIME + 270 days;
121     uint64[] RELEASE = new uint64[](6);
122 
123     mapping(address => uint256[6]) balances;
124     mapping(address => mapping(address => uint256)) allowed;
125 
126     /**
127      * @dev Constructor that gives msg.sender all of existing tokens.
128      */
129     function SpindleToken() public {
130         RELEASE[0] = ICO_START_TIME;
131         RELEASE[1] = RELEASE_B;
132         RELEASE[2] = RELEASE_C;
133         RELEASE[3] = RELEASE_D;
134         RELEASE[4] = RELEASE_E;
135         RELEASE[5] = RELEASE_F;
136 
137         balances[msg.sender][0] = TOTAL_SUPPLY;
138         emit Transfer(0x0, msg.sender, TOTAL_SUPPLY);
139     }
140 
141     /**
142      * @dev total number of tokens in existence
143      */
144     function totalSupply() external view returns (uint256) {
145         return TOTAL_SUPPLY;
146     }
147 
148     /**
149      * @dev transfer token for a specified address
150      * @param _to The address to transfer to.
151      * @param _value The amount to be transferred.
152     */
153     function transfer(address _to, uint256 _value) external returns (bool) {
154         require(_to != address(0));
155         require(_to != address(this));
156         _updateLockUpAmountOf(msg.sender);
157 
158         // SafeMath.sub will revert if there is not enough balance.
159         balances[msg.sender][0] = balances[msg.sender][0].sub(_value);
160         balances[_to][0] = balances[_to][0].add(_value);
161         emit Transfer(msg.sender, _to, _value);
162         return true;
163     }
164 
165     /**
166      * @dev Gets the payable balance of the specified address.
167      * @param _holder The address to query the the balance of.
168      * @return An uint256 representing the payable amount owned by the passed address.
169     */
170     function balanceOf(address _holder) external view returns (uint256) {
171         uint256[6] memory arr = lockUpAmountOf(_holder);
172         return arr[0];
173     }
174 
175     /**
176      * @dev Gets the lockUpAmount tuple of the specified address.
177      * @param _holder address The address to query the the balance of.
178      * @return An LockUpAmount representing the amount owned by the passed address.
179     */
180     function lockUpAmountOf(address _holder) public view returns (
181         uint256[6]
182     ) {
183         uint256[6] memory arr;
184         arr[0] = balances[_holder][0];
185         for (uint i = 1; i < RELEASE.length; i++) {
186             arr[i] = balances[_holder][i];
187             if(now >= RELEASE[i]){
188                 arr[0] = arr[0].add(balances[_holder][i]);
189                 arr[i] = 0;
190             }
191             else
192             {
193                 arr[i] = balances[_holder][i];
194             }
195         }
196         return arr;
197     }
198 
199     /**
200      * @dev update the lockUpAmount of _address.
201      * @param _address address The address updated the balances of.
202      */
203     function _updateLockUpAmountOf(address _address) internal {
204         uint256[6] memory arr = lockUpAmountOf(_address);
205 
206         for(uint8 i = 0;i < arr.length; i++){
207             balances[_address][i] = arr[i];
208         }
209     }
210 
211     /**
212      * @dev gets the strings of lockUpAmount of _address.
213      * @param _address address The address gets the string of lockUpAmount of.
214      */
215     function lockUpAmountStrOf(address _address) external view returns (
216         address Address,
217         string a,
218         string b,
219         string c,
220         string d,
221         string e,
222         string f
223     ) {
224         address __address = _address;
225         if(__address == address(0)) __address = msg.sender;
226 
227         uint256[6] memory arr = lockUpAmountOf(__address);
228 
229         return (
230             __address,
231             _uintToSPDStr(arr[0]),
232             _uintToSPDStr(arr[1]),
233             _uintToSPDStr(arr[2]),
234             _uintToSPDStr(arr[3]),
235             _uintToSPDStr(arr[4]),
236             _uintToSPDStr(arr[5])
237         );
238     }
239 
240     /**
241      * @dev gets the SPD_strings of a token amount.
242      * @param _amount The value of a token amount.
243      */
244     function _uintToSPDStr(uint256 _amount) internal pure returns (string) {
245         uint8 __tindex;
246         uint8 __sindex;
247         uint8 __left;
248         uint8 __right;
249         bytes memory __t = new bytes(30);  // '10000000000.000000000000000000'.length is 30 (max input)
250 
251         // set all bytes
252         for(__tindex = 29; ; __tindex--){  // last_index:29 to first_index:0
253             if(__tindex == 11){            // dot index
254                 __t[__tindex] = byte(46);  // byte of '.' is 46
255                 continue;
256             }
257             __t[__tindex] = byte(48 + _amount%10);  // byte of '0' is 48
258             _amount = _amount.div(10);
259             if(__tindex == 0) break;
260         }
261 
262         // calc the str region
263         for(__left = 0; __left < 10; __left++) {     // find the first index of non-zero byte.  return at least '0.xxxxx'
264             if(__t[__left]  != byte(48)) break;      // byte of '0' is 48
265         }
266         for(__right = 29; __right > 12; __right--){  // find the  last index of non-zero byte.  return at least 'xxxxx.0'
267             if(__t[__right] != byte(48)) break;      // byte of '0' is 48
268         }
269 
270         bytes memory __s = new bytes(__right - __left + 1 + 4); // allocatte __s[left..right] + ' SPD'
271 
272         // set and return
273         __sindex = 0;
274         for(__tindex = __left; __tindex <= __right; __tindex++){
275             __s[__sindex] = __t[__tindex];
276             __sindex++;
277         }
278 
279         __s[__sindex++] = byte(32);  // byte of ' ' is 32
280         __s[__sindex++] = byte(83);  // byte of 'S' is 83
281         __s[__sindex++] = byte(80);  // byte of 'P' is 80
282         __s[__sindex++] = byte(68);  // byte of 'D' is 68
283 
284         return string(__s);
285     }
286 
287     /**
288      * @dev Distribute tokens from owner address to another
289      * @param _to address The address which you want to transfer to
290      * @param _a uint256 the amount of A-type-tokens to be transferred
291      * ...
292      * @param _f uint256 the amount of F-type-tokens to be transferred
293      */
294     function distribute(address _to, uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e, uint256 _f) onlyOwner external returns (bool) {
295         require(_to != address(0));
296         _updateLockUpAmountOf(msg.sender);
297 
298         uint256 __total = 0;
299         __total = __total.add(_a);
300         __total = __total.add(_b);
301         __total = __total.add(_c);
302         __total = __total.add(_d);
303         __total = __total.add(_e);
304         __total = __total.add(_f);
305 
306         balances[msg.sender][0] = balances[msg.sender][0].sub(__total);
307 
308         balances[_to][0] = balances[_to][0].add(_a);
309         balances[_to][1] = balances[_to][1].add(_b);
310         balances[_to][2] = balances[_to][2].add(_c);
311         balances[_to][3] = balances[_to][3].add(_d);
312         balances[_to][4] = balances[_to][4].add(_e);
313         balances[_to][5] = balances[_to][5].add(_f);
314 
315         emit Transfer(msg.sender, _to, __total);
316         return true;
317     }
318 
319     /**
320      * @dev Transfer tokens from one address to another
321      * @param _from address The address which you want to send tokens from
322      * @param _to address The address which you want to transfer to
323      * @param _value uint256 the amount of tokens to be transferred
324      */
325     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
326         require(_to != address(0));
327         require(_to != address(this));
328         _updateLockUpAmountOf(_from);
329 
330         balances[_from][0] = balances[_from][0].sub(_value);
331         balances[_to][0] = balances[_to][0].add(_value);
332         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
333         emit Transfer(_from, _to, _value);
334         return true;
335     }
336 
337     /**
338      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
339      *
340      * Beware that changing an allowance with this method brings the risk that someone may use both the old
341      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
342      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
343      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344      * @param _spender The address which will spend the funds.
345      * @param _value The amount of tokens to be spent.
346      */
347     function approve(address _spender, uint256 _value) external returns (bool) {
348 
349         allowed[msg.sender][_spender] = _value;
350         emit Approval(msg.sender, _spender, _value);
351         return true;
352     }
353 
354     /**
355      * @dev Function to check the amount of tokens that an owner allowed to a spender.
356      * @param _holder address The address which owns the funds.
357      * @param _spender address The address which will spend the funds.
358      * @return A uint256 specifying the amount of tokens still available for the spender.
359     */
360     function allowance(address _holder, address _spender) external view returns (uint256) {
361         return allowed[_holder][_spender];
362     }
363 }