1 pragma solidity ^0.4.18;
2 
3 contract Usernames {
4     
5     mapping(address => string) private usernames;
6     mapping(string => int) private dedupeList;
7     
8     event NewUsername(address indexed _user, string indexed _username);
9     
10     function Usernames() public {
11         
12     }
13     
14     function getUsername(address _user) public view returns (string) {
15         return usernames[_user];
16     }
17     
18     function checkDupe(string _userName) public constant returns (int) {
19         return dedupeList[_userName];
20     }
21 
22     function createUsername(string _userName) external returns (bool) {
23         require(bytes(usernames[msg.sender]).length == 0);
24         require(dedupeList[_userName] == 0);
25         require(bytes(_userName).length >= 3 && bytes(_userName).length <= 16);
26         
27         usernames[msg.sender] = _userName;
28         dedupeList[_userName] = 1;
29         NewUsername(msg.sender, _userName);
30         
31         return true;
32     }
33     
34 }