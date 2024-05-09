1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18         return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
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
116 /**
117  * @title ERC223
118  * @dev ERC223 contract interface with ERC20 functions and events
119  *      Fully backward compatible with ERC20
120  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
121  */
122 contract ERC223 {
123     uint public totalSupply;
124 
125     // ERC223 and ERC20 functions and events
126     function transfer(address to, uint value) public returns (bool ok);
127     function transfer(address to, uint value, bytes data) public returns (bool ok);
128     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
129 
130     // ERC20 functions and events
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
132     function approve(address _spender, uint256 _value) public returns (bool success);
133     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
134     event Transfer(address indexed _from, address indexed _to, uint256 _value);
135     event Approval(address indexed _owner, address indexed _spender, uint _value);
136 }
137 
138 
139 /**
140  * @title ContractReceiver
141  * @dev Contract that is working with ERC223 tokens
142  */
143  contract ContractReceiver {
144 
145     struct TKN {
146         address sender;
147         uint value;
148         bytes data;
149         bytes4 sig;
150     }
151 
152     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
153         TKN memory tkn;
154         tkn.sender = _from;
155         tkn.value = _value;
156         tkn.data = _data;
157         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
158         tkn.sig = bytes4(u);
159 
160         /*
161          * tkn variable is analogue of msg variable of Ether transaction
162          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
163          * tkn.value the number of tokens that were sent   (analogue of msg.value)
164          * tkn.data is data of token transaction   (analogue of msg.data)
165          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
166          */
167     }
168 }
169 
170 
171 /**
172  * @title AIzen
173  * @dev AIzen is an ERC223 Token with ERC20 functions and events
174  *      Fully backward compatible with ERC20
175  */
176 contract AIzen is ERC223, Ownable {
177     using SafeMath for uint256;
178 
179     string public constant name = "AIzen";
180     string public constant symbol = "XAZ";
181     uint8 public constant decimals = 2;
182     uint256 public totalSupply = 50000000000 * 10 ** 2;
183 
184     bool public mintingFinished = false;
185     
186     mapping(address => uint256) public balanceOf;
187     mapping(address => mapping (address => uint256)) public allowance;
188         
189     event Mint(address indexed to, uint256 amount);
190     event Burn(address indexed from, uint256 amount);
191     event MintFinished();
192 
193     modifier canMint() {
194         require(!mintingFinished);
195         _;
196     }
197 
198     /**
199     * @dev constructor
200     */
201     constructor(address _owner) public {
202         
203         // set the owner address
204         owner = _owner;
205         
206         // the tokens of 40% of the totalSupply is set to the Innovation address
207         address innovation = 0xbabdd86c16050f3eaa1ecb5aab40bfeba6c11630;
208         balanceOf[innovation] = totalSupply.mul(40).div(100);
209         emit Transfer(0x0, innovation, balanceOf[innovation]);
210         
211         // the tokens of 30% of the totalSupply is set to the Marketing address
212         address marketing = 0x6f61ac86ffe23d99a4d5d3be28943e14fb0e68b2;
213         balanceOf[marketing] = totalSupply.mul(30).div(100);
214         emit Transfer(0x0, marketing, balanceOf[marketing]);
215         
216         // the tokens of 20% of the totalSupply is set to the Team address
217         address team = 0xc4132c69a575cedba7c595922cb240e110dcece5;
218         balanceOf[team] = totalSupply.mul(20).div(100);
219         emit Transfer(0x0, team, balanceOf[team]);
220         
221         // the tokens of 10% of the totalSupply is set to the Development address
222         address development = 0x43820388a9a105349ece6104448c61f7adac286b;
223         balanceOf[development] = totalSupply.mul(10).div(100);
224         emit Transfer(0x0, development, balanceOf[development]);
225     }
226     
227 
228    /**
229      * @dev Standard function transfer based on ERC223
230      */
231     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
232         require(_value > 0 && _to != address(0));
233 
234         if (isContract(_to)) {
235             return transferToContract(_to, _value, _data);
236         } else {
237             return transferToAddress(_to, _value, _data);
238         }
239     }
240 
241     /**
242      * @dev Standard function transfer similar to ERC20 transfer with no _data
243      *      Added due to backwards compatibility reasons
244      */
245     function transfer(address _to, uint _value) public returns (bool success) {
246         require(_value > 0 && _to != address(0));
247 
248         bytes memory empty;
249         if (isContract(_to)) {
250             return transferToContract(_to, _value, empty);
251         } else {
252             return transferToAddress(_to, _value, empty);
253         }
254     }
255 
256     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
257     function isContract(address _addr) private view returns (bool is_contract) {
258         uint length;
259         assembly {
260             //retrieve the size of the code on target address, this needs assembly
261             length := extcodesize(_addr)
262         }
263         return (length > 0);
264     }
265 
266     // function that is called when transaction target is an address
267     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
268         require(balanceOf[msg.sender] >= _value);
269         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
270         balanceOf[_to] = balanceOf[_to].add(_value);
271         emit Transfer(msg.sender, _to, _value, _data);
272         emit Transfer(msg.sender, _to, _value);
273         return true;
274     }
275 
276     // function that is called when transaction target is a contract
277     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
278         require(balanceOf[msg.sender] >= _value);
279         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
280         balanceOf[_to] = balanceOf[_to].add(_value);
281         ContractReceiver receiver = ContractReceiver(_to);
282         receiver.tokenFallback(msg.sender, _value, _data);
283         emit Transfer(msg.sender, _to, _value, _data);
284         emit Transfer(msg.sender, _to, _value);
285         return true;
286     }
287     
288     /**
289      * @dev Transfer tokens from one address to another
290      *      Added due to backwards compatibility with ERC20
291      * @param _from address The address which you want to send tokens from
292      * @param _to address The address which you want to transfer to
293      * @param _value uint256 the amount of tokens to be transferred
294      */
295     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
296         require(_to != address(0)
297                 && _value > 0
298                 && balanceOf[_from] >= _value
299                 && allowance[_from][msg.sender] >= _value);
300 
301         balanceOf[_from] = balanceOf[_from].sub(_value);
302         balanceOf[_to] = balanceOf[_to].add(_value);
303         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
304         emit Transfer(_from, _to, _value);
305         return true;
306     }
307 
308     /**
309      * @dev Allows _spender to spend no more than _value tokens in your behalf
310      *      Added due to backwards compatibility with ERC20
311      * @param _spender The address authorized to spend
312      * @param _value the max amount they can spend
313      */
314     function approve(address _spender, uint256 _value) public returns (bool success) {
315         allowance[msg.sender][_spender] = _value;
316         emit Approval(msg.sender, _spender, _value);
317         return true;
318     }
319     
320     /**
321      * @dev Function to check the amount of tokens that an owner allowed to a spender
322      *      Added due to backwards compatibility with ERC20
323      * @param _owner address The address which owns the funds
324      * @param _spender address The address which will spend the funds
325      */
326     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
327         return allowance[_owner][_spender];
328     }
329 
330     /**
331      * @dev Burns a specific amount of tokens.
332      * @param _from The address that will burn the tokens.
333      * @param _unitAmount The amount of token to be burned.
334      */
335     function burn(address _from, uint256 _unitAmount) onlyOwner public {
336         require(_unitAmount > 0
337                 && balanceOf[_from] >= _unitAmount);
338 
339         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
340         totalSupply = totalSupply.sub(_unitAmount);
341         Burn(_from, _unitAmount);
342     }
343     /**
344      * @dev Function to mint tokens
345      * @param _to The address that will receive the minted tokens.
346      * @param _unitAmount The amount of tokens to mint.
347      */
348     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
349         require(_unitAmount > 0);
350 
351         totalSupply = totalSupply.add(_unitAmount);
352         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
353         emit Mint(_to, _unitAmount);
354         emit Transfer(address(0), _to, _unitAmount);
355         return true;
356     }
357 
358     /**
359      * @dev Function to stop minting new tokens.
360      */
361     function finishMinting() onlyOwner canMint public returns (bool) {
362         mintingFinished = true;
363         emit MintFinished();
364         return true;
365     }
366 }