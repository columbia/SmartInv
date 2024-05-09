1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-18
3 */
4 pragma solidity ^0.4.24;
5 
6 contract Manager {
7   address public owner;
8   address public newOwner;
9   event TransferOwnership(address oldaddr, address newaddr);
10 
11   modifier onlyOwner() {
12     require (msg.sender == owner);
13 	// GS: Added yield below
14     _;
15   }
16 
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   function transferOwnership(address _newOwner) onlyOwner public {
22     newOwner = _newOwner;
23   }
24 
25   function acceptOwnership() public {
26     require(msg.sender == newOwner);
27     address oldaddr = owner;
28     owner = newOwner;
29     newOwner = address(0);
30     emit TransferOwnership(oldaddr, owner);
31   }
32 
33 }
34 
35 library SafeMath {
36   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     if (_a == 0) {
38       return 0;
39 	}
40     uint256 c = _a * _b;
41     require(c / _a == _b);
42     return c;
43   }
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     require(_b > 0);
46     uint256 c = _a / _b;
47     return c;
48   }
49   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     require(_b <= _a);
51     uint256 c = _a - _b;
52     return c;
53   }
54   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     uint256 c = _a + _b;
56     require(c >= _a);
57     return c;
58   }
59   function mod(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     require(_b != 0);
61     return _a % _b;
62   }
63 }
64 
65 // ----------------------------------------------------------------------------
66 // ERC Token Standard #20 Interface
67 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
68 // ----------------------------------------------------------------------------
69 contract ERC20Interface {
70   function totalSupply() public view returns (uint256);
71   function balanceOf(address _owner) public view returns (uint256 balance);
72   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
73   function transfer(address _to, uint256 _value) public returns (bool success);
74   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
75   function approve(address _spender, uint256 _value) public returns (bool success);
76   event Transfer(address indexed from, address indexed to, uint tokens);
77   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
78 }
79 
80 contract ReentrancyGuard {
81   uint256 private guardCounter = 1;
82   modifier noReentrant() {
83     guardCounter += 1;
84     uint256 localCounter = guardCounter;
85     _;
86     require(localCounter == guardCounter);
87   }
88 }
89 
90 interface tokenRecipient {
91   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
92 }
93 
94 contract ERC20Base is ERC20Interface, ReentrancyGuard {
95   using SafeMath for uint256;
96   string public name;
97   string public symbol;
98   uint8 public decimals = 18;
99   uint256 public totalSupply;
100   mapping(address => uint256) public balanceOf;
101   mapping(address => mapping(address => uint256)) public allowance;
102 
103   constructor() public {}
104 
105   function() public payable {
106     revert();
107   }
108 
109   function totalSupply() public view returns (uint256) {
110     return totalSupply;
111   }
112 
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balanceOf[_owner];
115   }
116 
117   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
118     return allowance[_owner][_spender];
119   }
120 
121   function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
122     require(_to != 0x0);
123     require(balanceOf[_from] >= _value);
124     if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
125       revert();
126     }
127     uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
128     balanceOf[_from] = balanceOf[_from].sub(_value);
129     balanceOf[_to] = balanceOf[_to].add(_value);
130     emit Transfer(_from, _to, _value);
131     assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
132     return true;
133   }
134 
135   function transfer(address _to, uint256 _value) public returns (bool success) {
136     return _transfer(msg.sender, _to, _value);
137   }
138 
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
140     require(_value <= allowance[_from][msg.sender]);
141     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
142     return _transfer(_from, _to, _value);
143   }
144 
145   function approve(address _spender, uint256 _value) public returns (bool success) {
146     allowance[msg.sender][_spender] = _value;
147     emit Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
152     allowance[msg.sender][_spender] = (
153     allowance[msg.sender][_spender].add(_addedValue));
154     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
155     return true;
156   }
157 
158   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
159     uint256 oldValue = allowance[msg.sender][_spender];
160     if (_subtractedValue >= oldValue) {
161       allowance[msg.sender][_spender] = 0;
162     } else {
163       allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164     }
165     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
166     return true;
167   }
168 
169   function approveAndCall(address _spender, uint256 _value, bytes _extraData) noReentrant public returns (bool success) {
170     tokenRecipient spender = tokenRecipient(_spender);
171     if (approve(_spender, _value)) {
172       spender.receiveApproval(msg.sender, _value, this, _extraData);
173       return true;
174 	}
175   }
176 }
177 
178 contract ManualToken is Manager, ERC20Base {
179   bool public isTokenLocked;
180   bool public isUseFreeze;
181   struct Frozen {
182     uint256 amount;
183   }
184 
185   mapping(address => Frozen) public frozenAccount;
186   event FrozenFunds(address indexed target, uint256 freezeAmount);
187 
188   constructor()
189   ERC20Base()
190   public
191   {
192     name = "FAB Token";
193     symbol = "FAB";
194     totalSupply = 55000000000 * 1 ether;
195     isUseFreeze = true;
196     isTokenLocked = false;
197     balanceOf[msg.sender] = totalSupply;
198     emit Transfer(address(0), msg.sender, totalSupply);
199   }
200 
201   modifier tokenLock() {
202     require(isTokenLocked == false);
203     _;
204   }
205 
206   function setLockToken(bool _lock) onlyOwner public {
207     isTokenLocked = _lock;
208   }
209 
210   function setUseFreeze(bool _useOrNot) onlyOwner public {
211     isUseFreeze = _useOrNot;
212   }
213 
214   function freezeAmount(address target, uint256 amountFreeze) onlyOwner public {
215     frozenAccount[target].amount = amountFreeze;
216     emit FrozenFunds(target, amountFreeze);
217   }
218 
219   function isFrozen(address target) public view returns (uint256) {
220     return frozenAccount[target].amount;
221   }
222 
223   function _transfer(address _from, address _to, uint256 _value) tokenLock internal returns (bool success) {
224     require(_to != 0x0);
225     require(balanceOf[_from] >= _value);
226     if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
227       revert();
228     }
229     if (isUseFreeze == true) {
230       require(balanceOf[_from].sub(_value) >= frozenAccount[_from].amount);
231     }
232     balanceOf[_from] = balanceOf[_from].sub(_value);
233     balanceOf[_to] = balanceOf[_to].add(_value);
234     emit Transfer(_from, _to, _value);
235     return true;
236   }
237 }