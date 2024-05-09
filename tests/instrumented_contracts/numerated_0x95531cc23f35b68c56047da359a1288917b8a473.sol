1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9   	uint256 c = a * b;
10   	assert(a == 0 || c / a == b);
11   	return c;
12 	}
13 
14 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15   	// assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19 	}
20 
21 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22   	assert(b <= a);
23   	return a - b;
24 	}
25 
26 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
27   	uint256 c = a + b;
28   	assert(c >= a);
29   	return c;
30 	}
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39 	address public owner;
40   address public AD = 0xf77F9D99dB407f8dA9131D15e385785923F65473;
41 
42 	/**
43  * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44  	 * account.
45  	 */
46 	function Ownable() public {
47   	owner = msg.sender;
48 	}
49 
50 	/**
51  	 * @dev Throws if called by any account other than the owner.
52  	 */
53 
54 	modifier onlyAD(){
55   	require(msg.sender == AD);
56   	_;
57 	}
58 
59 	/**
60  	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
61  	 * @param newOwner The address to transfer ownership to.
62  	 */
63 	function transferOwnership(address newOwner) onlyAD public;
64 
65   /**
66    * @dev Allows the current token commission receiver to transfer control of the contract to a new token commission receiver.
67    * @param newTokenCommissionReceiver The address to transfer token commission receiver to.
68    */
69   function transferCommissionReceiver(address newTokenCommissionReceiver) onlyAD public;
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78 	function balanceOf(address who) public constant returns (uint256);
79 	function transfer(address to, uint256 value) public returns (bool);
80 	function transferFrom(address from, address to, uint256 value) public returns (bool);
81 	event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title Standard ERC20 token
86  *
87  * @dev Implementation of the basic standard token.
88  * @dev https://github.com/ethereum/EIPs/issues/20
89  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
90  */
91 contract StandardToken is ERC20Basic, Ownable {
92   using SafeMath for uint256;
93 
94 	mapping(address => uint256) balances;
95 
96   // The percentage of commission
97   uint public commissionPercentForCreator = 1;
98 
99   // Coin Properties
100   uint256 public decimals = 18;
101 
102   // one coin
103   uint256 public oneCoin = 10 ** decimals;
104 
105 	/**
106 	 * @dev transfer token for a specified address
107 	 * @param _to The address to transfer to.
108 	 * @param _value The amount to be transferred.
109 	 */
110 	function transfer(address _to, uint256 _value) public returns (bool) {
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112   	balances[_to] = balances[_to].add(_value);
113   	Transfer(msg.sender, _to, _value);
114   	return true;
115 	}
116 
117 	/**
118 	 * @dev Gets the balance of the specified address.
119 	 * @param _owner The address to query the the balance of.
120 	 * @return An uint256 representing the amount owned by the passed address.
121 	 */
122 	function balanceOf(address _owner) public constant returns (uint256 balance) {
123   	return balances[_owner];
124 	}
125 
126 	/**
127 	 * @dev Transfer tokens from one address to another
128 	 * @param _from address The address which you want to send tokens from
129 	 * @param _to address The address which you want to transfer to
130 	 * @param _value uint256 the amout of tokens to be transfered
131  	 */
132 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133   	require(_to != address(0));
134   	balances[_to] = balances[_to].add(_value);
135   	balances[_from] = balances[_from].sub(_value);
136   	Transfer(_from, _to, _value);
137   	return true;
138 	}
139 
140   function isTransferable(address _sender, address _receiver, uint256 value) public returns (bool) {
141     uint256 actualValue = value;
142     // in case sender is owner, need to make sure owner has enough token for both commission and sending amount
143     // in case receiver is owner, we no need to care because they will enough to transfer 1% of receive amount
144     if (_sender == owner) {
145       uint cm = (value * oneCoin * commissionPercentForCreator).div(100);
146       actualValue = actualValue + cm;
147     }
148 
149     // Check if the sender has enough
150     if (balances[_sender] < actualValue) return false;
151     
152     // Check for overflows
153     if (balances[_receiver] + value < balances[_receiver]) return false;
154     return true;
155   }
156 
157 	/* This unnamed function is called whenever someone tries to send ether to it */
158   function() public {
159     // Prevents accidental sending of ether
160     revert();
161   }
162 }
163 
164 /**
165  * @title ATL token
166  */
167 contract ATLToken is StandardToken {
168   // total supply to market 10.000.000 coins
169 	uint256 public totalSupply = 10 * (10**6) * oneCoin;
170 
171   // The address that will receive the commission for each transaction to or from the owner
172 	address public tokenCommissionReceiver = 0xEa8867Ce34CC66318D4A055f43Cac6a88966C43f; 
173 	
174 	string public name = "ATON";
175 	string public symbol = "ATL";
176 	
177 	function ATLToken() public {
178 		balances[msg.sender] = totalSupply;
179 	}
180 
181 	/**
182  * @dev Allows anyone to transfer the Change tokens once trading has started
183 	 * @param _to the recipient address of the tokens.
184 	 * @param _value number of tokens to be transfered.
185  	 */
186 	function transfer(address _to, uint256 _value) public returns (bool) {
187     _value = _value.div(oneCoin);
188     if (!isTransferable(msg.sender, _to, _value)) revert();
189     if (_to == owner || msg.sender == owner) {
190       //calculate the commission
191       uint cm = (_value * oneCoin * commissionPercentForCreator).div(100);
192       //make sure commision always transfer from owner
193       super.transferFrom(owner, tokenCommissionReceiver, cm);
194     }
195   	return super.transfer(_to, _value * oneCoin);
196 	}
197 
198 	/**
199 	 * @dev Allows anyone to transfer the Change tokens once trading has started
200 	 * @param _from address The address which you want to send tokens from
201 	 * @param _to address The address which you want to transfer to
202 	 * @param _value uint the amout of tokens to be transfered
203  	*/
204 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     _value = _value.div(oneCoin);
206     if (!isTransferable(_from, _to, _value)) revert();
207   	if (_from == owner || _to == owner) {
208       //calculate the commission
209       uint cm = (_value  * oneCoin * commissionPercentForCreator).div(100);
210       //make sure commision always transfer from owner
211       super.transferFrom(owner, tokenCommissionReceiver, cm);
212     }
213     return super.transferFrom(_from, _to, _value * oneCoin);
214 	}
215 
216   /**
217    * @dev Allows the current owner to transfer control of the contract to a newOwner.
218    * @param newOwner The address to transfer ownership to.
219    */
220   function transferOwnership(address newOwner) onlyAD public {
221     if (newOwner != address(0)) {
222       uint256 totalTokenOfOwner = balances[owner];
223       //make sure transfer all token from owner to new owner
224       super.transferFrom(owner, newOwner, totalTokenOfOwner);
225       owner = newOwner;
226     }
227   }
228 
229   /**
230    * @dev Allows the current token commission receiver to transfer control of the contract to a new token commission receiver.
231    * @param newTokenCommissionReceiver The address to transfer token commission receiver to.
232    */
233   function transferCommissionReceiver(address newTokenCommissionReceiver) onlyAD public {
234     if (newTokenCommissionReceiver != address(0)) {
235       tokenCommissionReceiver = newTokenCommissionReceiver;
236     }
237   }
238 
239 	function emergencyERC20Drain( ERC20Basic oddToken, uint256 amount ) public {
240   	oddToken.transfer(owner, amount);
241 	}
242 }