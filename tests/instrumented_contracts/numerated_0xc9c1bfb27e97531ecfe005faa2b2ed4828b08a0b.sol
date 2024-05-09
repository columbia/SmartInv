1 contract AmIOnTheFork{
2   function forked() constant returns(bool);
3 }
4 
5 contract Etherandom {
6   address owner;
7   uint seedPrice;
8   uint execPrice;
9   uint gasPrice;
10   uint minimumGasLimit;
11   mapping(address => uint) seedc;
12   mapping(address => uint) execc;
13 
14   address constant AmIOnTheForkAddress = 0x2bd2326c993dfaef84f696526064ff22eba5b362;
15 
16   event SeedLog(address sender, bytes32 seedID, uint gasLimit);
17   event ExecLog(address sender, bytes32 execID, uint gasLimit, bytes32 serverSeedHash, bytes32 clientSeed, uint cardinality);
18 
19   function Etherandom() {
20     owner = msg.sender;
21   }
22 
23   modifier onlyAdmin {
24     if (msg.sender != owner) throw;
25     _
26   }
27 
28   function getSeedPrice() public constant returns (uint _seedPrice) {
29     return seedPrice;
30   }
31 
32   function getExecPrice() public constant returns (uint _execPrice) {
33     return execPrice;
34   }
35 
36   function getGasPrice() public constant returns (uint _gasPrice) {
37     return gasPrice;
38   }
39 
40   function getMinimumGasLimit() public constant returns (uint _minimumGasLimit) {
41     return minimumGasLimit;
42   }
43 
44   function getSeedCost(uint _gasLimit) public constant returns (uint _cost) {
45     uint cost = seedPrice + (_gasLimit * gasPrice);
46     return cost;
47   }
48 
49   function getExecCost(uint _gasLimit) public constant returns (uint _cost) {
50     uint cost = execPrice + (_gasLimit * gasPrice);
51     return cost;
52   }
53 
54   function kill() onlyAdmin {
55     selfdestruct(owner);
56   }
57 
58   function setSeedPrice(uint newSeedPrice) onlyAdmin {
59     seedPrice = newSeedPrice;
60   }
61 
62   function setExecPrice(uint newExecPrice) onlyAdmin {
63     execPrice = newExecPrice;
64   }
65 
66   function setGasPrice(uint newGasPrice) onlyAdmin {
67     gasPrice = newGasPrice;
68   }
69 
70   function setMinimumGasLimit(uint newMinimumGasLimit) onlyAdmin {
71     minimumGasLimit = newMinimumGasLimit;
72   }
73 
74   function withdraw(address addr) onlyAdmin {
75     addr.send(this.balance);
76   }
77 
78   function () {
79     throw;
80   }
81 
82   modifier costs(uint cost) {
83     if (msg.value >= cost) {
84       uint diff = msg.value - cost;
85       if (diff > 0) msg.sender.send(diff);
86       _
87     } else throw;
88   }
89 
90   function seed() returns (bytes32 _id) {
91     return seedWithGasLimit(getMinimumGasLimit());
92   }
93 
94   function seedWithGasLimit(uint _gasLimit) costs(getSeedCost(_gasLimit)) returns (bytes32 _id) {
95     if (_gasLimit > block.gaslimit || _gasLimit < getMinimumGasLimit()) throw;
96     bool forkFlag = AmIOnTheFork(AmIOnTheForkAddress).forked();
97     _id = sha3(forkFlag, this, msg.sender, seedc[msg.sender]);
98     seedc[msg.sender]++;
99     SeedLog(msg.sender, _id, _gasLimit);
100     return _id;
101   }
102 
103   function exec(bytes32 _serverSeedHash, bytes32 _clientSeed, uint _cardinality) returns (bytes32 _id) {
104     return execWithGasLimit(_serverSeedHash, _clientSeed, _cardinality, getMinimumGasLimit());
105   }
106 
107   function execWithGasLimit(bytes32 _serverSeedHash, bytes32 _clientSeed, uint _cardinality, uint _gasLimit) costs(getExecCost(_gasLimit)) returns (bytes32 _id) {
108     if (_gasLimit > block.gaslimit || _gasLimit < getMinimumGasLimit()) throw;
109     bool forkFlag = AmIOnTheFork(AmIOnTheForkAddress).forked();
110     _id = sha3(forkFlag, this, msg.sender, execc[msg.sender]);
111     execc[msg.sender]++;
112     ExecLog(msg.sender, _id, _gasLimit, _serverSeedHash, _clientSeed, _cardinality);
113     return _id;
114   }
115 }