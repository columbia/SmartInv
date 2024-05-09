1 pragma solidity ^0.4.25;
2 
3 interface IERC20 {
4   function transfer(address _to, uint256 _amount) external returns (bool success);
5   function transferFrom(address _from, address _to, uint256 _amount) external returns (bool success);
6   function balanceOf(address _owner) constant external returns (uint256 balance);
7   function approve(address _spender, uint256 _amount) external returns (bool success);
8   function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
9   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) external returns (bool success);
10   function totalSupply() external constant returns (uint);
11 }
12 
13 interface IPrizeCalculator {
14     function calculatePrizeAmount(uint _predictionTotalTokens, uint _winOutputTotalTokens, uint _forecastTokens)
15         pure
16         external
17         returns (uint);
18 }
19 
20 contract Owned {
21     address public owner;
22     address public executor;
23     address public superOwner;
24   
25     event OwnershipTransferred(address indexed _from, address indexed _to);
26 
27     constructor() public {
28         superOwner = msg.sender;
29         owner = msg.sender;
30         executor = msg.sender;
31     }
32 
33     modifier onlyOwner {
34         require(msg.sender == owner, "User is not owner");
35         _;
36     }
37 
38     modifier onlySuperOwner {
39         require(msg.sender == superOwner, "User is not owner");
40         _;
41     }
42 
43     modifier onlyOwnerOrSuperOwner {
44         require(msg.sender == owner || msg.sender == superOwner, "User is not owner");
45         _;
46     }
47 
48     modifier onlyAllowed {
49         require(msg.sender == owner || msg.sender == executor || msg.sender == superOwner, "Not allowed");
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwnerOrSuperOwner {
54         emit OwnershipTransferred(owner, _newOwner);
55         owner = _newOwner;
56     }
57 
58     function transferSuperOwnership(address _newOwner) public onlySuperOwner {
59         emit OwnershipTransferred(superOwner, _newOwner);
60         superOwner = _newOwner;
61     }
62 
63     function transferExecutorOwnership(address _newExecutor) public onlyOwnerOrSuperOwner {
64         emit OwnershipTransferred(executor, _newExecutor);
65         executor = _newExecutor;
66     }
67 }
68 
69 contract Pools is Owned {
70     using SafeMath for uint;  
71 
72     event Initialize(address _token);
73     event PoolAdded(bytes32 _id);
74     event PoolDestinationUpdated(bytes32 _id);
75     event ContributionAdded(bytes32 _poolId, bytes32 _contributionId);
76     event PoolStatusChange(bytes32 _poolId, PoolStatus _oldStatus, PoolStatus _newStatus);
77     event Paidout(bytes32 _poolId, bytes32 _contributionId);
78     event Withdraw(uint _amount);
79     
80     struct Pool {  
81         uint contributionStartUtc;
82         uint contributionEndUtc;
83         address destination;
84         PoolStatus status;
85         uint amountLimit;
86         uint amountCollected;
87         uint amountDistributing;
88         uint paidout;
89         address prizeCalculator;
90         mapping(bytes32 => Contribution) contributions;
91     }
92     
93     struct Contribution {  
94         address owner;
95         uint amount;
96         uint paidout;
97     }
98 
99     struct ContributionIndex {    
100         bytes32 poolId;
101         bytes32 contributionId;
102     }
103     
104     enum PoolStatus {
105         NotSet,       // 0
106         Active,       // 1
107         Distributing, // 2
108         Funding,       // 3 
109         Paused,       // 4
110         Canceled      // 5 
111     }  
112 
113     uint8 public constant version = 1;
114     bool public paused = true;
115     address public token;
116     uint public totalPools;
117     
118     mapping(bytes32 => Pool) public pools;
119     mapping(address => ContributionIndex[]) public walletPools;
120 
121     modifier contractNotPaused() {
122         require(paused == false, "Contract is paused");
123         _;
124     }
125 
126     modifier senderIsToken() {
127         require(msg.sender == address(token));
128         _;
129     }
130 
131     function initialize(address _token) external onlyOwnerOrSuperOwner {
132         token = _token;
133         paused = false;
134         emit Initialize(_token);
135     }
136 
137     function addPool(bytes32 _id, 
138             address _destination, 
139             uint _contributionStartUtc, 
140             uint _contributionEndUtc, 
141             uint _amountLimit, 
142             address _prizeCalculator) 
143         external 
144         onlyOwnerOrSuperOwner 
145         contractNotPaused {
146         
147         if (pools[_id].status == PoolStatus.NotSet) { // do not increase if update
148             totalPools++;
149         } 
150         
151         pools[_id].contributionStartUtc = _contributionStartUtc;
152         pools[_id].contributionEndUtc = _contributionEndUtc;
153         pools[_id].destination = _destination;
154         pools[_id].status = PoolStatus.Active;
155         pools[_id].amountLimit = _amountLimit;
156         pools[_id].prizeCalculator = _prizeCalculator;
157         
158         emit PoolAdded(_id);
159     }
160 
161     function updateDestination(bytes32 _id, 
162             address _destination) 
163         external 
164         onlyOwnerOrSuperOwner 
165         contractNotPaused {
166 
167         pools[_id].destination = _destination;
168 
169         emit PoolDestinationUpdated(_id);
170     }
171     
172     function setPoolStatus(bytes32 _poolId, PoolStatus _status) public onlyOwnerOrSuperOwner {
173         require(pools[_poolId].status != PoolStatus.NotSet, "pool should be initialized");
174         emit PoolStatusChange(_poolId,pools[_poolId].status, _status);
175         pools[_poolId].status = _status;
176     }
177     
178     // This method will be called for returning money when canceled or set everyone to take rewards by formula
179     function setPoolAmountDistributing(bytes32 _poolId, PoolStatus _poolStatus, uint _amountDistributing) external onlyOwnerOrSuperOwner {
180         setPoolStatus(_poolId, _poolStatus);
181         pools[_poolId].amountDistributing = _amountDistributing;
182     }
183 
184     /// Called by token contract after Approval: this.TokenInstance.methods.approveAndCall()
185     // _data = poolId(32),contributionId(32)
186     function receiveApproval(address _from, uint _amountOfTokens, address _token, bytes _data) 
187             external 
188             senderIsToken
189             contractNotPaused {    
190         require(_amountOfTokens > 0, "amount should be > 0");
191         require(_from != address(0), "not valid from");
192         require(_data.length == 64, "not valid _data length");
193       
194         bytes32 poolIdString = bytesToFixedBytes32(_data,0);
195         bytes32 contributionIdString = bytesToFixedBytes32(_data,32);
196         
197         // Validate pool and Contribution
198         require(pools[poolIdString].status == PoolStatus.Active, "Status should be active");
199         require(pools[poolIdString].contributionStartUtc < now, "Contribution is not started");    
200         require(pools[poolIdString].contributionEndUtc > now, "Contribution is ended"); 
201         require(pools[poolIdString].contributions[contributionIdString].amount == 0, 'Contribution duplicated');
202         require(pools[poolIdString].amountLimit == 0 ||
203                 pools[poolIdString].amountLimit >= pools[poolIdString].amountCollected.add(_amountOfTokens), "Contribution limit reached"); 
204         
205         // Transfer tokens from sender to this contract
206         require(IERC20(_token).transferFrom(_from, address(this), _amountOfTokens), "Tokens transfer failed.");
207 
208         walletPools[_from].push(ContributionIndex(poolIdString, contributionIdString));
209         pools[poolIdString].amountCollected = pools[poolIdString].amountCollected.add(_amountOfTokens); 
210         pools[poolIdString].contributions[contributionIdString].owner = _from;
211         pools[poolIdString].contributions[contributionIdString].amount = _amountOfTokens;
212 
213         emit ContributionAdded(poolIdString, contributionIdString);
214     }
215     
216     function transferToDestination(bytes32 _poolId) external onlyOwnerOrSuperOwner {
217         assert(IERC20(token).transfer(pools[_poolId].destination, pools[_poolId].amountCollected));
218         setPoolStatus(_poolId,PoolStatus.Funding);
219     }
220     
221     function payout(bytes32 _poolId, bytes32 _contributionId) public contractNotPaused {
222         require(pools[_poolId].status == PoolStatus.Distributing, "Pool should be Distributing");
223         require(pools[_poolId].amountDistributing > pools[_poolId].paidout, "Pool should be not empty");
224         
225         Contribution storage con = pools[_poolId].contributions[_contributionId];
226         require(con.paidout == 0, "Contribution already paidout");
227         
228         IPrizeCalculator calculator = IPrizeCalculator(pools[_poolId].prizeCalculator);
229     
230         uint winAmount = calculator.calculatePrizeAmount(
231             pools[_poolId].amountDistributing,
232             pools[_poolId].amountCollected,  
233             con.amount
234         );
235       
236         assert(winAmount > 0);
237         con.paidout = winAmount;
238         pools[_poolId].paidout = pools[_poolId].paidout.add(winAmount);
239         assert(IERC20(token).transfer(con.owner, winAmount));
240         emit Paidout(_poolId, _contributionId);
241     }
242 
243     function refund(bytes32 _poolId, bytes32 _contributionId) public contractNotPaused {
244         require(pools[_poolId].status == PoolStatus.Canceled, "Pool should be canceled");
245         require(pools[_poolId].amountDistributing > pools[_poolId].paidout, "Pool should be not empty");
246         
247         Contribution storage con = pools[_poolId].contributions[_contributionId];
248         require(con.paidout == 0, "Contribution already paidout");        
249         require(con.amount > 0, "Contribution not valid");   
250         require(con.owner != address(0), "Owner not valid"); 
251 
252         con.paidout = con.amount;
253         pools[_poolId].paidout = pools[_poolId].paidout.add(con.amount);
254         assert(IERC20(token).transfer(con.owner, con.amount));
255 
256         emit Paidout(_poolId, _contributionId);
257     }
258 
259     //////////
260     // Views
261     //////////
262     function getContribution(bytes32 _poolId, bytes32 _contributionId) public view returns(address, uint, uint) {
263         return (pools[_poolId].contributions[_contributionId].owner,
264             pools[_poolId].contributions[_contributionId].amount,
265             pools[_poolId].contributions[_contributionId].paidout);
266     }
267 
268     // ////////
269     // Safety Methods
270     // ////////
271     function () public payable {
272         require(false);
273     }
274 
275     function withdrawETH() external onlyOwnerOrSuperOwner {
276         uint balance = address(this).balance;
277         owner.transfer(balance);
278         emit Withdraw(balance);
279     }
280 
281     function withdrawTokens(uint _amount, address _token) external onlyOwnerOrSuperOwner {
282         assert(IERC20(_token).transfer(owner, _amount));
283         emit Withdraw(_amount);
284     }
285 
286     function pause(bool _paused) external onlyOwnerOrSuperOwner {
287         paused = _paused;
288     }
289 
290     function bytesToFixedBytes32(bytes memory b, uint offset) internal pure returns (bytes32) {
291         bytes32 out;
292 
293         for (uint i = 0; i < 32; i++) {
294             out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
295         }
296         return out;
297     }
298 }
299 
300 library SafeMath {
301     function add(uint a, uint b) internal pure returns (uint c) {
302         c = a + b;
303         require(c >= a);
304     }
305     function sub(uint a, uint b) internal pure returns (uint c) {
306         require(b <= a);
307         c = a - b;
308     }
309     function mul(uint a, uint b) internal pure returns (uint c) {
310         c = a * b;
311         require(a == 0 || c / a == b);
312     }
313     function div(uint a, uint b) internal pure returns (uint c) {
314         require(b > 0);
315         c = a / b;
316     }
317 }