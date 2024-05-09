1 pragma solidity ^0.4.16;
2 
3 contract TWQCrowdsale {
4     address public owner;
5     uint256 public amount;
6     uint256 public hard_limit;
7     uint256 public token_price;
8     mapping (address => uint256) public tokens_backed;
9     address public contract_admin;
10     
11     event FundTransfer(address backer, uint256 amount_paid);
12     event Withdrawal(address owner, uint256 total_amount);
13     event CrowdsaleStatus(bool active);
14     
15     function TWQCrowdsale (address crowdsale_owner, uint256 set_limit, uint256 price) public {
16         owner = crowdsale_owner;
17         hard_limit = set_limit * 1 ether;
18         token_price = price * 100 szabo;
19         contract_admin = msg.sender;
20     }
21     
22     function () public payable {
23         if (msg.value < 0.01 ether) revert();
24         if (msg.value + amount > hard_limit) revert();
25         FundTransfer(msg.sender, msg.value);
26         amount += msg.value;
27         tokens_backed[msg.sender] += msg.value / token_price;
28     }
29     
30     modifier authorized {
31         if (msg.sender != contract_admin) revert (); 
32         _;
33     }
34     
35     function owner_withdrawal(uint256 withdraw_amount) authorized public {
36         withdraw_amount = withdraw_amount * 100 szabo;
37         Withdrawal(owner, withdraw_amount);
38         owner.transfer(withdraw_amount);
39     }
40     
41     function add_hard_limit(uint256 additional_limit) authorized  public {
42         hard_limit += additional_limit * 1 ether;
43     }
44 }