1 pragma solidity ^0.4.19;
2 
3 interface token {
4     function transfer(address receiver, uint amount) public;
5     function balanceOf(address _owner) public constant returns (uint balance);
6 }
7 
8 contract Crowdsale {
9     address public beneficiary = msg.sender;
10     uint public price;
11     token public tokenReward;
12     bool crowdsaleClosed = false;
13 
14     event FundTransfer(address indexed backer, uint amount, bool isContribution);
15 
16     modifier onlyBy(address _account) { require(msg.sender == _account); _; }
17 
18 
19     function Crowdsale(
20         uint szaboCostOfEachToken,
21         address addressOfTokenUsedAsReward
22     ) public {
23         price = szaboCostOfEachToken * 1 szabo;
24         tokenReward = token(addressOfTokenUsedAsReward);
25     }
26 
27     /**
28      * Fallback function
29      *
30      * The function without name is the default function that is called whenever anyone sends funds to a contract
31      */
32     function () payable public{
33         require(!crowdsaleClosed);
34         uint amount = msg.value;
35         uint tokenAmount = 1 ether * amount / price;
36         tokenReward.transfer(msg.sender, tokenAmount);
37         FundTransfer(msg.sender, amount, true);
38     }
39 
40     function endCrowdsale() onlyBy(beneficiary) public{
41         crowdsaleClosed = true;
42     }
43 
44     function withdrawEther() onlyBy(beneficiary) public {
45         beneficiary.transfer(this.balance);
46     }
47 
48     function withdrawTokens() onlyBy(beneficiary) public {
49         uint tokenBalance = tokenReward.balanceOf(this);
50 
51         tokenReward.transfer(beneficiary, tokenBalance);
52     }
53 }