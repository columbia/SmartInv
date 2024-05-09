1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a && c>=b);
25     return c;
26   }
27 }
28 
29 
30 // source : https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
31 contract ERC20Interface {
32     function totalSupply() public constant returns (uint);
33     function balanceOf(address tokenOwner) public constant returns (uint balance);
34     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
44 
45 
46 contract DCoin is ERC20Interface {
47   using SafeMath for uint;
48 
49   // State variables
50   string public name = "D'Coin";
51   string public symbol = 'DCO';
52   uint public decimals = 6;
53   address public owner;
54   uint public maxCoinCap = 200000000 * (10 ** 6);
55   uint public totalSupply;
56   bool public emergencyFreeze;
57   
58   // mappings
59   mapping (address => uint) balances;
60   mapping (address => mapping (address => uint) ) allowed;
61   mapping (address => bool) frozen;
62 
63   // events
64   event Mint(address indexed _to, uint indexed _mintedAmount);
65   
66 
67   // constructor
68   function DCoin () public {
69     owner = msg.sender;
70   }
71 
72   // events
73   event OwnershipTransferred(address indexed _from, address indexed _to);
74   event Burn(address indexed from, uint256 amount);
75   event Freezed(address targetAddress, bool frozen);
76   event EmerygencyFreezed(bool emergencyFreezeStatus);
77   
78 
79 
80   // Modifiers
81   modifier onlyOwner {
82     require(msg.sender == owner);
83      _;
84   }
85 
86   modifier unfreezed(address _account) { 
87     require(!frozen[_account]);
88     _;  
89   }
90   
91   modifier noEmergencyFreeze() { 
92     require(!emergencyFreeze);
93     _; 
94   }
95   
96 
97 
98   // functions
99 
100   // ------------------------------------------------------------------------
101   // Transfer Token
102   // ------------------------------------------------------------------------
103   function transfer(address _to, uint _value) unfreezed(_to) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
104     require(_to != 0x0);
105     require(balances[msg.sender] >= _value); 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   // ------------------------------------------------------------------------
113   // Mint Token (Uncapped Minting)
114   // ------------------------------------------------------------------------
115   function mintToken (address _targetAddress, uint256 _mintedAmount) unfreezed(_targetAddress) noEmergencyFreeze() public onlyOwner returns(bool res) {
116     require(_targetAddress != 0x0); // use burn instead
117     require(_mintedAmount != 0);
118     require (totalSupply.add(_mintedAmount) <= maxCoinCap);
119     balances[_targetAddress] = balances[_targetAddress].add(_mintedAmount);
120     totalSupply = totalSupply.add(_mintedAmount);
121     emit Mint(_targetAddress, _mintedAmount);
122     emit Transfer(address(0), _targetAddress, _mintedAmount);
123     return true;
124   }
125 
126   // ------------------------------------------------------------------------
127   // Approve others to spend on your behalf
128   // ------------------------------------------------------------------------
129   /* 
130     While changing approval, the allowed must be changed to 0 than then to updated value
131     The smart contract doesn't enforces this due to backward competibility but requires frontend to do the validations
132    */
133   function approve(address _spender, uint _value) unfreezed(_spender) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
134     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
135     allowed[msg.sender][_spender] = _value;
136     emit Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   // ------------------------------------------------------------------------
141   // Approve and call : If approve returns true, it calls receiveApproval method of contract
142   // ------------------------------------------------------------------------
143   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
144     {
145         tokenRecipient spender = tokenRecipient(_spender);
146         if (approve(_spender, _value)) {
147             spender.receiveApproval(msg.sender, _value, this, _extraData);
148             return true;
149         }
150     }
151 
152   // ------------------------------------------------------------------------
153   // Transferred approved amount from other's account
154   // ------------------------------------------------------------------------
155   function transferFrom(address _from, address _to, uint _value) unfreezed(_to) unfreezed(_from) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
156     require(_value <= allowed[_from][msg.sender]);
157     require (_value <= balances[_from]);
158     balances[_from] = balances[_from].sub(_value);
159     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165 
166   // ------------------------------------------------------------------------
167   // Burn (Destroy tokens)
168   // ------------------------------------------------------------------------
169   function burn(uint256 _value) unfreezed(msg.sender) public returns (bool success) {
170     require(balances[msg.sender] >= _value);
171     balances[msg.sender] -= _value;
172     totalSupply -= _value;
173     emit Burn(msg.sender, _value);
174     return true;
175   }
176 
177   // ------------------------------------------------------------------------
178   //               ONLYOWNER METHODS                             
179   // ------------------------------------------------------------------------
180 
181 
182   // ------------------------------------------------------------------------
183   // Transfer Ownership
184   // ------------------------------------------------------------------------
185   function transferOwnership(address _newOwner) public onlyOwner {
186     require(_newOwner != address(0));
187     owner = _newOwner;
188     emit OwnershipTransferred(owner, _newOwner);
189   }
190 
191   // ------------------------------------------------------------------------
192   // Freeze account - onlyOwner
193   // ------------------------------------------------------------------------
194   function freezeAccount (address _target, bool _freeze) public onlyOwner returns(bool res) {
195     require(_target != 0x0);
196     frozen[_target] = _freeze;
197     emit Freezed(_target, _freeze);
198     return true;
199   }
200 
201   // ------------------------------------------------------------------------
202   // Emerygency freeze - onlyOwner
203   // ------------------------------------------------------------------------
204   function emergencyFreezeAllAccounts (bool _freeze) public onlyOwner returns(bool res) {
205     emergencyFreeze = _freeze;
206     emit EmerygencyFreezed(_freeze);
207     return true;
208   }
209   
210 
211   // ------------------------------------------------------------------------
212   //               CONSTANT METHODS
213   // ------------------------------------------------------------------------
214 
215 
216   // ------------------------------------------------------------------------
217   // Check Allowance : Constant
218   // ------------------------------------------------------------------------
219   function allowance(address _tokenOwner, address _spender) public constant returns (uint remaining) {
220     return allowed[_tokenOwner][_spender];
221   }
222 
223   // ------------------------------------------------------------------------
224   // Check Balance : Constant
225   // ------------------------------------------------------------------------
226   function balanceOf(address _tokenOwner) public constant returns (uint balance) {
227     return balances[_tokenOwner];
228   }
229 
230   // ------------------------------------------------------------------------
231   // Total supply : Constant
232   // ------------------------------------------------------------------------
233   function totalSupply() public constant returns (uint) {
234     return totalSupply;
235   }
236 
237   // ------------------------------------------------------------------------
238   // Get Freeze Status : Constant
239   // ------------------------------------------------------------------------
240   function isFreezed(address _targetAddress) public constant returns (bool) {
241     return frozen[_targetAddress]; 
242   }
243 
244 
245 
246   // ------------------------------------------------------------------------
247   // Prevents contract from accepting ETH
248   // ------------------------------------------------------------------------
249   function () public payable {
250     revert();
251   }
252 
253   // ------------------------------------------------------------------------
254   // Owner can transfer out any accidentally sent ERC20 tokens
255   // ------------------------------------------------------------------------
256   function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) {
257       return ERC20Interface(_tokenAddress).transfer(owner, _value);
258   }
259 }