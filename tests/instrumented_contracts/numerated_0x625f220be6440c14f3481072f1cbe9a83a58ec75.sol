1 pragma solidity ^0.4.15;
2 
3 contract Deposit {
4     address public Owner;
5     
6     mapping (address => uint) public deposits;
7     
8     uint public ReleaseDate;
9     bool public Locked;
10     
11     event Initialized();
12     event Deposit(uint Amount);
13     event Withdrawal(uint Amount);
14     event ReleaseDate(uint date);
15     
16     function initialize() payable {
17         Owner = msg.sender;
18         ReleaseDate = 0;
19         Locked = false;
20         Initialized();
21     }
22 
23     function setReleaseDate(uint date) public payable {
24         if (isOwner() && !Locked) {
25             ReleaseDate = date;
26             Locked = true;
27             ReleaseDate(date);
28         }
29     }
30 
31     function() payable { revert(); } // call deposit()
32     
33     function deposit() public payable {
34         if (msg.value >= 0.25 ether) {
35             deposits[msg.sender] += msg.value;
36             Deposit(msg.value);
37         }
38     }
39 
40     function withdraw(uint amount) public payable {
41         withdrawTo(msg.sender, amount);
42     }
43     
44     function withdrawTo(address to, uint amount) public payable {
45         if (isOwner() && isReleasable()) {
46             uint withdrawMax = deposits[msg.sender];
47             if (withdrawMax > 0 && amount <= withdrawMax) {
48                 to.transfer(amount);
49                 Withdrawal(amount);
50             }
51         }
52     }
53 
54     function isReleasable() public constant returns (bool) { return now >= ReleaseDate; }
55     function isOwner() public constant returns (bool) { return Owner == msg.sender; }
56 }