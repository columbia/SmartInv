1 pragma solidity ^0.4.18;
2 
3 contract Nicks {
4   mapping (address => string) private nickOfOwner;
5   mapping (string => address) private ownerOfNick;
6 
7   event Set (string indexed _nick, address indexed _owner);
8   event Unset (string indexed _nick, address indexed _owner);
9 
10   function Nicks () public {
11   }
12 
13   function nickOf (address _owner) public view returns (string _nick) {
14     return nickOfOwner[_owner];
15   }
16 
17   function ownerOf (string _nick) public view returns (address _owner) {
18     return ownerOfNick[_nick];
19   }
20 
21   function set (string _nick) public {
22     require(bytes(_nick).length > 2);
23     require(ownerOf(_nick) == address(0));
24 
25     address owner = msg.sender;
26     string storage oldNick = nickOfOwner[owner];
27 
28     if (bytes(oldNick).length > 0) {
29       Unset(oldNick, owner);
30       delete ownerOfNick[oldNick];
31     }
32 
33     nickOfOwner[owner] = _nick;
34     ownerOfNick[_nick] = owner;
35     Set(_nick, owner);
36   }
37 
38   function unset () public {
39     require(bytes(nickOfOwner[msg.sender]).length > 0);
40 
41     address owner = msg.sender;
42     string storage oldNick = nickOfOwner[owner];
43 
44     Unset(oldNick, owner);
45 
46     delete ownerOfNick[oldNick];
47     delete nickOfOwner[owner];
48   }
49 }