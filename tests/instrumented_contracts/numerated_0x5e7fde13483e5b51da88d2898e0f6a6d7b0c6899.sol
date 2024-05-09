1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.6;
3 
4 contract ChizDispenser {
5     struct Claim {
6         bool claimed;
7         uint256 ratId;
8     }
9 
10     mapping(uint256 => Claim) public existingClaims;
11 
12     ERC721 ratContract = ERC721(0xd21a23606D2746f086f6528Cd6873bAD3307b903);
13     ERC20 chizContract = ERC20(0x5c761c1a21637362374204000e383204d347064C);
14 
15     bool paused = false;
16     address deployer;
17     uint256 amount = 10000 * 1 ether;
18 
19     event Dispense(uint256 amount, uint256 ratId);
20 
21     constructor() {
22         deployer = msg.sender;
23     }
24 
25     modifier onlyDeployer() {
26         require(msg.sender == deployer);
27         _;
28     }
29 
30     modifier pauseable() {
31         require(paused == false, "contract is paused");
32         _;
33     }
34 
35     function pause() public onlyDeployer {
36         paused = true;
37     }
38 
39     function unpause() public onlyDeployer {
40         paused = false;
41     }
42 
43     function setAmount(uint256 newAmount) public onlyDeployer pauseable {
44         amount = newAmount;
45     }
46 
47     function withdraw(uint256 withdrawAmount) public onlyDeployer pauseable {
48         chizContract.transfer(msg.sender, withdrawAmount);
49     }
50     
51     function claimChiz(uint256 ratId) public pauseable {
52         Claim memory claim = existingClaims[ratId];
53         require(
54             claim.claimed == false,
55             "tokens have already been claimed for this rat"
56         );
57 
58         address ratOwner = ratContract.ownerOf(ratId);
59         require(msg.sender == ratOwner, "caller is not owner of this rat");
60 
61         existingClaims[ratId] = Claim(true, ratId);
62         chizContract.transfer(msg.sender, amount);
63 
64         emit Dispense(amount, ratId);
65     }
66     
67     function multiClaimChiz(uint256[] memory ratIds) public pauseable {
68         for(uint i = 0; i < ratIds.length; i++) {
69             claimChiz(ratIds[i]);
70         }
71     }
72 }
73 
74 abstract contract ERC721 {
75     function ownerOf(uint256 id) public virtual returns (address);
76 }
77 
78 abstract contract ERC20 {
79     function transfer(address to, uint256 value) public virtual;
80 }