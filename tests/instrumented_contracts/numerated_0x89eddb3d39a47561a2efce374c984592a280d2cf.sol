1 pragma solidity ^0.4.24;
2 
3 
4 interface tokenRecipient {
5 
6     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external;
7 
8 }
9 
10 
11 
12 contract owned {
13 
14     address public owner;
15 
16     address public newOwner;
17 
18 
19 
20    event OwnershipTransferred(address indexed _from, address indexed _to);
21 
22 
23 
24    constructor() owned() public {
25 
26         owner = msg.sender;
27 
28   
29 
30 }
31 
32 
33 
34 
35 
36  modifier onlyOwner {
37 
38         require(msg.sender == owner);
39 
40         _;
41 
42     }
43 
44 
45 
46    function transferOwnership(address _newOwner) onlyOwner public returns (bool success) {
47 
48         newOwner = _newOwner;
49 
50         return true;
51 
52     }
53 
54 
55 
56     function acceptOwnership() public returns (bool success) {
57 
58         require(msg.sender == newOwner);
59 
60         owner = newOwner;
61 
62         emit OwnershipTransferred(owner, newOwner);
63 
64         newOwner = address(0);
65 
66         return true;
67 
68     }
69 
70 }
71 
72 
73 
74 contract TokenERC20 is owned {
75 
76     string public name = 'Worldcoin';
77 
78     string public symbol = 'WDT';
79 
80     uint8 public decimals = 8;
81 
82     uint public totalSupply = 50000000000000;
83 
84 
85    mapping (address => uint) public balanceOf;
86 
87     mapping (address => mapping (address => uint)) public allowance;
88 
89     mapping (address => bool) public frozenAccount;
90 
91 
92 
93 
94 
95   event Transfer(address indexed from, address indexed to, uint value);
96 
97     event Approval(address indexed _owner, address indexed _spender, uint _value);
98 
99     event FrozenFunds(address indexed target, bool frozen);
100 
101 
102 
103    constructor() TokenERC20() public {
104 
105         balanceOf[msg.sender] = totalSupply;
106 
107     }
108 
109 
110 
111 
112 
113    function _transfer(address _from, address _to, uint _value) internal {
114 
115         require(_to != 0x0);
116 
117         require(balanceOf[_from] >= _value);
118 
119         require(balanceOf[_to] + _value > balanceOf[_to]);
120 
121         require(!frozenAccount[msg.sender]);
122 
123         require(!frozenAccount[_from]);
124 
125         require(!frozenAccount[_to]);
126 
127         
128 
129         uint previousBalances = balanceOf[_from] + balanceOf[_to];
130 
131         balanceOf[_from] -= _value;
132 
133         balanceOf[_to] += _value;
134 
135         emit Transfer(_from, _to, _value);
136 
137         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
138 
139     }
140 
141 
142 
143 
144 
145     function _multipleTransfer(address _from, address[] addresses, uint[] amounts) internal {
146 
147         for (uint i=0; i<addresses.length; i++) {
148 
149             address _to = addresses[i];
150 
151             uint _value = amounts[i];
152 
153             _transfer(_from, _to, _value);
154 
155         }
156 
157     }
158 
159 
160 
161 
162     function transfer(address _to, uint _value) public returns (bool success) {
163 
164         _transfer(msg.sender, _to, _value);
165         return true;
166 
167     }
168 
169 
170 
171 
172     function multipleTransfer(address[] addresses, uint[] amounts) public returns (bool success) {
173 
174         _multipleTransfer(msg.sender, addresses, amounts);
175 
176         return true;
177 
178     }
179 
180 
181 
182 
183     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
184 
185             require(allowance[_from][msg.sender] >= _value);
186 
187             allowance[_from][msg.sender] -= _value;
188        
189             _transfer(_from, _to, _value);
190 
191         return true;
192 
193     }
194 
195     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
196 
197         tokenRecipient spender = tokenRecipient(_spender);
198 
199         
200             spender.receiveApproval(msg.sender, _value, this, _extraData);
201             return true;
202 
203         
204 
205     }
206 
207 
208 
209     function approve(address _spender, uint _value) public returns (bool success) {
210 
211         allowance[msg.sender][_spender] = _value;
212 
213         emit Approval(msg.sender, _spender, _value);
214 
215         return true;
216 
217     }
218 
219 
220 
221     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success) {
222 
223         frozenAccount[target] = freeze;
224         emit FrozenFunds(target, freeze);
225 
226         return true;
227 
228     }
229 
230 }