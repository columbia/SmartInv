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
154     mapping(address => uint256) internal c_balances;
155     mapping(address => mapping(address => uint256)) internal c_approvals;
156 
157     function init(uint256 token_supply, string token_name, string token_symbol) internal {
158         c_balances[msg.sender] = token_supply;
159         c_totalSupply = token_supply;
160         name = token_name;
161         symbol = token_symbol;
162     }
163 
164     function() public {
165         assert(false);
166     }
167 
168     function setName(string _name) auth public {
169         name = _name;
170     }
171 
172     function totalSupply() constant public returns (uint256) {
173         return c_totalSupply;
174     }
175 
176     function balanceOf(address _owner) constant public returns (uint256) {
177         return c_balances[_owner];
178     }
179 
180     function approve(address _spender, uint256 _value) public stoppable returns (bool) {
181         require(msg.data.length >= (2 * 32) + 4);
182         require(_value == 0 || c_approvals[msg.sender][_spender] == 0);
183         // uint never less than 0. The negative number will become to a big positive number
184         require(_value < c_totalSupply);
185 
186         c_approvals[msg.sender][_spender] = _value;
187         emit Approval(msg.sender, _spender, _value);
188         return true;
189     }
190 
191     function allowance(address _owner, address _spender) constant public returns (uint256) {
192         return c_approvals[_owner][_spender];
193     }
194 }
195 
196 contract FreezerAuthority is DSAuthority {
197     address[] internal c_freezers;
198     // sha3("setFreezing(address,uint256,uint256,uint8)").slice(0,10)
199     bytes4 constant setFreezingSig = bytes4(0x51c3b8a6);
200     // sha3("transferAndFreezing(address,uint256,uint256,uint256,uint8)").slice(0,10)
201     bytes4 constant transferAndFreezingSig = bytes4(0xb8a1fdb6);
202 
203     function canCall(address caller, address, bytes4 sig) public view returns (bool) {
204         // freezer can call setFreezing, transferAndFreezing
205         if (isFreezer(caller) && (sig == setFreezingSig || sig == transferAndFreezingSig)) {
206             return true;
207         } else {
208             return false;
209         }
210     }
211 
212     function addFreezer(address freezer) public {
213         int i = indexOf(c_freezers, freezer);
214         if (i < 0) {
215             c_freezers.push(freezer);
216         }
217     }
218 
219     function removeFreezer(address freezer) public {
220         int index = indexOf(c_freezers, freezer);
221         if (index >= 0) {
222             uint i = uint(index);
223             while (i < c_freezers.length - 1) {
224                 c_freezers[i] = c_freezers[i + 1];
225             }
226             c_freezers.length--;
227         }
228     }
229 
230     /** Finds the index of a given value in an array. */
231     function indexOf(address[] values, address value) internal pure returns (int) {
232         uint i = 0;
233         while (i < values.length) {
234             if (values[i] == value) {
235                 return int(i);
236             }
237             i++;
238         }
239         return int(- 1);
240     }
241 
242     function isFreezer(address addr) public constant returns (bool) {
243         return indexOf(c_freezers, addr) >= 0;
244     }
245 }
246 
247 contract LemoCoin is Coin, DSMath {
248     // freezing struct
249     struct FreezingNode {
250         uint end_stamp;
251         uint num_lemos;
252         uint8 freezing_type;
253     }
254 
255     // freezing account list
256     mapping(address => FreezingNode[]) internal c_freezing_list;
257 
258     constructor(uint256 token_supply, string token_name, string token_symbol) public {
259         init(token_supply, token_name, token_symbol);
260         setAuthority(new FreezerAuthority());
261     }
262 
263     function addFreezer(address freezer) auth public {
264         FreezerAuthority(authority).addFreezer(freezer);
265     }
266 
267     function removeFreezer(address freezer) auth public {
268         FreezerAuthority(authority).removeFreezer(freezer);
269     }
270 
271     event ClearExpiredFreezingEvent(address indexed addr);
272     event SetFreezingEvent(address indexed addr, uint end_stamp, uint num_lemos, uint8 indexed freezing_type);
273 
274     function clearExpiredFreezing(address addr) public {
275         FreezingNode[] storage nodes = c_freezing_list[addr];
276         uint length = nodes.length;
277 
278         // find first expired index
279         uint left = 0;
280         while (left < length) {
281             // not freezing any more
282             if (nodes[left].end_stamp <= block.timestamp) {
283                 break;
284             }
285             left++;
286         }
287 
288         // next frozen index
289         uint right = left + 1;
290         while (left < length && right < length) {
291             // still freezing
292             if (nodes[right].end_stamp > block.timestamp) {
293                 nodes[left] = nodes[right];
294                 left++;
295             }
296             right++;
297         }
298         if (length != left) {
299             nodes.length = left;
300             emit ClearExpiredFreezingEvent(addr);
301         }
302     }
303 
304     function validBalanceOf(address addr) constant public returns (uint) {
305         FreezingNode[] memory nodes = c_freezing_list[addr];
306         uint length = nodes.length;
307         uint total_lemos = balanceOf(addr);
308 
309         for (uint i = 0; i < length; ++i) {
310             if (nodes[i].end_stamp > block.timestamp) {
311                 total_lemos = sub(total_lemos, nodes[i].num_lemos);
312             }
313         }
314 
315         return total_lemos;
316     }
317 
318     function freezingBalanceNumberOf(address addr) constant public returns (uint) {
319         return c_freezing_list[addr].length;
320     }
321 
322     function freezingBalanceInfoOf(address addr, uint index) constant public returns (uint, uint, uint8) {
323         return (c_freezing_list[addr][index].end_stamp, c_freezing_list[addr][index].num_lemos, uint8(c_freezing_list[addr][index].freezing_type));
324     }
325 
326     function setFreezing(address addr, uint end_stamp, uint num_lemos, uint8 freezing_type) auth stoppable public {
327         require(block.timestamp < end_stamp);
328         // uint never less than 0. The negative number will become to a big positive number
329         require(num_lemos < c_totalSupply);
330         clearExpiredFreezing(addr);
331         uint valid_balance = validBalanceOf(addr);
332         require(valid_balance >= num_lemos);
333 
334         FreezingNode memory node = FreezingNode(end_stamp, num_lemos, freezing_type);
335         c_freezing_list[addr].push(node);
336 
337         emit SetFreezingEvent(addr, end_stamp, num_lemos, freezing_type);
338     }
339 
340     function transferAndFreezing(address _to, uint256 _value, uint256 freeze_amount, uint end_stamp, uint8 freezing_type) auth stoppable public returns (bool) {
341         // uint never less than 0. The negative number will become to a big positive number
342         require(_value < c_totalSupply);
343         require(freeze_amount <= _value);
344 
345         transfer(_to, _value);
346         setFreezing(_to, end_stamp, freeze_amount, freezing_type);
347 
348         return true;
349     }
350 
351     function transfer(address _to, uint256 _value) stoppable public returns (bool) {
352         require(msg.data.length >= (2 * 32) + 4);
353         // uint never less than 0. The negative number will become to a big positive number
354         require(_value < c_totalSupply);
355         clearExpiredFreezing(msg.sender);
356         uint from_lemos = validBalanceOf(msg.sender);
357 
358         require(from_lemos >= _value);
359 
360         c_balances[msg.sender] = sub(c_balances[msg.sender], _value);
361         c_balances[_to] = add(c_balances[_to], _value);
362 
363         emit Transfer(msg.sender, _to, _value);
364         return true;
365     }
366 
367     function transferFrom(address _from, address _to, uint256 _value) stoppable public returns (bool) {
368         // uint never less than 0. The negative number will become to a big positive number
369         require(_value < c_totalSupply);
370         require(c_approvals[_from][msg.sender] >= _value);
371 
372         clearExpiredFreezing(_from);
373         uint from_lemos = validBalanceOf(_from);
374 
375         require(from_lemos >= _value);
376 
377         c_approvals[_from][msg.sender] = sub(c_approvals[_from][msg.sender], _value);
378         c_balances[_from] = sub(c_balances[_from], _value);
379         c_balances[_to] = add(c_balances[_to], _value);
380 
381         emit Transfer(_from, _to, _value);
382         return true;
383     }
384 }