1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 contract EthVerifyCore{
4     address public ceoAddress;
5     mapping(address=>bool) public admins;
6     mapping(address=>bool) public approvedContracts;
7     mapping (address => bool) private verifiedUsers;
8     
9   modifier onlyCEO() {
10     require(msg.sender == ceoAddress);
11     _;
12   }
13   modifier onlyAdmin() {
14     require(admins[msg.sender]);
15     _;
16   }
17     
18     function EthVerifyCore() public{
19         ceoAddress=msg.sender;
20         admins[ceoAddress]=true;
21     }
22     function setCEO(address newCEO) public onlyCEO{
23         ceoAddress=newCEO;
24     }
25     function addAdmin(address admin) public onlyCEO{
26         admins[admin]=true;
27     }
28     function removeAdmin(address admin) public onlyCEO{
29         admins[admin]=false;
30     }
31     function approveUser(address user) public onlyAdmin{
32         verifiedUsers[user]=true;
33     }
34     function approveUsers(address[] addresses) public onlyAdmin{
35         for(uint i = 0; i<addresses.length; i++){
36             verifiedUsers[addresses[i]]=true;
37         }
38     }
39     function disApproveUsers(address[] addresses) public onlyAdmin{
40         for(uint i = 0; i<addresses.length; i++){
41             verifiedUsers[addresses[i]]=false;
42         }
43     }
44     function getUserStatus(address user) public view onlyAdmin returns(bool){
45         return verifiedUsers[user];
46     }
47 }