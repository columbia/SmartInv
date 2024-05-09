1 pragma solidity ^0.4.24;
2 
3 contract DappRadar {
4     
5     mapping(address => mapping(address => uint)) public userDetails;
6 
7     event AddUserDetails(address indexed _userAccount, address indexed _userWallet, uint _balance);
8     event CreateAccount(address indexed _account);
9 
10     constructor() public {}
11 
12     function addUserDetails(address _userWallet, uint _balance)
13         public
14         {
15             if (_userWallet != 0x0 && _balance > 0) {
16                 userDetails[msg.sender][_userWallet] = _balance;
17                 emit AddUserDetails(msg.sender, _userWallet, _balance);
18             }
19         }
20 
21     function createAccount()
22         public
23         {
24             emit CreateAccount(msg.sender);
25         }
26 
27 }