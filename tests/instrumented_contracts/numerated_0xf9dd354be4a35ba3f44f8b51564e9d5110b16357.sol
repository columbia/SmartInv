1 pragma solidity ^0.4.8;
2 
3 contract IProxyManagement { 
4     function isProxyLegit(address _address) returns (bool){}
5     function raiseTransferEvent(address _from, address _to, uint _ammount){}
6     function raiseApprovalEvent(address _sender,address _spender,uint _value){}
7     function dedicatedProxyAddress() constant returns (address contractAddress){}
8 }
9 
10 contract ITokenRecipient { 
11 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
12 }
13 
14 contract NeterContract {
15     
16   
17     address public dev;
18     address public curator;
19     address public creationAddress;
20     address public destructionAddress;
21     uint256 public totalSupply = 0;
22     bool public lockdown = false;
23 
24 
25     string public standard = 'Neter token 1.0';
26     string public name = 'Neter';
27     string public symbol = 'NTR';
28     uint8 public decimals = 8;
29 
30 
31     mapping (address => uint256) balances;
32     mapping (address => mapping (address => uint256)) allowed;
33     IProxyManagement proxyManagementContract;
34 
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     event Create(address _destination, uint _amount);
39     event Destroy(address _destination, uint _amount);
40 
41 
42     function NeterContract() { 
43         dev = msg.sender;
44     }
45     
46     function balanceOf(address _owner) constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50     function transfer(address _to, uint256 _amount) returns (uint error) {
51         if(balances[msg.sender] < _amount) { return 55; }
52         if(balances[_to] + _amount <= balances[_to]) { return 55; }
53         if(lockdown) { return 55; }
54 
55         balances[msg.sender] -= _amount;
56         balances[_to] += _amount;
57         createTransferEvent(true, msg.sender, _to, _amount);              
58         return 0;
59         
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _amount) returns (uint error) {
63         if(balances[_from] < _amount) { return 55; }
64         if(balances[_to] + _amount <= balances[_to]) { return 55; }
65         if(_amount > allowed[_from][msg.sender]) { return 55; }
66         if(lockdown) { return 55; }
67 
68         balances[_from] -= _amount;
69         balances[_to] += _amount;
70         createTransferEvent(true, _from, _to, _amount);
71         allowed[_from][msg.sender] -= _amount;
72         return 0;
73     }
74 
75     function approve(address _spender, uint256 _value) returns (uint error) {
76         allowed[msg.sender][_spender] = _value;
77         createApprovalEvent(true, msg.sender, _spender, _value);
78         return 0;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     function transferViaProxy(address _source, address _to, uint256 _amount) returns (uint error){
86         if (!proxyManagementContract.isProxyLegit(msg.sender)) { return 1; }
87 
88         if (balances[_source] < _amount) {return 55;}
89         if (balances[_to] + _amount <= balances[_to]) {return 55;}
90         if (lockdown) {return 55;}
91 
92         balances[_source] -= _amount;
93         balances[_to] += _amount;
94 
95         if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){
96             createTransferEvent(false, _source, _to, _amount); 
97         }else{
98             createTransferEvent(true, _source, _to, _amount); 
99         }
100         return 0;
101     }
102     
103     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {
104         if (!proxyManagementContract.isProxyLegit(msg.sender)){ return 1; }
105 
106         if (balances[_from] < _amount) {return 55;}
107         if (balances[_to] + _amount <= balances[_to]) {return 55;}
108         if (lockdown) {return 55;}
109         if (_amount > allowed[_from][_source]) {return 55;}
110 
111         balances[_from] -= _amount;
112         balances[_to] += _amount;
113         allowed[_from][_source] -= _amount;
114 
115         if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){
116             createTransferEvent(false, _source, _to, _amount); 
117         }else{
118             createTransferEvent(true, _source, _to, _amount); 
119         }
120         return 0;
121     }
122     
123     function approveFromProxy(address _source, address _spender, uint256 _value) returns (uint error) {
124         if (!proxyManagementContract.isProxyLegit(msg.sender)){ return 1; }
125 
126         allowed[_source][_spender] = _value;
127         if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){
128             createApprovalEvent(false, _source, _spender, _value);
129         }else{
130             createApprovalEvent(true, _source, _spender, _value);
131         }
132         return 0;
133     }
134 
135     function issueNewCoins(address _destination, uint _amount, string _details) returns (uint error){
136         if (msg.sender != creationAddress) { return 1;}
137 
138         if(balances[_destination] + _amount < balances[_destination]) { return 55;}
139         if(totalSupply + _amount < totalSupply) { return 55; }
140 
141         totalSupply += _amount;
142         balances[_destination] += _amount;
143         Create(_destination, _amount);
144         createTransferEvent(true, 0x0, _destination, _amount);
145         return 0;
146     }
147 
148     function destroyOldCoins(address _destination, uint _amount, string _details) returns (uint error) {
149         if (msg.sender != destructionAddress) { return 1;}
150 
151         if (balances[_destination] < _amount) { return 55;} 
152 
153         totalSupply -= _amount;
154         balances[_destination] -= _amount;
155         Destroy(_destination, _amount);
156         createTransferEvent(true, _destination, 0x0, _amount);
157         return 0;
158     }
159 
160     function setTokenCurator(address _curatorAddress) returns (uint error){
161         if( msg.sender != dev) {return 1;}
162      
163         curator = _curatorAddress;
164         return 0;
165     }
166     
167     function setCreationAddress(address _contractAddress) returns (uint error){ 
168         if (msg.sender != curator) { return 1;}
169         
170         creationAddress = _contractAddress;
171         return 0;
172     }
173 
174     function setDestructionAddress(address _contractAddress) returns (uint error){ 
175         if (msg.sender != curator) { return 1;}
176         
177         destructionAddress = _contractAddress;
178         return 0;
179     }
180 
181     function setProxyManagementContract(address _contractAddress) returns (uint error){
182         if (msg.sender != curator) { return 1;}
183         
184         proxyManagementContract = IProxyManagement(_contractAddress);
185         return 0;
186     }
187 
188     function emergencyLock() returns (uint error){
189         if (msg.sender != curator && msg.sender != dev) { return 1; }
190         
191         lockdown = !lockdown;
192         return 0;
193     }
194 
195     function killContract() returns (uint error){
196         if (msg.sender != dev) { return 1; }
197         
198         selfdestruct(dev);
199         return 0;
200     }
201 
202     function proxyManagementAddress() constant returns (address proxyManagementAddress){
203         return address(proxyManagementContract);
204     }
205 
206     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
207         allowed[msg.sender][_spender] = _value;
208         ITokenRecipient spender = ITokenRecipient(_spender);
209         spender.receiveApproval(msg.sender, _value, this, _extraData);
210         return true;
211     }
212 
213     function createTransferEvent(bool _relayEvent, address _from, address _to, uint256 _value) internal {
214         if (_relayEvent){
215             proxyManagementContract.raiseTransferEvent(_from, _to, _value);
216         }
217         Transfer(_from, _to, _value);
218     }
219 
220     function createApprovalEvent(bool _relayEvent, address _sender, address _spender, uint _value) internal {
221         if (_relayEvent){
222             proxyManagementContract.raiseApprovalEvent(_sender, _spender, _value);
223         }
224         Approval(_sender, _spender, _value);
225     }
226 
227     function () {
228         throw;
229     }
230 }