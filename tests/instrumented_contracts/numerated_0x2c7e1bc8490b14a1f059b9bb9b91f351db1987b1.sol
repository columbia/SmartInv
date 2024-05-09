1 pragma solidity 0.5.2;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner, "");
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0), "");
17         owner = newOwner;
18     }
19 
20 }
21 
22 contract Manageable is Ownable {
23     mapping(address => bool) public listOfManagers;
24 
25     modifier onlyManager() {
26         require(listOfManagers[msg.sender], "");
27         _;
28     }
29 
30     function addManager(address _manager) public onlyOwner returns (bool success) {
31         if (!listOfManagers[_manager]) {
32             require(_manager != address(0), "");
33             listOfManagers[_manager] = true;
34             success = true;
35         }
36     }
37 
38     function removeManager(address _manager) public onlyOwner returns (bool success) {
39         if (listOfManagers[_manager]) {
40             listOfManagers[_manager] = false;
41             success = true;
42         }
43     }
44 
45     function getInfo(address _manager) public view returns (bool) {
46         return listOfManagers[_manager];
47     }
48 }
49 
50 contract KYCWhitelist is Manageable {
51     mapping(address => bool) public whitelist;
52 
53     event AddressIsAdded(address participant);
54     event AddressIsRemoved(address participant);
55 
56     function addParticipant(address _participant) public onlyManager {
57         require(_participant != address(0), "");
58 
59         whitelist[_participant] = true;
60         emit AddressIsAdded(_participant);
61     }
62 
63     function removeParticipant(address _participant) public onlyManager {
64         require(_participant != address(0), "");
65 
66         whitelist[_participant] = false;
67         emit AddressIsRemoved(_participant);
68     }
69 
70     function isWhitelisted(address _participant) public view returns (bool) {
71         return whitelist[_participant];
72     }
73 }