1 1  // SPDX-License-Identifier: MIT
2 2 pragma solidity ^0.6.8;
3 3 pragma experimental ABIEncoderV2;
4 4 
5 5 import "./openzeppelin/contracts/access/Ownable.sol";
6 6 import "./umb-network/toolbox/dist/contracts/lib/ValueDecoder.sol";
7 7 import "./interfaces/IStakingBank.sol";
8 8 import "./BaseChain.sol";
9 9 
10 10 contract Chain is BaseChain {
11 11   IStakingBank public immutable stakingBank;
12 12 
13 13   event LogMint(address indexed minter, uint256 blockId, uint256 staked, uint256 power);
14 14   event LogVoter(uint256 indexed blockId, address indexed voter, uint256 vote);
15 15 
16 16   IStakingBank public immutable stakingBank;
17 17 
18 18   constructor(
19 19     address _contractRegistry,
20 20     uint16 _padding,
21 21     uint16 _requiredSignatures
22 22   ) public BaseChain(_contractRegistry, _padding, _requiredSignatures) {
23 23     stakingBank = stakingBankContract();
24 24   }
25 25 
26 26   function submit(
27 27     uint32 _dataTimestamp,
28 28     bytes32 _root,
29 29     bytes32[] memory _keys,
30 30     uint256[] memory _values,
31 31     uint8[] memory _v,
32 32     bytes32[] memory _r,
33 33     bytes32[] memory _s
34 34   ) public { 
35 35     uint32 lastBlockId = getLatestBlockId();
36 36     uint32 dataTimestamp = squashedRoots[lastBlockId].extractTimestamp();
37 37 
38 38     require(dataTimestamp + padding < block.timestamp, "do not spam");
39 39     require(dataTimestamp < _dataTimestamp, "can NOT submit older data");
40 40     require(_keys.length == _values.length, "numbers of keys and values not the same");
41 41 
42 42     bytes memory testimony = abi.encodePacked(_dataTimestamp, _root);
43 43 
44 44     for (uint256 i = 0; i < _keys.length; i++) {
45 45       require(uint224(_values[i]) == _values[i], "FCD overflow");
46 46       fcds[_keys[i]] = FirstClassData(uint224(_values[i]), _dataTimestamp);
47 47       testimony = abi.encodePacked(testimony, _keys[i], _values[i]);
48 48     }
49 49 
50 50     bytes32 affidavit = keccak256(testimony);
51 51     uint256 power = 0;
52 52 
53 53     uint256 staked = stakingBank.totalSupply();
54 54     address prevSigner = address(0x0);
55 55 
56 56     uint256 i = 0;
57 57 
58 58     for (; i < _v.length; i++) {
59 59       address signer = recoverSigner(affidavit, _v[i], _r[i], _s[i]);
60 60       uint256 balance = stakingBank.balanceOf(signer);
61 61 
62 62       require(prevSigner < signer, "validator included more than once");
63 63       prevSigner = signer;
64 64       if (balance == 0) continue;
65 65 
66 66       emit LogVoter(lastBlockId + 1, signer, balance);
67 67       power += balance; 
68 68     }
69 69 
70 70     require(i >= requiredSignatures, "not enough signatures");
71 71 
72 72     squashedRoots[lastBlockId + 1] = _root.makeSquashedRoot(_dataTimestamp);
73 73     blocksCount++;
74 74 
75 75     emit LogMint(msg.sender, lastBlockId + 1, staked, power);
76 76   }
77 77 
78 78   function getLeaderIndex(uint256 _numberOfValidators, uint256 _timestamp) public view returns (uint256) {
79 79     uint32 latestBlockId = getLatestBlockId();
80 80 
81 81     
82 82     uint256 validatorIndex = latestBlockId +
83 83       (_timestamp - squashedRoots[latestBlockId].extractTimestamp()) / (padding + 1);
84 84 
85 85     return uint16(validatorIndex % _numberOfValidators);
86 86   }
87 87 
88 88   function getLeaderAddressAtTime(uint256 _timestamp) public view returns (address) {
89 89     uint256 numberOfValidators = stakingBank.getNumberOfValidators();
90 90 
91 91     if (numberOfValidators == 0) {
92 92       return address(0x0);
93 93     }
94 94 
95 95     uint256 validatorIndex = getLeaderIndex(numberOfValidators, _timestamp);
96 96 
97 97     return stakingBank.addresses(validatorIndex);
98 98   }
99 99 }