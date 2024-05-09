1 pragma solidity ^0.4.11;
2 
3 // Brag about how much ethereum is in your address
4 // Visit cryptobragging.com to learn more
5 contract BraggerContract {
6     // The address that paid the most
7     address public richest;
8     
9     // The string that will be displayed on cryptobragging.com
10     string public displayString;
11     
12     // The highest payment so far
13     uint public highestBalance;
14     
15     address owner;
16 
17     function BraggerContract() public payable {
18         owner = msg.sender;
19         highestBalance = 0;
20     }
21 
22     function becomeRichest(string newString) public payable {
23         // Ensure the sender is paying more than the highest so far.
24         require(msg.value > highestBalance);
25         
26         // Cap the string length for the website.
27         require(bytes(newString).length < 500);
28         
29         highestBalance = msg.value;
30         richest = msg.sender;
31         displayString = newString;
32     }
33     
34     function withdrawBalance() public {
35         owner.transfer(this.balance);
36     }
37 }