1 pragma solidity ^0.4.23;
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
46 contract WeisToken is ERC20Interface {
47   using SafeMath for uint;
48 
49   // State variables
50   string public name = 'WEIS';
51   string public symbol = 'WEIS';
52   uint public decimals = 8;
53   address public owner;
54   uint public totalSupply = 300000000 * (10 ** 8);
55   bool public emergencyFreeze;
56   
57   // mappings
58   mapping (address => uint) balances;
59   mapping (address => mapping (address => uint) ) allowed;
60   mapping (address => bool) frozen;
61   
62 
63   // constructor
64   constructor () public {
65     owner = msg.sender;
66     balances[owner] = totalSupply;
67     emit Transfer(0x0, owner, totalSupply);
68   }
69 
70   // events
71   event OwnershipTransferred(address indexed _from, address indexed _to);
72   event Burn(address indexed from, uint256 amount);
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
115     The smart contract enforces this for security reasons
116    */
117   function approve(address _spender, uint _value) unfreezed(_spender) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
118     // To change the approve amount you first have to reduce the addresses`
119     //  allowance to zero by calling `approve(_spender, 0)` if it is not
120     //  already 0 to mitigate the race condition 
121     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
122     allowed[msg.sender][_spender] = _value;
123     emit Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   // ------------------------------------------------------------------------
128   // Approve and call : If approve returns true, it calls receiveApproval method of contract
129   // ------------------------------------------------------------------------
130   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
131     {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139   // ------------------------------------------------------------------------
140   // Transferred approved amount from other's account
141   // ------------------------------------------------------------------------
142   function transferFrom(address _from, address _to, uint _value) unfreezed(_to) unfreezed(_from) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
143     require(_value <= allowed[_from][msg.sender]);
144     require (_value <= balances[_from]);
145     balances[_from] = balances[_from].sub(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(_from, _to, _value);
149     return true;
150   }
151 
152 
153   // ------------------------------------------------------------------------
154   // Burn (Destroy tokens)
155   // ------------------------------------------------------------------------
156   function burn(uint256 _value) unfreezed(msg.sender) public returns (bool success) {
157     require(balances[msg.sender] >= _value);
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     totalSupply = totalSupply.sub(_value);
160     emit Burn(msg.sender, _value);
161     return true;
162   }
163 
164   // ------------------------------------------------------------------------
165   //               ONLYOWNER METHODS                             
166   // ------------------------------------------------------------------------
167 
168 
169   // ------------------------------------------------------------------------
170   // Transfer Ownership
171   // ------------------------------------------------------------------------
172   function transferOwnership(address _newOwner) public onlyOwner {
173     require(_newOwner != address(0));
174     owner = _newOwner;
175     emit OwnershipTransferred(owner, _newOwner);
176   }
177 
178   // ------------------------------------------------------------------------
179   // Freeze account - onlyOwner
180   // ------------------------------------------------------------------------
181   function freezeAccount (address _target, bool _freeze) public onlyOwner returns(bool res) {
182     require(_target != 0x0);
183     frozen[_target] = _freeze;
184     emit Freezed(_target, _freeze);
185     return true;
186   }
187 
188   // ------------------------------------------------------------------------
189   // Emerygency freeze - onlyOwner
190   // ------------------------------------------------------------------------
191   function emergencyFreezeAllAccounts (bool _freeze) public onlyOwner returns(bool res) {
192     emergencyFreeze = _freeze;
193     emit EmerygencyFreezed(_freeze);
194     return true;
195   }
196   
197 
198   // ------------------------------------------------------------------------
199   //               CONSTANT METHODS
200   // ------------------------------------------------------------------------
201 
202 
203   // ------------------------------------------------------------------------
204   // Check Allowance : Constant
205   // ------------------------------------------------------------------------
206   function allowance(address _tokenOwner, address _spender) public constant returns (uint remaining) {
207     return allowed[_tokenOwner][_spender];
208   }
209 
210   // ------------------------------------------------------------------------
211   // Check Balance : Constant
212   // ------------------------------------------------------------------------
213   function balanceOf(address _tokenOwner) public constant returns (uint balance) {
214     return balances[_tokenOwner];
215   }
216 
217   // ------------------------------------------------------------------------
218   // Total supply : Constant
219   // ------------------------------------------------------------------------
220   function totalSupply() public constant returns (uint) {
221     return totalSupply;
222   }
223 
224   // ------------------------------------------------------------------------
225   // Get Freeze Status : Constant
226   // ------------------------------------------------------------------------
227   function isFreezed(address _targetAddress) public constant returns (bool) {
228     return frozen[_targetAddress]; 
229   }
230 
231 
232 
233   // ------------------------------------------------------------------------
234   // Prevents contract from accepting ETH
235   // ------------------------------------------------------------------------
236   function () public payable {
237     revert();
238   }
239 
240   // ------------------------------------------------------------------------
241   // Owner can transfer out any accidentally sent ERC20 tokens
242   // ------------------------------------------------------------------------
243   function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) {
244       return ERC20Interface(_tokenAddress).transfer(owner, _value);
245   }
246 }