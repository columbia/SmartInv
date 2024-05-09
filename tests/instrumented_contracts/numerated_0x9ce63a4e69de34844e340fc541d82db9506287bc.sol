1 contract MultiAsset {
2     function owner(bytes32 _symbol) constant returns(address);
3     function isCreated(bytes32 _symbol) constant returns(bool);
4     function totalSupply(bytes32 _symbol) constant returns(uint);
5     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
6     function transfer(address _to, uint _value, bytes32 _symbol) returns(bool);
7     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
8     function proxyTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool);
9     function proxyApprove(address _spender, uint _value, bytes32 _symbol) returns(bool);
10     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
11     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
12     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
13     function proxySetCosignerAddress(address _address, bytes32 _symbol) returns(bool);
14 }
15 
16 contract OpenDollar {
17     event Transfer(address indexed from, address indexed to, uint value);
18     event Approve(address indexed from, address indexed spender, uint value);
19 
20     MultiAsset public multiAsset;
21     bytes32 public symbol;
22 
23     function init(address _multiAsset, bytes32 _symbol) returns(bool) {
24         MultiAsset ma = MultiAsset(_multiAsset);
25         if (address(multiAsset) != 0x0 || !ma.isCreated(_symbol)) {
26             return false;
27         }
28         multiAsset = ma;
29         symbol = _symbol;
30         return true;
31     }
32 
33     modifier onlyMultiAsset() {
34         if (msg.sender == address(multiAsset)) {
35             _
36         }
37     }
38 
39     function totalSupply() constant returns(uint) {
40         return multiAsset.totalSupply(symbol);
41     }
42 
43     function balanceOf(address _owner) constant returns(uint) {
44         return multiAsset.balanceOf(_owner, symbol);
45     }
46 
47     function allowance(address _from, address _spender) constant returns(uint) {
48         return multiAsset.allowance(_from, _spender, symbol);
49     }
50 
51     function transfer(address _to, uint _value) returns(bool) {
52         return transferWithReference(_to, _value, "");
53     }
54 
55     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
56         if (!multiAsset.proxyTransferWithReference(_to, _value, symbol, _reference)) {
57             return false;
58         }
59         return true;
60     }
61 
62     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
63         return transferToICAPWithReference(_icap, _value, "");
64     }
65 
66     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
67         if (!multiAsset.proxyTransferToICAPWithReference(_icap, _value, _reference)) {
68             return false;
69         }
70         return true;
71     }
72     
73     function transferFrom(address _from, address _to, uint _value) returns(bool) {
74         return transferFromWithReference(_from, _to, _value, "");
75     }
76 
77     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
78         if (!multiAsset.proxyTransferFromWithReference(_from, _to, _value, symbol, _reference)) {
79             return false;
80         }
81         return true;
82     }
83 
84     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
85         return transferFromToICAPWithReference(_from, _icap, _value, "");
86     }
87 
88     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
89         if (!multiAsset.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference)) {
90             return false;
91         }
92         return true;
93     }
94 
95     function approve(address _spender, uint _value) returns(bool) {
96         if (!multiAsset.proxyApprove(_spender, _value, symbol)) {
97             return false;
98         }
99         return true;
100     }
101 
102     function setCosignerAddress(address _cosigner) returns(bool) {
103         if (!multiAsset.proxySetCosignerAddress(_cosigner, symbol)) {
104             return false;
105         }
106         return true;
107     }
108 
109     function emitTransfer(address _from, address _to, uint _value) onlyMultiAsset() {
110         Transfer(_from, _to, _value);
111     }
112 
113     function emitApprove(address _from, address _spender, uint _value) onlyMultiAsset() {
114         Approve(_from, _spender, _value);
115     }
116 
117     function sendToOwner() returns(bool) {
118         return multiAsset.transfer(multiAsset.owner(symbol), balanceOf(address(this)), symbol);
119     }
120 }