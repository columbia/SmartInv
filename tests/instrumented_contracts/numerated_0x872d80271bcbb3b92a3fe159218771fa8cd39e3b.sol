1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeERC20
29  * @dev Wrappers around ERC20 operations that throw on failure.
30  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
31  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
32  */
33 library SafeERC20 {
34   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
35     assert(token.transfer(to, value));
36   }
37 
38   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
39     assert(token.transferFrom(from, to, value));
40   }
41 
42   function safeApprove(ERC20 token, address spender, uint256 value) internal {
43     assert(token.approve(spender, value));
44   }
45 }
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 
81 contract Job {
82     using SafeMath for uint256;
83     using SafeERC20 for ERC20;
84 
85     event MilestoneCreated(uint16 id, uint16 parent, string title);
86     event ProposalCreated(uint16 id, uint16 milestone, address contractor, uint256 amount);
87 
88     ERC20 public token;
89     string public title; 
90     string public description; 
91     address public escrowAdmin;
92     address public customer;
93     
94     struct Proposal {
95         address contractor;             //Address of contractor
96         uint256 amount;                 //Proposed price
97         string description;             //Description of proposal
98     }
99     struct Milestone {
100         uint16 parent;                  //id of parent milestone
101         string title;                   //Milestone title
102         string description;             //Milestone description
103         uint64 deadline;                //Timestamp When work should be done
104         Proposal[] proposals;           //Proposals from contractors
105         int16 acceptedProposal;         //id of accepted proposal or -1 if no accepted
106         bool done;                      //Contractor marked milestone as done
107         bool approved;                  //Is approved by manager: general contractor or customer - for general milestones
108         bool customerApproved;          //Is approved by customer
109         bool requiresCustomerApproval;  //Is customer approval requireds
110         uint256 paid;                   //Amount which was already paid to contractor
111         uint256 allowance;              //Amount contractor allowed to spend to pay sub-contractors of this milestone
112     }
113     Milestone[] public milestones;      //Array of all milestones
114 
115     modifier onlyCustomer(){
116         require(msg.sender == customer);
117         _;
118     }
119 
120     constructor(ERC20 _token, string _title, string _description, address _escrowAdmin) public {
121         token = _token;
122         customer = msg.sender;
123         title = _title;
124         description = _description;
125         escrowAdmin = _escrowAdmin;
126 
127         pushMilestone(0, "", "", 0, false);
128     }
129 
130     function addGeneralMilestone(string _title, string _description, uint64 _deadline) onlyCustomer external{
131         require(_deadline > now);
132         pushMilestone(0, _title, _description, _deadline, false);
133     }
134     function addSubMilestone(uint16 _parent, string _title, string _description, uint64 _deadline, bool _requiresCustomerApproval) external {
135         require(_parent > 0 && _parent < milestones.length);
136         Milestone storage parent = milestones[_parent];
137         require(parent.acceptedProposal >= 0);
138         address generalContractor = parent.proposals[uint16(parent.acceptedProposal)].contractor;
139         assert(generalContractor!= address(0));
140         require(msg.sender == generalContractor);
141         pushMilestone(_parent, _title, _description, _deadline, _requiresCustomerApproval);
142     }
143 
144     function addProposal(uint16 milestone, uint256 _amount, string _description) external {
145         require(milestone < milestones.length);
146         require(_amount > 0);
147         milestones[milestone].proposals.push(Proposal({
148             contractor: msg.sender,
149             amount: _amount,
150             description: _description
151         }));
152         emit ProposalCreated( uint16(milestones[milestone].proposals.length-1), milestone, msg.sender, _amount);
153     }
154 
155     function getProposal(uint16 milestone, uint16 proposal) view public returns(address contractor, uint256 amount, string description){
156         require(milestone < milestones.length);
157         Milestone storage m = milestones[milestone];
158         require(proposal < m.proposals.length);
159         Proposal storage p = m.proposals[proposal];
160         return (p.contractor, p.amount, p.description);
161     }
162     function getProposalAmount(uint16 milestone, uint16 proposal) view public returns(uint256){
163         require(milestone < milestones.length);
164         Milestone storage m = milestones[milestone];
165         require(proposal < m.proposals.length);
166         Proposal storage p = m.proposals[proposal];
167         return p.amount;
168     }
169     function getProposalContractor(uint16 milestone, uint16 proposal) view public returns(address){
170         require(milestone < milestones.length);
171         Milestone storage m = milestones[milestone];
172         require(proposal < m.proposals.length);
173         Proposal storage p = m.proposals[proposal];
174         return p.contractor;
175     }
176 
177 
178     function confirmProposalAndTransferFunds(uint16 milestone, uint16 proposal) onlyCustomer external returns(bool){
179         require(milestone < milestones.length);
180         Milestone storage m = milestones[milestone];
181         require(m.deadline > now);
182 
183         require(proposal < m.proposals.length);
184         Proposal storage p = m.proposals[proposal];
185         m.acceptedProposal = int16(proposal);
186 
187         require(token.transferFrom(customer, address(this), p.amount));
188         return true;
189     }
190     function markDone(uint16 _milestone) external {
191         require(_milestone < milestones.length);
192         Milestone storage m = milestones[_milestone];
193         assert(m.acceptedProposal >= 0);
194         Proposal storage p = m.proposals[uint16(m.acceptedProposal)];        
195         require(msg.sender == p.contractor);
196         require(m.done == false);
197         m.done = true;
198     }
199     function approveAndPayout(uint16 _milestone) onlyCustomer external{
200         require(_milestone < milestones.length);
201         Milestone storage m = milestones[_milestone];
202         require(m.acceptedProposal >= 0);
203         //require(m.done);  //We do not require this right now
204         m.customerApproved = true;
205         Proposal storage p = m.proposals[uint16(m.acceptedProposal)];
206 
207         m.paid = p.amount;
208         require(token.transfer(p.contractor, p.amount));
209     }   
210 
211     function balance() view public returns(uint256) {
212         return token.balanceOf(address(this));
213     }
214 
215     function pushMilestone(uint16 _parent, string _title, string _description, uint64 _deadline, bool _requiresCustomerApproval) private returns(uint16) {
216         uint16 id = uint16(milestones.length++);
217         milestones[id].parent = _parent;
218         milestones[id].title = _title;
219         milestones[id].description = _description;
220         milestones[id].deadline = _deadline;
221         milestones[id].acceptedProposal = -1;
222         milestones[id].requiresCustomerApproval = _requiresCustomerApproval;
223         emit MilestoneCreated(id, _parent, _title);
224         return id;
225     }
226 
227 }