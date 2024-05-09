1 pragma solidity ^0.4.8;
2 
3 contract IProxy{
4 	function raiseTransferEvent(address _from, address _to, uint256 _value) returns (bool success) {}
5 	function raiseApprovalEvent(address _owner, address _spender, uint256 _value) returns (bool success){}
6 }
7 
8 contract ProxyManagementContract{
9 
10   
11     address public dev;
12     address public curator;
13     address public tokenAddress;
14 
15     address[] public proxyList; 
16 
17     mapping (address => bool) approvedProxies;
18     IProxy dedicatedProxy;
19 
20 
21     function ProxyManagementContract(){
22         dev = msg.sender;
23     }
24 
25     function addProxy(address _proxyAdress) returns (uint error){
26         if(msg.sender != curator){ return 1;}
27         
28         approvedProxies[_proxyAdress] = true;
29         proxyList.push(_proxyAdress);
30         return 0;
31     }
32 
33     function removeProxy(address _proxyAddress) returns (uint error){
34         if(msg.sender != curator){ return 1; }
35         if (!approvedProxies[_proxyAddress]) { return 55; }
36         
37         uint temAddressArrayLength = proxyList.length - 1;
38         uint newArrayCnt = 0;
39         address[] memory tempAddressArray = new address[](temAddressArrayLength);
40         
41         for (uint cnt = 0; cnt < proxyList.length; cnt++){
42             if (_proxyAddress == proxyList[cnt]){
43                 approvedProxies[_proxyAddress] = false;
44             }
45             else{
46                 tempAddressArray[newArrayCnt] = proxyList[cnt];
47                 newArrayCnt += 1;
48             }
49         }
50         proxyList = tempAddressArray;
51         return 0;
52     }
53 
54     function changeDedicatedProxy(address _contractAddress) returns (uint error){
55         if(msg.sender != curator){ return 1;}
56         
57         dedicatedProxy = IProxy(_contractAddress);
58         return 0;
59     }
60 
61     function raiseTransferEvent(address _from, address _to, uint256 _value) returns (uint error){
62         if (msg.sender != tokenAddress) { return 1; }
63         
64         dedicatedProxy.raiseTransferEvent(_from, _to, _value);
65         return 0;
66     }
67 
68     function raiseApprovalEvent(address _owner, address _spender, uint256 _value) returns (uint error){
69         if (msg.sender == tokenAddress) { return 1; }
70 
71         dedicatedProxy.raiseApprovalEvent(_owner, _spender, _value);
72         return 0;
73     }
74 
75     function setProxyManagementCurator(address _curatorAdress) returns (uint error){
76         if (msg.sender != dev){ return 1; }
77               
78         curator = _curatorAdress;
79         return 0;
80     }
81 
82     function setDedicatedProxy(address _contractAddress) returns (uint error){
83         if (msg.sender != curator){ return 1; }
84               
85         dedicatedProxy = IProxy(_contractAddress);
86         return 0;
87     }
88 
89     function setTokenAddress(address _contractAddress) returns (uint error){
90         if (msg.sender != curator){ return 1; }
91         
92         tokenAddress = _contractAddress;
93         return 0;
94     }
95 
96     function killContract() returns (uint error){
97         if (msg.sender != dev){ return 1; }
98 
99         selfdestruct(dev);
100         return 0;
101     }
102 
103     function dedicatedProxyAddress() constant returns (address contractAddress){
104         return address(dedicatedProxy);
105     }
106 
107     function getApprovedProxies() constant returns (address[] proxies){
108         return proxyList;
109     }
110 
111     function isProxyLegit(address _proxyAddress) constant returns (bool isLegit){
112         if (_proxyAddress == address(dedicatedProxy)){ return true; }
113         return approvedProxies[_proxyAddress];
114     }
115 
116     function () {
117         throw;
118     }
119 }