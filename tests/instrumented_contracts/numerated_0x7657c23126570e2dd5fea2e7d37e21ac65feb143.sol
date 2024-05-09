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
24     assert(c >= a);
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
46 contract BRICBITToken is ERC20Interface {
47   using SafeMath for uint;
48 
49   // State variables
50   string public symbol = 'BRIC';
51   string public name = 'BRICBIT';
52   uint public decimals = 8;
53   address public owner;
54   uint public totalSupply = 10000000000 * (10 **8);
55   bool public emergencyFreeze;
56   
57   // mappings
58   mapping (address => uint) balances;
59   mapping (address => mapping (address => uint) ) allowed;
60   mapping (address => bool) frozen;
61   
62 
63   // constructor
64   function BRICBITToken () public {
65     owner = msg.sender;
66     balances[owner] = totalSupply;
67   }
68 
69   // events
70   event OwnershipTransferred(address indexed _from, address indexed _to);
71   event Burn(address indexed from, uint256 amount);
72   event Freezed(address targetAddress, bool frozen);
73   event EmerygencyFreezed(bool emergencyFreezeStatus);
74   
75 
76 
77   // Modifiers
78   modifier onlyOwner {
79     require(msg.sender == owner);
80      _;
81   }
82 
83   modifier unfreezed(address _account) { 
84     require(!frozen[_account]);
85     _;  
86   }
87   
88   modifier noEmergencyFreeze() { 
89     require(!emergencyFreeze);
90     _; 
91   }
92   
93 
94 
95   // functions
96 
97   // ------------------------------------------------------------------------
98   // Transfer Token
99   // ------------------------------------------------------------------------
100   function transfer(address _to, uint _value) unfreezed(_to) noEmergencyFreeze() public returns (bool success) {
101     require(_to != 0x0);
102     require(balances[msg.sender] >= _value);
103    /*  require(!frozenAccount[_from]); 
104     require(!frozenAccount[_to]);  
105     require(!emergencyFreeze);   */ 
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   // ------------------------------------------------------------------------
113   // Approve others to spend on your behalf
114   // ------------------------------------------------------------------------
115   function approve(address _spender, uint _value) unfreezed(_spender) unfreezed(msg.sender) noEmergencyFreeze() public returns (bool success) {
116     //require(balances[msg.sender] >= _value);
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   // ------------------------------------------------------------------------
123   // Approve and call : If approve returns true, it calls receiveApproval method of contract
124   // ------------------------------------------------------------------------
125   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)
126     {
127         tokenRecipient spender = tokenRecipient(_spender);
128         if (approve(_spender, _value)) {
129             spender.receiveApproval(msg.sender, _value, this, _extraData);
130             return true;
131         }
132     }
133 
134   // ------------------------------------------------------------------------
135   // Transferred approved amount from other's account
136   // ------------------------------------------------------------------------
137   function transferFrom(address _from, address _to, uint _value) unfreezed(_to) unfreezed(_from) noEmergencyFreeze() public returns (bool success) {
138     require(_value <= allowed[_from][msg.sender]);
139     balances[_from] = balances[_from].sub(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     Transfer(_from, _to, _value);
143     return true;
144   }
145 
146 
147   // ------------------------------------------------------------------------
148   // Burn (Destroy tokens)
149   // ------------------------------------------------------------------------
150   function burn(uint256 _value) public returns (bool success) {
151     require(balances[msg.sender] >= _value);
152     balances[msg.sender] -= _value;
153     totalSupply -= _value;
154     Burn(msg.sender, _value);
155     return true;
156   }
157 
158   // ------------------------------------------------------------------------
159   //               ONLYOWNER METHODS                             
160   // ------------------------------------------------------------------------
161 
162 
163   // ------------------------------------------------------------------------
164   // Transfer Ownership
165   // ------------------------------------------------------------------------
166   function transferOwnership(address _newOwner) public onlyOwner {
167     require(_newOwner != address(0));
168     owner = _newOwner;
169     OwnershipTransferred(owner, _newOwner);
170   }
171 
172   // ------------------------------------------------------------------------
173   // Freeze account - onlyOwner
174   // ------------------------------------------------------------------------
175   function freezeAccount (address _target, bool _freeze) public onlyOwner returns(bool res) {
176     require(_target != 0x0);
177     frozen[_target] = _freeze;
178     Freezed(_target, _freeze);
179     return true;
180   }
181 
182   // ------------------------------------------------------------------------
183   // Emerygency freeze - onlyOwner
184   // ------------------------------------------------------------------------
185   function emergencyFreezeAllAccounts (bool _freeze) public onlyOwner returns(bool res) {
186     emergencyFreeze = _freeze;
187     EmerygencyFreezed(_freeze);
188     return true;
189   }
190   
191 
192   // ------------------------------------------------------------------------
193   //               CONSTANT METHODS
194   // ------------------------------------------------------------------------
195 
196 
197   // ------------------------------------------------------------------------
198   // Check Allowance : Constant
199   // ------------------------------------------------------------------------
200   function allowance(address _tokenOwner, address _spender) public constant returns (uint remaining) {
201     return allowed[_tokenOwner][_spender];
202   }
203 
204   // ------------------------------------------------------------------------
205   // Check Balance : Constant
206   // ------------------------------------------------------------------------
207   function balanceOf(address _tokenOwner) public constant returns (uint balance) {
208     return balances[_tokenOwner];
209   }
210 
211   // ------------------------------------------------------------------------
212   // Total supply : Constant
213   // ------------------------------------------------------------------------
214   function totalSupply() public constant returns (uint) {
215     return totalSupply;
216   }
217 
218   // ------------------------------------------------------------------------
219   // Get Freeze Status : Constant
220   // ------------------------------------------------------------------------
221   function isFreezed(address _targetAddress) public constant returns (bool) {
222     return frozen[_targetAddress]; 
223   }
224 
225 
226 
227   // ------------------------------------------------------------------------
228   // Prevents contract from accepting ETH
229   // ------------------------------------------------------------------------
230   function () public payable {
231     revert();
232   }
233 
234   // ------------------------------------------------------------------------
235   // Owner can transfer out any accidentally sent ERC20 tokens
236   // ------------------------------------------------------------------------
237   function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) {
238       return ERC20Interface(_tokenAddress).transfer(owner, _value);
239   }
240 }