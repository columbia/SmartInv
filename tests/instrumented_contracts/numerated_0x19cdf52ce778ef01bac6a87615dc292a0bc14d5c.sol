1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 library SafeMath {
5 
6   // We use `pure` bbecause it promises that the value for the function depends ONLY
7   // on the function arguments
8     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
9         uint256 c = a * b;
10         require(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a);
27         return c;
28     }
29 }
30 
31 interface RTCoinInterface {
32     
33 
34     /** Functions - ERC20 */
35     function transfer(address _recipient, uint256 _amount) external returns (bool);
36 
37     function transferFrom(address _owner, address _recipient, uint256 _amount) external returns (bool);
38 
39     function approve(address _spender, uint256 _amount) external returns (bool approved);
40 
41     /** Getters - ERC20 */
42     function totalSupply() external view returns (uint256);
43 
44     function balanceOf(address _holder) external view returns (uint256);
45 
46     function allowance(address _owner, address _spender) external view returns (uint256);
47 
48     /** Getters - Custom */
49     function mint(address _recipient, uint256 _amount) external returns (bool);
50 
51     function stakeContractAddress() external view returns (address);
52 
53     function mergedMinerValidatorAddress() external view returns (address);
54     
55     /** Functions - Custom */
56     function freezeTransfers() external returns (bool);
57 
58     function thawTransfers() external returns (bool);
59 }
60 
61 /// @title Merged Miner Validator allows people who mine mainnet Ethereum blocks to also mint RTC
62 /// @author Postables, RTrade Technologies Ltd
63 /// @notice Version 1, future versions will require a non-interactive block submissinon method
64 /// @dev We able V5 for safety features, see https://solidity.readthedocs.io/en/v0.4.24/security-considerations.html#take-warnings-seriously
65 contract MergedMinerValidator {
66 
67     using SafeMath for uint256;
68     
69     // 0.5
70     uint256 constant public SUBMISSIONREWARD = 500000000000000000;
71     // 0.3
72     uint256 constant public BLOCKREWARD = 300000000000000000;
73     string  constant public VERSION = "production";
74     address constant public TOKENADDRESS = 0xecc043b92834c1ebDE65F2181B59597a6588D616;
75     RTCoinInterface constant public RTI = RTCoinInterface(TOKENADDRESS);
76     
77     address public tokenAddress;
78     address public admin;
79     uint256 public lastBlockSet;
80 
81     enum BlockStateEnum { nil, submitted, claimed }
82 
83     struct Blocks {
84         uint256 number;
85         address coinbase;
86         BlockStateEnum state;
87     }
88 
89     mapping (uint256 => Blocks) public blocks;
90     mapping (uint256 => bytes) public hashedBlocks;
91     event BlockInformationSubmitted(address indexed _coinbase, uint256 indexed _blockNumber, address _submitter);
92     event MergedMinedRewardClaimed(address indexed _claimer, uint256[] indexed _blockNumbers, uint256 _totalReward);
93 
94     modifier submittedBlock(uint256 _blockNum) {
95         require(blocks[_blockNum].state == BlockStateEnum.submitted, "block state must be submitted");
96         _;
97 
98     }
99 
100     modifier nonSubmittedBlock(uint256 _blockNum) {
101         require(blocks[_blockNum].state == BlockStateEnum.nil, "block state must be empty");
102         _;
103     }
104 
105     modifier isCoinbase(uint256 _blockNumber) {
106         require(msg.sender == blocks[_blockNumber].coinbase, "sender must be coinbase");
107         _;
108     }
109 
110     modifier canMint() {
111         require(RTI.mergedMinerValidatorAddress() == address(this), "merged miner contract on rtc token must be set to this contract");
112         _;
113     }
114 
115     modifier notCurrentSetBlock(uint256 _blockNumber) {
116         require(_blockNumber > lastBlockSet, "unable to submit information for already submitted block");
117         _;
118     }
119 
120     modifier onlyAdmin() {
121         require(msg.sender == admin, "only an admin can invoke this function");
122         _;
123     }
124 
125     modifier tokenAddressNotSet() {
126         require(tokenAddress == address(0), "token address must not be set");
127         _;
128     }
129 
130     constructor(address _admin) public {
131         admin = _admin;
132         Blocks memory b = Blocks({
133             number: block.number,
134             coinbase: block.coinbase,
135             state: BlockStateEnum.submitted
136         });
137         lastBlockSet = block.number;
138         blocks[block.number] = b;
139         // we use address(0) and don't mint any tokens, since "we are submitting the information" 
140         emit BlockInformationSubmitted(block.coinbase, block.number, address(0));
141     }
142 
143     /** @notice Used to submit block hash, and block miner information for the current block
144         * @dev Future iterations will avoid this process entirely, and use RLP encoded block headers to parse the data.
145      */
146     function submitBlock() public nonSubmittedBlock(block.number) notCurrentSetBlock(block.number) returns (bool) {
147         Blocks memory b = Blocks({
148             number: block.number,
149             coinbase: block.coinbase,
150             state: BlockStateEnum.submitted
151         });
152         lastBlockSet = block.number;
153         blocks[block.number] = b;
154         // lets not do a storage lookup so we can avoid SSLOAD gas usage
155         emit BlockInformationSubmitted(block.coinbase, block.number, msg.sender);
156         require(RTI.mint(msg.sender, SUBMISSIONREWARD), "failed to transfer reward to block submitter");
157         return true;
158     }
159     
160 
161     /** @notice Used by a miner to claim their merged mined RTC
162         * @param _blockNumber The block number of the block that the person mined
163      */
164     function claimReward(uint256 _blockNumber) 
165         internal
166         isCoinbase(_blockNumber) 
167         submittedBlock(_blockNumber)
168         returns (uint256) 
169     {
170         // mark the reward as claimed
171         blocks[_blockNumber].state = BlockStateEnum.claimed;
172         return BLOCKREWARD;
173     }
174 
175     /** @notice Used by a miner to bulk claim their merged mined RTC
176         * @dev To prevent expensive looping, we throttle to 20 withdrawals at once
177         * @param _blockNumbers Contains the block numbers for which they want to claim
178      */
179     function bulkClaimReward(uint256[] _blockNumbers) external canMint returns (bool) {
180         require(_blockNumbers.length <= 20, "can only claim up to 20 rewards at once");
181         uint256 totalMint;
182         for (uint256 i = 0; i < _blockNumbers.length; i++) {
183             // update their total amount minted
184             totalMint = totalMint.add(claimReward(_blockNumbers[i]));
185         }
186         emit MergedMinedRewardClaimed(msg.sender, _blockNumbers, totalMint);
187         // make sure more than 0 is being claimed
188         require(totalMint > 0, "total coins to mint must be greater than 0");
189         require(RTI.mint(msg.sender, totalMint), "unable to mint tokens");
190         return true;
191     }
192 
193     /** @notice Used to destroy the contract
194      */
195     function goodNightSweetPrince() public onlyAdmin returns (bool) {
196         selfdestruct(msg.sender);
197         return true;
198     }
199 
200 }