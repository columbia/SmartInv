1 pragma solidity ^0.4.8;
2 
3 // an interface to ERC20 contracts
4 // only adds the signatures for the methods we need for withdrawals
5 contract ERC20 {
6   function balanceOf(address _owner) public constant returns (uint balance);
7   function transfer(address _to, uint256 _value) public returns (bool success);
8 }
9 
10 contract Capsule {
11     // store the eventual recipient of the capsule
12     // who will be allowed to withdraw when the time comes
13     address public recipient;
14     // the date of the eventual excavation store in seconds from epoch
15     uint public excavation;
16     // your friends at ETHCapsule, thanks for your support!
17     address public company = 0x46D99c89AE7529DDBAC80BEA2e8Ae017471Fc630;
18     // percentage of funds shared at withdrawal
19     uint public percent = 2;
20 
21     // event for capsule creation with pertinent details
22     event CapsuleCreated(
23         uint _excavation,
24         address _recipient
25     );
26 
27     // constructor for the capsule
28     // must put in an eventual excavation date and the recipient address
29     // also allows sending ETH as well as listing new tokens
30     function Capsule(uint _excavation, address _recipient) payable public {
31       require(_excavation < (block.timestamp + 100 years));
32       recipient = _recipient;
33       excavation = _excavation;
34       CapsuleCreated(_excavation, _recipient);
35     }
36 
37     // event for a fallback payable deposit
38     event Deposit(
39         uint _amount,
40         address _sender
41     );
42 
43     // this method accepts ether at any point as a way
44     // of facilitating groups pooling their resources
45     function () payable public {
46       Deposit(msg.value, msg.sender);
47     }
48 
49     // The event any ether is withdrawn
50     event EtherWithdrawal(
51       uint _amount
52     );
53 
54     // The event any time an ERC20 token is withdrawn
55     event TokenWithdrawal(
56       address _tokenAddress,
57       uint _amount
58     );
59 
60     // allows for the withdrawal of ECR20 tokens and Ether!
61     // must be the intended recipient after the excavation date
62     function withdraw(address[] _tokens) public {
63       require(msg.sender == recipient);
64       require(block.timestamp > excavation);
65 
66       // withdraw ether
67       if(this.balance > 0) {
68         uint ethShare = this.balance / (100 / percent);
69         company.transfer(ethShare);
70         uint ethWithdrawal = this.balance;
71         msg.sender.transfer(ethWithdrawal);
72         EtherWithdrawal(ethWithdrawal);
73       }
74 
75       // withdraw listed ERC20 tokens
76       for(uint i = 0; i < _tokens.length; i++) {
77         ERC20 token = ERC20(_tokens[i]);
78         uint tokenBalance = token.balanceOf(this);
79         if(tokenBalance > 0) {
80           uint tokenShare = tokenBalance / (100 / percent);
81           token.transfer(company, tokenShare);
82           uint tokenWithdrawal = token.balanceOf(this);
83           token.transfer(recipient, tokenWithdrawal);
84           TokenWithdrawal(_tokens[i], tokenWithdrawal);
85         }
86       }
87     }
88 }