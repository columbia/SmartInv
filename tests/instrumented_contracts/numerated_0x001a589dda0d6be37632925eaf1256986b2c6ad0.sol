1 /*
2 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
3 */
4 
5 contract AmIOnTheFork{
6     function forked() constant returns(bool);
7 }
8 
9 
10 contract Oraclize {
11     mapping (address => uint) reqc;
12     
13     address public cbAddress = 0x26588a9301b0428d95e6fc3a5024fce8bec12d51;
14     
15     address constant AmIOnTheForkAddress = 0x2bd2326c993dfaef84f696526064ff22eba5b362;
16     
17     event Log1(address sender, bytes32 cid, uint timestamp, string datasource, string arg, uint gaslimit, byte proofType, uint gasPrice);
18     event Log2(address sender, bytes32 cid, uint timestamp, string datasource, string arg1, string arg2, uint gaslimit, byte proofType, uint gasPrice);
19     
20     address owner;
21     
22     modifier onlyadmin {
23         if ((msg.sender != owner)&&(msg.sender != cbAddress)) throw;
24         _
25     }
26     
27     function addDSource(string dsname, uint multiplier) {
28         addDSource(dsname, 0x00, multiplier);
29     }
30     
31     function addDSource(string dsname, byte proofType, uint multiplier) onlyadmin {
32         bytes32 dsname_hash = sha3(dsname, proofType);
33         dsources[dsources.length++] = dsname_hash;
34         price_multiplier[dsname_hash] = multiplier;
35     }
36 
37     mapping (bytes32 => bool) coupons;
38     bytes32 coupon;
39     
40     function createCoupon(string _code) onlyadmin {
41         coupons[sha3(_code)] = true;
42     }
43     
44     function deleteCoupon(string _code) onlyadmin {
45         coupons[sha3(_code)] = false;
46     }
47     
48     function multisetProofType(uint[] _proofType, address[] _addr) onlyadmin {
49         for (uint i=0; i<_addr.length; i++) addr_proofType[_addr[i]] = byte(_proofType[i]);
50     }
51     
52     function multisetCustomGasPrice(uint[] _gasPrice, address[] _addr) onlyadmin {
53         for (uint i=0; i<_addr.length; i++) addr_gasPrice[_addr[i]] = _gasPrice[i];
54     }
55 
56     uint gasprice = 20000000000;
57     
58     function setGasPrice(uint newgasprice) onlyadmin {
59         gasprice = newgasprice;
60     }
61     
62     function setBasePrice(uint new_baseprice) onlyadmin { //0.001 usd in ether
63         baseprice = new_baseprice;
64         for (uint i=0; i<dsources.length; i++) price[dsources[i]] = new_baseprice*price_multiplier[dsources[i]];
65     }
66 
67     function setBasePrice(uint new_baseprice, bytes proofID) onlyadmin { //0.001 usd in ether
68         baseprice = new_baseprice;
69         for (uint i=0; i<dsources.length; i++) price[dsources[i]] = new_baseprice*price_multiplier[dsources[i]];
70     }
71     
72     function withdrawFunds(address _addr) onlyadmin {
73         _addr.send(this.balance);
74     }
75     
76     function() onlyadmin {}
77     
78     function Oraclize() {
79         owner = msg.sender;
80     }
81     
82     modifier costs(string datasource, uint gaslimit) {
83         uint price = getPrice(datasource, gaslimit, msg.sender);
84         if (msg.value >= price){
85             uint diff = msg.value - price;
86             if (diff > 0) msg.sender.send(diff);
87             _
88         } else throw;
89     }
90 
91     mapping (address => byte) addr_proofType;
92     mapping (address => uint) addr_gasPrice;
93     uint public baseprice;
94     mapping (bytes32 => uint) price;
95     mapping (bytes32 => uint) price_multiplier;
96     bytes32[] dsources;
97     function useCoupon(string _coupon) {
98         coupon = sha3(_coupon);
99     }
100     
101     function setProofType(byte _proofType) {
102         addr_proofType[msg.sender] = _proofType;
103     }
104     
105     function setCustomGasPrice(uint _gasPrice) {
106         addr_gasPrice[msg.sender] = _gasPrice;
107     }
108     
109     function getPrice(string _datasource) public returns (uint _dsprice) {
110         return getPrice(_datasource, msg.sender);
111     }
112     
113     function getPrice(string _datasource, uint _gaslimit) public returns (uint _dsprice) {
114         return getPrice(_datasource, _gaslimit, msg.sender);
115     }
116     
117     function getPrice(string _datasource, address _addr) private returns (uint _dsprice) {
118         return getPrice(_datasource, 200000, _addr);
119     }
120     
121     function getPrice(string _datasource, uint _gaslimit, address _addr) private returns (uint _dsprice) {
122         if ((_gaslimit <= 200000)&&(reqc[_addr] == 0)&&(tx.origin != cbAddress)) return 0;
123         if ((coupon != 0)&&(coupons[coupon] == true)) return 0;
124         _dsprice = price[sha3(_datasource, addr_proofType[_addr])];
125         uint gasprice_ = addr_gasPrice[_addr];
126         if (gasprice_ == 0) gasprice_ = gasprice; 
127         _dsprice += _gaslimit*gasprice_;
128         return _dsprice;
129     }
130     
131     function query(string _datasource, string _arg) returns (bytes32 _id) {
132         return query1(0, _datasource, _arg, 200000);
133     }
134     
135     function query1(string _datasource, string _arg) returns (bytes32 _id) {
136         return query1(0, _datasource, _arg, 200000);
137     }
138     
139     function query2(string _datasource, string _arg1, string _arg2) returns (bytes32 _id) {
140         return query2(0, _datasource, _arg1, _arg2, 200000);
141     }
142     
143     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id) {
144         return query1(_timestamp, _datasource, _arg, 200000);
145     }
146     
147     function query1(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id) {
148         return query1(_timestamp, _datasource, _arg, 200000);
149     }
150     
151     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id) {
152         return query2(_timestamp, _datasource, _arg1, _arg2, 200000);
153     }
154     
155     function query(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id) {
156         return query1(_timestamp, _datasource, _arg, _gaslimit);
157     }
158     
159     function query1(uint _timestamp, string _datasource, string _arg, uint _gaslimit) costs(_datasource, _gaslimit) returns (bytes32 _id) {
160 	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
161 	bool forkFlag = AmIOnTheFork(AmIOnTheForkAddress).forked();
162         _id = sha3(forkFlag, this, msg.sender, reqc[msg.sender]);
163         reqc[msg.sender]++;
164         Log1(msg.sender, _id, _timestamp, _datasource, _arg, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
165         return _id;
166     }
167     
168     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) costs(_datasource, _gaslimit) returns (bytes32 _id) {
169 	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
170 	bool forkFlag = AmIOnTheFork(AmIOnTheForkAddress).forked();
171         _id = sha3(forkFlag, this, msg.sender, reqc[msg.sender]);
172         reqc[msg.sender]++;
173         Log2(msg.sender, _id, _timestamp, _datasource, _arg1, _arg2, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
174         return _id;
175     }
176     
177     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id) {
178         return query(_timestamp, _datasource, _arg, _gaslimit);
179     }
180     
181     function query1_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id) {
182         return query1(_timestamp, _datasource, _arg, _gaslimit);
183     }
184     
185     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id) {
186         return query2(_timestamp, _datasource, _arg1, _arg2, _gaslimit);
187     }
188 }