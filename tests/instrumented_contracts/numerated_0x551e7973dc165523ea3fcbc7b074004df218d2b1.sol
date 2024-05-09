1 pragma solidity ^0.4.4;
2 /**
3  * @title Contract for object that have an owner
4  */
5 contract Owned {
6     /**
7      * Contract owner address
8      */
9     address public owner;
10 
11     /**
12      * @dev Store owner on creation
13      */
14     function Owned() { owner = msg.sender; }
15 
16     /**
17      * @dev Delegate contract to another person
18      * @param _owner is another person address
19      */
20     function delegate(address _owner) onlyOwner
21     { owner = _owner; }
22 
23     /**
24      * @dev Owner check modifier
25      */
26     modifier onlyOwner { if (msg.sender != owner) throw; _; }
27 }
28 
29 
30 /**
31  * @title Contract for objects that can be morder
32  */
33 contract Mortal is Owned {
34     /**
35      * @dev Destroy contract and scrub a data
36      * @notice Only owner can kill me
37      */
38     function kill() onlyOwner
39     { suicide(owner); }
40 }
41 
42 
43 contract Comission is Mortal {
44     address public ledger;
45     bytes32 public taxman;
46     uint    public taxPerc;
47 
48     /**
49      * @dev Comission contract constructor
50      * @param _ledger Processing ledger contract
51      * @param _taxman Tax receiver account
52      * @param _taxPerc Processing tax in percent
53      */
54     function Comission(address _ledger, bytes32 _taxman, uint _taxPerc) {
55         ledger  = _ledger;
56         taxman  = _taxman;
57         taxPerc = _taxPerc;
58     }
59 
60     /**
61      * @dev Refill ledger with comission
62      * @param _destination Destination account
63      */
64     function process(bytes32 _destination) payable returns (bool) {
65         // Handle value below 100 isn't possible
66         if (msg.value < 100) throw;
67 
68         var tax = msg.value * taxPerc / 100; 
69         var refill = bytes4(sha3("refill(bytes32)")); 
70         if ( !ledger.call.value(tax)(refill, taxman)
71           || !ledger.call.value(msg.value - tax)(refill, _destination)
72            ) throw;
73         return true;
74     }
75 }
76 
77 
78 library CreatorComission {
79     function create(address _ledger, bytes32 _taxman, uint256 _taxPerc) returns (Comission)
80     { return new Comission(_ledger, _taxman, _taxPerc); }
81 
82     function version() constant returns (string)
83     { return "v0.5.0 (a9ea4c6c)"; }
84 
85     function abi() constant returns (string)
86     { return '[{"constant":false,"inputs":[{"name":"_destination","type":"bytes32"}],"name":"process","outputs":[{"name":"","type":"bool"}],"payable":true,"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"taxman","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"ledger","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"}],"name":"delegate","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"taxPerc","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"_ledger","type":"address"},{"name":"_taxman","type":"bytes32"},{"name":"_taxPerc","type":"uint256"}],"type":"constructor"}]'; }
87 }
88 
89 
90 /**
91  * @title Builder based contract
92  */
93 contract Builder is Mortal {
94     /**
95      * @dev this event emitted for every builded contract
96      */
97     event Builded(address indexed client, address indexed instance);
98  
99     /* Addresses builded contracts at sender */
100     mapping(address => address[]) public getContractsOf;
101  
102     /**
103      * @dev Get last address
104      * @return last address contract
105      */
106     function getLastContract() constant returns (address) {
107         var sender_contracts = getContractsOf[msg.sender];
108         return sender_contracts[sender_contracts.length - 1];
109     }
110 
111     /* Building beneficiary */
112     address public beneficiary;
113 
114     /**
115      * @dev Set beneficiary
116      * @param _beneficiary is address of beneficiary
117      */
118     function setBeneficiary(address _beneficiary) onlyOwner
119     { beneficiary = _beneficiary; }
120 
121     /* Building cost  */
122     uint public buildingCostWei;
123 
124     /**
125      * @dev Set building cost
126      * @param _buildingCostWei is cost
127      */
128     function setCost(uint _buildingCostWei) onlyOwner
129     { buildingCostWei = _buildingCostWei; }
130 
131     /* Security check report */
132     string public securityCheckURI;
133 
134     /**
135      * @dev Set security check report URI
136      * @param _uri is an URI to report
137      */
138     function setSecurityCheck(string _uri) onlyOwner
139     { securityCheckURI = _uri; }
140 }
141 
142 //
143 // AIRA Builder for Comission contract
144 //
145 
146 /**
147  * @title BuilderComission contract
148  */
149 contract BuilderComission is Builder {
150     /**
151      * @dev Run script creation contract
152      * @return address new contract
153      */
154     function create(address _ledger, bytes32 _taxman, uint _taxPerc,
155                     address _client) payable returns (address) {
156         if (buildingCostWei > 0 && beneficiary != 0) {
157             // Too low value
158             if (msg.value < buildingCostWei) throw;
159             // Beneficiary send
160             if (!beneficiary.send(buildingCostWei)) throw;
161             // Refund
162             if (msg.value > buildingCostWei) {
163                 if (!msg.sender.send(msg.value - buildingCostWei)) throw;
164             }
165         } else {
166             // Refund all
167             if (msg.value > 0) {
168                 if (!msg.sender.send(msg.value)) throw;
169             }
170         }
171 
172         if (_client == 0)
173             _client = msg.sender;
174  
175         var inst = CreatorComission.create(_ledger, _taxman, _taxPerc);
176         inst.delegate(_client);
177         Builded(_client, inst);
178         getContractsOf[_client].push(inst);
179         return inst;
180     }
181 }