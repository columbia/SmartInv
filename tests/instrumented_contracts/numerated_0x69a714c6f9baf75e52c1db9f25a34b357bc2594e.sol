1 pragma solidity ^0.5.0;
2 
3 contract Pass {
4     constructor(address payable targetAddress) public payable {
5         selfdestruct(targetAddress);
6     }
7 }
8 
9 interface TargetInterface {
10     function checkBalance() external view returns (uint256);
11     function withdraw() external returns (bool);
12     function stock() external view returns (uint256);
13     function withdrawStock() external;
14 }
15 
16 contract Proxy_toff {
17     
18     address payable private constant targetAddress = 0x5799D73e4C60203CA6C7dDCB083b0c74ACb4b4C3;
19     address payable private owner;
20     
21     modifier onlyOwner {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     constructor() public payable {
27         owner = msg.sender;
28     }
29     
30     function investTargetMsgValue(bool keepBalance, bool leaveStock) public payable {
31         investTargetAmount(msg.value, keepBalance, leaveStock);
32     }
33 
34     function investTargetAmount(uint256 amount, bool keepBalance, bool leaveStock) public payable onlyOwner {
35         (bool success,) = targetAddress.call.value(amount)("");
36         require(success);
37         
38         if (!leaveStock) {
39             TargetInterface target = TargetInterface(targetAddress);
40             target.withdrawStock();
41         }
42 
43         if (!keepBalance) {
44             owner.transfer(address(this).balance);
45         }
46     }
47 
48     function withdrawTarget(bool keepBalance) public payable onlyOwner {
49         TargetInterface target = TargetInterface(targetAddress);
50         uint256 targetStock = target.stock();
51         uint256 targetBalanceAvailable = targetAddress.balance - targetStock;
52         uint256 targetBalanceRequired = target.checkBalance();
53         
54         if (targetStock == 0) {
55             targetBalanceRequired++;
56         }
57 
58         if (targetBalanceRequired > targetBalanceAvailable) {
59             uint256 needAdd = targetBalanceRequired - targetBalanceAvailable;
60             
61             require(address(this).balance >= needAdd);
62             (new Pass).value(needAdd)(targetAddress);
63         }
64 
65         target.withdraw();
66         
67         if (!keepBalance) {
68             owner.transfer(address(this).balance);
69         }
70     }
71     
72     function withdraw() public onlyOwner {
73         owner.transfer(address(this).balance);
74     }
75 
76     function kill() public onlyOwner {
77         selfdestruct(owner);
78     }
79 
80     function () external payable {
81     }
82     
83 }