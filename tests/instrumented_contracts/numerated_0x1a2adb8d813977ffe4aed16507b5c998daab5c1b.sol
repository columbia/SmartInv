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
46 contract GRETToken is ERC20Interface {
47   using SafeMath for uint;
48 
49   // State variables
50   string public symbol = 'GRET';
51   string public name = 'GRET';
52   uint public decimals = 8;
53   address public owner;
54   uint public totalSupply = 75000000 * (10 ** 8);
55   bool public emergencyFreeze;
56   
57   // mappings
58   mapping (address => uint) balances;
59   mapping (address => mapping (address => uint) ) allowed;
60   mapping (address => bool) frozen;
61   
62 
63   // constructor
64   function GRETToken () public {
65     owner = msg.sender;
66     balances[owner] = totalSupply;
67   }
68 
69   // events
70   event OwnershipTransferred(address indexed _from, address indexed _to);
71   event Burn(address indexed from, uint256 amount);
72   event Mint(address indexed tagetAddress, uint256 amount);
73   event Freezed(address targetAddress, bool frozen);
74   event EmerygencyFreezed(bool emergencyFreezeStatus);
75   
76 
77 
78   // Modifiers
79   modifier onlyOwner {
80     require(msg.sender == owner);
81      _;
82   }
83 
84   modifier unfreezed(address _account) { 
85     require(!frozen[_account]);
86     _;  
87   }
88   
89   modifier noEmergencyFreeze() { 
90     require(!emergencyFreeze);
91     _; 
92   }
93   
94 
95 
96   // functions
97 
98   // ------------------------------------------------------------------------
99   // Transfer Token
100   // ------------------------------------------------------------------------
101   function transfer(address _to, uint _value) unfreezed(_to) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
102     require(_to != 0x0);
103     require(balances[msg.sender] >= _value);
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   // ------------------------------------------------------------------------
111   // Approve others to spend on your behalf
112   // ------------------------------------------------------------------------
113   /* 
114     While changing approval, the allowed must be changed to 0 than then to updated value
115     The smart contract doesn't enforces this due to backward competibility but requires frontend to do the validations
116    */
117   function approve(address _spender, uint _value) unfreezed(_spender) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
118     allowed[msg.sender][_spender] = _value;
119     emit Approval(msg.sender, _spender, _value);
120     return true;
121   }
122 
123   // ------------------------------------------------------------------------
124   // Approve and call : If approve returns true, it calls receiveApproval method of contract
125   // ------------------------------------------------------------------------
126   function approveAndCall(address _spender, uint256 _value, bytes _extraData) unfreezed(_spender) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success)
127     {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 
135   // ------------------------------------------------------------------------
136   // Transferred approved amount from other's account
137   // ------------------------------------------------------------------------
138   function transferFrom(address _from, address _to, uint _value) unfreezed(_to) unfreezed(_from) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
139     require(_value <= allowed[_from][msg.sender]);
140     require (balances[_from]>= _value);
141     balances[_from] = balances[_from].sub(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     emit Transfer(_from, _to, _value);
145     return true;
146   }
147 
148 
149   // ------------------------------------------------------------------------
150   // Burn (Destroy tokens)
151   // ------------------------------------------------------------------------
152   function burn(uint256 _value) public returns (bool success) {
153     require(balances[msg.sender] >= _value);
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     totalSupply = totalSupply.sub(_value);
156     emit Burn(msg.sender, _value);
157     return true;
158   }
159 
160   // ------------------------------------------------------------------------
161   //               ONLYOWNER METHODS                             
162   // ------------------------------------------------------------------------
163 
164 
165   // ------------------------------------------------------------------------
166   // Transfer Ownership
167   // ------------------------------------------------------------------------
168   function transferOwnership(address _newOwner) public onlyOwner {
169     require(_newOwner != address(0));
170     owner = _newOwner;
171     emit OwnershipTransferred(owner, _newOwner);
172   }
173 
174   // ------------------------------------------------------------------------
175   // Mint Token (Uncapped Minting)
176   // ------------------------------------------------------------------------
177   function mintToken (address _targetAddress, uint256 _mintedAmount) unfreezed(_targetAddress) noEmergencyFreeze() public onlyOwner returns(bool res) {
178     require(_targetAddress != 0x0); // use burn instead
179     require(_mintedAmount != 0);
180     balances[_targetAddress] = balances[_targetAddress].add(_mintedAmount);
181     totalSupply = totalSupply.add(_mintedAmount);
182     emit Mint(_targetAddress, _mintedAmount);
183     emit Transfer(address(0), _targetAddress, _mintedAmount);
184     return true;
185   }
186 
187   // ------------------------------------------------------------------------
188   // Freeze account - onlyOwner
189   // ------------------------------------------------------------------------
190   function freezeAccount (address _target, bool _freeze) public onlyOwner returns(bool res) {
191     require(_target != 0x0);
192     frozen[_target] = _freeze;
193     emit Freezed(_target, _freeze);
194     return true;
195   }
196 
197   // ------------------------------------------------------------------------
198   // Emerygency freeze - onlyOwner
199   // ------------------------------------------------------------------------
200   function emergencyFreezeAllAccounts (bool _freeze) public onlyOwner returns(bool res) {
201     emergencyFreeze = _freeze;
202     emit EmerygencyFreezed(_freeze);
203     return true;
204   }
205   
206 
207   // ------------------------------------------------------------------------
208   //               CONSTANT METHODS
209   // ------------------------------------------------------------------------
210 
211 
212   // ------------------------------------------------------------------------
213   // Check Allowance : Constant
214   // ------------------------------------------------------------------------
215   function allowance(address _tokenOwner, address _spender) public constant returns (uint remaining) {
216     return allowed[_tokenOwner][_spender];
217   }
218 
219   // ------------------------------------------------------------------------
220   // Check Balance : Constant
221   // ------------------------------------------------------------------------
222   function balanceOf(address _tokenOwner) public constant returns (uint balance) {
223     return balances[_tokenOwner];
224   }
225 
226   // ------------------------------------------------------------------------
227   // Total supply : Constant
228   // ------------------------------------------------------------------------
229   function totalSupply() public constant returns (uint) {
230     return totalSupply;
231   }
232 
233   // ------------------------------------------------------------------------
234   // Get Freeze Status : Constant
235   // ------------------------------------------------------------------------
236   function isFreezed(address _targetAddress) public constant returns (bool) {
237     return frozen[_targetAddress]; 
238   }
239 
240 
241 
242   // ------------------------------------------------------------------------
243   // Prevents contract from accepting ETH
244   // ------------------------------------------------------------------------
245   function () public payable {
246     revert();
247   }
248 
249   // ------------------------------------------------------------------------
250   // Owner can transfer out any accidentally sent ERC20 tokens
251   // ------------------------------------------------------------------------
252   function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) {
253       return ERC20Interface(_tokenAddress).transfer(owner, _value);
254   }
255 }