1 pragma solidity ^0.4.0;
2 
3 contract IProperty {
4     event RegistrationCreated(address indexed registrant, bytes32 indexed hash, uint blockNumber, string description);
5     event RegistrationUpdated(address indexed registrant, bytes32 indexed hash, uint blockNumber, string description);
6 
7     struct Registration {
8         address registrant;
9         bytes32 hash;
10         uint blockNumber;
11         string description;
12     }
13 
14     mapping(bytes32 => Registration) registrations;
15 
16     function register(bytes32 hash, string description) public {
17 
18         Registration storage registration = registrations[hash];
19 
20         if (registration.registrant == address(0)) {         // this is the first registration of this hash
21             registration.registrant = msg.sender;
22             registration.hash = hash;
23             registration.blockNumber = block.number;
24             registration.description = description;
25 
26             emit RegistrationCreated(msg.sender, hash, block.number, description);
27         }
28         else if (registration.registrant == msg.sender) {    // this is an update coming from the first owner
29             registration.description = description;
30 
31             emit RegistrationUpdated(msg.sender, hash, registration.blockNumber, description);
32         }
33         else
34             revert("only owner can change his registration");
35 
36     }
37 
38     function retrieve(bytes32 hash) public view returns (address, bytes32, uint, string) {
39 
40         Registration storage registration = registrations[hash];
41 
42         return (registration.registrant, registration.hash, registration.blockNumber, registration.description);
43 
44     }
45 }