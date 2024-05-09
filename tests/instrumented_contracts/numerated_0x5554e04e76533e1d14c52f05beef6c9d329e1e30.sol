1 pragma solidity ^0.4.15;
2 
3 contract Token {
4     
5     mapping (address => uint256) public balanceOf;
6     mapping (uint256 => address) public addresses;
7     mapping (address => bool) public addressExists;
8     mapping (address => uint256) public addressIndex;
9     mapping(address => mapping (address => uint256)) allowed;
10     uint256 public numberOfAddress = 0;
11     
12     string public physicalString;
13     string public cryptoString;
14     
15     bool public isSecured;
16     string public name;
17     string public symbol;
18     uint256 public totalSupply;
19     bool public canMintBurn;
20     uint256 public txnTax;
21     uint256 public holdingTax;
22     //In Weeks, on Fridays
23     uint256 public holdingTaxInterval;
24     uint256 public lastHoldingTax;
25     uint256 public holdingTaxDecimals = 2;
26     bool public isPrivate;
27     
28     address public owner;
29     
30     function Token(string n, string a, uint256 totalSupplyToUse, bool isSecured, bool cMB, string physical, string crypto, uint256 txnTaxToUse, uint256 holdingTaxToUse, uint256 holdingTaxIntervalToUse, bool isPrivateToUse) {
31         name = n;
32         symbol = a;
33         totalSupply = totalSupplyToUse;
34         balanceOf[msg.sender] = totalSupplyToUse;
35         isSecured = isSecured;
36         physicalString = physical;
37         cryptoString = crypto;
38         canMintBurn = cMB;
39         owner = msg.sender;
40         txnTax = txnTaxToUse;
41         holdingTax = holdingTaxToUse;
42         holdingTaxInterval = holdingTaxIntervalToUse;
43         if(holdingTaxInterval!=0) {
44             lastHoldingTax = now;
45             while(getHour(lastHoldingTax)!=21) {
46                 lastHoldingTax -= 1 hours;
47             }
48             while(getWeekday(lastHoldingTax)!=5) {
49                 lastHoldingTax -= 1 days;
50             }
51             lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);
52         }
53         isPrivate = isPrivateToUse;
54         
55         addAddress(owner);
56     }
57     
58     function transfer(address _to, uint256 _value) payable returns (bool success) {
59         chargeHoldingTax();
60         if (balanceOf[msg.sender] < _value) return false;
61         if (balanceOf[_to] + _value < balanceOf[_to]) return false;
62         if (msg.sender != owner && _to != owner && txnTax != 0) {
63             if(!owner.send(txnTax)) {
64                 return false;
65             }
66         }
67         if(isPrivate && msg.sender != owner && !addressExists[_to]) {
68             return false;
69         }
70         balanceOf[msg.sender] -= _value;
71         balanceOf[_to] += _value;
72         addAddress(_to);
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76     
77     function transferFrom(
78          address _from,
79          address _to,
80          uint256 _amount
81      ) payable returns (bool success) {
82         if (_from != owner && _to != owner && txnTax != 0) {
83             if(!owner.send(txnTax)) {
84                 return false;
85             }
86         }
87         if(isPrivate && _from != owner && !addressExists[_to]) {
88             return false;
89         }
90         if (balanceOf[_from] >= _amount
91             && allowed[_from][msg.sender] >= _amount
92             && _amount > 0
93             && balanceOf[_to] + _amount > balanceOf[_to]) {
94             balanceOf[_from] -= _amount;
95             allowed[_from][msg.sender] -= _amount;
96             balanceOf[_to] += _amount;
97             Transfer(_from, _to, _amount);
98             return true;
99         } else {
100             return false;
101         }
102     }
103      
104     function approve(address _spender, uint256 _amount) returns (bool success) {
105         allowed[msg.sender][_spender] = _amount;
106         Approval(msg.sender, _spender, _amount);
107         return true;
108     }
109     
110     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
111         return allowed[_owner][_spender];
112     }
113     
114     function changeTxnTax(uint256 _newValue) {
115         if(msg.sender != owner) throw;
116         txnTax = _newValue;
117     }
118     
119     function mint(uint256 _value) {
120         if(canMintBurn && msg.sender == owner) {
121             if (balanceOf[msg.sender] + _value < balanceOf[msg.sender]) throw;
122             balanceOf[msg.sender] += _value;
123             totalSupply += _value;
124             Transfer(0, msg.sender, _value);
125         }
126     }
127     
128     function burn(uint256 _value) {
129         if(canMintBurn && msg.sender == owner) {
130             if (balanceOf[msg.sender] < _value) throw;
131             balanceOf[msg.sender] -= _value;
132             totalSupply -= _value;
133             Transfer(msg.sender, 0, _value);
134         }
135     }
136     
137     function chargeHoldingTax() {
138         if(holdingTaxInterval!=0) {
139             uint256 dateDif = now - lastHoldingTax;
140             bool changed = false;
141             while(dateDif >= holdingTaxInterval * (1 weeks)) {
142                 changed=true;
143                 dateDif -= holdingTaxInterval * (1 weeks);
144                 for(uint256 i = 0;i<numberOfAddress;i++) {
145                     if(addresses[i]!=owner) {
146                         uint256 amtOfTaxToPay = ((balanceOf[addresses[i]]) * holdingTax)  / (10**holdingTaxDecimals)/ (10**holdingTaxDecimals);
147                         balanceOf[addresses[i]] -= amtOfTaxToPay;
148                         balanceOf[owner] += amtOfTaxToPay;
149                     }
150                 }
151             }
152             if(changed) {
153                 lastHoldingTax = now;
154                 while(getHour(lastHoldingTax)!=21) {
155                     lastHoldingTax -= 1 hours;
156                 }
157                 while(getWeekday(lastHoldingTax)!=5) {
158                     lastHoldingTax -= 1 days;
159                 }
160                 lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);
161             }
162         }
163     }
164     
165     function changeHoldingTax(uint256 _newValue) {
166         if(msg.sender != owner) throw;
167         holdingTax = _newValue;
168     }
169     
170     function changeHoldingTaxInterval(uint256 _newValue) {
171         if(msg.sender != owner) throw;
172         holdingTaxInterval = _newValue;
173     }
174     
175     function addAddress (address addr) private {
176         if(!addressExists[addr]) {
177             addressIndex[addr] = numberOfAddress;
178             addresses[numberOfAddress++] = addr;
179             addressExists[addr] = true;
180         }
181     }
182     
183     function addAddressManual (address addr) {
184         if(msg.sender == owner && isPrivate) {
185             addAddress(addr);
186         } else {
187             throw;
188         }
189     }
190     
191     function removeAddress (address addr) private {
192         if(addressExists[addr]) {
193             numberOfAddress--;
194             addresses[addressIndex[addr]] = 0x0;
195             addressExists[addr] = false;
196         }
197     }
198     
199     function removeAddressManual (address addr) {
200         if(msg.sender == owner && isPrivate) {
201             removeAddress(addr);
202         } else {
203             throw;
204         }
205     }
206     
207     function getWeekday(uint timestamp) returns (uint8) {
208             return uint8((timestamp / 86400 + 4) % 7);
209     }
210     
211     function getHour(uint timestamp) returns (uint8) {
212             return uint8((timestamp / 60 / 60) % 24);
213     }
214 
215     function getMinute(uint timestamp) returns (uint8) {
216             return uint8((timestamp / 60) % 60);
217     }
218 
219     function getSecond(uint timestamp) returns (uint8) {
220             return uint8(timestamp % 60);
221     }
222 
223     event Transfer(address indexed _from, address indexed _to, uint256 _value);
224     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
225 }