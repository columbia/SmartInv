1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8 
9     uint256 c = a * b;
10     require(c / a == b);
11 
12     return c;
13   }
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     require(b > 0); 
16     uint256 c = a / b;
17 
18     return c;
19   }
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b <= a);
22     uint256 c = a - b;
23 
24     return c;
25   }
26   
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     require(c >= a);
30 
31     return c;
32   }
33   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34     require(b != 0);
35     return a % b;
36   }
37 }
38 
39 contract owned {
40     address public owner;
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     function transferOwnership(address newOwner) onlyOwner public {
52         owner = newOwner;
53     }
54 }
55 
56 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
57 
58 contract TokenERC20 is owned{
59     using SafeMath for uint256;
60 
61     string public name = "Smapi Digital Stock";
62     string public symbol = "SDS";
63     uint8 public decimals = 18;
64     uint256 public totalSupply = 20000000000000000000000000000;
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
80         name = "Smapi Digital Stock";
81         symbol = "SDS";
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
105     function transfer(address _to, uint256 _value) public onlyReleased returns (bool success) {
106         _transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     
111     function approve(address _spender, uint256 _value) public onlyReleased
112         returns (bool success) {
113         require(_spender != address(0));
114 
115         allowance[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119     
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
121         public onlyReleased
122         returns (bool success) {
123         tokenRecipient spender = tokenRecipient(_spender);
124         if (approve(_spender, _value)) {
125             spender.receiveApproval(msg.sender, _value, this, _extraData);
126             return true;
127         }
128     }
129     
130     function transferFrom(address _from, address _to, uint256 _value) public onlyReleased returns (bool success) {
131         require(_value <= allowance[_from][msg.sender]);     // Check allowance
132 
133         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function burn(uint256 _value) public onlyReleased returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
140         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
141         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145 
146     function burnFrom(address _from, uint256 _value) public onlyReleased returns (bool success) {
147         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
148         require(_value <= allowance[_from][msg.sender]);    // Check allowance
149         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
150         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
151         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
152         emit Burn(_from, _value);
153         return true;
154     }
155 }
156 
157 contract SDS is owned, TokenERC20 {
158 
159     mapping (address => bool) public frozenAccount;
160 
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
181     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
182         require (mintedAmount > 0);
183         totalSupply = totalSupply.add(mintedAmount);
184         balanceOf[target] = balanceOf[target].add(mintedAmount);
185         emit Transfer(0, this, mintedAmount);
186         emit Transfer(this, target, mintedAmount);
187     }
188     
189     function freezeAccount(address target, bool freeze) onlyOwner public {
190         frozenAccount[target] = freeze;
191         emit FrozenFunds(target, freeze);
192     }
193 
194 }