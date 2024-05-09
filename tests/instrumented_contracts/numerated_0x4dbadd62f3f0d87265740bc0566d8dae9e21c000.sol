1 contract IProxyManagement { 
2     function isProxyLegit(address _address) returns (bool){}
3     function raiseTransferEvent(address _from, address _to, uint _ammount){}
4     function raiseApprovalEvent(address _sender,address _spender,uint _value){}
5     function dedicatedProxyAddress() constant returns (address contractAddress){}
6 }
7 
8 contract ITokenRecipient { 
9 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
10 }
11 
12 contract IFundManagement {
13 	function fundsCombinedValue() constant returns (uint value){}
14     function getFundAlterations() returns (uint alterations){}
15 }
16 
17 contract IERC20Token {
18 
19     function totalSupply() constant returns (uint256 supply);
20     function balanceOf(address _owner) constant returns (uint256 balance);
21     function transfer(address _to, uint256 _value) returns (bool success);
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23     function approve(address _spender, uint256 _value) returns (bool success);
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 }
29 
30 contract MacroTokenContract{
31     
32     address public dev;
33     address public curator;
34     address public mintingContractAddress;
35     address public destructionContractAddress;
36     uint256 public totalSupply = 0;
37     bool public lockdown = false;
38 
39     string public standard = 'Macro token';
40     string public name = 'Macro';
41     string public symbol = 'MCR';
42     uint8 public decimals = 8;
43 
44     mapping (address => uint256) balances;
45     mapping (address => mapping (address => uint256)) allowed;
46     IProxyManagement proxyManagementContract;
47     IFundManagement fundManagementContract;
48 
49     uint public weiForMcr;
50     uint public mcrAmmountForGas;
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54     event Mint(address _destination, uint _amount);
55     event Destroy(address _destination, uint _amount);
56     event McrForGasFailed(address _failedAddress, uint _ammount);
57 
58     function MacroTokenContract() { 
59         dev = msg.sender;
60     }
61     
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function transfer(address _to, uint256 _value) returns (bool success){
67         if(balances[msg.sender] < _value) throw;
68         if(balances[_to] + _value <= balances[_to]) throw;
69         if(lockdown) throw;
70 
71         balances[msg.sender] -= _value;
72         balances[_to] += _value;
73         createTransferEvent(true, msg.sender, _to, _value);              
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         if(balances[_from] < _value) throw;
79         if(balances[_to] + _value <= balances[_to]) throw;
80         if(_value > allowed[_from][msg.sender]) throw;
81         if(lockdown) throw;
82 
83         balances[_from] -= _value;
84         balances[_to] += _value;
85         createTransferEvent(true, _from, _to, _value);
86         allowed[_from][msg.sender] -= _value;
87         return true;
88     }
89 
90     function approve(address _spender, uint256 _value) returns (bool success) {
91         if(lockdown) throw;
92         
93         allowed[msg.sender][_spender] = _value;
94         createApprovalEvent(true, msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100     }
101 
102     function transferViaProxy(address _source, address _to, uint256 _amount) returns (bool success){
103         if (!proxyManagementContract.isProxyLegit(msg.sender)) throw;
104         if (balances[_source] < _amount) throw;
105         if (balances[_to] + _amount <= balances[_to]) throw;
106         if (lockdown) throw;
107 
108         balances[_source] -= _amount;
109         balances[_to] += _amount;
110 
111         if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){
112             createTransferEvent(false, _source, _to, _amount); 
113         }else{
114             createTransferEvent(true, _source, _to, _amount); 
115         }
116         return true;
117     }
118     
119     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (bool success) {
120         if (!proxyManagementContract.isProxyLegit(msg.sender)) throw;
121         if (balances[_from] < _amount) throw;
122         if (balances[_to] + _amount <= balances[_to]) throw;
123         if (lockdown) throw;
124         if (_amount > allowed[_from][_source]) throw;
125 
126         balances[_from] -= _amount;
127         balances[_to] += _amount;
128         allowed[_from][_source] -= _amount;
129 
130         if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){
131             createTransferEvent(false, _source, _to, _amount); 
132         }else{
133             createTransferEvent(true, _source, _to, _amount); 
134         }
135         return true;
136     }
137     
138     function approveViaProxy(address _source, address _spender, uint256 _value) returns (bool success) {
139         if (!proxyManagementContract.isProxyLegit(msg.sender)) throw;
140         if(lockdown) throw;
141         
142         allowed[_source][_spender] = _value;
143         if (msg.sender == proxyManagementContract.dedicatedProxyAddress()){
144             createApprovalEvent(false, _source, _spender, _value);
145         }else{
146             createApprovalEvent(true, _source, _spender, _value);
147         }
148         return true;
149     }
150 
151     function mint(address _destination, uint _amount) returns (bool success){
152         if (msg.sender != mintingContractAddress) throw;
153         if(balances[_destination] + _amount < balances[_destination]) throw;
154         if(totalSupply + _amount < totalSupply) throw;
155 
156         totalSupply += _amount;
157         balances[_destination] += _amount;
158         Mint(_destination, _amount);
159         createTransferEvent(true, 0x0, _destination, _amount);
160         return true;
161     }
162 
163     function destroy(address _destination, uint _amount) returns (bool success) {
164         if (msg.sender != destructionContractAddress) throw;
165         if (balances[_destination] < _amount) throw;
166 
167         totalSupply -= _amount;
168         balances[_destination] -= _amount;
169         Destroy(_destination, _amount);
170         createTransferEvent(true, _destination, 0x0, _amount);
171         return true;
172     }
173 
174     function setTokenCurator(address _curatorAddress){
175         if( msg.sender != dev) throw;
176         curator = _curatorAddress;
177     }
178     
179     function setMintingContractAddress(address _contractAddress){ 
180         if (msg.sender != curator) throw;
181         mintingContractAddress = _contractAddress;
182     }
183 
184     function setDescrutionContractAddress(address _contractAddress){ 
185         if (msg.sender != curator) throw;
186         destructionContractAddress = _contractAddress;
187     }
188 
189     function setProxyManagementContract(address _contractAddress){
190         if (msg.sender != curator) throw;
191         proxyManagementContract = IProxyManagement(_contractAddress);
192     }
193 
194     function setFundManagementContract(address _contractAddress){
195         if (msg.sender != curator) throw;
196         fundManagementContract = IFundManagement(_contractAddress);
197     }
198 
199     function emergencyLock() {
200         if (msg.sender != curator && msg.sender != dev) throw;
201         
202         lockdown = !lockdown;
203     }
204 
205     function killContract(){
206         if (msg.sender != dev) throw;
207         selfdestruct(dev);
208     }
209 
210     function setWeiForMcr(uint _value){
211         if (msg.sender != curator) throw;
212         weiForMcr = _value;
213     }
214     
215     function setMcrAmountForGas(uint _value){
216         if (msg.sender != curator) throw;
217         mcrAmmountForGas = _value;
218     }
219 
220     function getGasForMcr(){
221         if (balances[msg.sender] < mcrAmmountForGas) throw;
222         if (balances[curator] > balances[curator] + mcrAmmountForGas) throw;
223         if (this.balance < weiForMcr * mcrAmmountForGas) throw;
224 
225         balances[msg.sender] -= mcrAmmountForGas;
226         balances[curator] += mcrAmmountForGas;
227         createTransferEvent(true, msg.sender, curator, weiForMcr * mcrAmmountForGas);
228         if (!msg.sender.send(weiForMcr * mcrAmmountForGas)) {
229             McrForGasFailed(msg.sender, weiForMcr * mcrAmmountForGas);
230         }
231     }
232 
233     function fundManagementAddress() constant returns (address fundManagementAddress){
234         return address(fundManagementContract);
235     }
236 
237     function proxyManagementAddress() constant returns (address proxyManagementAddress){
238         return address(proxyManagementContract);
239     }
240 
241     function fundsCombinedValue() constant returns (uint value){
242         return fundManagementContract.fundsCombinedValue();
243     }
244 
245     function getGasForMcrData() constant returns (uint, uint){
246         return (weiForMcr, mcrAmmountForGas);
247     }
248 
249     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
250         allowed[msg.sender][_spender] = _value;
251         ITokenRecipient spender = ITokenRecipient(_spender);
252         spender.receiveApproval(msg.sender, _value, this, _extraData);
253         return true;
254     }
255 
256     function createTransferEvent(bool _relayEvent, address _from, address _to, uint256 _value) internal {
257         if (_relayEvent){
258             proxyManagementContract.raiseTransferEvent(_from, _to, _value);
259         }
260         Transfer(_from, _to, _value);
261     }
262 
263     function createApprovalEvent(bool _relayEvent, address _sender, address _spender, uint _value) internal {
264         if (_relayEvent){
265             proxyManagementContract.raiseApprovalEvent(_sender, _spender, _value);
266         }
267         Approval(_sender, _spender, _value);
268     }
269     
270     function fillContract() payable{
271         if (msg.sender != curator) throw;
272     }
273 }