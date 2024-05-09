1 pragma solidity ^0.4.18;
2 
3 contract SendToMany
4 {
5     address[] public recipients;
6     
7     function SendToMany(address[] _recipients) public
8     {
9         recipients = _recipients;
10     }
11     
12     function() payable public
13     {
14         uint256 amountOfRecipients = recipients.length;
15         for (uint256 i=0; i<amountOfRecipients; i++)
16         {
17             recipients[i].transfer(msg.value / amountOfRecipients);
18         }
19     }
20 }