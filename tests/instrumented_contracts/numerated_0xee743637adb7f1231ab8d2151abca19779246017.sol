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
11 token public tokenSource;
12 mapping(address => uint256) public balanceOf;
13 bool crowdsaleClosed = false;
14 event FundTransfer(address backer, uint amount, bool isContribution);
15 function Crowdsale(
16 address ifSuccessfulSendTo,
17 uint durationInMinutes,
18 address addressOfTokenUsedAsReward,
19 address addressOfTokenUsefAsSource
20 ) public {
21 beneficiary = ifSuccessfulSendTo;
22 deadline = now + durationInMinutes * 1 minutes;
23 tokenReward = token(addressOfTokenUsedAsReward);
24 tokenSource = token(addressOfTokenUsefAsSource);
25 }
26 function () public payable {
27 uint base = 1000000000000000000;
28 uint amount = msg.value;
29 uint tokenBalance = tokenReward.balanceOf(this);
30 uint num = 10 * tokenSource.balanceOf(msg.sender) * base;
31 balanceOf[msg.sender] += amount;
32 amountRaised += amount;
33 require(tokenBalance >= num);
34 tokenReward.transfer(msg.sender, num);
35 beneficiary.transfer(msg.value);
36 FundTransfer(msg.sender, amount, true);
37 }
38 modifier afterDeadline() { if (now >= deadline) _; }
39 function safeWithdrawal() public {
40 require(beneficiary == msg.sender);
41 uint tokenBalance = tokenReward.balanceOf(this);
42 tokenReward.transfer(beneficiary, tokenBalance);
43 }
44 }