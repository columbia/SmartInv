1 pragma solidity ^0.4.21;
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
47         emit OwnershipTransferred(owner, newOwner);
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
72         require(_to != address(0));
73         require(_value <= balances[msg.sender]);
74 
75         balances[msg.sender] = balances[msg.sender].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         emit Transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) public view returns (uint256 balance) {
82         return balances[_owner];
83     }
84 }
85 
86 
87 contract StandardToken is ERC20, BasicToken {
88     mapping (address => mapping (address => uint256)) internal allowed;
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[_from]);
93         require(_value <= allowed[_from][msg.sender]);
94 
95         balances[_from] = balances[_from].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98         emit Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool) {
103         allowed[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public view returns (uint256) {
109         return allowed[_owner][_spender];
110     }
111 
112     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
113         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115         return true;
116     }
117 
118     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
119         uint oldValue = allowed[msg.sender][_spender];
120         if (_subtractedValue > oldValue) {
121             allowed[msg.sender][_spender] = 0;
122         } else {
123             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124         }
125         
126         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127         
128         return true;
129     }
130 }
131 
132 contract FreezableToken is StandardToken, Ownable {
133     event Freeze(address indexed who, uint256 end);
134 
135     mapping(address=>uint256) freezeEnd;
136 
137     function freeze(address _who, uint256 _end) onlyOwner public {
138         require(_who != address(0));
139         require(_end >= freezeEnd[_who]);
140 
141         freezeEnd[_who] = _end;
142 
143         emit Freeze(_who, _end);
144     }
145 
146     modifier notFrozen(address _who) {
147         require(freezeEnd[_who] < now);
148         _;
149     }
150 
151     function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
152         super.transferFrom(_from, _to, _value);
153     }
154 
155     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
156         super.transfer(_to, _value);
157     }
158 }
159 
160 contract UpgradeAgent {
161     function upgradeFrom(address _from, uint256 _value) public;
162 }
163 
164 contract UpgradableToken is StandardToken, Ownable {
165     using SafeMath for uint256;
166 
167     address public upgradeAgent;
168     uint256 public totalUpgraded;
169 
170     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
171 
172     function upgrade(uint256 _value) external {
173         assert(upgradeAgent != address(0));
174         require(_value != 0);
175         require(_value <= balances[msg.sender]);
176 
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         totalSupply = totalSupply.sub(_value);
179         totalUpgraded = totalUpgraded.add(_value);
180         UpgradeAgent(upgradeAgent).upgradeFrom(msg.sender, _value);
181         emit Upgrade(msg.sender, upgradeAgent, _value);
182     }
183 
184     function setUpgradeAgent(address _agent) external onlyOwner {
185         require(_agent != address(0));
186         assert(upgradeAgent == address(0));
187         
188         upgradeAgent = _agent;
189     }
190 }
191 
192 contract BurnableToken is BasicToken, Ownable {
193     event Burn(uint256 value);
194 
195     function burn(uint256 _value) onlyOwner public {
196         require(_value <= balances[owner]);
197 
198         balances[owner] = balances[owner].sub(_value);
199         totalSupply = totalSupply.sub(_value);
200         emit Burn(_value);
201     }
202 }
203 
204 contract StoppableToken is FreezableToken {
205     event Stop();
206     event Start();
207 
208     bool isStop;
209 
210     function stop() onlyOwner public {
211         isStop = true;
212         emit Stop();
213     }
214 
215     function start() onlyOwner public {
216         isStop = false;
217         emit Start();
218     }
219 
220     modifier notFrozen(address _who) {
221         require(!isStop);
222         require(freezeEnd[_who] < now);
223         _;
224     }
225 }
226 
227 contract MossCoin is StoppableToken, UpgradableToken, BurnableToken {
228     string public constant name = "Moss Coin";
229     string public constant symbol = "MOC";
230     uint8 public constant decimals = 18;
231 
232     function MossCoin(uint256 _amount) public
233         Ownable()
234     {
235         totalSupply = _amount * 1 ether;
236         balances[owner] = totalSupply;
237     }
238 }