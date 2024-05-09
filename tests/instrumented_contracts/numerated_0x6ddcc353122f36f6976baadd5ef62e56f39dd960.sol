1 pragma solidity ^0.4.19;
2 interface token {
3     function transfer(address receiver, uint amount) public;
4 }
5 contract ForeignToken {
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool);
8 }
9 
10 contract PODSSale {
11     address public beneficiary;
12     uint public fundingGoal;
13     uint public amountRaised;
14     uint public deadline;
15     uint public price;
16     token public tokenReward;
17     mapping(address => uint256) public balanceOf;
18     bool fundingGoalReached = false;
19     bool crowdsaleClosed = false;
20     event GoalReached(address recipient, uint totalAmountRaised);
21     event FundTransfer(address backer, uint amount, bool isContribution);
22     function PODSSale() public {
23         beneficiary = address(0x0D2e5bd9C6DDc363586061C6129D6122f0D7a2CB);
24         fundingGoal = 80 ether;
25         deadline = now + 43210 minutes; 
26         price = 25000;
27         tokenReward = token(address(0xEa29Ac8Bf5001592178F6Cd1275A1D0433F94C5B));
28     }
29     function () public payable {
30         require(!crowdsaleClosed);
31         uint amount = msg.value;
32         balanceOf[msg.sender] += amount;
33         amountRaised += amount;
34         tokenReward.transfer(msg.sender, amount * price);
35         FundTransfer(msg.sender, amount, true);
36     }
37     modifier afterDeadline() { if (now >= deadline) _; }
38     function checkGoalReached() public afterDeadline {
39         if (amountRaised >= fundingGoal){
40             fundingGoalReached = true;
41             GoalReached(beneficiary, amountRaised);
42         }
43         crowdsaleClosed = true;
44     }
45     function safeWithdrawal() public {
46         if (beneficiary == msg.sender) {
47                 beneficiary.transfer(this.balance);
48                 FundTransfer(beneficiary, this.balance, false);
49         }
50     }
51     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
52         if (msg.sender != beneficiary) { revert(); }
53 
54         ForeignToken tokenf = ForeignToken(_tokenContract);
55 
56         uint256 amount = tokenf.balanceOf(address(this));
57         return tokenf.transfer(beneficiary, amount);
58     }
59 }