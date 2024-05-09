1 pragma solidity ^0.4.8;
2 
3 contract Token {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract ERC20Token is Token {
15     uint256 constant MAX_UINT256 = 2**256 - 1;
16     uint256 _totalSupply;
17     
18     function transfer(address _to, uint256 _value) returns (bool success) {
19         require(balances[msg.sender] >= _value);
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24     }
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
26         uint256 allowance = allowed[_from][msg.sender];
27         require(balances[_from] >= _value && allowance >= _value);
28         balances[_to] += _value;
29         balances[_from] -= _value;
30         if (allowance < MAX_UINT256) {
31             allowed[_from][msg.sender] -= _value;
32         }
33         Transfer(_from, _to, _value);
34         return true;
35     }
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39     function approve(address _spender, uint256 _value) returns (bool success) {
40         allowed[msg.sender][_spender] = _value;
41         Approval(msg.sender, _spender, _value);
42         return true;
43     }
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
45       return allowed[_owner][_spender];
46     }
47     function totalSupply() constant returns (uint256 totalSupply) {
48          totalSupply = _totalSupply;
49     }
50     mapping (address => uint256) balances;
51     mapping (address => mapping (address => uint256)) allowed;
52 }
53 
54 contract iBTCoE is ERC20Token{
55     function TransferToBTCoE(address _to, uint256 _value) returns (bool success);
56     function TransferToSAToE(uint256 _value) returns (bool success);
57 }
58 
59 contract iSAToE is ERC20Token{
60     function TransferToSAToE(address _to, uint256 _value) returns (bool success);
61     function TransferToBTCoE(uint256 _amount) returns (bool success);
62 }
63 
64 contract BTCoE is iBTCoE{
65     
66     string public constant name = "Bitcoin oE"; 
67     uint8 public constant decimals = 8;
68     string public constant symbol = "BTCoE";
69 
70     address public owner;
71     mapping(address => bool) airDropped;
72     uint256 public airDropStage = 1;
73     uint256 public userCount = 0;
74     
75     address public satoeContract = 0x00;
76     uint256 constant minTxFee = 0.02 ether;
77     uint256 constant maxTxFee = 0.03 ether;
78     uint256 public maxSupply;
79     iSAToE satoe;
80     bool public satoeLocked = false;
81     
82     function BTCoE()
83     {
84         maxSupply  = 21000000 * 10**8;
85         _totalSupply = maxSupply;
86         
87         owner = msg.sender;
88         balances[owner] = maxSupply;
89         airDropped[owner] = true;
90     }
91     
92     modifier forOwner(){
93         require(msg.sender == owner);
94         _;
95     }
96     
97     function() payable external
98     {
99         require (block.number >= 4574200);
100         require (airDropStage <= 10);
101         require (!airDropped[msg.sender]);
102         require(msg.value >= minTxFee);
103         require(msg.value <= maxTxFee);
104         
105         uint256 airDropReward = (2048*10**8)/(2**(airDropStage-1));
106         require (balances[owner] >= airDropReward);
107         
108         balances[owner] -= airDropReward;
109         balances[msg.sender] += airDropReward;
110         Transfer(owner, msg.sender, airDropReward);
111         airDropped[msg.sender] = true;
112         
113         userCount ++;
114         if (userCount == 256*airDropStage)
115         {
116             userCount = 0;
117             airDropStage++;
118         }
119     }
120     //------------------------------------------------------------------------
121     function SetSAToEContract(address _address) forOwner
122     {
123         require (_address != 0x0);
124         require (!satoeLocked);
125         satoeContract = _address;
126         satoe = iSAToE(satoeContract);
127     }
128     function LockSAToE() forOwner
129     {
130         require (satoeContract != 0x00);
131         satoeLocked = true;
132     }
133     function TransferToBTCoE(address _to, uint256 _value) returns (bool success) 
134     {
135         require (msg.sender == satoeContract);
136         require (balances[satoeContract] >= _value);
137         
138         balances[satoeContract] -= _value;
139         balances[_to] += _value;
140         _totalSupply = maxSupply - balances[satoeContract];
141         Transfer(satoeContract, _to, _value);
142         return true;
143     }
144     function TransferToSAToE(uint256 _value) returns (bool success)
145     {
146         require (satoeContract != 0x00);
147         require (_value <= balances[msg.sender]);
148         uint256 realMicroSAToE = _value * 10**6;
149         
150         balances[msg.sender] -= _value;
151         balances[satoeContract] += _value;
152         _totalSupply = maxSupply - balances[satoeContract];
153         Transfer(msg.sender, satoeContract, _value);
154         require (satoe.TransferToSAToE(msg.sender, realMicroSAToE));
155         return true;
156     }
157     function balanceOf(address _owner) constant returns (uint256 balance) 
158     {
159         // balances[satoeContract] is locked
160         // check to assure match total supply.
161         if(_owner == satoeContract) return 0;
162         return balances[_owner];
163     }
164     //------------------------------------------------------------------------
165     function ProcessTxFee() forOwner
166     {
167         require (owner.send(this.balance));
168     }
169     //------------------------------------------------------------------------
170     event ClaimedSignature(address indexed ethAddress, string btcSignature);
171     event DeliveredBTC(address indexed ethAddress, uint256 amount);
172     bool public allowingClaimBTC = true;
173     mapping(address => bool) acceptedClaimers;
174     function AllowClaimBTC(bool val) forOwner
175     {
176         allowingClaimBTC = val;
177     }
178     function ClaimBTC(string fullSignature) payable
179     {
180         require (allowingClaimBTC);
181         require(!acceptedClaimers[msg.sender]);
182         require(msg.value >= minTxFee);
183         require(msg.value <= maxTxFee);
184         
185         ClaimedSignature(msg.sender,fullSignature);
186     }
187     
188     function DeliverToClaimers(address[] dests, uint256[] values) forOwner returns (uint256) 
189     {
190         require (dests.length == values.length);
191         uint256 i = 0;
192         while (i < dests.length) 
193         {
194             if(!acceptedClaimers[dests[i]])
195             {
196                 transfer(dests[i], values[i]); 
197                 acceptedClaimers[dests[i]] = true;
198                 DeliveredBTC(dests[i], values[i]);
199             }
200             i += 1;
201         }
202         return(i);
203     }
204 }