1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "./MergerBase.sol";
5 import "../fei/IFei.sol";
6 import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
7 
8 /**
9  @title Contract to exchange TRIBE with FEI post-merger
10  @author elee, Joey Santoro
11  @notice Exchange TRIBE for FEI at Intrinsic Value (semi-manually set)
12  Intrinsic Value = equity / circulating TRIBE.
13  equity = PCV - user FEI
14  circulating TRIBE = total supply - treasury - liquidity mining
15 */
16 contract TRIBERagequit is MergerBase {
17     using SafeERC20 for IERC20;
18 
19     /// @notice tribe treasury, removed from circulating supply
20     address public constant coreAddress = 0x8d5ED43dCa8C2F7dFB20CF7b53CC7E593635d7b9;
21 
22     /// @notice guardian multisig, sets the IV before DAO vote
23     address public constant guardian = 0xB8f482539F2d3Ae2C9ea6076894df36D1f632775;
24 
25     /// @notice Intrinsic value exchange rate (IV), scaled by 1e9
26     uint256 public intrinsicValueExchangeRateBase;
27 
28     /// @notice tribe liquidity mining dripper, removed from circulating supply
29     address public constant rewardsDripper = 0x3Fe0EAD3500e767F0F8bC2d3B5AF7755B1b21A6a;
30 
31     /// @notice you already know
32     IFei public constant fei = IFei(0x956F47F50A910163D8BF957Cf5846D573E7f87CA);
33 
34     /// @notice first timestamp for ragequit
35     uint256 public immutable rageQuitStart;
36 
37     /// @notice last timestamp for ragequit
38     uint256 public immutable rageQuitEnd;
39 
40     mapping(address => uint256) public claimed;
41 
42     event Exchange(address indexed from, uint256 amountIn, uint256 amountOut);
43 
44     bytes32 public merkleRoot;
45 
46     constructor(
47         bytes32 root,
48         uint256 _rageQuitStart,
49         uint256 _rageQuitEnd,
50         address tribeRariDAO
51     ) MergerBase(tribeRariDAO) {
52         merkleRoot = root;
53 
54         require(_rageQuitEnd - _rageQuitStart > 1 days, "need at least 24h ragequit window");
55         rageQuitStart = _rageQuitStart;
56         rageQuitEnd = _rageQuitEnd;
57     }
58 
59     /// @notice ragequit held TRIBE with FEI
60     /// @dev not gonna make it
61     /// @param amount the amount to redeem in TRIBE
62     /// @param totalMerkleAmount the amount of TRIBE allocated to the caller in the merkle drop
63     /// @param merkleProof a proof proving that the caller may redeem up to `totalMerkleAmount` amount of tribe
64     function ngmi(
65         uint256 amount,
66         uint256 totalMerkleAmount,
67         bytes32[] calldata merkleProof
68     ) external {
69         require(bothPartiesAccepted, "Proposals are not both passed");
70         require(block.timestamp > rageQuitStart && block.timestamp < rageQuitEnd, "outside ragequit window");
71         require(verifyClaim(msg.sender, totalMerkleAmount, merkleProof), "invalid proof");
72         require((claimed[msg.sender] + amount) <= totalMerkleAmount, "exceeds ragequit limit");
73         claimed[msg.sender] += amount;
74 
75         uint256 feiOut = (amount * intrinsicValueExchangeRateBase) / scalar;
76 
77         tribe.safeTransferFrom(msg.sender, coreAddress, amount);
78         fei.mint(msg.sender, feiOut);
79 
80         emit Exchange(msg.sender, amount, feiOut);
81     }
82 
83     function getCirculatingTribe() public view returns (uint256) {
84         return tribe.totalSupply() - tribe.balanceOf(coreAddress) - tribe.balanceOf(rewardsDripper);
85     }
86 
87     /// @notice recalculate the exchange amount using the protocolEquity
88     /// @param protocolEquity the protocol equity
89     /// @return the new intrinsicValueExchangeRateBase
90     function exchangeRate(uint256 protocolEquity) public view returns (uint256) {
91         return (scalar * protocolEquity) / getCirculatingTribe();
92     }
93 
94     /// @notice Update the exchange rate based on protocol equity
95     /// @param protocolEquity the protocol equity
96     /// @return the new exchange rate
97     /// @dev only callable once by guardian
98     function setExchangeRate(uint256 protocolEquity) external returns (uint256) {
99         require(intrinsicValueExchangeRateBase == 0, "already set");
100         require(msg.sender == guardian, "guardian");
101         intrinsicValueExchangeRateBase = exchangeRate(protocolEquity);
102         return intrinsicValueExchangeRateBase;
103     }
104 
105     /// @notice validate the proof of a merkle drop claim
106     /// @param claimer the address attempting to claim
107     /// @param totalMerkleAmount the amount of scaled TRIBE allocated the claimer claims that they have credit over
108     /// @param merkleProof a proof proving that claimer may redeem up to `totalMerkleAmount` amount of tribe
109     /// @return boolean true if the proof is valid, false if the proof is invalid
110     function verifyClaim(
111         address claimer,
112         uint256 totalMerkleAmount,
113         bytes32[] memory merkleProof
114     ) private view returns (bool) {
115         bytes32 leaf = keccak256(abi.encodePacked(claimer, totalMerkleAmount));
116         return MerkleProof.verify(merkleProof, merkleRoot, leaf);
117     }
118 }
