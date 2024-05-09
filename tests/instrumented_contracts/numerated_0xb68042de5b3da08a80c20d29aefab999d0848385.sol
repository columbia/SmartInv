1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     require(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26     return c;
27   }
28 }
29 
30 interface tokenRecipient { 
31     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
32 }
33 
34 contract IDAGToken {
35     using SafeMath for uint256;
36     string public name = "iDAG SPACE";
37     string public symbol = "iDAG";
38     uint8 public decimals = 18;
39     uint256 public totalSupply = 50000000000 ether;
40     uint256 public totalAirDrop = totalSupply * 10 / 100;
41     uint256 public eachAirDropAmount = 80000 ether;
42     bool public airdropFinished = false;
43     mapping (address => bool) public airDropBlacklist;
44     mapping (address => bool) public transferBlacklist;
45 
46     mapping (address => uint256) public balanceOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Burn(address indexed from, uint256 value);
50 
51     function IDAGToken() public {
52         balanceOf[msg.sender] = totalSupply - totalAirDrop;
53     }
54     
55     modifier canAirDrop() {
56         require(!airdropFinished);
57         _;
58     }
59     
60     modifier onlyWhitelist() {
61         require(airDropBlacklist[msg.sender] == false);
62         _;
63     }
64     
65     function airDrop(address _to, uint256 _amount) canAirDrop private returns (bool) {
66         totalAirDrop = totalAirDrop.sub(_amount);
67         balanceOf[_to] = balanceOf[_to].add(_amount);
68         Transfer(address(0), _to, _amount);
69         return true;
70         
71         if (totalAirDrop <= _amount) {
72             airdropFinished = true;
73         }
74     }
75     
76     function inspire(address _to, uint256 _amount) private returns (bool) {
77         if (!airdropFinished) {
78             totalAirDrop = totalAirDrop.sub(_amount);
79             balanceOf[_to] = balanceOf[_to].add(_amount);
80             Transfer(address(0), _to, _amount);
81             return true;
82             if(totalAirDrop <= _amount){
83                 airdropFinished = true;
84             }
85         }
86     }
87     
88     function getAirDropTokens() payable canAirDrop onlyWhitelist public {
89         
90         require(eachAirDropAmount <= totalAirDrop);
91         
92         address investor = msg.sender;
93         uint256 toGive = eachAirDropAmount;
94         
95         airDrop(investor, toGive);
96         
97         if (toGive > 0) {
98             airDropBlacklist[investor] = true;
99         }
100 
101         if (totalAirDrop == 0) {
102             airdropFinished = true;
103         }
104         
105         eachAirDropAmount = eachAirDropAmount.sub(0.8 ether);
106     }
107     
108     function getInspireTokens(address _from, address _to,uint256 _amount) payable public{
109         uint256 toGive = eachAirDropAmount * 50 / 100;
110         if(toGive > totalAirDrop){
111             toGive = totalAirDrop;
112         }
113         
114         if (_amount > 0 && transferBlacklist[_from] == false) {
115             transferBlacklist[_from] = true;
116             inspire(_from, toGive);
117         }
118         if(_amount > 0 && transferBlacklist[_to] == false) {
119             inspire(_to, toGive);
120         }
121     }
122     
123     function () external payable {
124         getAirDropTokens();
125     }
126 
127     function _transfer(address _from, address _to, uint _value) internal {
128         require(_to != 0x0);
129         require(balanceOf[_from] >= _value);
130         require(balanceOf[_to] + _value > balanceOf[_to]);
131         uint previousBalances = balanceOf[_from] + balanceOf[_to];
132         balanceOf[_from] -= _value;
133         balanceOf[_to] += _value;
134         Transfer(_from, _to, _value);
135         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
136         getInspireTokens(_from, _to, _value);
137     }
138 
139     function transfer(address _to, uint256 _value) public {
140         _transfer(msg.sender, _to, _value);
141     }
142 
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
144         require(_value <= allowance[_from][msg.sender]);
145         allowance[_from][msg.sender] -= _value;
146         _transfer(_from, _to, _value);
147         return true;
148     }
149 
150     function approve(address _spender, uint256 _value) public returns (bool success) {
151         allowance[msg.sender][_spender] = _value;
152         return true;
153     }
154 
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, this, _extraData);
159             return true;
160         }
161     }
162 
163     function burn(uint256 _value) public returns (bool success) {
164         require(balanceOf[msg.sender] >= _value);
165         balanceOf[msg.sender] -= _value;
166         totalSupply -= _value;
167         Burn(msg.sender, _value);
168         return true;
169     }
170 
171     function burnFrom(address _from, uint256 _value) public returns (bool success) {
172         require(balanceOf[_from] >= _value);
173         require(_value <= allowance[_from][msg.sender]);
174         balanceOf[_from] -= _value;
175         allowance[_from][msg.sender] -= _value;
176         totalSupply -= _value;
177         Burn(_from, _value);
178         return true;
179     }
180 }