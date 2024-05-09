1 pragma solidity ^0.4.23;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     constructor() public {
19         owner = msg.sender;
20         emit LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24     public
25     auth
26     {
27         owner = owner_;
28         emit LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32     public
33     auth
34     {
35         authority = authority_;
36         emit LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 contract DSNote {
57     event LogNote(
58         bytes4   indexed  sig,
59         address  indexed  guy,
60         bytes32  indexed  foo,
61         bytes32  indexed  bar,
62         uint              wad,
63         bytes             fax
64     ) anonymous;
65 
66     modifier note {
67         bytes32 foo;
68         bytes32 bar;
69 
70         assembly {
71             foo := calldataload(4)
72             bar := calldataload(36)
73         }
74 
75         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
76 
77         _;
78     }
79 }
80 contract DSStop is DSNote, DSAuth {
81     bool public stopped;
82 
83     modifier stoppable {
84         require(!stopped);
85         _;
86     }
87     function stop() public auth note {
88         stopped = true;
89     }
90     function start() public auth note {
91         stopped = false;
92     }
93 
94 }
95 contract DSMath {
96     function add(uint x, uint y) internal pure returns (uint z) {
97         require((z = x + y) >= x);
98     }
99     function sub(uint x, uint y) internal pure returns (uint z) {
100         require((z = x - y) <= x);
101     }
102     function mul(uint x, uint y) internal pure returns (uint z) {
103         require(y == 0 || (z = x * y) / y == x);
104     }
105 }
106 
107 contract ERC20 {
108     /// @return total amount of tokens
109     function totalSupply() constant public returns (uint256 supply);
110 
111     /// @param _owner The address from which the balance will be retrieved
112     /// @return The balance
113     function balanceOf(address _owner) constant public returns (uint256 balance);
114 
115     /// @notice send `_value` token to `_to` from `msg.sender`
116     /// @param _to The address of the recipient
117     /// @param _value The amount of token to be transferred
118     /// @return Whether the transfer was successful or not
119     function transfer(address _to, uint256 _value) public returns (bool success);
120 
121     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
122     /// @param _from The address of the sender
123     /// @param _to The address of the recipient
124     /// @param _value The amount of token to be transferred
125     /// @return Whether the transfer was successful or not
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
127 
128     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
129     /// @param _spender The address of the account able to transfer the tokens
130     /// @param _value The amount of wei to be approved for transfer
131     /// @return Whether the approval was successful or not
132     function approve(address _spender, uint256 _value) public returns (bool success);
133 
134     /// @param _owner The address of the account owning tokens
135     /// @param _spender The address of the account able to transfer the tokens
136     /// @return Amount of remaining tokens allowed to spent
137     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
138 
139     event Transfer(address indexed _from, address indexed _to, uint256 _value);
140     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
141 }
142 
143 
144 contract Coin is ERC20, DSStop {
145     string public name;
146     string public symbol;
147     uint8 public decimals = 18;
148     uint256 internal c_totalSupply;
149     mapping(address => uint256) internal c_balances;
150     mapping(address => mapping(address => uint256)) internal c_approvals;
151 
152     function init(uint256 token_supply, string token_name, string token_symbol) internal {
153         c_balances[msg.sender] = token_supply;
154         c_totalSupply = token_supply;
155         name = token_name;
156         symbol = token_symbol;
157     }
158 
159     function() public {
160         assert(false);
161     }
162 
163     function setName(string _name) auth public {
164         name = _name;
165     }
166 
167     function totalSupply() constant public returns (uint256) {
168         return c_totalSupply;
169     }
170 
171     function balanceOf(address _owner) constant public returns (uint256) {
172         return c_balances[_owner];
173     }
174 
175     function approve(address _spender, uint256 _value) public stoppable returns (bool) {
176         // uint never less than 0. The negative number will become to a big positive number
177         require(_value < c_totalSupply);
178 
179         c_approvals[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     function allowance(address _owner, address _spender) constant public returns (uint256) {
185         return c_approvals[_owner][_spender];
186     }
187 }
188 
189 contract FreezerAuthority is DSAuthority {
190     address[] internal c_freezers;
191     // sha3("setFreezing(address,uint256,uint256,uint8)").slice(0,10)
192     bytes4 constant setFreezingSig = bytes4(0x51c3b8a6);
193     // sha3("transferAndFreezing(address,uint256,uint256,uint256,uint8)").slice(0,10)
194     bytes4 constant transferAndFreezingSig = bytes4(0xb8a1fdb6);
195 
196     function canCall(address caller, address, bytes4 sig) public view returns (bool) {
197         // freezer can call setFreezing, transferAndFreezing
198         if (isFreezer(caller) && sig == setFreezingSig || sig == transferAndFreezingSig) {
199             return true;
200         } else {
201             return false;
202         }
203     }
204 
205     function addFreezer(address freezer) public {
206         int i = indexOf(c_freezers, freezer);
207         if (i < 0) {
208             c_freezers.push(freezer);
209         }
210     }
211 
212     function removeFreezer(address freezer) public {
213         int index = indexOf(c_freezers, freezer);
214         if (index >= 0) {
215             uint i = uint(index);
216             while (i < c_freezers.length - 1) {
217                 c_freezers[i] = c_freezers[i + 1];
218             }
219             c_freezers.length--;
220         }
221     }
222 
223     /** Finds the index of a given value in an array. */
224     function indexOf(address[] values, address value) internal pure returns (int) {
225         uint i = 0;
226         while (i < values.length) {
227             if (values[i] == value) {
228                 return int(i);
229             }
230             i++;
231         }
232         return int(- 1);
233     }
234 
235     function isFreezer(address addr) public constant returns (bool) {
236         return indexOf(c_freezers, addr) >= 0;
237     }
238 }
239 
240 contract LemoCoin is Coin, DSMath {
241     // freezing struct
242     struct FreezingNode {
243         uint end_stamp;
244         uint num_lemos;
245         uint8 freezing_type;
246     }
247 
248     // freezing account list
249     mapping(address => FreezingNode[]) internal c_freezing_list;
250 
251     constructor(uint256 token_supply, string token_name, string token_symbol) public {
252         init(token_supply, token_name, token_symbol);
253         setAuthority(new FreezerAuthority());
254     }
255 
256     function addFreezer(address freezer) auth public {
257         FreezerAuthority(authority).addFreezer(freezer);
258     }
259 
260     function removeFreezer(address freezer) auth public {
261         FreezerAuthority(authority).removeFreezer(freezer);
262     }
263 
264     event ClearExpiredFreezingEvent(address indexed addr);
265     event SetFreezingEvent(address indexed addr, uint end_stamp, uint num_lemos, uint8 indexed freezing_type);
266 
267     function clearExpiredFreezing(address addr) public {
268         FreezingNode[] storage nodes = c_freezing_list[addr];
269         uint length = nodes.length;
270 
271         // find first expired index
272         uint left = 0;
273         while (left < length) {
274             // not freezing any more
275             if (nodes[left].end_stamp <= block.timestamp) {
276                 break;
277             }
278             left++;
279         }
280 
281         // next frozen index
282         uint right = left + 1;
283         while (left < length && right < length) {
284             // still freezing
285             if (nodes[right].end_stamp > block.timestamp) {
286                 nodes[left] = nodes[right];
287                 left++;
288             }
289             right++;
290         }
291         if (length != left) {
292             nodes.length = left;
293             emit ClearExpiredFreezingEvent(addr);
294         }
295     }
296 
297     function validBalanceOf(address addr) constant public returns (uint) {
298         FreezingNode[] memory nodes = c_freezing_list[addr];
299         uint length = nodes.length;
300         uint total_lemos = balanceOf(addr);
301 
302         for (uint i = 0; i < length; ++i) {
303             if (nodes[i].end_stamp > block.timestamp) {
304                 total_lemos = sub(total_lemos, nodes[i].num_lemos);
305             }
306         }
307 
308         return total_lemos;
309     }
310 
311     function freezingBalanceNumberOf(address addr) constant public returns (uint) {
312         return c_freezing_list[addr].length;
313     }
314 
315     function freezingBalanceInfoOf(address addr, uint index) constant public returns (uint, uint, uint8) {
316         return (c_freezing_list[addr][index].end_stamp, c_freezing_list[addr][index].num_lemos, uint8(c_freezing_list[addr][index].freezing_type));
317     }
318 
319     function setFreezing(address addr, uint end_stamp, uint num_lemos, uint8 freezing_type) auth stoppable public {
320         require(block.timestamp < end_stamp);
321         // uint never less than 0. The negative number will become to a big positive number
322         require(num_lemos < c_totalSupply);
323         clearExpiredFreezing(addr);
324         uint valid_balance = validBalanceOf(addr);
325         require(valid_balance >= num_lemos);
326 
327         FreezingNode memory node = FreezingNode(end_stamp, num_lemos, freezing_type);
328         c_freezing_list[addr].push(node);
329 
330         emit SetFreezingEvent(addr, end_stamp, num_lemos, freezing_type);
331     }
332 
333     function transferAndFreezing(address _to, uint256 _value, uint256 freeze_amount, uint end_stamp, uint8 freezing_type) auth stoppable public returns (bool) {
334         // uint never less than 0. The negative number will become to a big positive number
335         require(_value < c_totalSupply);
336         require(freeze_amount <= _value);
337 
338         transfer(_to, _value);
339         setFreezing(_to, end_stamp, freeze_amount, freezing_type);
340 
341         return true;
342     }
343 
344     function transfer(address _to, uint256 _value) stoppable public returns (bool) {
345         // uint never less than 0. The negative number will become to a big positive number
346         require(_value < c_totalSupply);
347         clearExpiredFreezing(msg.sender);
348         uint from_lemos = validBalanceOf(msg.sender);
349 
350         require(from_lemos >= _value);
351 
352         c_balances[msg.sender] = sub(c_balances[msg.sender], _value);
353         c_balances[_to] = add(c_balances[_to], _value);
354 
355         emit Transfer(msg.sender, _to, _value);
356         return true;
357     }
358 
359     function transferFrom(address _from, address _to, uint256 _value) stoppable public returns (bool) {
360         // uint never less than 0. The negative number will become to a big positive number
361         require(_value < c_totalSupply);
362         require(c_approvals[_from][msg.sender] >= _value);
363 
364         clearExpiredFreezing(_from);
365         uint from_lemos = validBalanceOf(_from);
366 
367         require(from_lemos >= _value);
368 
369         c_approvals[_from][msg.sender] = sub(c_approvals[_from][msg.sender], _value);
370         c_balances[_from] = sub(c_balances[_from], _value);
371         c_balances[_to] = add(c_balances[_to], _value);
372 
373         emit Transfer(_from, _to, _value);
374         return true;
375     }
376 }