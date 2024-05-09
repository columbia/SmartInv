1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.6;
3 
4 contract ChizDispenserV2 {
5     struct Claim {
6         bool claimed;
7         uint256 ratId;
8     }
9 
10     mapping(uint256 => Claim) existingClaims;
11 
12     ChizDispenser chizDispenser = ChizDispenser(0x5e7fDe13483e5b51da88D2898e0f6a6d7B0c6899);
13     ERC721 ratContract = ERC721(0xd21a23606D2746f086f6528Cd6873bAD3307b903);
14     ERC20 chizContract = ERC20(0x5c761c1a21637362374204000e383204d347064C);
15 
16     bool paused = false;
17     address deployer;
18     uint256 amount = 10000 * 1 ether;
19 
20     event Dispense(uint256 amount, uint256 ratId);
21 
22     constructor() {
23         deployer = msg.sender;
24     }
25 
26     modifier onlyDeployer() {
27         require(msg.sender == deployer);
28         _;
29     }
30 
31     modifier pauseable() {
32         require(paused == false, 'contract is paused');
33         _;
34     }
35 
36     modifier isNotClaimed(uint256 ratId) {
37         bool claimed = isClaimed(ratId);
38         require(claimed == false, 'tokens for this rat have already been claimed');
39         _;
40     }
41 
42     function isClaimed(uint256 ratId) public view returns (bool) {
43         Claim memory claim = existingClaims[ratId];
44         if (claim.claimed) return true;
45         (bool claimed, ) = chizDispenser.existingClaims(ratId);
46         if (claimed) return true;
47         return false;
48     }
49 
50     function pause() public onlyDeployer {
51         paused = true;
52     }
53 
54     function unpause() public onlyDeployer {
55         paused = false;
56     }
57 
58     function setAmount(uint256 newAmount) public onlyDeployer pauseable {
59         amount = newAmount;
60     }
61 
62     function withdraw(uint256 withdrawAmount) public onlyDeployer pauseable {
63         chizContract.transfer(msg.sender, withdrawAmount);
64     }
65 
66     function claimChiz(uint256 ratId) public pauseable isNotClaimed(ratId) {
67         address ratOwner = ratContract.ownerOf(ratId);
68         require(msg.sender == ratOwner, 'caller is not owner of this rat');
69 
70         existingClaims[ratId] = Claim(true, ratId);
71         chizContract.transfer(msg.sender, amount);
72 
73         emit Dispense(amount, ratId);
74     }
75 
76     function multiClaimChiz(uint256[] memory ratIds) public pauseable {
77         for (uint256 i = 0; i < ratIds.length; i++) {
78             bool claimed = isClaimed(ratIds[i]);
79             if (!claimed) claimChiz(ratIds[i]);
80         }
81     }
82 
83     function megaClaimChiz() public pauseable {
84         uint256 ratBalance = ratContract.balanceOf(msg.sender);
85         for (uint256 i = 0; i < ratBalance; i++) {
86             uint256 tokenId = ratContract.tokenOfOwnerByIndex(msg.sender, i);
87             bool claimed = isClaimed(tokenId);
88             if (!claimed) claimChiz(tokenId);
89         }
90     }
91 }
92 
93 abstract contract ChizDispenser {
94     struct Claim {
95         bool claimed;
96         uint256 ratId;
97     }
98     mapping(uint256 => Claim) public existingClaims;
99 
100     function claimChiz(uint256 ratId) public virtual;
101 }
102 
103 abstract contract ERC721 {
104     function ownerOf(uint256 id) public virtual returns (address owner);
105 
106     function balanceOf(address owner) public virtual returns (uint256 balance);
107 
108     function tokenOfOwnerByIndex(address owner, uint256 index) public virtual returns (uint256 id);
109 }
110 
111 abstract contract ERC20 {
112     function transfer(address to, uint256 value) public virtual;
113 }