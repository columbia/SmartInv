1 pragma solidity ^0.4.24;
2 
3 /*
4 
5     Copyright 2018, Angelo A. M. & Vicent Nos & Mireia Puig
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
77 
78 
79 //////////////////////////////////////////////////////////////
80 //                                                          //
81 //                 ESSENTIA erc20 & Genesis                 //
82 //                   https://essentia.one                   //
83 //                                                          //
84 //////////////////////////////////////////////////////////////
85 
86 
87 
88 contract ESSENTIA_ERC20 is Ownable {
89 
90     using SafeMath for uint256;
91 
92 
93     mapping (address => uint256) public balances;
94 
95 
96     mapping (address => mapping (address => uint256)) internal allowed;
97 
98 
99 
100     // Public variables for the ESSENTIA ERC20 ESS token contract
101     string public constant standard = "ESSENTIA erc20 and Genesis";
102     uint256 public constant decimals = 18;   // hardcoded to be a constant
103     string public name = "ESSENTIA";
104     string public symbol = "ESS";
105     uint256 public totalSupply;
106 
107     event Transfer(address indexed from, address indexed to, uint256 value);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 
110 
111 
112     function balanceOf(address _owner) public view returns (uint256) {
113         return balances[_owner];
114     }
115 
116     function transfer(address _to, uint256 _value) public returns (bool) {
117 
118         require(_to != address(0));
119         require(_value <= balances[msg.sender]);
120         // SafeMath.sub will throw if there is not enough balance.
121         balances[msg.sender] = balances[msg.sender].sub(_value);
122 
123 
124         balances[_to] = balances[_to].add(_value);
125 
126         emit Transfer(msg.sender, _to, _value);
127         return true;
128     }
129 
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
131         require(_to != address(0));
132         require(_value <= balances[_from]);
133         require(_value <= allowed[_from][msg.sender]);
134 
135         balances[_from] = balances[_from].sub(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137 
138 
139         balances[_to] = balances[_to].add(_value);
140 
141 
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     function allowance(address _owner, address _spender) public view returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155 
156     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
157         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159         return true;
160     }
161 
162     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
163         uint oldValue = allowed[msg.sender][_spender];
164         if (_subtractedValue > oldValue) {
165             allowed[msg.sender][_spender] = 0;
166         } else {
167             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168         }
169         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 
173     /* Approve and then communicate the approved contract in a single tx */
174     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
175         tokenRecipient spender = tokenRecipient(_spender);
176 
177         if (approve(_spender, _value)) {
178             spender.receiveApproval(msg.sender, _value, this, _extraData);
179             return true;
180         }
181     }
182 }
183 
184 
185 
186 interface tokenRecipient {
187     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;
188 }
189 
190 
191 //
192 // This creates and adds two genesis pools of ESS tokens to the balance of the A and B ETH addresses
193 // The A/B ESS Genesis pools are 35/65 of the A+B total ESS Token supply. Integer rounded
194 //
195 
196 
197 contract ESSENTIA is ESSENTIA_ERC20 {
198 
199 
200         address public A;
201         address public B;
202 
203 
204     constructor (
205 
206         ) public {
207 
208         A = 0x9cDc027edFD6D4fa1dbe4D0Fa75B9D67f1f6c69D;
209         B = 0x9cDc027edFD6D4fa1dbe4D0Fa75B9D67f1f6c69D;
210 
211 
212         balances[A]=balances[A].add(614359681*(uint256(10)**decimals));
213         balances[B]=balances[B].add(1140953692*(uint256(10)**decimals));
214 
215         totalSupply=balances[A]+balances[B];
216 
217 
218     }
219 
220 }