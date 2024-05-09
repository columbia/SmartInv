1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 interface TokenUpgraderInterface{
28     function upgradeFor(address _for, uint256 _value) public returns (bool success);
29     function upgradeFrom(address _by, address _for, uint256 _value) public returns (bool success);
30 }
31   
32 contract ManagedToken {
33     using SafeMath for uint256;
34 
35     address public owner = msg.sender;
36     address public crowdsaleContractAddress;
37     address public crowdsaleManager;
38 
39     string public name;
40     string public symbol;
41 
42     bool public upgradable = false;
43     bool public upgraderSet = false;
44     TokenUpgraderInterface public upgrader;
45 
46     bool public locked = true;
47     bool public mintingAllowed = true;
48     uint8 public decimals = 18;
49 
50     modifier unlocked() {
51         require(!locked);
52         _;
53     }
54 
55     modifier unlockedOrByManager() {
56         require(!locked || (crowdsaleManager != address(0) && msg.sender == crowdsaleManager) || (msg.sender == owner));
57         _;
58     }
59     // Ownership
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     modifier onlyCrowdsale() {
69         require(msg.sender == crowdsaleContractAddress);
70         _;
71     }
72 
73     modifier ownerOrCrowdsale() {
74         require(msg.sender == owner || msg.sender == crowdsaleContractAddress);
75         _;
76     }
77 
78     function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
79         require(newOwner != address(0));      
80         OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         return true;
83     }
84 
85 
86     // ERC20 related functions
87 
88     uint256 public totalSupply = 0;
89 
90     mapping(address => uint256) balances;
91     mapping (address => mapping (address => uint256)) allowed;
92 
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97     function transfer(address _to, uint256 _value) unlockedOrByManager public returns (bool) {
98         require(_to != address(0));
99         balances[msg.sender] = balances[msg.sender].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         Transfer(msg.sender, _to, _value);
102         return true;
103     }
104 
105     function balanceOf(address _owner) view public returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) unlocked public returns (bool) {
110         require(_to != address(0));
111         var _allowance = allowed[_from][msg.sender];
112         balances[_from] = balances[_from].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         allowed[_from][msg.sender] = _allowance.sub(_value);
115         Transfer(_from, _to, _value);
116         return true;
117     }
118 
119     function approve(address _spender, uint256 _value) unlocked public returns (bool) {
120         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
127         return allowed[_owner][_spender];
128     }
129 
130     function increaseApproval (address _spender, uint _addedValue) unlocked public
131         returns (bool success) {
132             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
133             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
134             return true;
135     }
136 
137     function decreaseApproval (address _spender, uint _subtractedValue) unlocked public
138         returns (bool success) {
139             uint oldValue = allowed[msg.sender][_spender];
140             if (_subtractedValue > oldValue) {
141             allowed[msg.sender][_spender] = 0;
142             } else {
143             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144             }
145             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146             return true;
147     }
148 
149     function ManagedToken (string _name, string _symbol, uint8 _decimals) public {
150         require(bytes(_name).length > 1);
151         require(bytes(_symbol).length > 1);
152         name = _name;
153         symbol = _symbol;
154         decimals = _decimals;
155     }
156 
157     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
158         require(bytes(_name).length > 1);
159         require(bytes(_symbol).length > 1);
160         name = _name;
161         symbol = _symbol;
162         return true;
163     }
164 
165     function setLock(bool _newLockState) ownerOrCrowdsale public returns (bool success) {
166         require(_newLockState != locked);
167         locked = _newLockState;
168         return true;
169     }
170 
171     function disableMinting() ownerOrCrowdsale public returns (bool success) {
172         require(mintingAllowed);
173         mintingAllowed = false;
174         return true;
175     }
176 
177     function setCrowdsale(address _newCrowdsale) onlyOwner public returns (bool success) {
178         crowdsaleContractAddress = _newCrowdsale;
179         return true;
180     }
181 
182     function setManager(address _newManager) onlyOwner public returns (bool success) {
183         crowdsaleManager = _newManager;
184         return true;
185     }
186 
187     function mint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
188         require(mintingAllowed);
189         balances[_for] = balances[_for].add(_amount);
190         totalSupply = totalSupply.add(_amount);
191         Transfer(0, _for, _amount);
192         return true;
193     }
194 
195     function demint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
196         require(mintingAllowed);
197         balances[_for] = balances[_for].sub(_amount);
198         totalSupply = totalSupply.sub(_amount);
199         Transfer(_for, 0, _amount);
200         return true;
201     }
202 
203     function allowUpgrading(bool _newState) onlyOwner public returns (bool success) {
204         upgradable = _newState;
205         return true;
206     }
207 
208     function setUpgrader(address _upgraderAddress) onlyOwner public returns (bool success) {
209         require(!upgraderSet);
210         require(_upgraderAddress != address(0));
211         upgraderSet = true;
212         upgrader = TokenUpgraderInterface(_upgraderAddress);
213         return true;
214     }
215 
216     function upgrade() public returns (bool success) {
217         require(upgradable);
218         require(upgraderSet);
219         require(upgrader != TokenUpgraderInterface(0));
220         uint256 value = balances[msg.sender];
221         assert(value > 0);
222         delete balances[msg.sender];
223         totalSupply = totalSupply.sub(value);
224         assert(upgrader.upgradeFor(msg.sender, value));
225         return true;
226     }
227 
228     function upgradeFor(address _for, uint256 _value) public returns (bool success) {
229         require(upgradable);
230         require(upgraderSet);
231         require(upgrader != TokenUpgraderInterface(0));
232         var _allowance = allowed[_for][msg.sender];
233         require(_allowance > 0);
234         require(_allowance >= _value);
235         balances[_for] = balances[_for].sub(_value);
236         allowed[_for][msg.sender] = _allowance.sub(_value);
237         totalSupply = totalSupply.sub(_value);
238         assert(upgrader.upgradeFrom(msg.sender, _for, _value));
239         return true;
240     }
241 
242     function () payable external {
243         if (upgradable) {
244             assert(upgrade());
245             return;
246         }
247         revert();
248     }
249 
250 }