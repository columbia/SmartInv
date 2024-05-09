1 pragma solidity 0.5.4;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     require(a == 0 || c / a == b);
8     return c;
9   }
10  
11   function add(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a + b;
13     require(c >= a);
14     return c;
15   }
16 }
17 
18 contract ERC20 {
19   function transfer(address to, uint256 value) public returns (bool);
20 }
21 
22 contract MultiSign {
23     using SafeMath for uint;
24     
25     address public ThirdParty = address(0x9E832A9CEaDf1E97D6d8da6922b87b59d25eEee0);
26     address public Foundation = address(0x031DE0f3C1D4e525baBa97829eccb3d3D66E9bdb);
27     uint256 public ProposalID = 0;
28     mapping(uint => Proposal) public Proposals;
29 
30     struct Proposal {
31         uint256 id;                   // proposal id
32         address to;                   // to address
33         bool close;                   // false open, true close
34         address tokenContractAddress; // ERC20 token contract address
35         uint256 amount;               // token amount
36         uint256 approvalByThirdParty; // default: 0 approval: 1 refuse: 2
37         uint256 approvalByFoundation; // default: 0 approval: 1 refuse: 2
38     }
39     
40     
41     constructor() public {
42     }
43     
44     function lookProposal(uint256 id) public view returns (uint256 _id, address _to, bool _close, address _tokenContractAddress, uint256 _amount, uint256 _approvalByThirdParty, uint256 _approvalByFoundation) {
45         Proposal memory p = Proposals[id];
46         return (p.id, p.to, p.close, p.tokenContractAddress, p.amount, p.approvalByThirdParty, p.approvalByFoundation);
47     }
48     
49     // only  Foundation or ThirdParty can proposal
50     function proposal (address _to, address _tokenContractAddress, uint256 _amount) public returns (uint256 id) {
51         require(msg.sender == Foundation || msg.sender == ThirdParty);
52         ProposalID = ProposalID.add(1);
53         Proposals[ProposalID] = Proposal(ProposalID, _to, false, _tokenContractAddress, _amount, 0, 0);
54         return id;
55     }
56     
57     // only  Foundation or ThirdParty can approval
58     function approval (uint256 id) public returns (bool) {
59         require(msg.sender == Foundation || msg.sender == ThirdParty);
60         Proposal storage p = Proposals[id];
61         require(p.close == false);
62         if (msg.sender == Foundation && p.approvalByFoundation == 0) {
63             p.approvalByFoundation = 1;
64             Proposals[id] = p;
65         }
66         if (msg.sender == ThirdParty && p.approvalByThirdParty == 0) {
67             p.approvalByThirdParty = 1;
68             Proposals[id] = p;
69         }
70         
71         if (p.approvalByThirdParty == 1 && p.approvalByFoundation == 1) {
72             p.close = true;
73             Proposals[id] = p;
74             require(ERC20(p.tokenContractAddress).transfer(p.to, p.amount.mul(1e18)));
75         }
76         return true;
77     }
78     
79     // only  Foundation or ThirdParty can refuse
80     function refuse (uint256 id) public returns (bool) {
81         require(msg.sender == Foundation || msg.sender == ThirdParty);
82         Proposal storage p = Proposals[id];
83         require(p.close == false);
84         require(p.approvalByFoundation == 0 || p.approvalByThirdParty == 0);
85         
86         if (msg.sender == Foundation && p.approvalByFoundation == 0) {
87             p.close = true;
88             p.approvalByFoundation = 2;
89             Proposals[id] = p;
90             return true;
91         }
92         if (msg.sender == ThirdParty && p.approvalByThirdParty == 0) {
93             p.close = true;
94             p.approvalByThirdParty = 2;
95             Proposals[id] = p;
96             return true;
97         }
98         return true;
99     }
100     
101     
102     function() payable external {
103         revert();
104     }
105 }