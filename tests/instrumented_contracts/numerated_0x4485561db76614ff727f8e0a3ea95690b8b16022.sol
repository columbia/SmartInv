1 pragma solidity 0.4.24;
2 
3 interface ERC20 {
4 
5     event Transfer(address indexed from, address indexed to, uint256 value);
6     event Approval(address indexed owner, address indexed spender, uint256 value);
7 
8     function transfer(address _to, uint256 _value) external returns (bool);
9     function approve(address _spender, uint256 _value) external returns (bool);
10     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address _who) external view returns (uint256);
13     function allowance(address _owner, address _spender) external view returns (uint256);
14 }
15 
16 /**
17  * @title ERC223Basic additions to ERC20Basic
18  * @dev see also: https://github.com/ethereum/EIPs/issues/223               
19  *
20 */
21 contract ERC223 is ERC20 {
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes indexed _data);
24 
25     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
26     function contractFallback(address _to, uint _value, bytes _data) internal returns (bool success);
27     function isContract(address _addr) internal view returns (bool);
28 }
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36     address private owner_;
37     event OwnershipRenounced(address indexed previousOwner);
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     /**
41     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42     * account.
43     */
44     constructor() public {
45         owner_ = msg.sender;
46     }
47 
48     /**
49     * @return the address of the owner.
50     */
51     function owner() public view returns(address) {
52         return owner_;
53     }
54 
55     /**
56     * @dev Throws if called by any account other than the owner.
57     */
58     modifier onlyOwner() {
59         require(msg.sender == owner_, "Only the owner can call this function.");
60         _;
61     }
62 
63     /**
64     * @dev Allows the current owner to relinquish control of the contract.
65     * @notice Renouncing to ownership will leave the contract without an owner.
66     * It will not be possible to call the functions with the `onlyOwner`
67     * modifier anymore.
68     */
69     function renounceOwnership() public onlyOwner {
70         emit OwnershipRenounced(owner_);
71         owner_ = address(0);
72     }
73 
74     /**
75     * @dev Allows the current owner to transfer control of the contract to a newOwner.
76     * @param _newOwner The address to transfer ownership to.
77     */
78     function transferOwnership(address _newOwner) public onlyOwner {
79         _transferOwnership(_newOwner);
80     }
81 
82     /**
83     * @dev Transfers control of the contract to a newOwner.
84     * @param _newOwner The address to transfer ownership to.
85     */
86     function _transferOwnership(address _newOwner) internal {
87         require(_newOwner != address(0), "Cannot transfer ownership to zero address.");
88         emit OwnershipTransferred(owner_, _newOwner);
89         owner_ = _newOwner;
90     }
91 }
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99     /**
100     * @dev Multiplies two numbers, throws on overflow.
101     */
102     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
103         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106         if (_a == 0) {
107             return 0;
108         }
109 
110         c = _a * _b;
111         assert(c / _a == _b);
112         return c;
113     }
114 
115     /**
116     * @dev Integer division of two numbers, truncating the quotient.
117     */
118     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
119         // assert(_b > 0); // Solidity automatically throws when dividing by 0
120         // uint256 c = _a / _b;
121         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
122         return _a / _b;
123     }
124 
125     /**
126     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127     */
128     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
129         assert(_b <= _a);
130         return _a - _b;
131     }
132 
133     /**
134     * @dev Adds two numbers, throws on overflow.
135     */
136     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
137         c = _a + _b;
138         assert(c >= _a);
139         return c;
140     }
141 }
142 
143 contract Generic223Receiver {
144     uint public sentValue;
145     address public tokenAddr;
146     address public tokenSender;
147     bool public calledFoo;
148 
149     bytes public tokenData;
150     bytes4 public tokenSig;
151 
152     Tkn private tkn;
153 
154     bool private __isTokenFallback;
155 
156     struct Tkn {
157         address addr;
158         address sender;
159         uint256 value;
160         bytes data;
161         bytes4 sig;
162     }
163 
164     modifier tokenPayable {
165         assert(__isTokenFallback);
166         _;
167     }
168 
169     function tokenFallback(address _sender, uint _value, bytes _data) public returns (bool success) {
170 
171         tkn = Tkn(msg.sender, _sender, _value, _data, getSig(_data));
172         __isTokenFallback = true;
173         address(this).delegatecall(_data);
174         __isTokenFallback = false;
175         return true;
176     }
177 
178     function foo() public tokenPayable {
179         saveTokenValues();
180         calledFoo = true;
181     }
182 
183     function getSig(bytes _data) private pure returns (bytes4 sig) {
184         uint lngth = _data.length < 4 ? _data.length : 4;
185         for (uint i = 0; i < lngth; i++) {
186             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (lngth - 1 - i))));
187         }
188     }
189 
190     function saveTokenValues() private {
191         tokenAddr = tkn.addr;
192         tokenSender = tkn.sender;
193         sentValue = tkn.value;
194         tokenSig = tkn.sig;
195         tokenData = tkn.data;
196     }
197 }
198 
199 contract InvoxFinanceToken is ERC223, Ownable {
200 
201     using SafeMath for uint256;
202 
203     string private name_ = "Invox Finance Token";
204     string private symbol_ = "INVOX";
205     uint256 private decimals_ = 18;
206     uint256 public totalSupply = 464000000 * (10 ** decimals_);
207 
208     event Transfer(address indexed from, address indexed to, uint256 value);
209     event Approval(address indexed owner, address indexed spender, uint256 value);
210     
211     mapping (address => uint256) internal balances_;
212     mapping (address => mapping (address => uint256)) private allowed_;
213 
214     constructor() public {
215         balances_[msg.sender] = balances_[msg.sender].add(totalSupply);
216         emit Transfer(address(0), msg.sender, totalSupply);
217     }
218 
219     function() public payable { revert("Cannot send ETH to this address."); }
220     
221     function name() public view returns(string) {
222         return name_;
223     }
224 
225     function symbol() public view returns(string) {
226         return symbol_;
227     }
228 
229     function decimals() public view returns(uint256) {
230         return decimals_;
231     }
232 
233     function totalSupply() public view returns (uint256) {
234         return totalSupply;
235     }
236 
237     function safeTransfer(address _to, uint256 _value) public {
238         require(transfer(_to, _value), "Transfer failed.");
239     }
240 
241     function safeTransferFrom(address _from, address _to, uint256 _value) public {
242         require(transferFrom(_from, _to, _value), "Transfer failed.");
243     }
244 
245     function safeApprove( address _spender, uint256 _currentValue, uint256 _value ) public {
246         require(allowed_[msg.sender][_spender] == _currentValue, "Current allowance value does not match.");
247         approve(_spender, _value);
248     }
249 
250     // ERC20
251     function balanceOf(address _owner) public view returns (uint256) {
252         return balances_[_owner];
253     }
254 
255     function allowance(address _owner, address _spender) public view returns (uint256) {
256         return allowed_[_owner][_spender];
257     }
258 
259     function transfer(address _to, uint256 _value) public returns (bool) {
260         require(_value <= balances_[msg.sender], "Value exceeds balance of msg.sender.");
261         require(_to != address(0), "Cannot send tokens to zero address.");
262 
263         balances_[msg.sender] = balances_[msg.sender].sub(_value);
264         balances_[_to] = balances_[_to].add(_value);
265         emit Transfer(msg.sender, _to, _value);
266         return true;
267     }
268 
269     function approve(address _spender, uint256 _value) public returns (bool) {
270         allowed_[msg.sender][_spender] = _value;
271         emit Approval(msg.sender, _spender, _value);
272         return true;
273     }
274 
275     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
276         require(_value <= balances_[_from], "Value exceeds balance of msg.sender.");
277         require(_value <= allowed_[_from][msg.sender], "Value exceeds allowance of msg.sender for this owner.");
278         require(_to != address(0), "Cannot send tokens to zero address.");
279 
280         balances_[_from] = balances_[_from].sub(_value);
281         balances_[_to] = balances_[_to].add(_value);
282         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
283         emit Transfer(_from, _to, _value);
284         return true;
285     }
286 
287     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
288         allowed_[msg.sender][_spender] = allowed_[msg.sender][_spender].add(_addedValue);
289         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
290         return true;
291     }
292 
293     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
294         uint256 oldValue = allowed_[msg.sender][_spender];
295         if (_subtractedValue >= oldValue) {
296             allowed_[msg.sender][_spender] = 0;
297         } else {
298             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299         }
300         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
301         return true;
302     }
303 
304     // ERC223
305     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
306         require(_to != address(0), "Cannot transfer token to zero address.");
307         require(_value <= balanceOf(msg.sender), "Value exceeds balance of msg.sender.");
308         
309         transfer(_to, _value);
310 
311         if (isContract(_to)) {
312             return contractFallback(_to, _value, _data);
313         }
314         return true;
315     }
316 
317     function contractFallback(address _to, uint _value, bytes _data) internal returns (bool success) {
318         Generic223Receiver receiver = Generic223Receiver(_to);
319         return receiver.tokenFallback(msg.sender, _value, _data);
320     }
321 
322     // Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
323     function isContract(address _addr) internal view returns (bool) {
324         // retrieve the size of the code on target address, this needs assembly
325         uint length;
326         assembly { length := extcodesize(_addr) }
327         return length > 0;
328     }
329 }