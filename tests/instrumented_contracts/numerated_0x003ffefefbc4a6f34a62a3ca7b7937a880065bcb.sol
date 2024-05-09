1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     address public manager;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     modifier onlyManager {
17         require(msg.sender == manager);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 
25     function setManager(address newManager) onlyOwner public {
26         manager = newManager;
27     }
28 }
29 
30 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
31 
32 contract TokenERC20 {
33     string public name = "Robot Trading Token";
34     string public detail = "Robot Trading token ERC20";
35     string public symbol ="RTD";
36     uint8 public decimals = 18;
37     uint256 public totalSupply = 0;
38     address public owner;
39     address[] public owners;
40 
41     mapping (address => bool) ownerAppended;
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44     mapping (address => bool) public frozenAccount;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48     event Burn(address indexed from, uint256 value);
49     event FrozenFunds(address target, bool frozen);
50     event AirDropCoin(address target, uint256 token, uint256 rate, uint256 amount);
51     event AirDropToken(address token_address, address target, uint256 token, uint256 rate, uint256 amount);
52 
53     constructor() public {}
54 
55     function totalSupply() public view returns (uint256) {
56         return totalSupply;
57     }
58 
59     function getOwner(uint index) public view returns (address, uint256) {
60         return (owners[index], balanceOf[owners[index]]);
61     }
62 
63     function getOwnerCount() public view returns (uint) {
64         return owners.length;
65     }
66 
67     function _transfer(address _from, address _to, uint _value) internal {
68         require(_to != 0x0);
69         require(balanceOf[_from] >= _value);
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         require(!frozenAccount[_from]);
72         require(!frozenAccount[_to]);
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         balanceOf[_from] -= _value;
75         balanceOf[_to] += _value;
76         if(!ownerAppended[_to]) {
77             ownerAppended[_to] = true;
78             owners.push(_to);
79         }
80 
81         emit Transfer(_from, _to, _value);
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         _transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender]);
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function approve(address _spender, uint256 _value) public
98         returns (bool success) {
99         allowance[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105         public
106         returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, this, _extraData);
110             return true;
111         }
112     }
113 
114     function burn(uint256 _value) public returns (bool success) {
115         require(balanceOf[msg.sender] >= _value);
116         balanceOf[msg.sender] -= _value;
117         totalSupply -= _value;
118         emit Burn(msg.sender, _value);
119         return true;
120     }
121 
122     function burnFrom(address _from, uint256 _value) public returns (bool success) {
123         require(balanceOf[_from] >= _value);
124         require(_value <= allowance[_from][msg.sender]);
125         balanceOf[_from] -= _value;
126         allowance[_from][msg.sender] -= _value;
127         totalSupply -= _value;
128         emit Burn(_from, _value);
129         return true;
130     }
131 }
132 
133 contract Coin{
134   function transfer(address to, uint value) public returns (bool);
135 }
136 
137 contract Token is owned, TokenERC20 {
138     address public ico_address;
139     address public old_address;
140     address public app_address;
141 
142     constructor() public {
143         owner = msg.sender;
144     }
145 
146     function setDetail(string tokenDetail) onlyOwner public {
147         detail = tokenDetail;
148     }
149 
150     function() payable public {}
151 
152     function setApp(address _app_address) onlyOwner public {
153         app_address = _app_address;
154     }
155 
156     function importFromOld(address _ico_address, address _old_address, address[] _to, uint256[] _value) onlyOwner public {
157         ico_address = _ico_address;
158         old_address = _old_address;
159         for (uint256 i = 0; i < _to.length; i++) {
160             balanceOf[_to[i]] += _value[i] * 10 ** uint256(12);
161             totalSupply += _value[i] * 10 ** uint256(12);
162             if(!ownerAppended[_to[i]]) {
163                 ownerAppended[_to[i]] = true;
164                 owners.push(_to[i]);
165             }
166             emit Transfer(old_address, _to[i], _value[i] * 10 ** uint256(12));
167         }
168     }
169 
170     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
171         balanceOf[target] += mintedAmount;
172         totalSupply += mintedAmount;
173 
174         if(!ownerAppended[target]) {
175             ownerAppended[target] = true;
176             owners.push(target);
177         }
178 
179         emit Transfer(0, this, mintedAmount);
180         emit Transfer(this, target, mintedAmount);
181     }
182 
183     function freezeAccount(address target, bool freeze) onlyOwner public {
184         frozenAccount[target] = freeze;
185         emit FrozenFunds(target, freeze);
186     }
187 
188     function withdrawEther() onlyOwner public {
189         manager.transfer(address(this).balance);
190     }
191 
192     function withdrawToken(address _tokenAddr,uint256 _value) onlyOwner public {
193         assert(Coin(_tokenAddr).transfer(owner, _value) == true);
194     }
195 
196     function airDropCoin(uint256 _value)  onlyOwner public {
197         for (uint256 i = 0; i < owners.length; i++) {
198             address(owners[i]).transfer(balanceOf[owners[i]]/_value);
199             emit AirDropCoin(address(owners[i]), balanceOf[owners[i]], _value, (balanceOf[owners[i]]/_value));
200         }
201     }
202 
203     function airDropToken(address _tokenAddr,uint256 _value)  onlyOwner public {
204         for (uint256 i = 0; i < owners.length; i++) {
205              assert((Coin(_tokenAddr).transfer(address(owners[i]), balanceOf[owners[i]] / _value)) == true);
206              emit AirDropToken(address(_tokenAddr), address(owners[i]), balanceOf[owners[i]], _value, (balanceOf[owners[i]]/_value));
207         }
208     }
209 }