1 pragma solidity 0.4.24;
2 
3 /*
4 
5     Copyright 2018, Vicent Nos & Mireia Puig
6 
7     This program is free software: you can redistribute it and/or modify
8     it under the terms of the GNU General Public License as published by
9     the Free Software Foundation, either version 3 of the License, or
10     (at your option) any later version.
11 
12     This program is distributed in the hope that it will be useful,
13     but WITHOUT ANY WARRANTY; without even the implied warranty of
14     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15     GNU General Public License for more details.
16 
17     You should have received a copy of the GNU General Public License
18     along with this program.  If not, see <http://www.gnu.org/licenses/>.
19 
20 */
21 
22 
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 
55 contract Ownable {
56 
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor() internal {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address newOwner) public onlyOwner {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 }
76 
77 contract TokenCHK {
78   function transfer(address to, uint256 value) public returns (bool);
79 }
80 
81 
82 //////////////////////////////////////////////////////////////
83 //                                                          //
84 //                 SpaceImpulse_ERC20                       //
85 //                                                          //
86 //////////////////////////////////////////////////////////////
87 
88 
89 
90 contract SpaceImpulse_ERC20 is Ownable {
91 
92     using SafeMath for uint256;
93 
94     mapping (address => uint256) public balances;
95 
96     mapping (address => mapping (address => uint256)) internal allowed;
97 
98     // Public variables for the SpaceImpulse ERC20 token contract
99     string public constant standard = "SpaceImpulse ERC20";
100     uint256 public constant decimals = 18;   // hardcoded to be a constant
101     string public name = "Plasma";
102     string public symbol = "SPI";
103     uint256 public totalSupply;
104 
105     event Transfer(address indexed from, address indexed to, uint256 value);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 
108 
109 
110     function balanceOf(address _owner) public view returns (uint256) {
111         return balances[_owner];
112     }
113 
114     function transfer(address _to, uint256 _value) public returns (bool) {
115 
116         require(_to != address(0));
117         require(_value <= balances[msg.sender]);
118         // SafeMath.sub will throw if there is not enough balance.
119         balances[msg.sender] = balances[msg.sender].sub(_value);
120 
121 
122         balances[_to] = balances[_to].add(_value);
123 
124         emit Transfer(msg.sender, _to, _value);
125         return true;
126     }
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129         require(_to != address(0));
130         require(_value <= balances[_from]);
131         require(_value <= allowed[_from][msg.sender]);
132 
133         balances[_from] = balances[_from].sub(_value);
134         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135 
136 
137         balances[_to] = balances[_to].add(_value);
138 
139 
140         emit Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     function allowance(address _owner, address _spender) public view returns (uint256) {
151         return allowed[_owner][_spender];
152     }
153 
154     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157         return true;
158     }
159 
160     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
161         uint oldValue = allowed[msg.sender][_spender];
162         if (_subtractedValue > oldValue) {
163             allowed[msg.sender][_spender] = 0;
164         } else {
165             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166         }
167         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168         return true;
169     }
170 
171     /* Approve and then communicate the approved contract in a single tx */
172     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
173         tokenRecipient spender = tokenRecipient(_spender);
174 
175         if (approve(_spender, _value)) {
176             spender.receiveApproval(msg.sender, _value, this, _extraData);
177             return true;
178         }
179     }
180 }
181 
182 
183 
184 interface tokenRecipient {
185     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;
186 }
187 
188 
189 
190 contract SpaceImpulseERC20 is SpaceImpulse_ERC20 {
191 
192         address public A;
193 
194     constructor (
195 
196         ) public {
197 
198         A = 0xD9614b3FaC2B523504AbC18104e4B32EE0605855;
199 
200         balances[A] = balances[A].add(246000000*(uint256(10)**decimals));
201 
202         totalSupply = balances[A];
203 
204 
205     }
206 
207     function sweep(address _token, uint256 _amount) public onlyOwner {
208         TokenCHK token = TokenCHK(_token);
209 
210         if(!token.transfer(owner, _amount)) {
211             revert();
212         }
213     }
214 
215 }