1 contract SafeMath {
2     
3     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
4 
5     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
6         require(x <= MAX_UINT256 - y);
7         return x + y;
8     }
9 
10     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
11         require(x >= y);
12         return x - y;
13     }
14 
15     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
16         if (y == 0) {
17             return 0;
18         }
19         require(x <= (MAX_UINT256 / y));
20         return x * y;
21     }
22 }
23 
24 contract ReentrancyHandlingContract{
25 
26     bool locked;
27 
28     modifier noReentrancy() {
29         require(!locked);
30         locked = true;
31         _;
32         locked = false;
33     }
34 }
35 
36 contract Owned {
37     address public owner;
38     address public newOwner;
39 
40     function Owned() {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         assert(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     function acceptOwnership() public {
55         require(msg.sender == newOwner);
56         OwnerUpdate(owner, newOwner);
57         owner = newOwner;
58         newOwner = 0x0;
59     }
60 
61     event OwnerUpdate(address _prevOwner, address _newOwner);
62 }
63 
64 contract Lockable is Owned {
65 
66     uint256 public lockedUntilBlock;
67 
68     event ContractLocked(uint256 _untilBlock, string _reason);
69 
70     modifier lockAffected {
71         require(block.number > lockedUntilBlock);
72         _;
73     }
74 
75     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
76         lockedUntilBlock = _untilBlock;
77         ContractLocked(_untilBlock, _reason);
78     }
79 
80 
81     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
82         lockedUntilBlock = _untilBlock;
83         ContractLocked(_untilBlock, _reason);
84     }
85 }
86 
87 contract ERC20TokenInterface {
88   function totalSupply() public constant returns (uint256 _totalSupply);
89   function balanceOf(address _owner) public constant returns (uint256 balance);
90   function transfer(address _to, uint256 _value) public returns (bool success);
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
92   function approve(address _spender, uint256 _value) public returns (bool success);
93   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
94 
95   event Transfer(address indexed _from, address indexed _to, uint256 _value);
96   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 
99 contract InsurePalTokenInterface {
100     function mint(address _to, uint256 _amount) public;
101 }
102 
103 contract tokenRecipientInterface {
104   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
105 }
106 
107 contract KycContractInterface {
108     function isAddressVerified(address _address) public view returns (bool);
109 }
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 contract KycContract is Owned {
120     
121     mapping (address => bool) verifiedAddresses;
122     
123     function isAddressVerified(address _address) public view returns (bool) {
124         return verifiedAddresses[_address];
125     }
126     
127     function addAddress(address _newAddress) public onlyOwner {
128         require(!verifiedAddresses[_newAddress]);
129         
130         verifiedAddresses[_newAddress] = true;
131     }
132     
133     function removeAddress(address _oldAddress) public onlyOwner {
134         require(verifiedAddresses[_oldAddress]);
135         
136         verifiedAddresses[_oldAddress] = false;
137     }
138     
139     function batchAddAddresses(address[] _addresses) public onlyOwner {
140         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
141             assert(!verifiedAddresses[_addresses[cnt]]);
142             verifiedAddresses[_addresses[cnt]] = true;
143         }
144     }
145     
146     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner{
147         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
148     }
149     
150     function killContract() public onlyOwner {
151         selfdestruct(owner);
152     }
153 }
154 
155 
156 
157 
158 
159 
160 
161 
162 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
163 
164     /* Public variables of the token */
165     string public standard;
166     string public name;
167     string public symbol;
168     uint8 public decimals;
169 
170     address public crowdsaleContractAddress;
171 
172     /* Private variables of the token */
173     uint256 supply = 0;
174     mapping (address => uint256) balances;
175     mapping (address => mapping (address => uint256)) allowances;
176 
177     event Mint(address indexed _to, uint256 _value);
178     event Burn(address indexed _from, uint _value);
179 
180     /* Returns total supply of issued tokens */
181     function totalSupply() constant public returns (uint256) {
182         return supply;
183     }
184 
185     /* Returns balance of address */
186     function balanceOf(address _owner) constant public returns (uint256 balance) {
187         return balances[_owner];
188     }
189 
190     /* Transfers tokens from your address to other */
191     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
192         require(_to != 0x0 && _to != address(this));
193         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);  // Deduct senders balance
194         balances[_to] = safeAdd(balanceOf(_to), _value);                // Add recivers blaance
195         Transfer(msg.sender, _to, _value);                              // Raise Transfer event
196         return true;
197     }
198 
199     /* Approve other address to spend tokens on your account */
200     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
201         allowances[msg.sender][_spender] = _value;        // Set allowance
202         Approval(msg.sender, _spender, _value);           // Raise Approval event
203         return true;
204     }
205 
206     /* Approve and then communicate the approved contract in a single tx */
207     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
208         tokenRecipientInterface spender = tokenRecipientInterface(_spender);    // Cast spender to tokenRecipient contract
209         approve(_spender, _value);                                              // Set approval to contract for _value
210         spender.receiveApproval(msg.sender, _value, this, _extraData);          // Raise method on _spender contract
211         return true;
212     }
213 
214     /* A contract attempts to get the coins */
215     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
216         require(_to != 0x0 && _to != address(this));
217         balances[_from] = safeSub(balanceOf(_from), _value);                            // Deduct senders balance
218         balances[_to] = safeAdd(balanceOf(_to), _value);                                // Add recipient blaance
219         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value); // Deduct allowance for this address
220         Transfer(_from, _to, _value);                                                   // Raise Transfer event
221         return true;
222     }
223 
224     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
225         return allowances[_owner][_spender];
226     }
227 
228     function mint(address _to, uint256 _amount) public {
229         require(msg.sender == crowdsaleContractAddress);
230         supply = safeAdd(supply, _amount);
231         balances[_to] = safeAdd(balances[_to], _amount);
232         Mint(_to, _amount);
233         Transfer(0x0, _to, _amount);
234     }
235 
236     function burn(uint _amount) public {
237         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
238         supply = safeSub(supply, _amount);
239         Burn(msg.sender, _amount);
240         Transfer(msg.sender, 0x0, _amount);
241     }
242 
243     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
244         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
245     }
246 
247     function killContract() public onlyOwner {
248         selfdestruct(owner);
249     }
250 }
251 
252 
253 contract InsurePalToken is ERC20Token {
254 
255   /* Initializes contract */
256   function InsurePalToken() {
257     standard = "InsurePal token v1.0";
258     name = "InsurePal token";
259     symbol = "IPL";
260     decimals = 18;
261     crowdsaleContractAddress = 0x0c411ffFc6d3a8E4ca5f81bBC98b5B3EdA8FC3C7;   
262     lockFromSelf(5031534, "Lock before crowdsale starts");
263   }
264 }