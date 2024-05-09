1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 interface TokenUpgraderInterface{
28     function hasUpgraded(address _for) public view returns (bool alreadyUpgraded);
29     function upgradeFor(address _for, uint256 _value) public returns (bool success);
30 }
31   
32 contract ManagedToken {
33     using SafeMath for uint256;
34 
35 
36     address public owner = msg.sender;
37     address public crowdsaleContractAddress;
38     address public crowdsaleManager;
39 
40     string public name;
41     string public symbol;
42 
43     bool public upgradable = false;
44     bool public upgraderSet = false;
45     TokenUpgraderInterface public upgrader;
46 
47     bool public locked = true;
48         
49     uint8 public decimals = 18;
50 
51     uint256 public totalSupplyLimit = 1000000000*(10**18);  //  limit supply to 1 bln tokens
52     uint256 private newTotalSupply;
53 
54     modifier unlocked() {
55         require(!locked);
56         _;
57     }
58 
59     modifier unlockedOrByManager() {
60         require(!locked || (crowdsaleManager != address(0) && msg.sender == crowdsaleManager) || (msg.sender == owner));
61         _;
62     }
63     // Ownership
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     modifier onlyCrowdsale() {
73         require(msg.sender == crowdsaleContractAddress);
74         _;
75     }
76 
77     modifier ownerOrCrowdsale() {
78         require(msg.sender == owner || msg.sender == crowdsaleContractAddress);
79         _;
80     }
81 
82     function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
83         require(newOwner != address(0));      
84         OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         return true;
87     }
88 
89 
90     // ERC20 related functions
91 
92     uint256 public totalSupply = 0;
93 
94     mapping(address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 
101     function transfer(address _to, uint256 _value) unlockedOrByManager public returns (bool) {
102         require(_to != address(0));
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     function balanceOf(address _owner) view public returns (uint256 balance) {
110         return balances[_owner];
111     }
112 
113     function transferFrom(address _from, address _to, uint256 _value) unlocked public returns (bool) {
114         require(_to != address(0));
115         var _allowance = allowed[_from][msg.sender];
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         allowed[_from][msg.sender] = _allowance.sub(_value);
119         Transfer(_from, _to, _value);
120         return true;
121     }
122 
123     function approve(address _spender, uint256 _value) unlocked public returns (bool) {
124         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127         return true;
128     }
129 
130     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
131         return allowed[_owner][_spender];
132     }
133 
134     function increaseApproval (address _spender, uint _addedValue) unlocked public
135         returns (bool success) {
136             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138             return true;
139     }
140 
141     function decreaseApproval (address _spender, uint _subtractedValue) unlocked public
142         returns (bool success) {
143             uint oldValue = allowed[msg.sender][_spender];
144             if (_subtractedValue > oldValue) {
145             allowed[msg.sender][_spender] = 0;
146             } else {
147             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148             }
149             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150             return true;
151     }
152 
153     function ManagedToken (string _name, string _symbol, uint8 _decimals) public {
154         require(bytes(_name).length > 1);
155         require(bytes(_symbol).length > 1);
156         name = _name;
157         symbol = _symbol;
158         decimals = _decimals;
159     }
160 
161     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
162         require(bytes(_name).length > 1);
163         require(bytes(_symbol).length > 1);
164         name = _name;
165         symbol = _symbol;
166         return true;
167     }
168 
169     function setLock(bool _newLockState) ownerOrCrowdsale public returns (bool success) {
170         require(_newLockState != locked);
171         locked = _newLockState;
172         return true;
173     }
174 
175     function setCrowdsale(address _newCrowdsale) onlyOwner public returns (bool success) {
176         crowdsaleContractAddress = _newCrowdsale;
177         return true;
178     }
179 
180     function setManager(address _newManager) onlyOwner public returns (bool success) {
181         crowdsaleManager = _newManager;
182         return true;
183     }
184 
185     function mint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
186         newTotalSupply = totalSupply.add(_amount);
187         if (newTotalSupply > totalSupplyLimit) {
188           revert();
189         }
190         balances[_for] = balances[_for].add(_amount);
191         totalSupply = newTotalSupply;
192         Transfer(0, _for, _amount);
193         return true;
194     }
195 
196     function demint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
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
220         require(!upgrader.hasUpgraded(msg.sender));
221         uint256 value = balances[msg.sender];
222         assert(value > 0);
223         delete balances[msg.sender];
224         totalSupply = totalSupply.sub(value);
225         assert(upgrader.upgradeFor(msg.sender, value));
226         return true;
227     }
228 
229     function upgradeFor(address _for, uint256 _value) public returns (bool success) {
230         require(upgradable);
231         require(upgraderSet);
232         require(upgrader != TokenUpgraderInterface(0));
233         var _allowance = allowed[_for][msg.sender];
234         assert(_allowance > 0);
235         balances[_for] = balances[_for].sub(_value);
236         allowed[_for][msg.sender] = _allowance.sub(_value);
237         totalSupply = totalSupply.sub(_value);
238         assert(upgrader.upgradeFor(_for, _value));
239         return true;
240     }
241 
242     function () external {
243         if (upgradable) {
244             assert(upgrade());
245             return;
246         }
247         revert();
248     }
249 
250 }