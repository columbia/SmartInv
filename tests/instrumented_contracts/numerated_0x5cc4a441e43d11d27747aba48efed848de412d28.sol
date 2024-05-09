1 pragma solidity ^0.4.13;
2 
3 contract Prover {
4     
5     struct Entry {
6         bool exists;
7         uint256 time;
8         uint256 value;
9     }
10     
11     // {address: {dataHash1: Entry1, dataHash2: Entry2, ...}, ...}
12     mapping (address => mapping (bytes32 => Entry)) public ledger;
13     
14     // public functions for adding and deleting entries
15     function addEntry(bytes32 dataHash) payable {
16         _addEntry(dataHash);
17     }
18     function addEntry(string dataString) payable {
19         _addEntry(sha3(dataString));
20     }
21     function deleteEntry(bytes32 dataHash) {
22         _deleteEntry(dataHash);
23     }
24     function deleteEntry(string dataString) {
25         _deleteEntry(sha3(dataString));
26     }
27     
28     // internals for adding and deleting entries
29     function _addEntry(bytes32 dataHash) internal {
30         // check that the entry doesn't exist
31         assert(!ledger[msg.sender][dataHash].exists);
32         // initialize values
33         ledger[msg.sender][dataHash].exists = true;
34         ledger[msg.sender][dataHash].time = now;
35         ledger[msg.sender][dataHash].value = msg.value;
36     }
37     function _deleteEntry(bytes32 dataHash) internal {
38         // check that the entry exists
39         assert(ledger[msg.sender][dataHash].exists);
40         uint256 rebate = ledger[msg.sender][dataHash].value;
41         delete ledger[msg.sender][dataHash];
42         if (rebate > 0) {
43             msg.sender.transfer(rebate);
44         }
45     }
46     
47     // prove functions
48     function proveIt(address claimant, bytes32 dataHash) constant
49             returns (bool proved, uint256 time, uint256 value) {
50         return status(claimant, dataHash);
51     }
52     function proveIt(address claimant, string dataString) constant
53             returns (bool proved, uint256 time, uint256 value) {
54         // compute hash of the string
55         return status(claimant, sha3(dataString));
56     }
57     function proveIt(bytes32 dataHash) constant
58             returns (bool proved, uint256 time, uint256 value) {
59         return status(msg.sender, dataHash);
60     }
61     function proveIt(string dataString) constant
62             returns (bool proved, uint256 time, uint256 value) {
63         // compute hash of the string
64         return status(msg.sender, sha3(dataString));
65     }
66     
67     // internal for returning status of arbitrary entries
68     function status(address claimant, bytes32 dataHash) internal constant
69             returns (bool, uint256, uint256) {
70         // if entry exists
71         if (ledger[claimant][dataHash].exists) {
72             return (true, ledger[claimant][dataHash].time,
73                     ledger[claimant][dataHash].value);
74         }
75         else {
76             return (false, 0, 0);
77         }
78     }
79 
80     // raw eth transactions will be returned
81     function () {
82         revert();
83     }
84     
85 }