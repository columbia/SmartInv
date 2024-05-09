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
65     string public constant name       = "KUP";
66     string public constant symbol     = "KUP";
67     uint32 public constant decimals   = 18;
68     uint256 public totalSupply;
69 
70     mapping(address => uint256) balances;
71 	mapping(address => mapping (address => uint256)) internal allowed;
72 
73 	
74 
75 	event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 
78 	
79 	function TokenERC20(
80         uint256 initialSupply
81     ) public {
82         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
83         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
84     }
85 	
86     function totalSupply() public view returns (uint256) {
87 		return totalSupply;
88 	}	
89 	
90 	function transfer(address _to, uint256 _value) public returns (bool) {
91 		require(_to != address(0));
92 		require(_value <= balances[msg.sender]);
93 		balances[msg.sender] = balances[msg.sender].sub(_value);
94 		balances[_to] = balances[_to].add(_value);
95 		emit Transfer(msg.sender, _to, _value);
96 		return true;
97 	}
98 	
99 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
100 		require(_to != address(0));
101 		require(_value <= balances[_from]);
102 		require(_value <= allowed[_from][msg.sender]);	
103 		balances[_from] = balances[_from].sub(_value);
104 		balances[_to] = balances[_to].add(_value);
105 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106 		emit Transfer(_from, _to, _value);
107 		return true;
108 	}
109 
110 
111     function approve(address _spender, uint256 _value) public returns (bool) {
112 		allowed[msg.sender][_spender] = _value;
113 		emit Approval(msg.sender, _spender, _value);
114 		return true;
115 	}
116 
117     function allowance(address _owner, address _spender) public view returns (uint256) {
118 		return allowed[_owner][_spender];
119 	}
120 
121 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
122 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
123 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124 		return true;
125 	}
126 
127 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
128 		uint oldValue = allowed[msg.sender][_spender];
129 		if (_subtractedValue > oldValue) {
130 			allowed[msg.sender][_spender] = 0;
131 		} else {
132 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
133 		}
134 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135 		return true;
136 	}
137 	
138 	function getBalance(address _a) internal constant returns(uint256) {
139 
140             return balances[_a];
141        
142     }
143     
144     function balanceOf(address _owner) public view returns (uint256 balance) {
145         return getBalance( _owner );
146     }
147 	
148 
149  
150 	
151 }