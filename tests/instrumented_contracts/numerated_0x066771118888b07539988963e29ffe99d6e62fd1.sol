1 pragma solidity ^0.4.25;
2 
3 
4 contract Owner{
5     
6     address public owner;
7     
8     uint public ownerIncome;
9     
10     constructor()public {
11         owner=msg.sender;
12     }
13     
14     modifier onlyOwner(){
15         
16         require(msg.sender == owner,"you are not the owner");
17         _;
18     }
19     
20     function transferOwnership(address newOwner)public onlyOwner{
21      
22         owner = newOwner;
23     }
24     
25     function ownerWithDraw()public onlyOwner{
26         owner.transfer(ownerIncome);
27         ownerIncome=0;
28     }
29 }
30 
31 interface tokenRecipient { 
32     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
33     function receiveApprovalStr(address _from, uint256 _value, address _token, string _extraData) external;
34     function toMakeSellOrder(address _from, uint256 _value, address _token, uint _amtMin,uint _amtMax,uint _price) external;
35     function toModifySellOrder(address _from, uint256 _value, address _token, uint _id,uint _amtMin,uint _amtMax,uint _price) external;
36     function toTakeBuyOrder(address _from, uint256 _value, address _token, uint _id,uint _takeAmt) external;
37     function toRegisteName(address _from, uint256 _value, address _token, string _name) external;
38     function toBuyName(address _from, uint256 _value, address _token, string _name) external;
39     function toGetPaidContent(address _from, uint256 _value, address _token, uint _id) external;
40 }
41 
42 contract TokenERC20 is Owner{
43     // Public variables of the token
44     string public name="DASS";
45     string public symbol="DASS";
46     uint8 public decimals = 18;
47     // 18 decimals is the strongly suggested default, avoid changing it
48     uint256 public totalSupply=10000000000 * 10 ** uint256(decimals);
49 
50     // This creates an array with all balances
51     mapping (address => uint256) public balanceOf;
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 
58     event Burn(address indexed from, uint256 value);
59     
60     /**
61      * Constructor function
62      *
63      * Initializes contract with initial supply tokens to the creator of the contract
64      */
65     constructor() public {
66         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
67     }
68     
69     function _transfer(address _from, address _to, uint _value) internal {
70         require(_to != address(0x0),"address _to must not be 0x0");
71         require(balanceOf[_from] >= _value,"balanceOf _from is not enough");
72         // Check for overflows
73         require(balanceOf[_to] + _value >= balanceOf[_to],"check overflows fail");
74         // Save this for an assertion in the future
75         uint previousBalances = balanceOf[_from] + balanceOf[_to];
76         balanceOf[_from] -= _value;
77         balanceOf[_to] += _value;
78         emit Transfer(_from, _to, _value);
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     
84     function transfer(address _to, uint256 _value) public returns (bool success) {
85         _transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender],"_value exceed allowance");     // Check allowance
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     
98     function approve(address _spender, uint256 _value) public
99         returns (bool success) {
100         require(balanceOf[msg.sender] >= _value,"balanceOf msg.sender is not enough");
101         allowance[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
108         public
109         returns (bool success) {
110         tokenRecipient spender = tokenRecipient(_spender);
111         if (approve(_spender, _value)) {
112             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
113             return true;
114         }
115     }
116     
117     function approveAndCallStr(address _spender, uint256 _value, string _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApprovalStr(msg.sender, _value, address(this), _extraData);
123             return true;
124         }
125     }
126 
127     
128     function burn(uint256 _value) public returns (bool success) {
129         require(balanceOf[msg.sender] >= _value,"balanceOf is not enough");   // Check if the sender has enough
130         balanceOf[msg.sender] -= _value;            // Subtract from the sender
131         totalSupply -= _value;                      // Updates totalSupply
132         emit Burn(msg.sender, _value);
133         return true;
134     }
135 
136     
137     function burnFrom(address _from, uint256 _value) public returns (bool success) {
138         require(balanceOf[_from] >= _value,"balanceOf is not enough");                // Check if the targeted balance is enough
139         require(_value <= allowance[_from][msg.sender],"allowance is not enough");    // Check allowance
140         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
141         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
142         totalSupply -= _value;                              // Update totalSupply
143         emit Burn(_from, _value);
144         return true;
145     }
146     
147     function makeSellOrder(address _spender, uint256 _value,uint _amtMin,uint _amtMax,uint _price)
148         public
149         returns (bool success) {
150         tokenRecipient spender = tokenRecipient(_spender);
151         if (approve(_spender, _value)) {
152             spender.toMakeSellOrder(msg.sender, _value, address(this), _amtMin,_amtMax,_price);
153             return true;
154         }
155     }
156     
157     
158     function modifySellOrder(address _spender, uint256 _value,uint _id,uint _amtMin,uint _amtMax,uint _price)
159         public
160         returns (bool success) {
161         tokenRecipient spender = tokenRecipient(_spender);
162         if (approve(_spender, _value)) {
163             spender.toModifySellOrder(msg.sender, _value, address(this),_id, _amtMin,_amtMax,_price);
164             return true;
165         }
166     }
167     
168     function takeBuyOrder(address _spender, uint256 _value,uint _id,uint _takeAmt)
169         public
170         returns (bool success) {
171         tokenRecipient spender = tokenRecipient(_spender);
172         if (approve(_spender, _value)) {
173             spender.toTakeBuyOrder(msg.sender, _value, address(this),_id, _takeAmt);
174             return true;
175         }
176     }
177     
178     function registeName(address _spender, uint256 _value,string _name)
179         public
180         returns (bool success) {
181         tokenRecipient spender = tokenRecipient(_spender);
182         if (approve(_spender, _value)) {
183             spender.toRegisteName(msg.sender, _value, address(this),_name);
184             return true;
185         }
186     }
187     
188     function buyName(address _spender, uint256 _value,string _name)
189         public
190         returns (bool success) {
191         tokenRecipient spender = tokenRecipient(_spender);
192         if (approve(_spender, _value)) {
193             spender.toBuyName(msg.sender, _value, address(this),_name);
194             return true;
195         }
196     }
197     
198     function getPaidContent(address _spender, uint256 _value,uint _id)
199         public
200         returns (bool success) {
201         tokenRecipient spender = tokenRecipient(_spender);
202         if (approve(_spender, _value)) {
203             spender.toGetPaidContent(msg.sender, _value, address(this),_id);
204             return true;
205         }
206     }
207     
208 }