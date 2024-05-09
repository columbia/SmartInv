1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract IcoStorage is Ownable {
72 
73     struct Project {
74         bool isValue; // We now can know this is an initialized struct
75         string name; // ICO company name
76         address tokenAddress; // Token's smart contract address
77         bool active;    // if true, this contract can be shown
78     }
79 
80     mapping(address => Project) public projects;
81     address[] public projectsAccts;
82 
83     function createProject(
84         string _name,
85         address _icoContractAddress,
86         address _tokenAddress
87     ) public onlyOwner returns (bool) {
88         Project storage project  = projects[_icoContractAddress]; // Create new project
89 
90         project.isValue = true; // project is initilaized and not empty
91         project.name = _name;
92         project.tokenAddress = _tokenAddress;
93         project.active = true;
94 
95         projectsAccts.push(_icoContractAddress);
96 
97         return true;
98     }
99 
100     function getProject(address _icoContractAddress) public view returns (string, address, bool) {
101         require(projects[_icoContractAddress].isValue);
102 
103         return (
104             projects[_icoContractAddress].name,
105             projects[_icoContractAddress].tokenAddress,
106             projects[_icoContractAddress].active
107         );
108     }
109 
110     function activateProject(address _icoContractAddress) public onlyOwner returns (bool) {
111         Project storage project  = projects[_icoContractAddress];
112         require(project.isValue); // Check project exists
113 
114         project.active = true;
115 
116         return true;
117     }
118 
119     function deactivateProject(address _icoContractAddress) public onlyOwner returns (bool) {
120         Project storage project  = projects[_icoContractAddress];
121         require(project.isValue); // Check project exists
122 
123         project.active = false;
124 
125         return false;
126     }
127 
128     function getProjects() public view returns (address[]) {
129         return projectsAccts;
130     }
131 
132     function countProjects() public view returns (uint256) {
133         return projectsAccts.length;
134     }
135 }