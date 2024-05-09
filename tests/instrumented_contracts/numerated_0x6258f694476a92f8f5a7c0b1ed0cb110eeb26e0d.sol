1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     //转移所有权
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     
28     uint256 public totalSupply;
29 
30   
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35   
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38    
39     event Burn(address indexed from, uint256 value);
40 
41  
42     function TokenERC20(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  
48         balanceOf[msg.sender] = totalSupply;                
49         name = tokenName;                                  
50         symbol = tokenSymbol;                              
51     }
52 
53    //内部函数，转币
54     function _transfer(address _from, address _to, uint _value) internal {
55         
56         require(_to != 0x0);
57        
58         require(balanceOf[_from] >= _value);
59         
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         
64         balanceOf[_from] -= _value;
65         
66         balanceOf[_to] += _value;
67         emit Transfer(_from, _to, _value);
68         
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     //使用授权的币
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_value <= allowance[_from][msg.sender]);    
81         _transfer(_from, _to, _value);
82         return true;
83     }
84 
85    //授权
86     function approve(address _spender, uint256 _value) public
87         returns (bool success) {
88         allowance[msg.sender][_spender] = _value;
89         emit Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93 
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
95         public
96         returns (bool success) {
97         tokenRecipient spender = tokenRecipient(_spender);
98         if (approve(_spender, _value)) {
99             spender.receiveApproval(msg.sender, _value, this, _extraData);
100             return true;
101         }
102     }
103 
104     //销毁
105     function burn(uint256 _value) public returns (bool success) {
106         require(balanceOf[msg.sender] >= _value);  
107         balanceOf[msg.sender] -= _value;            
108         totalSupply -= _value;                     
109         emit Burn(msg.sender, _value);
110         return true;
111     }
112 
113   	//销毁授权的币
114     function burnFrom(address _from, uint256 _value) public returns (bool success) {
115         require(balanceOf[_from] >= _value);               
116         require(_value <= allowance[_from][msg.sender]);   
117         balanceOf[_from] -= _value;                        
118         allowance[_from][msg.sender] -= _value;           
119         totalSupply -= _value;                            
120         emit Burn(_from, _value);
121         return true;
122     }
123 }
124 
125 
126 
127 contract MyAdvancedToken is owned, TokenERC20 {
128 
129     uint256 public sellPrice;
130     uint256 public buyPrice;
131 
132     mapping (address => bool) public frozenAccount;
133     mapping (address => uint) public lockedAmount;
134     
135     event FrozenFunds(address target, bool frozen);
136     event Award(address to,uint amount);
137     event Punish(address violator,address victim,uint amount);
138     event LockToken(address target, uint256 amount,uint lockPeriod);
139     event OwnerUnlock(address from,uint256 amount);
140     function MyAdvancedToken(
141         uint256 initialSupply,
142         string tokenName,
143         string tokenSymbol
144     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
145 
146 	//转币
147     function _transfer(address _from, address _to, uint _value) internal {
148         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
149         require (balanceOf[_from] >= _value);               // Check if the sender has enough
150         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
151         require(!frozenAccount[_from]);                     // Check if sender is frozen
152         require(!frozenAccount[_to]);                       // Check if recipient is frozen
153         balanceOf[_from] -= _value;                         // Subtract from the sender
154         balanceOf[_to] += _value;                           // Add the same to the recipient
155         emit Transfer(_from, _to, _value);
156     }
157 
158    //增发
159     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
160         balanceOf[target] += mintedAmount;
161         totalSupply += mintedAmount;
162         emit Transfer(0, this, mintedAmount);
163         emit Transfer(this, target, mintedAmount);
164     }
165     //冻结解冻
166     function freezeAccount(address target, bool freeze) onlyOwner public {
167         frozenAccount[target] = freeze;
168         emit FrozenFunds(target, freeze);
169     }
170     //设置私募价格
171     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
172         sellPrice = newSellPrice;
173         buyPrice = newBuyPrice;
174     }
175 
176    //私募
177     function buy() payable public {
178         uint amount = msg.value / buyPrice;               
179         _transfer(this, msg.sender, amount);  
180         if(!owner.send(msg.value)){
181             revert();
182         }            
183     }
184 
185     //卖给合约
186     function sell(uint256 amount) public {
187         address myAddress = this;
188         require(myAddress.balance >= amount * sellPrice);      
189         _transfer(msg.sender, this, amount);              
190         msg.sender.transfer(amount * sellPrice);          
191     }
192     //奖励
193     function award(address user,uint256 amount) onlyOwner public
194     {
195       user.transfer(amount);
196       emit Award(user,amount);
197     }
198     //批量转账
199     function transferMultiAddress(address[] _recivers, uint256[] _values) public onlyOwner {
200         require (_recivers.length == _values.length);
201         address receiver;
202         uint256 value;
203         for(uint256 i = 0; i < _recivers.length ; i++){
204             receiver = _recivers[i];
205             value = _values[i];
206             _transfer(msg.sender,receiver,value);
207              emit Transfer(msg.sender,receiver,value);
208         }
209     }
210 
211     //惩罚
212     function punish(address violator,address victim,uint amount) public onlyOwner
213     {
214       _transfer(violator,victim,amount);
215       emit Punish(violator,victim,amount);
216     }
217 
218     //锁仓
219      function lockToken (address target,uint256 lockAmount,uint lockPeriod) onlyOwner public returns(bool res)
220     {
221         require(lockAmount>0);
222         require(balanceOf[target] >= lockAmount);
223         balanceOf[target] -= lockAmount;
224         lockedAmount[target] += lockAmount;
225         emit LockToken(target, lockAmount,lockPeriod);
226         return true;
227     }
228 
229     //解锁
230      function ownerUnlock (address target, uint256 amount) onlyOwner public returns(bool res) {
231         require(lockedAmount[target] >= amount);
232         balanceOf[target] += amount;
233         lockedAmount[target] -= amount;
234         emit OwnerUnlock(target,amount);
235         return true;
236     }
237     
238 }