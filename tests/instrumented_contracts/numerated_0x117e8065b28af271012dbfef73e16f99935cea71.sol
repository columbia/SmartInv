1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11     
12     
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20     
21     
22     /**
23     * @dev Throws if called by any account other than the owner.
24     */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29     
30     
31     /**
32     * @dev Allows the current owner to transfer control of the contract to a newOwner.
33     * @param newOwner The address to transfer ownership to.
34     */
35     function transferOwnership(address newOwner) public onlyOwner {
36         if (newOwner != address(0)) {
37             owner = newOwner;
38         }
39     }
40 
41 }
42 
43 contract Escrow is Ownable {
44     
45     enum DealState { Empty, Created, InProgress, InTrial, Finished }
46     enum Answer { NotDefined, Yes, No }
47     
48     struct Deal {
49         address customer;
50         address beneficiary;
51         address agent;
52         
53         uint256 value;
54         uint256 commission;
55         
56         uint256 endtime;
57         
58         bool customerAns;
59         bool beneficiaryAns;
60         
61         DealState state;
62     }
63     
64     mapping (uint256 => Deal) public deals;
65     uint256 lastDealId;
66     
67     function createNew(address _customer, address _beneficiary, address _agent,
68                         uint256 _value, uint256 _commision, uint256 _endtime) public onlyOwner returns (uint256) {
69         uint256 dealId = lastDealId + 1;
70         deals[dealId] = Deal(_customer, _beneficiary, _agent, _value, _commision, _endtime, false, false, DealState.Created);
71         lastDealId++;
72         return dealId;
73     }
74     
75     function pledge(uint256 _dealId) public payable {
76         require(msg.value == (deals[_dealId].value + deals[_dealId].commission));
77         deals[_dealId].state = DealState.InProgress;
78     }
79     
80     modifier onlyAgent(uint256 _dealId) {
81         require(msg.sender == deals[_dealId].agent);
82         _;
83     }
84     
85     /**
86      * @dev Сonfirm that the customer conditions are met
87      */
88     function confirmCustomer(uint256 _dealId) public {
89         require(msg.sender == deals[_dealId].customer);
90         deals[_dealId].customerAns = true;
91     }
92     
93     /**
94      * @dev Сonfirm that the beneficiary conditions are met
95      */
96     function confirmBeneficiary(uint256 _dealId) public {
97         require(msg.sender == deals[_dealId].beneficiary);
98         deals[_dealId].beneficiaryAns = true;
99     }
100     
101     /**
102      * @dev Check participants answers and change deal state
103      */
104     function finishDeal(uint256 _dealId) public onlyOwner {
105         require(deals[_dealId].state == DealState.InProgress);
106         if (deals[_dealId].customerAns && deals[_dealId].beneficiaryAns) {
107             deals[_dealId].beneficiary.transfer(deals[_dealId].value);
108             deals[_dealId].agent.transfer(deals[_dealId].commission);
109             deals[_dealId].state = DealState.Finished;
110         } else {
111             require(now >= deals[_dealId].endtime);
112             deals[_dealId].state = DealState.InTrial;
113         }
114     }
115     
116     /**
117      * @dev Return money to customer
118      */
119     function dealRevert(uint256 _dealId) public onlyAgent(_dealId) {
120         require(deals[_dealId].state == DealState.InTrial);
121         deals[_dealId].customer.transfer(deals[_dealId].value);
122         deals[_dealId].agent.transfer(deals[_dealId].commission);
123         deals[_dealId].state = DealState.Finished;
124     }
125     
126     /**
127      * @dev Confirm deal completed and transfer money to beneficiary
128      */
129     function dealConfirm(uint256 _dealId) public onlyAgent(_dealId) {
130         require(deals[_dealId].state == DealState.InTrial);
131         deals[_dealId].beneficiary.transfer(deals[_dealId].value);
132         deals[_dealId].agent.transfer(deals[_dealId].commission);
133         deals[_dealId].state = DealState.Finished;
134     }
135 }