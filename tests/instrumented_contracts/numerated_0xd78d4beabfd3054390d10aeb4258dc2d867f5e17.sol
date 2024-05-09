1 pragma solidity ^0.4.19;
2 
3 // DELEGATION SC
4 
5 // (c) SecureVote 2018
6 
7 // Released under MIT licence
8 
9 contract SVDelegation {
10 
11     address public owner;
12 
13     struct Delegation {
14         uint256 thisDelegationId;
15         address dlgt;
16         uint256 setAtBlock;
17         uint256 prevDelegation;
18     }
19 
20     mapping (address => mapping (address => Delegation)) tokenDlgts;
21     mapping (address => Delegation) globalDlgts;
22 
23     mapping (uint256 => Delegation) public historicalDelegations;
24     uint256 public totalDelegations = 0;
25 
26     event SetGlobalDelegation(address voter, address delegate);
27     event SetTokenDelegation(address voter, address tokenContract, address delegate);
28 
29     function SVDelegation() public {
30         owner = msg.sender;
31 
32         // commit the genesis historical delegation to history (like genesis block)
33         createDelegation(address(0), 0);
34     }
35 
36     function createDelegation(address dlgtAddress, uint256 prevDelegationId) internal returns(Delegation) {
37         uint256 myDelegationId = totalDelegations;
38         historicalDelegations[myDelegationId] = Delegation(myDelegationId, dlgtAddress, block.number, prevDelegationId);
39         totalDelegations += 1;
40 
41         return historicalDelegations[myDelegationId];
42     }
43 
44     // get previous delegation, create new delegation via function and then commit to globalDlgts
45     function setGlobalDelegation(address dlgtAddress) public {
46         uint256 prevDelegationId = globalDlgts[msg.sender].thisDelegationId;
47         globalDlgts[msg.sender] = createDelegation(dlgtAddress, prevDelegationId);
48         SetGlobalDelegation(msg.sender, dlgtAddress);
49     }
50 
51     // get previous delegation, create new delegation via function and then commit to tokenDlgts
52     function setTokenDelegation(address tokenContract, address dlgtAddress) public {
53         uint256 prevDelegationId = tokenDlgts[tokenContract][msg.sender].thisDelegationId;
54         tokenDlgts[tokenContract][msg.sender] = createDelegation(dlgtAddress, prevDelegationId);
55         SetTokenDelegation(msg.sender, tokenContract, dlgtAddress);
56     }
57 
58     function resolveDelegation(address voter, address tokenContract) public constant returns(uint256, address, uint256, uint256) {
59         Delegation memory _tokenDlgt = tokenDlgts[tokenContract][voter];
60 
61         // probs simplest test to check if we have a valid delegation
62         if (_tokenDlgt.setAtBlock > 0) {
63             return _dlgtRet(_tokenDlgt);
64         } else {
65             return _dlgtRet(globalDlgts[voter]);
66         }
67     }
68 
69     function _rawGetGlobalDelegation(address _voter) public constant returns(uint256, address, uint256, uint256) {
70         return _dlgtRet(globalDlgts[_voter]);
71     }
72 
73     function _rawGetTokenDelegation(address _voter, address _tokenContract) public constant returns(uint256, address, uint256, uint256) {
74         return _dlgtRet(tokenDlgts[_tokenContract][_voter]);
75     }
76 
77     function _dlgtRet(Delegation d) internal pure returns(uint256, address, uint256, uint256) {
78         return (d.thisDelegationId, d.dlgt, d.setAtBlock, d.prevDelegation);
79     }
80 }