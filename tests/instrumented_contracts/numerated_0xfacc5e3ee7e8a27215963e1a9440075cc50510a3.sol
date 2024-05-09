1 pragma solidity ^0.4.4;
2 
3 contract Token {
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
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         if (balances[msg.sender] >= _value && (balances[_to] + _value) > balances[_to] && _value > 0) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             Transfer(msg.sender, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to] && _value > 0) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function balanceOf(address _owner) constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     function approve(address _spender, uint256 _value) returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
72         return allowed[_owner][_spender];
73     }
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;
77     uint256 public totalSupply;
78 }
79 
80 contract IAHCToken is StandardToken {
81 
82     string public constant name   = "IAHC";
83     string public constant symbol = "IAHC";
84 
85     uint8 public constant decimals = 8;
86     uint  public constant decimals_multiplier = 100000000;
87 
88     address public constant ESCROW_WALLET = 0x3D7FaD8174dac0df6a0a3B473b9569f7618d07E2;
89 
90     uint public constant icoSupply          = 500000000 * decimals_multiplier; //0,5 billion (500,000,000 IAHC coins will be available for purchase (25% of total IAHC)
91     uint public constant icoTokensPrice     = 142000;                          //wei / decimals, base price: 0.0000142 ETH per 1 IAHC
92     uint public constant icoMinCap          = 100   ether;
93     uint public constant icoMaxCap          = 7000  ether;
94 
95     uint public constant whiteListMinAmount = 0.50  ether;
96     uint public constant preSaleMinAmount   = 0.25  ether;
97     uint public constant crowdSaleMinAmount = 0.10  ether;
98 
99     address public icoOwner;
100     uint public icoLeftSupply  = icoSupply; //current left tokens to sell during ico
101     uint public icoSoldCap     = 0;         //current sold value in wei
102 
103     uint public whiteListTime         = 1519084800; //20.02.2018 (40% discount)
104     uint public preSaleListTime       = 1521590400; //21.03.2018 (28% discount)
105     uint public crowdSaleTime         = 1524355200; //22.04.2018 (10% discount)
106     uint public crowdSaleEndTime      = 1526947200; //22.05.2018 (0% discount)
107     uint public icoEndTime            = 1529712000; //23.06.2018
108     uint public guarenteedPaybackTime = 1532304000; //23.07.2018
109 
110     mapping(address => bool) public whiteList;
111     mapping(address => uint) public icoContributions;
112 
113     function IAHCToken(){
114         icoOwner = msg.sender;
115         balances[icoOwner] = 2000000000 * decimals_multiplier - icoSupply; //froze ico tokens
116         totalSupply = 2000000000 * decimals_multiplier;
117     }
118 
119     modifier onlyOwner() {
120         require(msg.sender == icoOwner);
121         _;
122     }
123 
124     //unfroze tokens if some left unsold from ico
125     function icoEndUnfrozeTokens() public onlyOwner() returns(bool) {
126         require(now >= icoEndTime && icoLeftSupply > 0);
127 
128         balances[icoOwner] += icoLeftSupply;
129         icoLeftSupply = 0;
130     }
131 
132     //if soft cap is not reached - participant can ask ethers back
133     function minCapFail() public {
134         require(now >= icoEndTime && icoSoldCap < icoMinCap);
135         require(icoContributions[msg.sender] > 0 && balances[msg.sender] > 0);
136 
137         uint tokens = balances[msg.sender];
138         balances[icoOwner] += tokens;
139         balances[msg.sender] -= tokens;
140         uint contribution = icoContributions[msg.sender];
141         icoContributions[msg.sender] = 0;
142 
143         Transfer(msg.sender, icoOwner, tokens);
144 
145         msg.sender.transfer(contribution);
146     }
147 
148     // for info
149     function getCurrentStageDiscount() public constant returns (uint) {
150         uint discount = 0;
151         if (now >= icoEndTime && now < preSaleListTime) {
152             discount = 40;
153         } else if (now < crowdSaleTime) {
154             discount = 28;
155         } else if (now < crowdSaleEndTime) {
156             discount = 10;
157         }
158         return discount;
159     }
160 
161     function safePayback(address receiver, uint amount) public onlyOwner() {
162         require(now >= guarenteedPaybackTime);
163         require(icoSoldCap < icoMinCap);
164 
165         receiver.transfer(amount);
166     }
167 
168     // count tokens i could buy now
169     function countTokens(uint paid, address sender) public constant returns (uint) {
170         uint discount = 0;
171         if (now < preSaleListTime) {
172             require(whiteList[sender]);
173             require(paid >= whiteListMinAmount);
174             discount = 40;
175         } else if (now < crowdSaleTime) {
176             require(paid >= preSaleMinAmount);
177             discount = 28;
178         } else if (now < crowdSaleEndTime) {
179             require(paid >= crowdSaleMinAmount);
180             discount = 10;
181         }
182 
183         uint tokens = paid / icoTokensPrice;
184         if (discount > 0) {
185             tokens = tokens / (100 - discount) * 100;
186         }
187         return tokens;
188     }
189 
190     // buy tokens if you can
191     function () public payable {
192         contribute();
193     }
194 
195     function contribute() public payable {
196         require(now >= whiteListTime && now < icoEndTime && icoLeftSupply > 0);
197 
198         uint tokens = countTokens(msg.value, msg.sender);
199         uint payback = 0;
200         if (icoLeftSupply < tokens) {
201             //not enough tokens so we need to return some ethers back
202             payback = msg.value - (msg.value / tokens) * icoLeftSupply;
203             tokens = icoLeftSupply;
204         }
205         uint contribution = msg.value - payback;
206 
207         icoLeftSupply                -= tokens;
208         balances[msg.sender]         += tokens;
209         icoSoldCap                   += contribution;
210         icoContributions[msg.sender] += contribution;
211 
212         Transfer(icoOwner, msg.sender, tokens);
213 
214         if (icoSoldCap >= icoMinCap) {
215             ESCROW_WALLET.transfer(this.balance);
216         }
217         if (payback > 0) {
218             msg.sender.transfer(payback);
219         }
220     }
221 
222 
223     //lists
224     function addToWhitelist(address _participant) public onlyOwner() returns(bool) {
225         if (whiteList[_participant]) {
226             return true;
227         }
228         whiteList[_participant] = true;
229         return true;
230     }
231     function removeFromWhitelist(address _participant) public onlyOwner() returns(bool) {
232         if (!whiteList[_participant]) {
233             return true;
234         }
235         whiteList[_participant] = false;
236         return true;
237     }
238 
239 }