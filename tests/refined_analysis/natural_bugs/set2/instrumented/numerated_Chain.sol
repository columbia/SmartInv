1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.8;
3 pragma experimental ABIEncoderV2;
4 
5 import "./openzeppelin/contracts/access/Ownable.sol";
6 import "./umb-network/toolbox/dist/contracts/lib/ValueDecoder.sol";
7 
8 import "./interfaces/IStakingBank.sol";
9 
10 import "./BaseChain.sol";
11 
12 contract Chain is BaseChain {
13   IStakingBank public immutable stakingBank;
14 
15   // ========== EVENTS ========== //
16 
17   event LogMint(address indexed minter, uint256 blockId, uint256 staked, uint256 power);
18   event LogVoter(uint256 indexed blockId, address indexed voter, uint256 vote);
19 
20   // ========== CONSTRUCTOR ========== //
21 
22   constructor(
23     address _contractRegistry,
24     uint16 _padding,
25     uint16 _requiredSignatures
26   ) public BaseChain(_contractRegistry, _padding, _requiredSignatures) {
27     // we not changing SB address that often, so lets save it once, it will save 10% gas
28     stakingBank = stakingBankContract();
29   }
30 
31   // ========== VIEWS ========== //
32 
33   function isForeign() override external pure returns (bool) {
34     return false;
35   }
36 
37   function getName() override external pure returns (bytes32) {
38     return "Chain";
39   }
40 
41   function getStatus() external view returns(
42     uint256 blockNumber,
43     uint16 timePadding,
44     uint32 lastDataTimestamp,
45     uint32 lastBlockId,
46     address nextLeader,
47     uint32 nextBlockId,
48     address[] memory validators,
49     uint256[] memory powers,
50     string[] memory locations,
51     uint256 staked,
52     uint16 minSignatures
53   ) {
54     blockNumber = block.number;
55     timePadding = padding;
56     lastBlockId = getLatestBlockId();
57     lastDataTimestamp = squashedRoots[lastBlockId].extractTimestamp();
58     minSignatures = requiredSignatures;
59 
60     staked = stakingBank.totalSupply();
61     uint256 numberOfValidators = stakingBank.getNumberOfValidators();
62     powers = new uint256[](numberOfValidators);
63     validators = new address[](numberOfValidators);
64     locations = new string[](numberOfValidators);
65 
66     for (uint256 i = 0; i < numberOfValidators; i++) {
67       validators[i] = stakingBank.addresses(i);
68       (, locations[i]) = stakingBank.validators(validators[i]);
69       powers[i] = stakingBank.balanceOf(validators[i]);
70     }
71 
72     nextBlockId = getBlockIdAtTimestamp(block.timestamp + 1);
73 
74     nextLeader = numberOfValidators > 0
75       ? validators[getLeaderIndex(numberOfValidators, block.timestamp + 1)]
76       : address(0);
77   }
78 
79   function getNextLeaderAddress() external view returns (address) {
80     return getLeaderAddressAtTime(block.timestamp + 1);
81   }
82 
83   function getLeaderAddress() external view returns (address) {
84     return getLeaderAddressAtTime(block.timestamp);
85   }
86 
87   // ========== MUTATIVE FUNCTIONS ========== //
88 
89   // solhint-disable-next-line function-max-lines
90   function submit(
91     uint32 _dataTimestamp,
92     bytes32 _root,
93     bytes32[] memory _keys,
94     uint256[] memory _values,
95     uint8[] memory _v,
96     bytes32[] memory _r,
97     bytes32[] memory _s
98   ) public { // it could be external, but for external we got stack too deep
99     uint32 lastBlockId = getLatestBlockId();
100     uint32 dataTimestamp = squashedRoots[lastBlockId].extractTimestamp();
101 
102     require(dataTimestamp + padding < block.timestamp, "do not spam");
103     require(dataTimestamp < _dataTimestamp, "can NOT submit older data");
104     // we can't expect minter will have exactly the same timestamp
105     // but for sure we can demand not to be off by a lot, that's why +3sec
106     // temporary remove this condition, because recently on ropsten we see cases when minter/node
107     // can be even 100sec behind
108     // require(_dataTimestamp <= block.timestamp + 3,
109     //   string(abi.encodePacked("oh, so you can predict the future:", _dataTimestamp - block.timestamp + 48)));
110     require(_keys.length == _values.length, "numbers of keys and values not the same");
111 
112     bytes memory testimony = abi.encodePacked(_dataTimestamp, _root);
113 
114     for (uint256 i = 0; i < _keys.length; i++) {
115       require(uint224(_values[i]) == _values[i], "FCD overflow");
116       fcds[_keys[i]] = FirstClassData(uint224(_values[i]), _dataTimestamp);
117       testimony = abi.encodePacked(testimony, _keys[i], _values[i]);
118     }
119 
120     bytes32 affidavit = keccak256(testimony);
121     uint256 power = 0;
122 
123     uint256 staked = stakingBank.totalSupply();
124     address prevSigner = address(0x0);
125 
126     uint256 i = 0;
127 
128     for (; i < _v.length; i++) {
129       address signer = recoverSigner(affidavit, _v[i], _r[i], _s[i]);
130       uint256 balance = stakingBank.balanceOf(signer);
131 
132       require(prevSigner < signer, "validator included more than once");
133       prevSigner = signer;
134       if (balance == 0) continue;
135 
136       emit LogVoter(lastBlockId + 1, signer, balance);
137       power += balance; // no need for safe math, if we overflow then we will not have enough power
138     }
139 
140     require(i >= requiredSignatures, "not enough signatures");
141     // we turn on power once we have proper DPoS
142     // require(power * 100 / staked >= 66, "not enough power was gathered");
143 
144     squashedRoots[lastBlockId + 1] = _root.makeSquashedRoot(_dataTimestamp);
145     blocksCount++;
146 
147     emit LogMint(msg.sender, lastBlockId + 1, staked, power);
148   }
149 
150   function getLeaderIndex(uint256 _numberOfValidators, uint256 _timestamp) public view returns (uint256) {
151     uint32 latestBlockId = getLatestBlockId();
152 
153     // timePadding + 1 => because padding is a space between blocks, so next round starts on first block after padding
154     uint256 validatorIndex = latestBlockId +
155       (_timestamp - squashedRoots[latestBlockId].extractTimestamp()) / (padding + 1);
156 
157     return uint16(validatorIndex % _numberOfValidators);
158   }
159 
160   // @todo - properly handled non-enabled validators, newly added validators, and validators with low stake
161   function getLeaderAddressAtTime(uint256 _timestamp) public view returns (address) {
162     uint256 numberOfValidators = stakingBank.getNumberOfValidators();
163 
164     if (numberOfValidators == 0) {
165       return address(0x0);
166     }
167 
168     uint256 validatorIndex = getLeaderIndex(numberOfValidators, _timestamp);
169 
170     return stakingBank.addresses(validatorIndex);
171   }
172 }