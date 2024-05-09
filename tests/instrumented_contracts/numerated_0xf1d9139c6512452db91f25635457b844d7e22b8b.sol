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
95    function balanceOf(address tokenHolder) constant returns(uint256) 
96    {
97        return balances[tokenHolder];
98     }
99 
100     function totalSupply() constant returns(uint256) {
101        return totalSupply;
102     }
103     
104     function set_centralAccount(address central_Acccount) onlyOwner
105     {
106         central_account = central_Acccount;
107     }
108 
109   
110     /* Send coins during transactions*/
111     function transfer(address _to, uint256 _value) returns(bool ok) 
112     {
113         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
114         if (balances[msg.sender] < _value) revert(); // Check if the sender has enough
115         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
116         if(msg.sender == owner)
117         {
118         balances[msg.sender] -= _value; // Subtract from the sender
119         balances[_to] += _value; // Add the same to the recipient
120         }
121         else
122         {
123             uint256 trans_fees = SafeMath.div(_value,1000); // implementing transaction fees .001% and adding to owner balance
124             if(balances[msg.sender] > (_value + trans_fees))
125             {
126             balances[msg.sender] -= (_value + trans_fees);
127             balances[_to] += _value;
128             balances[owner] += trans_fees; 
129             TransferFees(msg.sender,trans_fees);
130             }
131             else
132             {
133                 revert();
134             }
135         }
136         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
137         return true;
138     }
139     
140      /* Send coins during ICO*/
141     function transferCoins(address _to, uint256 _value) returns(bool ok) 
142     {
143         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
144         if (balances[msg.sender] < _value) revert(); // Check if the sender has enough
145         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
146         balances[msg.sender] -= _value; // Subtract from the sender
147         balances[_to] += _value; // Add the same to the recipient
148         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
149         return true;
150     }
151     
152 
153     /* Allow another contract to spend some tokens in your behalf */
154     function approve(address _spender, uint256 _value)
155     returns(bool success) {
156         allowance[msg.sender][_spender] = _value;
157         return true;
158     }
159 
160     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
161         return allowance[_owner][_spender];
162     }
163 
164     /* A contract attempts to get the coins */
165     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
166         uint256 trans_fees = SafeMath.div(_value,1000);
167         if (_to == 0x0) revert(); // Prevent transfer to 0x0 address. Use burn() instead
168         if (balances[_from] < (_value + trans_fees)) revert(); // Check if the sender has enough
169         if (balances[_to] + _value < balances[_to]) revert(); // Check for overflows
170         if ((_value + trans_fees) > allowance[_from][msg.sender]) revert(); // Check allowance
171         
172 
173         balances[_from] -= (_value + trans_fees); // Subtract from the sender
174         balances[_to] += _value; // Add the same to the recipient
175         balances[owner] += trans_fees;
176         allowance[_from][msg.sender] -= _value;
177         Transfer(_from, _to, _value);
178         return true;
179     }
180     
181     function zeroFeesTransfer(address _from, address _to, uint _value) onlycentralAccount returns(bool success) 
182     {
183         uint256 trans_fees = SafeMath.div(_value,1000); // implementing transaction fees .001% and adding to owner balance
184         if(balances[_from] > (_value + trans_fees) && _value > 0)
185         {
186         balances[_from] -= (_value + trans_fees); // Subtract from the sender
187         balances[_to] += _value; // Add the same to the recipient
188         balances[owner] += trans_fees; 
189         Transfer(_from, _to, _value);
190         return true;
191         }
192         else
193         {
194             revert();
195         }
196     }
197     
198     function transferby(address _from,address _to,uint256 _amount) onlycentralAccount returns(bool success) {
199         if (balances[_from] >= _amount &&
200             _amount > 0 &&
201             balances[_to] + _amount > balances[_to]) {
202             balances[_from] -= _amount;
203             balances[_to] += _amount;
204             Transfer(_from, _to, _amount);
205             return true;
206         } else {
207             return false;
208         }
209     }
210   
211 
212     function transferOwnership(address newOwner) onlyOwner {
213       balances[newOwner] += balances[owner];
214       balances[owner] = 0;
215       owner = newOwner;
216 
217     }
218     
219      // Failsafe drain
220 
221     function drain() onlyOwner {
222         owner.transfer(this.balance);
223     }
224     
225 }