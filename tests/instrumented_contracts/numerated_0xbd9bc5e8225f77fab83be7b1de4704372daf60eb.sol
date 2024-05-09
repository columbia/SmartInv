1 /*
2     @MyJobBot
3 */
4 
5 pragma solidity ^ 0.5.12;
6 pragma experimental ABIEncoderV2;
7 
8 
9 contract Owned {
10     address public owner;
11     address public newOwner;
12     address public oracul;
13     uint idleTime = 7776000; // 90 days
14     uint lastTxTime;
15     
16 
17 
18     event OwnershipTransferred(address indexed _from, address indexed _to);
19     event OraculChanged(address indexed _oracul);
20 
21     constructor() public {
22         owner = 0x95B719Df33A6b4c2a897CAa156BFCFf4d8564161;
23         oracul = msg.sender;
24         lastTxTime = now;
25     }
26 
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31     modifier onlyOracul {
32         require(msg.sender == oracul);
33         _;
34     }
35 
36     function transferOwnership(address _newOwner) public onlyOwner {
37         newOwner = _newOwner;
38     }
39 
40     function acceptOwnership() public {
41         require(msg.sender == newOwner);
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44         newOwner = address(0);
45     }
46 
47     function setOracul(address _newOracul) public onlyOwner {
48         oracul = _newOracul;
49         emit OraculChanged(_newOracul);
50     }
51 
52     function canSuicide() public view returns(bool) {
53         if (now - lastTxTime <  idleTime) {
54             return false;
55         } else {
56             return true;
57         }
58     }
59 
60     function suicideContract() public onlyOwner {
61         if (now - lastTxTime < idleTime) {
62             revert();
63         } else {
64             selfdestruct(msg.sender);
65         }
66     }
67 }
68 
69 
70 
71 contract Verifier is Owned {
72     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name,string version)"));
73     bytes32 private constant CHECK_TYPEHASH = keccak256(abi.encodePacked("Check(address user,uint256 amount,uint256 time)"));
74 
75     bytes32 private constant DOMAIN_SEPARATOR = keccak256(abi.encode(
76         EIP712_DOMAIN_TYPEHASH,
77         keccak256("AddTrade"),
78         keccak256("1")
79     ));
80     
81     struct Check {
82         address user;
83         uint256 amount;
84         uint256 time;
85     }
86 
87     function hashCheck(Check memory _check) private pure returns (bytes32){
88         return keccak256(abi.encodePacked(
89             "\x19\x01",
90             DOMAIN_SEPARATOR,
91             keccak256(abi.encode(
92                 CHECK_TYPEHASH,
93                 _check.user,
94                 _check.amount,
95                 _check.time
96             ))
97         ));
98     }
99     
100     function verify(Check memory check, uint8 sigV, bytes32 sigR, bytes32 sigS) public view returns (bool) {
101         return oracul == ecrecover(hashCheck(check), sigV, sigR, sigS);
102     }
103 
104     function verifyCheck(address user, uint256 amount, uint256 time, uint8 sigV, bytes32 sigR, bytes32 sigS)  public view returns (bool) {
105         Check memory check = Check({user: user, amount: amount, time: time});
106 
107         return oracul == ecrecover(hashCheck(check), sigV, sigR, sigS);
108     }
109 }
110 
111 contract Verifier2 is Owned {
112     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name,string version)"));
113     bytes32 private constant CHECK_TYPEHASH = keccak256(abi.encodePacked("Access(address user)"));
114 
115     bytes32 private constant DOMAIN_SEPARATOR = keccak256(abi.encode(
116         EIP712_DOMAIN_TYPEHASH,
117         keccak256("AddTrade"),
118         keccak256("1")
119     ));
120     
121     struct Access {
122         address user;
123     }
124 
125     function hashCheck(Access memory _check) private pure returns (bytes32){
126         return keccak256(abi.encodePacked(
127             "\x19\x01",
128             DOMAIN_SEPARATOR,
129             keccak256(abi.encode(
130                 CHECK_TYPEHASH,
131                 _check.user
132             ))
133         ));
134     }
135 
136     function verifyAccess(address user, uint8 sigV, bytes32 sigR, bytes32 sigS)  public view returns (bool) {
137         Access memory access = Access({user: user});
138 
139         return oracul == ecrecover(hashCheck(access), sigV, sigR, sigS);
140     }
141 }
142 
143 
144 contract MyJobBot is Verifier, Verifier2 {
145     // Init
146     uint public adminBalance;
147     uint public proposalPrice;
148     address[] public allProposals;
149     address[] public allCashOut;
150     struct ProposalObject {
151         uint amount;
152         uint time;
153     }
154     mapping(address => uint) cashOutRecords;
155     mapping(address => ProposalObject) proposalRecords;
156     mapping(address => uint) penaltyRecords;
157     constructor() public {
158         proposalPrice = 78000000000000000;
159     }
160 
161     // Events
162     event NewProposal(address indexed user, uint indexed amount);
163     event CashOut(address indexed user, uint indexed amount);
164     event Penalty(address indexed user, uint indexed amount);
165 
166 
167     // Getters
168     function getCashOut(address _user) public view returns(uint) {
169         return cashOutRecords[_user];
170     }
171 
172     function getProposal(address _user) public view returns(ProposalObject memory) {
173         return proposalRecords[_user];
174     }
175 
176     function getPenalty(address _user) public view returns(uint) {
177         return penaltyRecords[_user];
178     }
179     
180     // Functions
181     function newProposal(address user, uint8 sigV, bytes32 sigR, bytes32 sigS) public payable {
182         require(verifyAccess(user, sigV, sigR, sigS) == true);
183         require(msg.sender == user);
184         require(msg.value >= proposalPrice);
185         require (proposalRecords[msg.sender].time == 0);
186 
187         adminBalance += msg.value / 100 * 45;
188         
189         proposalRecords[msg.sender] = ProposalObject({amount: msg.value - (msg.value / 100 * 45), time: now});
190         allProposals.push(msg.sender);
191         lastTxTime = now;
192         emit NewProposal(msg.sender, msg.value);
193     }
194 
195     function cashOut(address user, uint256 amount, uint256 time, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
196         require(verifyCheck(user, amount, time, sigV, sigR, sigS) == true);
197         require(msg.sender == user);
198         require(time > cashOutRecords[msg.sender]);
199         require (amount + adminBalance <= address(this).balance);
200 
201         msg.sender.transfer(amount);
202         cashOutRecords[msg.sender] = time;
203         allCashOut.push(msg.sender);
204         lastTxTime = now;
205         emit CashOut(msg.sender, amount);
206     }
207 
208     function penalty() public payable {
209         require(msg.value >= proposalPrice);
210         adminBalance += msg.value;
211         penaltyRecords[msg.sender] = now;
212         emit Penalty(msg.sender, msg.value);
213     }
214 
215     function cashoutAdmin() public onlyOwner {
216         msg.sender.transfer(adminBalance);
217         adminBalance = 0;
218     }
219 
220     function setProposalPrice(uint _newProposalPrice) public onlyOracul {
221         proposalPrice = _newProposalPrice;
222     }
223 
224     // ==================== Fallback!
225     function() external payable {
226         if (msg.value == 1000000000) {
227             cashoutAdmin();
228             return;
229         }
230         adminBalance += msg.value;
231     }
232 }