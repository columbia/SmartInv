1 pragma solidity ^0.4.24;
2 
3 // © 2018 SafeBlocks LTD.  All rights reserved.
4 
5 /*
6   _____            __          ____    _                  _
7  / ____|          / _|        |  _ \  | |                | |
8 | (___     __ _  | |_    ___  | |_) | | |   ___     ___  | | __  ___
9  \___ \   / _` | |  _|  / _ \ |  _ <  | |  / _ \   / __| | |/ / / __|
10  ____) | | (_| | | |   |  __/ | |_) | | | | (_) | | (__  |   <  \__ \
11 |_____/   \__,_| |_|    \___| |____/  |_|  \___/   \___| |_|\_\ |___/
12 
13 */
14 // @author SafeBlocks
15 // @date 30/04/2018
16 
17 contract SafeBlocksProxy {
18 
19     event ContractDeployed(address sourceAddress, string cid, uint blockNumber);
20     event Operation(address sourceAddress, bool approved, address token, uint amount, address destination, uint blockNumber);
21     event ConfigurationChanged(address sender, address newConfiguration, string message);
22 
23     address owner;
24     address superOwner;
25     bool isBypassMode;
26     bytes32 hashedPwd;
27     SafeBlocksFirewall safeBlocksFirewall;
28 
29     constructor(address _superOwner, bytes32 _hashedPwd) public {
30         owner = msg.sender;
31         superOwner = _superOwner;
32         hashedPwd = _hashedPwd;
33         isBypassMode = false;
34     }
35 
36     //*************************************** modifiers ****************************************
37 
38     modifier onlyContractOwner {
39         require(owner == msg.sender, "You are not allowed to run this function, required role: Contract-Owner");
40         _;
41     }
42 
43     modifier onlySuperOwner {
44         require(superOwner == msg.sender, "You are not allowed to run this function, required role: Super-Owner");
45         _;
46     }
47 
48     //* Matching  the given pwd and setting the new one in case of a successful match *//
49     modifier onlySuperOwnerWithPwd(string pwd, bytes32 newHashedPwd) {
50         bytes32 hashedInput = keccak256(abi.encodePacked(pwd));
51         require(superOwner == msg.sender && hashedInput == hashedPwd, "You are not allowed to run this function, required role: Super-Owner with Password");
52         hashedPwd = newHashedPwd;
53         _;
54     }
55 
56     //*************************************** restricted ****************************************
57 
58     function setSuperOwner(address newSuperOwner, string pwd, bytes32 newHashedPwd)
59     onlySuperOwnerWithPwd(pwd, newHashedPwd)
60     public {
61         superOwner = newSuperOwner;
62         emit ConfigurationChanged(msg.sender, newSuperOwner, "a new Super-Owner has been assigned");
63     }
64 
65     function setOwner(address newOwner, string pwd, bytes32 newHashedPwd)
66     onlySuperOwnerWithPwd(pwd, newHashedPwd)
67     public {
68         owner = newOwner;
69         emit ConfigurationChanged(msg.sender, newOwner, "a new Owner has been assigned");
70     }
71 
72     function setBypassForAll(bool _bypass)
73     onlySuperOwner
74     public {
75         isBypassMode = _bypass;
76         emit ConfigurationChanged(msg.sender, msg.sender, "a new Bypass-Mode has been assigned");
77     }
78 
79     function getBypassStatus()
80     public
81     view
82     onlyContractOwner
83     returns (bool){
84         return isBypassMode;
85     }
86 
87     function setSBFWContractAddress(address _sbfwAddress)
88     onlyContractOwner
89     public {
90         safeBlocksFirewall = SafeBlocksFirewall(_sbfwAddress);
91         emit ConfigurationChanged(msg.sender, _sbfwAddress, "a new address has been assigned to SafeBlocksFirewall");
92     }
93 
94     //*************************************** public ****************************************
95 
96     function allowTransaction(uint _amount, address _destination, address _token)
97     public
98     returns (bool) {
99         address contractAddress = msg.sender;
100 
101         if (isBypassMode) {
102             emit Operation(contractAddress, true, _token, _amount, _destination, block.number);
103             return true;
104         }
105         bool result = safeBlocksFirewall.allowTransaction(contractAddress, _amount, _destination, _token);
106         emit Operation(contractAddress, result, _token, _amount, _destination, block.number);
107         return result;
108     }
109 
110     function contractDeployedNotice(string _cid, uint _blockNumber)
111     public {
112         emit ContractDeployed(msg.sender, _cid, _blockNumber);
113     }
114 
115 }
116 
117 interface SafeBlocksFirewall {
118 
119     /*
120      * Validating the transaction according to a predefined security policy
121      */
122     function allowTransaction(
123         address _contractAddress,
124         uint _amount,
125         address _destination,
126         address _token)
127     external
128     returns(bool);
129 }
130 // © 2018 SafeBlocks LTD.  All rights reserved.