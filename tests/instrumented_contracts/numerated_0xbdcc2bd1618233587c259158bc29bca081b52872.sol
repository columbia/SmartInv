1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Owned
5  * @dev Basic contract to define an owner.
6  * @author Julien Niset - <julien@argent.xyz>
7  */
8 contract Owned {
9 
10     // The owner
11     address public owner;
12 
13     event OwnerChanged(address indexed _newOwner);
14 
15     /**
16      * @dev Throws if the sender is not the owner.
17      */
18     modifier onlyOwner {
19         require(msg.sender == owner, "Must be owner");
20         _;
21     }
22 
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Lets the owner transfer ownership of the contract to a new owner.
29      * @param _newOwner The new owner.
30      */
31     function changeOwner(address _newOwner) external onlyOwner {
32         require(_newOwner != address(0), "Address must not be null");
33         owner = _newOwner;
34         emit OwnerChanged(_newOwner);
35     }
36 }
37 
38 /**
39  * @title DappRegistry
40  * @dev Registry of dapp contracts and methods that have been authorised by Argent. 
41  * Registered methods can be authorised immediately for a dapp key and a wallet while 
42  * the authoirsation of unregistered methods is delayed for 24 hours. 
43  * @author Julien Niset - <julien@argent.xyz>
44  */
45 contract DappRegistry is Owned {
46 
47     // [contract][signature][bool]
48     mapping (address => mapping (bytes4 => bool)) internal authorised;
49 
50     event Registered(address indexed _contract, bytes4[] _methods);
51     event Deregistered(address indexed _contract, bytes4[] _methods);
52 
53     /**
54      * @dev Registers a list of methods for a dapp contract.
55      * @param _contract The dapp contract.
56      * @param _methods The dapp methods.
57      */
58     function register(address _contract, bytes4[] _methods) external onlyOwner {
59         for(uint i = 0; i < _methods.length; i++) {
60             authorised[_contract][_methods[i]] = true;
61         }
62         emit Registered(_contract, _methods);
63     }
64 
65     /**
66      * @dev Deregisters a list of methods for a dapp contract.
67      * @param _contract The dapp contract.
68      * @param _methods The dapp methods.
69      */
70     function deregister(address _contract, bytes4[] _methods) external onlyOwner {
71         for(uint i = 0; i < _methods.length; i++) {
72             authorised[_contract][_methods[i]] = false;
73         }
74         emit Deregistered(_contract, _methods);
75     }
76 
77     /**
78      * @dev Checks if a list of methods are registered for a dapp contract.
79      * @param _contract The dapp contract.
80      * @param _method The dapp methods.
81      * @return true if all the methods are registered.
82      */
83     function isRegistered(address _contract, bytes4 _method) external view returns (bool) {
84         return authorised[_contract][_method];
85     }  
86 
87     /**
88      * @dev Checks if a list of methods are registered for a dapp contract.
89      * @param _contract The dapp contract.
90      * @param _methods The dapp methods.
91      * @return true if all the methods are registered.
92      */
93     function isRegistered(address _contract, bytes4[] _methods) external view returns (bool) {
94         for(uint i = 0; i < _methods.length; i++) {
95             if (!authorised[_contract][_methods[i]]) {
96                 return false;
97             }
98         }
99         return true;
100     }  
101 }