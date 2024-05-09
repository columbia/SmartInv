1 pragma solidity ^0.4.19;
2 
3 /**
4  * Copyright (C) VEGIG Crypto
5  * All rights reserved.
6  *  *
7  * This code is adapted from Fixed supply token contract 
8  * (c) BokkyPooBah 2017. The MIT Licence.
9  *
10  * MIT License
11  *
12  * Permission is hereby granted, free of charge, to any person obtaining a copy 
13  * of this software and associated documentation files (the ""Software""), to 
14  * deal in the Software without restriction, including without limitation the 
15  * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
16  * sell copies of the Software, and to permit persons to whom the Software is 
17  * furnished to do so, subject to the following conditions: 
18  *  The above copyright notice and this permission notice shall be included in 
19  *  all copies or substantial portions of the Software.
20  *
21  * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
22  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
23  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
24  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
25  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
26  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
27  * THE SOFTWARE.
28  *
29  */
30  
31  /**
32  * 	@title SafeMath
33  * 	@dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60  
61 /*
62  * 	Standard ERC20 interface. Adapted from https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
63  *
64 */ 
65 	contract ERC20Interface {
66       
67 		function totalSupply() public constant returns (uint256 totSupply);   
68 	    function balanceOf(address _owner) public constant returns (uint256 balance);   
69 		function transfer(address _to, uint256 _amount) public returns (bool success);	  
70 		function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);   
71 		function approve(address _spender, uint256 _value) public returns (bool success);   
72 		function allowance(address _owner, address _spender) public constant returns (uint256 remaining);             
73 		event Transfer(address indexed _from, address indexed _to, uint256 _value);   
74 		event Approval(address indexed _owner, address indexed _spender, uint256 _value); 	
75 	  
76 	}
77 
78 /*
79  * 	Interface to cater for future requirements (if applicable)
80  *
81 */
82 	contract VEGIGInterface {
83   
84 		function send (address _to, uint256 _amount) public returns (bool success);  
85 		function sendFrom(address _from, address _to, uint256 _amount) public returns (bool success);
86 		function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
87 		function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success);
88 		function transferOwnership (address _newOwner) public;	
89 	}
90 
91 /*
92  * 	VEGIGCrypto contract
93  *
94 */
95 	contract VEGIGCrypto is ERC20Interface, VEGIGInterface {
96 		using SafeMath for uint256;
97 	
98 		string public symbol = "VGIG";
99 		string public name = "VEGIG";
100 		uint8 public constant decimals = 8;
101 		uint256 public constant _totalSupply = 19000000000000000;
102       
103 		// Owner of this contract
104 		address public owner;
105    
106 		// Balances for each account
107 		mapping(address => uint256) balances;
108    
109 		// Owner of account approves the transfer of an amount to another account
110 		mapping(address => mapping (address => uint256)) allowed;
111    
112 		// Functions with this modifier can only be executed by the owner
113 		modifier onlyOwner() {          
114 			require(msg.sender == owner);
115 			_;		  
116 		}
117 	  
118 		// Functions with this modifier can only be executed not to this contract. This is to avoid sending ERC20 tokens to this contract address
119 		modifier notThisContract(address _to) {		
120 			require(_to != address(this));
121 			_;			  
122 		}
123    
124 		// Constructor
125 		function VEGIGCrypto() public {	  
126 			owner = msg.sender;
127 			balances[owner] = _totalSupply;		  
128 		}
129       
130 		// This is safety mechanism to allow ETH (if any) in this contract address to be sent to the contract owner
131 		function () payable public {
132 			if(this.balance > 1000000000000000000){
133 				owner.transfer(this.balance);
134 			}
135 		}
136 
137 		// Returns the account balance of another account with address _owner.
138 		function balanceOf(address _owner) public constant returns (uint256 balance) {
139 			return balances[_owner];
140 		}
141 	  
142 		// Returns the total token supply.
143 		function totalSupply() public constant returns (uint256 totSupply) {
144 			return _totalSupply;
145 		}
146 	    
147 		// Transfer the balance from owner's account to another account
148 		function transfer(address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {
149 			require(_to != 0x0);
150 			require(_amount > 0);
151 			require(balances[msg.sender] >= _amount);
152 			require(balances[_to] + _amount > balances[_to]);
153 			balances[msg.sender] -= _amount;
154 			balances[_to] += _amount;		  
155 			Transfer(msg.sender, _to, _amount);
156 			return true;	 
157 		}
158    
159 		// The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. 
160 		// This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. 
161 		// The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.
162 		// Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
163 		function transferFrom( address _from, address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {	
164 		
165 		   require(balances[_from] >= _amount);
166 		   require(allowed[_from][msg.sender] >= _amount);
167 		   require(_amount > 0);
168 		   require(balances[_to] + _amount > balances[_to]);
169 		   
170 		   balances[_from] -= _amount;
171            allowed[_from][msg.sender] -= _amount;
172            balances[_to] += _amount;
173            Transfer(_from, _to, _amount);
174            return true;        
175 		}
176 	 
177 		// Allows _spender to withdraw from your account multiple times, up to the _value amount. 
178 		// If this function is called again it overwrites the current allowance with _value
179 		// To change the approve amount you first have to reduce the addresses`
180 		// allowance to zero by calling `approve(_spender, 0)` if it is not
181 		// already 0 to mitigate the race condition described here:
182 		// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729   		
183 		function approve(address _spender, uint256 _amount) public returns (bool) {		
184 		
185 			require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
186 		  
187 			allowed[msg.sender][_spender] = _amount;
188 			Approval(msg.sender, _spender, _amount);
189 			return true;
190 		}
191 		
192 		// Returns the amount which _spender is still allowed to withdraw from _owner
193 		function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
194 			return allowed[_owner][_spender];
195 		}
196 		
197 		function send(address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {
198 		    return transfer(_to, _amount);
199 		}
200 		
201 		function sendFrom( address _from, address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {	
202 		    return transferFrom(_from, _to, _amount);
203 		}
204 		   
205 		// Approve should be called when allowed[_spender] == 0. To increment
206 		// allowed value is better to use this function to avoid 2 calls (and wait until 
207 		// the first transaction is mined)
208 		// From MonolithDAO Token.sol
209 		function increaseApproval (address _spender, uint _addedValue) public 
210 			returns (bool success) {
211 			
212 			allowed[msg.sender][_spender] += _addedValue;
213 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214 			return true;
215 		}
216 
217 		// Decrease approval
218 		function decreaseApproval (address _spender, uint _subtractedValue) public
219 			returns (bool success) {
220 			
221 			uint oldValue = allowed[msg.sender][_spender];
222 			
223 			if (_subtractedValue > oldValue) {
224 				allowed[msg.sender][_spender] = 0;
225 			} else {
226 				allowed[msg.sender][_spender] -= _subtractedValue;
227 			}
228 			
229 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230 			return true;
231 		}
232 						
233 		// Change the name and symbol assigned to this contract
234 		function changeNameSymbol(string _name, string _symbol) public onlyOwner {
235 			name = _name;
236 			symbol = _symbol;
237 		}
238 		
239 		// Transfer owner of contract to a new owner
240 		function transferOwnership(address _newOwner) public onlyOwner {
241 			owner = _newOwner;
242 		}
243 	}