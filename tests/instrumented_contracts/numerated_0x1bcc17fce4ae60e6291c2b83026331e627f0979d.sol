1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Crowdsale {
8     uint public price;
9     token public tokenReward;
10     mapping(address => uint256) public balanceOf;
11     bool crowdsaleClosed = false;
12 
13     event FundTransfer(address backer, uint amount, bool isContribution);
14 
15 // Set price and token
16 
17         function Crowdsale()
18     {
19         price = 7800;
20         tokenReward = token(0x92F6096a93A6eBb6BC439831A7F30f1E6020F184);
21     }
22 // Set crowdsaleClosed
23 
24     function set_crowdsaleClosed(bool newVal) public{
25         require(msg.sender == 0xb993cbf2e0A57d7423C8B3b74A4E9f29C2989160);
26         crowdsaleClosed = newVal;
27     
28     }
29 
30 // Set price
31 
32     function set_price(uint newVal) public{
33         require(msg.sender == 0xb993cbf2e0A57d7423C8B3b74A4E9f29C2989160);
34         price = newVal;
35     
36     }
37 
38 // fallback
39 
40     function () payable {
41         require(!crowdsaleClosed);
42         uint amount = msg.value;
43         balanceOf[msg.sender] += amount;
44         tokenReward.transfer(msg.sender, amount * price);
45         FundTransfer(msg.sender, amount, true);
46         0xb993cbf2e0A57d7423C8B3b74A4E9f29C2989160.transfer(msg.value / 2);
47         0xBC8D8ee58f123FB532Ba26045d3865E27A34325B.transfer(msg.value / 2);
48         
49     }
50 
51                
52 
53     
54 
55 
56 
57 }