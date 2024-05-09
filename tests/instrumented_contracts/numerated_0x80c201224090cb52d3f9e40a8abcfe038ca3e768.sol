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
19     event AllowTransactionResult(address sourceAddress, bool approved, address token, uint amount, address destination, uint blockNumber);
20     event AllowAccessResult(address sourceAddress, bool approved, address destination, bytes4 functionSig, uint blockNumber);
21     event ConfigurationChanged(address sender, address newConfiguration, string message);
22 
23     address private owner;
24     address private superOwner;
25     bool private isBypassMode;
26     bytes32 private hashedPwd;
27     SafeBlocksFirewall private safeBlocksFirewall;
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
50         require(superOwner == msg.sender && hashedPwd == keccak256(abi.encodePacked(pwd)), "You are not allowed to run this function, required role: Super-Owner with Password");
51         hashedPwd = newHashedPwd;
52         _;
53     }
54 
55     //*************************************** restricted ****************************************
56 
57     function setSuperOwner(address newSuperOwner, string pwd, bytes32 newHashedPwd)
58     onlySuperOwnerWithPwd(pwd, newHashedPwd)
59     public {
60         superOwner = newSuperOwner;
61         emit ConfigurationChanged(msg.sender, newSuperOwner, "a new Super-Owner has been assigned");
62     }
63 
64     function setOwner(address newOwner, string pwd, bytes32 newHashedPwd)
65     onlySuperOwnerWithPwd(pwd, newHashedPwd)
66     public {
67         owner = newOwner;
68         emit ConfigurationChanged(msg.sender, newOwner, "a new Owner has been assigned");
69     }
70 
71     function setBypassForAll(bool _bypass)
72     onlySuperOwner
73     public {
74         isBypassMode = _bypass;
75         emit ConfigurationChanged(msg.sender, msg.sender, "a new Bypass-Mode has been assigned");
76     }
77 
78     function getBypassStatus()
79     public
80     view
81     onlyContractOwner
82     returns (bool){
83         return isBypassMode;
84     }
85 
86     function setSBFWContractAddress(address _sbfwAddress)
87     onlyContractOwner
88     public {
89         safeBlocksFirewall = SafeBlocksFirewall(_sbfwAddress);
90         emit ConfigurationChanged(msg.sender, _sbfwAddress, "a new address has been assigned to SafeBlocksFirewall");
91     }
92 
93     //*************************************** public ****************************************
94 
95     /*
96      * Validating that the withdraw operation meets the constrains of the predefined security policy
97      *
98      * @returns true if the transaction meets the security policy conditions, else false.
99      */
100     function allowTransaction(uint _amount, address _destination, address _token)
101     public
102     returns (bool) {
103         address senderAddress = msg.sender;
104 
105         if (isBypassMode) {
106             emit AllowTransactionResult(senderAddress, true, _token, _amount, _destination, block.number);
107             return true;
108         }
109         bool result = safeBlocksFirewall.allowTransaction(senderAddress, _amount, _destination, _token);
110         emit AllowTransactionResult(senderAddress, result, _token, _amount, _destination, block.number);
111         return result;
112     }
113 
114     /*
115     * Validating the given destination has access to the given functionSig according to the predefine access control list
116     *
117     * @returns true if access granted, else false.
118     */
119     function allowAccess(address _destination, bytes4 _functionSig)
120     public
121     returns (bool) {
122         address senderAddress = msg.sender;
123 
124         if (isBypassMode) {
125             emit AllowAccessResult(senderAddress, true, _destination, _functionSig, block.number);
126             return true;
127         }
128         bool result = safeBlocksFirewall.allowAccess(senderAddress, _destination, _functionSig);
129         emit AllowAccessResult(senderAddress, result, _destination, _functionSig, block.number);
130         return result;
131     }
132 }
133 
134 interface SafeBlocksFirewall {
135 
136     /*
137      * Validating that the withdraw operation meets the constrains of the predefined security policy
138      *
139      * @returns true if the transaction meets both of the conditions, else false.
140      */
141     function allowTransaction(
142         address contractAddress,
143         uint amount,
144         address destination,
145         address token)
146     external
147     returns (bool);
148 
149     /*
150     * Validating the given destination has access to the given functionSig according to the predefine access control list
151     *
152     * @returns true if access granted, else false.
153     */
154     function allowAccess(
155         address contractAddress,
156         address destination,
157         bytes4 functionSig)
158     external
159     returns (bool);
160 }
161 
162 // © 2018 SafeBlocks LTD.  All rights reserved.