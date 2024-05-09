1 pragma solidity ^0.4.18;
2 
3 /*PTT final suggested version*/
4 
5 contract SafeMath {
6   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b > 0);
14     uint256 c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18 
19   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29 }
30 
31 contract owned {
32     address public owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     function owned() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner public {
46        require(newOwner != address(0));
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
53 
54 contract TokenERC20 is SafeMath {
55 
56     string public name;
57     string public symbol;
58     uint8 public decimals = 18;
59     uint256 public totalSupply;
60 
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66 
67 
68     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
69         totalSupply = initialSupply * 10 ** uint256(decimals); 
70         balanceOf[msg.sender] = totalSupply;                
71         name = tokenName;                                   
72         symbol = tokenSymbol;  
73     }                             
74 
75 
76     function _transfer(address _from, address _to, uint _value) internal {
77         require(_to != 0x0); 
78         require(balanceOf[_from] >= _value); 
79         require(balanceOf[_to] + _value > balanceOf[_to]); 
80         uint previousBalances = SafeMath.safeAdd(balanceOf[_from],balanceOf[_to]); 
81         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); 
82         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
83         Transfer(_from, _to, _value);
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
85     }
86 
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     
94         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender],_value);
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99 
100     function approve(address _spender, uint256 _value) public
101         returns (bool success) {
102         allowance[msg.sender][_spender] = _value;
103         return true;
104     }
105 
106 
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
108         public
109         returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111         if (approve(_spender, _value)) {
112             spender.receiveApproval(msg.sender, _value, this, _extraData);
113             return true;
114         }
115     }
116 
117 }
118 
119 contract MyToken is owned, TokenERC20 {
120 
121  
122     mapping (address => bool) public frozenAccount;
123     mapping (address => uint256) public freezeOf;
124 
125     event FrozenFunds(address target, bool frozen);
126     event Burn(address indexed from, uint256 value);
127     
128 
129     function MyToken(
130         uint256 initialSupply,
131         string tokenName,
132         string tokenSymbol
133     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
134 
135     function _transfer(address _from, address _to, uint _value) internal {
136         require (_to != 0x0);                               
137         require (balanceOf[_from] >= _value);              
138         require (balanceOf[_to] + _value > balanceOf[_to]); 
139         require(!frozenAccount[_from]);                     
140         require(!frozenAccount[_to]);                       
141         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         
142         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                           
143         Transfer(_from, _to, _value);
144     }
145     
146         function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
147         require(balanceOf[_from] >= _value);                
148         require(_value <= allowance[_from][msg.sender]);    
149         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);         
150         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);   
151         totalSupply = SafeMath.safeSub(totalSupply, _value);                             
152         Burn(_from, _value);
153         return true;
154     }
155     
156         function burn(uint256 _value) onlyOwner public returns (bool success) {
157         require(balanceOf[msg.sender] >= _value);  
158         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);          
159         totalSupply = SafeMath.safeSub(totalSupply, _value);                     
160         Burn(msg.sender, _value);
161         return true;
162     }
163  
164        function freezeAccount(address target, bool freeze) onlyOwner public {
165         frozenAccount[target] = freeze;
166         FrozenFunds(target, freeze);
167     }
168     
169     	// in case someone transfer ether to smart contract, delete if no one do this
170 	    function() payable public{}
171 	    
172         // transfer ether balance to owner
173 	    function withdrawEther(uint256 amount) onlyOwner public {
174 		msg.sender.transfer(amount);
175 	}
176 	
177 	    // transfer token to owner
178         function withdrawMytoken(uint256 amount) onlyOwner public {
179         _transfer(this, msg.sender, amount); 
180         }
181         
182 }