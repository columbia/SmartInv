1 /**
2  * @title METTA platform token & preICO crowdsale implementasion
3  * @author Maxim Akimov - <devstylesoftware@gmail.com>
4  * @author Dmitrii Bykov - <bykoffdn@gmail.com>
5  */
6 
7 pragma solidity ^0.4.18;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14     
15 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16 		uint256 c = a * b;
17 		assert(a == 0 || c / a == b);
18 		return c;
19 	}
20 
21 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
22 		// assert(b > 0); // Solidity automatically throws when dividing by 0
23 		uint256 c = a / b;
24 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
25 		return c;
26 	}
27 
28 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29 		assert(b <= a);
30 		return a - b;
31 	}
32 
33 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
34 		uint256 c = a + b;
35 		assert(c >= a);
36 		return c;
37 	}
38   
39 }
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47 	uint256 public totalSupply;
48 	function balanceOf(address who) constant returns (uint256);
49 	function transfer(address to, uint256 value) returns (bool);
50 	event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58 	function allowance(address owner, address spender) constant returns (uint256);
59 	function transferFrom(address from, address to, uint256 value) returns (bool);
60 	function approve(address spender, uint256 value) returns (bool);
61 	event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances. 
67  */
68 contract BasicToken is ERC20Basic {
69     
70 	using SafeMath for uint256;
71 
72 	mapping(address => uint256) balances;
73 
74 	/**
75 	* @dev transfer token for a specified address
76 	* @param _to The address to transfer to.
77 	* @param _value The amount to be transferred.
78 	*/
79 	function transfer(address _to, uint256 _value) returns (bool) {
80 		balances[msg.sender] = balances[msg.sender].sub(_value);
81 		balances[_to] = balances[_to].add(_value);
82 		Transfer(msg.sender, _to, _value);
83 		return true;
84 	}
85 
86 	/**
87 	* @dev Gets the balance of the specified address.
88 	* @param _owner The address to query the the balance of. 
89 	* @return An uint256 representing the amount owned by the passed address.
90 	*/
91 	function balanceOf(address _owner) constant returns (uint256 balance) {
92 		return balances[_owner];
93 	}
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105 	mapping (address => mapping (address => uint256)) allowed;
106 
107 	/**
108 	* @dev Transfer tokens from one address to another
109 	* @param _from address The address which you want to send tokens from
110 	* @param _to address The address which you want to transfer to
111 	* @param _value uint256 the amout of tokens to be transfered
112 	*/
113 	function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
114 	  
115 		var _allowance = allowed[_from][msg.sender];
116 
117 		// Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
118 		// require (_value <= _allowance);
119 
120 		balances[_to] = balances[_to].add(_value);
121 		balances[_from] = balances[_from].sub(_value);
122 		allowed[_from][msg.sender] = _allowance.sub(_value);
123 		Transfer(_from, _to, _value);
124 		return true;
125 	}
126 
127 	/**
128 	* @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
129 	* @param _spender The address which will spend the funds.
130 	* @param _value The amount of tokens to be spent.
131 	*/
132 	function approve(address _spender, uint256 _value) returns (bool) {
133 
134 		// To change the approve amount you first have to reduce the addresses`
135 		//  allowance to zero by calling `approve(_spender, 0)` if it is not
136 		//  already 0 to mitigate the race condition described here:
137 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140 		allowed[msg.sender][_spender] = _value;
141 		Approval(msg.sender, _spender, _value);
142 		return true;
143 	}
144 
145 	/**
146 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
147 	* @param _owner address The address which owns the funds.
148 	* @param _spender address The address which will spend the funds.
149 	* @return A uint256 specifing the amount of tokens still available for the spender.
150 	*/
151 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
152 		return allowed[_owner][_spender];
153 	}
154 
155 }
156 
157 /**
158  * @title Ownable
159  * @dev The Ownable contract has an owner address, and provides basic authorization control
160  * functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163     
164 	address public owner;
165 	address public ownerCandidat;
166 
167 	/**
168 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
169 	* account.
170 	*/
171 	function Ownable() {
172 		owner = msg.sender;
173 		
174 	}
175 
176 	/**
177 	* @dev Throws if called by any account other than the owner.
178 	*/
179 	modifier onlyOwner() {
180 		require(msg.sender == owner);
181 		_;
182 	}
183 
184 	/**
185 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
186 	* @param newOwner The address to transfer ownership to.
187 	*/
188 	function transferOwnership(address newOwner) onlyOwner {
189 		require(newOwner != address(0));      
190 		ownerCandidat = newOwner;
191 	}
192 	/**
193 	* @dev Allows safe change current owner to a newOwner.
194 	*/
195 	function confirmOwnership()  {
196 		require(msg.sender == ownerCandidat);      
197 		owner = msg.sender;
198 	}
199 
200 }
201 
202 /**
203  * @title Burnable Token
204  * @dev Token that can be irreversibly burned (destroyed).
205  */
206 contract BurnableToken is StandardToken, Ownable {
207  
208 	/**
209 	* @dev Burns a specific amount of tokens.
210 	* @param _value The amount of token to be burned.
211 	*/
212 	function burn(uint256 _value) public onlyOwner {
213 		require(_value > 0);
214 
215 		address burner = msg.sender;    
216 										
217 
218 		balances[burner] = balances[burner].sub(_value);
219 		totalSupply = totalSupply.sub(_value);
220 		Burn(burner, _value);
221 	}
222 
223 	event Burn(address indexed burner, uint indexed value);
224  
225 }
226  
227 contract MettaCoin is BurnableToken {
228  
229 	string public constant name = "TOKEN METTA";   
230 	string public constant symbol = "METTA";   
231 	uint32 public constant decimals = 18;    
232 	uint256 public constant initialSupply = 300000000 * 1 ether;
233 
234 	function MettaCoin() {
235 		totalSupply = initialSupply;
236 		balances[msg.sender] = initialSupply;
237 	}    
238   
239 }