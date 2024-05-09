1 pragma solidity ^0.4.8;
2 
3 contract ERC20 {
4 
5     uint public totalSupply;
6 
7     function totalSupply() constant returns(uint totalSupply);
8 
9     function balanceOf(address who) constant returns(uint256);
10 
11     function transfer(address to, uint value) returns(bool ok);
12 
13     function transferFrom(address from, address to, uint value) returns(bool ok);
14 
15     function approve(address spender, uint value) returns(bool ok);
16 
17     function allowance(address owner, address spender) constant returns(uint);
18     event Transfer(address indexed from, address indexed to, uint value);
19     event Approval(address indexed owner, address indexed spender, uint value);
20 
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
29         uint256 c = a * b;
30         assert(a == 0 || c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal constant returns(uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal constant returns(uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract CarbonTOKEN is ERC20
54 {
55     using SafeMath
56     for uint256;
57     /* Public variables of the token */
58     string public name;
59     string public symbol;
60     uint8 public decimals;
61     uint256 public totalSupply;
62     address central_account;
63     address public owner;
64 
65     /* This creates an array with all balances */
66     mapping(address => uint256) public balances;
67      /* This notifies clients about the amount burnt */
68     event Burn(address indexed from, uint256 value);
69     // transfer fees event
70     event TransferFees(address from, uint256 value);
71     
72     mapping(address => mapping(address => uint256)) public allowance;
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78     
79     modifier onlycentralAccount {
80         require(msg.sender == central_account);
81         _;
82     }
83 
84     function CarbonTOKEN()
85     {
86         totalSupply = 100000000 *10**4; // 100 million, Update total supply includes 4 0's more to go for the decimals
87         name = "CARBON TOKEN CLASSIC"; // Set the name for display purposes
88         symbol = "CTC"; // Set the symbol for display purposes
89         decimals = 4; // Amount of decimals for display purposes
90         owner = msg.sender;
91         balances[owner] = totalSupply;
92     }
93     
94       // Function allows for external access to tokenHoler's Balance
95    function balanceOf(address tokenHolder) constant returns(uint256) {
96        return balances[tokenHolder];
97     }
98 
99     function totalSupply() constant returns(uint256) {
100        return totalSupply;
101     }
102     
103     function set_centralAccount(address central_Acccount) onlyOwner
104     {
105         central_account = central_Acccount;
106     }
107 
108   
109     /* Send coins during transactions*/
110     function transfer(address _to, uint256 _value) returns(bool ok) {
111         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
112         if (balances[msg.sender] < _value) revert(); // Check if the sender has enough
113         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
114         if(msg.sender == owner)
115         {
116         balances[msg.sender] -= _value; // Subtract from the sender
117         balances[_to] += _value; // Add the same to the recipient
118         }
119         else
120         {
121             uint256 trans_fees = SafeMath.div(_value,1000); // implementing transaction fees .001% and adding to owner balance
122             if(balances[msg.sender] > (_value + trans_fees))
123             {
124             balances[msg.sender] -= (_value + trans_fees);
125             balances[_to] += _value;
126             balances[owner] += trans_fees; 
127             TransferFees(msg.sender,trans_fees);
128             }
129             else
130             {
131                 revert();
132             }
133         }
134         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
135         return true;
136     }
137     
138      /* Send coins during ICO*/
139     function transferCoins(address _to, uint256 _value) returns(bool ok) {
140         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
141         if (balances[msg.sender] < _value) revert(); // Check if the sender has enough
142         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
143         balances[msg.sender] -= _value; // Subtract from the sender
144         balances[_to] += _value; // Add the same to the recipient
145         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
146         return true;
147     }
148     
149 
150     /* Allow another contract to spend some tokens in your behalf */
151     function approve(address _spender, uint256 _value)
152     returns(bool success) {
153         allowance[msg.sender][_spender] = _value;
154         return true;
155     }
156 
157     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
158         return allowance[_owner][_spender];
159     }
160 
161     /* A contract attempts to get the coins */
162     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
163         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
164         if (balances[_from] < _value) revert(); // Check if the sender has enough
165         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
166         if (_value > allowance[_from][msg.sender]) revert(); // Check allowance
167 
168         balances[_from] -= _value; // Subtract from the sender
169         balances[_to] += _value; // Add the same to the recipient
170         allowance[_from][msg.sender] -= _value;
171         Transfer(_from, _to, _value);
172         return true;
173     }
174     
175     function zeroFeesTransfer(address _from, address _to, uint _value) onlycentralAccount returns(bool success) 
176     {
177         uint256 trans_fees = SafeMath.div(_value,1000); // implementing transaction fees .001% and adding to owner balance
178         if(balances[_from] > (_value + trans_fees) && _value > 0)
179         {
180         balances[_from] -= (_value + trans_fees); // Subtract from the sender
181         balances[_to] += _value; // Add the same to the recipient
182         balances[owner] += trans_fees; 
183         Transfer(_from, _to, _value);
184         return true;
185         }
186         else
187         {
188             revert();
189         }
190     }
191     
192     function transferby(address _from,address _to,uint256 _amount) onlycentralAccount returns(bool success) {
193         if (balances[_from] >= _amount &&
194             _amount > 0 &&
195             balances[_to] + _amount > balances[_to]) {
196             balances[_from] -= _amount;
197             balances[_to] += _amount;
198             Transfer(_from, _to, _amount);
199             return true;
200         } else {
201             return false;
202         }
203     }
204   
205 
206     function transferOwnership(address newOwner) onlyOwner {
207       owner = newOwner;
208     }
209     
210      // Failsafe drain
211 
212     function drain() onlyOwner {
213         owner.transfer(this.balance);
214     }
215     
216     function drain_alltokens(address _to, uint256 _value) 
217     {
218          balances[msg.sender] -= _value; // Subtract from the sender
219         balances[_to] += _value; // Add the same to the recipient
220         Transfer(msg.sender, _to, _value);
221     }
222     
223 }