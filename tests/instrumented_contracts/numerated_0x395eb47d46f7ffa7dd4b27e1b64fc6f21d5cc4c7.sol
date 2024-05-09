1 pragma solidity ^0.4.24;
2 
3 contract Whitelist {
4 
5     address public owner;
6     mapping(address => bool) public whitelistAdmins;
7     mapping(address => bool) public whitelist;
8 
9     constructor () public {
10         owner = msg.sender;
11         whitelistAdmins[owner] = true;
12     }
13 
14     modifier onlyOwner () {
15         require(msg.sender == owner, "Only owner");
16         _;
17     }
18 
19     modifier onlyWhitelistAdmin () {
20         require(whitelistAdmins[msg.sender], "Only whitelist admin");
21         _;
22     }
23 
24     function isWhitelisted(address _addr) public view returns (bool) {
25         return whitelist[_addr];
26     }
27 
28     function addWhitelistAdmin(address _admin) public onlyOwner {
29         whitelistAdmins[_admin] = true;
30     }
31 
32     function removeWhitelistAdmin(address _admin) public onlyOwner {
33         require(_admin != owner, "Cannot remove contract owner");
34         whitelistAdmins[_admin] = false;
35     }
36 
37     function whitelistAddress(address _user) public onlyWhitelistAdmin  {
38         whitelist[_user] = true;
39     }
40 
41     function whitelistAddresses(address[] _users) public onlyWhitelistAdmin {
42         for (uint256 i = 0; i < _users.length; i++) {
43             whitelist[_users[i]] = true;
44         }
45     }
46 
47     function unWhitelistAddress(address _user) public onlyWhitelistAdmin  {
48         whitelist[_user] = false;
49     }
50 
51     function unWhitelistAddresses(address[] _users) public onlyWhitelistAdmin {
52         for (uint256 i = 0; i < _users.length; i++) {
53             whitelist[_users[i]] = false;
54         }
55     }
56 
57 }