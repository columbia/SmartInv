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
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 
52 
53 contract Ownable {
54 
55     address public owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor() internal {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 contract TokenCHK {
76   function transfer(address to, uint256 value) public returns (bool);
77 }
78 
79 
80 //////////////////////////////////////////////////////////////
81 //                                                          //
82 //                 SpaceImpulse_ERC20                       //
83 //                                                          //
84 //////////////////////////////////////////////////////////////
85 
86 
87 
88 contract SpaceImpulse_ERC20 is Ownable {
89 
90     using SafeMath for uint256;
91 
92     mapping (address => uint256) public balances;
93 
94     mapping (address => mapping (address => uint256)) internal allowed;
95 
96     // Public variables for the SpaceImpulse ERC20 token contract
97     string public constant standard = "SpaceImpulse ERC20";
98     uint256 public constant decimals = 18;   // hardcoded to be a constant
99     string public name = "Plasma";
100     string public symbol = "SPI";
101     uint256 public totalSupply;
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106 
107 
108     function balanceOf(address _owner) public view returns (uint256) {
109         return balances[_owner];
110     }
111 
112     function transfer(address _to, uint256 _value) public returns (bool) {
113 
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116         // SafeMath.sub will throw if there is not enough balance.
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118 
119 
120         balances[_to] = balances[_to].add(_value);
121 
122         emit Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);
130 
131         balances[_from] = balances[_from].sub(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133 
134 
135         balances[_to] = balances[_to].add(_value);
136 
137 
138         emit Transfer(_from, _to, _value);
139         return true;
140     }
141 
142     function approve(address _spender, uint256 _value) public returns (bool) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function allowance(address _owner, address _spender) public view returns (uint256) {
149         return allowed[_owner][_spender];
150     }
151 
152     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
153         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
154         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156     }
157 
158     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
159         uint oldValue = allowed[msg.sender][_spender];
160         if (_subtractedValue > oldValue) {
161             allowed[msg.sender][_spender] = 0;
162         } else {
163             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164         }
165         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166         return true;
167     }
168 
169     /* Approve and then communicate the approved contract in a single tx */
170     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172 
173         if (approve(_spender, _value)) {
174             spender.receiveApproval(msg.sender, _value, this, _extraData);
175             return true;
176         }
177     }
178 }
179 
180 
181 
182 interface tokenRecipient {
183     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;
184 }
185 
186 
187 
188 contract SpaceImpulseERC20 is SpaceImpulse_ERC20 {
189 
190         address public A;
191 
192     constructor (
193 
194         ) public {
195 
196         A = 0x69587ed6f526f8B3FD9eB01d4F1FCC86f0394c8f;
197 
198         balances[A] = balances[A].add(246000000*(uint256(10)**decimals));
199 
200         totalSupply = balances[A];
201 
202 
203     }
204 
205     function sweep(address _token, uint256 _amount) public onlyOwner {
206         TokenCHK token = TokenCHK(_token);
207 
208         if(!token.transfer(owner, _amount)) {
209             revert();
210         }
211     }
212 }