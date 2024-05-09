1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17         return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60     address public owner;
61 
62 
63     event OwnershipRenounced(address indexed previousOwner);
64     event OwnershipTransferred(
65         address indexed previousOwner,
66         address indexed newOwner
67     );
68 
69 
70     /**
71     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72     * account.
73     */
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     /**
79     * @dev Throws if called by any account other than the owner.
80     */
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     /**
87     * @dev Allows the current owner to relinquish control of the contract.
88     * @notice Renouncing to ownership will leave the contract without an owner.
89     * It will not be possible to call the functions with the `onlyOwner`
90     * modifier anymore.
91     */
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipRenounced(owner);
94         owner = address(0);
95     }
96 
97     /**
98     * @dev Allows the current owner to transfer control of the contract to a newOwner.
99     * @param _newOwner The address to transfer ownership to.
100     */
101     function transferOwnership(address _newOwner) public onlyOwner {
102         _transferOwnership(_newOwner);
103     }
104 
105     /**
106     * @dev Transfers control of the contract to a newOwner.
107     * @param _newOwner The address to transfer ownership to.
108     */
109     function _transferOwnership(address _newOwner) internal {
110         require(_newOwner != address(0));
111         emit OwnershipTransferred(owner, _newOwner);
112         owner = _newOwner;
113     }
114 }
115 
116 
117 
118 /**
119  * @title ERC223
120  * @dev ERC223 contract interface with ERC20 functions and events
121  *      Fully backward compatible with ERC20
122  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
123  */
124 contract ERC223 {
125     uint public totalSupply;
126 
127     // ERC223 and ERC20 functions and events
128     function transfer(address to, uint value) public returns (bool ok);
129     function transfer(address to, uint value, bytes data) public returns (bool ok);
130     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
131 
132     // ERC20 functions and events
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
134     function approve(address _spender, uint256 _value) public returns (bool success);
135     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
136     event Transfer(address indexed _from, address indexed _to, uint256 _value);
137     event Approval(address indexed _owner, address indexed _spender, uint _value);
138 }
139 
140 
141 /**
142  * @title ContractReceiver
143  * @dev Contract that is working with ERC223 tokens
144  */
145  contract ContractReceiver {
146 
147     struct TKN {
148         address sender;
149         uint value;
150         bytes data;
151         bytes4 sig;
152     }
153 
154     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
155         TKN memory tkn;
156         tkn.sender = _from;
157         tkn.value = _value;
158         tkn.data = _data;
159         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
160         tkn.sig = bytes4(u);
161 
162         /*
163          * tkn variable is analogue of msg variable of Ether transaction
164          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
165          * tkn.value the number of tokens that were sent   (analogue of msg.value)
166          * tkn.data is data of token transaction   (analogue of msg.data)
167          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
168          */
169     }
170 }
171 
172 /**
173  * @title Ecoprotech
174  * @dev Ecoprotech is an ERC223 Token with ERC20 functions and events
175  *      Fully backward compatible with ERC20
176  */
177 contract Ecoprotech is ERC223, Ownable {
178     using SafeMath for uint256;
179 
180     string public constant name = "EXEES";
181     string public constant symbol = "EXE";
182     uint8 public constant decimals = 8;
183     uint256 public constant totalSupply = 2000000000000 * 10 ** 8;
184 
185     mapping(address => uint256) public balanceOf;
186     mapping(address => mapping (address => uint256)) public allowance;
187 
188     /**
189      * @dev Constructor is called only once and can not be called again
190      */
191     constructor(address _owner) public {
192 
193         address tokenSale = 0xbc9019f01acf8e508157ced0744168bf63e2ca50;              
194         address marketor1 = 0x4bed1dfa79183b0ea6b90abfdcbaf11a915c9abb;              
195         address marketor2 = 0x1069a6ba89f2eb70573658645a63afe95b47dff7;              
196         address organization = 0x6400e8f9f71d3b4d886098b19520f40502c5bbb6;           
197         address advisor = 0x62148bd0cf4d44fa045130aa39c2fcd6e7b70a20;                
198         address developer = 0xed45f100028964156800e2a24116196cd767d78b;              
199         address team = 0x2ca0da7ae78179600d476f0de59b8d22fd865bdf;                   
200         address seedInvestors = 0x13596d3bf16852b07696e535cad877d0665a6756;          
201 
202         initialize(tokenSale, 45);
203         initialize(marketor1, 15);
204         initialize(marketor2, 10);
205         initialize(organization, 8);
206         initialize(advisor, 7);
207         initialize(developer, 6);
208         initialize(team, 6);
209         initialize(seedInvestors, 3);
210 
211         owner = _owner;
212    }
213 
214     /**
215      * @dev allocate token to _address based on _ratio
216      * @param _address Address to initialize
217      * @param _ratio Ratio that is used to set the amount of token to _address
218      */
219     function initialize(address _address, uint256 _ratio) private {
220         uint256 tmpBalance = totalSupply.mul(_ratio).div(100);
221         balanceOf[_address] = tmpBalance;
222         emit Transfer(0x0, _address, tmpBalance);
223     }
224 
225     /**
226      * @dev Standard function transfer based on ERC223
227      */
228     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
229         require(_value > 0 && _to != address(0));
230 
231         if (isContract(_to)) {
232             return transferToContract(_to, _value, _data);
233         } else {
234             return transferToAddress(_to, _value, _data);
235         }
236     }
237 
238     /**
239      * @dev Standard function transfer similar to ERC20 transfer with no _data
240      *      Added due to backwards compatibility reasons
241      */
242     function transfer(address _to, uint _value) public returns (bool success) {
243         require(_value > 0 && _to != address(0));
244 
245         bytes memory empty;
246         if (isContract(_to)) {
247             return transferToContract(_to, _value, empty);
248         } else {
249             return transferToAddress(_to, _value, empty);
250         }
251     }
252 
253     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
254     function isContract(address _addr) private view returns (bool is_contract) {
255         uint length;
256         assembly {
257             //retrieve the size of the code on target address, this needs assembly
258             length := extcodesize(_addr)
259         }
260         return (length > 0);
261     }
262 
263     // function that is called when transaction target is an address
264     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
265         require(balanceOf[msg.sender] >= _value);
266         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
267         balanceOf[_to] = balanceOf[_to].add(_value);
268         emit Transfer(msg.sender, _to, _value, _data);
269         emit Transfer(msg.sender, _to, _value);
270         return true;
271     }
272 
273     // function that is called when transaction target is a contract
274     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
275         require(balanceOf[msg.sender] >= _value);
276         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
277         balanceOf[_to] = balanceOf[_to].add(_value);
278         ContractReceiver receiver = ContractReceiver(_to);
279         receiver.tokenFallback(msg.sender, _value, _data);
280         emit Transfer(msg.sender, _to, _value, _data);
281         emit Transfer(msg.sender, _to, _value);
282         return true;
283     }
284 
285     /**
286      * @dev Transfer tokens from one address to another
287      *      Added due to backwards compatibility with ERC20
288      * @param _from address The address which you want to send tokens from
289      * @param _to address The address which you want to transfer to
290      * @param _value uint256 the amount of tokens to be transferred
291      */
292     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
293         require(_to != address(0)
294                 && _value > 0
295                 && balanceOf[_from] >= _value
296                 && allowance[_from][msg.sender] >= _value);
297 
298         balanceOf[_from] = balanceOf[_from].sub(_value);
299         balanceOf[_to] = balanceOf[_to].add(_value);
300         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
301         emit Transfer(_from, _to, _value);
302         return true;
303     }
304 
305     /**
306      * @dev Allows _spender to spend no more than _value tokens in your behalf
307      *      Added due to backwards compatibility with ERC20
308      * @param _spender The address authorized to spend
309      * @param _value the max amount they can spend
310      */
311     function approve(address _spender, uint256 _value) public returns (bool success) {
312         allowance[msg.sender][_spender] = _value;
313         emit Approval(msg.sender, _spender, _value);
314         return true;
315     }
316 
317     /**
318      * @dev Function to check the amount of tokens that an owner allowed to a spender
319      *      Added due to backwards compatibility with ERC20
320      * @param _owner address The address which owns the funds
321      * @param _spender address The address which will spend the funds
322      */
323     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
324         return allowance[_owner][_spender];
325     }
326 }