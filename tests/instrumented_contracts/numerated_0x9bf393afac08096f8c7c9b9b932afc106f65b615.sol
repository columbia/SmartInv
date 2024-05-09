1 pragma solidity ^0.4.16;
2 
3 contract Token {
4     uint8 public decimals = 6;
5     uint8 public referralPromille = 20;
6     uint256 public totalSupply = 2000000000000;
7     uint256 public buyPrice = 1600000000;
8     uint256 public sellPrice = 1400000000;
9     string public name = "Brisfund token";
10     string public symbol = "BRIS";
11     mapping (address => bool) public lock;
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     address owner;
15 
16     function Token() public {
17         owner = msg.sender;
18         balanceOf[owner] = totalSupply;
19     }
20 
21     function transfer(address _to, uint256 _value) public returns (bool) {
22         require(!lock[msg.sender]);
23         require(balanceOf[msg.sender] >= _value);
24         require(balanceOf[_to] + _value >= balanceOf[_to]);
25         balanceOf[msg.sender] -= _value;
26         balanceOf[_to] += _value;
27         Transfer(msg.sender, _to, _value);
28         return true;
29     }
30 
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
32         require(!lock[_from]);
33         require(allowance[_from][msg.sender] >= _value);
34         require(balanceOf[_from] >= _value);
35         require(balanceOf[_to] + _value >= balanceOf[_to]);
36         allowance[_from][msg.sender] -= _value;
37         balanceOf[_from] -= _value;
38         balanceOf[_to] += _value;
39         Transfer(_from, _to, _value);
40         return true;
41     }
42 
43     function approve(address _spender, uint256 _value) public returns (bool) {
44         allowance[msg.sender][_spender] = _value;
45         Approval(msg.sender, _spender, _value);
46         return true;
47     }
48 
49     function setBlocking(address _address, bool _state) public onlyOwner returns (bool) {
50         lock[_address] = _state;
51         return true;
52     }
53 
54     function setReferralPromille(uint8 _promille) public onlyOwner returns (bool) {
55         require(_promille < 100);
56         referralPromille = _promille;
57         return true;
58     }
59 
60     function setPrice(uint256 _buyPrice, uint256 _sellPrice) public onlyOwner returns (bool) {
61         require(_sellPrice > 0);
62         require(_buyPrice > _sellPrice);
63         buyPrice = _buyPrice;
64         sellPrice = _sellPrice;
65         return true;
66     }
67 
68     function buy() public payable returns (bool) {
69         uint value = msg.value / buyPrice;
70         require(balanceOf[owner] >= value);
71         require(balanceOf[msg.sender] + value > balanceOf[msg.sender]);
72         balanceOf[owner] -= value;
73         balanceOf[msg.sender] += value;
74         Transfer(owner, msg.sender, value);
75         return true;
76     }
77 
78     function buyWithReferral(address _referral) public payable returns (bool) {
79         uint value = msg.value / buyPrice;
80         uint bonus = value / 1000 * referralPromille;
81         require(balanceOf[owner] >= value + bonus);
82         require(balanceOf[msg.sender] + value > balanceOf[msg.sender]);
83         require(balanceOf[_referral] + bonus >= balanceOf[_referral]);
84         balanceOf[owner] -= value + bonus;
85         balanceOf[msg.sender] += value;
86         balanceOf[_referral] += bonus;
87         Transfer(owner, msg.sender, value);
88         Transfer(owner, _referral, bonus);
89         return true;
90     }
91 
92     function sell(uint256 _tokenAmount) public returns (bool) {
93         require(!lock[msg.sender]);
94         uint ethValue = _tokenAmount * sellPrice;
95         require(this.balance >= ethValue);
96         require(balanceOf[msg.sender] >= _tokenAmount);
97         require(balanceOf[owner] + _tokenAmount > balanceOf[owner]);
98         balanceOf[msg.sender] -= _tokenAmount;
99         balanceOf[owner] += _tokenAmount;
100         msg.sender.transfer(ethValue);
101         Transfer(msg.sender, owner, _tokenAmount);
102         return true;
103     }
104 
105     function changeSupply(uint256 _value, bool _add) public onlyOwner returns (bool) {
106         if(_add) {
107             require(balanceOf[owner] + _value > balanceOf[owner]);
108             balanceOf[owner] += _value;
109             totalSupply += _value;
110             Transfer(0, owner, _value);
111         } else {
112             require(balanceOf[owner] >= _value);
113             balanceOf[owner] -= _value;
114             totalSupply -= _value;
115             Transfer(owner, 0, _value);
116         }
117         return true;
118     }
119 
120     function reverse(address _reversed, uint256 _value) public onlyOwner returns (bool) {
121         require(balanceOf[_reversed] >= _value);
122         require(balanceOf[owner] + _value > balanceOf[owner]);
123         balanceOf[_reversed] -= _value;
124         balanceOf[owner] += _value;
125         Transfer(_reversed, owner, _value);
126         return true;
127     }
128 
129     function transferOwnership(address newOwner) public onlyOwner {
130         owner = newOwner;
131     }
132 
133     function kill() public onlyOwner {
134         selfdestruct(owner);
135     }
136 
137     modifier onlyOwner {
138         require(msg.sender == owner);
139         _;
140     }
141 
142     event Transfer(address indexed _from, address indexed _to, uint256 _value);
143 
144     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
145 }