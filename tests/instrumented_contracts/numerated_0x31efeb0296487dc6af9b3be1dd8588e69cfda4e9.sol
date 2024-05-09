1 pragma solidity 0.4.18;
2 
3 
4 /* 
5     Author: Patrick Guay @ Vanbex and Etherparty
6     patrick@vanbex.com
7 */
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 contract VancouverCharityDrive is Ownable {
52 
53 
54     mapping(address => Pledge[]) public pledges; // keeps all the pledges per address
55     mapping(address => CompanyInfo) public companies; // keeps all the names of companies per address
56     address[] public participatingCompanies;
57 
58     event PledgeCreated(address indexed pledger, uint256 amount, string companyName);
59     event PledgeUpdated(address indexed pledger, uint256 amount, string companyName);
60     event PledgeConfirmed(address indexed pledger, uint256 amount, string companyName, string txHash);
61 
62     struct CompanyInfo {
63         bool initialized;
64         string name;
65         string email;
66         string description;
67     }
68 
69     struct Pledge {
70         bool initialized;
71         uint amount; // Amount of the currency used for the pledge
72         string charityName; // Name of the charity
73         string currency; // Currency used for the pledge
74         string txHash; //  TxHash of the pledge
75         bool confirmed;
76     }
77 
78     modifier isWhiteListed() {
79         require(companies[msg.sender].initialized == true);
80         _;
81     }
82 
83     function whitelistCompany(address _companyAddress, string _companyName, string _companyEmail, string _description) public onlyOwner returns(bool) {
84         companies[_companyAddress] = CompanyInfo(true, _companyName, _companyEmail, _description);
85         participatingCompanies.push(_companyAddress);
86         return true;
87     }
88 
89     function createPledge(uint _amount, string _charityName, string _currency) public isWhiteListed returns(bool) {
90         pledges[msg.sender].push(Pledge(true, _amount, _charityName, _currency, "", false));
91         PledgeCreated(msg.sender, _amount, companies[msg.sender].name);
92         return true;
93     }
94 
95     function updatePledge(uint _amount, string _charityName, string _currency, uint _pledgeIndex) public isWhiteListed returns(bool) {
96         Pledge storage pledge = pledges[msg.sender][_pledgeIndex];
97         require(pledge.initialized == true && pledge.confirmed == false);
98         pledge.currency = _currency;
99         pledge.amount = _amount;
100         pledge.charityName = _charityName;
101         return true;
102     }
103 
104     function confirmPledge(uint _pledgeIndex, string _txHash) public isWhiteListed returns(bool) {
105         Pledge storage pledge = pledges[msg.sender][_pledgeIndex];
106         require(pledge.initialized == true && pledge.confirmed == false);
107         pledge.txHash = _txHash;
108         pledge.confirmed = true;
109         PledgeConfirmed(msg.sender, pledge.amount, companies[msg.sender].name, _txHash);
110         return true;
111     }
112 
113     function getPledge(address _companyAddress, uint _index) public view returns (uint amount, string charityName, string currency, string txHash, bool confirmed) {
114         amount = pledges[_companyAddress][_index].amount;
115         charityName = pledges[_companyAddress][_index].charityName;
116         currency = pledges[_companyAddress][_index].currency;
117         txHash = pledges[_companyAddress][_index].txHash;
118         confirmed = pledges[_companyAddress][_index].confirmed;
119     }
120 
121     function getAllCompanies() public view returns (address[]) {
122         return participatingCompanies;
123     }
124 }