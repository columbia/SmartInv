1 pragma solidity ^0.4.24;
2 
3 interface ERC725 {
4     function keyHasPurpose(bytes32 _key, uint256 _purpose) public view returns (bool result);
5 }
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 interface ERC20Basic {
13 	function balanceOf(address who) public constant returns (uint256);
14 }
15 
16 
17 interface ProfileStorage {
18 	function getStake(address identity) public view returns(uint256);
19 }
20 
21 /**
22 * @title Ownable
23 * @dev The Ownable contract has an owner address, and provides basic authorization control
24 * functions, this simplifies the implementation of "user permissions".
25 */
26 contract Ownable {
27     address public owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33     * account.
34     */
35     constructor () public {
36         owner = msg.sender;
37     }
38 
39     /**
40     * @dev Throws if called by any account other than the owner.
41     */
42     modifier onlyOwner() {
43         require(msg.sender == owner, "Only contract owner can call this function");
44         _;
45     }
46 
47     /**
48     * @dev Allows the current owner to transfer control of the contract to a newOwner.
49     * @param newOwner The address to transfer ownership to.
50     */
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0));
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 
57 }
58 
59 contract Voting is Ownable {
60 	mapping(address => bool) public walletApproved;
61 	mapping(address => bool) public walletVoted;
62 
63 	ERC20Basic public tokenContract;
64 	ProfileStorage public profileStorageContract;
65 
66 	uint256 public votingClosingTime;
67 
68 	struct Candidate{
69 		string name;
70 		uint256 votes;
71 	}
72 
73 	Candidate[34] public candidates;
74 
75 	constructor (address tokenContractAddress, address profileStorageContractAddress) public {
76 		tokenContract = ERC20Basic(tokenContractAddress);
77 		profileStorageContract = ProfileStorage(profileStorageContractAddress);
78 
79 		votingClosingTime = 0;
80 
81 		 candidates[0].name = "Air Sourcing";
82 		 candidates[1].name = "Ametlab";
83 		 candidates[2].name = "B2B Section of Slovenian Blockchain Association (SBCA)";
84 		 candidates[3].name = "Beleaf & Co";
85 		 candidates[4].name = "BioGenom 2.0";
86 		 candidates[5].name = "CAM Engineering";
87 		 candidates[6].name = "Dispensa Dei Tipici";
88 		 candidates[7].name = "Fuzzy Factory";
89 		 candidates[8].name = "GSC Platform";
90 		 candidates[9].name = "HydraWarehouse";
91 		candidates[10].name = "Ibis Eteh";
92 		candidates[11].name = "Infotrans";
93 		candidates[12].name = "Intelisale";
94 		candidates[13].name = "Istmos";
95 		candidates[14].name = "Ivy Food Tech";
96 		candidates[15].name = "Journey Foods";
97 		candidates[16].name = "Kakaxi";
98 		candidates[17].name = "L.Co";
99 		candidates[18].name = "LynqWallet";
100 		candidates[19].name = "MedicoHealth AG";
101 		candidates[20].name = "Moku Menehune";
102 		candidates[21].name = "NetSDL";
103 		candidates[22].name = "Orchit";
104 		candidates[23].name = "Phy2Trace";
105 		candidates[24].name = "Procurean";
106 		candidates[25].name = "PsyChain";
107 		candidates[26].name = "RealMeal";
108 		candidates[27].name = "Reterms";
109 		candidates[28].name = "Sensefinity";
110 		candidates[29].name = "Solomon Ears";
111 		candidates[30].name = "Space Invoices";
112 		candidates[31].name = "Step Online";
113 		candidates[32].name = "TMA";
114 		candidates[33].name = "Zemlja&Morje";
115 	}
116 
117 	// Enabling and disabling the voting process
118 	function startVoting() public onlyOwner {
119 		require(votingClosingTime == 0, "Voting already started once!");
120 		votingClosingTime = block.timestamp + 7 days;
121 	}
122 
123 	event WalletApproved(address wallet, address ERC725Address);
124 	event WalletRejected(address wallet, address ERC725Address, string reason);
125 	event WalletVoted(address wallet, string firstChoice, string secondChoice, string thirdChoice);
126 
127 	// Setting and getting voting approval for wallets
128 	function approveMultipleWallets(address[] wallets, address[] ERC725Addresses) public onlyOwner {
129 		require(votingClosingTime == 0, "Voting already started!");
130 		require(wallets.length <= 50, "Cannot approve more than 50 wallets at a time!");
131 		require(wallets.length == ERC725Addresses.length, "Arrays are not the same length!");
132 		uint256 i = 0;
133 		for(i = 0; i < wallets.length && i < 50; i = i + 1) {
134 			walletApproved[wallets[i]] = false;
135 
136 			if (wallets[i] == address(0) && ERC725Addresses[i] == address(0)) {
137 				emit WalletRejected(wallets[i], ERC725Addresses[i], 
138 						"Cannot verify an empty application!");
139 			}
140 			else {
141 				if(ERC725Addresses[i] != address(0)) {
142 					if(profileStorageContract.getStake(ERC725Addresses[i]) >= 10^21) {
143 						walletApproved[ERC725Addresses[i]] = true;
144 						emit WalletApproved(address(0), ERC725Addresses[i]);
145 					}
146 					else {
147 						emit WalletRejected(wallets[i], ERC725Addresses[i], 
148 							"Profile does not have at least 1000 trac at the time of approval!");
149 					}	
150 				}
151 				else {
152 					// Only wallet was submitted 
153 						// -> Verify wallet balance and approve wallet
154 					if(tokenContract.balanceOf(wallets[i]) >= 10^21) {
155 						walletApproved[wallets[i]] = true;
156 						emit WalletApproved(wallets[i], address(0));
157 					}
158 					else {
159 						emit WalletRejected(wallets[i], address(0), 
160 							"Wallet does not have at least 1000 trac at the time of approval!");
161 					}
162 				}
163 			}
164 		}
165 	}
166 	function disapproveMultipleWallets(address[] wallets) public onlyOwner {
167 		require(wallets.length <= 50, "Cannot approve more than 50 wallets at a time!");
168 		uint256 i = 0;
169 		for(i = 0; i < wallets.length && i < 50; i = i + 1) {
170 			walletApproved[wallets[i]] = false;
171 			emit WalletRejected(wallets[i], address(0), "Wallet approval removed!");
172 		}
173 	}
174 	function isWalletApproved(address wallet) public view returns (bool) {
175 		return walletApproved[wallet];
176 	}
177 
178 
179 	function vote(uint256[] candidateIndexes) public {
180 		require(votingClosingTime != 0, "Voting has not yet started!");
181 		require(votingClosingTime >= block.timestamp, "Voting period has expired!");
182 
183 		require(walletApproved[msg.sender] == true, "Sender is not approved and thus cannot vote!");
184 		
185 		require(walletVoted[msg.sender] == false, "Sender already voted!");
186 
187 		require(candidateIndexes.length == 3, "Must vote for 3 candidates!");
188 
189 		require(candidateIndexes[0] != candidateIndexes[1], "Cannot cast multiple votes for the same person!");
190 		require(candidateIndexes[1] != candidateIndexes[2], "Cannot cast multiple votes for the same person!");
191 		require(candidateIndexes[2] != candidateIndexes[0], "Cannot cast multiple votes for the same person!");
192 
193 		require(candidateIndexes[0] >= 0 && candidateIndexes[0] < candidates.length, "The selected candidate does not exist!");
194 		require(candidateIndexes[1] >= 0 && candidateIndexes[1] < candidates.length, "The selected candidate does not exist!");
195 		require(candidateIndexes[2] >= 0 && candidateIndexes[2] < candidates.length, "The selected candidate does not exist!");
196 
197 		walletVoted[msg.sender] = true;
198 		emit WalletVoted(msg.sender, candidates[candidateIndexes[0]].name, candidates[candidateIndexes[1]].name, candidates[candidateIndexes[2]].name);
199 
200 		assert(candidates[candidateIndexes[0]].votes + 3 > candidates[candidateIndexes[0]].votes);
201 		candidates[candidateIndexes[0]].votes = candidates[candidateIndexes[0]].votes + 3;		
202 
203 		assert(candidates[candidateIndexes[1]].votes + 2 > candidates[candidateIndexes[1]].votes);
204 		candidates[candidateIndexes[1]].votes = candidates[candidateIndexes[1]].votes + 2;		
205 	
206 		assert(candidates[candidateIndexes[2]].votes + 1 > candidates[candidateIndexes[2]].votes);
207 		candidates[candidateIndexes[2]].votes = candidates[candidateIndexes[2]].votes + 1;		
208 	
209 		require(tokenContract.balanceOf(msg.sender) >= 10^21, "Sender does not have at least 1000 TRAC and thus cannot vote!");
210 	}
211 
212 	function voteWithProfile(uint256[] candidateIndexes, address ERC725Address) public {
213 		require(votingClosingTime != 0, "Voting has not yet started!");
214 		require(votingClosingTime >= block.timestamp, "Voting period has expired!");
215 		
216 		require(walletApproved[msg.sender] == true || walletApproved[ERC725Address] == true, "Sender is not approved and thus cannot vote!");
217 
218 		require(walletVoted[msg.sender] == false, "Sender already voted!");
219 		require(walletVoted[ERC725Address] == false, "Profile was already used for voting!");
220 
221 		require(candidateIndexes.length == 3, "Must vote for 3 candidates!");
222 
223 		require(candidateIndexes[0] != candidateIndexes[1], "Cannot cast multiple votes for the same person!");
224 		require(candidateIndexes[1] != candidateIndexes[2], "Cannot cast multiple votes for the same person!");
225 		require(candidateIndexes[2] != candidateIndexes[0], "Cannot cast multiple votes for the same person!");
226 
227 		require(candidateIndexes[0] >= 0 && candidateIndexes[0] < candidates.length, "The selected candidate does not exist!");
228 		require(candidateIndexes[1] >= 0 && candidateIndexes[1] < candidates.length, "The selected candidate does not exist!");
229 		require(candidateIndexes[2] >= 0 && candidateIndexes[2] < candidates.length, "The selected candidate does not exist!");
230 
231 		walletVoted[msg.sender] = true;
232 		walletVoted[ERC725Address] = true;
233 		emit WalletVoted(msg.sender, candidates[candidateIndexes[0]].name, candidates[candidateIndexes[1]].name, candidates[candidateIndexes[2]].name);
234 		
235 		assert(candidates[candidateIndexes[0]].votes + 3 > candidates[candidateIndexes[0]].votes);
236 		candidates[candidateIndexes[0]].votes = candidates[candidateIndexes[0]].votes + 3;		
237 
238 		assert(candidates[candidateIndexes[1]].votes + 2 > candidates[candidateIndexes[1]].votes);
239 		candidates[candidateIndexes[1]].votes = candidates[candidateIndexes[1]].votes + 2;		
240 	
241 		assert(candidates[candidateIndexes[2]].votes + 1 > candidates[candidateIndexes[2]].votes);
242 		candidates[candidateIndexes[2]].votes = candidates[candidateIndexes[2]].votes + 1;		
243 
244 		require(ERC725(ERC725Address).keyHasPurpose(keccak256(abi.encodePacked(msg.sender)), 2), 
245 			"Sender is not the management wallet for this ERC725 identity!");
246 			
247 		require(tokenContract.balanceOf(msg.sender) >= 10^21 || profileStorageContract.getStake(ERC725Address) >= 10^21,
248 		    "Neither the sender nor the submitted profile have at least 1000 TRAC and thus cannot vote!");
249 	}
250 }