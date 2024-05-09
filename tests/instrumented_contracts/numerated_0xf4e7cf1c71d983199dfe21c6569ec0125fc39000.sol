1 pragma solidity ^0.4.24;
2 
3 //設定管理者//
4 
5 contract owned {
6     address public owner;
7     address public owner2;
8 
9     function owned() {
10         owner = msg.sender;
11     }
12     function change_owned(address new_owner2) onlyOwner {
13         owner2 =  new_owner2;
14     }
15     
16     modifier onlyOwner {
17         require(msg.sender == owner || msg.sender == owner2);
18         _;
19     }
20 }    
21 
22 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
23     function tokenFallback(address _sender, uint256 _value, bytes _extraData) returns (bool);
24 }
25 
26 contract Leimen is owned{
27     
28 //設定初始值//
29 
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event FrozenFunds(address target, bool frozen);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Burn(address indexed from, uint256 value);
36 
37     string public name;
38     string public symbol;
39     uint8 public decimals = 2;
40     uint256 public totalSupply;
41     
42 //初始化//
43 
44     function Leimen() public {
45 	    totalSupply = 1000000000 * 100 ;
46     	balanceOf[msg.sender] = totalSupply ;
47         name = "Leimen coin";
48         symbol = "XLEM";         
49     }
50     
51 //管理權限//
52 
53     mapping (address => bool) public frozenAccount;
54     uint256 public eth_amount ;
55     bool public stoptransfer ;
56     bool public stopsell ;
57     
58 
59     function freezeAccount(address target, bool freeze) onlyOwner {
60         frozenAccount[target] = freeze;
61         emit FrozenFunds(target, freeze);
62     }
63 
64     function set_prices(uint256 _eth_amount) onlyOwner {
65         eth_amount  = _eth_amount  ;
66     }
67 
68     function withdraw_Leim(uint256 amount)  onlyOwner {
69         require(balanceOf[this] >= amount) ;
70         balanceOf[this] -= amount ;
71         balanceOf[msg.sender] += amount ;
72     }
73     
74     function withdraw_Eth(uint amount_wei) onlyOwner {
75         msg.sender.transfer(amount_wei) ;
76     }
77     
78     function set_Name(string _name) onlyOwner {
79         name = _name;
80     }
81     
82     function set_symbol(string _symbol) onlyOwner {
83         symbol = _symbol;
84     }
85     
86     function set_stopsell(bool _stopsell) onlyOwner {
87         stopsell = _stopsell;
88     }
89     
90     function set_stoptransfer(bool _stoptransfer) onlyOwner {
91         stoptransfer = _stoptransfer;
92     }
93     
94     function burn(uint256 _value) onlyOwner {
95         require(_value > 0);
96         require(balanceOf[msg.sender] >= _value);   
97         balanceOf[msg.sender] -= _value;            
98         totalSupply -= _value;                      
99         emit Burn(msg.sender, _value);
100     }    
101 
102 //交易//
103 
104     function _transfer(address _from, address _to, uint _value) 
105         internal returns(bool success){
106 	    require(!frozenAccount[_from]);
107 	    require(!stoptransfer);
108         require(_to != 0x0);
109         
110         require(_value >= 0);
111         require(balanceOf[_from] >= _value);
112         require(balanceOf[_to] + _value > balanceOf[_to]);
113         
114         uint previousBalances = balanceOf[_from] + balanceOf[_to];
115 
116         balanceOf[_from] -= _value;
117         balanceOf[_to] += _value;
118         emit Transfer(_from, _to, _value);
119 
120         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
121         return true;
122     }
123 
124     function transfer(address _to, uint256 _value) public returns (bool success){
125         if(compare(_to) == true){
126             transferAndCall(_to, _value , "");
127         }
128         else{
129             require(_transfer(msg.sender, _to, _value));
130         }
131         return true;
132 	}
133 
134 // 服務合約
135 
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
137         require(_value <= allowance[_from][msg.sender]); 
138         allowance[_from][msg.sender] -= _value;
139         require(_transfer(_from, _to, _value));
140         return true;
141     }
142 
143     function approve(address _spender, uint256 _value) public
144         returns (bool success) {
145         allowance[msg.sender][_spender] = _value;
146         return true;
147     }
148 
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
150         public
151         returns (bool success) {
152         tokenRecipient spender = tokenRecipient(_spender);
153         if (approve(_spender, _value)) {
154             spender.receiveApproval(msg.sender, _value, this, _extraData);
155             return true;
156         }
157     }
158     function transferAndCall(address _recipient, uint256 _value, bytes _extraData) {
159         require(_transfer(msg.sender, _recipient, _value));
160         require(tokenRecipient(_recipient).tokenFallback(msg.sender, _value, _extraData));
161     }
162 
163     address[]  public contract_address;
164     
165     function add_address(address _address){
166         contract_address.push(_address);
167     }
168 
169     function change_address(uint256 _index, address _address){
170         contract_address[_index] = _address;
171     }
172 
173     function compare(address _address) view public returns(bool){
174         uint i = 0;
175         for (i;i<contract_address.length;i++){
176             if (contract_address[i] == _address){
177                 return true;
178             }
179         }
180     }
181 
182 //幣販售
183 
184     function () payable {
185         buy();
186     }
187 
188     function buy() payable returns (uint amount){
189 	    require(!stopsell);
190         amount = msg.value * eth_amount  / (10**16) ;
191         assert(amount*(10**16)/eth_amount == msg.value);
192         require(balanceOf[this] >= amount);           
193         balanceOf[msg.sender] += amount;           
194         balanceOf[this] -= amount; 
195         Transfer(this, msg.sender, amount);         
196         return amount;    
197     }
198 }