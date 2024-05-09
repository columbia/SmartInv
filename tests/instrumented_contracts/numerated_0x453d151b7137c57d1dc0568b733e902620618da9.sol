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
65     string public constant name       = "aubar";
66     string public constant symbol     = "AUB";
67     uint32 public constant decimals   = 18;
68     uint256 public totalSupply;
69     uint256 public currentTotalSupply = 0;
70 	uint256 public airdrop;
71     uint256 public startBalance;
72   	uint256 public buyPrice ;
73 	
74     mapping(address => bool) touched; 
75     mapping(address => uint256) balances;
76 	mapping(address => mapping (address => uint256)) internal allowed;
77 	mapping(address => bool) public frozenAccount;   
78 	
79 	event FrozenFunds(address target, bool frozen);
80 	event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 	event Burn(address indexed burner, uint256 value);   
83 	
84 	function TokenERC20(
85         uint256 initialSupply
86     ) public {
87         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
88         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
89     }
90 	
91     function totalSupply() public view returns (uint256) {
92 		return totalSupply;
93 	}	
94 	
95 	function transfer(address _to, uint256 _value) public returns (bool) {
96 		require(_to != address(0));
97 		require(!frozenAccount[msg.sender]); 
98 		require(_value <= balances[msg.sender]);
99 		balances[msg.sender] = balances[msg.sender].sub(_value);
100 		balances[_to] = balances[_to].add(_value);
101 		emit Transfer(msg.sender, _to, _value);
102 		return true;
103 	}
104 	
105 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106 		require(_to != address(0));
107 		require(_value <= balances[_from]);
108 		require(_value <= allowed[_from][msg.sender]);	
109 		require(!frozenAccount[_from]); 
110 		balances[_from] = balances[_from].sub(_value);
111 		balances[_to] = balances[_to].add(_value);
112 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113 		emit Transfer(_from, _to, _value);
114 		return true;
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
145 	function getBalance(address _a) internal constant returns(uint256) {
146         if( currentTotalSupply < totalSupply ){
147             if( touched[_a] )
148                 return balances[_a];
149             else
150                 return balances[_a].add( startBalance );
151         } else {
152             return balances[_a];
153         }
154     }
155     
156     function balanceOf(address _owner) public view returns (uint256 balance) {
157         return getBalance( _owner );
158     }
159 	
160  
161 	function burn(uint256 _value)  public  {
162 		_burn(msg.sender, _value);
163 	}
164 
165 	function _burn(address _who, uint256 _value) internal {
166 		require(_value <= balances[_who]);
167 		balances[_who] = balances[_who].sub(_value);
168 		totalSupply = totalSupply.sub(_value);
169 		emit Burn(_who, _value);
170 		emit Transfer(_who, address(0), _value);
171 	}
172 	
173  
174 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
175         balances[target] = balances[target].add(mintedAmount);
176         totalSupply = totalSupply.add(mintedAmount);
177         emit Transfer(0, this, mintedAmount);
178         emit Transfer(this, target, mintedAmount);
179     }
180 	
181  
182     function freezeAccount(address target, bool freeze) onlyOwner public {
183         frozenAccount[target] = freeze;
184         emit FrozenFunds(target, freeze);
185     }
186 	
187  
188 
189 	
190 	function () payable public {
191  
192     }
193 	
194  
195     function selfdestructs() payable  public onlyOwner {
196     	selfdestruct(owner);
197     }
198     
199  
200     function getEth(uint num) payable public onlyOwner {
201     	owner.transfer(num);
202     }
203 	
204 
205  
206 	
207 }