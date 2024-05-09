1 pragma solidity ^0.4.18;
2 
3 /*
4 License
5 
6 The MIT License (MIT)
7 
8 Copyright (c) 2016 Smart Contract Solutions, Inc.
9 
10 Permission is hereby granted, free of charge, to any person obtaining
11 a copy of this software and associated documentation files (the
12 "Software"), to deal in the Software without restriction, including
13 without limitation the rights to use, copy, modify, merge, publish,
14 distribute, sublicense, and/or sell copies of the Software, and to
15 permit persons to whom the Software is furnished to do so, subject to
16 the following conditions:
17 
18 The above copyright notice and this permission notice shall be included
19 in all copies or substantial portions of the Software.
20 
21 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
22 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
23 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
24 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
25 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
26 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
27 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
28 
29 Author - Daniel Blank, The Workshopp
30 
31 */
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   /**
62   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 // ----------------------------------------------------------------------------
80 // ERC Token Standard #20 Interface
81 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
82 // ----------------------------------------------------------------------------
83 contract ERC20Interface {
84     function totalSupply() public view returns (uint);
85     function balanceOf(address tokenOwner) public view returns (uint balance);
86     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
87     function transfer(address to, uint tokens) public returns (bool success);
88     function approve(address spender, uint tokens) public returns (bool success);
89     function transferFrom(address from, address to, uint tokens) public returns (bool success);
90 
91     event Transfer(address indexed from, address indexed to, uint tokens);
92     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
93 }
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals and an
97 // initial fixed supply
98 // ----------------------------------------------------------------------------
99 contract CGTToken is ERC20Interface {
100     using SafeMath for uint;
101 
102     string public symbol;
103     string public name;
104     uint8 public decimals;
105     uint _totalSupply;
106 
107     mapping(address => uint) balances;
108     mapping(address => mapping(address => uint)) internal allowed;
109 
110 
111     // ------------------------------------------------------------------------
112     // Constructor
113     // ------------------------------------------------------------------------
114     function CGTToken() public {
115         symbol = "CGT";
116         name = "Cryptov Group Token";
117         decimals = 2;
118         _totalSupply = 10000000 * 10**uint(decimals);
119         balances[msg.sender] = _totalSupply;
120         Transfer(address(0), msg.sender, _totalSupply);
121     }
122 
123     // ------------------------------------------------------------------------
124     // Total supply
125     // ------------------------------------------------------------------------
126     function totalSupply() public view returns (uint) {
127         return _totalSupply - balances[address(0)];
128     }
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account `tokenOwner`
132     // ------------------------------------------------------------------------
133     function balanceOf(address tokenOwner) public constant returns (uint balance) {
134         return balances[tokenOwner];
135     }
136 
137     // ------------------------------------------------------------------------
138     // Transfer the balance from token owner's account to `to` account
139     // - Owner's account must have sufficient balance to transfer
140     // - 0 value transfers are allowed
141     // ------------------------------------------------------------------------
142     function transfer(address to, uint tokens) public returns (bool success) {
143         require(to != address(0));
144         require(tokens <= balances[msg.sender]);
145     
146         // SafeMath.sub will throw if there is not enough balance.
147         balances[msg.sender] = balances[msg.sender].sub(tokens);
148         balances[to] = balances[to].add(tokens);
149         Transfer(msg.sender, to, tokens);
150         return true;
151     }
152 
153     // ------------------------------------------------------------------------
154     // Token owner can approve for `spender` to transferFrom(...) `tokens`
155     // from the token owner's account
156     //
157     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
158     // recommends that there are no checks for the approval double-spend attack
159     // as this should be implemented in user interfaces 
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167     // ------------------------------------------------------------------------
168     // Transfer `tokens` from the `from` account to the `to` account
169     // 
170     // The calling account must already have sufficient tokens approve(...)-d
171     // for spending from the `from` account and
172     // - From account must have sufficient balance to transfer
173     // - Spender must have sufficient allowance to transfer
174     // - 0 value transfers are allowed
175     // ------------------------------------------------------------------------
176     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
177         require(to != address(0));
178         require(tokens <= balances[from]);
179         require(tokens <= allowed[from][msg.sender]);
180         
181         balances[from] = balances[from].sub(tokens);
182         balances[to] = balances[to].add(tokens);
183         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
184         Transfer(from, to, tokens);
185         return true;
186     }
187 
188     // ------------------------------------------------------------------------
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ------------------------------------------------------------------------
192     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195 
196     // ------------------------------------------------------------------------
197     // @dev Increase the amount of tokens that an owner allowed to a spender.
198     //
199     //  * approve should be called when allowed[_spender] == 0. To increment
200     //  * allowed value is better to use this function to avoid 2 calls (and wait until
201     //  * the first transaction is mined)
202     //  From MonolithDAO Token.sol
203     //  @param _spender The address which will spend the funds.
204     //  @param _addedValue The amount of tokens to increase the allowance by.
205     // ------------------------------------------------------------------------
206     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 
212    // ------------------------------------------------------------------------
213    // @dev Decrease the amount of tokens that an owner allowed to a spender.
214    //
215    // approve should be called when allowed[_spender] == 0. To decrement
216    // allowed value is better to use this function to avoid 2 calls (and wait until
217    // the first transaction is mined)
218    // From MonolithDAO Token.sol
219    // @param _spender The address which will spend the funds.
220    // @param _subtractedValue The amount of tokens to decrease the allowance by.
221    // ------------------------------------------------------------------------
222     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
223         uint oldValue = allowed[msg.sender][_spender];
224         if (_subtractedValue > oldValue) {
225         allowed[msg.sender][_spender] = 0;
226         } else {
227         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228         }
229         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 }