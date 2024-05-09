1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokensНу 
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37 }
38 
39 
40 
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 
69 contract StandardToken is Token {
70 
71     function transfer(address _to, uint256 _value) returns (bool success) {
72             if (balances[msg.sender] >= _value && _value > 0) {
73                 balances[msg.sender] -= _value;
74                 balances[_to] += _value;
75                 Transfer(msg.sender, _to, _value);
76             return true;
77         } 
78         else
79          { return false; }
80 
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
85             balances[_to] += _value;
86             balances[_from] -= _value;
87             allowed[_from][msg.sender] -= _value;
88             Transfer(_from, _to, _value);
89             return true;
90         } else { return false; }
91     }
92 
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97     function approve(address _spender, uint256 _value) returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
104       return allowed[_owner][_spender];
105     }
106 
107     mapping (address => uint256) balances;
108     mapping (address => mapping (address => uint256)) allowed;
109     uint256 public totalSupply;
110 }
111  
112 
113 
114 contract erc20GST is StandardToken {
115     using SafeMath for uint256;
116     
117     uint startPreICO =1525338000;
118     uint stopPreICO =1525942800;
119     uint start1Week =1525942800;
120     uint stop1Week =1527411600;
121     uint start2Week =1527411600;
122     uint stop2Week =1528880400;
123     uint start3Week =1528880400;
124     uint stop3Week =1530349200;
125     address storeETH = 0xcaAc6e94dAEFC3BB81CA692a8AE9d5C73f54A024;
126     address admin =0x4eebcc25cD79CDA7845B6aDD99885348bcbFd04A;
127     address tokenSaleStore = 0x02d105f68AbF0Cb98416fD018a25230e80974AbF;
128     address tokenPreIcoStore = 0x1714bA62AEcD1D0fdc8c3b10e1d6076A97BA4CBc;
129     address tokenStore = 0x58258A4cF4514f6379D320ddC5BcB24A315df0d8;
130     uint256 public exchangeRates = 19657;
131     uint256 BonusPercent=0;
132     address storeAddress;
133     
134     
135     
136     function() external payable {
137         if(msg.value>=10000000000000000)
138         {
139             
140             if(now < stopPreICO  && now > startPreICO){
141                 if(msg.value<1000000000000000000){
142                      throw;
143                 }
144                 if(msg.value>1000000000000000000 && msg.value <= 10000000000000000000){
145                     BonusPercent =  35;
146                 }
147                 if(msg.value>10000000000000000000 && msg.value <= 50000000000000000000){
148                     BonusPercent =  40;
149                 }
150                  if(msg.value>50000000000000000000){
151                     BonusPercent = 50; 
152                 }
153                 storeAddress = tokenPreIcoStore;
154             }
155             if(now > start1Week && now < stop1Week)
156             {
157                 BonusPercent = 30; 
158                 storeAddress = tokenSaleStore;
159             }
160             if(now > start2Week && now < stop2Week)
161             {
162                 BonusPercent = 20; 
163                  storeAddress = tokenSaleStore;
164             }
165             if(now > start3Week && now < stop3Week)
166             {
167                 BonusPercent = 10; 
168                  storeAddress = tokenSaleStore;
169             }
170                 uint256 value = msg.value.mul(exchangeRates);
171                 uint256 bonus = value.div(100).mul(BonusPercent);
172                 value = value.add(bonus);
173             if(balances[storeAddress] >= value && value > 0) {
174                 storeETH.transfer(msg.value);
175                 if(balances[storeAddress] >= value && value > 0) {
176                     balances[storeAddress] -= value;
177                     balances[msg.sender] += value;
178                     Transfer(storeAddress, msg.sender,  value);
179                 }
180             }
181             else {
182                 throw;
183             }
184             
185         }
186         else {
187               throw;
188         }
189     }
190     function setExchangeRates(uint256 _value){
191         if(msg.sender==admin){
192             if(_value >0){
193             exchangeRates = _value;
194             }
195         }
196     }
197 
198 
199     string public name;                   
200     uint8 public decimals;                
201     string public symbol;                 
202     string public version = 'gst.01';  
203 
204     function erc20GST(
205         uint8 _decimalUnits 
206         ) {
207         balances[tokenSaleStore] = 300000000000000000000000000;               // Give the creator all initial tokens
208         balances[tokenPreIcoStore] = 25000000000000000000000000;  
209         balances[tokenStore] = 175000000000000000000000000;     
210         totalSupply = 500000000000000000000000000;                        // Update total supply
211         name = "GAMESTARS TOKEN";                                   // Set the name for display purposes
212         decimals = _decimalUnits;                            // Amount of decimals for display purposes
213         symbol = "GST";                               // Set the symbol for display purposes
214     }
215 
216 
217     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220 
221         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
222         return true;
223     }
224 }