1 pragma solidity ^0.4.0;
2 
3 contract EthProfile{
4     mapping(address=>string) public name;
5     mapping(address=>string) public description;
6     mapping(address=>string) public contact;
7     mapping(address=>string) public imageAddress;
8 
9     constructor() public{
10     }
11     
12     event Success(string status, address sender);
13 
14     function updateName(string newName) public{
15         require(bytes(newName).length <256);
16         name[msg.sender] = newName;
17         emit Success('Name Updated',msg.sender);
18     }
19     
20     function updateDescription(string newDescription) public{
21         require(bytes(newDescription).length <256);
22         description[msg.sender] = newDescription;
23         emit Success('Description Updated',msg.sender);
24     }
25     
26     function updateContact(string newContact) public{
27         require(bytes(newContact).length < 256);
28         contact[msg.sender] = newContact;
29         emit Success('Contact Updated',msg.sender);
30     }
31     
32     function updateImageAddress(string newImage) public{
33         require(bytes(newImage).length <256);
34         imageAddress[msg.sender] = newImage;
35         emit Success('Image Updated',msg.sender);
36     }
37 }