1 pragma solidity ^0.4.17;
2 
3 library CSCLib {
4 
5 	struct Split {
6 		address to;
7 		uint ppm;
8 	}
9 
10 	struct CSCStorage {
11 		mapping(address => uint) lastUserClaim;
12 		uint[] deposits;
13 		bool isClaimable;
14 
15 		address developer;
16 		uint dev_fee;
17 		uint refer_fee;
18 		Split[] splits;
19 		mapping(address => uint) userSplit;
20 	}
21 
22 	event SplitTransfer(address to, uint amount, uint balance);
23 
24 	function init(CSCStorage storage self,  address[] members, uint[] ppms, address refer) internal {
25 		uint shift_amt = self.dev_fee / members.length;
26 		uint remainder = self.dev_fee % members.length * members.length / 10;
27 		uint dev_total = self.dev_fee + remainder;
28 		if(refer != 0x0){
29 			addSplit(self, Split({to: self.developer, ppm: dev_total - self.refer_fee}));
30 			addSplit(self, Split({to: refer, ppm: self.refer_fee}));
31 		} else {
32 			addSplit(self, Split({to: self.developer, ppm: dev_total}));
33 		}
34 
35 		for(uint index = 0; index < members.length; index++) {
36 			addSplit(self, Split({to: members[index], ppm: ppms[index] - shift_amt}));
37 		}
38 	}
39 
40 	function addSplit(CSCStorage storage self, Split newSplit) internal {
41 		require(newSplit.ppm > 0);
42 		uint index = self.userSplit[newSplit.to];
43 		if(index > 0) {
44 			newSplit.ppm += self.splits[index].ppm;
45 			self.splits[index] = newSplit;
46 		} else {
47 			self.userSplit[newSplit.to] = self.splits.length;
48 			self.splits.push(newSplit);
49 		}
50 	}
51 
52 	function payAll(CSCStorage storage self) internal {
53 		for(uint index = 0; index < self.splits.length; index++) {
54 			uint value = (msg.value) * self.splits[index].ppm / 1000000.00;
55 			if(value > 0 ) {
56 				require(self.splits[index].to.call.gas(60000).value(value)());
57 				SplitTransfer(self.splits[index].to, value, this.balance);
58 			}
59 		}
60 	}
61 
62 	function getSplit(CSCStorage storage self, uint index) internal view returns (Split) {
63 		return self.splits[index];
64 	}
65 
66 	function getSplitCount(CSCStorage storage self) internal view returns (uint count) {
67 		return self.splits.length;
68 	}
69 
70 	function claimFor(CSCStorage storage self, address user) internal {
71 		require(self.isClaimable);
72 		uint sum = getClaimableBalanceFor(self, user);
73 		uint splitIndex = self.userSplit[user];
74 		self.lastUserClaim[user] = self.deposits.length;
75 		if(sum > 0) {
76 			require(self.splits[splitIndex].to.call.gas(60000).value(sum)());
77 			SplitTransfer(self.splits[splitIndex].to, sum, this.balance);
78 		}
79 	}
80 
81 	function claim(CSCStorage storage self)  internal {
82 		return claimFor(self, msg.sender);
83 	}
84 
85 	function getClaimableBalanceFor(CSCStorage storage self, address user) internal view returns (uint balance) {
86 		uint splitIndex = self.userSplit[user];
87 		uint lastClaimIndex = self.lastUserClaim[user];
88 		uint unclaimed = 0;
89 		if(self.splits[splitIndex].to == user) {
90 			for(uint depositIndex = lastClaimIndex; depositIndex < self.deposits.length; depositIndex++) {
91 				uint value = self.deposits[depositIndex] * self.splits[splitIndex].ppm / 1000000.00;
92 				unclaimed += value;
93 			}
94 		}
95 		return unclaimed;
96 	}
97 
98 	function getClaimableBalance(CSCStorage storage self)  internal view returns (uint balance) {
99 		return getClaimableBalanceFor(self, msg.sender);
100 	}
101 
102 	function transfer(CSCStorage storage self, address to, uint ppm) internal {
103 		require(getClaimableBalanceFor(self, msg.sender) == 0.0);
104 		require(getClaimableBalanceFor(self, to) == 0.0);
105 		require(ppm > 0);
106 		// neither user can have a pending balance to use transfer
107 		uint splitIndex = self.userSplit[msg.sender];
108 		if(splitIndex > 0 && self.splits[splitIndex].to == msg.sender && self.splits[splitIndex].ppm >= ppm) {
109 			self.lastUserClaim[to] = self.lastUserClaim[msg.sender];
110 			self.splits[splitIndex].ppm -= ppm;
111 			addSplit(self, Split({to: to, ppm: ppm}));
112 		}
113 	}
114 
115 	function pay(CSCStorage storage self) internal {
116 		if(self.isClaimable) {
117 			self.deposits.push(msg.value);
118 		} else {
119 			payAll(self);
120 		}
121 	}
122 }
123 contract ClaimableSplitCoin {
124 
125 	using CSCLib for CSCLib.CSCStorage;
126 
127 	CSCLib.CSCStorage csclib;
128 
129 	function ClaimableSplitCoin(address[] members, uint[] ppms, address refer, bool claimable) public {
130 		csclib.isClaimable = claimable;
131 		csclib.dev_fee = 2500;
132 		csclib.developer = 0xaB48Dd4b814EBcb4e358923bd719Cd5cd356eA16;
133 		csclib.refer_fee = 250;
134 		csclib.init(members, ppms, refer);
135 	}
136 
137 	function () public payable {
138 		csclib.pay();
139 	}
140 
141 	function developer() public view returns(address) {
142 		return csclib.developer;
143 	}
144 
145 	function getSplitCount() public view returns (uint count) {
146 		return csclib.getSplitCount();
147 	}
148 
149 	function splits(uint index) public view returns (address to, uint ppm) {
150 		return (csclib.splits[index].to, csclib.splits[index].ppm);
151 	}
152 
153 	event SplitTransfer(address to, uint amount, uint balance);
154 
155 	function claimFor(address user) public {
156 		csclib.claimFor(user);
157 	}
158 
159 	function claim() public {
160 		csclib.claimFor(msg.sender);
161 	}
162 
163 	function getClaimableBalanceFor(address user) public view returns (uint balance) {
164 		return csclib.getClaimableBalanceFor(user);
165 	}
166 
167 	function getClaimableBalance() public view returns (uint balance) {
168 		return csclib.getClaimableBalanceFor(msg.sender);
169 	}
170 
171 	function transfer(address to, uint ppm) public {
172 		csclib.transfer(to, ppm);
173 	}
174 }
175 contract SplitCoinFactory {
176   mapping(address => address[]) public contracts;
177   mapping(address => uint) public referralContracts;
178   mapping(address => address) public referredBy;
179   mapping(address => address[]) public referrals;
180   address[] public deployed;
181   event Deployed (
182     address _deployed
183   );
184 
185 
186   function make(address[] users, uint[] ppms, address refer, bool claimable) public returns (address) {
187     address referContract = referredBy[msg.sender];
188     if(refer != 0x0 && referContract == 0x0 && contracts[refer].length > 0 ) {
189       uint referContractIndex = referralContracts[refer] - 1;
190       if(referContractIndex >= 0 && refer != msg.sender) {
191         referContract = contracts[refer][referContractIndex];
192         referredBy[msg.sender] = referContract;
193         referrals[refer].push(msg.sender);
194       }
195     }
196     address sc = new ClaimableSplitCoin(users, ppms, referContract, claimable);
197     contracts[msg.sender].push(sc);
198     deployed.push(sc);
199     Deployed(sc);
200     return sc;
201   }
202 
203   function generateReferralAddress(address refer) public returns (address) {
204     uint[] memory ppms = new uint[](1);
205     address[] memory users = new address[](1);
206     ppms[0] = 1000000;
207     users[0] = msg.sender;
208 
209     address referralContract = make(users, ppms, refer, true);
210     if(referralContract != 0x0) {
211       uint index = contracts[msg.sender].length;
212       referralContracts[msg.sender] = index;
213     }
214     return referralContract;
215   }
216 }