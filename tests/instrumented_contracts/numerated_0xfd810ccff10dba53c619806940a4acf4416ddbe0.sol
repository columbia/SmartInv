1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function name() public view returns(bytes32);
5     function symbol() public view returns(bytes32);
6     function balanceOf (address _owner) public view returns(uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (uint);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 }
11 
12 
13 contract AppCoins is ERC20Interface{
14     // Public variables of the token
15     address public owner;
16     bytes32 private token_name;
17     bytes32 private token_symbol;
18     uint8 public decimals = 18;
19     // 18 decimals is the strongly suggested default, avoid changing it
20     uint256 public totalSupply;
21 
22     // This creates an array with all balances
23     mapping (address => uint256) public balances;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     // This notifies clients about the amount burnt
30     event Burn(address indexed from, uint256 value);
31 
32 
33     function AppCoins() public {
34         owner = msg.sender;
35         token_name = "AppCoins";
36         token_symbol = "APPC";
37         uint256 _totalSupply = 1000000;
38         totalSupply = _totalSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balances[owner] = totalSupply;                // Give the creator all initial tokens
40     }
41 
42     function name() public view returns(bytes32) {
43         return token_name;
44     }
45 
46     function symbol() public view returns(bytes32) {
47         return token_symbol;
48     }
49 
50     function balanceOf (address _owner) public view returns(uint256 balance) {
51         return balances[_owner];
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balances[_from] >= _value);
62         // Check for overflows
63         require(balances[_to] + _value > balances[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balances[_from] + balances[_to];
66         // Subtract from the sender
67         balances[_from] -= _value;
68         // Add the same to the recipient
69         balances[_to] += _value;
70         emit Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balances[_from] + balances[_to] == previousBalances);
73     }
74 
75 
76     function transfer (address _to, uint256 _amount) public returns (bool success) {
77         if( balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
78 
79             balances[msg.sender] -= _amount;
80             balances[_to] += _amount;
81             emit Transfer(msg.sender, _to, _amount);
82             return true;
83         } else {
84             return false;
85         }
86     }
87 
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (uint) {
90         require(_value <= allowance[_from][msg.sender]);     // Check allowance
91         allowance[_from][msg.sender] -= _value;
92         _transfer(_from, _to, _value);
93         return allowance[_from][msg.sender];
94     }
95 
96 
97     function approve(address _spender, uint256 _value) public
98         returns (bool success) {
99         allowance[msg.sender][_spender] = _value;
100         return true;
101     }
102 
103 
104     function burn(uint256 _value) public returns (bool success) {
105         require(balances[msg.sender] >= _value);   // Check if the sender has enough
106         balances[msg.sender] -= _value;            // Subtract from the sender
107         totalSupply -= _value;                      // Updates totalSupply
108         emit Burn(msg.sender, _value);
109         return true;
110     }
111 
112 
113     function burnFrom(address _from, uint256 _value) public returns (bool success) {
114         require(balances[_from] >= _value);                // Check if the targeted balance is enough
115         require(_value <= allowance[_from][msg.sender]);    // Check allowance
116         balances[_from] -= _value;                         // Subtract from the targeted balance
117         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
118         totalSupply -= _value;                              // Update totalSupply
119         emit Burn(_from, _value);
120         return true;
121     }
122 }
123 
124 
125 interface ErrorThrower {
126     event Error(string func, string message);
127 }
128 
129 
130 contract Ownable is ErrorThrower {
131     address public owner;
132     
133     event OwnershipRenounced(address indexed previousOwner);
134     event OwnershipTransferred(
135         address indexed previousOwner,
136         address indexed newOwner
137     );
138 
139 
140 
141     constructor() public {
142         owner = msg.sender;
143     }
144 
145 
146     modifier onlyOwner(string _funcName) {
147         if(msg.sender != owner){
148             emit Error(_funcName,"Operation can only be performed by contract owner");
149             return;
150         }
151         _;
152     }
153 
154 
155     function renounceOwnership() public onlyOwner("renounceOwnership") {
156         emit OwnershipRenounced(owner);
157         owner = address(0);
158     }
159 
160 
161     function transferOwnership(address _newOwner) public onlyOwner("transferOwnership") {
162         _transferOwnership(_newOwner);
163     }
164 
165 
166     function _transferOwnership(address _newOwner) internal {
167         if(_newOwner == address(0)){
168             emit Error("transferOwnership","New owner's address needs to be different than 0x0");
169             return;
170         }
171 
172         emit OwnershipTransferred(owner, _newOwner);
173         owner = _newOwner;
174     }
175 }
176 
177 
178 library Roles {
179   struct Role {
180     mapping (address => bool) bearer;
181   }
182 
183 
184   function add(Role storage _role, address _addr)
185     internal
186   {
187     _role.bearer[_addr] = true;
188   }
189 
190   function remove(Role storage _role, address _addr)
191     internal
192   {
193     _role.bearer[_addr] = false;
194   }
195 
196 
197   function check(Role storage _role, address _addr)
198     internal
199     view
200   {
201     require(has(_role, _addr));
202   }
203 
204   function has(Role storage _role, address _addr)
205     internal
206     view
207     returns (bool)
208   {
209     return _role.bearer[_addr];
210   }
211 }
212 
213 
214 contract RBAC {
215   using Roles for Roles.Role;
216 
217   mapping (string => Roles.Role) private roles;
218 
219   event RoleAdded(address indexed operator, string role);
220   event RoleRemoved(address indexed operator, string role);
221 
222   function checkRole(address _operator, string _role)
223     public
224     view
225   {
226     roles[_role].check(_operator);
227   }
228 
229   function hasRole(address _operator, string _role)
230     public
231     view
232     returns (bool)
233   {
234     return roles[_role].has(_operator);
235   }
236 
237 
238   function addRole(address _operator, string _role)
239     internal
240   {
241     roles[_role].add(_operator);
242     emit RoleAdded(_operator, _role);
243   }
244 
245 
246   function removeRole(address _operator, string _role)
247     internal
248   {
249     roles[_role].remove(_operator);
250     emit RoleRemoved(_operator, _role);
251   }
252 
253 
254   modifier onlyRole(string _role)
255   {
256     checkRole(msg.sender, _role);
257     _;
258   }
259 
260 }
261 
262 
263 contract Whitelist is Ownable, RBAC {
264     string public constant ROLE_WHITELISTED = "whitelist";
265 
266 
267     modifier onlyIfWhitelisted(string _funcname, address _operator) {
268         if(!hasRole(_operator, ROLE_WHITELISTED)){
269             emit Error(_funcname, "Operation can only be performed by Whitelisted Addresses");
270             return;
271         }
272         _;
273     }
274 
275 
276     function addAddressToWhitelist(address _operator)
277         public
278         onlyOwner("addAddressToWhitelist")
279     {
280         addRole(_operator, ROLE_WHITELISTED);
281     }
282 
283 
284     function whitelist(address _operator)
285         public
286         view
287         returns (bool)
288     {
289         return hasRole(_operator, ROLE_WHITELISTED);
290     }
291 
292 
293     function addAddressesToWhitelist(address[] _operators)
294         public
295         onlyOwner("addAddressesToWhitelist")
296     {
297         for (uint256 i = 0; i < _operators.length; i++) {
298             addAddressToWhitelist(_operators[i]);
299         }
300     }
301 
302 
303     function removeAddressFromWhitelist(address _operator)
304         public
305         onlyOwner("removeAddressFromWhitelist")
306     {
307         removeRole(_operator, ROLE_WHITELISTED);
308     }
309 
310     function removeAddressesFromWhitelist(address[] _operators)
311         public
312         onlyOwner("removeAddressesFromWhitelist")
313     {
314         for (uint256 i = 0; i < _operators.length; i++) {
315             removeAddressFromWhitelist(_operators[i]);
316         }
317     }
318 
319 }
320 
321 contract AppCoinsCreditsBalance is Whitelist {
322 
323     // AppCoins token
324     AppCoins private appc;
325 
326     // balance proof
327     bytes private balanceProof;
328 
329     // balance
330     uint private balance;
331 
332     event BalanceProof(bytes _merkleTreeHash);
333     event Deposit(uint _amount);
334     event Withdraw(uint _amount);
335 
336     constructor(
337         address _addrAppc
338     )
339     public
340     {
341         appc = AppCoins(_addrAppc);
342     }
343 
344 
345     function getBalance() public view returns(uint256) {
346         return balance;
347     }
348 
349     function getBalanceProof() public view returns(bytes) {
350         return balanceProof;
351     }
352 
353  
354     function registerBalanceProof(bytes _merkleTreeHash)
355         internal{
356 
357         balanceProof = _merkleTreeHash;
358 
359         emit BalanceProof(_merkleTreeHash);
360     }
361 
362     function depositFunds(uint _amount, bytes _merkleTreeHash)
363         public
364         onlyIfWhitelisted("depositFunds", msg.sender){
365         require(appc.allowance(msg.sender, address(this)) >= _amount);
366         registerBalanceProof(_merkleTreeHash);
367         appc.transferFrom(msg.sender, address(this), _amount);
368         balance = balance + _amount;
369         emit Deposit(_amount);
370     }
371 
372     function withdrawFunds(uint _amount, bytes _merkleTreeHash)
373         public
374         onlyOwner("withdrawFunds"){
375         require(balance >= _amount);
376         registerBalanceProof(_merkleTreeHash);
377         appc.transfer(msg.sender, _amount);
378         balance = balance - _amount;
379         emit Withdraw(_amount);
380     }
381 
382 }