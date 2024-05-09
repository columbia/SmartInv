1 pragma solidity ^0.4.20;
2 
3 // Upload URL contract for Item Market game. Everyone can upload URLs for all ID's (cannot be prevented on blockchain) 
4 // However, UI will only check owner data.
5 
6 contract UploadIMG{
7     
8     // Addres => ID => URL
9     mapping(address => mapping(uint256 => string)) public Data;
10     
11     function UploadIMG() public {
12  
13     }
14     // This can be changed!
15     function UploadURL(uint256 ID, string URL) public {
16         Data[msg.sender][ID] = URL;
17     }
18 
19     function GetURL(address ADDR, uint256 ID) public returns (string) {
20         return Data[ADDR][ID];
21     }
22     
23     // If someone sends eth, send back immediately.
24     function() payable public{
25         if (msg.value > 0){
26             msg.sender.transfer(msg.value);
27         }
28     }
29 }