1 pragma solidity ^0.4.13;
2 
3 
4 contract BM_MasterClass_Reserved {
5     mapping (address => uint256) public holders;
6     uint256 public amount_investments = 0;
7     uint256 public countHolders = 0;
8 
9     uint256 public dtStart = 1502737200; //14.08.2017 22:00 MSK
10     uint256 public dtEnd = 1502910000; //16.08.2017 22:00 MSK
11 
12     uint256 public minSizeInvest = 100 finney;
13 
14     address public owner;
15 
16     event Investment(address holder, uint256 value);
17 
18     function BM_MasterClass_Reserved(){
19         owner = msg.sender;
20     }
21 
22     modifier isOwner()
23     {
24         assert(msg.sender == owner);
25         _;
26     }
27 
28     function changeOwner(address new_owner) isOwner {
29         assert(new_owner!=address(0x0));
30         assert(new_owner!=address(this));
31         owner = new_owner;
32     }
33 
34     function getDataHolders(address holder) external constant returns(uint256)
35     {
36         return holders[holder];
37     }
38 
39     function sendInvestmentsToOwner() isOwner {
40         assert(now >= dtEnd);
41         owner.transfer(this.balance);
42     }
43 
44     function () payable {
45         assert(now < dtEnd);
46         assert(now >= dtStart);
47         assert(msg.value>=minSizeInvest);
48 
49         if(holders[msg.sender] == 0){
50             countHolders += 1;
51         }
52         holders[msg.sender] += msg.value;
53         amount_investments += msg.value;
54         Investment(msg.sender, msg.value);
55     }
56 }