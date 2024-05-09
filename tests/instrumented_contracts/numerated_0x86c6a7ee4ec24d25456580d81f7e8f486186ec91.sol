1 pragma solidity ^0.4.19;
2 /* @file
3  * @title Coin
4  * @version 1.2.0
5 */
6 contract Coin {
7   string public constant symbol = "BTRC";
8   string public constant name = "Bituber";
9   uint8 public constant decimals = 18;
10   uint256 public _totalSupply = 0;
11   uint256 public _maxSupply = 33000000000000000000000;
12   uint256 public price = 2000;
13   bool private workingState = true;
14   bool private transferAllowed = true;
15   bool private generationState = true;
16   address public owner;
17   address private cur_coin;
18   mapping (address => uint256) balances;
19   mapping (address => mapping (address => uint256)) allowed;
20   mapping (address => uint256) private etherClients;
21   event FundsGot(address indexed _sender, uint256 _value);
22   event Transfer(address indexed _from, address indexed _to, uint256 _value);
23   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24   event TokenGenerationEnabled();
25   event TokenGenerationDisabled();
26   event ContractEnabled();
27   event ContractDisabled();
28   event TransferEnabled();
29   event TransferDisabled();
30   event CurrentCoin(address coin);
31   event Refund(address client, uint256 amount, uint256 tokens);
32   event TokensSent(address client, uint256 amount);
33   event PaymentGot(bool result);
34   modifier onlyOwner {
35     require(msg.sender == owner);
36     _;
37   }
38   modifier ownerAndCoin {
39     require((msg.sender == owner)||(msg.sender == cur_coin));
40     _;
41   }
42   modifier workingFlag {
43     require(workingState == true);
44     _;
45   }
46   modifier transferFlag {
47     require(transferAllowed == true);
48     _;
49   }
50 
51   function Coin() public payable {
52     owner = msg.sender;
53     enableContract();
54   }
55   function refund(address _client, uint256 _amount, uint256 _tokens) public workingFlag ownerAndCoin {
56     balances[_client] -= _tokens;
57     balances[address(this)] += _tokens;
58     _client.transfer(_amount);
59     Refund(_client, _amount, _tokens);
60   }
61   function kill() public onlyOwner {
62     require(workingState == false);
63     selfdestruct(owner);
64   }
65   function setCurrentCoin(address current) public onlyOwner workingFlag {
66     cur_coin = current;
67     CurrentCoin(cur_coin);
68   }
69 
70   //work controller functions
71   function enableContract() public onlyOwner {
72     workingState = true;
73     ContractEnabled();
74   }
75   function disableContract() public onlyOwner {
76     workingState = false;
77     ContractDisabled();
78   }
79   function contractState() public view returns (string state) {
80     if (workingState) {
81       state = "Working";
82     }
83     else {
84       state = "Stopped";
85     }
86   }
87   function enableGeneration() public onlyOwner {
88     generationState = true;
89     TokenGenerationEnabled();
90   }
91   function disableGeneration() public onlyOwner {
92     generationState = false;
93     TokenGenerationDisabled();
94   }
95   function tokenGenerationState() public view returns (string state) {
96     if (generationState) {
97       state = "Working";
98     }
99     else {
100       state = "Stopped";
101     }
102   }
103   function setMaxSupply(uint256 supply) public onlyOwner {
104     _maxSupply = supply;
105   }
106   //transfer controller functions
107   function enableTransfer() public onlyOwner {
108     transferAllowed = true;
109     TransferEnabled();
110   }
111   function disableTransfer() public onlyOwner {
112     transferAllowed = false;
113     TransferDisabled();
114   }
115   function transferState() public view returns (string state) {
116     if (transferAllowed) {
117       state = "Working";
118     }
119     else {
120       state = "Stopped";
121     }
122   }
123   //token controller functions
124   function generateTokens(address _client, uint256 _amount) public ownerAndCoin workingFlag returns (bool success) {
125     uint256 de = _amount - balances[address(this)];
126     if (_maxSupply >= _totalSupply + de)
127     {
128       if (_client == address(this))
129       {
130         balances[address(this)] += _amount;
131   		  _totalSupply += _amount;
132       }
133       else
134       {
135         if (balances[address(this)] >= _amount)
136         {
137           transferFrom(address(this), _client, _amount);
138         }
139         else
140         {
141           transferFrom(address(this), _client, balances[address(this)]);
142           _totalSupply += de;
143           balances[_client] += de;
144         }
145       }
146       TokensSent(_client, _amount);
147       return true;
148     }
149     else
150     {
151       return false;
152     }
153   }
154   function setPrice(uint256 _price) public onlyOwner {
155     price = _price;
156   }
157   //send ether function (working)
158   function () public workingFlag payable {
159     bool ret = false;
160     if (generationState) {
161        ret = cur_coin.call(bytes4(keccak256("pay(address,uint256,uint256)")), msg.sender, msg.value, price);
162     }
163     PaymentGot(ret);
164   }
165   function totalSupply() public constant workingFlag returns (uint256 totalsupply) {
166     totalsupply = _totalSupply;
167   }
168   //ERC20 Interface
169   function balanceOf(address _owner) public constant workingFlag returns (uint256 balance) {
170     return balances[_owner];
171   }
172   function transfer(address _to, uint256 _value) public workingFlag returns (bool success) {
173     if (balances[msg.sender] >= _value
174       && _value > 0
175       && balances[_to] + _value > balances[_to])
176       {
177         if ((msg.sender == address(this))||(_to == address(this))) {
178           balances[msg.sender] -= _value;
179           balances[_to] += _value;
180           Transfer(msg.sender, _to, _value);
181           return true;
182         }
183         else {
184           if (transferAllowed == true) {
185             balances[msg.sender] -= _value;
186             balances[_to] += _value;
187             Transfer(msg.sender, _to, _value);
188             return true;
189           }
190           else {
191             return false;
192           }
193         }
194       }
195       else {
196         return false;
197       }
198   }
199   function transferFrom(address _from, address _to, uint256 _value) public workingFlag returns (bool success) {
200     if ((msg.sender == cur_coin)||(msg.sender == owner)) {
201       allowed[_from][_to] = _value;
202     }
203     if (balances[_from] >= _value
204       && allowed[_from][_to] >= _value
205       && _value > 0
206       && balances[_to] + _value > balances[_to])
207       {
208         if ((_from == address(this))||(_to == address(this))) {
209           balances[_from] -= _value;
210           allowed[_from][_to] -= _value;
211           balances[_to] += _value;
212           Transfer(_from, _to, _value);
213           return true;
214         }
215         else {
216           if (transferAllowed == true) {
217             balances[_from] -= _value;
218             allowed[_from][_to] -= _value;
219             balances[_to] += _value;
220             Transfer(_from, _to, _value);
221             return true;
222           }
223           else {
224             return false;
225           }
226         }
227       }
228       else {
229         return false;
230       }
231   }
232   function approve(address _spender, uint256 _value) public returns (bool success) {
233     allowed[msg.sender][_spender] = _value;
234     Approval(msg.sender, _spender, _value);
235     return true;
236   }
237   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
238     return allowed[_owner][_spender];
239   }
240 }