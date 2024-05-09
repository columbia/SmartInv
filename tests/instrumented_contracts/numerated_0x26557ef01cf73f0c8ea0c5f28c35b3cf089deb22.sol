1 pragma solidity ^0.4.15;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17   /**
18    * @dev Throws if called by any account other than the owner.
19    */
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) onlyOwner public {
29     require(newOwner != address(0));
30     OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33 }
34 contract Esla is Ownable{
35 	struct PersonalInfo{
36 		string full_name;
37 		string company;
38 		string job_title;
39 		string email;
40 		string mobile;
41 		string telephone;
42 		string fax;
43 	}
44 	mapping (address => PersonalInfo) personalInfos;
45 	address[] public users;
46 	mapping (address => bool) authorized;
47 	event Authorized(address indexed user_wallet_address);
48   event DeAuthorized(address indexed user_wallet_address);
49   event PersonalInfoAdded(address indexed user_wallet_address, string full_name, string company, 
50 		string job_title, string email, string mobile, string telephone, string fax);
51 	function Esla(){
52 		owner = msg.sender;
53 		authorized[owner] = true;
54 	}
55 	function authorize(address user_wallet_address) public onlyOwner{
56 		authorized[user_wallet_address] = true;
57 		Authorized(user_wallet_address);
58 	}
59 	function deAuthorize(address user_wallet_address) public onlyOwner{
60 		authorized[user_wallet_address] = false;
61 		DeAuthorized(user_wallet_address);
62 	}
63 	function isAuthorized(address user_wallet_address) public constant returns (bool){
64 		return authorized[user_wallet_address];
65 	}
66   modifier allowedToAdd() {
67     require(authorized[msg.sender]);
68     _;
69   }
70 	function addPersonalInfo(address user_wallet_address, string _full_name, string _company, 
71 		string _job_title, string _email, string _mobile, string _telephone, string _fax) public allowedToAdd returns (bool){
72 		personalInfos[user_wallet_address] = PersonalInfo(_full_name, _company, _job_title, _email, _mobile, _telephone, _fax);
73 		PersonalInfo storage personalInfo = personalInfos[user_wallet_address];
74 		users.push(user_wallet_address);
75 		PersonalInfoAdded(user_wallet_address, personalInfo.full_name, personalInfo.company, personalInfo.job_title, 
76 			personalInfo.email, personalInfo.mobile, personalInfo.telephone, personalInfo.fax);
77 		return true;
78 	}
79 	function getPersonalInfo(address user_wallet_address) public constant returns (string, string, string, string, 
80 		string, string, string){
81 		PersonalInfo storage personalInfo = personalInfos[user_wallet_address];
82 		return (personalInfo.full_name, personalInfo.company, personalInfo.job_title, 
83 			personalInfo.email, personalInfo.mobile, personalInfo.telephone, personalInfo.fax);
84 	}
85 	function getUserCount() public constant returns (uint){
86 		return users.length;
87 	}
88 }