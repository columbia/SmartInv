1 pragma solidity ^0.4.21;
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
27 interface Token { 
28     function distr(address _to, uint256 _value) external returns (bool);
29     function teamdistr(address _to, uint256 _value) external returns (bool);
30     function totalSupply() constant external returns (uint256 supply);
31     function balanceOf(address _owner) constant external returns (uint256 balance);
32 }
33 
34 contract ForeignToken {
35     function balanceOf(address _owner) constant public returns (uint256);
36     function transfer(address _to, uint256 _value) public returns (bool);
37 }
38 
39 contract ERC20Basic {
40     uint256 public totalSupply;
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     function allowance(address owner, address spender) public constant returns (uint256);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract TFFC is ERC20Basic {
51 
52 	using SafeMath for uint256;
53 	address owner = msg.sender;
54 
55 	mapping (address => uint256) balances;
56 	mapping (address => mapping (address => uint256)) allowed;
57 	mapping (address => bool) public blacklist;
58 
59 	string public constant name = "TFFC";
60 	string public constant symbol = "TF";
61 	uint public constant decimals = 8;
62 
63 	uint256 public totalSupply = 50000000e8;//50000000e8;//总量5000万个
64 	uint256 public totaTeamRemaining = (totalSupply.div(100).mul(20));
65 	uint256 private totaTeamRemainingBak = totaTeamRemaining;
66 	uint256 public totalRemaining = (totalSupply.sub(totaTeamRemaining));
67 	uint256 private totalRemainingBak = totalRemaining;
68 	uint256 public uservalue;
69 	uint256 public teamvalue;
70 	uint256 private TeamReleaseCount = 0;
71 	uint256 private UserSendCount = 0;
72 	uint256 private UserSendCountBak = 0; 
73 	uint256 private totalPhaseValue = 1000e8;
74 	bool public distributionuserFinished = false; //用户分发是否结束的标志 false:未结束 true:结束
75 	bool public distributionteamFinished = false;//团队分发是否结束的标志 false：未结束  true： 结束
76 
77 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79     event UserDistr(address indexed to, uint256 amount);
80     event TeamDistr(address indexed to, uint256 amount);
81     event DistrFinished();
82 
83 	modifier onlyOwner() {
84 		require(msg.sender == owner);
85         _;
86 	}
87 
88 	modifier canUserDistr() {
89         require(!distributionuserFinished);
90         _;
91     }
92 
93     modifier canTeamDistr() {
94         require(!distributionteamFinished);
95         _;
96     }
97 
98     modifier onlyWhitelist() {
99         require(blacklist[msg.sender] == false);
100         _;
101     }
102 
103     modifier onlyPayloadSize(uint size) {
104         assert(msg.data.length >= size + 4);
105         _;
106     }
107 
108     function TFFC () public {
109     	owner = msg.sender;
110     	uservalue = 1000e8;
111     	teamvalue = (totaTeamRemaining.div(100).mul(20));
112     }
113 
114     function teamdistr(address _to, uint256 _amount) canTeamDistr private returns (bool) {
115     	TeamReleaseCount = TeamReleaseCount.add(_amount);
116     	totaTeamRemaining = totaTeamRemaining.sub(_amount);
117     	balances[_to] = balances[_to].add(_amount);
118     	emit TeamDistr(_to,_amount);
119     	emit Transfer(address(0), _to, _amount);
120     	
121     	return true;
122 
123     	if (TeamReleaseCount >= totaTeamRemainingBak) {
124         	distributionteamFinished = true;
125         }
126     }
127 
128     function teamRelease(address _to) payable canTeamDistr onlyOwner public {
129     	if (teamvalue > totaTeamRemaining) {
130 			teamvalue = totaTeamRemaining;
131 		}
132 
133 		require(teamvalue <= totaTeamRemaining);
134 
135         teamdistr(_to, teamvalue);
136 
137         if (TeamReleaseCount >= totaTeamRemainingBak) {
138         	distributionteamFinished = true;
139         }
140     }
141 
142     function () external payable {
143         getTokens();
144     }
145 
146     function distr(address _to, uint256 _amount) canUserDistr private returns (bool) {
147 		
148 		UserSendCount = UserSendCount.add(_amount);
149 		totalRemaining = totalRemaining.sub(_amount);
150 		balances[_to] = balances[_to].add(_amount);
151 		if (UserSendCount < totalRemainingBak) {
152 			if (UserSendCount.sub(UserSendCountBak) >= totalPhaseValue) {
153         		uservalue = uservalue.div(2);
154         		UserSendCountBak = UserSendCount;
155         	}
156 		}
157 
158         emit UserDistr(_to, _amount);
159         emit Transfer(address(0), _to, _amount);
160         
161         return true;
162         
163         if (UserSendCount >= totalRemainingBak) {
164         	distributionuserFinished = true;
165         }
166         
167     }
168 
169 
170 	function getTokens() payable canUserDistr onlyWhitelist public {
171 		
172 		if (uservalue > totalRemaining) {
173 			uservalue = totalRemaining;
174 		}
175 
176 		require(uservalue <= totalRemaining);
177 
178 		address investor = msg.sender;
179         uint256 toGive = uservalue;
180 
181         distr(investor, toGive);
182 
183         if (toGive > 0) {
184         	blacklist[investor] = true;
185         }
186 
187         if (UserSendCount >= totalRemainingBak) {
188         	distributionuserFinished = true;
189         }
190 	}
191 
192 	function transferOwnership(address newOwner) onlyOwner public {
193         if (newOwner != address(0)) {
194             owner = newOwner;
195         }
196     }
197 
198     function enableWhitelist(address[] addresses) onlyOwner public {
199         for (uint i = 0; i < addresses.length; i++) {
200             blacklist[addresses[i]] = false;
201         }
202     }
203 
204     function disableWhitelist(address[] addresses) onlyOwner public {
205         for (uint i = 0; i < addresses.length; i++) {
206             blacklist[addresses[i]] = true;
207         }
208     }
209 
210     function finishUserDistribution() onlyOwner canUserDistr public returns (bool) {
211         distributionuserFinished = true;
212         emit DistrFinished();
213         return true;
214     }
215 
216     function balanceOf(address _owner) constant public returns (uint256) {
217 	    return balances[_owner];
218     }
219 
220     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
221 
222         require(_to != address(0));
223         require(_amount <= balances[msg.sender]);
224         
225         balances[msg.sender] = balances[msg.sender].sub(_amount);
226         balances[_to] = balances[_to].add(_amount);
227         emit Transfer(msg.sender, _to, _amount);
228         return true;
229     }
230     
231     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
232 
233         require(_to != address(0));
234         require(_amount <= balances[_from]);
235         require(_amount <= allowed[_from][msg.sender]);
236         
237         balances[_from] = balances[_from].sub(_amount);
238         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
239         balances[_to] = balances[_to].add(_amount);
240         emit Transfer(_from, _to, _amount);
241         return true;
242     }
243 
244     function approve(address _spender, uint256 _value) public returns (bool success) {
245         // mitigates the ERC20 spend/approval race condition
246         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
247         allowed[msg.sender][_spender] = _value;
248         emit Approval(msg.sender, _spender, _value);
249         return true;
250     }
251     
252     function allowance(address _owner, address _spender) constant public returns (uint256) {
253         return allowed[_owner][_spender];
254     }
255 
256     function withdraw() onlyOwner public {
257         uint256 etherBalance = address(this).balance;
258         owner.transfer(etherBalance);
259     }
260 
261     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
262         ForeignToken t = ForeignToken(tokenAddress);
263         uint bal = t.balanceOf(who);
264         return bal;
265     }
266 
267     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
268         ForeignToken token = ForeignToken(_tokenContract);
269         uint256 amount = token.balanceOf(address(this));
270         return token.transfer(owner, amount);
271     }
272 }