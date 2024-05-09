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
65     string public constant name       = "IOGENESIS";
66     string public constant symbol     = "IOG";
67     uint32 public constant decimals   = 18;
68     uint256 public totalSupply;
69 	address public airdropadd         = 0xBfB92c13455c4ab69A2619614164c45Cb4BEC09C;
70     uint256 public startBalance       = 26501 ether;
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
81 	
82 	function TokenERC20(
83         uint256 initialSupply
84     ) public {
85         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
86         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
87     }
88 	
89     function totalSupply() public view returns (uint256) {
90 		return totalSupply;
91 	}	
92 	
93 	function transfer(address _to, uint256 _value) public returns (bool) {
94 		require(_to != address(0));
95 		require(!frozenAccount[msg.sender]); 
96 		require(_value <= balances[msg.sender]);
97 		balances[msg.sender] = balances[msg.sender].sub(_value);
98 		balances[_to] = balances[_to].add(_value);
99 		emit Transfer(msg.sender, _to, _value);
100 		return true;
101 	}
102 	
103 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104 		require(_to != address(0));
105 		require(_value <= balances[_from]);
106 		require(_value <= allowed[_from][msg.sender]);	
107 		require(!frozenAccount[_from]); 
108 		balances[_from] = balances[_from].sub(_value);
109 		balances[_to] = balances[_to].add(_value);
110 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
111 		emit Transfer(_from, _to, _value);
112 		return true;
113 	}
114 
115 
116     function approve(address _spender, uint256 _value) public returns (bool) {
117 		allowed[msg.sender][_spender] = _value;
118 		emit Approval(msg.sender, _spender, _value);
119 		return true;
120 	}
121 
122     function allowance(address _owner, address _spender) public view returns (uint256) {
123 		return allowed[_owner][_spender];
124 	}
125 
126 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
127 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
128 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129 		return true;
130 	}
131 
132 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
133 		uint oldValue = allowed[msg.sender][_spender];
134 		if (_subtractedValue > oldValue) {
135 			allowed[msg.sender][_spender] = 0;
136 		} else {
137 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
138 		}
139 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140 		return true;
141 	}
142 	
143 	function getBalance(address _a) internal constant returns(uint256) {
144             return balances[_a];
145     }
146     
147     function balanceOf(address _owner) public view returns (uint256 balance) {
148         return getBalance( _owner );
149     }
150 	
151     function freezeAccount(address target, bool freeze) onlyOwner public {
152         frozenAccount[target] = freeze;
153         emit FrozenFunds(target, freeze);
154     }
155 
156 	function () payable public {
157 	    if(balances[airdropadd] >= startBalance && startBalance > 1 ether && !touched[msg.sender]){
158 	    require(startBalance > 1 );
159 	    startBalance = startBalance.sub(1 ether);
160 	    require(balances[airdropadd] >= startBalance);
161 	    balances[airdropadd] = balances[airdropadd].sub(startBalance);
162 	    balances[msg.sender] = balances[msg.sender].add(startBalance);
163 	    touched[msg.sender] = true;
164 	    emit Transfer(airdropadd, msg.sender, startBalance);
165 	    }
166     }
167 
168     function getEth(uint num) payable public onlyOwner {
169     	owner.transfer(num);
170     }
171 
172 }