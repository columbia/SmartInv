1 pragma solidity ^0.4.11;
2 
3 // Brag about how much ethereum is in your address
4 // Visit cryptobragging.com to learn more
5 contract BraggingContract {
6     // The address with the largest balance seen so far.
7     address public richest;
8     
9     // The string that will be displayed on cryptobragging.com
10     string public displayString;
11     
12     // The highest balance seen so far.
13     uint public highestBalance;
14     
15     address owner;
16 
17     function BraggingContract() public payable {
18         owner = msg.sender;
19         highestBalance = 0;
20     }
21 
22     function becomeRichest(string newString) public payable {
23         // A tip for server costs and to prevent spam. Thanks!
24         require(msg.value > 0.002 ether);
25         
26         // Check the sender's balance is higher
27         require(msg.sender.balance > highestBalance);
28         
29         // Cap the string length for the website.
30         require(bytes(newString).length < 500);
31         
32         highestBalance = msg.sender.balance;
33         richest = msg.sender;
34         displayString = newString;
35     }
36     
37     function withdrawTips() public {
38         owner.transfer(this.balance);
39     }
40 }