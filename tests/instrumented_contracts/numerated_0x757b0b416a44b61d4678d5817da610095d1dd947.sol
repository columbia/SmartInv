1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7 
8     function safeMul(uint a, uint b)pure internal returns (uint) {
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function safeDiv(uint a, uint b)pure internal returns (uint) {
15         assert(b > 0);
16         uint c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function safeSub(uint a, uint b)pure internal returns (uint) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function safeAdd(uint a, uint b)pure internal returns (uint) {
27         uint c = a + b;
28         assert(c>=a && c>=b);
29         return c;
30     }
31 }
32 
33 /*
34  * Base Token for ERC20 compatibility
35  * ERC20 interface 
36  * see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20 {
39     function balanceOf(address who) public view returns (uint);
40     function allowance(address owner, address spender) public view returns (uint);
41     function transfer(address to, uint value) public returns (bool ok);
42     function transferFrom(address from, address to, uint value) public returns (bool ok);
43     function approve(address spender, uint value) public returns (bool ok);
44     event Transfer(address indexed from, address indexed to, uint value);
45     event Approval(address indexed owner, address indexed spender, uint value);
46 }
47 
48 /*
49  * Ownable
50  *
51  * Base contract with an owner.
52  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
53  */
54 contract Ownable {
55     /* Address of the owner */
56     address public owner;
57 
58     constructor() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address newOwner) onlyOwner public{
68         require(newOwner != owner);
69         require(newOwner != address(0));
70         owner = newOwner;
71     }
72 }
73 
74 contract AddressHolder {
75     address[] internal addresses;
76 
77     function inArray(address _addr) public view returns(bool){
78         for(uint i = 0; i < addresses.length; i++){
79             if(_addr == addresses[i]){
80                 return true;
81             }
82         }
83         return false;
84     }
85 
86     function addAddress(address _addr) public {
87         addresses.push(_addr);
88     }
89 
90     function showAddresses() public view returns(address[] ){
91         return addresses;
92     }
93 
94     function totalUsers() public view returns(uint count){
95         return addresses.length;
96     }
97 }
98 
99 contract Freezable is Ownable{
100 
101     // determines if all account got frozen.
102     bool internal accountsFrozen;
103 
104     // list of all the admins in the system
105     mapping (address => bool) internal admins;
106 
107     // list of the frozen accounts
108     mapping (address => bool) public frozenAccount;
109     event FrozenFunds(address target, bool frozen);
110 
111     constructor() public {
112         admins[msg.sender] = true;
113     }
114 
115     function freezeAccount(address target, bool freeze) onlyOwner public{
116         frozenAccount[target] = freeze;
117         emit FrozenFunds(target, freeze);
118     }
119 
120     function unFreezeAccount(address target) onlyOwner public{
121         frozenAccount[target] = false;
122         emit FrozenFunds(target, false);
123     }
124     
125     function makeAdmin(address target, bool isAdmin) onlyOwner public{
126         admins[target] = isAdmin;
127     }
128 
129     function revokeAdmin(address target) onlyOwner public {
130         admins[target] = false;
131     }
132 
133     function freezeAll() onlyOwner public{
134         accountsFrozen = true;
135     }
136 
137     function unfreezeAll() onlyOwner public {
138         accountsFrozen = false;
139     }
140 
141     modifier isAdmin() {
142         require(admins[msg.sender] == true);
143         _;
144     }
145 }
146 
147 /**
148  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
149  *
150  * Based on code by FirstBlood:
151  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, SafeMath, Freezable, AddressHolder{
154 
155     event Burn(address indexed from, uint value);
156 
157     /* Actual balances of token holders */
158     mapping(address => uint) balances;
159     uint public totalSupply;
160 
161     /* approve() allowances */
162     mapping (address => mapping (address => uint)) internal allowed;
163     
164     /**
165      *
166      * Transfer with ERC223 specification
167      *
168      * http://vessenes.com/the-erc20-short-address-attack-explained/
169      */
170     function transfer(address _to, uint _value) 
171     public
172     returns (bool success)
173     {
174         require(_to != address(0));
175 
176         //add new address to the addresses array
177         if(!inArray(_to)){
178             addAddress(_to);
179         }
180         require(balances[msg.sender] >= _value);
181         require(_value > 0);
182         require(!frozenAccount[msg.sender]);
183         require(!accountsFrozen || admins[msg.sender] == true);
184         balances[msg.sender] = safeSub(balances[msg.sender], _value);
185         balances[_to] = safeAdd(balances[_to], _value);
186         emit Transfer(msg.sender, _to, _value);
187         return true;
188     }
189 
190     function transferFrom(address _from, address _to, uint _value)
191     public
192     returns (bool success) 
193     {
194         require(_to != address(0));
195         require(_value <= balances[_from]);
196         require(_value <= allowed[_from][msg.sender]);
197         require(!frozenAccount[msg.sender]);
198         require(!accountsFrozen || admins[msg.sender] == true);
199 
200         //add new address to the addresses array
201         if(!inArray(_to)){
202             addAddress(_to);
203         }
204 
205         uint _allowance = allowed[_from][msg.sender];
206         balances[_to] = safeAdd(balances[_to], _value);
207         balances[_from] = safeSub(balances[_from], _value);
208         allowed[_from][msg.sender] = safeSub(_allowance, _value);
209         emit Transfer(_from, _to, _value);
210         return true;
211     }
212 
213     function balanceOf(address _owner) public view returns (uint balance) {
214         return balances[_owner];
215     }
216 
217     function approve(address _spender, uint _value) 
218     public
219     returns (bool success)
220     {
221         require(_spender != address(0));
222 
223         //add new address to the addresses array
224         if(!inArray(_spender)){
225             addAddress(_spender);
226         }
227         // To change the approve amount you first have to reduce the addresses`
228         //    allowance to zero by calling `approve(_spender, 0)` if it is not
229         //    already 0 to mitigate the race condition described here:
230         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231         //if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
232         require(_value == 0 || allowed[msg.sender][_spender] == 0);
233         allowed[msg.sender][_spender] = _value;
234         emit Approval(msg.sender, _spender, _value);
235         return true;
236     }
237 
238     /**
239      * approve should be called when allowed[_spender] == 0. To increment
240      * allowed value is better to use this function to avoid 2 calls (and wait until
241      * the first transaction is mined)
242      * From MonolithDAO Token.sol
243      */
244     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245         //add new address to the addresses array
246         if(!inArray(_spender)){
247             addAddress(_spender);
248         }
249         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
255         uint oldValue = allowed[msg.sender][_spender];
256         if (_subtractedValue > oldValue) {
257             allowed[msg.sender][_spender] = 0;
258         } else {
259             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
260         }
261         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262         return true;
263     }
264 
265     function allowance(address _owner, address _spender) public view returns (uint remaining) {
266         return allowed[_owner][_spender];
267     }
268 
269     function burn(address from, uint amount) onlyOwner public{
270         require(balances[from] >= amount && amount > 0);
271         balances[from] = safeSub(balances[from],amount);
272         totalSupply = safeAdd(totalSupply, amount);
273         emit Transfer(from, address(0), amount);
274         emit Burn(from, amount);
275     }
276 
277     function burn(uint amount) onlyOwner public {
278         burn(msg.sender, amount);
279     }
280 }
281 
282 contract Geco is StandardToken {
283     string public name;
284     uint8 public decimals; 
285     string public symbol;
286     string public version = "1.0";
287     uint totalEthInWei;
288 
289     constructor() public{
290         decimals = 18;     // Amount of decimals for display purposes
291         totalSupply = 100000000 * 10 ** uint256(decimals);    // Give the creator all initial tokens
292         balances[msg.sender] = totalSupply;     // Update total supply
293         name = "GreenEminer";    // Set the name for display purposes
294         symbol = "GECO";    // Set the symbol for display purposes
295 
296         //add owner to the addresses array
297         addAddress(msg.sender);
298     }
299 
300     /* Approves and then calls the receiving contract */
301     function approveAndCall(address _spender, uint256 _value, bytes _extraData) 
302     public
303     returns (bool success) {
304         allowed[msg.sender][_spender] = _value;
305         emit Approval(msg.sender, _spender, _value);
306         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
307         return true;
308     }
309 
310     // can accept ether
311     function() payable public{
312         revert();
313     }
314 }