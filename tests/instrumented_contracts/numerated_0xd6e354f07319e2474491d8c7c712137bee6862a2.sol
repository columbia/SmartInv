1 pragma solidity ^0.4.18;
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
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24     public
25     auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32     public
33     auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
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
75         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
76 
77         _;
78     }
79 }
80 contract DSStop is DSNote, DSAuth {
81 
82     bool public stopped;
83 
84     modifier stoppable {
85         require(!stopped);
86         _;
87     }
88     function stop() public auth note {
89         stopped = true;
90     }
91     function start() public auth note {
92         stopped = false;
93     }
94 
95 }
96 contract DSMath {
97     function add(uint x, uint y) internal pure returns (uint z) {
98         require((z = x + y) >= x);
99     }
100     function sub(uint x, uint y) internal pure returns (uint z) {
101         require((z = x - y) <= x);
102     }
103     function mul(uint x, uint y) internal pure returns (uint z) {
104         require(y == 0 || (z = x * y) / y == x);
105     }
106 }
107 
108 contract ERC20 {
109     /// @return total amount of tokens
110     function totalSupply() constant public returns (uint256 supply);
111 
112     /// @param _owner The address from which the balance will be retrieved
113     /// @return The balance
114     function balanceOf(address _owner) constant public returns (uint256 balance);
115 
116     /// @notice send `_value` token to `_to` from `msg.sender`
117     /// @param _to The address of the recipient
118     /// @param _value The amount of token to be transferred
119     /// @return Whether the transfer was successful or not
120     function transfer(address _to, uint256 _value) public returns (bool success);
121 
122     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
123     /// @param _from The address of the sender
124     /// @param _to The address of the recipient
125     /// @param _value The amount of token to be transferred
126     /// @return Whether the transfer was successful or not
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
128 
129     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
130     /// @param _spender The address of the account able to transfer the tokens
131     /// @param _value The amount of wei to be approved for transfer
132     /// @return Whether the approval was successful or not
133     function approve(address _spender, uint256 _value) public returns (bool success);
134 
135     /// @param _owner The address of the account owning tokens
136     /// @param _spender The address of the account able to transfer the tokens
137     /// @return Amount of remaining tokens allowed to spent
138     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
139 
140     event Transfer(address indexed _from, address indexed _to, uint256 _value);
141     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
142 }
143 
144 
145 contract Coin is ERC20, DSStop {
146     string internal c_name;
147     string internal c_symbol;
148     uint8 internal c_decimals = 0;
149     uint256 internal c_totalSupply;
150     mapping(address => uint256) internal c_balances;
151     mapping(address => mapping(address => uint256)) internal c_approvals;
152 
153     function init(uint256 total_lemos, string token_name, string token_symbol) internal {
154         c_balances[msg.sender] = total_lemos;
155         c_totalSupply = total_lemos;
156         c_name = token_name;
157         c_symbol = token_symbol;
158     }
159 
160     function() public {
161         assert(false);
162     }
163 
164     function name() constant public returns (string) {
165         return c_name;
166     }
167 
168     function symbol() constant public returns (string) {
169         return c_symbol;
170     }
171 
172     function decimals() constant public returns (uint8) {
173         return c_decimals;
174     }
175 
176     function totalSupply() constant public returns (uint256) {
177         return c_totalSupply;
178     }
179 
180     function balanceOf(address _owner) constant public returns (uint256) {
181         return c_balances[_owner];
182     }
183 
184     function approve(address _spender, uint256 _value) public stoppable returns (bool) {
185         // uint never less than 0. The negative number will become to a big positive number
186         require(_value < c_totalSupply);
187 
188         c_approvals[msg.sender][_spender] = _value;
189         Approval(msg.sender, _spender, _value);
190         return true;
191     }
192 
193     function allowance(address _owner, address _spender) constant public returns (uint256) {
194         return c_approvals[_owner][_spender];
195     }
196 
197 }
198 
199 contract FreezerAuthority is DSAuthority {
200     address[] internal c_freezers;
201     // sha3("setFreezing(address,uint256,uint256,uint8)").slice(0,10)
202     bytes4 constant setFreezingSig = bytes4(0x51c3b8a6);
203     // sha3("transferAndFreezing(address,uint256,uint256,uint256,uint8)").slice(0,10)
204     bytes4 constant transferAndFreezingSig = bytes4(0xb8a1fdb6);
205 
206     function canCall(address caller, address, bytes4 sig) public view returns (bool) {
207         // freezer can call setFreezing, transferAndFreezing
208         if (isFreezer(caller) && sig == setFreezingSig || sig == transferAndFreezingSig) {
209             return true;
210         } else {
211             return false;
212         }
213     }
214 
215     function addFreezer(address freezer) public {
216         int i = indexOf(c_freezers, freezer);
217         if (i < 0) {
218             c_freezers.push(freezer);
219         }
220     }
221 
222     function removeFreezer(address freezer) public {
223         int index = indexOf(c_freezers, freezer);
224         if (index >= 0) {
225             uint i = uint(index);
226             while (i < c_freezers.length - 1) {
227                 c_freezers[i] = c_freezers[i + 1];
228             }
229             c_freezers.length--;
230         }
231     }
232 
233     /** Finds the index of a given value in an array. */
234     function indexOf(address[] values, address value) internal pure returns (int) {
235         uint i = 0;
236         while (i < values.length) {
237             if (values[i] == value) {
238                 return int(i);
239             }
240             i++;
241         }
242         return int(- 1);
243     }
244 
245     function isFreezer(address addr) public constant returns (bool) {
246         return indexOf(c_freezers, addr) >= 0;
247     }
248 }
249 
250 contract LemoCoin is Coin, DSMath {
251     enum freezing_type_enum {
252         FUND_RAISING_FREEZING,
253         VIP_FREEZING
254     }
255 
256     //freezing struct
257     struct FreezingNode {
258         uint end_stamp;
259         uint num_lemos;
260         freezing_type_enum freezing_type;
261     }
262 
263     //freezing account list
264     mapping(address => FreezingNode []) internal c_freezing_list;
265 
266     function LemoCoin(uint256 total_lemos, string token_name, string token_symbol) public {
267         init(total_lemos, token_name, token_symbol);
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
279     event ClearExpiredFreezingEvent(address addr);
280     event SetFreezingEvent(address addr, uint end_stamp, uint num_lemos, freezing_type_enum freezing_type);
281 
282     function clearExpiredFreezing(address addr) public {
283         var nodes = c_freezing_list[addr];
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
308             ClearExpiredFreezingEvent(addr);
309         }
310     }
311 
312     function validBalanceOf(address addr) constant public returns (uint) {
313         var nodes = c_freezing_list[addr];
314         uint length = nodes.length;
315         uint total_lemos = balanceOf(addr);
316 
317         for (uint i = 0; i < length; ++i) {
318             if (nodes[i].end_stamp > block.timestamp) {
319                 total_lemos = sub(total_lemos, nodes[i].num_lemos);
320             }
321         }
322 
323         return total_lemos;
324     }
325 
326     function freezingBalanceNumberOf(address addr) constant public returns (uint) {
327         return c_freezing_list[addr].length;
328     }
329 
330     function freezingBalanceInfoOf(address addr, uint index) constant public returns (uint, uint, uint8) {
331         return (c_freezing_list[addr][index].end_stamp, c_freezing_list[addr][index].num_lemos, uint8(c_freezing_list[addr][index].freezing_type));
332     }
333 
334     function setFreezing(address addr, uint end_stamp, uint num_lemos, uint8 freezing_type) auth stoppable public {
335         require(block.timestamp < end_stamp);
336         // uint never less than 0. The negative number will become to a big positive number
337         require(num_lemos < c_totalSupply);
338         clearExpiredFreezing(addr);
339         uint valid_balance = validBalanceOf(addr);
340         require(valid_balance >= num_lemos);
341 
342         FreezingNode memory node = FreezingNode(end_stamp, num_lemos, freezing_type_enum(freezing_type));
343         c_freezing_list[addr].push(node);
344 
345         SetFreezingEvent(addr, end_stamp, num_lemos, freezing_type_enum(freezing_type));
346     }
347 
348     function transferAndFreezing(address _to, uint256 _value, uint256 freezeAmount, uint end_stamp, uint8 freezing_type) auth stoppable public returns (bool) {
349         // uint never less than 0. The negative number will become to a big positive number
350         require(_value < c_totalSupply);
351         require(freezeAmount <= _value);
352 
353         transfer(_to, _value);
354         setFreezing(_to, end_stamp, freezeAmount, freezing_type);
355 
356         return true;
357     }
358 
359     function transfer(address _to, uint256 _value) stoppable public returns (bool) {
360         // uint never less than 0. The negative number will become to a big positive number
361         require(_value < c_totalSupply);
362         clearExpiredFreezing(msg.sender);
363         uint from_lemos = validBalanceOf(msg.sender);
364 
365         require(from_lemos >= _value);
366 
367         c_balances[msg.sender] = sub(c_balances[msg.sender], _value);
368         c_balances[_to] = add(c_balances[_to], _value);
369 
370         Transfer(msg.sender, _to, _value);
371         return true;
372     }
373 
374     function transferFrom(address _from, address _to, uint256 _value) stoppable public returns (bool) {
375         // uint never less than 0. The negative number will become to a big positive number
376         require(_value < c_totalSupply);
377         require(c_approvals[_from][msg.sender] >= _value);
378 
379         clearExpiredFreezing(_from);
380         uint from_lemos = validBalanceOf(_from);
381 
382         require(from_lemos >= _value);
383 
384         c_approvals[_from][msg.sender] = sub(c_approvals[_from][msg.sender], _value);
385         c_balances[_from] = sub(c_balances[_from], _value);
386         c_balances[_to] = add(c_balances[_to], _value);
387 
388         Transfer(_from, _to, _value);
389         return true;
390     }
391 }