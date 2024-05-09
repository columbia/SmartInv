1 pragma solidity ^0.4.24;
2 
3 //設定管理者//
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 }    
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
18 
19 contract x32323 is owned{
20     
21 //設定初始值//
22 
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25     mapping (address => bool) public frozenAccount;
26 
27     event FrozenFunds(address target, bool frozen);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     function freezeAccount(address target, bool freeze) onlyOwner {
31         frozenAccount[target] = freeze;
32         FrozenFunds(target, freeze);
33     }
34 
35     string public name;
36     string public symbol;
37     uint8 public decimals = 2;
38     uint256 public totalSupply;
39     
40 //初始化//
41 
42     function TokenERC20(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47 	totalSupply = 1000000000 * 100 ;
48     	balanceOf[msg.sender] = totalSupply ;
49         name = "Leimen coin";
50         symbol = "Lem";         
51     }
52     
53 //管理權限//
54 
55     uint256 minBalance ;
56     uint256 price ;
57     bool stopped ;
58     bool selling;
59 
60 
61     function set_prices(uint256 price_wei) onlyOwner {
62         price = price_wei  ;
63     }
64 
65     function withdrawal_Lem(uint256 amount)  onlyOwner {
66         require(balanceOf[this] >= amount) ;
67         balanceOf[this] -= amount ;
68         balanceOf[msg.sender] += amount ;
69     }
70     
71     function withdrawal_Eth(uint amount_wei) onlyOwner {
72         msg.sender.transfer(amount_wei) ;
73     }
74     
75     function set_Name(string _name) onlyOwner {
76         name = _name;
77     }
78     
79     function set_symbol(string _symbol) onlyOwner {
80         symbol = _symbol;
81     }
82     
83     function set_sell(bool _selling) onlyOwner {
84         selling = _selling;
85     }
86     
87     function stop() onlyOwner {
88         stopped = true;
89     }
90 
91     function start() onlyOwner {
92         stopped = false;
93     }
94 
95 //交易//
96 
97     function _transfer(address _from, address _to, uint _value) internal {
98 	    require(!frozenAccount[_from]);
99 	    require(!stopped);
100         require(_to != 0x0);
101         
102         require(_value >= 0);
103         require(balanceOf[_from] >= _value);
104         require(balanceOf[_to] + _value > balanceOf[_to]);
105         
106         uint previousBalances = balanceOf[_from] + balanceOf[_to];
107 
108         balanceOf[_from] -= _value;
109         balanceOf[_to] += _value;
110         Transfer(_from, _to, _value);
111 
112         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
113     }
114 
115     function transfer(address _to, uint256 _value) public {
116         _transfer(msg.sender, _to, _value);
117 	    }
118 
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
120         require(_value <= allowance[_from][msg.sender]); 
121         allowance[_from][msg.sender] -= _value;
122         _transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function approve(address _spender, uint256 _value) public
127         returns (bool success) {
128         allowance[msg.sender][_spender] = _value;
129         return true;
130     }
131 
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142 //販售
143 
144     function () payable {
145         buy();
146     }
147 
148     function buy() payable returns (uint amount){
149         require(price != 0);
150 	    require(selling);
151         amount = msg.value / price * 100 ;
152         require(balanceOf[this] > amount);           
153         balanceOf[msg.sender] += amount;           
154         balanceOf[this] -= amount; 
155         Transfer(this, msg.sender, amount);         
156         return amount;    
157     }
158 }