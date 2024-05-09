1 pragma solidity ^0.4.11;
2 	/**
3 		* @title SafeMath
4 		* @dev Math operations with safety checks that throw on error
5 	*/
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }}
27 	/**
28 		* @title Ownable
29 		* @dev The Ownable contract has an owner address, and provides basic authorization control 
30 		* functions, this simplifies the implementation of "user permissions". 
31 	*/
32 contract Ownable {
33   address public owner;
34 	/** 
35 		* @dev The Ownable constructor sets the original `owner` of the contract to the sender
36 		* account.
37 	*/
38   function Ownable() {
39     owner = msg.sender;
40   }
41 	/**
42 		* @dev Throws if called by any account other than the owner. 
43 	*/
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 	/**
49 		* @dev Allows the current owner to transfer control of the contract to a newOwner.
50         * @param newOwner The address to transfer ownership to. 
51 	*/
52   function transferOwnership(address newOwner) onlyOwner {
53     if (newOwner != address(0)) {
54       owner = newOwner;
55     }  }
56 }
57 	/**
58 		* @title ERC20Basic
59 		* @dev Simpler version of ERC20 interface
60 		* @dev see https://github.com/ethereum/EIPs/issues/179
61 	*/
62 contract ERC20Basic {
63   uint256 public totalSupply;
64   function balanceOf(address who) constant returns (uint256);
65   function transfer(address to, uint256 value) returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 	/**
69 		* @title Basic token
70 		* @dev Basic version of StandardToken, with no allowances. 
71 	*/
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74   mapping(address => uint256) balances;
75 	/**
76 		* @dev transfer token for a specified address
77 		* @param _to The address to transfer to.
78 		* @param _value The amount to be transferred.
79 	*/
80   function transfer(address _to, uint256 _value) returns (bool) {
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 	/**
87 		* @dev Gets the balance of the specified address.
88 		* @param _owner The address to query the the balance of. 
89 		* @return An uint256 representing the amount owned by the passed address.
90 	*/
91   function balanceOf(address _owner) constant returns (uint256 balance) {
92     return balances[_owner];
93   }
94 }
95 	/**
96 		* @title ERC20 interface
97 		* @dev see https://github.com/ethereum/EIPs/issues/20
98 	*/
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) constant returns (uint256);
101   function transferFrom(address from, address to, uint256 value) returns (bool);
102   function approve(address spender, uint256 value) returns (bool);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 	/**
106 		* @title Standard ERC20 token
107 		*
108 		* @dev Implementation of the basic standard token.
109 		* @dev https://github.com/ethereum/EIPs/issues/20
110 		* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111 	*/
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) allowed;
115 	/**
116 		* @dev Transfer tokens from one address to another
117         * @param _from address The address which you want to send tokens from
118 		* @param _to address The address which you want to transfer to
119 		* @param _value uint256 the amout of tokens to be transfered
120 	*/
121   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
122     var _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_to] = balances[_to].add(_value);
128     balances[_from] = balances[_from].sub(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 	/**
134 		* @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
135 		* @param _spender The address which will spend the funds.
136 		* @param _value The amount of tokens to be spent.
137 	*/
138   function approve(address _spender, uint256 _value) returns (bool) {
139 	/**
140 		* To change the approve amount you first have to reduce the addresses`
141 		* allowance to zero by calling `approve(_spender, 0)` if it is not
142 		* already 0 to mitigate the race condition described here:
143 		* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144 	*/
145     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
146 
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 	/**
152 		* @dev Function to check the amount of tokens that an owner allowed to a spender.
153 		* @param _owner address The address which owns the funds.
154 		* @param _spender address The address which will spend the funds.
155 		* @return A uint256 specifing the amount of tokens still avaible for the spender.
156 	*/
157   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
158     return allowed[_owner][_spender];
159   }
160 }
161 contract BIONEUM is StandardToken, Ownable {
162     using SafeMath for uint256;
163     // Token Info.
164     string  public constant name = "BIONEUM";
165     string  public constant symbol = "BIO";
166     uint256 public constant decimals = 8;
167     uint256 public constant totalSupply = decVal(50000000);
168 	
169     // Address where funds are collected.
170     address public multisig = 0x999bb65DBfc56742d6a65b1267cfdacf2afa5FBE;
171     // Developer tokens.
172 	address public developers = 0x8D9acc27005419E0a260B44d060F7427Cd9739B2;
173     // Founder tokens.
174 	address public founders = 0xB679919c63799c39d074EEad650889B24C06fdC6;
175     // Bounty tokens.
176 	address public bounty = 0xCF2F450FB7d265fF82D0c2f1737d9f0258ae40A3;
177 	// Address of this contract/token
178     address public constant tokenAddress = this;
179     // Sale period.
180     uint256 public startDate;
181     uint256 public endDate;
182     // Amount of raised money in wei.
183     uint256 public weiRaised;
184     // Number of tokens sold.
185 	uint256 public tokensSold;
186     // Modifiers.
187     modifier uninitialized() {
188         require(multisig == 0x0);
189         _;
190     }    
191 	function BIONEUM() {
192         startDate = now;
193         endDate = startDate.add(30 days);
194 		
195         balances[founders] 	= decVal(5000000);
196         Transfer(0x0, founders	, balances[founders]);
197 		
198         balances[bounty] 	= decVal(1000000);
199         Transfer(0x0, bounty	, balances[bounty]);
200 		
201         balances[developers] = decVal(4000000);
202         Transfer(0x0, developers	, balances[developers]);
203 		
204 		balances[this] = totalSupply.sub(balances[developers].add(balances[founders]).add(balances[bounty]));
205         Transfer(0x0, this		, balances[this]);
206     }
207     function supply() internal returns (uint256) {
208         return balances[this];
209     }
210     function getRateAt(uint256 at, uint256 amount) constant returns (uint256) {
211         if (at < startDate) {
212             return 0;
213         } else if (at < startDate.add(7 days)) {
214             return decVal(1300);
215         } else if (at < startDate.add(14 days)) {
216             return decVal(1150);
217         } else if (at < startDate.add(21 days)) {
218             return decVal(1050);
219         } else if (at < startDate.add(28 days) || at <= endDate) {
220             return decVal(1000);
221         } else {
222             return 0;
223         }
224 	}
225 	function decVal(uint256 amount) internal returns(uint256){
226 		return amount * 10 ** uint256(decimals);
227 	}
228     // Fallback function can be used to buy tokens
229     function () payable {
230         buyTokens(msg.sender, msg.value);
231     }
232     function buyTokens(address sender, uint256 value) internal {
233         require(saleActive());
234         require(value >= 0.001 ether);
235         uint256 weiAmount = value;
236         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
237         // Calculate token amount to be purchased
238         uint256 actualRate = getRateAt(now, amount);
239         uint256 amount = weiAmount.mul(actualRate).div(1 ether);
240         // We have enough token to sell
241         require(supply() >= amount);
242         // Transfer tokens
243         balances[this] = balances[this].sub(amount);
244         balances[sender] = balances[sender].add(amount);
245 		Transfer(this, sender, amount);
246         // Update state.
247         weiRaised = updatedWeiRaised;
248 		tokensSold = tokensSold.add(amount);
249         // Forward the fund to fund collection wallet.
250         multisig.transfer(msg.value);
251     }
252 	function internalSend(address recipient, uint256 bioAmount) onlyOwner{
253 		// We have enough token to send
254 		// Function used to provide tokens to users who participated in the 1.0 token sale
255         require(supply() >= bioAmount);
256         // Transfer tokens
257         balances[this] = balances[this].sub(bioAmount);
258         balances[recipient] = balances[recipient].add(bioAmount);
259 		Transfer(this, recipient, bioAmount);
260 	}
261     function finalize() onlyOwner {
262         require(!saleActive());
263 		// Burn all unsold tokens at the end of the crowdsale
264 		Transfer(this, 0x0, balances[this]);
265         balances[this] = 0;
266     }
267     function saleActive() public constant returns (bool) {
268         return (now >= startDate && now < endDate && supply() > 0);
269     }
270 }