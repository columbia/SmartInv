1 pragma solidity ^0.4.19;
2 
3 /**
4  * Copyright (C) DinarETH Cryptoken
5  * All rights reserved.
6  *  *
7  * Note: This code is adapted from Fixed Supply token contract 
8  * (c) BokkyPooBah 2017. The MIT Licence.
9  *
10  */
11  
12  /**
13  * 	@title SafeMath
14  * 	@dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41  
42 /*
43  * 	Standard ERC20 interface. Adapted from https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
44  *
45 */ 
46 	contract ERC20Interface {
47       
48 		function totalSupply() public constant returns (uint256 totSupply);   
49 	    function balanceOf(address _owner) public constant returns (uint256 balance);   
50 		function transfer(address _to, uint256 _amount) public returns (bool success);	  
51 		function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);   
52 		function approve(address _spender, uint256 _value) public returns (bool success);   
53 		function allowance(address _owner, address _spender) public constant returns (uint256 remaining);             
54 		event Transfer(address indexed _from, address indexed _to, uint256 _value);   
55 		event Approval(address indexed _owner, address indexed _spender, uint256 _value); 	
56 	  
57 	}
58 
59 /*
60  * 	Interface to cater for DinarETH specific requirements
61  *
62 */
63 	contract DinarETHInterface {
64   
65 		function getGoldXchgRate() public constant returns (uint rate);
66 		function setGoldCertVerifier(string _baseURL) public;
67 		function increaseApproval(address _spender, uint _addedValue) public returns (bool success);
68 		function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success);
69 		function transferOwnership(address _newOwner) public;
70 	}
71 
72 /*
73  * 	DinarETH Crypto contract
74  *
75 */
76 	contract DinarETHCrypto is ERC20Interface, DinarETHInterface {
77 		using SafeMath for uint256;
78 	
79 		string public symbol = "DNAR";
80 		string public name = "DinarETH";
81 		string public goldCertVerifier = "https://dinareth.io/goldcert/"; //example https://dinareth.io/goldcert/0xdb2996EF3724Ab7205xxxxxxx
82 		uint8 public constant decimals = 8;
83 		uint256 public constant DNARtoGoldXchgRate = 10000000;			 // 1 DNAR = 0.1g Gold
84 		uint256 public constant _totalSupply = 9900000000000000;
85       
86 		// Owner of this contract
87 		address public owner;
88    
89 		// Balances for each account
90 		mapping(address => uint256) balances;
91    
92 		// Owner of account approves the transfer of an amount to another account
93 		mapping(address => mapping (address => uint256)) allowed;
94    
95 		// Functions with this modifier can only be executed by the owner
96 		modifier onlyOwner() {          
97 			require(msg.sender == owner);
98 			_;		  
99 		}
100 	  
101 		// Functions with this modifier can only be executed not to this contract. This is to avoid sending ERC20 tokens to this contract address
102 		modifier notThisContract(address _to) {		
103 			require(_to != address(this));
104 			_;			  
105 		}
106    
107 		// Constructor
108 		function DinarETHCrypto() public {	  
109 			owner = msg.sender;
110 			balances[owner] = _totalSupply;		  
111 		}
112       
113 		// This is safety mechanism to allow ETH (if any) in this contract address to be sent to the contract owner
114 		function () payable public {
115 			if(this.balance > 1000000000000000000){
116 				owner.transfer(this.balance);
117 			}
118 		}
119 
120 		// Returns the account balance of another account with address _owner.
121 		function balanceOf(address _owner) public constant returns (uint256 balance) {
122 			return balances[_owner];
123 		}
124 	  
125 		// Returns the total token supply.
126 		function totalSupply() public constant returns (uint256 totSupply) {
127 			return _totalSupply;
128 		}
129 	    
130 		// Transfer the balance from owner's account to another account
131 		function transfer(address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {
132 			require(_to != 0x0);
133 			require(_amount > 0);
134 			require(balances[msg.sender] >= _amount);
135 			require(balances[_to] + _amount > balances[_to]);
136 			balances[msg.sender] -= _amount;
137 			balances[_to] += _amount;		  
138 			Transfer(msg.sender, _to, _amount);
139 			return true;	 
140 		}
141    
142 		// The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. 
143 		// This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. 
144 		// The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.
145 		// Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
146 		function transferFrom( address _from, address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {	
147 		
148 		   require(balances[_from] >= _amount);
149 		   require(allowed[_from][msg.sender] >= _amount);
150 		   require(_amount > 0);
151 		   require(balances[_to] + _amount > balances[_to]);
152 		   
153 		   balances[_from] -= _amount;
154            allowed[_from][msg.sender] -= _amount;
155            balances[_to] += _amount;
156            Transfer(_from, _to, _amount);
157            return true;        
158 		}
159 	 
160 		// Allows _spender to withdraw from your account multiple times, up to the _value amount. 
161 		// If this function is called again it overwrites the current allowance with _value
162 		// To change the approve amount you first have to reduce the addresses`
163 		// allowance to zero by calling `approve(_spender, 0)` if it is not
164 		// already 0 to mitigate the race condition described here:
165 		// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729   		
166 		function approve(address _spender, uint256 _amount) public returns (bool) {		
167 		
168 			require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
169 		  
170 			allowed[msg.sender][_spender] = _amount;
171 			Approval(msg.sender, _spender, _amount);
172 			return true;
173 		}
174 		
175 		// Returns the amount which _spender is still allowed to withdraw from _owner
176 		function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
177 			return allowed[_owner][_spender];
178 		}
179 		
180 		function send(address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {
181 		    return transfer(_to, _amount);
182 		}
183 		
184 		function sendFrom( address _from, address _to, uint256 _amount) public notThisContract(_to) returns (bool success) {	
185 		    return transferFrom(_from, _to, _amount);
186 		}
187 		   
188 		// Approve should be called when allowed[_spender] == 0. To increment
189 		// allowed value is better to use this function to avoid 2 calls (and wait until 
190 		// the first transaction is mined)
191 		// From MonolithDAO Token.sol
192 		function increaseApproval (address _spender, uint _addedValue) public 
193 			returns (bool success) {
194 			
195 			allowed[msg.sender][_spender] += _addedValue;
196 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197 			return true;
198 		}
199 
200 		// Decrease approval
201 		function decreaseApproval (address _spender, uint _subtractedValue) public
202 			returns (bool success) {
203 			
204 			uint oldValue = allowed[msg.sender][_spender];
205 			
206 			if (_subtractedValue > oldValue) {
207 				allowed[msg.sender][_spender] = 0;
208 			} else {
209 				allowed[msg.sender][_spender] -= _subtractedValue;
210 			}
211 			
212 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213 			return true;
214 		}
215 		
216 		// Get DNAR to Gold (in gram) exchange rate. I.e. 1 DNAR = 0.1g Gold
217 		function getGoldXchgRate() public constant returns (uint rate) {						
218 			return DNARtoGoldXchgRate;			
219 		}
220 		
221 		// Set Gold Certificate Verifier URL
222 		function setGoldCertVerifier(string _baseURL) public onlyOwner {
223 			goldCertVerifier = _baseURL;
224 		}
225 								
226 		// Change the name and symbol assigned to this contract
227 		function changeNameSymbol(string _name, string _symbol) public onlyOwner {
228 			name = _name;
229 			symbol = _symbol;
230 		}
231 		
232 		// Transfer owner of contract to a new owner
233 		function transferOwnership(address _newOwner) public onlyOwner {
234 			owner = _newOwner;
235 		}
236 	}