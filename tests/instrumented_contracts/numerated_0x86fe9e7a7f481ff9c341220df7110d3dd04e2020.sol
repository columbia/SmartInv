1 // File: contracts/CNTMToken/ERC223/ERC223Interface.sol
2 
3 pragma solidity >=0.4.21 <0.6.0;
4 
5 contract ERC223Interface {
6     uint public totalSupply;
7     function balanceOf(address who) public view returns (uint);
8     function transfer(address to, uint value) public;
9     function transfer(address to, uint value, bytes memory data) public;
10     event Transfer(address indexed from, address indexed to, uint value, bytes data);
11 }
12 
13 // File: contracts/CNTMToken/ERC223/ERC223ReceivingContract.sol
14 
15 pragma solidity >=0.4.21 <0.6.0;
16 
17 contract ERC223ReceivingContract {
18 /**
19  * @dev Standard ERC223 function that will handle incoming token transfers.
20  *
21  * @param _from  Token sender address.
22  * @param _value Amount of tokens.
23  * @param _data  Transaction metadata.
24  */
25     function tokenFallback(address _from, uint _value, bytes memory _data) public;
26 }
27 
28 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
29 
30 pragma solidity ^0.5.0;
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error
35  */
36 library SafeMath {
37     /**
38     * @dev Multiplies two unsigned integers, reverts on overflow.
39     */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56     */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     /**
67     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Adds two unsigned integers, reverts on overflow.
78     */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a);
82 
83         return c;
84     }
85 
86     /**
87     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88     * reverts when dividing by zero.
89     */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0);
92         return a % b;
93     }
94 }
95 
96 // File: contracts/CNTMToken/ERC223/ERC223Token.sol
97 
98 pragma solidity >=0.4.21 <0.6.0;
99 
100 
101 
102 
103 /**
104  * @title Reference implementation of the ERC223 standard token.
105  */
106 
107 contract ERC223Token is ERC223Interface {
108     using SafeMath for uint;
109 
110     mapping(address => uint) public balances;
111 
112     /**
113      * @dev Transfer the specified amount of tokens to the specified address.
114      *      Invokes the `tokenFallback` function if the recipient is a contract.
115      *      The token transfer fails if the recipient is a contract
116      *      but does not implement the `tokenFallback` function
117      *      or the fallback function to receive funds.
118      *
119      * @param _to    Receiver address.
120      * @param _value Amount of tokens that will be transferred.
121      * @param _data  Transaction metadata.
122      */
123     function transfer(address _to, uint _value, bytes memory _data) public {
124         // Standard function transfer similar to ERC20 transfer with no _data .
125         // Added due to backwards compatibility reasons .
126         uint codeLength;
127 
128         /* solium-disable-next-line */
129         assembly {
130             // Retrieve the size of the code on target address, this needs assembly .
131             codeLength := extcodesize(_to)
132         }
133 
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         if(codeLength>0) {
137             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
138             receiver.tokenFallback(msg.sender, _value, _data);
139         }
140         emit Transfer(msg.sender, _to, _value, _data);
141     }
142 
143     /**
144      * @dev Transfer the specified amount of tokens to the specified address.
145      *      This function works the same with the previous one
146      *      but doesn't contain `_data` param.
147      *      Added due to backwards compatibility reasons.
148      *
149      * @param _to    Receiver address.
150      * @param _value Amount of tokens that will be transferred.
151      */
152     function transfer(address _to, uint _value) public {
153         uint codeLength;
154         bytes memory empty;
155         /* solium-disable-next-line */
156         assembly {
157             // Retrieve the size of the code on target address, this needs assembly .
158             codeLength := extcodesize(_to)
159         }
160 
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         if(codeLength>0) {
164             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
165             receiver.tokenFallback(msg.sender, _value, empty);
166         }
167         emit Transfer(msg.sender, _to, _value, empty);
168     }
169 
170     /**
171      * @dev Returns balance of the `_owner`.
172      *
173      * @param _owner   The address whose balance will be returned.
174      * @return balance Balance of the `_owner`.
175      */
176     function balanceOf(address _owner) public view returns (uint balance) {
177         return balances[_owner];
178     }
179 }
180 
181 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
182 
183 pragma solidity ^0.5.0;
184 
185 /**
186  * @title Ownable
187  * @dev The Ownable contract has an owner address, and provides basic authorization control
188  * functions, this simplifies the implementation of "user permissions".
189  */
190 contract Ownable {
191     address private _owner;
192 
193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194 
195     /**
196      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197      * account.
198      */
199     constructor () internal {
200         _owner = msg.sender;
201         emit OwnershipTransferred(address(0), _owner);
202     }
203 
204     /**
205      * @return the address of the owner.
206      */
207     function owner() public view returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(isOwner());
216         _;
217     }
218 
219     /**
220      * @return true if `msg.sender` is the owner of the contract.
221      */
222     function isOwner() public view returns (bool) {
223         return msg.sender == _owner;
224     }
225 
226     /**
227      * @dev Allows the current owner to relinquish control of the contract.
228      * @notice Renouncing to ownership will leave the contract without an owner.
229      * It will not be possible to call the functions with the `onlyOwner`
230      * modifier anymore.
231      */
232     function renounceOwnership() public onlyOwner {
233         emit OwnershipTransferred(_owner, address(0));
234         _owner = address(0);
235     }
236 
237     /**
238      * @dev Allows the current owner to transfer control of the contract to a newOwner.
239      * @param newOwner The address to transfer ownership to.
240      */
241     function transferOwnership(address newOwner) public onlyOwner {
242         _transferOwnership(newOwner);
243     }
244 
245     /**
246      * @dev Transfers control of the contract to a newOwner.
247      * @param newOwner The address to transfer ownership to.
248      */
249     function _transferOwnership(address newOwner) internal {
250         require(newOwner != address(0));
251         emit OwnershipTransferred(_owner, newOwner);
252         _owner = newOwner;
253     }
254 }
255 
256 // File: contracts/CNTMToken/CNTMToken.sol
257 
258 pragma solidity >=0.4.21 <0.6.0;
259 
260 
261 
262 contract CNTMToken is ERC223Token, Ownable {
263     string public name;
264     string public symbol;
265     uint8 public decimals;
266     uint256 public totalSupply;
267     address mpAddress;
268 
269     modifier onlyMP {
270         require(msg.sender == mpAddress);
271         _;
272     }
273 
274     constructor (
275         string memory _name,
276         string memory _symbol,
277         uint8 _decimals
278     ) public {
279         symbol = _symbol;
280         name = _name;
281         decimals = _decimals;
282         totalSupply = 1000000000 * (10 ** uint256(decimals));
283         balances[msg.sender] = totalSupply;
284     }
285 
286     function setMarketPlaceAddress(
287         address _mpaddress
288     ) public onlyOwner {
289         mpAddress = _mpaddress;
290     }
291 
292     function transferFrom(
293         address _from,
294         address _to,
295         uint _value,
296         bytes memory _data
297     ) public onlyMP {
298         uint codeLength;
299 
300         /* solium-disable-next-line */
301         assembly {
302             codeLength := extcodesize(_to)
303         }
304 
305         balances[_from] = balances[_from].sub(_value);
306         balances[_to] = balances[_to].add(_value);
307         if(codeLength>0) {
308             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
309             receiver.tokenFallback(_from, _value, _data);
310         }
311         emit Transfer(_from, _to, _value, _data);
312     }
313 
314     function transferFrom(
315         address _from,
316         address _to,
317         uint _value
318     ) public onlyMP {
319         uint codeLength;
320         bytes memory empty;
321 
322         /* solium-disable-next-line */
323         assembly {
324             codeLength := extcodesize(_to)
325         }
326 
327         balances[_from] = balances[_from].sub(_value);
328         balances[_to] = balances[_to].add(_value);
329         if(codeLength>0) {
330             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
331             receiver.tokenFallback(_from, _value, empty);
332         }
333         emit Transfer(_from, _to, _value, empty);
334     }
335 }