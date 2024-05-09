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
28     function hasUpgraded(address _for) public view returns (bool alreadyUpgraded);
29     function upgradeFor(address _for, uint256 _value) public returns (bool success);
30     function upgradeFrom(address _by, address _for, uint256 _value) public returns (bool success);
31 }
32   
33 contract ManagedToken {
34     using SafeMath for uint256;
35 
36     address public owner = msg.sender;
37     address public crowdsaleContractAddress;
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
55     // Ownership
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     modifier onlyCrowdsale() {
65         require(msg.sender == crowdsaleContractAddress);
66         _;
67     }
68 
69     modifier ownerOrCrowdsale() {
70         require(msg.sender == owner || msg.sender == crowdsaleContractAddress);
71         _;
72     }
73 
74     function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
75         require(newOwner != address(0));      
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         return true;
79     }
80 
81 
82     // ERC20 related functions
83 
84     uint256 public totalSupply = 0;
85 
86     mapping(address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88 
89 
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92 
93     function transfer(address _to, uint256 _value) unlocked public returns (bool) {
94         require(_to != address(0));
95         balances[msg.sender] = balances[msg.sender].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         Transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     function balanceOf(address _owner) view public returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) unlocked public returns (bool) {
106         require(_to != address(0));
107         var _allowance = allowed[_from][msg.sender];
108         balances[_from] = balances[_from].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         allowed[_from][msg.sender] = _allowance.sub(_value);
111         Transfer(_from, _to, _value);
112         return true;
113     }
114 
115     function approve(address _spender, uint256 _value) unlocked public returns (bool) {
116         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126     function increaseApproval (address _spender, uint _addedValue) unlocked public
127         returns (bool success) {
128             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
129             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130             return true;
131     }
132 
133     function decreaseApproval (address _spender, uint _subtractedValue) unlocked public
134         returns (bool success) {
135             uint oldValue = allowed[msg.sender][_spender];
136             if (_subtractedValue > oldValue) {
137             allowed[msg.sender][_spender] = 0;
138             } else {
139             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
140             }
141             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142             return true;
143     }
144 
145     function ManagedToken (string _name, string _symbol, uint8 _decimals) public {
146         require(bytes(_name).length > 1);
147         require(bytes(_symbol).length > 1);
148         name = _name;
149         symbol = _symbol;
150         decimals = _decimals;
151     }
152 
153     function setNameAndTicker(string _name, string _symbol) onlyOwner public returns (bool success) {
154         require(bytes(_name).length > 1);
155         require(bytes(_symbol).length > 1);
156         name = _name;
157         symbol = _symbol;
158         return true;
159     }
160 
161     function setLock(bool _newLockState) ownerOrCrowdsale public returns (bool success) {
162         require(_newLockState != locked);
163         locked = _newLockState;
164         return true;
165     }
166 
167     function disableMinting() ownerOrCrowdsale public returns (bool success) {
168         require(mintingAllowed);
169         mintingAllowed = false;
170         return true;
171     }
172 
173     function setCrowdsale(address _newCrowdsale) onlyOwner public returns (bool success) {
174         crowdsaleContractAddress = _newCrowdsale;
175         return true;
176     }
177 
178     function mint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
179         require(mintingAllowed);
180         balances[_for] = balances[_for].add(_amount);
181         totalSupply = totalSupply.add(_amount);
182         Transfer(0, _for, _amount);
183         return true;
184     }
185 
186     function demint(address _for, uint256 _amount) onlyCrowdsale public returns (bool success) {
187         require(mintingAllowed);
188         balances[_for] = balances[_for].sub(_amount);
189         totalSupply = totalSupply.sub(_amount);
190         Transfer(_for, 0, _amount);
191         return true;
192     }
193 
194     function allowUpgrading(bool _newState) onlyOwner public returns (bool success) {
195         upgradable = _newState;
196         return true;
197     }
198 
199     function setUpgrader(address _upgraderAddress) onlyOwner public returns (bool success) {
200         require(!upgraderSet);
201         require(_upgraderAddress != address(0));
202         upgraderSet = true;
203         upgrader = TokenUpgraderInterface(_upgraderAddress);
204         return true;
205     }
206 
207     function upgrade() public returns (bool success) {
208         require(upgradable);
209         require(upgraderSet);
210         require(upgrader != TokenUpgraderInterface(0));
211         uint256 value = balances[msg.sender];
212         assert(value > 0);
213         delete balances[msg.sender];
214         totalSupply = totalSupply.sub(value);
215         assert(upgrader.upgradeFor(msg.sender, value));
216         return true;
217     }
218 
219     function upgradeFor(address _for, uint256 _value) public returns (bool success) {
220         require(upgradable);
221         require(upgraderSet);
222         require(upgrader != TokenUpgraderInterface(0));
223         var _allowance = allowed[_for][msg.sender];
224         require(_allowance > 0);
225         require(_allowance >= _value);
226         balances[_for] = balances[_for].sub(_value);
227         allowed[_for][msg.sender] = _allowance.sub(_value);
228         totalSupply = totalSupply.sub(_value);
229         assert(upgrader.upgradeFrom(msg.sender, _for, _value));
230         return true;
231     }
232 
233     function () external {
234         if (upgradable) {
235             assert(upgrade());
236             return;
237         }
238         revert();
239     }
240 
241 }