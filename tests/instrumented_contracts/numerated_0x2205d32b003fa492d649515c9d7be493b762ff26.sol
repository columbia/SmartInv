1 pragma solidity 0.4.23;
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
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed sig,
60         address  indexed guy,
61         bytes32  indexed foo,
62         bytes32  indexed bar,
63         uint wad,
64         bytes fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83     bool public stopped;
84 
85     modifier stoppable {
86         require(!stopped);
87         _;
88     }
89     function stop() public auth note {
90         stopped = true;
91     }
92 
93     function start() public auth note {
94         stopped = false;
95     }
96 }
97 
98 contract DSMath {
99     function add(uint x, uint y) internal pure returns (uint z) {
100         require((z = x + y) >= x);
101     }
102 
103     function sub(uint x, uint y) internal pure returns (uint z) {
104         require((z = x - y) <= x);
105     }
106 
107     function mul(uint x, uint y) internal pure returns (uint z) {
108         require(y == 0 || (z = x * y) / y == x);
109     }
110 }
111 
112 contract ERC20 {
113     /// @return total amount of tokens
114     function totalSupply() constant public returns (uint256 supply);
115 
116     /// @param _owner The address from which the balance will be retrieved
117     /// @return The balance
118     function balanceOf(address _owner) constant public returns (uint256 balance);
119 
120     /// @notice send `_value` token to `_to` from `msg.sender`
121     /// @param _to The address of the recipient
122     /// @param _value The amount of token to be transferred
123     /// @return Whether the transfer was successful or not
124     function transfer(address _to, uint256 _value) public returns (bool success);
125 
126     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
127     /// @param _from The address of the sender
128     /// @param _to The address of the recipient
129     /// @param _value The amount of token to be transferred
130     /// @return Whether the transfer was successful or not
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
132 
133     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
134     /// @param _spender The address of the account able to transfer the tokens
135     /// @param _value The amount of wei to be approved for transfer
136     /// @return Whether the approval was successful or not
137     function approve(address _spender, uint256 _value) public returns (bool success);
138 
139     /// @param _owner The address of the account owning tokens
140     /// @param _spender The address of the account able to transfer the tokens
141     /// @return Amount of remaining tokens allowed to spent
142     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
143 
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 }
147 
148 
149 contract Coin is ERC20, DSStop {
150     string public name;
151     string public symbol;
152     uint8 public decimals = 18;
153     uint256 internal c_totalSupply;
154     
155     
156     mapping(address => uint256) internal c_balances;
157     mapping(address => mapping(address => uint256)) internal c_approvals;
158 
159     function init(uint256 token_supply, string token_name, string token_symbol) internal {
160         c_balances[msg.sender] = token_supply;
161         c_totalSupply = token_supply;
162         name = token_name;
163         symbol = token_symbol;
164     }
165 
166     function() public {
167         assert(false);
168     }
169 
170     function setName(string _name) auth public {
171         name = _name;
172         
173         
174         
175         
176         
177         
178     }
179 
180     function totalSupply() constant public returns (uint256) {
181         return c_totalSupply;
182     }
183 
184     function balanceOf(address _owner) constant public returns (uint256) {
185         return c_balances[_owner];
186     }
187 
188     function approve(address _spender, uint256 _value) public stoppable returns (bool) {
189         require(msg.data.length >= (2 * 32) + 4);
190         require(_value == 0 || c_approvals[msg.sender][_spender] == 0);
191         // uint never less than 0. The negative number will become to a big positive number
192         require(_value < c_totalSupply);
193 
194         c_approvals[msg.sender][_spender] = _value;
195         emit Approval(msg.sender, _spender, _value);
196         return true;
197     }
198 
199     function allowance(address _owner, address _spender) constant public returns (uint256) {
200         return c_approvals[_owner][_spender];
201     }
202 }
203 
204 contract FreezerAuthority is DSAuthority {
205     address[] internal c_freezers;
206     // sha3("setFreezing(address,uint256,uint256,uint8)").slice(0,10)
207     bytes4 constant setFreezingSig = bytes4(0x51c3b8a6);
208     // sha3("transferAndFreezing(address,uint256,uint256,uint256,uint8)").slice(0,10)
209     bytes4 constant transferAndFreezingSig = bytes4(0xb8a1fdb6);
210 
211     function canCall(address caller, address, bytes4 sig) public view returns (bool) {
212         // freezer can call setFreezing, transferAndFreezing
213         if (isFreezer(caller) && (sig == setFreezingSig || sig == transferAndFreezingSig)) {
214             return true;
215         } else {
216             return false;
217         }
218     }
219 
220     function addFreezer(address freezer) public {
221         int i = indexOf(c_freezers, freezer);
222         if (i < 0) {
223             c_freezers.push(freezer);
224         }
225     }
226 
227     function removeFreezer(address freezer) public {
228         int index = indexOf(c_freezers, freezer);
229         if (index >= 0) {
230             uint i = uint(index);
231             while (i < c_freezers.length - 1) {
232                 c_freezers[i] = c_freezers[i + 1];
233             }
234             c_freezers.length--;
235         }
236     }
237 
238     /** Finds the index of a given value in an array. */
239     function indexOf(address[] values, address value) internal pure returns (int) {
240         uint i = 0;
241         while (i < values.length) {
242             if (values[i] == value) {
243                 return int(i);
244             }
245             i++;
246         }
247         return int(- 1);
248     }
249 
250     function isFreezer(address addr) public constant returns (bool) {
251         return indexOf(c_freezers, addr) >= 0;
252     }
253 }
254 
255 contract LimitCollectCoin is Coin, DSMath {
256     // freezing struct
257     struct FreezingNode {
258         uint end_stamp;
259         uint num_lccs;
260         uint8 freezing_type;
261     }
262 
263     // freezing account list
264     mapping(address => FreezingNode[]) internal c_freezing_list;
265 
266     constructor(uint256 token_supply, string token_name, string token_symbol) public {
267         init(token_supply, token_name, token_symbol);
268         setAuthority(new FreezerAuthority());
269     }
270 
271     function addFreezer(address freezer) auth public {
272         FreezerAuthority(authority).addFreezer(freezer);
273     }
274 
275     function removeFreezer(address freezer) auth public {
276         FreezerAuthority(authority).removeFreezer(freezer);
277     }
278 
279     event ClearExpiredFreezingEvent(address indexed addr);
280     event SetFreezingEvent(address indexed addr, uint end_stamp, uint num_lccs, uint8 indexed freezing_type);
281 
282     function clearExpiredFreezing(address addr) public {
283         FreezingNode[] storage nodes = c_freezing_list[addr];
284         uint length = nodes.length;
285 
286         // find first expired index
287         uint left = 0;
288         while (left < length) {
289             // not freezing any more
290             if (nodes[left].end_stamp <= block.timestamp) {
291                 break;
292             }
293             left++;
294         }
295 
296         // next frozen index
297         uint right = left + 1;
298         while (left < length && right < length) {
299             // still freezing
300             if (nodes[right].end_stamp > block.timestamp) {
301                 nodes[left] = nodes[right];
302                 left++;
303             }
304             right++;
305         }
306         if (length != left) {
307             nodes.length = left;
308             emit ClearExpiredFreezingEvent(addr);
309         }
310     }
311 
312     function validBalanceOf(address addr) constant public returns (uint) {
313         FreezingNode[] memory nodes = c_freezing_list[addr];
314         uint length = nodes.length;
315         uint total_lccs = balanceOf(addr);
316 
317         for (uint i = 0; i < length; ++i) {
318             if (nodes[i].end_stamp > block.timestamp) {
319                 total_lccs = sub(total_lccs, nodes[i].num_lccs);
320             }
321         }
322 
323         return total_lccs;
324     }
325 
326     function freezingBalanceNumberOf(address addr) constant public returns (uint) {
327         return c_freezing_list[addr].length;
328     }
329 
330     function freezingBalanceInfoOf(address addr, uint index) constant public returns (uint, uint, uint8) {
331         return (c_freezing_list[addr][index].end_stamp, c_freezing_list[addr][index].num_lccs, uint8(c_freezing_list[addr][index].freezing_type));
332     }
333 
334     function setFreezing(address addr, uint end_stamp, uint num_lccs, uint8 freezing_type) auth stoppable public {
335         require(block.timestamp < end_stamp);
336         // uint never less than 0. The negative number will become to a big positive number
337         require(num_lccs < c_totalSupply);
338         clearExpiredFreezing(addr);
339         uint valid_balance = validBalanceOf(addr);
340         require(valid_balance >= num_lccs);
341 
342         FreezingNode memory node = FreezingNode(end_stamp, num_lccs, freezing_type);
343         c_freezing_list[addr].push(node);
344 
345         emit SetFreezingEvent(addr, end_stamp, num_lccs, freezing_type);
346     }
347 
348     function transferAndFreezing(address _to, uint256 _value, uint256 freeze_amount, uint end_stamp, uint8 freezing_type) auth stoppable public returns (bool) {
349         // uint never less than 0. The negative number will become to a big positive number
350         require(_value < c_totalSupply);
351         require(freeze_amount <= _value);
352 
353         transfer(_to, _value);
354         setFreezing(_to, end_stamp, freeze_amount, freezing_type);
355 
356         return true;
357     }
358 
359     function transfer(address _to, uint256 _value) stoppable public returns (bool) {
360         require(msg.data.length >= (2 * 32) + 4);
361         // uint never less than 0. The negative number will become to a big positive number
362         require(_value < c_totalSupply);
363         clearExpiredFreezing(msg.sender);
364         uint from_lccs = validBalanceOf(msg.sender);
365 
366         require(from_lccs >= _value);
367 
368         c_balances[msg.sender] = sub(c_balances[msg.sender], _value);
369         c_balances[_to] = add(c_balances[_to], _value);
370 
371         emit Transfer(msg.sender, _to, _value);
372         return true;
373     }
374 
375     function transferFrom(address _from, address _to, uint256 _value) stoppable public returns (bool) {
376         // uint never less than 0. The negative number will become to a big positive number
377         require(_value < c_totalSupply);
378         require(c_approvals[_from][msg.sender] >= _value);
379 
380         clearExpiredFreezing(_from);
381         uint from_lccs = validBalanceOf(_from);
382 
383         require(from_lccs >= _value);
384 
385         c_approvals[_from][msg.sender] = sub(c_approvals[_from][msg.sender], _value);
386         c_balances[_from] = sub(c_balances[_from], _value);
387         c_balances[_to] = add(c_balances[_to], _value);
388 
389         emit Transfer(_from, _to, _value);
390         return true;
391     }
392 }