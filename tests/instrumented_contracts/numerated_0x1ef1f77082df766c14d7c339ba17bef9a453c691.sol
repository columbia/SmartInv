1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6 /**
7 * @dev Multiplies two unsigned integers, reverts on overflow.
8 */
9 
10     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
11 
12 	// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13 	// benefit is lost if 'b' is also tested.
14 	// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15 
16         if (_a == 0) {
17             return 0;
18 	}
19 
20         uint256 c = _a * _b;
21         require(c / _a == _b);
22         return c;
23     }
24 
25 /**
26 * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27 */
28 
29     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // Solidity only automatically asserts when dividing by 0
31         require(_b > 0);
32         uint256 c = _a / _b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37 /**
38 * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39 */
40 
41     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42         require(_b <= _a);
43         return _a - _b;
44     }
45 
46 /**
47 * @dev Adds two unsigned integers, reverts on overflow.
48 */
49 
50     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51         uint256 c = _a + _b;
52         require(c >= _a);
53         return c;
54     }
55 
56 /**
57 * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
58 * reverts when dividing by zero.
59 */
60 
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 
66 }
67 
68 
69 /*
70 * Ownable
71 *
72 * Base contract with an owner.
73 * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
74 */
75 
76 contract Ownable {
77     address public owner;
78     address public newOwner;
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor() public {
82         owner = msg.sender;
83         newOwner = address(0);
84     }
85 
86 // allows execution by the owner only
87 
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     modifier onlyNewOwner() {
94         require(msg.sender != address(0));
95         require(msg.sender == newOwner);
96         _;
97     }
98 
99 /**
100 *@dev allows transferring the contract ownership
101 *the new owner still needs to accept the transfer
102 *can only be called by the contract owner
103 *@param _newOwner new contract owner
104 */
105 
106     function transferOwnership(address _newOwner) public onlyOwner {
107         require(_newOwner != address(0));
108         newOwner = _newOwner;
109     }
110 
111 /**
112 *@dev used by a new owner to accept an ownership transfer
113 */
114 
115     function acceptOwnership() public onlyNewOwner returns(bool) {
116         emit OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119 
120 }
121 
122 
123 /*
124 *ERC20 Token interface
125 */
126 
127 contract ERC20 {
128     function totalSupply() public view returns (uint256);
129     function balanceOf(address who) public view returns (uint256);
130     function allowance(address owner, address spender) public view returns (uint256);
131     function transfer(address to, uint256 value) public returns (bool);
132     function transferFrom(address from, address to, uint256 value) public returns (bool);
133     function approve(address spender, uint256 value) public returns (bool);
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 }
137 
138 interface TokenRecipient {
139     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
140 }
141 
142 
143 contract TestCoin is ERC20, Ownable {
144     using SafeMath for uint256;
145     string public name;
146     string public symbol;
147     uint8 public decimals;
148     uint256 internal initialSupply;
149     uint256 internal totalSupply_;
150     mapping(address => uint256) internal balances;
151     mapping(address => bool) public frozen;
152     mapping(address => mapping(address => uint256)) internal allowed;
153 
154     event Burn(address indexed owner, uint256 value);
155     event Mint(uint256 value);
156     event Freeze(address indexed holder);
157     event Unfreeze(address indexed holder);
158 
159     modifier notFrozen(address _holder) {
160         require(!frozen[_holder]);
161         _;
162     }
163 
164     constructor() public {
165         name = "TestCoin";
166         symbol = "TTC";
167         decimals = 0;
168         initialSupply = 10000000000;
169         totalSupply_ = 10000000000;
170         balances[owner] = totalSupply_;
171         emit Transfer(address(0), owner, totalSupply_);
172     }
173 
174     function() public payable {
175         revert();
176     }
177 
178 /**
179 * @dev Total number of tokens in existence
180 */
181 
182     function totalSupply() public view returns (uint256) {
183         return totalSupply_;
184     }
185 
186 /**
187 * @dev Transfer token for a specified addresses
188 * @param _from The address to transfer from.
189 * @param _to The address to transfer to.
190 * @param _value The amount to be transferred.
191 */
192 
193     function _transfer(address _from, address _to, uint _value) internal {
194         require(_to != address(0));
195         require(_value <= balances[_from]);
196         require(_value <= allowed[_from][msg.sender]);
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200         emit Transfer(_from, _to, _value);
201     }
202 
203 /**
204 * @dev Transfer token for a specified address
205 * @param _to The address to transfer to.
206 * @param _value The amount to be transferred.
207 */
208 
209     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
210         require(_to != address(0));
211         require(_value <= balances[msg.sender]);
212         balances[msg.sender] = balances[msg.sender].sub(_value);
213         balances[_to] = balances[_to].add(_value);
214         emit Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218 /**
219 * @dev Gets the balance of the specified address.
220 * @param _holder The address to query the balance of.
221 * @return An uint256 representing the amount owned by the passed address.
222 */
223 
224     function balanceOf(address _holder) public view returns (uint256 balance) {
225         return balances[_holder];
226     }
227 
228 /**
229 * ERC20 Token Transfer
230 */
231 
232     function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public notFrozen(_from) returns (bool) {
233         uint256 _total;
234         _total = _value.add(_fee);
235         require(_to != address(0));
236         require(_total <= balances[_from]);
237         balances[msg.sender] = balances[msg.sender].add(_fee);
238         balances[_from] = balances[_from].sub(_total);
239         balances[_to] = balances[_to].add(_value);
240         emit Transfer(_from, _to, _value);
241         emit Transfer(_from, msg.sender, _fee);
242         //require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to])
243         return true;
244     }
245 
246 /**
247 * @dev Transfer tokens from one address to another.
248 * Note that while this function emits an Approval event, this is not required as per the specification,
249 * and other compliant implementations may not emit the event.
250 * @param _from address The address which you want to send tokens from
251 * @param _to address The address which you want to transfer to
252 * @param _value uint256 the amount of tokens to be transferred
253 */
254 
255     function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
256         require(_to != address(0));
257         require(_value <= balances[_from]);
258         require(_value <= allowed[_from][msg.sender]);
259         _transfer(_from, _to, _value);
260         return true;
261     }
262 
263 /**
264 * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.
265 * Beware that changing an allowance with this method brings the risk that someone may use both the old
266 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
267 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
268 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269 * @param _spender The address which will spend the funds.
270 * @param _value The amount of tokens to be spent.
271 */
272 
273     function approve(address _spender, uint256 _value) public returns (bool) {
274         allowed[msg.sender][_spender] = _value;
275         emit Approval(msg.sender, _spender, _value);
276         return true;
277     }
278 
279 /**
280 * @dev Function to check the amount of tokens that an _holder allowed to a spender.
281 * @param _holder address The address which owns the funds.
282 * @param _spender address The address which will spend the funds.
283 * @return A uint256 specifying the amount of tokens still available for the spender.
284 */
285 
286     function allowance(address _holder, address _spender) public view returns (uint256) {
287         return allowed[_holder][_spender];
288     }
289 
290 /**
291 * Freeze Account.
292 */
293 
294     function freezeAccount(address _holder) public onlyOwner returns (bool) {
295         require(!frozen[_holder]);
296         frozen[_holder] = true;
297         emit Freeze(_holder);
298         return true;
299     }
300 
301 /**
302 * Unfreeze Account.
303 */
304 
305     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
306         require(frozen[_holder]);
307         frozen[_holder] = false;
308         emit Unfreeze(_holder);
309         return true;
310     }
311 
312 /**
313 * Token Burn.
314 */
315 
316     function burn(uint256 _value) public onlyOwner returns (bool success) {
317         require(_value <= balances[msg.sender]);
318         address burner = msg.sender;
319         balances[burner] = balances[burner].sub(_value);
320         totalSupply_ = totalSupply_.sub(_value);
321         emit Burn(burner, _value);
322         emit Transfer(burner, address(0), _value);
323         return true;
324     }
325 
326 /**
327 * Token Mint.
328 */
329 
330     function mint(uint256 _amount) public onlyOwner returns (bool) {
331         totalSupply_ = totalSupply_.add(_amount);
332         balances[owner] = balances[owner].add(_amount);
333         emit Transfer(address(0), owner, _amount);
334         return true;
335     }
336 
337 /**
338 * @dev Internal function to determine if an address is a contract
339 * @param addr The address being queried
340 * @return True if `_addr` is a contract
341 */
342 
343     function isContract(address addr) internal view returns (bool) {
344         uint size;
345         assembly{size := extcodesize(addr)}
346         return size > 0;
347     }
348 
349 }