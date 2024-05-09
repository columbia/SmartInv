1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract Crowdsale is Ownable {
70   using SafeMath for uint256;
71 
72   // start and end timestamps where investments are allowed (both inclusive)
73   uint256 public startTime;
74   uint256 public endTime;
75 
76   // address where funds are collected
77   WhitelistedGateway public gateway;
78   PendingContributions public pending;
79 
80 	bool closedManually = false;
81 	bool acceptWithoutWhitelist = true;
82   uint256 minContrib;
83 
84 	function setPending(bool newValue) public onlyOwner {
85 		acceptWithoutWhitelist = newValue;
86 	}
87 
88 	function setClosedManually(bool newValue) public onlyOwner {
89 		closedManually = newValue;
90 	}
91 
92 
93   function Crowdsale(uint256 _startTime, uint256 _endTime, address _vault, Whitelist _whitelist, uint256 _minContrib) public {
94     // require(_startTime >= now);
95     require(_endTime >= _startTime);
96     require(_vault != address(0));
97 
98     startTime = _startTime;
99     endTime = _endTime;
100     minContrib = _minContrib;
101     gateway = new WhitelistedGateway(_whitelist, _vault);
102 	pending = new PendingContributions(gateway);
103 	// allow the pending container to fund the gateway
104 	gateway.addOwner(pending);
105   }
106 
107   // fallback function can be used to buy tokens
108   function () external payable {
109     require(validPurchase());
110     forwardFunds();  
111   }
112 
113   // send ether either to the Gateway or to the PendingContributions
114   function forwardFunds() internal {
115 	if(gateway.isWhitelisted(msg.sender)) {
116 		gateway.fund.value(msg.value)(msg.sender);
117 		return;
118 	} 
119 	pending.fund.value(msg.value)(msg.sender);
120   }
121 
122   // @return true if the transaction can buy tokens
123   function validPurchase() internal view returns (bool) {
124     bool withinPeriod = now >= startTime && now <= endTime;
125     bool sufficientPurchase = msg.value >= minContrib;
126     bool whitelisted = gateway.isWhitelisted(msg.sender);
127     return !closedManually && withinPeriod && sufficientPurchase && (acceptWithoutWhitelist || whitelisted);
128   }
129 
130   // @return true if crowdsale event has ended
131   function hasEnded() public view returns (bool) {
132     return now > endTime;
133   }
134 
135 }
136 
137 contract PendingContributions is Ownable {
138 	using SafeMath for uint256;
139 
140 	mapping(address=>uint256) public contributions;
141 	WhitelistedGateway public gateway;
142 
143 	event PendingContributionReceived(address contributor, uint256 value, uint256 timestamp);
144 	event PendingContributionAccepted(address contributor, uint256 value, uint256 timestamp);
145 	event PendingContributionWithdrawn(address contributor, uint256 value, uint256 timestamp);
146 
147 	function PendingContributions(WhitelistedGateway _gateway) public {
148 		gateway = _gateway;
149 	}
150 
151 	modifier onlyWhitelisted(address contributor) {
152 		require(gateway.isWhitelisted(contributor));
153 		_;
154 	}
155 
156 	function fund(address contributor) payable public onlyOwner {
157 		contributions[contributor] += msg.value;
158 		PendingContributionReceived(contributor, msg.value, now);
159 	}
160 
161 	function withdraw() public {
162 		uint256 toTransfer = contributions[msg.sender];
163 		require(toTransfer > 0);
164 		contributions[msg.sender] = 0;
165 		msg.sender.transfer(toTransfer);
166 		PendingContributionWithdrawn(msg.sender, toTransfer, now);
167 	}
168 
169 	function retry(address contributor) public onlyWhitelisted(contributor) {
170 		uint256 toTransfer = contributions[contributor];
171 		require(toTransfer > 0);
172 		gateway.fund.value(toTransfer)(contributor);
173 		contributions[contributor] = 0;
174 		PendingContributionAccepted(contributor, toTransfer, now);
175 	}
176 }
177 
178 contract Whitelist is Ownable {
179 	using SafeMath for uint256;
180 
181 	mapping(address=>bool) public whitelist;
182 	
183 	event Authorized(address candidate, uint timestamp);
184 	event Revoked(address candidate, uint timestamp);
185 
186 	function authorize(address candidate) public onlyOwner {
187 	    whitelist[candidate] = true;
188 	    Authorized(candidate, now);
189 	}
190 	
191 	// also if not in the list..
192 	function revoke(address candidate) public onlyOwner {
193 	    whitelist[candidate] = false;
194 	    Revoked(candidate, now);
195 	}
196 	
197 	function authorizeMany(address[50] candidates) public onlyOwner {
198 	    for(uint i = 0; i < candidates.length; i++) {
199 	        authorize(candidates[i]);
200 	    }
201 	}
202 
203 	function isWhitelisted(address candidate) public view returns(bool) {
204 		return whitelist[candidate];
205 	}
206 }
207 
208 contract WhitelistedGateway {
209 	using SafeMath for uint256;
210 
211 	mapping(address=>bool) public owners;
212 	mapping(address=>uint) public contributions;
213 	address public vault;
214 	Whitelist public whitelist;
215 
216 	event NewContribution(address contributor, uint256 amount, uint256 timestamp);
217 
218 	modifier onlyOwners() {
219 		require(owners[msg.sender]);
220 		_;
221 	}
222 
223 	function addOwner(address newOwner) public onlyOwners {
224 		owners[newOwner] = true;
225 	}
226 
227 	function WhitelistedGateway(Whitelist _whitelist, address _vault) public {
228 		whitelist = _whitelist;
229 		vault = _vault;
230 		owners[msg.sender] = true;
231 	}
232 
233 	function isWhitelisted(address candidate) public view returns(bool) {
234 		return whitelist.isWhitelisted(candidate);
235 	}
236 
237 	function fund(address contributor) public payable onlyOwners {
238 		contributions[contributor] += msg.value;
239 		vault.transfer(msg.value);
240 		NewContribution(contributor, msg.value, now);
241 	}
242 }