1 pragma solidity ^0.4.24; 
2 
3 contract ETHStatement {
4 
5     /* --- EVENTS --- */
6 
7     event InvestorStatement(address indexed investor, uint amount, string email);
8 
9     /* --- FIELDS --- */
10 
11     struct Investor {
12         uint amount;
13         string email;
14     }
15 
16     mapping (address => Investor) public investors;
17     uint public totalAmount;
18 
19 
20     /* --- PUBLIC / EXTERNAL METHODS --- */
21 
22     function declare(uint amount, string email) public { 
23         require(msg.sender.balance >= amount, "You don't have enough ETH.");
24         totalAmount += amount - investors[msg.sender].amount;
25         investors[msg.sender].amount = amount; 
26         investors[msg.sender].email = email;
27 
28         emit InvestorStatement(msg.sender, amount, email);
29     }
30 
31     function declare(uint amount) public { 
32         return declare(amount, "");
33     }
34 
35     function getInvestorStatement(address investor) view public returns(uint, string) {
36         return (investors[investor].amount, investors[investor].email);
37     }
38 
39 }