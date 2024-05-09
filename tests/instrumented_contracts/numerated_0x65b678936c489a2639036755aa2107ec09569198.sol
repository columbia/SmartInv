1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9 
10     uint256 c = a * b;
11     require(c / a == b);
12 
13     return c;
14   }
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     require(b > 0); 
17     uint256 c = a / b;
18 
19     return c;
20   }
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b <= a);
23     uint256 c = a - b;
24 
25     return c;
26   }
27   
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     require(c >= a);
31 
32     return c;
33   }
34   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b != 0);
36     return a % b;
37   }
38 }
39 
40 contract owned {
41     address public owner;
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner public {
53         owner = newOwner;
54     }
55 }
56 
57 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
58 
59 contract TokenERC20 is owned{
60     using SafeMath for uint256;
61     string public name = "ITEN";
62     string public symbol = "ITEN";
63     uint8 public decimals = 18;
64     uint256 public totalSupply = 500000000000000000000000000;
65     bool public released = true;
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70     event Burn(address indexed from, uint256 value);
71 
72     
73     constructor(
74         uint256 initialSupply,
75         string tokenName,
76         string tokenSymbol
77     ) public {
78         totalSupply = initialSupply * 10 ** uint256(decimals);  
79         balanceOf[msg.sender] = 0;                
80         name = "ITEN";                                  
81         symbol = "ITEN";                              
82     }
83 
84     function release() public onlyOwner{
85       require (owner == msg.sender);
86       released = !released;
87     }
88 
89     modifier onlyReleased() {
90       require(released);
91       _;
92     }
93 
94     function _transfer(address _from, address _to, uint _value) internal onlyReleased {
95         require(_to != 0x0);
96         require(balanceOf[_from] >= _value);
97         require(balanceOf[_to] + _value > balanceOf[_to]);
98         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
99         balanceOf[_from] = balanceOf[_from].sub(_value);
100         balanceOf[_to] = balanceOf[_to].add(_value);
101         emit Transfer(_from, _to, _value);
102         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
103     }
104 
105     function approve(address _spender, uint256 _value) public onlyReleased
106         returns (bool success) {
107         require(_spender != address(0));
108 
109         allowance[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113     
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
115         public onlyReleased
116         returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, this, _extraData);
120             return true;
121         }
122     }
123 
124     function transfer(address _to, uint256 _value) public onlyReleased returns (bool success) {
125         _transfer(msg.sender, _to, _value);
126         return true;
127     }
128 
129  
130     function transferFrom(address _from, address _to, uint256 _value) public onlyReleased returns (bool success) {
131         require(_value <= allowance[_from][msg.sender]); 
132         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
133         _transfer(_from, _to, _value);
134         return true;
135     }
136 
137 
138     function burn(uint256 _value) public onlyReleased returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   
140         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);           
141         totalSupply = totalSupply.sub(_value);                     
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145     
146     function burnFrom(address _from, uint256 _value) public onlyReleased returns (bool success) {
147         require(balanceOf[_from] >= _value);                
148         require(_value <= allowance[_from][msg.sender]);    
149         balanceOf[_from] = balanceOf[_from].sub(_value);                         
150         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             
151         totalSupply = totalSupply.sub(_value);                    
152         emit Burn(_from, _value);
153         return true;
154     }
155 }
156 
157 
158 contract ITEN is owned, TokenERC20 {
159 
160     mapping (address => bool) public frozenAccount;
161     event FrozenFunds(address target, bool frozen);
162     constructor(
163         uint256 initialSupply,
164         string tokenName,
165         string tokenSymbol
166     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
167     }
168 
169       function _transfer(address _from, address _to, uint _value) internal onlyReleased {
170         require (_to != 0x0);                               
171         require (balanceOf[_from] >= _value);               
172         require (balanceOf[_to] + _value >= balanceOf[_to]); 
173         require(!frozenAccount[_from]);                     
174         require(!frozenAccount[_to]);                       
175         balanceOf[_from] = balanceOf[_from].sub(_value);       
176         balanceOf[_to] = balanceOf[_to].add(_value);   
177         emit Transfer(_from, _to, _value);
178     }
179 
180     
181     /// mintedAmount 1 0x18 = 1.000000000000000000
182     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
183         require (mintedAmount > 0);
184         totalSupply = totalSupply.add(mintedAmount);
185         balanceOf[target] = balanceOf[target].add(mintedAmount);
186         emit Transfer(0, this, mintedAmount);
187         emit Transfer(this, target, mintedAmount);
188     }
189 
190     function freezeAccount(address target, bool freeze) onlyOwner public {
191         frozenAccount[target] = freeze;
192         emit FrozenFunds(target, freeze);
193     }
194 
195 }