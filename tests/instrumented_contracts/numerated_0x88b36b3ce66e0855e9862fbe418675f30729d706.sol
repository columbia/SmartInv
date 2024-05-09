1 pragma solidity ^0.4.15;
2 /* @file
3  * @title Coin
4  * @version 1.2.0
5 */
6 contract Coin {
7   string public constant symbol = "BTRC";
8   string public constant name = "BiTUBER";
9   uint8 public constant decimals = 18;
10   uint256 public _totalSupply = 0;
11   uint256 public price = 100;
12   bool private workingState = false;
13   bool private transferAllowed = false;
14   bool private generationState = true;
15   address public owner;
16   address private cur_coin;
17   mapping (address => uint256) balances;
18   mapping (address => mapping (address => uint256)) allowed;
19   mapping (address => uint256) private etherClients;
20   event FundsGot(address indexed _sender, uint256 _value);
21   event Transfer(address indexed _from, address indexed _to, uint256 _value);
22   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23   event TokenGenerationEnabled();
24   event TokenGenerationDisabled();
25   event ContractEnabled();
26   event ContractDisabled();
27   event TransferEnabled();
28   event TransferDisabled();
29   event CurrentCoin(address coin);
30   event Refund(address client, uint256 amount, uint256 tokens);
31   event TokensSent(address client, uint256 amount);
32   event PaymentGot(bool result);
33   modifier onlyOwner {
34     require(msg.sender == owner);
35     _;
36   }
37   modifier ownerAndCoin {
38     require((msg.sender == owner)||(msg.sender == cur_coin));
39     _;
40   }
41   modifier workingFlag {
42     require(workingState == true);
43     _;
44   }
45   modifier transferFlag {
46     require(transferAllowed == true);
47     _;
48   }
49 
50   function Coin() public payable {
51     owner = msg.sender;
52     enableContract();
53   }
54   function refund(address _client, uint256 _amount, uint256 _tokens) public workingFlag ownerAndCoin {
55     balances[_client] -= _tokens;
56     balances[address(this)] += _tokens;
57     _client.transfer(_amount);
58     Refund(_client, _amount, _tokens);
59   }
60   function kill() public onlyOwner {
61     require(workingState == false);
62     selfdestruct(owner);
63   }
64   function setCurrentCoin(address current) public onlyOwner workingFlag {
65     cur_coin = current;
66     CurrentCoin(cur_coin);
67   }
68 
69   //work controller functions
70   function enableContract() public onlyOwner {
71     workingState = true;
72     ContractEnabled();
73   }
74   function disableContract() public onlyOwner {
75     workingState = false;
76     ContractDisabled();
77   }
78   function contractState() public view returns (string state) {
79     if (workingState) {
80       state = "Working";
81     }
82     else {
83       state = "Stopped";
84     }
85   }
86   function enableGeneration() public onlyOwner {
87     generationState = true;
88     TokenGenerationEnabled();
89   }
90   function disableGeneration() public onlyOwner {
91     generationState = false;
92     TokenGenerationDisabled();
93   }
94   function tokenGenerationState() public view returns (string state) {
95     if (generationState) {
96       state = "Working";
97     }
98     else {
99       state = "Stopped";
100     }
101   }
102   //transfer controller functions
103   function enableTransfer() public onlyOwner {
104     transferAllowed = true;
105     TransferEnabled();
106   }
107   function disableTransfer() public onlyOwner {
108     transferAllowed = false;
109     TransferDisabled();
110   }
111   function transferState() public view returns (string state) {
112     if (transferAllowed) {
113       state = "Working";
114     }
115     else {
116       state = "Stopped";
117     }
118   }
119   //token controller functions
120   function generateTokens(address _client, uint256 _amount) public ownerAndCoin workingFlag {
121     if (_client == address(this))
122     {
123       balances[address(this)] += _amount;
124 		  _totalSupply += _amount;
125     }
126     else
127     {
128       if (balances[address(this)] >= _amount)
129       {
130         transferFrom(address(this), _client, _amount);
131       }
132       else
133       {
134         uint256 de = _amount - balances[address(this)];
135         transferFrom(address(this), _client, balances[address(this)]);
136         _totalSupply += de;
137         balances[_client] += de;
138       }
139     }
140     TokensSent(_client, _amount);
141   }
142   function setPrice(uint256 _price) public onlyOwner {
143     price = _price;
144   }
145   function getPrice() public view returns (uint256 _price) {
146     _price = price;
147   }
148   //send ether function (working)
149   function () public workingFlag payable {
150     bool ret = false;
151     if (generationState) {
152        ret = cur_coin.call(bytes4(keccak256("pay(address,uint256,uint256)")), msg.sender, msg.value, price);
153     }
154     PaymentGot(ret);
155   }
156   function totalSupply() public constant workingFlag returns (uint256 totalsupply) {
157     totalsupply = _totalSupply;
158   }
159   //ERC20 Interface
160   function balanceOf(address _owner) public constant workingFlag returns (uint256 balance) {
161     return balances[_owner];
162   }
163   function transfer(address _to, uint256 _value) public workingFlag returns (bool success) {
164     if (balances[msg.sender] >= _value
165       && _value > 0
166       && balances[_to] + _value > balances[_to])
167       {
168         if ((msg.sender == address(this))||(_to == address(this))) {
169           balances[msg.sender] -= _value;
170           balances[_to] += _value;
171           Transfer(msg.sender, _to, _value);
172           return true;
173         }
174         else {
175           if (transferAllowed == true) {
176             balances[msg.sender] -= _value;
177             balances[_to] += _value;
178             Transfer(msg.sender, _to, _value);
179             return true;
180           }
181           else {
182             return false;
183           }
184         }
185       }
186       else {
187         return false;
188       }
189   }
190   function transferFrom(address _from, address _to, uint256 _value) public workingFlag returns (bool success) {
191     if ((msg.sender == cur_coin)||(msg.sender == owner)) {
192       allowed[_from][_to] = _value;
193     }
194     if (balances[_from] >= _value
195       && allowed[_from][_to] >= _value
196       && _value > 0
197       && balances[_to] + _value > balances[_to])
198       {
199         if ((_from == address(this))||(_to == address(this))) {
200           balances[_from] -= _value;
201           allowed[_from][_to] -= _value;
202           balances[_to] += _value;
203           Transfer(_from, _to, _value);
204           return true;
205         }
206         else {
207           if (transferAllowed == true) {
208             balances[_from] -= _value;
209             allowed[_from][_to] -= _value;
210             balances[_to] += _value;
211             Transfer(_from, _to, _value);
212             return true;
213           }
214           else {
215             return false;
216           }
217         }
218       }
219       else {
220         return false;
221       }
222   }
223   function approve(address _spender, uint256 _value) public returns (bool success) {
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
229     return allowed[_owner][_spender];
230   }
231 }