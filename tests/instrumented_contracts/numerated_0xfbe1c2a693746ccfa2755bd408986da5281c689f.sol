1 // DAC Contract Address: 0x800deede5d02713616498cdfd8bc5780964deb9a
2 // ABI: [{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"totalSupply","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"},{"name":"tokenAddress","type":"address"},{"name":"tokenName","type":"string"},{"name":"tokenSymbol","type":"string"}],"name":"transmuteTransfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"standard","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"toCheck","type":"address"}],"name":"vaildBalanceForTokenCreation","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"coinsAmount","type":"uint256"},{"name":"initialSupply","type":"uint256"},{"name":"assetTokenName","type":"string"},{"name":"tokenSymbol","type":"string"},{"name":"_assetID","type":"string"},{"name":"_assetMeta","type":"string"},{"name":"_isVerified","type":"string"}],"name":"CreateDigitalAssetToken","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalAssetTokens","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"changeOwner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"assetToken","type":"address"}],"name":"doesAssetTokenExist","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"idx","type":"uint256"}],"name":"getAssetTokenByIndex","outputs":[{"name":"assetToken","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_creator","type":"address"},{"indexed":true,"name":"_assetContract","type":"address"}],"name":"NewDigitalAsset","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"},{"indexed":false,"name":"_tokenAddress","type":"address"},{"indexed":false,"name":"_tokenName","type":"string"},{"indexed":false,"name":"_tokenSymbol","type":"string"}],"name":"TransmutedTransfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]
3 //
4 // Test Asset Created with owner & _isVerified : 0x7962e319eDCB6afEabb0d72bb245A23d2266e3AD
5 
6 pragma solidity ^0.4.10;
7 
8 contract SafeMath {
9 
10     /* function assert(bool assertion) internal { */
11     /*   if (!assertion) { */
12     /*     throw; */
13     /*   } */
14     /* }      // assert no longer needed once solidity is on 0.4.10 */
15 
16     function safeToAdd(uint a, uint b) internal returns (bool) {
17         return (a + b >= a);
18     }
19 
20     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
21       uint256 z = x + y;
22       assert((z >= x) && (z >= y));
23       return z;
24     }
25 
26     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
27       assert(x >= y);
28       uint256 z = x - y;
29       return z;
30     }
31 
32     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
33       uint256 z = x * y;
34       assert((x == 0)||(z/x == y));
35       return z;
36     }
37 
38 }
39 
40 contract Token {
41     uint256 public _totalSupply;
42     function balanceOf(address _owner) constant returns (uint256 balance);
43     function transfer(address _to, uint256 _value) returns (bool success);
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
45     function approve(address _spender, uint256 _value) returns (bool success);
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 
52 /*  ERC 20 token */
53 contract StandardToken is Token {
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56       if (balances[msg.sender] >= _value && _value > 0) {
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59         Transfer(msg.sender, _to, _value);
60         return true;
61       } else {
62         return false;
63       }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
68         balances[_to] += _value;
69         balances[_from] -= _value;
70         allowed[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73       } else {
74         return false;
75       }
76     }
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 
92     function totalSupply() constant returns (uint256 totalSupply) {
93           totalSupply = _totalSupply;
94     }
95 
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 }
99   
100 contract DigitalAssetToken is StandardToken() 
101 {
102     string public constant standard = 'DigitalAssetToken 1.0';
103     string public symbol;
104     string public  name;
105     string public  assetID;
106     string public  assetMeta;
107     string public isVerfied;
108     uint8 public constant decimals = 0;
109    
110     // Constructor
111     function DigitalAssetToken(
112     address tokenMaster,
113     address requester,
114     uint256 initialSupply,
115     string assetTokenName,
116     string tokenSymbol,
117     string _assetID,
118     string _assetMeta
119     ) {
120         //Only Token Master can initiate Digital Asset Token Creations
121         require(msg.sender == tokenMaster);
122 
123         DigitalAssetCoin coinMaster = DigitalAssetCoin(tokenMaster);
124 
125         require(coinMaster.vaildBalanceForTokenCreation(requester));
126         
127         balances[requester] = initialSupply;              // Give the creator all initial tokens
128         _totalSupply = initialSupply;                        // Update total supply
129         name = assetTokenName;                                   // Set the name for display purposes
130         symbol = tokenSymbol;                               // Set the symbol for display purposes
131         assetID = _assetID;
132         assetMeta = _assetMeta;
133     } 
134 }
135   
136 contract DigitalAssetCoin is StandardToken {
137     string public constant standard = 'DigitalAssetCoin 1.0';
138     string public constant symbol = "DAC";
139     string public constant name = "Digital Asset Coin";
140     uint8 public constant decimals = 0;
141 
142     // Balances for each account
143     mapping(address => uint256) transmutedBalances;
144 
145     // Triggered whenever approve(address _spender, uint256 _value) is called.
146     event NewDigitalAsset(address indexed _creator, address indexed _assetContract);
147     event TransmutedTransfer(address indexed _from, address indexed _to, uint256 _value, address _tokenAddress, string _tokenName, string _tokenSymbol);
148 
149     //List of Asset Tokens
150     uint256 public totalAssetTokens;
151     address[] addressList;
152     mapping(address => uint256) addressDict;
153     
154     // Owner of this contract
155     address public owner;
156 
157     // Functions with this modifier can only be executed by the owner
158     modifier onlyOwner() {
159         require(msg.sender == owner);
160         _;
161     }
162     
163     // Allow Owner to be changed by exisiting owner (Dev management)
164     function changeOwner(address _newOwner) onlyOwner() {
165         owner = _newOwner;
166     }
167 
168     // Constructor
169     function DigitalAssetCoin() {
170         owner = msg.sender;
171         _totalSupply = 100000000000;
172         balances[owner] = _totalSupply;
173         totalAssetTokens = 0;
174         addressDict[this] = totalAssetTokens;
175         addressList.length = 1;
176         addressList[totalAssetTokens] = this;
177     }
178 
179     function CreateDigitalAssetToken(
180     uint256 coinsAmount,
181     uint256 initialSupply,
182     string assetTokenName,
183     string tokenSymbol,
184     string _assetID,
185     string _assetMeta
186     ) {
187         //Not Enought Coins to Create new Asset Token
188         require(balanceOf(msg.sender) > coinsAmount);
189         
190         //Cant be smaller than 1 or larger than 1
191         require(coinsAmount == 1);
192 
193         //Send coins back to master escrow
194         DigitalAssetToken newToken = new DigitalAssetToken(this, msg.sender,initialSupply,assetTokenName,tokenSymbol,_assetID,_assetMeta);
195         //Use coins for Token Creation
196         transmuteTransfer(msg.sender, 1, newToken, assetTokenName, tokenSymbol);
197         insetAssetToken(newToken);
198     }
199 
200     function vaildBalanceForTokenCreation (address toCheck) external returns (bool success) {
201         address sender = msg.sender;
202         address org = tx.origin; 
203         address tokenMaster = this;
204 
205         //Can not be run from human or master contract
206         require(sender != org || sender != tokenMaster);
207 
208         //Check if message send can make token
209         if (balances[toCheck] >= 1) {
210             return true;
211         } else {
212             return false;
213         }
214 
215     }
216     
217     function insetAssetToken(address assetToken) internal {
218         totalAssetTokens = totalAssetTokens + 1;
219         addressDict[assetToken] = totalAssetTokens;
220         addressList.length += 1;
221         addressList[totalAssetTokens] = assetToken;
222         NewDigitalAsset(msg.sender, assetToken);
223         //Transfer(msg.sender, assetToken, 777);
224     }
225     
226     function getAssetTokenByIndex (uint256 idx) external returns (address assetToken) {
227         require(totalAssetTokens <= idx);
228         return addressList[idx];
229     }
230     
231     function doesAssetTokenExist (address assetToken) external returns (bool success) {
232         uint256 value = addressDict[assetToken];
233         if(value == 0)
234             return false;
235         else
236             return true;
237     }
238     
239     // Transmute DAC to DAT
240     function transmuteTransfer(address _from, uint256 _value, address tokenAddress, string tokenName, string tokenSymbol) returns (bool success) {
241         if (balances[_from] >= _value && _value > 0) {
242             balances[_from] -= _value;
243             transmutedBalances[this] += _value;
244             TransmutedTransfer(_from, this, _value, tokenAddress, tokenName, tokenSymbol);
245             return true;
246         } else {
247             return false;
248         }
249     }
250 
251 }