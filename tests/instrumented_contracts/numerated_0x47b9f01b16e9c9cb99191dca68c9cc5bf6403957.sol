1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-10
3 */
4 
5 // Sources flattened with hardhat v2.1.1 https://hardhat.org
6 
7 // File contracts/erc20/ERC20.sol
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.2;
12 
13 abstract contract ERC20 {
14 
15     uint256 private _totalSupply;
16     mapping(address => uint256) internal _balances;
17     mapping(address => mapping(address => uint256)) internal _allowances;
18 
19     event Transfer(address indexed from, address indexed to, uint256 amount);
20     event Approval(
21         address indexed owner,
22         address indexed spender,
23         uint256 amount
24     );
25 
26     /*
27    * Internal Functions for ERC20 standard logics
28    */
29 
30     function _transfer(address from, address to, uint256 amount)
31         internal
32         returns (bool success)
33     {
34         _balances[from] = _balances[from] - amount;
35         _balances[to] = _balances[to] + amount;
36         emit Transfer(from, to, amount);
37         success = true;
38     }
39 
40     function _approve(address owner, address spender, uint256 amount)
41         internal
42         returns (bool success)
43     {
44         _allowances[owner][spender] = amount;
45         emit Approval(owner, spender, amount);
46         success = true;
47     }
48 
49     function _mint(address recipient, uint256 amount)
50         internal
51         returns (bool success)
52     {
53         _totalSupply = _totalSupply + amount;
54         _balances[recipient] = _balances[recipient] + amount;
55         emit Transfer(address(0), recipient, amount);
56         success = true;
57     }
58 
59     function _burn(address burned, uint256 amount)
60         internal
61         returns (bool success)
62     {
63         _balances[burned] = _balances[burned] - amount;
64         _totalSupply = _totalSupply - amount;
65         emit Transfer(burned, address(0), amount);
66         success = true;
67     }
68 
69     /*
70    * public view functions to view common data
71    */
72 
73     function totalSupply() external view returns (uint256 total) {
74         total = _totalSupply;
75     }
76     function balanceOf(address owner) external view returns (uint256 balance) {
77         balance = _balances[owner];
78     }
79 
80     function allowance(address owner, address spender)
81         external
82         view
83         returns (uint256 remaining)
84     {
85         remaining = _allowances[owner][spender];
86     }
87 
88     /*
89    * External view Function Interface to implement on final contract
90    */
91     function name() virtual external view returns (string memory tokenName);
92     function symbol() virtual external view returns (string memory tokenSymbol);
93     function decimals() virtual external view returns (uint8 tokenDecimals);
94 
95     /*
96    * External Function Interface to implement on final contract
97    */
98     function transfer(address to, uint256 amount)
99         virtual
100         external
101         returns (bool success);
102     function transferFrom(address from, address to, uint256 amount)
103         virtual
104         external
105         returns (bool success);
106     function approve(address spender, uint256 amount)
107         virtual
108         external
109         returns (bool success);
110 }
111 
112 abstract contract Ownable {
113     address internal _owner;
114 
115     event OwnershipTransferred(
116         address indexed currentOwner,
117         address indexed newOwner
118     );
119 
120     constructor() {
121         _owner = msg.sender;
122         emit OwnershipTransferred(address(0), msg.sender);
123     }
124 
125     modifier onlyOwner() {
126         require(
127             msg.sender == _owner,
128             "Ownable : Function called by unauthorized user."
129         );
130         _;
131     }
132 
133     function owner() external view returns (address ownerAddress) {
134         ownerAddress = _owner;
135     }
136 
137     function transferOwnership(address newOwner)
138         public
139         onlyOwner
140         returns (bool success)
141     {
142         require(newOwner != address(0), "Ownable/transferOwnership : cannot transfer ownership to zero address");
143         success = _transferOwnership(newOwner);
144     }
145 
146     function renounceOwnership() external onlyOwner returns (bool success) {
147         success = _transferOwnership(address(0));
148     }
149 
150     function _transferOwnership(address newOwner) internal returns (bool success) {
151         emit OwnershipTransferred(_owner, newOwner);
152         _owner = newOwner;
153         success = true;
154     }
155 }
156 
157 
158 abstract contract ERC20Lockable is ERC20, Ownable {
159     struct LockInfo {
160         uint256 amount;
161         uint256 due;
162     }
163 
164     mapping(address => LockInfo[]) internal _locks;
165     mapping(address => uint256) internal _totalLocked;
166 
167     event Lock(address indexed from, uint256 amount, uint256 due);
168     event Unlock(address indexed from, uint256 amount);
169 
170     modifier checkLock(address from, uint256 amount) {
171         require(_balances[from] >= _totalLocked[from] + amount, "ERC20Lockable/Cannot send more than unlocked amount");
172         _;
173     }
174 
175     function _lock(address from, uint256 amount, uint256 due)
176     internal
177     returns (bool success)
178     {
179         require(due > block.timestamp, "ERC20Lockable/lock : Cannot set due to past");
180         require(
181             _balances[from] >= amount + _totalLocked[from],
182             "ERC20Lockable/lock : locked total should be smaller than balance"
183         );
184         _totalLocked[from] = _totalLocked[from] + amount;
185         _locks[from].push(LockInfo(amount, due));
186         emit Lock(from, amount, due);
187         success = true;
188     }
189 
190     function _unlock(address from, uint256 index) internal returns (bool success) {
191         LockInfo storage lock = _locks[from][index];
192         _totalLocked[from] = _totalLocked[from] - lock.amount;
193         emit Unlock(from, lock.amount);
194         _locks[from][index] = _locks[from][_locks[from].length - 1];
195         _locks[from].pop();
196         success = true;
197     }
198 
199     function unlock(address from, uint256 idx) external returns(bool success){
200         require(_locks[from][idx].due < block.timestamp,"ERC20Lockable/unlock: cannot unlock before due");
201         return _unlock(from, idx);
202     }
203 
204     function unlockAll(address from) external returns (bool success) {
205         for(uint256 i = 0; i < _locks[from].length;){
206             i++;
207             if(_locks[from][i - 1].due < block.timestamp){
208                 if(_unlock(from, i - 1)){
209                     i--;
210                 }
211             }
212         }
213         success = true;
214     }
215 
216     function releaseLock(address from)
217     external
218     onlyOwner
219     returns (bool success)
220     {
221         for(uint256 i = 0; i < _locks[from].length;){
222             i++;
223             if(_unlock(from, i - 1)){
224                 i--;
225             }
226         }
227         success = true;
228     }
229 
230     function transferWithLockUp(address recipient, uint256 amount, uint256 due)
231     external
232     onlyOwner
233     returns (bool success)
234     {
235         require(
236             recipient != address(0),
237             "ERC20Lockable/transferWithLockUp : Cannot send to zero address"
238         );
239         _transfer(msg.sender, recipient, amount);
240         _lock(recipient, amount, due);
241         success = true;
242     }
243 
244     function lockInfo(address locked, uint256 index)
245     external
246     view
247     returns (uint256 amount, uint256 due)
248     {
249         LockInfo memory lock = _locks[locked][index];
250         amount = lock.amount;
251         due = lock.due;
252     }
253 
254     function totalLocked(address locked) external view returns(uint256 amount, uint256 length){
255         amount = _totalLocked[locked];
256         length = _locks[locked].length;
257     }
258 }
259 
260 abstract contract ERC20Burnable is ERC20 {
261     event Burn(address indexed burned, uint256 amount);
262 
263     function burn(uint256 amount) 
264     external
265     returns (bool success)
266     {
267         success = _burn(msg.sender, amount);
268         emit Burn(msg.sender, amount);
269         success = true;
270     }
271 
272     function burnFrom(address burned, uint256 amount) 
273     external
274     returns (bool success)
275     {
276         _burn(burned, amount);
277         emit Burn(burned, amount);
278         success = _approve(
279             burned,
280             msg.sender,
281             _allowances[burned][msg.sender] - amount
282         );
283     }
284 }
285 
286 contract ONSTON is
287     ERC20Lockable,
288     ERC20Burnable
289 {
290     string constant private _name = "ONSTON";
291     string constant private _symbol = "ONSTON";
292     uint8 constant private _decimals = 18;
293     uint256 constant private _initial_supply = 1_000_000_000;
294 
295     constructor(address _owner) Ownable() {
296         _mint(_owner, _initial_supply * (10**uint256(_decimals)));
297         _transferOwnership(_owner);
298     }
299 
300     function transfer(address to, uint256 amount)
301         override
302         external
303         checkLock(msg.sender, amount)
304         returns (bool success)
305     {
306         require(
307             to != address(0),
308             "ONSTON/transfer : Should not send to zero address"
309         );
310         _transfer(msg.sender, to, amount);
311         success = true;
312     }
313 
314     function transferFrom(address from, address to, uint256 amount)
315         override
316         external
317         checkLock(from, amount)
318         returns (bool success)
319     {
320         require(
321             to != address(0),
322             "ONSTON/transferFrom : Should not send to zero address"
323         );
324         _transfer(from, to, amount);
325         _approve(
326             from,
327             msg.sender,
328             _allowances[from][msg.sender] - amount
329         );
330         success = true;
331     }
332 
333     function approve(address spender, uint256 amount)
334         override
335         external
336         returns (bool success)
337     {
338         require(
339             spender != address(0),
340             "ONSTON/approve : Should not approve zero address"
341         );
342         _approve(msg.sender, spender, amount);
343         success = true;
344     }
345 
346     function name() override external pure returns (string memory tokenName) {
347         tokenName = _name;
348     }
349 
350     function symbol() override external pure returns (string memory tokenSymbol) {
351         tokenSymbol = _symbol;
352     }
353 
354     function decimals() override external pure returns (uint8 tokenDecimals) {
355         tokenDecimals = _decimals;
356     }
357 }