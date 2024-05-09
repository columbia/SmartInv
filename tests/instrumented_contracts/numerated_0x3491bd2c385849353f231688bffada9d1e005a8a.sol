1 pragma solidity ^0.4.15;
2 /* @file
3  * @title Coin
4  * @version 1.2.1
5 */
6 contract Coin {
7   string public constant symbol = "BTRC";
8   string public constant name = "BITUBER";
9   uint8 public constant decimals = 18;
10   uint256 public _totalSupply = 0;
11   uint256 public price = 1500;
12   bool private workingState = false;
13   bool private transferAllowed = false;
14   address public owner;
15   address private cur_coin;
16   mapping (address => uint256) balances;
17   mapping (address => mapping (address => uint256)) allowed;
18   mapping (address => uint256) private etherClients;
19   event FundsGot(address indexed _sender, uint256 _value);
20   event Transfer(address indexed _from, address indexed _to, uint256 _value);
21   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22   event ContractEnabled();
23   event ContractDisabled();
24   event TransferEnabled();
25   event TransferDisabled();
26   event CurrentCoin(address coin);
27   event Refund(address client, uint256 amount);
28   event TokensSent(address client, uint256 amount);
29   modifier onlyOwner {
30     require(msg.sender == owner);
31     _;
32   }
33   modifier ownerAndCoin {
34     require((msg.sender == owner)||(msg.sender == cur_coin));
35     _;
36   }
37   modifier workingFlag {
38     require(workingState == true);
39     _;
40   }
41   modifier transferFlag {
42     require(transferAllowed == true);
43     _;
44   }
45 
46   function Coin() public payable {
47     owner = msg.sender;
48     enableContract();
49   }
50   function refund(address _client, uint256 _amount, uint256 _tokens) public workingFlag ownerAndCoin {
51     transferFrom(_client, address(this), _tokens);
52     _client.transfer(_amount);
53     Refund(_client, _amount);
54   }
55   function kill() public onlyOwner {
56     require(workingState == false);
57     selfdestruct(owner);
58   }
59   function setCurrentCoin(address current) public onlyOwner workingFlag {
60     cur_coin = current;
61     CurrentCoin(cur_coin);
62   }
63 
64   //work controller functions
65   function enableContract() public onlyOwner {
66     workingState = true;
67     ContractEnabled();
68   }
69   function disableContract() public onlyOwner {
70     workingState = false;
71     ContractDisabled();
72   }
73   function contractState() public view returns (string state) {
74     if (workingState) {
75       state = "Working";
76     }
77     else {
78       state = "Stopped";
79     }
80   }
81   //transfer controller functions
82   function enableTransfer() public onlyOwner {
83     transferAllowed = true;
84     TransferEnabled();
85   }
86   function disableTransfer() public onlyOwner {
87     transferAllowed = false;
88     TransferDisabled();
89   }
90   function transferState() public view returns (string state) {
91     if (transferAllowed) {
92       state = "Working";
93     }
94     else {
95       state = "Stopped";
96     }
97   }
98   //token controller functions
99   function generateTokens(address _client, uint256 _amount) public ownerAndCoin workingFlag {
100     if (_client == address(this)) {
101 		balances[address(this)] += _amount;
102 		_totalSupply += _amount;
103 	}
104 	else
105 	{
106 		if (balances[address(this)] >= _amount)
107 		{
108 			transferFrom(address(this), _client, _amount);
109 		}
110 		else
111 		{
112 			uint256 de = _amount - balances[address(this)];
113 			transferFrom(address(this), _client, balances[address(this)]);
114 			_totalSupply += de;
115 			balances[_client] += de;
116 		}
117 	}
118     TokensSent(_client, _amount);
119   }
120   function setPrice(uint256 _price) public onlyOwner {
121     price = _price;
122   }
123   function getPrice() public view returns (uint256 _price) {
124     _price = price;
125   }
126   //send ether function (working)
127   function () public workingFlag payable {
128     bool ret = cur_coin.call(bytes4(keccak256("pay(address,uint256,uint256)")), msg.sender, msg.value, price);
129     ret;
130   }
131   function totalSupply() public constant workingFlag returns (uint256 totalsupply) {
132     totalsupply = _totalSupply;
133   }
134   //ERC20 Interface
135   function balanceOf(address _owner) public constant workingFlag returns (uint256 balance) {
136     return balances[_owner];
137   }
138   function transfer(address _to, uint256 _value) public workingFlag returns (bool success) {
139     if (balances[msg.sender] >= _value
140       && _value > 0
141       && balances[_to] + _value > balances[_to])
142       {
143         if ((msg.sender == address(this))||(_to == address(this))) {
144           balances[msg.sender] -= _value;
145           balances[_to] += _value;
146           Transfer(msg.sender, _to, _value);
147           return true;
148         }
149         else {
150           if (transferAllowed == true) {
151             balances[msg.sender] -= _value;
152             balances[_to] += _value;
153             Transfer(msg.sender, _to, _value);
154             return true;
155           }
156           else {
157             return false;
158           }
159         }
160       }
161       else {
162         return false;
163       }
164   }
165   function transferFrom(address _from, address _to, uint256 _value) public workingFlag returns (bool success) {
166 	if ((msg.sender == cur_coin)||(msg.sender == owner)) {
167       allowed[_from][msg.sender] = _value;
168     }
169     if (balances[_from] >= _value
170       && allowed[_from][msg.sender] >= _value
171       && _value > 0
172       && balances[_to] + _value > balances[_to])
173       {
174         if ((_from == address(this))||(_to == address(this))) {
175           balances[msg.sender] -= _value;
176           allowed[_from][msg.sender] -= _value;
177           balances[_to] += _value;
178           Transfer(_from, _to, _value);
179           return true;
180         }
181         else {
182           if (transferAllowed == true) {
183             balances[msg.sender] -= _value;
184             allowed[_from][msg.sender] -= _value;
185             balances[_to] += _value;
186             Transfer(_from, _to, _value);
187             return true;
188           }
189           else {
190             return false;
191           }
192         }
193       }
194       else {
195         return false;
196       }
197   }
198   function approve(address _spender, uint256 _value) public returns (bool success) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
204     return allowed[_owner][_spender];
205   }
206 }