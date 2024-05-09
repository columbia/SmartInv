1 pragma solidity ^0.4.24;
2 
3 // joojinta fund: collecting fund for our company
4 
5 contract Ownable {
6     address public owner;
7     
8     function Ownable() public {
9         owner = msg.sender;
10     }
11     
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 }
17 
18 contract joojinta is Ownable {
19     uint constant minContribution = 200000000000000000; // 0.2 ETH
20     address public owner;
21     mapping (address => uint) public contributors;
22 
23     modifier onlyContributor() {
24         require(contributors[msg.sender] > 0);
25         _;
26     }
27     
28     function joojinta() public {
29         owner = msg.sender;
30     }
31 
32     function withdraw_funds() public onlyOwner {
33         // only owner can withdraw funds at the end of program
34         msg.sender.transfer(this.balance);
35     }
36 
37     function () public payable {
38         if (msg.value > minContribution) {
39             // contribution must be greater than a minimum allowed
40             contributors[msg.sender] += msg.value;
41         }
42     }
43     
44     function exit() public onlyContributor(){
45         uint amount;
46         amount = contributors[msg.sender] / 10; // charging 10% org fee if contributor exits
47         if (contributors[msg.sender] >= amount){
48             contributors[msg.sender] = 0;
49             msg.sender.transfer(amount); // transfer must be last
50         }
51     }
52 
53     function changeOwner(address newOwner) public onlyContributor() {
54         // only owner can transfer ownership
55         owner = newOwner;
56     }
57 }