1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20 is ERC20Basic {
18     function allowance(address owner, address spender) public view returns (uint256);
19     function transferFrom(address from, address to, uint256 value) public returns (bool);
20     function approve(address spender, uint256 value) public returns (bool);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30     address public owner;
31 
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36     /**
37      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38      * account.
39      */
40     function Ownable() public {
41         owner = msg.sender;
42     }
43 
44     /**
45      * @dev Throws if called by any account other than the owner.
46      */
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     /**
53      * @dev Allows the current owner to transfer control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      */
56     function transferOwnership(address newOwner) public onlyOwner {
57         require(newOwner != address(0));
58         OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60     }
61 
62 }
63 
64 /**
65  * @title Destructible
66  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
67  */
68 contract Destructible is Ownable {
69 
70     function Destructible() public payable { }
71 
72     /**
73      * @dev Transfers the current balance to the owner and terminates the contract.
74      */
75     function destroy() onlyOwner public {
76         selfdestruct(owner);
77     }
78 
79     function destroyAndSend(address _recipient) onlyOwner public {
80         selfdestruct(_recipient);
81     }
82 }
83 
84 contract TrustServiceStorage is Destructible {
85 
86     struct Deal {
87         bytes32 dealHash;
88         address[] addresses;
89     }
90 
91     uint256 dealId = 1;
92 
93     mapping (uint256 => Deal) deals;
94 
95     mapping (uint256 => mapping(address => bool)) signedAddresses;
96 
97     address trust;
98 
99     modifier onlyTrust() {
100         require(msg.sender == trust);
101         _;
102     }
103 
104     function setTrust(address _trust) onlyOwner {
105         trust = _trust;
106     }
107 
108     function getDealId() onlyTrust returns (uint256) {
109         return dealId;
110     }
111 
112     function setDealId(uint256 _dealId) onlyTrust {
113         dealId = _dealId;
114     }
115 
116     function addDeal(uint256 dealId, bytes32 dealHash, address[] addresses) onlyTrust returns (uint256) {
117         deals[dealId] = Deal(dealHash, addresses);
118     }
119 
120     function getDealHash(uint256 dealId) onlyTrust returns (bytes32) {
121         return deals[dealId].dealHash;
122     }
123 
124     function getDealAddrCount(uint256 dealId) onlyTrust returns (uint256) {
125         return deals[dealId].addresses.length;
126     }
127 
128     function getDealAddrAtIndex(uint256 dealId, uint256 index) onlyTrust returns (address)  {
129         return deals[dealId].addresses[index];
130     }
131 
132     function setSigned(uint256 dealId, address _address) onlyTrust {
133         signedAddresses[dealId][_address] = true;
134     }
135 
136     function setUnSigned(uint256 dealId, address _address) onlyTrust {
137         signedAddresses[dealId][_address] = false;
138     }
139 
140     function getSigned(uint256 dealId, address _address) onlyTrust returns (bool) {
141         return signedAddresses[dealId][_address];
142     }
143 }
144 
145 contract TrustService is Destructible {
146 
147     TrustServiceStorage trustStorage;
148 
149     ERC20 public feeToken;
150     uint256 public fee;
151     address public feeSender;
152     address public feeRecipient;
153 
154     event DealSaved(uint256 indexed dealId);
155 
156     function setFee(address _feeToken, address _feeSender, address _feeRecipient, uint256 _fee) public onlyOwner {
157        require(_feeToken != address(0));
158        require(_feeSender != address(0));
159        require(_feeRecipient != address(0));
160        require(_fee > 0);
161        feeToken = ERC20(_feeToken);
162        feeSender = _feeSender;
163        feeRecipient = _feeRecipient;
164        fee = _fee;
165     }
166 
167     function clearFee() public onlyOwner {
168        fee = 0;
169     }
170 
171     function setStorage(address _storageAddress) onlyOwner {
172         trustStorage = TrustServiceStorage(_storageAddress);
173     }
174 
175     function createDeal(
176       bytes32 dealHash,
177       address[] addresses
178     ) public returns (uint256) {
179 
180         require(fee == 0 || feeToken.transferFrom(feeSender, feeRecipient, fee));
181 
182         uint256 dealId = trustStorage.getDealId();
183 
184         trustStorage.addDeal(dealId, dealHash, addresses);
185 
186         DealSaved(dealId);
187 
188         trustStorage.setDealId(dealId + 1);
189 
190         return dealId;
191     }
192 
193     function createAndSignDeal(
194       bytes32 dealHash,
195       address[] addresses)
196     public {
197 
198         uint256 id = createDeal(dealHash, addresses);
199         signDeal(id);
200     }
201 
202     function readDeal(uint256 dealId) public view returns (
203       bytes32 dealHash,
204       address[] addresses,
205       bool[] signed
206     ) {
207         dealHash = trustStorage.getDealHash(dealId);
208 
209         uint256 addrCount = trustStorage.getDealAddrCount(dealId);
210 
211         addresses = new address[](addrCount);
212 
213         signed = new bool[](addrCount);
214 
215         for(uint i = 0; i < addrCount; i ++) {
216             addresses[i] = trustStorage.getDealAddrAtIndex(dealId, i);
217             signed[i] = trustStorage.getSigned(dealId , addresses[i]);
218         }
219     }
220 
221     function signDeal(uint256 dealId) public {
222         trustStorage.setSigned(dealId, msg.sender);
223     }
224 
225     function confirmDeal(uint256 dealId, bytes32 dealHash) public constant returns (bool) {
226         bytes32 hash = trustStorage.getDealHash(dealId);
227 
228         return hash == dealHash;
229     }
230 }