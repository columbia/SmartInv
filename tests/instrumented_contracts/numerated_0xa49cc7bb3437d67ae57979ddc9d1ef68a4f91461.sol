1 pragma solidity ^0.4.24;
2 
3 /*
4 
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9 
10     This program is distributed in the hope that it will be useful,
11     but WITHOUT ANY WARRANTY; without even the implied warranty of
12     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13     GNU General Public License for more details.
14 
15     You should have received a copy of the GNU General Public License
16     along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 */
19 
20 
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
75 
76 
77 
78 
79 contract XAIN_ERC20 is Ownable {
80 
81     using SafeMath for uint256;
82 
83 
84     mapping (address => uint256) public balances;
85 
86 
87     mapping (address => mapping (address => uint256)) internal allowed;
88 
89 
90 
91     // Public variables for the XAIN ERC20 XNP token contract
92     string public constant standard = "XAIN erc20 and Genesis";
93     uint256 public constant decimals = 18;   // hardcoded to be a constant
94     string public name = "XAIN";
95     string public symbol = "XNP";
96     uint256 public totalSupply;
97 
98     event Transfer(address indexed from, address indexed to, uint256 value);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 
101 
102 
103     function balanceOf(address _owner) public view returns (uint256) {
104         return balances[_owner];
105     }
106 
107     function transfer(address _to, uint256 _value) public returns (bool) {
108 
109         require(_to != address(0));
110         require(_value <= balances[msg.sender]);
111         // SafeMath.sub will throw if there is not enough balance.
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113 
114 
115         balances[_to] = balances[_to].add(_value);
116 
117         emit Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[_from]);
124         require(_value <= allowed[_from][msg.sender]);
125 
126         balances[_from] = balances[_from].sub(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128 
129 
130         balances[_to] = balances[_to].add(_value);
131 
132 
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) public view returns (uint256) {
144         return allowed[_owner][_spender];
145     }
146 
147     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
148         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
149         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150         return true;
151     }
152 
153     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154         uint oldValue = allowed[msg.sender][_spender];
155         if (_subtractedValue > oldValue) {
156             allowed[msg.sender][_spender] = 0;
157         } else {
158             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159         }
160         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161         return true;
162     }
163 
164     /* Approve and then communicate the approved contract in a single tx */
165     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
166         tokenRecipient spender = tokenRecipient(_spender);
167 
168         if (approve(_spender, _value)) {
169             spender.receiveApproval(msg.sender, _value, this, _extraData);
170             return true;
171         }
172     }
173 }
174 
175 
176 
177 interface tokenRecipient {
178     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;
179 }
180 
181 
182 //
183 // This creates and adds six genesis pools of XNP tokens to the balance of the A,B,C,D,E and F Ethereum addresses
184 //
185 
186 contract XAIN is XAIN_ERC20 {
187 
188 
189         address public A;
190         address public B;
191         address public C;
192         address public D;
193         address public E;
194         address public F;
195 
196 
197     constructor (
198 
199         ) public {
200 
201         A = 0xc3b60984Df1FeffBd884Da6C083EaB735563C641;
202         B = 0xD5b8D79dE753C98f165bD8d3eb896C1276c4B1FF;
203         C = 0x75B351AD3e51376C9a3373D724e16daA52C54cD5;
204         D = 0x908dA0Eb55C64Ea116A47a9bF62C6bfBd542FA81;
205         E = 0x48875C46796C14e3fDC27D7acfBbd4a0f2a39953;
206         F = 0xA010C083B38A9013d7E1Db8b4e5015BB7b280224;
207 
208         balances[A]=balances[A].add(5000000*(uint256(10)**decimals));
209         balances[B]=balances[B].add(5000000*(uint256(10)**decimals));
210         balances[C]=balances[C].add(10000000*(uint256(10)**decimals));
211         balances[D]=balances[D].add(10000000*(uint256(10)**decimals));
212         balances[E]=balances[E].add(25000000*(uint256(10)**decimals));
213         balances[F]=balances[F].add(45000000*(uint256(10)**decimals));
214 
215         totalSupply=balances[A]+balances[B]+balances[C]+balances[D]+balances[E]+balances[F];
216 
217 
218     }
219 
220 
221 }