1 // This contract just saves in the blockchain the intention to withdraw dth
2 // A Bot will execute this operation in the ETC blockchain and will save
3 // the result back
4 contract Owned {
5     /// Prevents methods from perfoming any value transfer
6     modifier noEther() {if (msg.value > 0) throw; _}
7     /// Allows only the owner to call a function
8     modifier onlyOwner { if (msg.sender == owner) _ }
9 
10     function Owned() { owner = msg.sender;}
11     address owner;
12 
13 
14     function changeOwner(address _newOwner) onlyOwner {
15         owner = _newOwner;
16     }
17 
18     function execute(address _dst, uint _value, bytes _data) onlyOwner {
19         _dst.call.value(_value)(_data);
20     }
21 
22     function getOwner() noEther constant returns (address) {
23         return owner;
24     }
25 }
26 
27 contract CrossWhitehatWithdraw is Owned {
28     address bot;
29     uint price;
30 
31     Operation[] public operations;
32 
33     modifier onlyBot { if ((msg.sender == owner)||(msg.sender == bot)) _ }
34 
35     struct Operation {
36         address dth;
37         address etcBeneficiary;
38         uint percentage;
39         uint queryTime;
40 
41         uint answerTime;
42         uint result;
43         bytes32 dthTxHash;
44     }
45 
46     function CrossWhitehatWithdraw(uint _price, address _bot) Owned() {
47         price = _price;
48         bot = _bot;
49     }
50 
51     function withdraw(address _etcBeneficiary, uint _percentage) returns (uint) {
52         if (_percentage > 100) throw;
53         if (msg.value < price) throw;
54         Operation op = operations[operations.length ++];
55         op.dth = msg.sender;
56         op.etcBeneficiary = _etcBeneficiary;
57         op.percentage = _percentage;
58         op.queryTime = now;
59         Withdraw(op.dth, op.etcBeneficiary, op.percentage, operations.length -1);
60 
61         return operations.length -1;
62     }
63 
64     function setResult(uint _idOperation, uint _result, bytes32 _dthTxHash) onlyBot noEther {
65         Operation op = operations[_idOperation];
66         if (op.dth == 0) throw;
67         op.answerTime = now;
68         op.result = _result;
69         op.dthTxHash = _dthTxHash;
70         WithdrawResult(_idOperation, _dthTxHash, _result);
71     }
72 
73     function setBot(address _bot) onlyOwner noEther  {
74         bot = _bot;
75     }
76 
77     function getBot() noEther constant returns (address) {
78         return bot;
79     }
80 
81     function setPrice(uint _price) onlyOwner noEther  {
82         price = _price;
83     }
84 
85     function getPrice() noEther constant returns (uint) {
86         return price;
87     }
88 
89     function getOperation(uint _idOperation) noEther constant returns (address dth,
90         address etcBeneficiary,
91         uint percentage,
92         uint queryTime,
93         uint answerTime,
94         uint result,
95         bytes32 dthTxHash)
96     {
97         Operation op = operations[_idOperation];
98         return (op.dth,
99                 op.etcBeneficiary,
100                 op.percentage,
101                 op.queryTime,
102                 op.answerTime,
103                 op.result,
104                 op.dthTxHash);
105     }
106 
107     function getOperationsNumber() noEther constant returns (uint) {
108         return operations.length;
109     }
110 
111     function() {
112         throw;
113     }
114 
115     function kill() onlyOwner {
116         uint i;
117         for (i=0; i<operations.length; i++) {
118             Operation op = operations[i];
119             op.dth =0;
120             op.etcBeneficiary =0;
121             op.percentage=0;
122             op.queryTime=0;
123             op.answerTime=0;
124             op.result=0;
125             op.dthTxHash=0;
126         }
127         operations.length=0;
128         bot=0;
129         price=0;
130         selfdestruct(owner);
131     }
132 
133     event Withdraw(address indexed dth, address indexed beneficiary, uint percentage, uint proposal);
134     event WithdrawResult(uint indexed proposal, bytes32 indexed hash, uint result);
135 
136 
137 }