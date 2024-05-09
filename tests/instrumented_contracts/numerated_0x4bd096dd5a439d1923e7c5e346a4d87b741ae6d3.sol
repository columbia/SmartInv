1 pragma solidity >=0.4.21 <0.6.0;
2 
3 contract Owner {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient {
21     function receiveApproval(
22         address _from,
23         uint256 _value,
24         address _token,
25         bytes _extraData)
26     external;
27 }
28 
29 contract ERC20Token {
30     string public name;
31     string public symbol;
32     uint8 public decimals;
33     uint256 public totalSupply;
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     event Burn(address indexed from, uint256 value);
41 
42     constructor (
43         string _tokenName,
44         string _tokenSymbol,
45         uint8 _decimals,
46         uint256 _totalSupply)
47     public {
48         name = _tokenName;
49         symbol = _tokenSymbol;
50         decimals = _decimals;
51         totalSupply = _totalSupply * 10 ** uint256(decimals);
52         balanceOf[msg.sender] = totalSupply;
53     }
54 
55     function _transfer(
56         address _from,
57         address _to,
58         uint256 _value)
59     internal {
60         require(_to != 0x0);
61         require(_from != 0x0);
62         require(balanceOf[_from] >= _value);
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64 
65         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
66 
67         balanceOf[_from] -= _value;
68         balanceOf[_to] += _value;
69 
70         emit Transfer(_from, _to, _value);
71 
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75     function transfer(
76         address _to,
77         uint256 _value)
78     public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82     function transferFrom(
83         address _from,
84         address _to,
85         uint256 _value)
86     public returns (bool success) {
87         require(_value <= allowance[_from][msg.sender]);
88         
89         allowance[_from][msg.sender] -= _value;
90         
91         _transfer(_from, _to, _value);
92         
93         return true;
94     }
95 
96     function approve(
97         address _spender,
98         uint256 _value)
99     public returns (bool success) {
100         allowance[msg.sender][_spender] = _value;
101         
102         return true;
103     }
104 
105     function approveAndCall(
106         address _spender,
107         uint256 _value,
108         bytes _extraData)
109     public returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111 
112         if (approve(_spender, _value)) {
113             spender.receiveApproval(msg.sender, _value, this, _extraData);
114             return true;
115         }
116     }
117 
118     function burn(
119         uint256 _value)
120     public returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);
122 
123         balanceOf[msg.sender] -= _value;
124         totalSupply -= _value;
125 
126         emit Burn(msg.sender, _value);
127 
128         return true;
129     }
130 
131     function burnFrom(
132         address _from,
133         uint256 _value)
134     public returns (bool success) {
135         require(balanceOf[_from] >= _value);
136         require(_value <= allowance[_from][msg.sender]);
137 
138         balanceOf[_from] -= _value;
139         allowance[_from][msg.sender] -= _value;
140         totalSupply -= _value;
141 
142         emit Burn(_from, _value);
143 
144         return true;
145     }
146 }
147 
148 contract Fyle is Owner, ERC20Token {
149     
150     mapping(address => string[]) private urls;
151     event SendFyle(string _message);
152     
153     constructor (
154         string _tokenName,
155         string _tokenSymbol,
156         uint8 _decimals,
157         uint256 _totalSupply)
158     ERC20Token(_tokenName, _tokenSymbol, _decimals, _totalSupply) public {
159     }
160     
161     function mint(
162         address _to, 
163         uint256 _amount) 
164     public onlyOwner returns (bool) {
165         totalSupply = totalSupply + _amount;
166         balanceOf[_to] = balanceOf[_to] + _amount;
167         return true;
168     }
169 
170     function sendFyle(
171         address _from,
172         address _to,
173         string _url,
174         string _message)
175     onlyOwner public {
176         urls[_to].push(_url);
177         _transfer(_from, _to, 1);
178         emit SendFyle(_message);
179     }
180 
181     function getUrlAtIndexOf(
182         address _address,
183         uint256 _index)
184     public view returns(string) {
185         return urls[_address][_index];
186     }
187 
188     function getUrlCountOf(
189         address _address)
190     public view returns(uint256) {
191         return urls[_address].length;
192     }
193 
194     function getMsgSender(
195         )
196     public view returns(address) {
197         return msg.sender;
198     }
199 }