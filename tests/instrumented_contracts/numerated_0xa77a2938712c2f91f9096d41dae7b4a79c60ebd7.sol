1 pragma solidity ^0.4.18;
2 
3 contract ctf {
4     address public owner;
5     // uint public secret;
6     uint private flag; //no public, it's a secret;
7 
8     /* CONSTRUCTOR */
9     function ctf(uint _flag) public { 
10       owner = msg.sender;
11       flag = _flag;
12     }
13 
14     /* let me change the secret just in case I want to */
15     function change_flag(uint newflag) public {
16       require(msg.sender == owner); //make sure it's me
17       flag = newflag;
18     }
19 
20     function() payable public {
21       return;
22     }
23     // don't need it anymore
24     function kill(address _to) public {
25       require(msg.sender == owner);
26       selfdestruct(_to);
27     }
28 }