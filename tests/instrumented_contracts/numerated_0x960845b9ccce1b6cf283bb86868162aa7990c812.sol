1 /**
2  * Copyright (C) Siousada.io
3  * All rights reserved.
4  * Author: info@siousada.io
5  *
6  * This code is adapted from OpenZeppelin Project.
7  * more at http://openzeppelin.org.
8  *
9  * MIT License
10  *
11  * Permission is hereby granted, free of charge, to any person obtaining a copy 
12  * of this software and associated documentation files (the ""Software""), to 
13  * deal in the Software without restriction, including without limitation the 
14  * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
15  * sell copies of the Software, and to permit persons to whom the Software is 
16  * furnished to do so, subject to the following conditions: 
17  *  The above copyright notice and this permission notice shall be included in 
18  *  all copies or substantial portions of the Software.
19  *
20  * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
21  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
22  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
23  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
24  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
25  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
26  * THE SOFTWARE.
27  *
28  */
29 pragma solidity ^0.4.11;
30 
31 library SafeMath {
32     function mul(uint256 a, uint256 b) internal returns (uint256) {
33         uint256 c = a * b;
34         assert(a == 0 || c / a == b);
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal returns (uint256) {
39         // assert(b > 0); // Solidity automatically throws when dividing by 0
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal returns (uint256) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     function add(uint256 a, uint256 b) internal returns (uint256) {
51         uint256 c = a + b;
52         assert(c >= a);
53         return c;
54     }
55 }
56 
57 contract Guarded {
58 
59     modifier isValidAmount(uint256 _amount) { 
60         require(_amount > 0); 
61         _; 
62     }
63 
64     // ensure address not null, and not this contract address
65     modifier isValidAddress(address _address) {
66         require(_address != 0x0 && _address != address(this));
67         _;
68     }
69 
70 }
71 
72 contract Ownable {
73     address public owner;
74 
75     /** 
76      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77      * account.
78      */
79     function Ownable() {
80         owner = msg.sender;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner. 
85      */
86     modifier onlyOwner() {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     /**
92      * @dev Allows the current owner to transfer control of the contract to a newOwner.
93      * @param newOwner The address to transfer ownership to. 
94      */
95     function transferOwnership(address newOwner) onlyOwner {
96         if (newOwner != address(0)) {
97             owner = newOwner;
98         }
99     }
100 
101 }
102 
103 contract Claimable is Ownable {
104     address public pendingOwner;
105 
106     /**
107      * @dev Modifier throws if called by any account other than the pendingOwner. 
108      */
109     modifier onlyPendingOwner() {
110         require(msg.sender == pendingOwner);
111         _;
112     }
113 
114     /**
115      * @dev Allows the current owner to set the pendingOwner address. 
116      * @param newOwner The address to transfer ownership to. 
117      */
118     function transferOwnership(address newOwner) onlyOwner {
119         pendingOwner = newOwner;
120     }
121 
122     /**
123      * @dev Allows the pendingOwner address to finalize the transfer.
124      */
125     function claimOwnership() onlyPendingOwner {
126         owner = pendingOwner;
127         pendingOwner = 0x0;
128     }
129 }
130 
131 contract ERC20 {
132     
133     /// total amount of tokens
134     uint256 public totalSupply;
135 
136     /// @param _owner The address from which the balance will be retrieved
137     /// @return The balance
138     function balanceOf(address _owner) constant returns (uint256 balance);
139 
140     /// @notice send `_value` token to `_to` from `msg.sender`
141     /// @param _to The address of the recipient
142     /// @param _value The amount of token to be transferred
143     /// @return Whether the transfer was successful or not
144     function transfer(address _to, uint256 _value) returns (bool success);
145 
146     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
147     /// @param _from The address of the sender
148     /// @param _to The address of the recipient
149     /// @param _value The amount of token to be transferred
150     /// @return Whether the transfer was successful or not
151     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
152 
153     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
154     /// @param _spender The address of the account able to transfer the tokens
155     /// @param _value The amount of tokens to be approved for transfer
156     /// @return Whether the approval was successful or not
157     function approve(address _spender, uint256 _value) returns (bool success);
158 
159     /// @param _owner The address of the account owning tokens
160     /// @param _spender The address of the account able to transfer the tokens
161     /// @return Amount of remaining tokens allowed to spent
162     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
163 
164     event Transfer(address indexed _from, address indexed _to, uint256 _value);
165     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
166 
167 }
168 
169 contract ERC20Token is ERC20 {
170     using SafeMath for uint256;
171 
172     string public standard = 'Cryptoken 0.1.1';
173 
174     string public name = '';            // the token name
175     string public symbol = '';          // the token symbol
176     uint8 public decimals = 0;          // the number of decimals
177 
178     // mapping of our users to balance
179     mapping (address => uint256) public balances;
180     mapping (address => mapping (address => uint256)) public allowed;
181 
182     // our constructor. We have fixed everything above, and not as 
183     // parameters in the constructor.
184     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
185         name = _name;
186         symbol = _symbol;
187         decimals = _decimals;
188     }
189 
190     // get token balance
191     function balanceOf(address _owner) 
192         public constant 
193         returns (uint256 balance) 
194     {
195         return balances[_owner];
196     }    
197 
198     /**
199      * make a transfer. This can be called from the token holder.
200      * e.g. Token holder Alice, can issue somethign like this to Bob
201      *      Alice.transfer(Bob, 200);     // to transfer 200 to Bob
202      */
203     /// Initiate a transfer to `_to` with value `_value`?
204     function transfer(address _to, uint256 _value) 
205         public returns (bool success) 
206     {
207         // sanity check
208         require(_to != address(this));
209 
210         // // check for overflows
211         // require(_value > 0 &&
212         //   balances[msg.sender] < _value &&
213         //   balances[_to] + _value < balances[_to]);
214 
215         // 
216         balances[msg.sender] = balances[msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         
219         // emit transfer event
220         Transfer(msg.sender, _to, _value);
221         return true;
222     }
223 
224     /**
225      * make an approved transfer to another account from vault. This operation
226      * should be called after approved operation below.
227      * .e.g Alice allow Bob to spend 30 by doing:
228      *      Alice.approve(Bob, 30);                 // allow 30 to Bob
229      *
230      * and Bob can claim, say 10, from that by doing
231      *      Bob.transferFrom(Alice, Bob, 10);       // spend only 10
232      * and Bob's balance shall be 20 in the allowance.
233      */
234     /// Initiate a transfer of `_value` from `_from` to `_to`
235     function transferFrom(address _from, address _to, uint256 _value)         
236         public returns (bool success) 
237     {    
238         // sanity check
239         require(_to != 0x0 && _from != 0x0);
240         require(_from != _to && _to != address(this));
241 
242         // check for overflows
243         // require(_value > 0 &&
244         //   balances[_from] >= _value &&
245         //   allowed[_from][_to] <= _value &&
246         //   balances[_to] + _value < balances[_to]);
247 
248         // update public balance
249         allowed[_from][_to] = allowed[_from][_to].sub(_value);        
250         balances[_from] = balances[_from].sub(_value);
251         balances[_to] = balances[_to].add(_value);
252 
253         // emit transfer event
254         Transfer(_from, _to, _value);
255         return true;
256     }
257 
258     /**
259      * This method is explained further in https://goo.gl/iaqxBa on the
260      * possible attacks. As such, we have to make sure the value is
261      * drained, before any Alice/Bob can approve each other to
262      * transfer on their behalf.
263      * @param _spender  - the recipient of the value
264      * @param _value    - the value allowed to be spent 
265      *
266      * This can be called by the token holder
267      * e.g. Alice can allow Bob to spend 30 on her behalf
268      *      Alice.approve(Bob, 30);     // gives 30 to Bob.
269      */
270     /// Approve `_spender` to claim/spend `_value`?
271     function approve(address _spender, uint256 _value)          
272         public returns (bool success) 
273     {
274         // sanity check
275         require(_spender != 0x0 && _spender != address(this));            
276 
277         // if the allowance isn't 0, it can only be updated to 0 to prevent 
278         // an allowance change immediately after withdrawal
279         require(allowed[msg.sender][_spender] == 0);
280 
281         allowed[msg.sender][_spender] = _value;
282         Approval(msg.sender, _spender, _value);
283         return true;
284     }
285 
286     /**
287      * Check the allowance that has been approved previously by owner.
288      */
289     /// check allowance approved from `_owner` to `_spender`?
290     function allowance(address _owner, address _spender)          
291         public constant returns (uint remaining) 
292     {
293         // sanity check
294         require(_spender != 0x0 && _owner != 0x0);
295         require(_owner != _spender && _spender != address(this));            
296 
297         // constant op. Just return the balance.
298         return allowed[_owner][_spender];
299     }
300 
301 }
302 
303 contract SSDToken is ERC20Token, Guarded, Claimable {
304 
305     uint256 public SUPPLY = 1000000000 ether;   // 1b ether;
306 
307     // our constructor, just supply the total supply.
308     function SSDToken() 
309         ERC20Token('SIOUSADA', 'SSD', 18) 
310     {
311         totalSupply = SUPPLY;
312         balances[msg.sender] = SUPPLY;
313     }
314 
315 }