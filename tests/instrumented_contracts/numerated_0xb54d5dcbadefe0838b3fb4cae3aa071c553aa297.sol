1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to relinquish control of the contract.
37      */
38     function renounceOwnership() public onlyOwner {
39         emit OwnershipRenounced(owner);
40         owner = address(0);
41     }
42 
43     /**
44      * @dev Allows the current owner to transfer control of the contract to a newOwner.
45      * @param _newOwner The address to transfer ownership to.
46      */
47     function transferOwnership(address _newOwner) public onlyOwner {
48         _transferOwnership(_newOwner);
49     }
50 
51     /**
52      * @dev Transfers control of the contract to a newOwner.
53      * @param _newOwner The address to transfer ownership to.
54      */
55     function _transferOwnership(address _newOwner) internal {
56         require(_newOwner != address(0));
57         emit OwnershipTransferred(owner, _newOwner);
58         owner = _newOwner;
59     }
60 }
61 
62 
63 contract Notary is Ownable {
64 
65     struct Record {
66         bytes notarisedData;
67         uint256 timestamp;
68     }
69 
70     mapping(bytes32 => Record) public records;
71     uint256 public notarisationFee;
72 
73     /**
74     * @dev initialize Notary
75     * @param _owner of the notary
76     */
77     constructor (address _owner) public {
78         owner = _owner;
79     }
80 
81     /**
82     * @dev make sure that the call has the notarisation cost
83     */
84     modifier callHasNotarisationCost() {
85         require(msg.value >= notarisationFee);
86         _;
87     }
88 
89     /**
90     * @dev set notarisation cost
91     * @param _fee to notarize a record
92     */
93     function setNotarisationFee(uint256 _fee) public onlyOwner {
94         notarisationFee = _fee;
95     }
96 
97     /**
98     * @dev fetch a Record by it's data notarised data
99     * @param _notarisedData the data that got notarised
100     */
101     function record(bytes _notarisedData) public constant returns(bytes, uint256) {
102         Record memory r = records[keccak256(_notarisedData)];
103         return (r.notarisedData, r.timestamp);
104     }
105 
106     /**
107     * @dev notarize a new record
108     * @param _record the record to notarize
109     */
110     function notarize(bytes _record)
111         public
112         payable
113         callHasNotarisationCost
114     {
115 
116         // create hash of record to to have an unique and deterministic key
117         bytes32 recordHash = keccak256(_record);
118 
119         // make sure the record hasn't been notarised
120         require(records[recordHash].timestamp == 0);
121 
122         // transfer notarisation fee to owner
123         if (owner != address(0)){
124             owner.transfer(address(this).balance);
125         }
126 
127         // notarize record
128         records[recordHash] = Record({
129             notarisedData: _record,
130             timestamp: now
131         });
132 
133     }
134 
135 }
136 
137 contract NotaryMulti {
138 
139     Notary public notary;
140 
141     constructor(Notary _notary) public {
142         notary = _notary;
143     }
144 
145     function notaryFee() public constant returns (uint256) {
146         return 2 * notary.notarisationFee();
147     }
148 
149     /**
150     * @dev notarize two records
151     * @param _firstRecord is the first record that should be notarized
152     * @param _secondRecord is the second record that should be notarized
153     */
154     function notarizeTwo(bytes _firstRecord, bytes _secondRecord) payable public {
155         notary.notarize(_firstRecord);
156         notary.notarize(_secondRecord);
157     }
158 
159 }