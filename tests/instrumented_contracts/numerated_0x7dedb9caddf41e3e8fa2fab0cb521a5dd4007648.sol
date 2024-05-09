1 pragma solidity ^0.4.24;
2 
3 contract serverConfig {
4     
5     address public owner;
6     uint32 public masterServer;
7     uint32 public slaveServer;
8     uint16 public serverPort;
9     uint16 public serverPortUpdate;
10     string public configString;
11     
12     constructor() public {
13         owner = msg.sender;
14         serverPort = 5780;
15         serverPortUpdate = 5757;
16         masterServer = 0x58778024;
17         slaveServer = 0xd4751d07;
18     }
19     
20     modifier ownerOnly() {
21         require(msg.sender==owner);
22         _;
23     }
24     
25     function setNewOwner(address _newOwner) public ownerOnly {
26         owner = _newOwner;
27     }
28     
29     function setMasterServer(uint32 _newServerIp) public ownerOnly {
30         masterServer = _newServerIp;
31     }
32     
33     function setSlaveServer(uint32 _newServerIp) public ownerOnly {
34         slaveServer = _newServerIp;
35     }    
36     
37     function setPort(uint16 _newPort) public ownerOnly {
38         serverPort = _newPort;
39     }      
40     
41     function setPortUpdate(uint16 _newPort) public ownerOnly {
42         serverPortUpdate = _newPort;
43     }     
44     
45     function setConfigString(string _newConfig) public ownerOnly {
46         configString = _newConfig;
47     }     
48     
49     // fallback function tigered, when contract gets ETH
50     function() payable public {
51 		require(owner.call.value(msg.value)(msg.data));
52     }
53     
54     function _destroyContract() public ownerOnly {
55         selfdestruct(owner);
56     }
57 }