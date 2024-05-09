1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract owned {
39     address public owner;
40 
41     function owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) onlyOwner public {
51         owner = newOwner;
52     }
53 }
54 
55 contract TokenERC20 is owned {
56 	
57     using SafeMath for uint256;
58     
59     string public constant name       = "Potter coin";
60     string public constant symbol     = "POTB";
61     uint32 public constant decimals   = 18;
62     uint256 public totalSupply;
63 
64     mapping(address => uint256) balances;
65 	mapping(address => mapping (address => uint256)) internal allowed;
66 	mapping(address => bool) public frozenAccount;
67 
68 	event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70      // This notifies clients about the amount burnt
71     event Burn(address indexed from, uint256 value);
72      /* This generates a public event on the blockchain that will notify clients */
73     event FrozenFunds(address target, bool frozen);
74 
75 	
76 	function TokenERC20(
77         uint256 initialSupply
78     ) public {
79         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
80         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
81     }
82 	
83     function totalSupply() public view returns (uint256) {
84 		return totalSupply;
85 	}	
86 	
87 	function transfer(address _to, uint256 _value) public returns (bool) {
88 		require(_to != address(0));
89 		require(_value <= balances[msg.sender]);
90 		if(!frozenAccount[msg.sender]){
91 		    balances[msg.sender] = balances[msg.sender].sub(_value);
92 		    balances[_to] = balances[_to].add(_value);
93 		    emit Transfer(msg.sender, _to, _value);
94 		    return true;
95 		} else{
96 		    return false;
97 		}
98 		
99 	}
100 	
101 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102 		require(_to != address(0));
103 		require(_value <= balances[_from]);
104 		require(_value <= allowed[_from][msg.sender]);
105 		if(!frozenAccount[_from]){
106 		    balances[_from] = balances[_from].sub(_value);
107 		    balances[_to] = balances[_to].add(_value);
108 		    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109 		    emit Transfer(_from, _to, _value);
110 		    return true;
111 		}else{
112 		    return false;
113 		}
114 		
115 	}
116 
117 
118     function approve(address _spender, uint256 _value) public returns (bool) {
119 		allowed[msg.sender][_spender] = _value;
120 		emit Approval(msg.sender, _spender, _value);
121 		return true;
122 	}
123 
124     function allowance(address _owner, address _spender) public view returns (uint256) {
125 		return allowed[_owner][_spender];
126 	}
127 
128 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131 		return true;
132 	}
133 
134 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
135 		uint oldValue = allowed[msg.sender][_spender];
136 		if (_subtractedValue > oldValue) {
137 			allowed[msg.sender][_spender] = 0;
138 		} else {
139 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
140 		}
141 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142 		return true;
143 	}
144 	
145  
146     function balanceOf(address _owner) public view returns (uint256 balance) {
147         return balances[_owner];
148     }
149     
150     ////
151     /**
152      * Destroy tokens from other account
153      *
154      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
155      *
156      * @param _from the address of the sender
157      * @param _value the amount of money to burn
158      */
159      
160        function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
161         require(balances[_from] >= _value);              
162         balances[_from] = balances[_from].sub(_value);                          
163         balances[msg.sender] = balances[msg.sender].add(_value);
164         return true;
165     }
166     
167   
168     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
169     /// @param target Address to be frozen
170     /// @param freeze either to freeze it or not
171     function freezeAccount(address target, bool freeze) onlyOwner public {
172         frozenAccount[target] = freeze;
173     }
174 
175 }