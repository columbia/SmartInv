1 pragma solidity ^0.4.21;
2 
3 
4 // Problem Statement
5 // ***1) User A Creates A contract with fields Contract Title Document Title, Version,
6 //  description (Max 32 Characters) Owner (Your Name or Your organization Name) 
7 // ParticipantID(with public address) Consent_Details (Max 32 Characters)
8 // ***2) User B Signs the contract
9 // ***3) User A can Verify
10 contract Agreement {
11     address private owner;
12 
13 // A struct named Contract is requred to hold objects
14     struct Contract {
15         uint id; //0
16         bytes32 contractTitle; //1
17         bytes32 documentTitle; //2
18         bytes32 version; //3
19         bytes32 description; //4
20         address participant; //5
21         bytes32 consent; //6
22         bool isSigned; //7
23     }
24 
25 // we need mapping so for contract listing 
26     mapping (uint => Contract) public contracts;
27 
28 // Contract Count holder
29     uint public contractCount;
30     
31     function Agreement () public {
32         owner = msg.sender;
33     }
34 
35 // Event when new contract is created to notifiy all clients
36     event ContractCreated(uint contractId, address participantId);
37 // Event when a contract is signed
38     event ContractSigned(uint contractId);
39     
40 // A contract can be only added by owner and user must exist;
41     function addContract(
42         bytes32 contractTitle, bytes32 documentTitle, bytes32 version,
43         bytes32 description, address participant, bytes32 consent
44         ) public {
45         require(owner == msg.sender);
46         contractCount += 1;
47         contracts[contractCount] = 
48         Contract(contractCount, contractTitle, documentTitle, version, description, participant, consent, false);
49         emit ContractCreated(contractCount, participant);
50     }
51     
52     function addMultipleContracts(
53         bytes32 contractTitle, bytes32 documentTitle, bytes32 version,
54         bytes32 description, address[] _participant, bytes32 consent
55         ) public {
56         require(owner == msg.sender);
57         uint arrayLength = _participant.length;
58         for (uint i=0; i < arrayLength; i++) {
59             contractCount += 1;
60             contracts[contractCount] = Contract(
61             contractCount, contractTitle, documentTitle,
62             version, description, _participant[i], consent, false);
63             emit ContractCreated(contractCount, _participant[i]);
64         }
65     }
66 
67 // To sign contract id needs to be valid and contract should assigned to participant and should not be signed already
68     function signContract( uint id) public {
69         require(id > 0 && id <= contractCount);
70         require(contracts[id].participant == msg.sender);
71         require(!contracts[id].isSigned);
72         contracts[id].isSigned = true;
73         emit ContractSigned(id);
74     }
75 }