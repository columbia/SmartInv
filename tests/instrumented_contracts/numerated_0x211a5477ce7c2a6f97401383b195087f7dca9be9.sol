1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization
39  *      control functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the
48      *      sender account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner public {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 }
72 
73 /**
74  * @title ERC223
75  * @dev ERC223 contract interface with ERC20 functions and events
76  *      Fully backward compatible with ERC20
77  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
78  */
79 contract ERC223 {
80     uint public totalSupply;
81 
82     // ERC223 and ERC20 functions and events
83     function balanceOf(address who) public view returns (uint);
84     function totalSupply() public view returns (uint256 _supply);
85     function transfer(address to, uint value) public returns (bool ok);
86     function transfer(address to, uint value, bytes data) public returns (bool ok);
87     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
88     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
89 
90     // ERC223 functions
91     function name() public view returns (string _name);
92     function symbol() public view returns (string _symbol);
93     function decimals() public view returns (uint8 _decimals);
94 
95     // ERC20 functions and events
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
97     function approve(address _spender, uint256 _value) public returns (bool success);
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint _value);
101 }
102 
103 /**
104  * @title ContractReceiver
105  * @dev Contract that is working with ERC223 tokens
106  */
107  contract ContractReceiver {
108 
109     struct TKN {
110         address sender;
111         uint value;
112         bytes data;
113         bytes4 sig;
114     }
115 
116     function tokenFallback(address _from, uint _value, bytes _data) public pure {
117         TKN memory tkn;
118         tkn.sender = _from;
119         tkn.value = _value;
120         tkn.data = _data;
121         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
122         tkn.sig = bytes4(u);
123 
124         /*
125          * tkn variable is analogue of msg variable of Ether transaction
126          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
127          * tkn.value the number of tokens that were sent (analogue of msg.value)
128          * tkn.data is data of token transaction (analogue of msg.data)
129          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
130          */
131     }
132 }
133 
134 /**
135  * @title MAMECOIN
136  * @author MAMECOIN team
137  * @dev MAMECOIN is an ERC223 Token with ERC20 functions and events
138  *      Fully backward compatible with ERC20
139  */
140 contract MAMECOIN is ERC223, Ownable {
141     using SafeMath for uint256;
142 
143     string public name = "MAMECOIN";
144     string public symbol = "MAME";
145     uint8 public decimals = 8;
146     uint256 public totalSupply = 50e9 * 1e8;
147 
148     mapping(address => uint256) public balanceOf;
149     mapping(address => mapping (address => uint256)) public allowance;
150     mapping (address => bool) public frozenAccount;
151     mapping (address => uint256) public unlockUnixTime;
152 
153     event FrozenFunds(address indexed target, bool frozen);
154     event LockedFunds(address indexed target, uint256 locked);
155     event Burn(address indexed from, uint256 amount);
156 
157     /**
158      * @dev Constructor is called only once and can not be called again
159      */
160     function MAMECOIN() public {
161         owner = 0xf438F671f19371aB40EcB32b53f45Fce69996f9B;
162 
163         balanceOf[owner] = totalSupply;
164     }
165 
166     function name() public view returns (string _name) {
167         return name;
168     }
169 
170     function symbol() public view returns (string _symbol) {
171         return symbol;
172     }
173 
174     function decimals() public view returns (uint8 _decimals) {
175         return decimals;
176     }
177 
178     function totalSupply() public view returns (uint256 _totalSupply) {
179         return totalSupply;
180     }
181 
182     function balanceOf(address _owner) public view returns (uint256 balance) {
183         return balanceOf[_owner];
184     }
185 
186     /**
187      * @dev Prevent targets from sending or receiving tokens
188      * @param targets Addresses to be frozen
189      * @param isFrozen either to freeze it or not
190      */
191     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
192         require(targets.length > 0);
193 
194         for (uint j = 0; j < targets.length; j++) {
195             require(targets[j] != 0x0);
196             frozenAccount[targets[j]] = isFrozen;
197             FrozenFunds(targets[j], isFrozen);
198         }
199     }
200 
201     /**
202      * @dev Prevent targets from sending or receiving tokens by setting Unix times
203      * @param targets Addresses to be locked funds
204      * @param unixTimes Unix times when locking up will be finished
205      */
206     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
207         require(targets.length > 0
208                 && targets.length == unixTimes.length);
209 
210         for(uint j = 0; j < targets.length; j++){
211             require(unlockUnixTime[targets[j]] < unixTimes[j]);
212             unlockUnixTime[targets[j]] = unixTimes[j];
213             LockedFunds(targets[j], unixTimes[j]);
214         }
215     }
216 
217     /**
218      * @dev Function that is called when a user or another contract wants to transfer funds
219      */
220     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
221         require(_value > 0
222                 && frozenAccount[msg.sender] == false
223                 && frozenAccount[_to] == false
224                 && now > unlockUnixTime[msg.sender]
225                 && now > unlockUnixTime[_to]);
226 
227         if (isContract(_to)) {
228             require(balanceOf[msg.sender] >= _value);
229             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
230             balanceOf[_to] = balanceOf[_to].add(_value);
231             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
232             Transfer(msg.sender, _to, _value, _data);
233             Transfer(msg.sender, _to, _value);
234             return true;
235         } else {
236             return transferToAddress(_to, _value, _data);
237         }
238     }
239 
240     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
241         require(_value > 0
242                 && frozenAccount[msg.sender] == false
243                 && frozenAccount[_to] == false
244                 && now > unlockUnixTime[msg.sender]
245                 && now > unlockUnixTime[_to]);
246 
247         if (isContract(_to)) {
248             return transferToContract(_to, _value, _data);
249         } else {
250             return transferToAddress(_to, _value, _data);
251         }
252     }
253 
254     /**
255      * @dev Standard function transfer similar to ERC20 transfer with no _data
256      *      Added due to backwards compatibility reasons
257      */
258     function transfer(address _to, uint _value) public returns (bool success) {
259         require(_value > 0
260                 && frozenAccount[msg.sender] == false
261                 && frozenAccount[_to] == false
262                 && now > unlockUnixTime[msg.sender]
263                 && now > unlockUnixTime[_to]);
264 
265         bytes memory empty;
266         if (isContract(_to)) {
267             return transferToContract(_to, _value, empty);
268         } else {
269             return transferToAddress(_to, _value, empty);
270         }
271     }
272 
273     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
274     function isContract(address _addr) private view returns (bool is_contract) {
275         uint length;
276         assembly {
277             //retrieve the size of the code on target address, this needs assembly
278             length := extcodesize(_addr)
279         }
280         return (length > 0);
281     }
282 
283     // function that is called when transaction target is an address
284     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
285         require(balanceOf[msg.sender] >= _value);
286         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
287         balanceOf[_to] = balanceOf[_to].add(_value);
288         Transfer(msg.sender, _to, _value, _data);
289         Transfer(msg.sender, _to, _value);
290         return true;
291     }
292 
293     // function that is called when transaction target is a contract
294     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
295         require(balanceOf[msg.sender] >= _value);
296         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
297         balanceOf[_to] = balanceOf[_to].add(_value);
298         ContractReceiver receiver = ContractReceiver(_to);
299         receiver.tokenFallback(msg.sender, _value, _data);
300         Transfer(msg.sender, _to, _value, _data);
301         Transfer(msg.sender, _to, _value);
302         return true;
303     }
304 
305     /**
306      * @dev Transfer tokens from one address to another
307      *      Added due to backwards compatibility with ERC20
308      * @param _from address The address which you want to send tokens from
309      * @param _to address The address which you want to transfer to
310      * @param _value uint256 the amount of tokens to be transferred
311      */
312     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
313         require(_to != address(0)
314                 && _value > 0
315                 && balanceOf[_from] >= _value
316                 && allowance[_from][msg.sender] >= _value
317                 && frozenAccount[_from] == false
318                 && frozenAccount[_to] == false
319                 && now > unlockUnixTime[_from]
320                 && now > unlockUnixTime[_to]);
321 
322         balanceOf[_from] = balanceOf[_from].sub(_value);
323         balanceOf[_to] = balanceOf[_to].add(_value);
324         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
325         Transfer(_from, _to, _value);
326         return true;
327     }
328 
329     /**
330      * @dev Allows _spender to spend no more than _value tokens in your behalf
331      *      Added due to backwards compatibility with ERC20
332      * @param _spender The address authorized to spend
333      * @param _value the max amount they can spend
334      */
335     function approve(address _spender, uint256 _value) public returns (bool success) {
336         allowance[msg.sender][_spender] = _value;
337         Approval(msg.sender, _spender, _value);
338         return true;
339     }
340 
341     /**
342      * @dev Function to check the amount of tokens that an owner allowed to a spender
343      *      Added due to backwards compatibility with ERC20
344      * @param _owner address The address which owns the funds
345      * @param _spender address The address which will spend the funds
346      */
347     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
348         return allowance[_owner][_spender];
349     }
350 
351     /**
352      * @dev Burns a specific amount of tokens.
353      * @param _from The address that will burn the tokens.
354      * @param _unitAmount The amount of token to be burned.
355      */
356     function burn(address _from, uint256 _unitAmount) onlyOwner public {
357         require(_unitAmount > 0
358                 && balanceOf[_from] >= _unitAmount);
359 
360         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
361         totalSupply = totalSupply.sub(_unitAmount);
362         Burn(_from, _unitAmount);
363     }
364 }