1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../vendor/MerkleProof.sol";
6 import "../Utils.sol";
7 
8 interface IEulStakes {
9     function stakeGift(address beneficiary, address underlying, uint amount) external;
10 }
11 
12 contract EulDistributor {
13     address public immutable eul;
14     address public immutable eulStakes;
15     string public constant name = "EUL Distributor";
16 
17     address public owner;
18     bytes32 public currRoot;
19     bytes32 public prevRoot;
20     mapping(address => mapping(address => uint)) public claimed; // account -> token -> amount
21 
22     event OwnerChanged(address indexed newOwner);
23 
24     constructor(address eul_, address eulStakes_) {
25         eul = eul_;
26         eulStakes = eulStakes_;
27         owner = msg.sender;
28         Utils.safeApprove(eul_, eulStakes_, type(uint).max);
29     }
30 
31     // Owner functions
32 
33     modifier onlyOwner {
34         require(msg.sender == owner, "unauthorized");
35         _;
36     }
37 
38     function transferOwnership(address newOwner) external onlyOwner {
39         owner = newOwner;
40         emit OwnerChanged(newOwner);
41     }
42 
43     function updateRoot(bytes32 newRoot) external onlyOwner {
44         prevRoot = currRoot;
45         currRoot = newRoot;
46     }
47 
48     // Claiming
49 
50     /// @notice Claim distributed tokens
51     /// @param account Address that should receive tokens
52     /// @param token Address of token being claimed (ie EUL)
53     /// @param proof Merkle proof that validates this claim
54     /// @param stake If non-zero, then the address of a token to auto-stake to, instead of claiming
55     function claim(address account, address token, uint claimable, bytes32[] calldata proof, address stake) external {
56         bytes32 candidateRoot = MerkleProof.processProof(proof, keccak256(abi.encodePacked(account, token, claimable))); // 72 byte leaf
57         require(candidateRoot == currRoot || candidateRoot == prevRoot, "proof invalid/expired");
58 
59         uint alreadyClaimed = claimed[account][token];
60         require(claimable > alreadyClaimed, "already claimed");
61 
62         uint amount;
63         unchecked {
64             amount = claimable - alreadyClaimed;
65         }
66 
67         claimed[account][token] = claimable;
68 
69         if (stake == address(0)) {
70             Utils.safeTransfer(token, account, amount);
71         } else {
72             require(msg.sender == account, "can only auto-stake for yourself");
73             require(token == eul, "can only auto-stake EUL");
74             IEulStakes(eulStakes).stakeGift(account, stake, amount);
75         }
76     }
77 }
