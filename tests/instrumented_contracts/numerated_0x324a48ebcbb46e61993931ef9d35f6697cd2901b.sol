1 pragma solidity 0.4.19;
2 
3 contract Owned {
4     address public owner;
5     address public pendingOwner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     function Owned() internal {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) public onlyOwner {
19         require(newOwner != address(0));
20         pendingOwner = newOwner;
21     }
22 
23     function acceptOwnership() public {
24         require(msg.sender == pendingOwner);
25         OwnershipTransferred(owner, pendingOwner);
26         owner = pendingOwner;
27         pendingOwner = address(0);
28     }
29 }
30 
31 contract Support is Owned {
32     mapping (address => bool) public supportList;
33 
34     event SupportAdded(address indexed _who);
35     event SupportRemoved(address indexed _who);
36 
37 
38     modifier supportOrOwner {
39         require(msg.sender == owner || supportList[msg.sender]);
40         _;
41     }
42 
43     function addSupport(address _who) public onlyOwner {
44         require(_who != address(0));
45         require(_who != owner);
46         require(!supportList[_who]);
47         supportList[_who] = true;
48         SupportAdded(_who);
49     }
50 
51     function removeSupport(address _who) public onlyOwner {
52         require(supportList[_who]);
53         supportList[_who] = false;
54         SupportRemoved(_who);
55     }
56 }
57 
58 library SafeMath {
59     function sub(uint a, uint b) internal pure returns (uint) {
60         assert(b <= a);
61         return a - b;
62     }
63 
64     function add(uint a, uint b) internal pure returns (uint) {
65         uint c = a + b;
66         assert(c >= a);
67         return c;
68     }
69 }
70 
71 contract MigrationAgent {
72     function migrateFrom(address _from, uint256 _value) public;
73 }
74 
75 // ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
76 contract ERC20 {
77     uint public totalSupply;
78     function balanceOf(address who) public constant returns (uint balance);
79     function allowance(address owner, address spender) public constant returns (uint remaining);
80     function transfer(address to, uint value) public returns (bool success);
81     function transferFrom(address from, address to, uint value) public returns (bool success);
82     function approve(address spender, uint value) public returns (bool success);
83 
84     event Transfer(address indexed from, address indexed to, uint value);
85     event Approval(address indexed owner, address indexed spender, uint value);
86 }
87 
88 contract Skraps is ERC20, Support {
89     using SafeMath for uint;
90 
91     string public name = "Skraps";
92     string public symbol = "SKRP";
93     uint8 public decimals = 18;
94     uint public totalSupply;
95 
96     uint private endOfFreeze = 1522569600; // Sun, 01 Apr 2018 00:00:00 PST
97     uint private MAX_SUPPLY = 110000000 * 1 ether;
98 
99     address public migrationAgent;
100 
101     mapping (address => uint) private balances;
102     mapping (address => mapping (address => uint)) private allowed;
103 
104     enum State { Enabled, Migration }
105     State public state = State.Enabled;
106 
107     event Burn(address indexed from, uint256 value);
108 
109     function balanceOf(address _who) public constant returns (uint) {
110         return balances[_who];
111     }
112 
113     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
114         return allowed[_owner][_spender];
115     }
116 
117     function Skraps() public {
118         totalSupply = MAX_SUPPLY;
119         balances[owner] = totalSupply;
120         Transfer(0, owner, totalSupply);
121     }
122 
123     function transfer(address _to, uint _value) public returns (bool success) {
124         require(_to != address(0));
125         require(now > endOfFreeze || msg.sender == owner || supportList[msg.sender]);
126         require(balances[msg.sender] >= _value);
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
134         require(_to != address(0));
135         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         balances[_from] = balances[_from].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         Transfer(_from, _to, _value);
140         return true;
141     }
142 
143     function approve(address _spender, uint _value) public returns (bool success) {
144         require(_spender != address(0));
145         require(now > endOfFreeze || msg.sender == owner || supportList[msg.sender]);
146         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     function setMigrationAgent(address _agent) public onlyOwner {
153         require(state == State.Enabled);
154         migrationAgent = _agent;
155     }
156 
157     function startMigration() public onlyOwner {
158         require(migrationAgent != address(0));
159         require(state == State.Enabled);
160         state = State.Migration;
161     }
162 
163     function cancelMigration() public onlyOwner {
164         require(state == State.Migration);
165         require(totalSupply == MAX_SUPPLY);
166         migrationAgent = address(0);
167         state = State.Enabled;
168     }
169 
170     function migrate() public {
171         require(state == State.Migration);
172         require(balances[msg.sender] > 0);
173         uint value = balances[msg.sender];
174         balances[msg.sender] = balances[msg.sender].sub(value);
175         totalSupply = totalSupply.sub(value);
176         Burn(msg.sender, value);
177         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
178     }
179 
180     function manualMigrate(address _who) public supportOrOwner {
181         require(state == State.Migration);
182         require(balances[_who] > 0);
183         uint value = balances[_who];
184         balances[_who] = balances[_who].sub(value);
185         totalSupply = totalSupply.sub(value);
186         Burn(_who, value);
187         MigrationAgent(migrationAgent).migrateFrom(_who, value);
188     }
189 
190     function withdrawTokens(uint _value) public onlyOwner {
191         require(balances[address(this)] > 0 && balances[address(this)] >= _value);
192         balances[address(this)] = balances[address(this)].sub(_value);
193         balances[msg.sender] = balances[msg.sender].add(_value);
194         Transfer(address(this), msg.sender, _value);
195     }
196 
197     function () payable public {
198         require(state == State.Migration);
199         require(msg.value == 0);
200         migrate();
201     }
202 }