1 //Every CocktailBar needs some Peanuts ; )
2 //This is your official invitation to the Cocktailbar Grand opening,
3 //Come join us: @cocktailbar_discussion
4 //
5 //Sincerely, Mr. Martini
6 
7 pragma solidity ^0.5.9;
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31   
32       function ceil(uint a, uint m) internal pure returns (uint r) {
33         return (a + m - 1) / m * m;
34     }
35 
36 }
37 
38 contract Owned {
39     modifier onlyOwner() {
40         require(msg.sender==owner);
41         _;
42     }
43     address payable owner;
44     address payable newOwner;
45     function changeOwner(address payable _newOwner) public onlyOwner {
46         require(_newOwner!=address(0));
47         newOwner = _newOwner;
48     }
49     function acceptOwnership() public {
50         if (msg.sender==newOwner) {
51             owner = newOwner;
52         }
53     }
54 }
55 
56 contract ERC20 {
57     uint256 public totalSupply;
58     function balanceOf(address _owner) view public  returns (uint256 balance);
59     function transfer(address _to, uint256 _value) public  returns (bool success);
60     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
61     function approve(address _spender, uint256 _value) public returns (bool success);
62     function allowance(address _owner, address _spender) view public  returns (uint256 remaining);
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 }
66 
67 contract Token is Owned,  ERC20 {
68     using SafeMath for uint256;
69     string public symbol;
70     string public name;
71     uint8 public decimals;
72     mapping (address=>uint256) balances;
73     mapping (address=>mapping (address=>uint256)) allowed;
74     
75     uint256 burn_amount=0;
76     event Burn(address burner, uint256 _value);
77     event BurntOut(address burner, uint256 _value);
78     
79     function balanceOf(address _owner) view public   returns (uint256 balance) {return balances[_owner];}
80     
81     function transfer(address _to, uint256 _amount) public   returns (bool success) {
82         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
83 
84 //Herein lies the magic of Peanuts; A 5% Testa Waste (BURN) //function reduces the supply of each transaction by 5%.This repeats //until there is but 100 PEANUTS left.
85 
86         uint256 amount = fivePercent(_amount); 
87         burn(msg.sender,amount);
88         if(totalSupply > 100000000000000000000)
89         {
90             
91         uint256 amountToTransfer = _amount.sub(amount);
92         balances[msg.sender]-=amountToTransfer;
93         balances[_to]+=amountToTransfer;
94         
95         emit Transfer(msg.sender,_to,amountToTransfer);
96         return true;
97         }
98         else{
99          
100         balances[msg.sender]-=_amount;
101         balances[_to]+=_amount;
102         emit Transfer(msg.sender,_to,_amount);
103         return true;
104         }
105         
106     }
107   
108   function transferFromOwner(address _to, uint256 _amount) public   returns (bool success) {
109         require (balances[owner]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
110        
111         uint256 amount = fivePercent(_amount);
112         burn(owner, amount);
113         
114         if(totalSupply > 100000000000000000000)
115         {
116         uint256 amountToTransfer = _amount.sub(amount);
117         balances[owner]-=amountToTransfer;
118         balances[_to]+=amountToTransfer;
119            emit Transfer(owner,_to,amountToTransfer);
120         }else
121         {
122         
123         balances[owner]-=_amount;
124         balances[_to]+=_amount;
125            emit Transfer(owner,_to,_amount);
126         }
127  return true;
128     }
129   
130     function transferFrom(address _from,address _to,uint256 _amount) public   returns (bool success) {
131         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
132         uint256 amount = fivePercent(_amount);
133        
134         burn(_from, amount);
135        
136         if(totalSupply > 100000000000000000000)
137         {
138         uint256 amountToTransfer = _amount.sub(amount);
139         balances[_from]-=amountToTransfer;
140         allowed[_from][msg.sender]-=amountToTransfer;
141         balances[_to]+=amountToTransfer;
142         emit Transfer(_from, _to, amountToTransfer);
143         }
144         else
145         {
146            
147         balances[_from]-=_amount;
148         allowed[_from][msg.sender]-=_amount;
149         balances[_to]+=_amount;
150         emit Transfer(_from, _to, _amount);
151         }
152        
153         return true;
154     }
155   
156     function approve(address _spender, uint256 _amount) public   returns (bool success) {
157         allowed[msg.sender][_spender]=_amount;
158         emit Approval(msg.sender, _spender, _amount);
159         return true;
160     }
161     
162     function allowance(address _owner, address _spender) view public   returns (uint256 remaining) {
163       return allowed[_owner][_spender];
164     }
165     
166     
167     function burn(address _from, uint256 _value) internal  {
168     
169         if(totalSupply > 100000000000000000000)
170         {
171             
172             uint256 burnlimit = totalSupply.sub(_value);
173         
174         
175         if(burnlimit > 100000000000000000000)    
176         {
177         balances[_from] =balances[_from].sub(_value);  // Subtract from the sender
178         totalSupply =totalSupply.sub(_value);  
179         burn_amount = burn_amount.add(_value);
180         // Updates totalSupply
181         emit Burn(_from, _value);
182         }else
183         {
184              emit BurntOut(msg.sender, _value);
185         }
186             
187         }else
188         {
189             emit BurntOut(msg.sender, _value);
190         }
191         
192         
193         
194     }
195         function fivePercent(uint256 _tokens) private pure returns (uint256){
196         uint256 roundValue = _tokens.ceil(100);
197         uint fivepercentofTokens = roundValue.mul(500).div(100 * 10**uint(2));
198         return fivepercentofTokens;
199     }
200 }
201 
202 contract PEANUTS is Token{
203     using SafeMath for uint256;
204     constructor() public{
205         symbol = "PEANUTS";
206         name = "PEANUTS";
207         decimals = 18;
208         totalSupply = 2500000000000000000000; //2500 
209         
210         owner = msg.sender;
211         balances[owner] = totalSupply;
212         
213         
214     }
215 
216     function () payable external {
217         require(msg.value>0);
218         owner.transfer(msg.value);
219     }
220     
221     
222     
223     
224 }