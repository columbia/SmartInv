1 pragma solidity ^0.5.0;
2 
3 interface IDarkEnergyCrystals {
4 
5     function mint(uint256 _quantity) external;
6     function burn(uint256 _quantity) external;
7     function unlock(address _holder, uint256 _quantity) external;
8 }
9 
10 contract CrystalMinter {
11 
12     IDarkEnergyCrystals crystals;
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
26     constructor(address _crystalsAddr, address _signer1, address _signer2, address _signer3) public {
27         crystals = IDarkEnergyCrystals(_crystalsAddr);
28         signer1 = _signer1;
29         signer2 = _signer2;
30         signer3 = _signer3;
31     }
32 
33     function mint(uint256 _quantity) public onlySigner() {
34         crystals.mint(_quantity);
35     }
36 
37     function burn(uint256 _quantity) public onlySigner() {
38         crystals.burn(_quantity);
39     }
40 
41     function unlock(address _holder, uint256 _quantity) public onlySigner() {
42         crystals.unlock(_holder, _quantity);
43     }
44 
45     function proposeSubstitution(
46                 address _affirmer,
47                 address _retiree,
48                 address _replacement
49             )
50                 public
51                 onlySigner
52                 isSigner(_affirmer)
53                 isSigner(_retiree)
54                 notSigner(_replacement)
55     {
56         address _proposer = msg.sender;
57 
58         require(_affirmer != _proposer, "CrystalMinter: Affirmer Is Proposer");
59         require(_affirmer != _retiree, "CrystalMinter: Affirmer Is Retiree");
60         require(_proposer != _retiree, "CrystalMinter: Retiree Is Proposer");
61 
62         proposals[_proposer] = SubstitutionProposal(_proposer, _affirmer, _retiree, _replacement);
63     }
64 
65     function withdrawProposal() public onlySigner {
66         delete proposals[msg.sender];
67     }
68 
69     function withdrawStaleProposal(address _oldProposer) public onlySigner notSigner(_oldProposer) {
70         delete proposals[_oldProposer];
71     }
72 
73     function acceptProposal(address _proposer) public onlySigner isSigner(_proposer) {
74         SubstitutionProposal storage proposal = proposals[_proposer];
75 
76         require(proposal.affirmer == msg.sender, "CrystalMinter: Not Affirmer");
77 
78         if (signer1 == proposal.retiree) {
79             signer1 = proposal.replacement;
80         } else if (signer2 == proposal.retiree) {
81             signer2 = proposal.replacement;
82         } else if (signer3 == proposal.retiree) {
83             signer3 = proposal.replacement;
84         }
85 
86         delete proposals[_proposer];
87     }
88 
89     modifier onlySigner() {
90         require(msg.sender == signer1 ||
91                 msg.sender == signer2 ||
92                 msg.sender == signer3,
93                 "CrystalMinter: Not Signer");
94         _;
95     }
96 
97     modifier isSigner(address _addr) {
98         require(_addr == signer1 ||
99                 _addr == signer2 ||
100                 _addr == signer3,
101                 "CrystalMinter: Addr Not Signer");
102         _;
103     }
104 
105     modifier notSigner(address _addr) {
106         require(_addr != signer1 &&
107                 _addr != signer2 &&
108                 _addr != signer3,
109                 "CrystalMinter: Addr Is Signer");
110         _;
111     }
112 }