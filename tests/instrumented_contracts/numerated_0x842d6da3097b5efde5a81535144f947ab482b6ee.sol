1 pragma solidity ^0.4.16;
2 
3 
4 contract WhoTheEth {
5     
6     address owner;
7     uint public numberOfNames;
8     mapping(address => string) public names;
9     mapping(address => uint) public bank;
10 
11     event AddedName(
12         address indexed _address,
13         string _name,
14         uint _time,
15         address indexed _referrer,
16         uint _value
17     );
18     
19     function WhoTheEth() public {
20         owner = msg.sender;
21     }
22     
23     function pullFunds() public {
24         require (bank[msg.sender] > 0);
25         uint value = bank[msg.sender];
26         bank[msg.sender] = 0;
27         msg.sender.transfer(value);
28     }
29     
30     function setName(string newName) payable public {
31         require(msg.value >= 1 finney || numberOfNames < 500);
32         numberOfNames++;
33         names[msg.sender] = newName;
34         bank[owner] += msg.value;
35         AddedName(msg.sender, newName, now, owner, msg.value);
36     }
37     
38         
39     function setNameRefer(string newName, address ref) payable public {
40         require(msg.value >= 1 finney || numberOfNames < 500);
41         require(msg.sender != ref);
42         numberOfNames++;
43         names[msg.sender] = newName;
44         bank[owner] += msg.value / 10;
45         bank[ref] += msg.value - (msg.value / 10);
46         AddedName(msg.sender, newName, now, ref, msg.value);
47     }
48     
49 
50 }