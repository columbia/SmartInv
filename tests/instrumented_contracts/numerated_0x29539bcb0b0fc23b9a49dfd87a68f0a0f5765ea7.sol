1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4     
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9 
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14 
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19 
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 contract IERC20Token {
27     function totalSupply() public constant returns (uint256 totalSupply);
28     function balanceOf(address _owner) public  constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) public returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
31     function approve(address _spender, uint256 _value) public returns (bool success);
32     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
33     // NOT IERC20 Token
34     function hasSDC(address _address,uint256 _quantity) public returns (bool success);
35     function hasSDCC(address _address,uint256 _quantity) public returns (bool success);
36     function eliminateSDCC(address _address,uint256 _quantity) public returns (bool success);
37     function createSDCC(address _address,uint256 _quantity) public returns (bool success); 
38     function createSDC(address _address,uint256 _init_quantity, uint256 _quantity) public returns (bool success);
39     function stakeSDC(address _address, uint256 amount)  public returns(bool);
40     function endStake(address _address, uint256 amount)  public returns(bool);
41 
42     function chipBalanceOf(address _address) public returns (uint256 _amount);
43     function transferChips(address _from, address _to, uint256 _value) public returns (bool success);
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // Owned contract
52 // ----------------------------------------------------------------------------
53 
54 contract Owned {
55     
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     function Owned() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73 
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 contract Lockable is Owned{
83 
84 	uint256 public lockedUntilBlock;
85 
86 	event ContractLocked(uint256 _untilBlock, string _reason);
87 
88 	modifier lockAffected {
89 		require(block.number > lockedUntilBlock);
90 		_;
91 	}
92 
93 	function lockFromSelf(uint256 _untilBlock, string _reason) internal {
94 		lockedUntilBlock = _untilBlock;
95 		ContractLocked(_untilBlock, _reason);
96 	}
97 
98 
99 	function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
100 		lockedUntilBlock = _untilBlock;
101 		ContractLocked(_untilBlock, _reason);
102 	}
103 }
104 
105 contract Token is IERC20Token, Lockable {
106 
107 	using SafeMath for uint256;
108 
109 	/* Public variables of the token */
110 	string public standard;
111 	string public name;
112 	string public symbol;
113 	uint8 public decimals;
114 	uint256 public supply;
115 
116 	address public crowdsaleContractAddress;
117 
118 	/* Private variables of the token */
119 	mapping (address => uint256) balances;
120 	mapping (address => mapping (address => uint256)) allowances;
121 
122 	/* Events */
123 	event Mint(address indexed _to, uint256 _value);
124 
125 	function Token(){
126 
127 	}
128 	/* Returns total supply of issued tokens */
129 	function totalSupply() constant returns (uint256) {
130 		return supply;
131 	}
132 
133 	/* Returns balance of address */
134 	function balanceOf(address _owner) constant returns (uint256 balance) {
135 		return balances[_owner];
136 	}
137 
138 	/* Transfers tokens from your address to other */
139 	function transfer(address _to, uint256 _value) lockAffected returns (bool success) {
140 		require(_to != 0x0 && _to != address(this));
141 		balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance
142 		balances[_to] = balances[_to].add(_value);               // Add recivers blaance
143 		Transfer(msg.sender, _to, _value);                       // Raise Transfer event
144 		return true;
145 	}
146 
147 	/* Approve other address to spend tokens on your account */
148 	function approve(address _spender, uint256 _value) lockAffected returns (bool success) {
149 		allowances[msg.sender][_spender] = _value;        // Set allowance
150 		Approval(msg.sender, _spender, _value);           // Raise Approval event
151 		return true;
152 	}
153 
154 	/* A contract attempts to get the coins */
155 	function transferFrom(address _from, address _to, uint256 _value)  returns (bool success) {
156 		require(_to != 0x0 && _to != address(this));
157 		balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
158 		balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
159 		allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address
160 		Transfer(_from, _to, _value);                                               // Raise Transfer event
161 		return true;
162 	}
163 
164 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
165 		return allowances[_owner][_spender];
166 	}
167 
168 	function mintTokens(address _to, uint256 _amount) {
169 		require(msg.sender == crowdsaleContractAddress);
170 		supply = supply.add(_amount);
171 		balances[_to] = balances[_to].add(_amount);
172 		Mint(_to, _amount);
173 		Transfer(0x0, _to, _amount);
174 	}
175 
176 	function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner {
177 		IERC20Token(_tokenAddress).transfer(_to, _amount);
178 	}
179 }
180 
181 
182 //----------------------------------------------------------------------
183 // Contract function to receive approval and execute function in one call
184 //
185 // Borrowed from MiniMeToken
186 // ----------------------------------------------------------------------------
187 
188 contract ApproveAndCallFallBack {
189     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
190 }
191 
192 // ----------------------------------------------------------------------------
193 // ERC20 Token, with the addition of symbol, name and decimals and an
194 // initial fixed supply
195 // ----------------------------------------------------------------------------
196 contract SoundcoinsToken is Token {
197 
198     address _teamAddress; // Account 3
199     address _saleAddress;
200 
201     uint256 availableSupply = 250000000;
202     uint256 minableSupply = 750000000;
203 
204     address public SoundcoinsAddress;
205     /* Balances for ships */
206     uint256 public total_SDCC_supply = 0;
207     mapping (address => uint256) balances_chips;
208     mapping (address => uint256) holdings_SDC;
209     uint256 holdingsSupply = 0;
210 
211 
212     modifier onlyAuthorized {
213         require(msg.sender == SoundcoinsAddress);
214         _;
215     }
216     /* Initializes contract */
217     function SoundcoinsToken(address _crowdsaleContract) public {
218         standard = "Soundcoins Token  V1.0";
219         name = "Soundcoins";
220         symbol = "SDC";
221         decimals = 0;
222         supply = 1000000000;
223         _teamAddress = msg.sender;
224         balances[msg.sender] = 100000000;
225         _saleAddress = _crowdsaleContract;
226         balances[_crowdsaleContract] = 150000000;
227     }
228 
229     /********* */
230     /* TOOLS  */
231     /********* */
232 
233 
234     function getAvailableSupply() public returns (uint256){
235         return availableSupply;
236     }
237 
238     function getMinableSupply() public returns (uint256){
239         return minableSupply;
240     }
241 
242     function getHoldingsSupply() public returns (uint256){
243         return holdingsSupply;
244     }
245 
246     function getSDCCSupply() public returns (uint256){
247         return total_SDCC_supply;
248     }
249 
250     function getSoundcoinsAddress() public returns (address){
251         return SoundcoinsAddress;
252     }
253     // See if Address has Enough SDC
254     function hasSDC(address _address,uint256 _quantity) public returns (bool success){
255         return (balances[_address] >= _quantity);
256     }
257 
258     // See if Address has Enough SDC
259     function hasSDCC(address _address, uint256 _quantity) public returns (bool success){
260         return (chipBalanceOf(_address) >= _quantity);
261     }
262    /*SDC*/
263 
264     function createSDC(address _address, uint256 _init_quantity, uint256 _quantity) onlyAuthorized public returns (bool success){
265         require(minableSupply >= 0);
266         balances[_address] = balances[_address].add(_quantity);
267         availableSupply = availableSupply.add(_quantity);
268         holdings_SDC[_address] = holdings_SDC[_address].sub(_init_quantity);
269         minableSupply = minableSupply.sub(_quantity.sub(_init_quantity));
270         holdingsSupply = holdingsSupply.sub(_init_quantity);
271         return true;
272     }
273 
274     function eliminateSDCC(address _address, uint256 _quantity) onlyAuthorized public returns (bool success){
275         balances_chips[_address] = balances_chips[_address].sub(_quantity);
276         total_SDCC_supply = total_SDCC_supply.sub(_quantity);
277         return true;
278     }
279 
280     function createSDCC(address _address, uint256 _quantity) onlyAuthorized public returns (bool success){
281         balances_chips[_address] = balances_chips[_address].add(_quantity);
282         total_SDCC_supply = total_SDCC_supply.add(_quantity);
283         return true;
284     }
285     
286     function chipBalanceOf(address _address) public returns (uint256 _amount) {
287         return balances_chips[_address];
288     }
289 
290     function transferChips(address _from, address _to, uint256 _value) onlyAuthorized public returns (bool success) {
291         require(_to != 0x0 && _to != address(msg.sender));
292         balances_chips[_from] = balances_chips[_from].sub(_value); // Deduct senders balance
293         balances_chips[_to] = balances_chips[_to].add(_value);               // Add recivers blaance
294         return true;
295     }
296 
297     function changeSoundcoinsContract(address _newAddress) public onlyOwner {
298         SoundcoinsAddress = _newAddress;
299     }
300 
301     function stakeSDC(address _address, uint256 amount) onlyAuthorized public returns(bool){
302         balances[_address] = balances[_address].sub(amount);
303         availableSupply = availableSupply.sub(amount);
304         holdings_SDC[_address] = holdings_SDC[_address].add(amount);
305         holdingsSupply = holdingsSupply.add(amount);
306         return true;
307     }
308 
309     function endStake(address _address, uint256 amount) onlyAuthorized public returns(bool){
310         balances[_address] = balances[_address].add(amount);
311         availableSupply = availableSupply.add(amount);
312         holdings_SDC[_address] = holdings_SDC[_address].sub(amount);
313         holdingsSupply = holdingsSupply.sub(amount);
314         return true;
315     }
316 }