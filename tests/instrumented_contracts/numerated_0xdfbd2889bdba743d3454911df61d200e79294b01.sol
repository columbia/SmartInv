1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 contract ERC20Interface {
6     uint256 public totalSupply;
7 
8     function balanceOf(address _owner) public constant returns (uint256);
9     function transfer(address _to, uint256 _value) public returns (bool ok);
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok);
11     function approve(address _spender, uint256 _value) public returns (bool ok);
12     function allowance(address _owner, address _spender) public constant returns (uint256);
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 // File: contracts/SafeMath.sol
19 
20 /**
21  * Math operations with safety checks
22  */
23 library SafeMath {
24     function multiply(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function divide(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b > 0);
32         uint256 c = a / b;
33         assert(a == b * c + a % b);
34         return c;
35     }
36 
37     function subtract(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a && c >= b);
45         return c;
46     }
47 }
48 
49 // File: contracts/StandardToken.sol
50 
51 contract StandardToken is ERC20Interface {
52     using SafeMath for uint256;
53 
54     /* Actual balances of token holders */
55     mapping(address => uint) balances;
56     /* approve() allowances */
57     mapping (address => mapping (address => uint)) allowed;
58 
59     /**
60      *
61      * Fix for the ERC20 short address attack
62      *
63      * http://vessenes.com/the-erc20-short-address-attack-explained/
64      */
65     modifier onlyPayloadSize(uint256 size) {
66         require(msg.data.length == size + 4);
67         _;
68     }
69 
70     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool ok) {
71         require(_to != address(0));
72         require(_value > 0);
73         uint256 holderBalance = balances[msg.sender];
74         require(_value <= holderBalance);
75 
76         balances[msg.sender] = holderBalance.subtract(_value);
77         balances[_to] = balances[_to].add(_value);
78 
79         emit Transfer(msg.sender, _to, _value);
80 
81         return true;
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {
85         require(_to != address(0));
86         uint256 allowToTrans = allowed[_from][msg.sender];
87         uint256 balanceFrom = balances[_from];
88         require(_value <= balanceFrom);
89         require(_value <= allowToTrans);
90 
91         balances[_from] = balanceFrom.subtract(_value);
92         balances[_to] = balances[_to].add(_value);
93         allowed[_from][msg.sender] = allowToTrans.subtract(_value);
94 
95         emit Transfer(_from, _to, _value);
96 
97         return true;
98     }
99 
100     /**
101      * @dev Returns balance of the `_owner`.
102      *
103      * @param _owner   The address whose balance will be returned.
104      * @return balance Balance of the `_owner`.
105      */
106     function balanceOf(address _owner) public constant returns (uint256) {
107         return balances[_owner];
108     }
109 
110     function approve(address _spender, uint256 _value) public returns (bool ok) {
111         // To change the approve amount you first have to reduce the addresses`
112         //  allowance to zero by calling `approve(_spender, 0)` if it is not
113         //  already 0 to mitigate the race condition described here:
114         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115         //    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
116         //    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
117         allowed[msg.sender][_spender] = _value;
118 
119         emit Approval(msg.sender, _spender, _value);
120 
121         return true;
122     }
123 
124     function allowance(address _owner, address _spender) public constant returns (uint256) {
125         return allowed[_owner][_spender];
126     }
127 
128     /**
129      * Atomic increment of approved spending
130      *
131      * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      *
133      */
134     function increaseApproval(address _spender, uint256 _addedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {
135         uint256 oldValue = allowed[msg.sender][_spender];
136         allowed[msg.sender][_spender] = oldValue.add(_addedValue);
137 
138         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139 
140         return true;
141     }
142 
143     /**
144      * Atomic decrement of approved spending.
145      *
146      * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      */
148     function decreaseApproval(address _spender, uint256 _subtractedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {
149         uint256 oldValue = allowed[msg.sender][_spender];
150         if (_subtractedValue > oldValue) {
151             allowed[msg.sender][_spender] = 0;
152         } else {
153             allowed[msg.sender][_spender] = oldValue.subtract(_subtractedValue);
154         }
155 
156         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157 
158         return true;
159     }
160 
161 }
162 
163 // File: contracts/BurnableToken.sol
164 
165 contract BurnableToken is StandardToken {
166     /**
167      * @dev Burns a specific amount of tokens.
168      * @param _value The amount of token to be burned.
169      */
170     function burn(uint256 _value) public {
171         _burn(msg.sender, _value);
172     }
173 
174     function _burn(address _holder, uint256 _value) internal {
175         require(_value <= balances[_holder]);
176 
177         balances[_holder] = balances[_holder].subtract(_value);
178         totalSupply = totalSupply.subtract(_value);
179 
180         emit Burn(_holder, _value);
181         emit Transfer(_holder, address(0), _value);
182     }
183 
184     event Burn(address indexed _burner, uint256 _value);
185 }
186 
187 // File: contracts/Ownable.sol
188 
189 /**
190  * @title Ownable
191  * @dev The Ownable contract has an owner address, and provides basic authorization control
192  * functions, this simplifies the implementation of "user permissions".
193  */
194 contract Ownable {
195     address public owner;
196     address public newOwner;
197 
198     /**
199      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200      * account.
201      */
202     constructor() public {
203         owner = msg.sender;
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(msg.sender == owner);
211         _;
212     }
213 
214     /**
215      * @dev Allows the current owner to transfer control of the contract to a newOwner.
216      * @param _newOwner The address to transfer ownership to.
217      */
218     function transferOwnership(address _newOwner) public onlyOwner {
219         newOwner = _newOwner;
220     }
221 
222     function acceptOwnership() public {
223         require(msg.sender == newOwner);
224 
225         owner = newOwner;
226         newOwner = address(0);
227 
228         emit OwnershipTransferred(owner, newOwner);
229     }
230 
231     event OwnershipTransferred(address indexed _from, address indexed _to);
232 }
233 
234 // File: contracts/ERC223Interface.sol
235 
236 contract ERC223Interface is ERC20Interface {
237     function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok);
238 
239     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes indexed _data);
240 }
241 
242 // File: contracts/ERC223ReceivingContract.sol
243 
244 contract ERC223ReceivingContract {
245     /**
246      * @dev Standard ERC223 function that will handle incoming token transfers.
247      *
248      * @param _from  Token sender address.
249      * @param _value Amount of tokens.
250      * @param _data  Transaction metadata.
251      */
252     function tokenFallback(address _from, uint256 _value, bytes _data) public;
253 }
254 
255 // File: contracts/Standard223Token.sol
256 
257 contract Standard223Token is ERC223Interface, StandardToken {
258     function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok) {
259         if (!super.transfer(_to, _value)) {
260             revert();
261         }
262         if (isContract(_to)) {
263             contractFallback(msg.sender, _to, _value, _data);
264         }
265 
266         emit Transfer(msg.sender, _to, _value, _data);
267 
268         return true;
269     }
270 
271     function transfer(address _to, uint256 _value) public returns (bool ok) {
272         return transfer(_to, _value, new bytes(0));
273     }
274 
275     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool ok) {
276         if (!super.transferFrom(_from, _to, _value)) {
277             revert();
278         }
279         if (isContract(_to)) {
280             contractFallback(_from, _to, _value, _data);
281         }
282 
283         emit Transfer(_from, _to, _value, _data);
284 
285         return true;
286     }
287 
288     function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {
289         return transferFrom(_from, _to, _value, new bytes(0));
290     }
291 
292     function contractFallback(address _origin, address _to, uint256 _value, bytes _data) private {
293         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
294         receiver.tokenFallback(_origin, _value, _data);
295     }
296 
297     function isContract(address _addr) private view returns (bool is_contract) {
298         uint256 length;
299         assembly {
300             length := extcodesize(_addr)
301         }
302 
303         return (length > 0);
304     }
305 }
306 
307 // File: contracts/ICOToken.sol
308 
309 // ----------------------------------------------------------------------------
310 // ICO Token contract
311 // ----------------------------------------------------------------------------
312 contract ICOToken is BurnableToken, Ownable, Standard223Token {
313     string public name;
314     string public symbol;
315     uint8 public decimals;
316 
317     // ------------------------------------------------------------------------
318     // Constructor
319     // ------------------------------------------------------------------------
320     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
321         name = _name;
322         symbol = _symbol;
323         decimals = _decimals;
324         totalSupply = _totalSupply;
325 
326         balances[owner] = totalSupply;
327 
328         emit Mint(owner, totalSupply);
329         emit Transfer(address(0), owner, totalSupply);
330         emit MintFinished();
331     }
332 
333     function () public payable {
334         revert();
335     }
336 
337     event Mint(address indexed _to, uint256 _amount);
338     event MintFinished();
339 }