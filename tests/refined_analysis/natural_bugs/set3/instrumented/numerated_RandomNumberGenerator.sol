1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import "@pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol";
6 import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
7 
8 import "../interfaces/IPotController.sol";
9 
10 /**
11  * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
12  * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
13  */
14 contract RandomNumberGenerator is VRFConsumerBase, Ownable {
15 
16     /* ========== STATE VARIABLES ========== */
17 
18     bytes32 internal keyHash;
19     uint256 internal fee;
20 
21     mapping(address => uint) private _pots;
22     mapping(address => bool) private _availablePot;
23     mapping(bytes32 => address) private _requestIds;
24 
25     /* ========== MODIFIER ========== */
26 
27     modifier onlyPot {
28         require(_availablePot[msg.sender], "RandomNumberConsumer: is not pot contract.");
29         _;
30     }
31 
32     /* ========== EVENTS ========== */
33 
34     event RequestRandomness(
35         bytes32 indexed requestId,
36         bytes32 keyHash,
37         uint256 seed
38     );
39 
40     event RequestRandomnessFulfilled(
41         bytes32 indexed requestId,
42         uint256 randomness
43     );
44 
45 
46     /**
47      * Constructor inherits VRFConsumerBase
48      *
49      * Network: BSC
50      * Chainlink VRF Coordinator address: 0x747973a5A2a4Ae1D3a8fDF5479f1514F65Db9C31
51      * LINK token address:                0x404460C6A5EdE2D891e8297795264fDe62ADBB75
52      * Key Hash: 0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c
53      */
54     constructor(address _vrfCoordinator, address _linkToken)
55     VRFConsumerBase(
56         _vrfCoordinator,
57         _linkToken
58     ) public
59     {
60         keyHash = 0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c;
61         fee = 0.2 * 10 ** 18; // 0.2 LINK (Varies by network)
62     }
63 
64     /* ========== VIEW FUNCTIONS ========== */
65 
66     function availablePot(address pot) public view returns(bool) {
67         return _availablePot[pot];
68     }
69 
70     /* ========== RESTRICTED FUNCTIONS ========== */
71 
72     function setKeyHash(bytes32 _keyHash) external onlyOwner {
73         keyHash = _keyHash;
74     }
75 
76     function setFee(uint256 _fee) external onlyOwner {
77         fee = _fee;
78     }
79 
80     function setPotAddress(address potAddress, bool activate) external onlyOwner {
81         _availablePot[potAddress] = activate;
82     }
83 
84     /* ========== MUTATE FUNCTIONS ========== */
85 
86     function getRandomNumber(uint potId, uint256 userProvidedSeed) public onlyPot returns (bytes32 requestId) {
87         require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
88         _pots[msg.sender] = potId;
89         requestId = requestRandomness(keyHash, fee, userProvidedSeed);
90         _requestIds[requestId] = msg.sender;
91 
92         emit RequestRandomness(requestId, keyHash, userProvidedSeed);
93     }
94 
95     /* ========== CALLBACK FUNCTIONS ========== */
96 
97     function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
98         address potAddress = _requestIds[requestId];
99         IPotController(potAddress).numbersDrawn(_pots[potAddress], requestId, randomness);
100 
101         emit RequestRandomnessFulfilled(requestId, randomness);
102 
103         delete _requestIds[requestId];
104     }
105 
106     // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
107 }
