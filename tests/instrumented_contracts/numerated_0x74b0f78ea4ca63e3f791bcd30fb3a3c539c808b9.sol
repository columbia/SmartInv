1 /*
2 *
3 *
4 *
5 *专业开发ECR20代币，ER721代币，区块链游戏，区块链资金盘，微信fac2323
6 *
7 *专业开发ECR20代币，ER721代币，区块链游戏，区块链资金盘，微信fac2323
8 *
9 *专业开发ECR20代币，ER721代币，区块链游戏，区块链资金盘，微信fac2323
10 *
11 *专业开发ECR20代币，ER721代币，区块链游戏，区块链资金盘，微信fac2323
12 *
13 *
14 *
15 *
16 */
17 
18 
19 
20 pragma solidity ^0.4.21;
21 
22 
23 library SafeMath {
24 
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     if (a == 0) {
27       return 0;
28     }
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 contract owned {
58     address public owner;
59 
60     function owned() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address newOwner) onlyOwner public {
70         owner = newOwner;
71     }
72 }
73 
74 contract TokenERC20 is owned {
75 	
76     using SafeMath for uint256;
77     
78     string public constant name       = "圣链";
79     string public constant symbol     = "HRG";
80     uint32 public constant decimals   = 18;
81     uint256 public totalSupply;
82 
83     mapping(address => uint256) balances;
84 	mapping(address => mapping (address => uint256)) internal allowed;
85 	mapping(address => bool) public frozenAccount;
86 
87 	event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89      // This notifies clients about the amount burnt
90     event Burn(address indexed from, uint256 value);
91      /* This generates a public event on the blockchain that will notify clients */
92     event FrozenFunds(address target, bool frozen);
93 
94 	
95 	function TokenERC20(
96         uint256 initialSupply
97     ) public {
98         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
99         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
100     }
101 	
102     function totalSupply() public view returns (uint256) {
103 		return totalSupply;
104 	}	
105 	
106 	function transfer(address _to, uint256 _value) public returns (bool) {
107 		require(_to != address(0));
108 		require(_value <= balances[msg.sender]);
109 		if(!frozenAccount[msg.sender]){
110 		    balances[msg.sender] = balances[msg.sender].sub(_value);
111 		    balances[_to] = balances[_to].add(_value);
112 		    emit Transfer(msg.sender, _to, _value);
113 		    return true;
114 		} else{
115 		    return false;
116 		}
117 		
118 	}
119 	
120 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121 		require(_to != address(0));
122 		require(_value <= balances[_from]);
123 		require(_value <= allowed[_from][msg.sender]);
124 		if(!frozenAccount[_from]){
125 		    balances[_from] = balances[_from].sub(_value);
126 		    balances[_to] = balances[_to].add(_value);
127 		    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128 		    emit Transfer(_from, _to, _value);
129 		    return true;
130 		}else{
131 		    return false;
132 		}
133 		
134 	}
135 
136 
137     function approve(address _spender, uint256 _value) public returns (bool) {
138 		allowed[msg.sender][_spender] = _value;
139 		emit Approval(msg.sender, _spender, _value);
140 		return true;
141 	}
142 
143     function allowance(address _owner, address _spender) public view returns (uint256) {
144 		return allowed[_owner][_spender];
145 	}
146 
147 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
148 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
149 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150 		return true;
151 	}
152 
153 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
154 		uint oldValue = allowed[msg.sender][_spender];
155 		if (_subtractedValue > oldValue) {
156 			allowed[msg.sender][_spender] = 0;
157 		} else {
158 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159 		}
160 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161 		return true;
162 	}
163 	
164  
165     function balanceOf(address _owner) public view returns (uint256 balance) {
166         return balances[_owner];
167     }
168     
169     ////
170     /**
171      * Destroy tokens from other account
172      *
173      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
174      *
175      * @param _from the address of the sender
176      * @param _value the amount of money to burn
177      */
178      
179        function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
180         require(balances[_from] >= _value);              
181         balances[_from] = balances[_from].sub(_value);                          
182         balances[msg.sender] = balances[msg.sender].add(_value);
183         return true;
184     }
185     
186   
187     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
188     /// @param target Address to be frozen
189     /// @param freeze either to freeze it or not
190     function freezeAccount(address target, bool freeze) onlyOwner public {
191         frozenAccount[target] = freeze;
192     }
193 
194 }