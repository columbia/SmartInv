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
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     require(b > 0);
13     uint256 c = a / b;
14     return c;
15   }
16   
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b <= a);
19     uint256 c = a - b;
20     return c;
21   }
22 
23  
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27     return c;
28   }
29 }
30 
31 contract ERC20 {
32   function transfer(address to, uint256 value) public returns (bool);
33 }
34 
35 contract MultiSign {
36     using SafeMath for uint;
37     
38     address public Exchange = address(0x9E832A9CEaDf1E97D6d8da6922b87b59d25eEee0);
39     address public Foundation = address(0x5a403e651EC2cD3b6B385dC639f1A90ea01017f7);
40     uint256 public ProposalID = 0;
41     mapping(uint => Proposal) public Proposals;
42 
43     struct Proposal {
44         uint256 id;
45         address to;
46         bool close; // false open, true close
47         address tokenContractAddress; // ERC20 token contract address
48         uint256 amount;
49         uint256 approvalByExchange; // default 0  approva 1 refuse 2
50         uint256 approvalByFoundation;
51     }
52     
53     
54     constructor() public {
55     }
56     
57     function lookProposal(uint256 id) public view returns (uint256 _id, address _to, bool _close, address _tokenContractAddress, uint256 _amount, uint256 _approvalByExchange, uint256 _approvalByFoundation) {
58         Proposal memory p = Proposals[id];
59         return (p.id, p.to, p.close, p.tokenContractAddress, p.amount, p.approvalByExchange, p.approvalByFoundation);
60     }
61     
62     // only  Foundation or Exchange can proposal
63     function proposal (address _to, address _tokenContractAddress, uint256 _amount) public returns (uint256 id) {
64         require(msg.sender == Foundation || msg.sender == Exchange);
65         ProposalID = ProposalID.add(1);
66         Proposals[ProposalID] = Proposal(ProposalID, _to, false, _tokenContractAddress, _amount, 0, 0);
67         return id;
68     }
69     
70     // only  Foundation or Exchange can approval
71     function approval (uint256 id) public returns (bool) {
72         require(msg.sender == Foundation || msg.sender == Exchange);
73         Proposal storage p = Proposals[id];
74         require(p.close == false);
75         if (msg.sender == Foundation && p.approvalByFoundation == 0) {
76             p.approvalByFoundation = 1;
77             Proposals[ProposalID] = p;
78         }
79         if (msg.sender == Exchange && p.approvalByExchange == 0) {
80             p.approvalByExchange = 1;
81             Proposals[ProposalID] = p;
82         }
83         
84         if (p.approvalByExchange == 1 && p.approvalByFoundation == 1) {
85             p.close = true;
86             Proposals[ProposalID] = p;
87             ERC20(p.tokenContractAddress).transfer(p.to, p.amount.mul(1e18));
88         }
89         return true;
90     }
91     
92     // only  Foundation or Exchange can refuse
93     function refuse (uint256 id) public returns (bool) {
94         require(msg.sender == Foundation || msg.sender == Exchange);
95         Proposal storage p = Proposals[id];
96         require(p.close == false);
97         if (msg.sender == Foundation && p.approvalByFoundation == 0) {
98             p.close = true;
99             p.approvalByFoundation = 2;
100             Proposals[ProposalID] = p;
101             return true;
102         }
103         if (msg.sender == Exchange && p.approvalByExchange == 0) {
104             p.close = true;
105             p.approvalByExchange = 2;
106             Proposals[ProposalID] = p;
107             return true;
108         }
109     }
110     
111     
112     function() payable external {
113         revert();
114     }
115 }