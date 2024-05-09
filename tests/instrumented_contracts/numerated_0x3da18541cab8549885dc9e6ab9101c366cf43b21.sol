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
19 contract Leimen is owned{
20     
21 //設定初始值//
22 
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     event FrozenFunds(address target, bool frozen);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Burn(address indexed from, uint256 value);
29 
30     string public name;
31     string public symbol;
32     uint8 public decimals = 2;
33     uint256 public totalSupply;
34     
35 //初始化//
36 
37     function Leimen() public {
38 	    totalSupply = 1000000000 * 100 ;
39     	balanceOf[msg.sender] = totalSupply ;
40         name = "Leimen test";
41         symbol = "Lts";         
42     }
43     
44 //管理權限//
45 
46     mapping (address => bool) public frozenAccount;
47     uint256 public eth_amount ;
48     bool public stoptransfer ;
49     bool public stopsell;
50     
51 
52     function freezeAccount(address target, bool freeze) onlyOwner {
53         frozenAccount[target] = freeze;
54         FrozenFunds(target, freeze);
55     }
56 
57     function set_prices(uint256 _eth_amount) onlyOwner {
58         eth_amount  = _eth_amount  ;
59     }
60 
61     function withdraw_Leim(uint256 amount)  onlyOwner {
62         require(balanceOf[this] >= amount) ;
63         balanceOf[this] -= amount ;
64         balanceOf[msg.sender] += amount ;
65     }
66     
67     function withdraw_Eth(uint amount_wei) onlyOwner {
68         msg.sender.transfer(amount_wei) ;
69     }
70     
71     function set_Name(string _name) onlyOwner {
72         name = _name;
73     }
74     
75     function set_symbol(string _symbol) onlyOwner {
76         symbol = _symbol;
77     }
78     
79     function set_stopsell(bool _stopsell) onlyOwner {
80         stopsell = _stopsell;
81     }
82     
83     function set_stoptransfer(bool _stoptransfer) onlyOwner {
84         stoptransfer = _stoptransfer;
85     }
86     
87     function burn(uint256 _value) onlyOwner {
88         require(_value > 0);
89         require(balanceOf[msg.sender] >= _value);   
90         balanceOf[msg.sender] -= _value;            
91         totalSupply -= _value;                      
92         Burn(msg.sender, _value);
93     }    
94 
95 //交易//
96 
97     function _transfer(address _from, address _to, uint _value) internal {
98 	    require(!frozenAccount[_from]);
99 	    require(!stoptransfer);
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
149 	    require(!stopsell);
150         amount = msg.value * eth_amount / (10 ** 18) ;
151         require(balanceOf[this] >= amount);           
152         balanceOf[msg.sender] += amount;           
153         balanceOf[this] -= amount; 
154         Transfer(this, msg.sender, amount);         
155         return amount;    
156     }
157 }