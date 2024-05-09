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
76     uint256 minTxFee = 0.02 ether;
77     uint256 maxTxFee = 0.03 ether;
78     uint256 minClaimFee = 0.003 ether;
79     uint256 maxClaimFee = 0.004 ether;
80     uint256 public maxSupply;
81     iSAToE satoe;
82     bool public satoeLocked = false;
83     
84     function BTCoE()
85     {
86         maxSupply  = 21000000 * 10**8;
87         _totalSupply = maxSupply;
88         
89         owner = msg.sender;
90         balances[owner] = maxSupply;
91         airDropped[owner] = true;
92     }
93     
94     modifier forOwner(){
95         require(msg.sender == owner);
96         _;
97     }
98     
99     function() payable external
100     {
101         require (block.number >= 4574200);
102         require (airDropStage <= 10);
103         require (!airDropped[msg.sender]);
104         require(msg.value >= minTxFee);
105         require(msg.value <= maxTxFee);
106         
107         uint256 airDropReward = (2048*10**8)/(2**(airDropStage-1));
108         require (balances[owner] >= airDropReward);
109         
110         balances[owner] -= airDropReward;
111         balances[msg.sender] += airDropReward;
112         Transfer(owner, msg.sender, airDropReward);
113         airDropped[msg.sender] = true;
114         
115         userCount ++;
116         if (userCount == 256*airDropStage)
117         {
118             userCount = 0;
119             airDropStage++;
120         }
121     }
122     //------------------------------------------------------------------------
123     function SetSAToEContract(address _address) forOwner
124     {
125         require (_address != 0x0);
126         require (!satoeLocked);
127         satoeContract = _address;
128         satoe = iSAToE(satoeContract);
129     }
130     function LockSAToE() forOwner
131     {
132         require (satoeContract != 0x00);
133         satoeLocked = true;
134     }
135     function TransferToBTCoE(address _to, uint256 _value) returns (bool success) 
136     {
137         require (msg.sender == satoeContract);
138         require (balances[satoeContract] >= _value);
139         
140         balances[satoeContract] -= _value;
141         balances[_to] += _value;
142         _totalSupply = maxSupply - balances[satoeContract];
143         Transfer(satoeContract, _to, _value);
144         return true;
145     }
146     function TransferToSAToE(uint256 _value) returns (bool success)
147     {
148         require (satoeContract != 0x00);
149         require (_value <= balances[msg.sender]);
150         uint256 realMicroSAToE = _value * 10**6;
151         
152         balances[msg.sender] -= _value;
153         balances[satoeContract] += _value;
154         _totalSupply = maxSupply - balances[satoeContract];
155         Transfer(msg.sender, satoeContract, _value);
156         require (satoe.TransferToSAToE(msg.sender, realMicroSAToE));
157         return true;
158     }
159     function balanceOf(address _owner) constant returns (uint256 balance) 
160     {
161         // balances[satoeContract] is locked
162         // check to assure match total supply.
163         if(_owner == satoeContract) return 0;
164         return balances[_owner];
165     }
166     //------------------------------------------------------------------------
167     function ProcessTxFee() forOwner
168     {
169         require (owner.send(this.balance));
170     }
171     function SetTxFee(uint256 minfee, uint256 maxfee) forOwner
172     {
173         require (minfee < maxfee);
174         minTxFee = minfee;
175         maxTxFee = maxfee;
176     }
177     function SetClaimFee(uint256 minfee, uint256 maxfee) forOwner
178     {
179         require (minfee < maxfee);
180         minClaimFee = minfee;
181         maxClaimFee = maxfee;
182     }
183     //------------------------------------------------------------------------
184     event ClaimedSignature(address indexed ethAddress, string btcSignature);
185     event DeliveredBTC(address indexed ethAddress, uint256 amount);
186     bool public allowingClaimBTC = true;
187     mapping(address => bool) acceptedClaimers;
188     function AllowClaimBTC(bool val) forOwner
189     {
190         allowingClaimBTC = val;
191     }
192     function ClaimBTC(string fullSignature) payable
193     {
194         require (allowingClaimBTC);
195         require (!acceptedClaimers[msg.sender]);
196         require (msg.value >= minClaimFee);
197         require (msg.value <= maxClaimFee);
198         
199         ClaimedSignature(msg.sender,fullSignature);
200     }
201     
202     function DeliverToClaimers(address[] dests, uint256[] values) forOwner returns (uint256) 
203     {
204         require (dests.length == values.length);
205         uint256 i = 0;
206         while (i < dests.length) 
207         {
208             if(!acceptedClaimers[dests[i]])
209             {
210                 transfer(dests[i], values[i]); 
211                 acceptedClaimers[dests[i]] = true;
212                 DeliveredBTC(dests[i], values[i]);
213             }
214             i += 1;
215         }
216         return(i);
217     }
218 }