1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9 	uint256 public totalSupply;
10 	function balanceOf(address who) public constant returns (uint256);
11 	function transfer(address to, uint256 value) public returns (bool);
12 	event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20 	function allowance(address owner, address spender) public constant returns (uint256);
21 	function transferFrom(address from, address to, uint256 value) public returns (bool);
22 	function approve(address spender, uint256 value) public returns (bool);
23 	event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32 		uint256 c = a * b;
33 		assert(a == 0 || c / a == b);
34 		return c;
35 	}
36 
37 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
38 		// assert(b > 0); // Solidity automatically throws when dividing by 0
39 		uint256 c = a / b;
40 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 		return c;
42 	}
43 
44 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45 		assert(b <= a); 
46 		return a - b; 
47 	} 
48 	
49 	function add(uint256 a, uint256 b) internal pure returns (uint256) { 
50 		uint256 c = a + b; assert(c >= a);
51 		return c;
52 	}
53 
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61 	using SafeMath for uint256;
62 
63 	mapping(address => uint256) balances;
64 
65 	/**
66 	* @dev transfer token for a specified address
67 	* @param _to The address to transfer to.
68 	* @param _value The amount to be transferred.
69 	*/
70 	function transfer(address _to, uint256 _value) public returns (bool) {
71 		require(_to != address(0));
72 		require(_value <= balances[msg.sender]); 
73 		balances[msg.sender] = balances[msg.sender].sub(_value); 
74 		balances[_to] = balances[_to].add(_value); 
75 		emit Transfer(msg.sender, _to, _value); 
76 		return true; 
77 	} 
78 
79 	/** 
80 	 * @dev Gets the balance of the specified address. 
81 	 * @param _owner The address to query the the balance of. 
82 	 * @return An uint256 representing the amount owned by the passed address. 
83 	 */ 
84 	function balanceOf(address _owner) public constant returns (uint256 balance) { 
85 		return balances[_owner]; 
86 	} 
87 } 
88 
89 /** 
90  * @title Standard ERC20 token 
91  * 
92  * @dev Implementation of the basic standard token. 
93  * @dev https://github.com/ethereum/EIPs/issues/20 
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
95  */ 
96 contract StandardToken is ERC20, BasicToken {
97 
98 	mapping (address => mapping (address => uint256)) internal allowed;
99 
100 	/**
101 	 * @dev Transfer tokens from one address to another
102 	 * @param _from address The address which you want to send tokens from
103 	 * @param _to address The address which you want to transfer to
104 	 * @param _value uint256 the amount of tokens to be transferred
105 	 */
106 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107 		require(_to != address(0));
108 		require(_value <= balances[_from]);
109 		require(_value <= allowed[_from][msg.sender]); 
110 		balances[_from] = balances[_from].sub(_value); 
111 		balances[_to] = balances[_to].add(_value); 
112 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
113 		emit Transfer(_from, _to, _value); 
114 		return true; 
115 	} 
116 
117  /** 
118 	* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
119 	* 
120 	* Beware that changing an allowance with this method brings the risk that someone may use both the old 
121 	* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
122 	* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
123 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
124 	* @param _spender The address which will spend the funds. 
125 	* @param _value The amount of tokens to be spent. 
126 	*/ 
127 	function approve(address _spender, uint256 _value) public returns (bool) { 
128 		allowed[msg.sender][_spender] = _value; 
129 		emit Approval(msg.sender, _spender, _value); 
130 		return true; 
131 	}
132 
133  /** 
134 	* @dev Function to check the amount of tokens that an owner allowed to a spender. 
135 	* @param _owner address The address which owns the funds. 
136 	* @param _spender address The address which will spend the funds. 
137 	* @return A uint256 specifying the amount of tokens still available for the spender. 
138 	*/ 
139 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
140 		return allowed[_owner][_spender]; 
141 	} 
142 
143  /** 
144 	* approve should be called when allowed[_spender] == 0. To increment 
145 	* allowed value is better to use this function to avoid 2 calls (and wait until 
146 	* the first transaction is mined) * From MonolithDAO Token.sol 
147 	*/ 
148 	function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
149 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
150 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
151 		return true; 
152 	}
153 
154 	function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
155 		uint oldValue = allowed[msg.sender][_spender]; 
156 		if (_subtractedValue > oldValue) {
157 			allowed[msg.sender][_spender] = 0;
158 		} else {
159 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
160 		}
161 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162 		return true;
163 	}
164 
165 	function () public payable {
166 		revert();
167 	}
168 
169 }
170 
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177 	address public owner;
178 
179 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181 	/**
182 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
183 	 * account.
184 	 */
185 	constructor() public {
186 		owner = msg.sender;
187 	}
188 
189 	/**
190 	 * @dev Throws if called by any account other than the owner.
191 	 */
192 	modifier onlyOwner() {
193 		require(msg.sender == owner);
194 		_;
195 	}
196 
197 	/**
198 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
199 	 * @param newOwner The address to transfer ownership to.
200 	 */
201 	function transferOwnership(address newOwner) onlyOwner public {
202 		require(newOwner != address(0));
203 		emit OwnershipTransferred(owner, newOwner);
204 		owner = newOwner;
205 	}
206 
207 }
208 
209 /**
210  * @title Mintable token
211  * @dev Simple ERC20 Token example, with mintable token creation
212  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
213  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
214  */
215 contract MintableToken is StandardToken, Ownable {
216 		
217 	event Mint(address indexed to, uint256 amount);
218     
219     uint public totalMined;
220 
221 	function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
222 		require(totalMined.sub(totalSupply) >= _amount);
223 		totalSupply = totalSupply.add(_amount);
224 		balances[_to] = balances[_to].add(_amount);
225 		emit Mint(_to, _amount);
226 		return true;
227 	}
228 }
229 
230 contract vBitcoin is MintableToken {
231 	string public constant name = "Virtual Bitcoin";
232 	string public constant symbol = "vBTC";
233 	uint32 public constant decimals = 18;
234 	
235     uint public start = 1529934560;
236     uint public startBlockProfit = 50;
237     uint public blockBeforeChange = 210000;
238     uint public blockTime = 15 minutes;
239     
240     function defrosting() onlyOwner public {
241         
242         uint _totalMined = 0;
243         uint timePassed = now.sub(start);
244         uint blockPassed = timePassed.div(blockTime);
245         uint blockProfit = startBlockProfit;
246         
247         while(blockPassed > 0) {
248             if(blockPassed > blockBeforeChange) {
249                 _totalMined = _totalMined.add(blockBeforeChange.mul(blockProfit));
250                 blockProfit = blockProfit.div(2);
251                 blockPassed = blockPassed.sub(blockBeforeChange);
252             } else {
253                 _totalMined = _totalMined.add(blockPassed.mul(blockProfit));
254                 blockPassed = 0;
255             }
256         }
257         
258         totalMined = _totalMined;
259     }
260 }