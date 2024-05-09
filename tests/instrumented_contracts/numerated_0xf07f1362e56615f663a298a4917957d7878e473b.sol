1 pragma solidity ^0.4.18;
2 
3 // change your nickname for all YouCollect Collectible Games
4 contract Nicknames {
5   mapping (address => string) private nickOfOwner;
6   mapping (string => address) private ownerOfNick;
7 
8   event Set (string indexed _nick, address indexed _owner);
9   event Unset (string indexed _nick, address indexed _owner);
10 
11   function Nicknames () public {
12   }
13 
14   function nickOf (address _owner) public view returns (string _nick) {
15     return nickOfOwner[_owner];
16   }
17 
18   function ownerOf (string _nick) public view returns (address _owner) {
19     return ownerOfNick[_nick];
20   }
21 
22   function set (string _nick) public {
23     require(bytes(_nick).length > 2);
24     require(ownerOf(_nick) == address(0));
25 
26     address owner = msg.sender;
27     string storage oldNick = nickOfOwner[owner];
28 
29     if (bytes(oldNick).length > 0) {
30       Unset(oldNick, owner);
31       delete ownerOfNick[oldNick];
32     }
33 
34     nickOfOwner[owner] = _nick;
35     ownerOfNick[_nick] = owner;
36     Set(_nick, owner);
37   }
38 
39   function unset () public {
40     require(bytes(nickOfOwner[msg.sender]).length > 0);
41 
42     address owner = msg.sender;
43     string storage oldNick = nickOfOwner[owner];
44 
45     Unset(oldNick, owner);
46 
47     delete ownerOfNick[oldNick];
48     delete nickOfOwner[owner];
49   }
50 }