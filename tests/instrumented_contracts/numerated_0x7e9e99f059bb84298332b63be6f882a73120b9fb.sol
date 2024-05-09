1 contract IERC20Token {
2 
3     function totalSupply() constant returns (uint256 supply);
4     function balanceOf(address _owner) constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
7     function approve(address _spender, uint256 _value) returns (bool success);
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
9 
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract IToken {
15     function totalSupply() constant returns (uint256 supply) {}
16     function balanceOf(address _owner) constant returns (uint256 balance) {}
17     function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}
18     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}
19     function approveViaProxy(address _source, address _spender, uint256 _value) returns (uint error) {}
20     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {} 
21     function mint(address _destination, uint _amount) returns (uint error){}
22     function destroy(address _destination, uint _amount) returns (uint error) {}
23 }
24 
25 contract MacroProxyContract is IERC20Token {
26 
27     address public dev;
28     address public curator;
29     address public proxyManagementAddress;
30     bool public proxyWorking;
31 
32     string public standard = 'MacroERC20Proxy';
33     string public name = 'Macro';
34     string public symbol = 'MCR';
35     uint8 public decimals = 8;
36 
37     IToken tokenContract;
38 
39     function MacroProxyContract(){ 
40         dev = msg.sender;
41     }
42 
43     function totalSupply() constant returns (uint256 supply) {
44         return tokenContract.totalSupply();
45     }
46 
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return tokenContract.balanceOf(_owner);
49     }
50 
51     function transfer(address _to, uint256 _value) returns (bool success) {
52         if (!proxyWorking) throw;
53         
54         tokenContract.transferViaProxy(msg.sender, _to, _value);
55         Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         if (!proxyWorking) throw;
61 
62         tokenContract.transferFromViaProxy(msg.sender, _from, _to, _value);
63         Transfer(_from, _to, _value);
64         return true;
65     }
66 
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         if (!proxyWorking) throw;
69         
70         tokenContract.approveViaProxy(msg.sender, _spender, _value);
71         Approval(msg.sender, _spender, _value);
72         return true;
73      
74     }
75 
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77         return tokenContract.allowance(_owner, _spender);
78     } 
79 
80     function setTokenContract(address _tokenAddress) {
81         if (msg.sender != curator) throw;
82         tokenContract = IToken(_tokenAddress);
83     }
84     
85     function setProxyManagementAddress(address _proxyManagementAddress){ 
86         if (msg.sender != curator) throw;
87         proxyManagementAddress = _proxyManagementAddress;
88     }
89 
90     function enableDisableTokenProxy(){
91         if (msg.sender != curator) throw;
92         proxyWorking = !proxyWorking;
93 
94     }
95     
96     function setProxyCurator(address _curatorAddress){
97         if( msg.sender != dev) throw;
98         curator = _curatorAddress;
99     }
100 
101     function killContract(){
102         if (msg.sender != dev) throw;
103         selfdestruct(dev);
104     }
105 
106     function tokenAddress() constant returns (address contractAddress){
107         return address(tokenContract);
108     }
109 
110     function raiseTransferEvent(address _from, address _to, uint256 _value){
111         if(msg.sender != proxyManagementAddress) throw;
112         Transfer(_from, _to, _value);
113     }
114 
115     function raiseApprovalEvent(address _owner, address _spender, uint256 _value){
116         if(msg.sender != proxyManagementAddress) throw;
117         Approval(_owner, _spender, _value);
118     }
119 
120     function () {
121         throw;     
122     }
123 }