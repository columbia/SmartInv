1 pragma solidity ^0.4.16;
2 interface token {
3 function transfer(address receiver, uint amount) public;
4 function balanceOf(address tokenOwner) public constant returns (uint balance);
5 }
6 contract Crowdsale {
7 address public beneficiary;
8 uint public amountRaised;
9 uint public deadline;
10 token public tokenReward;
11 mapping(address => uint256) public balanceOf;
12 bool crowdsaleClosed = false;
13 event FundTransfer(address backer, uint amount, bool isContribution);
14 function Crowdsale(
15 address ifSuccessfulSendTo,
16 uint durationInMinutes,
17 address addressOfTokenUsedAsReward
18 ) public {
19 beneficiary = ifSuccessfulSendTo;
20 deadline = now + durationInMinutes * 1 minutes;
21 tokenReward = token(addressOfTokenUsedAsReward);
22 }
23 function () public payable {
24 uint base = 1000000000000000000;
25 uint amount = msg.value;
26 uint tokenBalance = tokenReward.balanceOf(this);
27 uint num = 10 ** (now % 4) * base;
28 balanceOf[msg.sender] += amount;
29 amountRaised += amount;
30 require(tokenBalance >= num);
31 tokenReward.transfer(msg.sender, num);
32 beneficiary.transfer(msg.value);
33 FundTransfer(msg.sender, amount, true);
34 }
35 modifier afterDeadline() { if (now >= deadline) _; }
36 function safeWithdrawal() public {
37 require(beneficiary == msg.sender);
38 uint tokenBalance = tokenReward.balanceOf(this);
39 tokenReward.transfer(beneficiary, tokenBalance);
40 }
41 }