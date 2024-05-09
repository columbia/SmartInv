1 pragma solidity ^0.4.8;
2 
3 contract IERC20Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}   
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 contract IToken {
41     function totalSupply() constant returns (uint256 supply) {}
42     function balanceOf(address _owner) constant returns (uint256 balance) {}
43     function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}
44     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}
45     function approveFromProxy(address _source, address _spender, uint256 _value) returns (uint error) {}
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {} 
47     function issueNewCoins(address _destination, uint _amount, string _details) returns (uint error){}
48     function destroyOldCoins(address _destination, uint _amount, string _details) returns (uint error) {}
49 }
50 
51 contract ProxyContract is IERC20Token {
52 
53 
54     address public dev;
55     address public curator;
56     address public proxyManagementAddress;
57     
58     bool public proxyWorking;
59 
60     string public standard = 'Neter proxy';
61     string public name = 'Neter';
62     string public symbol = 'NTR';
63     uint8 public decimals = 8;
64 
65     IToken tokenContract;
66 
67 
68     function ProxyContract(){ 
69         dev = msg.sender;
70     }
71 
72     function totalSupply() constant returns (uint256 supply) {
73         return tokenContract.totalSupply();
74     }
75 
76     function balanceOf(address _owner) constant returns (uint256 balance) {
77         return tokenContract.balanceOf(_owner);
78     }
79 
80     function transfer(address _to, uint256 _value) returns (bool success) {
81         if (!proxyWorking) { return false;}
82         
83         uint error =  tokenContract.transferViaProxy(msg.sender, _to, _value);
84         
85         if(error == 0){
86             Transfer(msg.sender, _to, _value);
87             return true;
88         }else{
89             return false;
90         }
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
94         if (!proxyWorking) { return false;}
95         
96         uint error =  tokenContract.transferFromViaProxy(msg.sender, _from, _to, _value);
97         
98         if(error == 0){
99             Transfer(_from, _to, _value);
100             return true;
101         }else{
102             return false;
103         }
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success) {
107         if (!proxyWorking) { return false;}
108         
109         uint error =  tokenContract.approveFromProxy(msg.sender, _spender, _value);
110         
111         if(error == 0){
112             Approval(msg.sender, _spender, _value);
113             return true;
114         }else{
115             return false;
116         }
117     }
118 
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120         return tokenContract.allowance(_owner, _spender);
121     } 
122     
123     function setTokenContract(address _tokenAddress) returns (uint error){
124         if (msg.sender != curator) { return 1;}
125         
126         tokenContract = IToken(_tokenAddress);
127         return 0;
128     }
129     
130     function setProxyManagementAddress(address _proxyManagementAddress) returns (uint error){ 
131         if (msg.sender != curator) { return 1;}
132         
133         proxyManagementAddress = _proxyManagementAddress;
134         return 0;
135     }
136 
137     function EnableDisableTokenProxy() returns (uint error){
138         if (msg.sender != curator) { return 1; }       
139         
140         proxyWorking = !proxyWorking;
141         return 0;
142 
143     }
144     
145     function setProxyCurator(address _curatorAddress) returns (uint error){
146         if( msg.sender != dev) {return 1;}
147      
148         curator = _curatorAddress;
149         return 0;
150     }
151 
152     function killContract() returns (uint error){
153         if (msg.sender != dev) { return 1; }
154         
155         selfdestruct(dev);
156         return 0;
157     }
158 
159     function tokenAddress() constant returns (address contractAddress){
160         return address(tokenContract);
161     }
162 
163     function raiseTransferEvent(address _from, address _to, uint256 _value) returns (uint error){
164         if(msg.sender != proxyManagementAddress) { return 1; }
165 
166         Transfer(_from, _to, _value);
167         return 0;
168     }
169 
170     function raiseApprovalEvent(address _owner, address _spender, uint256 _value) returns (uint error){
171         if(msg.sender != proxyManagementAddress) { return 1; }
172 
173         Approval(_owner, _spender, _value);
174         return 0;
175     }
176 
177     function () {
178         throw;     
179     }
180 }