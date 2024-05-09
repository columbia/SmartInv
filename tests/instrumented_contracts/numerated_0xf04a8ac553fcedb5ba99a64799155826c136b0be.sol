1 /*
2  * ERC20 interface
3  * see https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6   uint public totalSupply; // Number of tokens in circulation
7   function balanceOf(address who) constant returns (uint);
8   function allowance(address owner, address spender) constant returns (uint);
9 
10   function transfer(address to, uint value) returns (bool ok);
11   function transferFrom(address from, address to, uint value) returns (bool ok);
12   function approve(address spender, uint value) returns (bool ok);
13 
14   event Transfer(address indexed from, address indexed to, uint value);
15   event Approval(address indexed owner, address indexed spender, uint value);
16 }
17 
18 
19 /**
20  * Math operations with safety checks
21  * Reference: https://github.com/OpenZeppelin/zeppelin-solidity/commit/353285e5d96477b4abb86f7cde9187e84ed251ac
22  */
23 contract SafeMath {
24   function safeMul(uint a, uint b) internal constant returns (uint) {
25     uint c = a * b;
26 
27     assert(a == 0 || c / a == b);
28 
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal constant returns (uint) {    
33     uint c = a / b;
34 
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal constant returns (uint) {
39     require(b <= a);
40 
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal constant returns (uint) {
45     uint c = a + b;
46 
47     assert(c>=a && c>=b);
48 
49     return c;
50   }
51 }
52 
53 
54 /*
55  * Standard ERC20 token
56  *
57  * https://github.com/ethereum/EIPs/issues/20
58  */
59 contract Token is ERC20, SafeMath {
60 
61   mapping(address => uint) balances;
62   mapping (address => mapping (address => uint)) allowed;
63 
64   function transfer(address _to, uint _value) returns (bool success) {
65 
66     return doTransfer(msg.sender, _to, _value);
67   }
68 
69   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
70     var _allowance = allowed[_from][msg.sender];
71 
72     allowed[_from][msg.sender] = safeSub(_allowance, _value);
73 
74     return doTransfer(_from, _to, _value);
75   }
76 
77   /// @notice You must set the allowance to zero before changing to a non-zero value
78   function approve(address _spender, uint _value) public returns (bool success) {
79     require(allowed[msg.sender][_spender] == 0 || _value == 0);
80 
81     allowed[msg.sender][_spender] = _value;
82 
83     Approval(msg.sender, _spender, _value);
84 
85     return true;
86   }
87 
88   function doTransfer(address _from, address _to, uint _value) private returns (bool success) {
89     balances[_from] = safeSub(balances[_from], _value);
90     balances[_to] = safeAdd(balances[_to], _value);
91 
92     Transfer(_from, _to, _value);
93 
94     return true;
95   }
96 
97   function balanceOf(address _owner) public constant returns (uint balance) {
98     return balances[_owner];
99   }
100 
101   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
102     return allowed[_owner][_spender];
103   }
104 }
105 
106 contract MintInterface {
107   function mint(address recipient, uint amount) returns (bool success);
108 }
109 
110 
111 /*
112  * Manages the ownership of a contract
113  */
114 contract Owned {
115     address public owner; // owner of the contract. By default, the creator of the contract
116 
117     modifier onlyOwner() {
118       require(msg.sender == owner);
119 
120         _;
121     }
122 
123     function Owned() {
124         owner = msg.sender;
125     }
126 
127     // Changes the owner of the contract to "newOwner"
128     // Only executed by "owner"
129     // If you want to completely remove the ownership of a contract, just change it to "0x0"
130     function changeOwner(address newOwner) public onlyOwner {
131       owner = newOwner;
132     }
133 }
134 
135 /*
136  * Manage the minters of a token
137  */
138 contract Minted is MintInterface, Owned {
139   uint public numMinters; // Number of minters of the token.
140   bool public open; // If is possible to add new minters or not. True by default.
141   mapping (address => bool) public minters; // if an address is a minter of the token or not
142 
143   // Log of the minters added
144   event NewMinter(address who);
145 
146   modifier onlyMinters() {
147     require(minters[msg.sender]);
148 
149     _;
150   }
151 
152   modifier onlyIfOpen() {
153     require(open);
154 
155     _;
156   }
157 
158   function Minted() {
159     open = true;
160   }
161 
162   // Adds a new minter to the token
163   // _minter: address of the new minter
164   // Only executed by "Owner" (see "Owned" contract)
165   // Only executed if the function "endMinting" has not been executed
166   function addMinter(address _minter) public onlyOwner onlyIfOpen {
167     if(!minters[_minter]) {
168       minters[_minter] = true;
169       numMinters++;
170 
171       NewMinter(_minter);
172     }
173   }
174 
175   // Removes a minter of the token
176   // _minter: address of the minter to be removed
177   // Only executed by "Owner" (see "Owned" contract)
178   function removeMinter(address _minter) public onlyOwner {
179     if(minters[_minter]) {
180       minters[_minter] = false;
181       numMinters--;
182     }
183   }
184 
185   // Blocks the possibility to add new minters
186   // This function is irreversible
187   // Only executed by "Owner" (see "Owned" contract)
188   function endMinting() public onlyOwner {
189     open = false;
190   }
191 }
192 
193 /*
194  * Allows an address to set a block from when a token won't be tradeable
195  */
196 contract Pausable is Owned {
197   // block from when the token won't be tradeable
198   // Default to 0 = no restriction
199   uint public endBlock;
200 
201   modifier validUntil() {
202     require(block.number <= endBlock || endBlock == 0);
203 
204     _;
205   }
206 
207   // Set a block from when a token won't be tradeable
208   // There is no limit in the number of executions to avoid irreversible mistakes.
209   // Only executed by "Owner" (see "Owned" contract)
210   function setEndBlock(uint block) public onlyOwner {
211     endBlock = block;
212   }
213 }
214 
215 
216 /*
217  * Token contract
218  */
219 contract ProjectToken is Token, Minted, Pausable {
220   string public name; // name of the token
221   string public symbol; // acronim of the token
222   uint public decimals; // number of decimals of the token
223 
224   uint public transferableBlock; // block from which the token can de transfered
225 
226   modifier lockUpPeriod() {
227     require(block.number >= transferableBlock);
228 
229     _;
230   }
231 
232   function ProjectToken(
233     string _name,
234     string _symbol,
235     uint _decimals,
236     uint _transferableBlock
237   ) {
238     name = _name;
239     symbol = _symbol;
240     decimals = _decimals;
241     transferableBlock = _transferableBlock;
242   }
243 
244   // Creates "amount" tokens and send them to "recipient" address
245   // Only executed by authorized minters (see "Minted" contract)
246   function mint(address recipient, uint amount)
247     public
248     onlyMinters
249     returns (bool success)
250   {
251     totalSupply = safeAdd(totalSupply, amount);
252     balances[recipient] = safeAdd(balances[recipient], amount);
253 
254     Transfer(0x0, recipient, amount);
255 
256     return true;
257   }
258 
259   // Aproves "_spender" to spend "_value" tokens and executes its "receiveApproval" function
260   function approveAndCall(address _spender, uint256 _value)
261     public
262     returns (bool success)
263   {
264     if(super.approve(_spender, _value)){
265       if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address)"))), msg.sender, _value, this))
266         revert();
267 
268       return true;
269     }
270   }
271 
272   // Transfers "value" tokens to "to" address
273   // Only executed adter "transferableBlock"
274   // Only executed before "endBlock" (see "Expiration" contract)
275   // Only executed if there are enough funds and don't overflow
276   function transfer(address to, uint value)
277     public
278     lockUpPeriod
279     validUntil
280     returns (bool success)
281   {
282     if(super.transfer(to, value))
283       return true;
284 
285     return false;
286   }
287 
288   // Transfers "value" tokens to "to" address from "from"
289   // Only executed adter "transferableBlock"
290   // Only executed before "endBlock" (see "Expiration" contract)
291   // Only executed if there are enough funds available and approved, and don't overflow
292   function transferFrom(address from, address to, uint value)
293     public
294     lockUpPeriod
295     validUntil
296     returns (bool success)
297   {
298     if(super.transferFrom(from, to, value))
299       return true;
300 
301     return false;
302   }
303 
304   function refundTokens(address _token, address _refund, uint _value) onlyOwner {
305 
306     Token(_token).transfer(_refund, _value);
307   }
308 
309 }