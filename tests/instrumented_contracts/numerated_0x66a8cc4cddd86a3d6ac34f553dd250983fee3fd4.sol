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
78 contract Invoice is Mortal {
79     address   public signer;
80     uint      public closeBlock;
81 
82     Comission public comission;
83     string    public description;
84     bytes32   public beneficiary;
85     uint      public value;
86 
87     /**
88      * @dev Offer type contract
89      * @param _comission Comission handler address
90      * @param _description Deal description
91      * @param _beneficiary Beneficiary account
92      * @param _value Deal value
93      */
94     function Invoice(address _comission,
95                      string  _description,
96                      bytes32 _beneficiary,
97                      uint    _value) {
98         comission   = Comission(_comission);
99         description = _description;
100         beneficiary = _beneficiary;
101         value       = _value;
102     }
103 
104     /**
105      * @dev Call me to withdraw money
106      */
107     function withdraw() onlyOwner {
108         if (closeBlock != 0) {
109             if (!comission.process.value(value)(beneficiary)) throw;
110         }
111     }
112 
113     /**
114      * @dev Payment fallback function
115      */
116     function () payable {
117         // Condition check
118         if (msg.value != value
119            || closeBlock != 0) throw;
120 
121         // Store block when closed
122         closeBlock = block.number;
123         signer = msg.sender;
124         PaymentReceived();
125     }
126     
127     /**
128      * @dev Payment notification
129      */
130     event PaymentReceived();
131 }
132 
133 
134 library CreatorInvoice {
135     function create(address _comission, string _description, bytes32 _beneficiary, uint256 _value) returns (Invoice)
136     { return new Invoice(_comission, _description, _beneficiary, _value); }
137 
138     function version() constant returns (string)
139     { return "v0.5.0 (a9ea4c6c)"; }
140 
141     function abi() constant returns (string)
142     { return '[{"constant":true,"inputs":[],"name":"signer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"beneficiary","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"comission","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"withdraw","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"value","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"}],"name":"delegate","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"description","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"closeBlock","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"inputs":[{"name":"_comission","type":"address"},{"name":"_description","type":"string"},{"name":"_beneficiary","type":"bytes32"},{"name":"_value","type":"uint256"}],"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[],"name":"PaymentReceived","type":"event"}]'; }
143 }
144 
145 
146 /**
147  * @title Builder based contract
148  */
149 contract Builder is Mortal {
150     /**
151      * @dev this event emitted for every builded contract
152      */
153     event Builded(address indexed client, address indexed instance);
154  
155     /* Addresses builded contracts at sender */
156     mapping(address => address[]) public getContractsOf;
157  
158     /**
159      * @dev Get last address
160      * @return last address contract
161      */
162     function getLastContract() constant returns (address) {
163         var sender_contracts = getContractsOf[msg.sender];
164         return sender_contracts[sender_contracts.length - 1];
165     }
166 
167     /* Building beneficiary */
168     address public beneficiary;
169 
170     /**
171      * @dev Set beneficiary
172      * @param _beneficiary is address of beneficiary
173      */
174     function setBeneficiary(address _beneficiary) onlyOwner
175     { beneficiary = _beneficiary; }
176 
177     /* Building cost  */
178     uint public buildingCostWei;
179 
180     /**
181      * @dev Set building cost
182      * @param _buildingCostWei is cost
183      */
184     function setCost(uint _buildingCostWei) onlyOwner
185     { buildingCostWei = _buildingCostWei; }
186 
187     /* Security check report */
188     string public securityCheckURI;
189 
190     /**
191      * @dev Set security check report URI
192      * @param _uri is an URI to report
193      */
194     function setSecurityCheck(string _uri) onlyOwner
195     { securityCheckURI = _uri; }
196 }
197 
198 //
199 // AIRA Builder for Invoice contract
200 //
201 /**
202  * @title BuilderInvoice contract
203  */
204 contract BuilderInvoice is Builder {
205     /**
206      * @dev Run script creation contract
207      * @return address new contract
208      */
209     function create(address _comission, string _description,
210                     bytes32 _beneficiary, uint _value,
211                     address _client) payable returns (address) {
212         if (buildingCostWei > 0 && beneficiary != 0) {
213             // Too low value
214             if (msg.value < buildingCostWei) throw;
215             // Beneficiary send
216             if (!beneficiary.send(buildingCostWei)) throw;
217             // Refund
218             if (msg.value > buildingCostWei) {
219                 if (!msg.sender.send(msg.value - buildingCostWei)) throw;
220             }
221         } else {
222             // Refund all
223             if (msg.value > 0) {
224                 if (!msg.sender.send(msg.value)) throw;
225             }
226         }
227 
228         if (_client == 0)
229             _client = msg.sender;
230  
231         var inst = CreatorInvoice.create(_comission, _description, _beneficiary, _value);
232         inst.delegate(_client);
233         Builded(_client, inst);
234         getContractsOf[_client].push(inst);
235         return inst;
236     }
237 }