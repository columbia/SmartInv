1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract Ownable {
32     address owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) public onlyOwner {
46         require(newOwner != address(0));
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 contract ERC20Basic {
53     uint256 public totalSupply;
54     function balanceOf(address who) public view returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 contract ERC20 is ERC20Basic {
60     function allowance(address owner, address spender) public view returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68  
69     mapping(address => uint256) balances;
70 
71     function transfer(address _to, uint256 _value) public returns (bool) {
72       require(_to != address(0));
73       require(_value <= balances[msg.sender]);
74 
75       balances[msg.sender] = balances[msg.sender].sub(_value);
76       balances[_to] = balances[_to].add(_value);
77       Transfer(msg.sender, _to, _value);
78       return true;
79     }
80 
81     function balanceOf(address _owner) public view returns (uint256 balance) {
82       return balances[_owner];
83     }
84 }
85 
86 contract StandardToken is ERC20, BasicToken {
87     mapping (address => mapping (address => uint256)) internal allowed;
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90         require(_to != address(0));
91         require(_value <= balances[_from]);
92         require(_value <= allowed[_from][msg.sender]);
93 
94         balances[_from] = balances[_from].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) public view returns (uint256) {
108         return allowed[_owner][_spender];
109     }
110 
111     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
112         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114         return true;
115     }
116 
117     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
118         uint oldValue = allowed[msg.sender][_spender];
119         if (_subtractedValue > oldValue) {
120             allowed[msg.sender][_spender] = 0;
121         } else {
122             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123         }
124         
125         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126         
127         return true;
128     }
129 }
130 
131 contract FreezableToken is StandardToken, Ownable {
132     event Freeze(address indexed who, uint256 end);
133 
134     mapping(address=>uint256) freezeEnd;
135 
136     function freeze(address _who, uint256 _end) onlyOwner public {
137         require(_who != address(0));
138         require(_end >= freezeEnd[_who]);
139 
140         freezeEnd[_who] = _end;
141 
142         Freeze(_who, _end);
143     }
144 
145     modifier notFrozen(address _who) {
146         require(freezeEnd[_who] < now);
147         _;
148     }
149 
150     function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
151         super.transferFrom(_from, _to, _value);
152     }
153 
154     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
155         super.transfer(_to, _value);
156     }
157 }
158 
159 contract UpgradeAgent {
160     function upgradeFrom(address _from, uint256 _value) public;
161 }
162 
163 contract UpgradableToken is StandardToken, Ownable {
164     using SafeMath for uint256;
165 
166     address public upgradeAgent;
167     uint256 public totalUpgraded;
168 
169     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
170 
171     function upgrade(uint256 _value) external {
172         assert(upgradeAgent != address(0));
173         require(_value != 0);
174         require(_value <= balances[msg.sender]);
175 
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         totalSupply = totalSupply.sub(_value);
178         totalUpgraded = totalUpgraded.add(_value);
179         UpgradeAgent(upgradeAgent).upgradeFrom(msg.sender, _value);
180         Upgrade(msg.sender, upgradeAgent, _value);
181     }
182 
183     function setUpgradeAgent(address _agent) external onlyOwner {
184         require(_agent != address(0));
185         assert(upgradeAgent == address(0));
186         
187         upgradeAgent = _agent;
188     }
189 }
190 
191 contract CrowdsaleToken is StandardToken, Ownable {
192     using SafeMath for uint256;
193     address public crowdsale;
194     mapping (address => uint256) public waiting;
195     uint256 public saled;
196 
197     event Sale(address indexed to, uint256 value);
198     event Release(address indexed to);
199     event Reject(address indexed to);
200     event SetCrowdsale(address indexed addr);
201 
202     function setCrowdsale(address _addr) onlyOwner public {
203         crowdsale = _addr;
204         SetCrowdsale(_addr);
205     }
206 
207     modifier onlyCrowdsale() {
208         require(crowdsale != address(0));
209         require(crowdsale == msg.sender);
210         _;
211     }
212 
213     function sale(address _to, uint256 _value) public onlyCrowdsale returns (bool) {
214         require(_to != address(0));
215         assert(saled.add(_value) <= balances[owner]);
216 
217         saled = saled.add(_value);
218         waiting[_to] = waiting[_to].add(_value);
219         Sale(_to, _value);
220         return true;
221     }
222 
223     // send waiting tokens to customer's balance
224     function release(address _to) external onlyOwner {
225         require(_to != address(0));
226 
227         uint256 val = waiting[_to];
228         waiting[_to] = 0;
229         balances[owner] = balances[owner].sub(val);
230         balances[_to] = balances[_to].add(val);
231         Release(_to);
232     }
233 
234     // reject waiting token
235     function reject(address _to) external onlyOwner {
236         require(_to != address(0));
237 
238         saled = saled.sub(waiting[_to]);
239         waiting[_to] = 0;
240 
241         Reject(_to);
242     }
243 }
244 
245 contract BurnableToken is BasicToken, Ownable {
246     event Burn(uint256 value);
247 
248     function burn(uint256 _value) onlyOwner public {
249         require(_value <= balances[owner]);
250 
251         balances[owner] = balances[owner].sub(_value);
252         totalSupply = totalSupply.sub(_value);
253         Burn(_value);
254     }
255 }
256 
257 contract MossCoin is FreezableToken, UpgradableToken, CrowdsaleToken, BurnableToken {
258     string public constant name = "Moss Coin";
259     string public constant symbol = "MOC";
260     uint8 public constant decimals = 18;
261 
262     function MossCoin(uint256 _amount) public
263         Ownable()
264     {
265         totalSupply = _amount * 1 ether;
266         balances[owner] = totalSupply;
267     }
268 }