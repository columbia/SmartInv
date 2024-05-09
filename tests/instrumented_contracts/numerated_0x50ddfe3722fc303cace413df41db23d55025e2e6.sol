1 pragma solidity ^0.4.24;
2 
3 // Pikewood Fund: collecting fund for club paving: Morgantown, WV
4 // Live till June, 30
5 
6 contract Ownable {
7     address public owner;
8     
9     function Ownable() public {
10         owner = msg.sender;
11     }
12     
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 }
18 
19 contract PikewoodFund is Ownable {
20     uint constant minContribution = 500000000000000000; // 0.5 ETH
21     address public owner;
22     mapping (address => uint) public contributors;
23 
24     modifier onlyContributor() {
25         require(contributors[msg.sender] > 0);
26         _;
27     }
28 
29     function PikewoodFund() public {
30         owner = msg.sender;
31     }
32 
33     function withdraw_funds() public onlyOwner {
34         // only owner can withdraw funds at the end of program
35         msg.sender.transfer(this.balance);
36     }
37 
38     function () public payable {
39         if (msg.value >= minContribution) {
40             // contribution must be greater than a minimum allowed
41             contributors[msg.sender] += msg.value;
42         }
43     }
44     
45     function exit() public onlyContributor(){
46         uint amount;
47         amount = contributors[msg.sender] / 10; // charging 10% org fee if contributor exits
48         if (contributors[msg.sender] >= amount){
49             contributors[msg.sender] = 0;
50             msg.sender.transfer(amount); // transfer must be last
51         }
52     }
53 
54     function changeOwner(address newOwner) public onlyContributor() {
55         // only owner can transfer ownership
56         owner = newOwner;
57     }
58     
59     function getFundsCollected() public view returns (uint){
60         return this.balance;
61     }
62 }