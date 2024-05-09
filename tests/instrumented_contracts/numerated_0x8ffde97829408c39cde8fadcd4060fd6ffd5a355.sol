1 pragma solidity ^0.5.2;
2 // This is basically a shared account in which any transactions done must be signed by multiple parties. Hence, multi-signature wallet.
3 contract SimpleMultiSigWallet {
4     struct Proposal {
5         uint256 amount;
6         address payable to;
7         uint8 votes;
8         bytes data;
9         mapping (address => bool) voted;
10     }
11     
12     mapping (bytes32 => Proposal) internal proposals;
13     mapping (address => uint8) public voteCount;
14     
15     uint8 constant public maximumVotes = 2; 
16     constructor() public{
17         voteCount[0x8c070C3c66F62E34bAe561951450f15f3256f67c] = 1; // ARitz Cracker
18         voteCount[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 1; // Sumpunk
19     }
20     
21     function proposeTransaction(address payable to, uint256 amount, bytes memory data) public{
22         require(voteCount[msg.sender] != 0, "You cannot vote");
23         bytes32 hash = keccak256(abi.encodePacked(to, amount, data));
24         require(!proposals[hash].voted[msg.sender], "Already voted");
25         if (proposals[hash].votes == 0){
26             proposals[hash].amount = amount;
27             proposals[hash].to = to;
28             proposals[hash].data = data;
29             proposals[hash].votes = voteCount[msg.sender];
30             proposals[hash].voted[msg.sender] = true;
31         }else{
32             proposals[hash].votes += voteCount[msg.sender];
33             proposals[hash].voted[msg.sender] = true;
34             if (proposals[hash].votes >= maximumVotes){
35                 if (proposals[hash].data.length == 0){
36                     proposals[hash].to.transfer(proposals[hash].amount);
37                 }else{
38 					bool success;
39 					bytes memory returnData;
40 					(success, returnData) = proposals[hash].to.call.value(proposals[hash].amount)(proposals[hash].data);
41 					require(success);
42                 }
43                 delete proposals[hash];
44             }
45         }
46     }
47     
48     // Yes we will take your free ERC223 tokens, thank you very much
49     function tokenFallback(address from, uint value, bytes memory data) public{
50         
51     }
52     
53     function() external payable{
54         // Accept free ETH
55     }
56 }