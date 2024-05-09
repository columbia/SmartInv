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
37 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
38 
39 contract Ownable {
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   function Ownable() public {
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 contract TokenERC20 is Ownable {
62 	
63     using SafeMath for uint256;
64     
65     string public constant name       = "PWCC";
66     string public constant symbol     = "PWCC";
67     uint32 public constant decimals   = 18;
68     uint256 public totalSupply;
69     uint256 public currentTotalSupply = 0;
70     uint256 public startBalance       = 2 ether;
71  
72 	
73     mapping(address => bool) touched; 
74     mapping(address => uint256) balances;
75 	mapping(address => mapping (address => uint256)) internal allowed;
76 	mapping(address => bool) public frozenAccount;   
77 	
78 	event FrozenFunds(address target, bool frozen);
79 	event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 	event Burn(address indexed burner, uint256 value);   
82 	
83 	function TokenERC20(
84         uint256 initialSupply
85     ) public {
86         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
87         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
88     }
89 	
90     function totalSupply() public view returns (uint256) {
91 		return totalSupply;
92 	}	
93 	
94 	function transfer(address _to, uint256 _value) public returns (bool) {
95 		require(_to != address(0));
96 		 
97 		if( !touched[msg.sender] && currentTotalSupply < totalSupply  ){
98             balances[msg.sender] = balances[msg.sender].add( startBalance );
99             touched[msg.sender] = true;
100             currentTotalSupply = currentTotalSupply.add( startBalance );
101         }
102 		
103 		require(_value <= balances[msg.sender]);
104 
105 		balances[msg.sender] = balances[msg.sender].sub(_value);
106 		balances[_to] = balances[_to].add(_value);
107 		emit Transfer(msg.sender, _to, _value);
108 		return true;
109 	}
110 	
111 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112 		require(_to != address(0));
113 		require(_value <= balances[_from]);
114 		require(_value <= allowed[_from][msg.sender]);	
115 
116         if( !touched[_from] && currentTotalSupply < totalSupply ){
117             touched[_from] = true;
118             balances[_from] = balances[_from].add( startBalance );
119             currentTotalSupply = currentTotalSupply.add( startBalance );
120         }
121 
122 		balances[_from] = balances[_from].sub(_value);
123 		balances[_to] = balances[_to].add(_value);
124 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125 		emit Transfer(_from, _to, _value);
126 		return true;
127 	}
128 
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131 		allowed[msg.sender][_spender] = _value;
132 		emit Approval(msg.sender, _spender, _value);
133 		return true;
134 	}
135 
136     function allowance(address _owner, address _spender) public view returns (uint256) {
137 		return allowed[_owner][_spender];
138 	}
139 
140 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
141 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143 		return true;
144 	}
145 
146 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
147 		uint oldValue = allowed[msg.sender][_spender];
148 		if (_subtractedValue > oldValue) {
149 			allowed[msg.sender][_spender] = 0;
150 		} else {
151 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152 		}
153 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154 		return true;
155 	}
156 	
157 	function getBalance(address _a) internal constant returns(uint256) {
158         if( currentTotalSupply < totalSupply ){
159             if( touched[_a] )
160                 return balances[_a];
161             else
162                 return balances[_a].add( startBalance );
163         } else {
164             return balances[_a];
165         }
166     }
167     
168     function balanceOf(address _owner) public view returns (uint256 balance) {
169         return getBalance( _owner );
170     }
171 	
172  
173 
174  
175 	
176 	function () payable public {
177   
178     }
179 	
180  
181 
182  
183     function getEth(uint num) payable public onlyOwner {
184     	owner.transfer(num);
185     }
186 	
187  
188 	function modifyairdrop(uint256 _startBalance ) public onlyOwner {
189 		startBalance = _startBalance;
190 	}
191  
192 	
193 }