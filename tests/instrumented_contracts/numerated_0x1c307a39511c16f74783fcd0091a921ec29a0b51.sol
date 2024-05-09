1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 //EthVerify.net
4 contract EthVerifyCore{
5     address public ceoAddress;
6     mapping(address=>bool) public admins;
7     mapping(address=>bool) public approvedContracts;
8 
9     //Use this variable to access info on addresses, ie require(ethVerify.verifiedUsers(msg.sender));
10     mapping (address => bool) public verifiedUsers;
11 
12   modifier onlyCEO() {
13     require(msg.sender == ceoAddress);
14     _;
15   }
16   modifier onlyAdmin() {
17     require(admins[msg.sender]);
18     _;
19   }
20 
21     function EthVerifyCore() public{
22         ceoAddress=msg.sender;
23         admins[ceoAddress]=true;
24     }
25     function setCEO(address newCEO) public onlyCEO{
26         ceoAddress=newCEO;
27     }
28     function addAdmin(address admin) public onlyCEO{
29         admins[admin]=true;
30     }
31     function removeAdmin(address admin) public onlyCEO{
32         admins[admin]=false;
33     }
34     function approveUser(address user) public onlyAdmin{
35         verifiedUsers[user]=true;
36     }
37     function approveUsers(address[] addresses) public onlyAdmin{
38         for(uint i = 0; i<addresses.length; i++){
39             verifiedUsers[addresses[i]]=true;
40         }
41     }
42     function disApproveUsers(address[] addresses) public onlyAdmin{
43         for(uint i = 0; i<addresses.length; i++){
44             verifiedUsers[addresses[i]]=false;
45         }
46     }
47 }