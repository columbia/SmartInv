1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns(uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns(uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   constructor() public {
46     owner = msg.sender;
47   }
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 }
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73   bool public paused = false;
74   /**
75    * @dev modifier to allow actions only when the contract IS paused
76    */
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81   /**
82    * @dev modifier to allow actions only when the contract IS NOT paused
83    */
84   modifier whenPaused {
85     require(paused);
86     _;
87   }
88   /**
89    * @dev called by the owner to pause, triggers stopped state
90    */
91   function pause() public onlyOwner whenNotPaused returns(bool) {
92     paused = true;
93     emit Pause();
94     return true;
95   }
96   /**
97    * @dev called by the owner to unpause, returns to normal state
98    */
99   function unpause() public onlyOwner whenPaused returns(bool) {
100     paused = false;
101     emit Unpause();
102     return true;
103   }
104 }
105 
106 contract ERC20 {
107 
108   uint256 public totalSupply;
109 
110   function transfer(address _to, uint256 _value) public returns(bool success);
111 
112   function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
113 
114   function balanceOf(address _owner) constant public returns(uint256 balance);
115 
116   function approve(address _spender, uint256 _value) public returns(bool success);
117 
118   function allowance(address _owner, address _spender) constant public returns(uint256 remaining);
119 
120   event Transfer(address indexed _from, address indexed _to, uint256 _value);
121 
122   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 }
124 
125 contract BasicToken is ERC20, Pausable {
126   using SafeMath for uint256;
127 
128   event Frozen(address indexed _address, bool _value);
129 
130   mapping(address => uint256) balances;
131   mapping(address => bool) public frozens;
132   mapping(address => mapping(address => uint256)) allowed;
133 
134   function _transfer(address _from, address _to, uint256 _value) internal returns(bool success) {
135     require(_to != 0x0);
136     require(_value > 0);
137     require(frozens[_from] == false);
138     balances[_to] = balances[_to].add(_value);
139     balances[_from] = balances[_from].sub(_value);
140     emit Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   function transfer(address _to, uint256 _value) public whenNotPaused returns(bool success) {
145     require(balances[msg.sender] >= _value);
146     return _transfer(msg.sender, _to, _value);
147   }
148 
149   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool success) {
150     require(balances[_from] >= _value);
151     require(allowed[_from][msg.sender] >= _value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     return _transfer(_from, _to, _value);
154   }
155 
156   function balanceOf(address _owner) constant public returns(uint256 balance) {
157     return balances[_owner];
158   }
159 
160   function approve(address _spender, uint256 _value) public returns(bool success) {
161     allowed[msg.sender][_spender] = _value;
162     emit Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   function allowance(address _owner, address _spender) constant public returns(uint256 remaining) {
167     return allowed[_owner][_spender];
168   }
169 
170   function freeze(address[] _targets, bool _value) public onlyOwner returns(bool success) {
171     require(_targets.length > 0);
172     require(_targets.length <= 255);
173     for (uint8 i = 0; i < _targets.length; i++) {
174       assert(_targets[i] != 0x0);
175       frozens[_targets[i]] = _value;
176       emit Frozen(_targets[i], _value);
177     }
178     return true;
179   }
180 
181   function transferMulti(address[] _to, uint256[] _value) public whenNotPaused returns(bool success) {
182     require(_to.length > 0);
183     require(_to.length <= 255);
184     require(_to.length == _value.length);
185     require(frozens[msg.sender] == false);
186     uint8 i;
187     uint256 amount;
188     for (i = 0; i < _to.length; i++) {
189       assert(_to[i] != 0x0);
190       assert(_value[i] > 0);
191       amount = amount.add(_value[i]);
192     }
193     require(balances[msg.sender] >= amount);
194     balances[msg.sender] = balances[msg.sender].sub(amount);
195     for (i = 0; i < _to.length; i++) {
196       balances[_to[i]] = balances[_to[i]].add(_value[i]);
197       emit Transfer(msg.sender, _to[i], _value[i]);
198     }
199     return true;
200   }
201 }
202 
203 contract UCToken is BasicToken {
204 
205   string public constant name = "UnityChainToken";
206   string public constant symbol = "UCT";
207   uint256 public constant decimals = 18;
208 
209   constructor() public {
210     // 私募
211     _assign(0x490657f65380fe9e47ab46671B9CE7d02a06dF40, 1500);
212     // 团队
213     _assign(0xA0d5366E74E56Be39542BD6125897E30775C7bd8, 1500);
214     // 商城返利
215     _assign(0xDdb844341f70DC7FB45Ca27E26cB5a131823AE74, 1000);
216     // 推广分红
217     _assign(0xfdE4884AD60012b80c1E57cCf4526d38746899a0, 250);
218     // 持仓分红
219     _assign(0xf5Cfb87CAe4bC2D314D824De5B1B7a9F00Ef30Ee, 250);
220     // 交易分红
221     _assign(0xbbFc3e1Fc45fEDaA9FaB4fF1f74374ED4f217b4c, 250);
222     // 二次分红
223     _assign(0x2EAdc466b18bAb66369C52CF8F37DAf383F793a7, 250);
224   }
225 
226   function _assign(address _address, uint256 _value) private {
227     uint256 amount = _value * (10 ** 6) * (10 ** decimals);
228     balances[_address] = amount;
229     allowed[_address][owner] = amount;
230     totalSupply = totalSupply.add(amount);
231   }
232 }