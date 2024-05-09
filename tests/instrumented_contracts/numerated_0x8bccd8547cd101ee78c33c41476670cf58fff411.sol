1 pragma solidity ^0.4.11;
2 
3 contract BMCAssetInterface {
4     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
5     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
6     function __approve(address _spender, uint _value, address _sender) returns(bool);
7     function __process(bytes _data, address _sender) payable {
8         throw;
9     }
10 }
11 
12 contract BMCAssetProxy {
13     address public bmcPlatform;
14     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
15     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
16     function __approve(address _spender, uint _value, address _sender) returns(bool);    
17     function getLatestVersion() returns(address);
18     function init(address _bmcPlatform, string _symbol, string _name);
19     function proposeUpgrade(address _newVersion);
20 }
21 
22 /**
23  * @title BMC Asset implementation contract.
24  *
25  * Basic asset implementation contract, without any additional logic.
26  * Every other asset implementation contracts should derive from this one.
27  * Receives calls from the proxy, and calls back immediatly without arguments modification.
28  *
29  * Note: all the non constant functions return false instead of throwing in case if state change
30  * didn't happen yet.
31  */
32 contract BMCAsset is BMCAssetInterface {
33     // Assigned asset proxy contract, immutable.
34     BMCAssetProxy public proxy;
35 
36     /**
37      * Only assigned proxy is allowed to call.
38      */
39     modifier onlyProxy() {
40         if (proxy == msg.sender) {
41             _;
42         }
43     }
44 
45     /**
46      * Sets asset proxy address.
47      *
48      * Can be set only once.
49      *
50      * @param _proxy asset proxy contract address.
51      *
52      * @return success.
53      * @dev function is final, and must not be overridden.
54      */
55     function init(BMCAssetProxy _proxy) returns(bool) {
56         if (address(proxy) != 0x0) {
57             return false;
58         }
59         proxy = _proxy;
60         return true;
61     }
62 
63     /**
64      * Passes execution into virtual function.
65      *
66      * Can only be called by assigned asset proxy.
67      *
68      * @return success.
69      * @dev function is final, and must not be overridden.
70      */
71     function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
72         return _transferWithReference(_to, _value, _reference, _sender);
73     }
74 
75     /**
76      * Calls back without modifications.
77      *
78      * @return success.
79      * @dev function is virtual, and meant to be overridden.
80      */
81     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
82         return proxy.__transferWithReference(_to, _value, _reference, _sender);
83     }
84 
85     /**
86      * Passes execution into virtual function.
87      *
88      * Can only be called by assigned asset proxy.
89      *
90      * @return success.
91      * @dev function is final, and must not be overridden.
92      */
93     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
94         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
95     }
96 
97     /**
98      * Calls back without modifications.
99      *
100      * @return success.
101      * @dev function is virtual, and meant to be overridden.
102      */
103     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
104         return proxy.__transferFromWithReference(_from, _to, _value, _reference, _sender);
105     }
106 
107     /**
108      * Passes execution into virtual function.
109      *
110      * Can only be called by assigned asset proxy.
111      *
112      * @return success.
113      * @dev function is final, and must not be overridden.
114      */
115     function __approve(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
116         return _approve(_spender, _value, _sender);
117     }
118 
119     /**
120      * Calls back without modifications.
121      *
122      * @return success.
123      * @dev function is virtual, and meant to be overridden.
124      */
125     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
126         return proxy.__approve(_spender, _value, _sender);
127     }
128 }
129 
130 
131 /**
132  * @title Blackmooncrypto.com BMC tokens contract.
133  *
134  * The official Blackmooncrypto.com token implementation.
135  */
136 contract BMC is BMCAsset {
137 
138     uint public icoUsd;
139     uint public icoEth;
140     uint public icoBtc;
141     uint public icoLtc;
142 
143     function initBMC(BMCAssetProxy _proxy, uint _icoUsd, uint _icoEth, uint _icoBtc, uint _icoLtc) returns(bool) {
144         if(icoUsd != 0 || icoEth != 0 || icoBtc != 0 || icoLtc != 0) {
145             return false;
146         }
147         icoUsd = _icoUsd;
148         icoEth = _icoEth;
149         icoBtc = _icoBtc;
150         icoLtc = _icoLtc;
151         super.init(_proxy);
152         return true;
153     }
154 
155 }