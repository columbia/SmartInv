1 pragma solidity ^0.4.18;
2 
3 library CSCLib {
4 
5 	uint constant MILLION = 1000000;
6 	uint constant GASLIMIT = 65000;
7 
8 
9 	struct Split {
10 		address to;
11 		uint ppm;
12 	}
13 
14 	struct CSCStorage {
15 		mapping(address => uint) lastUserClaim;
16 		uint[] deposits;
17 		bool isClaimable;
18 
19 		address developer;
20 		uint dev_fee;
21 		uint refer_fee;
22 		Split[] splits;
23 		mapping(address => uint) userSplit;
24 	}
25 
26 	event SplitTransfer(address to, uint amount, uint balance);
27 
28 	/*
29 	self: a storage pointer
30 
31 	members: an array of addresses
32 
33 	ppms: an array of integers that should sum to 1 million.
34 		Represents how much ether a user should get
35 
36 	refer: the address of a referral contract that referred this user.
37 		Referral contract should be a claimable contract
38 
39 	*/
40 	function init(CSCStorage storage self,  address[] members, uint[] ppms, address refer) internal {
41 		uint shift_amt = self.dev_fee / members.length;
42 		uint remainder = self.dev_fee % members.length * members.length / 10;
43 		uint dev_total = self.dev_fee + remainder;
44 		self.deposits.push(0);
45 		if(refer != 0x0){
46 			addSplit(self, Split({to: self.developer, ppm: dev_total - self.refer_fee}));
47 			addSplit(self, Split({to: refer, ppm: self.refer_fee}));
48 		} else {
49 			addSplit(self, Split({to: self.developer, ppm: dev_total}));
50 		}
51 
52 		uint sum = 0;
53 		for(uint index = 0; index < members.length; index++) {
54 			sum += ppms[index];
55 			addSplit(self, Split({to: members[index], ppm: ppms[index] - shift_amt}));
56 		}
57 		require(sum >= MILLION - 1 && sum < MILLION + 1 );
58 	}
59 
60 	function addSplit(CSCStorage storage self, Split newSplit) internal {
61 		require(newSplit.ppm > 0);
62 		uint index = self.userSplit[newSplit.to];
63 		if(index > 0) {
64 			newSplit.ppm += self.splits[index].ppm;
65 			self.splits[index] = newSplit;
66 		} else {
67 			self.userSplit[newSplit.to] = self.splits.length;
68 			self.lastUserClaim[newSplit.to] = self.deposits.length;
69 			self.splits.push(newSplit);
70 		}
71 	}
72 
73 	function payAll(CSCStorage storage self) internal {
74 		for(uint index = 0; index < self.splits.length; index++) {
75 			uint value = (msg.value) * self.splits[index].ppm / MILLION;
76 			if(value > 0 ) {
77 				require(self.splits[index].to.call.gas(GASLIMIT).value(value)());
78 				SplitTransfer(self.splits[index].to, value, this.balance);
79 			}
80 		}
81 	}
82 
83 	function getSplit(CSCStorage storage self, uint index) internal view returns (Split) {
84 		return self.splits[index];
85 	}
86 
87 	function getSplitCount(CSCStorage storage self) internal view returns (uint count) {
88 		return self.splits.length;
89 	}
90 
91 	function claimFor(CSCStorage storage self, address user) internal {
92 		require(self.isClaimable);
93 		uint sum = getClaimableBalanceFor(self, user);
94 		uint splitIndex = self.userSplit[user];
95 		self.lastUserClaim[user] = self.deposits.length;
96 		if(sum > 0) {
97 			require(self.splits[splitIndex].to.call.gas(GASLIMIT).value(sum)());
98 			SplitTransfer(self.splits[splitIndex].to, sum, this.balance);
99 		}
100 	}
101 
102 	function claim(CSCStorage storage self)  internal {
103 		return claimFor(self, msg.sender);
104 	}
105 
106 	function getClaimableBalanceFor(CSCStorage storage self, address user) internal view returns (uint balance) {
107 		uint splitIndex = self.userSplit[user];
108 		uint lastClaimIndex = self.lastUserClaim[user];
109 		uint unclaimed = 0;
110 		if(self.splits[splitIndex].to == user) {
111 			for(uint depositIndex = lastClaimIndex; depositIndex < self.deposits.length; depositIndex++) {
112 				uint value = self.deposits[depositIndex] * self.splits[splitIndex].ppm / MILLION;
113 				unclaimed += value;
114 			}
115 		}
116 		return unclaimed;
117 	}
118 
119 	function getClaimableBalance(CSCStorage storage self)  internal view returns (uint balance) {
120 		return getClaimableBalanceFor(self, msg.sender);
121 	}
122 
123 	function transfer(CSCStorage storage self, address to, uint ppm) internal {
124 		require(getClaimableBalanceFor(self, msg.sender) == 0.0);
125 		require(getClaimableBalanceFor(self, to) == 0.0);
126 		require(ppm > 0);
127 		// neither user can have a pending balance to use transfer
128 		uint splitIndex = self.userSplit[msg.sender];
129 		if(splitIndex > 0 && self.splits[splitIndex].to == msg.sender && self.splits[splitIndex].ppm >= ppm) {
130 			self.splits[splitIndex].ppm -= ppm;
131 			addSplit(self, Split({to: to, ppm: ppm}));
132 		}
133 	}
134 
135 	function pay(CSCStorage storage self) internal {
136 		if(self.isClaimable) {
137 			self.deposits.push(msg.value);
138 		} else {
139 			payAll(self);
140 		}
141 	}
142 }
143 contract ClaimableSplitCoin {
144 
145 	using CSCLib for CSCLib.CSCStorage;
146 
147 	CSCLib.CSCStorage csclib;
148 
149 	function ClaimableSplitCoin(address[] members, uint[] ppms, address refer, bool claimable) public {
150 		csclib.isClaimable = claimable;
151 		csclib.dev_fee = 2500;
152 		csclib.developer = 0xaB48Dd4b814EBcb4e358923bd719Cd5cd356eA16;
153 		csclib.refer_fee = 250;
154 		csclib.init(members, ppms, refer);
155 	}
156 
157 	function () public payable {
158 		csclib.pay();
159 	}
160 
161 	function developer() public view returns(address) {
162 		return csclib.developer;
163 	}
164 
165 	function getSplitCount() public view returns (uint count) {
166 		return csclib.getSplitCount();
167 	}
168 
169 	function splits(uint index) public view returns (address to, uint ppm) {
170 		return (csclib.splits[index].to, csclib.splits[index].ppm);
171 	}
172 
173 	function isClaimable() public view returns (bool) {
174 		return csclib.isClaimable;
175 	}
176 
177 	event SplitTransfer(address to, uint amount, uint balance);
178 
179 	function claimFor(address user) public {
180 		csclib.claimFor(user);
181 	}
182 
183 	function claim() public {
184 		csclib.claimFor(msg.sender);
185 	}
186 
187 	function getClaimableBalanceFor(address user) public view returns (uint balance) {
188 		return csclib.getClaimableBalanceFor(user);
189 	}
190 
191 	function getClaimableBalance() public view returns (uint balance) {
192 		return csclib.getClaimableBalanceFor(msg.sender);
193 	}
194 
195 	function transfer(address to, uint ppm) public {
196 		csclib.transfer(to, ppm);
197 	}
198 }
199 contract SplitCoinFactory {
200   mapping(address => address[]) public contracts;
201   mapping(address => uint) public referralContracts;
202   mapping(address => address) public referredBy;
203   mapping(address => address[]) public referrals;
204   address[] public deployed;
205   event Deployed (
206     address _deployed
207   );
208 
209 
210   function make(address[] users, uint[] ppms, address refer, bool claimable) public returns (address) {
211     address referContract = referredBy[msg.sender];
212     if(refer != 0x0 && referContract == 0x0 && contracts[refer].length > 0 ) {
213       uint referContractIndex = referralContracts[refer] - 1;
214       if(referContractIndex >= 0 && refer != msg.sender) {
215         referContract = contracts[refer][referContractIndex];
216         referredBy[msg.sender] = referContract;
217         referrals[refer].push(msg.sender);
218       }
219     }
220     address sc = new ClaimableSplitCoin(users, ppms, referContract, claimable);
221     contracts[msg.sender].push(sc);
222     deployed.push(sc);
223     Deployed(sc);
224     return sc;
225   }
226 
227   function generateReferralAddress(address refer) public returns (address) {
228     uint[] memory ppms = new uint[](1);
229     address[] memory users = new address[](1);
230     ppms[0] = 1000000;
231     users[0] = msg.sender;
232 
233     address referralContract = make(users, ppms, refer, true);
234     if(referralContract != 0x0) {
235       uint index = contracts[msg.sender].length;
236       referralContracts[msg.sender] = index;
237     }
238     return referralContract;
239   }
240 }