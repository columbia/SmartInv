1 pragma solidity ^0.4.18;
2 
3 contract SendToMany
4 {
5     address owner;
6     
7     address[] public recipients;
8     
9     function SendToMany() public
10     {
11         owner = msg.sender;
12     }
13     
14     function setRecipients(address[] newRecipientsList) public
15     {
16         require(msg.sender == owner);
17         
18         recipients = newRecipientsList;
19     }
20     
21     function addRecipient(address newRecipient) public
22     {
23         recipients.push(newRecipient);
24     }
25     
26     function sendToAll(uint256 amountPerRecipient) payable public
27     {
28         for (uint256 i=0; i<recipients.length; i++)
29         {
30             recipients[i].transfer(amountPerRecipient);
31         }
32     }
33 }