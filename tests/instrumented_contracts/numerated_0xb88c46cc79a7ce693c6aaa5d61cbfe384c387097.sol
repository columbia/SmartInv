1 pragma solidity ^0.4.25;
2 
3 contract owned {
4     address public owner;
5     mapping (address => bool) public owners;
6     
7     constructor() public {
8         owner = msg.sender;
9         owners[msg.sender] = true;
10     }
11     
12     modifier zeus {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     modifier athena {
18         require(owners[msg.sender] == true);
19         _;
20     }
21 
22     function addOwner(address _newOwner) zeus public {
23         owners[_newOwner] = true;
24     }
25     
26     function removeOwner(address _oldOwner) zeus public {
27         owners[_oldOwner] = false;
28     }
29     
30     function transferOwnership(address newOwner) public zeus {
31         owner = newOwner;
32         owners[newOwner] = true;
33         owners[owner] = false;
34     }
35 }
36 
37 
38 contract cgkgame is owned {
39     
40     mapping (string => string) cards;
41 
42     function saveCard(string _gameid, string _cards) athena public {
43         cards[_gameid] = _cards;
44     }
45     
46     function getCard(string _gameid) view public returns (string) {
47         return cards[_gameid];
48     }
49     
50 }