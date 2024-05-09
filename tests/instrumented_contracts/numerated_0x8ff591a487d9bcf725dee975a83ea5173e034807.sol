1 pragma solidity ^0.5.0;
2 
3 interface ISplinterlands {
4     function mintCard(string calldata splinterId, address owner) external;
5     function unlockCard(uint256 _ethId, address _newHolder) external;
6     function tokenIdForCardId(string calldata _splinterId) external view returns (uint256);
7     function burnCard(uint256 _ethId) external;
8 }
9 
10 contract CardMinter {
11 
12     address splinterlandsAddr;
13     address signer1;
14     address signer2;
15     address signer3;
16 
17     struct SubstitutionProposal {
18         address proposer;
19         address affirmer;
20         address retiree;
21         address replacement;
22     }
23 
24     mapping(address => SubstitutionProposal) proposals;
25 
26     constructor(address _splinterlandsAddr, address _signer1, address _signer2, address _signer3) public {
27         splinterlandsAddr = _splinterlandsAddr;
28         signer1 = _signer1;
29         signer2 = _signer2;
30         signer3 = _signer3;
31     }
32 
33     function mintCard(string memory _splinterId, address _cardHolder) public onlySigner {
34         ISplinterlands splinterlands = ISplinterlands(splinterlandsAddr);
35 
36         splinterlands.mintCard(_splinterId, _cardHolder);
37     }
38 
39     function unlockCard(string memory _splinterId, address _cardHolder) public onlySigner {
40         ISplinterlands splinterlands = ISplinterlands(splinterlandsAddr);
41 
42         splinterlands.unlockCard(
43                     splinterlands.tokenIdForCardId(_splinterId),
44                     _cardHolder
45                 );
46     }
47 
48     function burnCard(string memory _splinterId) public onlySigner {
49         ISplinterlands splinterlands = ISplinterlands(splinterlandsAddr);
50         splinterlands.burnCard(splinterlands.tokenIdForCardId(_splinterId));
51     }
52 
53     function proposeSubstitution(
54                 address _affirmer,
55                 address _retiree,
56                 address _replacement
57             )
58                 public
59                 onlySigner
60                 isSigner(_affirmer)
61                 isSigner(_retiree)
62                 notSigner(_replacement)
63     {
64         address _proposer = msg.sender;
65 
66         require(_affirmer != _proposer, "CardMinter: Affirmer Is Proposer");
67         require(_affirmer != _retiree, "CardMinter: Affirmer Is Retiree");
68         require(_proposer != _retiree, "CardMinter: Retiree Is Proposer");
69 
70         proposals[_proposer] = SubstitutionProposal(_proposer, _affirmer, _retiree, _replacement);
71     }
72 
73     function withdrawProposal() public onlySigner {
74         delete proposals[msg.sender];
75     }
76 
77     function withdrawStaleProposal(address _oldProposer) public onlySigner notSigner(_oldProposer) {
78         delete proposals[_oldProposer];
79     }
80 
81     function acceptProposal(address _proposer) public onlySigner isSigner(_proposer) {
82         SubstitutionProposal storage proposal = proposals[_proposer];
83 
84         require(proposal.affirmer == msg.sender, "CardMinter: Not Affirmer");
85 
86         if (signer1 == proposal.retiree) {
87             signer1 = proposal.replacement;
88         } else if (signer2 == proposal.retiree) {
89             signer2 = proposal.replacement;
90         } else if (signer3 == proposal.retiree) {
91             signer3 = proposal.replacement;
92         }
93 
94         delete proposals[_proposer];
95     }
96 
97     modifier onlySigner() {
98         require(msg.sender == signer1 ||
99                 msg.sender == signer2 ||
100                 msg.sender == signer3,
101                 "CardMinter: Not Signer");
102         _;
103     }
104 
105     modifier isSigner(address _addr) {
106         require(_addr == signer1 ||
107                 _addr == signer2 ||
108                 _addr == signer3,
109                 "CardMinter: Addr Not Signer");
110         _;
111     }
112 
113     modifier notSigner(address _addr) {
114         require(_addr != signer1 &&
115                 _addr != signer2 &&
116                 _addr != signer3,
117                 "CardMinter: Addr Is Signer");
118         _;
119     }
120 }