1 pragma solidity 0.4.15;
2 
3 
4 /// @title Abstract oracle contract - Functions to be implemented by oracles
5 contract Oracle {
6 
7     function isOutcomeSet() public constant returns (bool);
8     function getOutcome() public constant returns (int);
9 }
10 
11 
12 
13 /// @title Centralized oracle contract - Allows the contract owner to set an outcome
14 /// @author Stefan George - <stefan@gnosis.pm>
15 contract CentralizedOracle is Oracle {
16 
17     /*
18      *  Events
19      */
20     event OwnerReplacement(address indexed newOwner);
21     event OutcomeAssignment(int outcome);
22 
23     /*
24      *  Storage
25      */
26     address public owner;
27     bytes public ipfsHash;
28     bool public isSet;
29     int public outcome;
30 
31     /*
32      *  Modifiers
33      */
34     modifier isOwner () {
35         // Only owner is allowed to proceed
36         require(msg.sender == owner);
37         _;
38     }
39 
40     /*
41      *  Public functions
42      */
43     /// @dev Constructor sets owner address and IPFS hash
44     /// @param _ipfsHash Hash identifying off chain event description
45     function CentralizedOracle(address _owner, bytes _ipfsHash)
46         public
47     {
48         // Description hash cannot be null
49         require(_ipfsHash.length == 46);
50         owner = _owner;
51         ipfsHash = _ipfsHash;
52     }
53 
54     /// @dev Replaces owner
55     /// @param newOwner New owner
56     function replaceOwner(address newOwner)
57         public
58         isOwner
59     {
60         // Result is not set yet
61         require(!isSet);
62         owner = newOwner;
63         OwnerReplacement(newOwner);
64     }
65 
66     /// @dev Sets event outcome
67     /// @param _outcome Event outcome
68     function setOutcome(int _outcome)
69         public
70         isOwner
71     {
72         // Result is not set yet
73         require(!isSet);
74         isSet = true;
75         outcome = _outcome;
76         OutcomeAssignment(_outcome);
77     }
78 
79     /// @dev Returns if winning outcome is set
80     /// @return Is outcome set?
81     function isOutcomeSet()
82         public
83         constant
84         returns (bool)
85     {
86         return isSet;
87     }
88 
89     /// @dev Returns outcome
90     /// @return Outcome
91     function getOutcome()
92         public
93         constant
94         returns (int)
95     {
96         return outcome;
97     }
98 }
99 
100 
101 
102 /// @title Centralized oracle factory contract - Allows to create centralized oracle contracts
103 /// @author Stefan George - <stefan@gnosis.pm>
104 contract CentralizedOracleFactory {
105 
106     /*
107      *  Events
108      */
109     event CentralizedOracleCreation(address indexed creator, CentralizedOracle centralizedOracle, bytes ipfsHash);
110 
111     /*
112      *  Public functions
113      */
114     /// @dev Creates a new centralized oracle contract
115     /// @param ipfsHash Hash identifying off chain event description
116     /// @return Oracle contract
117     function createCentralizedOracle(bytes ipfsHash)
118         public
119         returns (CentralizedOracle centralizedOracle)
120     {
121         centralizedOracle = new CentralizedOracle(msg.sender, ipfsHash);
122         CentralizedOracleCreation(msg.sender, centralizedOracle, ipfsHash);
123     }
124 }