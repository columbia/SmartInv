1 pragma solidity ^0.6.0;
2 
3 contract BrandContest {
4 
5     //The allowed Votes that can be transfered
6     mapping(uint256 => uint256) private _allowedVotingAmounts;
7 
8     //Keeps track of the current ERC721 Token addresses allowed for this votation (ARTE/ETRA)
9     mapping(address => bool) private _allowedTokenAddresses;
10 
11     //Takes notes of how many votes received for any token id, for both Tokens (ARTE/ETRA)
12     mapping(address => mapping(uint256 => uint256)) private _votes;
13 
14     //Takes notes of how many ethers received for any token id, for both Tokens (ARTE/ETRA)
15     mapping(address => mapping(uint256 => uint256)) private _ethers;
16 
17     //Takes notes of the rewards anyone sends to vote, creators can redeem those at the end of the survey
18     mapping(address => uint256) private _rewards;
19     mapping(address => bool) private _redeemed;
20 
21     //Il blocco di fine della votazione
22     uint256 private _surveyEndBlock;
23 
24     //Event raised only the first time this NFT receives a vote
25     event FirstVote(address indexed tokenAddress, uint256 indexed tokenId);
26 
27     //Event raised when someone votes for a specific NFT
28     event Vote(address indexed voter, address indexed tokenAddress, uint256 indexed tokenId, address creator, uint256 votes, uint256 amount);
29 
30     //To let this Smart Contract work, you need to pass the ERC721 token addresses supported by this survey (ARTE/ETRA).
31     constructor(address[] memory allowedTokenAddresses, uint256 surveyEndBlock) public {
32         for(uint256 i = 0; i < allowedTokenAddresses.length; i++) {
33             _allowedTokenAddresses[allowedTokenAddresses[i]] = true;
34         }
35         _surveyEndBlock = surveyEndBlock;
36         _allowedVotingAmounts[4000000000000000] = 1;
37         _allowedVotingAmounts[30000000000000000] = 5;
38         _allowedVotingAmounts[100000000000000000] = 10;
39         _allowedVotingAmounts[300000000000000000] = 20;
40     }
41 
42     //The concrete vote operation:
43     //You vote sending some ether to this call, specifing the ERC721 location and id you want to vote.
44     //The amount of ethers received will be registered as a vote for the chosen NFT and transfered to its creator
45     //The vote is to be considered valid if and only if the creator's address is the one who sent the original NFT to the wallet with address: 0x74Ef70357ef21BaD2b45795679F2727C48d501ED
46     function vote(address tokenAddress, uint256 tokenId, address payable creator) public payable {
47 
48         //Are you still able to vote?
49         require(block.number < _surveyEndBlock, "Survey ended!");
50 
51         //To vote you must provide some ethers, with a maximum of 3 eth
52         require(_allowedVotingAmounts[msg.value] > 0, "Vote must be 0.004, 0.03, 0.1 or 0.3 ethers");
53 
54         //You can just vote one of the allowed NFTs (ARTE/ETRA)
55         require(_allowedTokenAddresses[tokenAddress], "Unallowed Token Address!");
56 
57         //Check if tokenId and its owner are valid
58         require(IERC721(tokenAddress).ownerOf(tokenId) != address(0), "Owner is nobody, maybe wrong tokenId?");
59 
60         //If this is the first time this NFT receives a vote, the FirstVote event will be raised
61         if(_votes[tokenAddress][tokenId] == 0) {
62             emit FirstVote(tokenAddress, tokenId);
63         }
64 
65         //Update the votes and ethers amount for this NFT
66         _votes[tokenAddress][tokenId] = _votes[tokenAddress][tokenId] + _allowedVotingAmounts[msg.value];
67         _ethers[tokenAddress][tokenId] = _ethers[tokenAddress][tokenId] + msg.value;
68 
69         //Collects the rewards that can be gived back to the creator at the end of the survey
70         _rewards[creator] = msg.value + _rewards[creator];
71 
72         //Raise an event containing voting info, to let everyone grab this info off-chain
73         emit Vote(msg.sender, tokenAddress, tokenId, creator, _allowedVotingAmounts[msg.value], msg.value);
74     }
75 
76     function getSurveyEndBlock() public view returns(uint256) {
77         return _surveyEndBlock;
78     }
79 
80     //Every creator can redeem their rewards at the end of the survey
81     function redeemRewards() public {
82         require(block.number >= _surveyEndBlock, "Survey is still running!");
83         require(_rewards[msg.sender] > 0 && !_redeemed[msg.sender], "No rewards for you or already redeemed!");
84         payable(msg.sender).transfer(_rewards[msg.sender]);
85         _redeemed[msg.sender] = true;
86     }
87 }
88 
89 interface IERC721 {
90     function ownerOf(uint256 _tokenId) external view returns (address);
91 }