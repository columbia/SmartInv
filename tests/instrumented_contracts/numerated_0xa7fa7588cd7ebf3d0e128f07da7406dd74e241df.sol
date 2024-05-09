1 pragma solidity ^0.4.16;
2 
3 contract TWQCrowdsale {
4     address public owner;
5     uint256 public amount;
6     uint256 public hard_limit;
7     uint256 public token_price;
8     mapping (address => uint256) public tokens_backed;
9     address public contract_admin;
10     uint256 public start_block;
11     uint256 public end_block;
12     
13     event FundTransfer(address backer, uint256 amount_paid);
14     event Withdrawal(address owner, uint256 total_amount);
15     
16     function TWQCrowdsale (address crowdsale_owner, uint256 set_limit, uint256 price, uint256 time_limit) public {
17         owner = crowdsale_owner;
18         hard_limit = set_limit * 1 ether;
19         token_price = price * 100 szabo;
20         contract_admin = msg.sender;
21         start_block = block.number;
22         end_block = ((time_limit * 1 hours) / 15 seconds) + start_block;
23     }
24     
25     function () public payable {
26         if (msg.value < 0.01 ether || msg.value + amount > hard_limit) revert();
27         if (block.number < start_block || block.number > end_block) revert();
28         FundTransfer(msg.sender, msg.value);
29         amount += msg.value;
30         tokens_backed[msg.sender] += msg.value / token_price;
31     }
32     
33     modifier authorized {
34         if (msg.sender != contract_admin) revert (); 
35         _;
36     }
37     
38     function owner_withdrawal(uint256 withdraw_amount) authorized public {
39         withdraw_amount = withdraw_amount * 100 szabo;
40         Withdrawal(owner, withdraw_amount);
41         owner.transfer(withdraw_amount);
42     }
43     
44     function add_hard_limit(uint256 additional_limit) authorized  public {
45         hard_limit += additional_limit * 100 szabo;
46     }
47     
48     function change_start_block(uint256 new_block) authorized public {
49         start_block = new_block;
50     }
51     
52     function extend_end_block(uint256 end_time_period) authorized public {
53         end_block += ((end_time_period * 1 hours) / 15 seconds); 
54     }
55     
56     function shorten_end_block(uint256 end_time_period) authorized public {
57         end_block -= ((end_time_period * 1 hours) / 15 seconds);
58     }
59     
60     function set_end_block(uint256 block_number) authorized public {
61         end_block = block_number;
62     }
63     
64     function end_now() authorized public {
65         end_block = block.number;
66     }
67 }