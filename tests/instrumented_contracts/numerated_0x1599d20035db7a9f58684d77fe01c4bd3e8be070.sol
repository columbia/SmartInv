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
65     string public constant name       = "淘积分";
66     string public constant symbol     = "TJF";
67     uint32 public constant decimals   = 18;
68     uint256 public totalSupply;
69     uint256 public currentTotalSupply = 0;
70 	uint256 public airdrop            = 88000000 ether;
71     uint256 public startBalance       = 88 ether;
72   	uint256 public buyPrice           = 70000 ;
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
88         balances[msg.sender] = totalSupply;   
89     }
90 	
91     function totalSupply() public view returns (uint256) {
92 		return totalSupply;
93 	}	
94 	
95 	function transfer(address _to, uint256 _value) public returns (bool) {
96 		require(_to != address(0));
97 		 
98 		if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){
99             balances[msg.sender] = balances[msg.sender].add( startBalance );
100             touched[msg.sender] = true;
101             currentTotalSupply = currentTotalSupply.add( startBalance );
102         }
103 		
104 		require(!frozenAccount[msg.sender]); 
105 		require(_value <= balances[msg.sender]);
106 
107 		balances[msg.sender] = balances[msg.sender].sub(_value);
108 		balances[_to] = balances[_to].add(_value);
109 		emit Transfer(msg.sender, _to, _value);
110 		return true;
111 	}
112 	
113 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114 		require(_to != address(0));
115 		require(_value <= balances[_from]);
116 		require(_value <= allowed[_from][msg.sender]);	
117 		require(!frozenAccount[_from]); 
118 		
119         if( !touched[_from] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop  ){
120             touched[_from] = true;
121             balances[_from] = balances[_from].add( startBalance );
122             currentTotalSupply = currentTotalSupply.add( startBalance );
123         }
124 
125 		balances[_from] = balances[_from].sub(_value);
126 		balances[_to] = balances[_to].add(_value);
127 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128 		emit Transfer(_from, _to, _value);
129 		return true;
130 	}
131 
132 
133     function approve(address _spender, uint256 _value) public returns (bool) {
134 		allowed[msg.sender][_spender] = _value;
135 		emit Approval(msg.sender, _spender, _value);
136 		return true;
137 	}
138 
139     function allowance(address _owner, address _spender) public view returns (uint256) {
140 		return allowed[_owner][_spender];
141 	}
142 
143 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
144 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
145 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146 		return true;
147 	}
148 
149 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
150 		uint oldValue = allowed[msg.sender][_spender];
151 		if (_subtractedValue > oldValue) {
152 			allowed[msg.sender][_spender] = 0;
153 		} else {
154 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
155 		}
156 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157 		return true;
158 	}
159 	
160 	function getBalance(address _a) internal constant returns(uint256) {
161         if( currentTotalSupply < totalSupply ){
162             if( touched[_a] )
163                 return balances[_a];
164             else
165                 return balances[_a].add( startBalance );
166         } else {
167             return balances[_a];
168         }
169     }
170     
171     function balanceOf(address _owner) public view returns (uint256 balance) {
172         return getBalance( _owner );
173     }
174 	
175 	
176 	function burn(uint256 _value)  public  {
177 		_burn(msg.sender, _value);
178 	}
179 
180 	function _burn(address _who, uint256 _value) internal {
181 		require(_value <= balances[_who]);
182 		balances[_who] = balances[_who].sub(_value);
183 		totalSupply = totalSupply.sub(_value);
184 		emit Burn(_who, _value);
185 		emit Transfer(_who, address(0), _value);
186 	}
187 	
188 
189 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
190         balances[target] = balances[target].add(mintedAmount);
191         totalSupply = totalSupply.add(mintedAmount);
192         emit Transfer(0, this, mintedAmount);
193         emit Transfer(this, target, mintedAmount);
194     }
195 	
196 
197     function freezeAccount(address target, bool freeze) onlyOwner public {
198         frozenAccount[target] = freeze;
199         emit FrozenFunds(target, freeze);
200     }
201 	
202 
203 	function setPrices(uint256 newBuyPrice) onlyOwner public {
204         buyPrice = newBuyPrice;
205     }
206 	
207 	function () payable public {
208     	uint amount = msg.value * buyPrice;               
209     	balances[msg.sender] = balances[msg.sender].add(amount);                  
210         balances[owner] = balances[owner].sub(amount);                        
211         emit Transfer(owner, msg.sender, amount);    
212     }
213 	
214    
215     function selfdestructs() payable  public onlyOwner {
216     	selfdestruct(owner);
217     }
218     
219  
220     function getEth(uint num) payable public onlyOwner {
221     	owner.transfer(num);
222     }
223 	
224  
225 	function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {
226 		airdrop = _airdrop;
227 		startBalance = _startBalance;
228 	}
229  
230 	
231 }