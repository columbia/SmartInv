1 // SPDX-License-Identifier: MIT
2 pragma solidity = 0.7.6;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor () {
24         address msgSender = _msgSender();
25         _owner = msgSender;
26         emit OwnershipTransferred(address(0), msgSender);
27     }
28 
29     /**
30      * @dev Returns the address of the current owner.
31      */
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     /**
45      * @dev Leaves the contract without owner. It will not be possible to call
46      * `onlyOwner` functions anymore. Can only be called by the current owner.
47      *
48      * NOTE: Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public virtual onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         emit OwnershipTransferred(_owner, newOwner);
63         _owner = newOwner;
64     }
65 }
66 
67 // In the first version, claimed block nonce / mixDigest IS NOT VERIFIED
68 // This contract assumes that MEV block template producer completely TRUSTS pool operator that received the signed work order.
69 // This contract !DOES NOT VERIFY! that block nonce / mixDigest is valid or that it was broadcasted without delay
70 // In the next version we're planning to introduce trustless approach to verify submited block nonce on-chain(see smartpool) and verify delay in seconds for share submission(using oracles)
71 contract LogOfClaimedMEVBlocks is Ownable {
72     uint256 internal constant FLAG_BLOCK_NONCE_LIMIT = 0x10000000000000000;
73     mapping (address => uint) public timestampOfPossibleExit;
74     mapping (address => uint) public depositedEther;
75 
76     mapping (address => address) public blockSubmissionsOperator;
77     mapping (bytes32 => uint) public claimedBlockNonce;
78 
79     event Deposit(address user, uint amount, uint updatedExitTime);
80     event Withdraw(address user, uint amount);
81     event BlockClaimed(bytes32 blockHeader, bytes32 seedHash, bytes32 target, uint blockNumber, uint blockPayment, address miningPoolAddress, address mevProducerAddress, uint blockNonce, bytes32 mixDigest);
82     event PoolOperatorUpdate(address miningPoolAddress, address oldPoolOperator, address newPoolOperator);
83 
84 
85     // Add another mining pool to mining DAO which will receive signed work orders directly from mev producers
86     function whitelistMiningPool(address miningPoolAddress) onlyOwner external {
87         assert(msg.data.length == 36);
88         // Owner can't update submission operator for already active pool
89         require(blockSubmissionsOperator[miningPoolAddress] == 0x0000000000000000000000000000000000000000);
90         blockSubmissionsOperator[miningPoolAddress] = miningPoolAddress;
91         emit PoolOperatorUpdate(miningPoolAddress, 0x0000000000000000000000000000000000000000, miningPoolAddress);
92     }
93 
94     function setBlockSubmissionsOperator(address newBlockSubmissionsOperator) external {
95         assert(msg.data.length == 36);
96         address oldBlockSubmissionsOperator = blockSubmissionsOperator[msg.sender];
97         // This mining pool was already whitelisted
98         require(oldBlockSubmissionsOperator != 0x0000000000000000000000000000000000000000);
99         blockSubmissionsOperator[msg.sender] = newBlockSubmissionsOperator;
100         emit PoolOperatorUpdate(msg.sender, oldBlockSubmissionsOperator, newBlockSubmissionsOperator);
101     }
102 
103     function depositAndLock(uint depositAmount, uint depositDuration) public payable {
104         require(depositAmount == msg.value);
105         // Enforcing min and max lockup durations
106         require(depositDuration >= 24 * 60 * 60 && depositDuration <= 365 * 24 * 60 * 60);
107         // You can always decrease you lockup time down to 1 day from the time of current block
108         timestampOfPossibleExit[msg.sender] = block.timestamp + depositDuration;
109         if (msg.value > 0) {
110             depositedEther[msg.sender] += msg.value;
111         }
112         emit Deposit(msg.sender, msg.value, block.timestamp + depositDuration);
113     }
114     fallback () external payable {
115         depositAndLock(msg.value, 24 * 60 * 60);
116     }
117 
118 
119     function withdrawEtherInternal(uint etherAmount) internal {
120         require(depositedEther[msg.sender] > 0);
121         // Deposit lockup period is over
122         require(block.timestamp > timestampOfPossibleExit[msg.sender]);
123         if (depositedEther[msg.sender] < etherAmount)
124             etherAmount = depositedEther[msg.sender];
125         depositedEther[msg.sender] -= etherAmount;
126         payable(msg.sender).transfer(etherAmount);
127         emit Withdraw(msg.sender, etherAmount);
128     }
129     function withdrawAll() external {
130         withdrawEtherInternal((uint)(-1));
131     }
132     function withdraw(uint etherAmount) external {
133         withdrawEtherInternal(etherAmount);
134     }
135 
136 
137     function submitClaim(
138         bytes32 blockHeader,
139         bytes32 seedHash,
140         bytes32 target,
141         uint blockNumber,
142         uint blockPayment,
143         address payable miningPoolAddress,
144         address mevProducerAddress,
145         uint8 v,
146         bytes32 r,
147         bytes32 s,
148         uint blockNonce,
149         bytes32 mixDigest
150     ) external {
151         require(msg.sender == blockSubmissionsOperator[miningPoolAddress]);
152         bytes32 hash = keccak256(abi.encodePacked(blockHeader, seedHash, target, blockNumber, blockPayment, miningPoolAddress));
153         if (claimedBlockNonce[hash] == 0 && blockNonce < FLAG_BLOCK_NONCE_LIMIT) {
154             if (ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == mevProducerAddress) {
155                 require(depositedEther[mevProducerAddress] >= blockPayment);
156                 claimedBlockNonce[hash] = FLAG_BLOCK_NONCE_LIMIT + blockNonce;
157                 depositedEther[mevProducerAddress] -= blockPayment;
158                 miningPoolAddress.transfer(blockPayment);
159                 emit BlockClaimed(blockHeader, seedHash, target, blockNumber, blockPayment, miningPoolAddress, mevProducerAddress, blockNonce, mixDigest);
160             }
161         }
162     }
163 
164     function checkValidityOfGetWork(
165         bytes32 blockHeader,
166         bytes32 seedHash,
167         bytes32 target,
168         uint blockNumber,
169         uint blockPayment,
170         address payable miningPoolAddress,
171         address mevProducerAddress,
172         uint8 v,
173         bytes32 r,
174         bytes32 s
175     ) public view returns (bool isWorkSignatureCorrect, uint remainingDuration) {
176         bytes32 hash = keccak256(abi.encodePacked(blockHeader, seedHash, target, blockNumber, blockPayment, miningPoolAddress));
177         if (claimedBlockNonce[hash] == 0) {
178             if (ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == mevProducerAddress) {
179                 isWorkSignatureCorrect = true;
180                 if ((depositedEther[mevProducerAddress] >= blockPayment) && (timestampOfPossibleExit[mevProducerAddress] > block.timestamp)) {
181                     remainingDuration = timestampOfPossibleExit[mevProducerAddress] - block.timestamp;
182                 }
183             }
184         }
185     }
186 }