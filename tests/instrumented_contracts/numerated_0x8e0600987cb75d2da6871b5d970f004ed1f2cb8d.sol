1 pragma solidity ^0.4.6;
2 
3 contract FourWaySplit {
4 
5   // balances and account list are publicly visible
6 
7   mapping(address => uint) public beneficiaryBalance;
8   address[4] public beneficiaryList;
9 
10   // emit events for real-time listeners and state history
11 
12   event LogReceived(address sender, uint amount);
13   event LogWithdrawal(address beneficiary, uint amount);
14 
15   // give the constructor four addresses for the split
16 
17   function FourWaySplit(address addressA, address addressB, address addressC, address addressD) {
18     beneficiaryList[0]=addressA;
19     beneficiaryList[1]=addressB;
20     beneficiaryList[2]=addressC;
21     beneficiaryList[3]=addressD;
22   }
23 
24   // send ETH
25 
26   function pay() 
27     public
28     payable
29     returns(bool success)
30   {
31     if(msg.value==0) throw;
32 
33     // ignoring values not evenly divisible by 4. We round down and keep the change.
34     // (No way to remove the loose change, so it's effectively destroyed.)
35 
36     uint forth = msg.value / 4;
37 
38     beneficiaryBalance[beneficiaryList[0]] += forth;
39     beneficiaryBalance[beneficiaryList[1]] += forth;
40     beneficiaryBalance[beneficiaryList[2]] += forth;
41     beneficiaryBalance[beneficiaryList[3]] += forth;
42     LogReceived(msg.sender, msg.value);
43     return true;
44   }
45 
46   function withdraw(uint amount)
47     public
48     returns(bool success)
49   {
50     if(beneficiaryBalance[msg.sender] < amount) throw; // insufficient funds
51     beneficiaryBalance[msg.sender] -= amount;          // Optimistic accounting.
52     if(!msg.sender.send(amount)) throw;                // failed to transfer funds
53     LogWithdrawal(msg.sender, amount);
54     return true;
55   }
56 
57 }