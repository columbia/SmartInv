1 pragma solidity ^0.4.2;
2 
3 contract GravatarRegistry {
4   event NewGravatar(uint id, address owner, string displayName, string imageUrl);
5   event UpdatedGravatar(uint id, address owner, string displayName, string imageUrl);
6 
7   struct Gravatar {
8     address owner;
9     string displayName;
10     string imageUrl;
11   }
12 
13   Gravatar[] public gravatars;
14 
15   mapping (uint => address) public gravatarToOwner;
16   mapping (address => uint) public ownerToGravatar;
17 
18   function createGravatar(string _displayName, string _imageUrl) public {
19     require(ownerToGravatar[msg.sender] == 0);
20     uint id = gravatars.push(Gravatar(msg.sender, _displayName, _imageUrl)) - 1;
21 
22     gravatarToOwner[id] = msg.sender;
23     ownerToGravatar[msg.sender] = id;
24 
25     emit NewGravatar(id, msg.sender, _displayName, _imageUrl);
26   }
27 
28   function getGravatar(address owner) public view returns (string, string) {
29     uint id = ownerToGravatar[owner];
30     return (gravatars[id].displayName, gravatars[id].imageUrl);
31   }
32 
33   function updateGravatarName(string _displayName) public {
34     require(ownerToGravatar[msg.sender] != 0);
35     require(msg.sender == gravatars[ownerToGravatar[msg.sender]].owner);
36 
37     uint id = ownerToGravatar[msg.sender];
38 
39     gravatars[id].displayName = _displayName;
40     emit UpdatedGravatar(id, msg.sender, _displayName, gravatars[id].imageUrl);
41   }
42 
43   function updateGravatarImage(string _imageUrl) public {
44     require(ownerToGravatar[msg.sender] != 0);
45     require(msg.sender == gravatars[ownerToGravatar[msg.sender]].owner);
46 
47     uint id = ownerToGravatar[msg.sender];
48 
49     gravatars[id].imageUrl =  _imageUrl;
50     emit UpdatedGravatar(id, msg.sender, gravatars[id].displayName, _imageUrl);
51   }
52 
53   // the gravatar at position 0 of gravatars[]
54   // is fake
55   // it's a mythical gravatar
56   // that doesn't really exist
57   // dani will invoke this function once when this contract is deployed
58   // but then no more
59   function setMythicalGravatar() public {
60     require(msg.sender == 0x8d3e809Fbd258083a5Ba004a527159Da535c8abA);
61     gravatars.push(Gravatar(0x0, " ", " "));
62   }
63 }