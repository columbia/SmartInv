1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45      * account.
46      */
47     function Ownable() public {
48         owner = msg.sender;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) onlyOwner public {
64         require(newOwner != address(0));
65         OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67     }
68 }
69 
70 /**
71 * @title ERC20Basic
72 * @dev Simpler version of ERC20 interface
73 * @dev see https://github.com/ethereum/EIPs/issues/179
74 */
75 contract ERC20Basic {
76     uint256 public totalSupply;
77     function balanceOf(address who) public constant returns (uint256);
78     function transfer(address to, uint256 value) public returns (bool);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87     function allowance(address owner, address spender) public constant returns (uint256);
88     function transferFrom(address from, address to, uint256 value) public returns (bool);
89     function approve(address spender, uint256 value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 contract ApprovalContract is ERC20 {
95     using SafeMath for uint256;
96 
97     mapping (address => mapping (address => uint256)) public allowed;
98 
99     /**
100      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101      *
102      * Beware that changing an allowance with this method brings the risk that someone may use both the old
103      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
104      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
105      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106      * @param _spender The address which will spend the funds.
107      * @param _value The amount of tokens to be spent.
108      */
109     function approve(address _spender, uint256 _value) public returns (bool) {
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     /**
116      * @dev Function to check the amount of tokens that an owner allowed to a spender.
117      * @param _owner address The address which owns the funds.
118      * @param _spender address The address which will spend the funds.
119      * @return A uint256 specifying the amount of tokens still available for the spender.
120      */
121     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122         return allowed[_owner][_spender];
123     }
124 
125     /**
126      * approve should be called when allowed[_spender] == 0. To increment
127      * allowed value is better to use this function to avoid 2 calls (and wait until
128      * the first transaction is mined)
129      * From MonolithDAO Token.sol
130      */
131     function increaseApproval (address _spender, uint _addedValue) public
132     returns (bool success) {
133         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135         return true;
136     }
137 
138     function decreaseApproval (address _spender, uint _subtractedValue) public
139     returns (bool success) {
140         uint oldValue = allowed[msg.sender][_spender];
141         if (_subtractedValue > oldValue) {
142             allowed[msg.sender][_spender] = 0;
143         } else {
144             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145         }
146         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148     }
149 }
150 
151 /**
152  * @title Mintable token
153  * @dev Simple ERC20 Token example, with mintable token creation
154  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
155  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
156  */
157 contract MintableToken is ApprovalContract, Ownable {
158 
159     uint256 public hardCap;
160     mapping(address => uint256) public balances;
161 
162     event Mint(address indexed to, uint256 amount);
163 
164     modifier canMint() {
165         require(totalSupply == 0);
166         _;
167     }
168 
169     /**
170      * @dev Function to mint tokens
171      * @param _to The address that will receive the minted tokens.
172      * @param _amount The amount of tokens to mint.
173      * @return A boolean that indicates if the operation was successful.
174      */
175     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
176         require(_amount < hardCap);
177         totalSupply = totalSupply.add(_amount);
178         balances[_to] = balances[_to].add(_amount);
179         Mint(_to, _amount);
180         Transfer(0x0, _to, _amount);
181         return true;
182     }
183 }
184 
185 /**
186  * @title Vesting token
187  */
188 contract Vesting is MintableToken {
189 
190     event VestingMemberAdded(address indexed _address, uint256 _amount, uint _start, uint _end);
191 
192     struct _Vesting {
193         uint256 totalSum;     //total amount
194         uint256 start;        //start block
195         uint256 end;          //end block
196         uint256 usedAmount;   //the amount of paid payments
197     }
198 
199     mapping (address => _Vesting ) public vestingMembers;
200 
201     function addVestingMember(
202         address _address,
203         uint256 _amount,
204         uint256 _start,
205         uint256 _end
206     ) onlyOwner public returns (bool) {
207         require(
208             _address != address(0) &&
209             _amount > 0 &&
210             _start < _end &&
211             vestingMembers[_address].totalSum == 0 &&
212             balances[msg.sender] > _amount
213         );
214 
215         balances[msg.sender] = balances[msg.sender].sub(_amount);
216 
217         vestingMembers[_address].totalSum = _amount;    //total amount
218         vestingMembers[_address].start = _start;        //start block
219         vestingMembers[_address].end = _end;            //end block
220         vestingMembers[_address].usedAmount = 0;        //the amount of paid payments
221 
222         VestingMemberAdded(_address, _amount, _start, _end);
223 
224         return true;
225     }
226 
227     function currentPart(address _address) private constant returns (uint256) {
228         if (vestingMembers[_address].totalSum == 0 || block.number <= vestingMembers[_address].start) {
229             return 0;
230         }
231         if (block.number >= vestingMembers[_address].end) {
232             return vestingMembers[_address].totalSum.sub(vestingMembers[_address].usedAmount);
233         }
234 
235         return vestingMembers[_address].totalSum
236         .mul(block.number - vestingMembers[_address].start)
237         .div(vestingMembers[_address].end - vestingMembers[_address].start)
238         .sub(vestingMembers[_address].usedAmount);
239     }
240 
241     function subFromBalance(address _address, uint256 _amount) private returns (uint256) {
242         require(_address != address(0));
243 
244         if (vestingMembers[_address].totalSum == 0) {
245             balances[_address] = balances[_address].sub(_amount);
246             return balances[_address];
247         }
248         uint256 summary = balanceOf(_address);
249         require(summary >= _amount);
250 
251         if (balances[_address] > _amount) {
252             balances[_address] = balances[_address].sub(_amount);
253         } else {
254             uint256 part = currentPart(_address);
255             if (block.number >= vestingMembers[_address].end) {
256                 vestingMembers[_address].totalSum = 0;          //total amount
257                 vestingMembers[_address].start = 0;             //start block
258                 vestingMembers[_address].end = 0;               //end block
259                 vestingMembers[_address].usedAmount = 0;        //the amount of paid payments
260             } else {
261                 vestingMembers[_address].usedAmount = vestingMembers[_address].usedAmount.add(part);
262             }
263             balances[_address] = balances[_address].add(part).sub(_amount);
264         }
265 
266         return balances[_address];
267     }
268 
269     function balanceOf(address _owner) public constant returns (uint256 balance) {
270         if (vestingMembers[_owner].totalSum == 0) {
271             return balances[_owner];
272         } else {
273             return balances[_owner].add(currentPart(_owner));
274         }
275     }
276 
277     function transfer(address _to, uint256 _value) public returns (bool) {
278         require(_to != address(0));
279         require(_value <= balanceOf(msg.sender));
280 
281         subFromBalance(msg.sender, _value);
282 
283         balances[_to] = balances[_to].add(_value);
284         Transfer(msg.sender, _to, _value);
285         return true;
286     }
287 
288     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
289         require(_to != address(0));
290 
291         uint256 _allowance = allowed[_from][msg.sender];
292 
293         subFromBalance(_from, _value);
294 
295         balances[_to] = balances[_to].add(_value);
296         allowed[_from][msg.sender] = _allowance.sub(_value);
297         Transfer(_from, _to, _value);
298         return true;
299     }
300 }
301 
302 
303 contract DMToken is Vesting {
304 
305     string public name = "DMarket Token";
306     string public symbol = "DMT";
307     uint256 public decimals = 8;
308 
309     function DMToken() public {
310         hardCap = 15644283100000000;
311     }
312 
313     function multiTransfer(address[] recipients, uint256[] amounts) public {
314         require(recipients.length == amounts.length);
315         for (uint i = 0; i < recipients.length; i++) {
316             transfer(recipients[i], amounts[i]);
317         }
318     }
319 
320     function multiVesting(
321         address[] _address,
322         uint256[] _amount,
323         uint256[] _start,
324         uint256[] _end
325     ) public onlyOwner {
326         require(
327             _address.length == _amount.length &&
328             _address.length == _start.length &&
329             _address.length == _end.length
330         );
331         for (uint i = 0; i < _address.length; i++) {
332             addVestingMember(_address[i], _amount[i], _start[i], _end[i]);
333         }
334     }
335 }