1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
4 
5 contract owned {
6     address public owner;
7 
8     constructor() public{
9         owner = msg.sender;
10     }
11 
12     event SelfMessage(address backer1, address backer2);
13     
14     modifier isOwner {
15         emit SelfMessage(msg.sender, owner);
16         require(msg.sender == owner);
17         _;
18     }
19 }
20 
21 
22 contract GAMTToken is owned{
23     string public constant name = "ga-me.io token";
24     string public constant symbol = "GAMT";
25     uint8 public constant decimals = 18;  // 18 是建议的默认值
26     uint256 public totalSupply;
27     uint256 amountRaised = 0;
28     bool public crowdSale = false;
29 
30     mapping (address => uint256) public balanceOf;  // 
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     mapping (address => bool) public frozenAccount;
34     mapping (address => bool) public airDropAccount;
35     event FreezeAccount(address target, bool frozen);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Burn(address indexed from, uint256 value);
39     event CrowdSaleTransfer(address backer, uint256 crowdNum,  uint256 amount, bool indexed isContribution);
40     
41 
42     constructor() public {
43         totalSupply = 1000000000 * 10 ** uint256(decimals);
44         balanceOf[msg.sender] = totalSupply;
45         owner = msg.sender;
46     }
47 
48     function _transfer(address _from, address _to, uint _value) internal {
49         require(_to != 0x0);
50         require(balanceOf[_from] >= _value);
51         require(balanceOf[_to] + _value > balanceOf[_to]);
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         balanceOf[_from] -= _value;
54         balanceOf[_to] += _value;
55         emit Transfer(_from, _to, _value);
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59     function transfer(address _to, uint256 _value) public {
60         require(!frozenAccount[msg.sender]);
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         require(_value <= allowance[_from][msg.sender]);     // Check allowance
66         allowance[_from][msg.sender] -= _value;
67         _transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function approve(address _spender, uint256 _value) public
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         return true;
75     }
76 
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85     function burn(uint256 _value) public returns (bool success) {
86         require(balanceOf[msg.sender] >= _value);
87         balanceOf[msg.sender] -= _value;
88         totalSupply -= _value;
89         emit Burn(msg.sender, _value);
90         return true;
91     }
92 
93     function burnFrom(address _from, uint256 _value) public returns (bool success) {
94         require(balanceOf[_from] >= _value);
95         require(_value <= allowance[_from][msg.sender]);
96         balanceOf[_from] -= _value;
97         allowance[_from][msg.sender] -= _value;
98         totalSupply -= _value;
99         emit Burn(_from, _value);
100         return true;
101     }
102 
103     function () payable public{
104         require(crowdSale);
105         uint256 amountETH = msg.value;
106         uint256 count = amountETH / 10 ** uint256(15);
107         uint256 tokenNum = 0;
108         if (0 == amountETH){
109             require(!airDropAccount[msg.sender]);
110             tokenNum  = 200* 10 ** uint256(decimals);
111             _transfer(address(this), msg.sender, tokenNum);
112 
113             airDropAccount[msg.sender] = true;
114             emit CrowdSaleTransfer(msg.sender, amountETH, tokenNum, true);
115         } else if (0 <amountETH && amountETH <5 * 10 **uint256(16)) {
116             //0~0.05
117             tokenNum  = 1000*count*10 ** uint256(decimals);
118             amountRaised += amountETH;
119             _transfer(address(this), msg.sender, tokenNum);
120             emit CrowdSaleTransfer(msg.sender, amountETH, tokenNum, true);
121         } else if (5 * 10 **uint256(16) <=amountETH && amountETH < 5 * 10 **uint256(17)) {
122             //0.05~0.05
123             tokenNum  = 1250*count*10 ** uint256(decimals);
124             amountRaised += amountETH;
125             _transfer(address(this), msg.sender, tokenNum);
126             emit CrowdSaleTransfer(msg.sender, amountETH, tokenNum, true);
127         } else {
128             //0.5~
129             tokenNum  = 1500*count*10 ** uint256(decimals);
130             amountRaised += amountETH;
131             _transfer(address(this), msg.sender, tokenNum);
132             emit CrowdSaleTransfer(msg.sender, amountETH, tokenNum, true);
133         }
134     }
135 
136     function drawEther() isOwner public {
137             if (owner.send(amountRaised)) {
138                 amountRaised = 0;
139             }
140     }
141 
142     function onOffCrowdSale(bool onOff) isOwner public {
143         crowdSale = onOff;
144         if(false == crowdSale){
145             uint256 restToken = balanceOf[this];
146             if (restToken > 0){
147                 _transfer(address(this), owner, restToken);
148             } else {
149             }
150         }
151     }
152 
153     function freezeAccount(address target, bool freeze) isOwner public{
154         frozenAccount[target] = freeze;
155         emit FreezeAccount(target, freeze);
156     }
157 }