1 contract ChronoBankAssetInterface {
2     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
3     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
4     function __approve(address _spender, uint _value, address _sender) returns(bool);
5     function __process(bytes _data, address _sender) payable {
6         throw;
7     }
8 }
9 
10 contract ChronoBankAssetProxy {
11     function __transferWithReference(address _to, uint _value, string _reference, address _sender) returns(bool);
12     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) returns(bool);
13     function __approve(address _spender, uint _value, address _sender) returns(bool);    
14 }
15 
16 contract ChronoBankAsset is ChronoBankAssetInterface {
17     // Assigned asset proxy contract, immutable.
18     ChronoBankAssetProxy public proxy;
19 
20     /**
21      * Only assigned proxy is allowed to call.
22      */
23     modifier onlyProxy() {
24         if (proxy == msg.sender) {
25             _;
26         }
27     }
28 
29     /**
30      * Sets asset proxy address.
31      *
32      * Can be set only once.
33      *
34      * @param _proxy asset proxy contract address.
35      *
36      * @return success.
37      * @dev function is final, and must not be overridden.
38      */
39     function init(ChronoBankAssetProxy _proxy) returns(bool) {
40         if (address(proxy) != 0x0) {
41             return false;
42         }
43         proxy = _proxy;
44         return true;
45     }
46 
47     /**
48      * Passes execution into virtual function.
49      *
50      * Can only be called by assigned asset proxy.
51      *
52      * @return success.
53      * @dev function is final, and must not be overridden.
54      */
55     function __transferWithReference(address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
56         return _transferWithReference(_to, _value, _reference, _sender);
57     }
58 
59     /**
60      * Calls back without modifications.
61      *
62      * @return success.
63      * @dev function is virtual, and meant to be overridden.
64      */
65     function _transferWithReference(address _to, uint _value, string _reference, address _sender) internal returns(bool) {
66         return proxy.__transferWithReference(_to, _value, _reference, _sender);
67     }
68 
69     /**
70      * Passes execution into virtual function.
71      *
72      * Can only be called by assigned asset proxy.
73      *
74      * @return success.
75      * @dev function is final, and must not be overridden.
76      */
77     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) onlyProxy() returns(bool) {
78         return _transferFromWithReference(_from, _to, _value, _reference, _sender);
79     }
80 
81     /**
82      * Calls back without modifications.
83      *
84      * @return success.
85      * @dev function is virtual, and meant to be overridden.
86      */
87     function _transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) internal returns(bool) {
88         return proxy.__transferFromWithReference(_from, _to, _value, _reference, _sender);
89     }
90 
91     /**
92      * Passes execution into virtual function.
93      *
94      * Can only be called by assigned asset proxy.
95      *
96      * @return success.
97      * @dev function is final, and must not be overridden.
98      */
99     function __approve(address _spender, uint _value, address _sender) onlyProxy() returns(bool) {
100         return _approve(_spender, _value, _sender);
101     }
102 
103     /**
104      * Calls back without modifications.
105      *
106      * @return success.
107      * @dev function is virtual, and meant to be overridden.
108      */
109     function _approve(address _spender, uint _value, address _sender) internal returns(bool) {
110         return proxy.__approve(_spender, _value, _sender);
111     }
112 }