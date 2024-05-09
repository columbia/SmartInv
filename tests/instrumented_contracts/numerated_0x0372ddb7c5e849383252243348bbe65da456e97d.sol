1 pragma solidity 0.4.24;
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
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract Ownable {
47 	address public owner;
48 
49 	constructor() public{
50 		owner = msg.sender;
51 	}
52 
53 	modifier onlyOwner() {
54 		require(msg.sender == owner);
55 		_;
56 	}
57 }
58 
59 
60 contract Pausable is Ownable {
61 	event Pause();
62 	event Unpause();
63 
64 	bool public paused = false;
65 
66 	modifier whenNotPaused() {
67 		require(!paused);
68 		_;
69 	}
70 
71 	modifier whenPaused() {
72 		require(paused);
73 		_;
74 	}
75 
76 	function pause() onlyOwner whenNotPaused public {
77 		paused = true;
78 		emit Pause();
79 	}
80 
81 	function unpause() onlyOwner whenPaused public {
82 		paused = false;
83 		emit Unpause();
84 	}
85 }
86 
87 contract CUC is ERC20,Pausable {
88     
89     using SafeMath for uint256;
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93     mapping (address => bool) public blacklist;
94 
95     string public constant name = "CUC";
96     string public constant symbol = "CUC";
97     uint8 public constant decimals = 18; 
98 
99     uint256 public totalDistributed = 1050000000e18;  
100 	uint256 public teamDistributed = 450000000e18;  
101 	uint256 public platformDistributed = 1200000000e18;  
102     uint256 public totalRemaining; 
103     uint256 public value = 3000e18;
104 	
105     address private _team_beneficiary;
106     address private _platform_beneficiary;
107 	uint256 private _releaseTime = now + 365 days;  
108     
109     event Distr(address indexed to, uint256 amount);
110     event DistrFinished();
111     
112     event Burn(address indexed burner, uint256 value);
113 
114     bool public distributionFinished = false;
115     
116     modifier canDistr() {
117         require(!distributionFinished);
118         _;
119     }
120     
121     modifier onlyWhitelist() {
122         require(blacklist[msg.sender] == false);
123         _;
124     }
125     
126     constructor(address _team, address _platform) public {  
127 		owner = msg.sender;
128 		require(owner != _team);
129 		require(owner != _platform);
130 		require(_team != address(0));
131 		require(_platform != address(0));
132 		totalSupply = 3000000000e18;
133 		totalRemaining = totalSupply.sub(totalDistributed).sub(teamDistributed).sub(platformDistributed);
134         balances[owner] = totalDistributed;
135 		_team_beneficiary = _team;
136 		_platform_beneficiary = _platform;
137 		balances[_team_beneficiary] = teamDistributed;
138 		balances[_platform_beneficiary] = platformDistributed;
139     }
140     
141     function transferOwnership(address newOwner) onlyOwner public {
142 		require(newOwner != address(0));
143 		owner = newOwner;
144     }
145     
146     function finishDistribution() onlyOwner canDistr public returns (bool) {
147         distributionFinished = true;
148         emit DistrFinished();
149         return true;
150     }
151     
152     function distr(address _to, uint256 _amount) canDistr private returns (bool) {
153         totalDistributed = totalDistributed.add(_amount);
154         totalRemaining = totalRemaining.sub(_amount);
155         balances[_to] = balances[_to].add(_amount);
156         emit Distr(_to, _amount);
157         emit Transfer(address(0), _to, _amount);       
158         if (totalDistributed >= totalSupply) {
159             distributionFinished = true;
160         }
161 		return true;
162     }
163     
164     function () external payable {
165         getTokens();
166      }
167 
168     function getTokens() payable canDistr onlyWhitelist public {
169 	
170         if (value > totalRemaining) {
171             value = totalRemaining;
172         }
173         
174         require(value <= totalRemaining);
175         
176         address investor = msg.sender;
177 
178 		require(tx.origin == investor); 
179 		uint256 toGive = value;
180 		
181 		distr(investor, toGive);
182 		
183 		if (toGive > 0) {
184 			blacklist[investor] = true;
185 		}
186 		
187 		value = value.mul(99999).div(100000);   
188     }
189 
190     function balanceOf(address _owner) constant public returns (uint256) {
191         return balances[_owner];
192     }
193 
194     modifier onlyPayloadSize(uint size) {
195         require(msg.data.length >= size + 4);  
196         _;
197     }
198 	
199 	function isPayLock(address from) public view returns (bool) { 
200 		if (from == _team_beneficiary || from == _platform_beneficiary) {
201 			if (now >= _releaseTime) {
202 				return true;
203 			} else {
204 				return false;
205 			}
206 		} 
207 		return true;
208 	}
209     
210     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public whenNotPaused returns (bool success) {
211         require(_to != address(0));
212         require(_amount <= balances[msg.sender]);
213         require(isPayLock(msg.sender));
214         balances[msg.sender] = balances[msg.sender].sub(_amount);
215         balances[_to] = balances[_to].add(_amount);
216         emit Transfer(msg.sender, _to, _amount);
217         return true;
218     }
219     
220     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public whenNotPaused returns (bool success) {
221         require(_to != address(0));
222         require(_amount <= balances[_from]);
223         require(_amount <= allowed[_from][msg.sender]);
224         require(isPayLock(_from));
225         balances[_from] = balances[_from].sub(_amount);
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
227         balances[_to] = balances[_to].add(_amount);
228         emit Transfer(_from, _to, _amount);
229         return true;
230     }
231 
232     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
233         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
234         allowed[msg.sender][_spender] = _value;
235         emit Approval(msg.sender, _spender, _value);
236         return true;
237     }
238     
239     function allowance(address _owner, address _spender) constant public returns (uint256) {
240         return allowed[_owner][_spender];
241     }
242     
243     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
244         ForeignToken t = ForeignToken(tokenAddress);
245         uint bal = t.balanceOf(who);
246         return bal;
247     }
248     
249     function withdraw() onlyOwner public {
250         uint256 etherBalance = address(this).balance;
251         owner.transfer(etherBalance);
252     }
253     
254     function burn(uint256 _value) onlyOwner public {
255         require(_value <= balances[msg.sender]);
256         address burner = msg.sender;
257         balances[burner] = balances[burner].sub(_value);
258         totalSupply = totalSupply.sub(_value);
259         totalDistributed = totalDistributed.sub(_value);
260         emit Burn(burner, _value);
261     }
262     
263     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
264         ForeignToken token = ForeignToken(_tokenContract);
265         uint256 amount = token.balanceOf(address(this));
266         return token.transfer(owner, amount);
267     }
268 }