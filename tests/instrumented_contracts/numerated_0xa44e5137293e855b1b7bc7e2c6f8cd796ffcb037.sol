1 pragma solidity ^0.4.19;
2 
3 contract Owned {
4   address public owner;
5 
6   function Owned(
7     )
8       public {
9         owner = msg.sender;
10     }
11 
12   modifier onlyOwner {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(
18     address _owner)
19       onlyOwner public {
20         require(_owner != 0x0);
21 
22         owner = _owner;
23     }
24 }
25 
26 interface tokenRecipient {
27   function receiveApproval(
28     address _from,
29     uint256 _value,
30     address _token,
31     bytes _extraData)
32       public;
33 }
34 
35 contract ERC20Token {
36   string public name;
37   string public symbol;
38   uint8 public decimals;
39   uint256 public totalSupply;
40 
41   mapping (address => uint256) public balanceOf;
42   mapping (address => mapping (address => uint256)) public allowance;
43 
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 
46   event Burn(address indexed from, uint256 value);
47 
48   function ERC20Token(
49     string _tokenName,
50     string _tokenSymbol,
51     uint8 _decimals,
52     uint256 _totalSupply)
53       public {
54         name = _tokenName;
55         symbol = _tokenSymbol;
56         decimals = _decimals;
57         totalSupply = _totalSupply * 10 ** uint256(decimals);
58         balanceOf[msg.sender] = totalSupply;
59     }
60 
61   function _transfer(
62     address _from,
63     address _to,
64     uint256 _value)
65       internal {
66         require(_to != 0x0);
67         require(_from != 0x0);
68         require(_from != _to);
69         require(balanceOf[_from] >= _value);
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71 
72         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
73 
74         balanceOf[_from] -= _value;
75         balanceOf[_to] += _value;
76 
77         Transfer(_from, _to, _value);
78 
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82   function transfer(
83     address _to,
84     uint256 _value)
85       public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89   function transferFrom(
90     address _from,
91     address _to,
92     uint256 _value)
93       public returns (bool success) {
94         require(_value <= allowance[_from][msg.sender]);
95         
96         allowance[_from][msg.sender] -= _value;
97         
98         _transfer(_from, _to, _value);
99         
100         return true;
101     }
102 
103   function approve(
104     address _spender,
105     uint256 _value)
106       public returns (bool success) {
107         allowance[msg.sender][_spender] = _value;
108         
109         return true;
110     }
111 
112   function approveAndCall(
113     address _spender,
114     uint256 _value,
115     bytes _extraData)
116       public returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118 
119         if (approve(_spender, _value)) {
120           spender.receiveApproval(msg.sender, _value, this, _extraData);
121           
122           return true;
123         }
124     }
125 
126   function burn(
127     uint256 _value)
128       public returns (bool success) {
129         require(balanceOf[msg.sender] >= _value);
130 
131         balanceOf[msg.sender] -= _value;
132         totalSupply -= _value;
133 
134         Burn(msg.sender, _value);
135 
136         return true;
137     }
138 
139   function burnFrom(
140     address _from,
141     uint256 _value)
142       public returns (bool success) {
143         require(balanceOf[_from] >= _value);
144         require(_value <= allowance[_from][msg.sender]);
145 
146         balanceOf[_from] -= _value;
147         allowance[_from][msg.sender] -= _value;
148         totalSupply -= _value;
149 
150         Burn(_from, _value);
151 
152         return true;
153     }
154 }
155 
156 contract Sentinel is Owned, ERC20Token {
157   mapping (bytes32 => address) public services;
158 
159   function Sentinel(
160     string _tokenName,
161     string _tokenSymbol,
162     uint8 _decimals,
163     uint256 _totalSupply)
164       ERC20Token(_tokenName, _tokenSymbol, _decimals, _totalSupply) public {
165     }
166 
167   function deployService(
168     bytes32 _serviceName,
169     address _serviceAddress)
170       onlyOwner public {
171         services[_serviceName] = _serviceAddress;
172     }
173 
174   function payService(
175     bytes32 _serviceName,
176     address _from,
177     address _to,
178     uint256 _value)
179       public {
180         require(msg.sender != 0x0);
181         require(services[_serviceName] != 0x0);
182         require(msg.sender == services[_serviceName]);
183         require(_from != 0x0);
184         require(_to != 0x0);
185         require(balanceOf[_from] >= _value);
186         require(balanceOf[_to] + _value > balanceOf[_to]);
187 
188         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
189 
190         balanceOf[_from] -= _value;
191         balanceOf[_to] += _value;
192 
193         Transfer(_from, _to, _value);
194 
195         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
196     }
197 }