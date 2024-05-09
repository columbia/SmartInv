1 pragma solidity ^0.4.19;
2 
3 contract ERC20 {
4 
5 event Transfer(address indexed _from, address indexed _to, uint256 _value);
6 
7 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
8 
9 function totalSupply() external constant returns (uint);
10 
11 function balanceOf(address _owner) external constant returns (uint256);
12 
13 function transfer(address _to, uint256 _value) external returns (bool);
14 
15 function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
16 
17 function approve(address _spender, uint256 _value) external returns (bool);
18 
19 function allowance(address _owner, address _spender) external constant returns (uint256);
20     
21 }
22 
23 library SafeMath {
24 
25     /*
26         @return sum of a and b
27     */
28     function ADD (uint256 a, uint256 b) pure internal returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 
34     /*
35         @return difference of a and b
36     */
37     function SUB (uint256 a, uint256 b) pure internal returns (uint256) {
38         assert(a >= b);
39         return a - b;
40     }
41     
42 }
43 
44 contract Ownable {
45 
46     address owner;
47 
48     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
49 
50     function Ownable() public {
51         owner = msg.sender;
52         OwnershipTransferred (address(0), owner);
53     }
54 
55     function transferOwnership(address _newOwner)
56         public
57         onlyOwner
58         notZeroAddress(_newOwner)
59     {
60         owner = _newOwner;
61         OwnershipTransferred(msg.sender, _newOwner);
62     }
63 
64     //Only owner can call function
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     modifier notZeroAddress(address _address) {
71         require(_address != address(0));
72         _;
73     }
74 
75 }
76 
77 contract StandardToken is ERC20, Ownable{
78 
79     using SafeMath for uint256;
80     
81     //Total amount of TheWolfCoin
82     uint256 _totalSupply = 5000000000; 
83 
84     //Balances for each account
85     mapping (address => uint256)  balances;
86     //Owner of the account approves the transfer of an amount to another account
87     mapping (address => mapping (address => uint256)) allowed;
88 
89     //Notifies users about the amount burnt
90     event Burn(address indexed _from, uint256 _value);
91 
92     //return _totalSupply of the Token
93     function totalSupply() external constant returns (uint256 totalTokenSupply) {
94         totalTokenSupply = _totalSupply;
95     }
96 
97     //What is the balance of a particular account?
98     function balanceOf(address _owner)
99         external
100         constant
101         returns (uint256 balance)
102     {
103         return balances[_owner];
104     }
105 
106     //Transfer the balance from owner's account to another account
107     function transfer(address _to, uint256 _amount)
108         external
109         notZeroAddress(_to)
110         returns (bool success)
111     {
112         balances[msg.sender] = balances[msg.sender].SUB(_amount);
113         balances[_to] = balances[_to].ADD(_amount);
114         Transfer(msg.sender, _to, _amount);
115         return true;
116     }
117 
118     function transferFrom(address _from, address _to, uint256 _amount)
119         external
120         notZeroAddress(_to)
121         returns (bool success)
122     {
123         //Require allowance to be not too big
124         require(allowed[_from][msg.sender] >= _amount);
125         balances[_from] = balances[_from].SUB(_amount);
126         balances[_to] = balances[_to].ADD(_amount);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB(_amount);
128         Transfer(_from, _to, _amount);
129         return true;
130     }
131 
132     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
133     // If this function is called again it overwrites the current allowance with _value.
134     function approve(address _spender, uint256 _amount)
135         external
136         notZeroAddress(_spender)
137         returns (bool success)
138     {
139         allowed[msg.sender][_spender] = _amount;
140         Approval(msg.sender, _spender, _amount);
141         return true;
142     }
143 
144     //Return how many tokens left that you can spend from
145     function allowance(address _owner, address _spender)
146         external
147         constant
148         returns (uint256 remaining)
149     {
150         return allowed[_owner][_spender];
151     }
152 
153     function increaseApproval(address _spender, uint256 _addedValue)
154         external
155         returns (bool success)
156     {
157         uint256 increased = allowed[msg.sender][_spender].ADD(_addedValue);
158         require(increased <= balances[msg.sender]);
159         //Cannot approve more coins then you have
160         allowed[msg.sender][_spender] = increased;
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint256 _subtractedValue)
166         external
167         returns (bool success)
168     {
169         uint256 oldValue = allowed[msg.sender][_spender];
170         if (_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0;
172         } else {
173             allowed[msg.sender][_spender] = oldValue.SUB(_subtractedValue);
174         }
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179     function burn(uint256 _value) external returns (bool success) {
180         //Subtract from the sender
181         balances[msg.sender] = balances[msg.sender].SUB(_value);
182         //Update _totalSupply
183         _totalSupply = _totalSupply.SUB(_value);
184         Burn(msg.sender, _value);
185         return true;
186     }
187 
188 }
189 
190 contract TheWolfCoin is StandardToken {
191 
192     function ()
193    	public
194     {
195     //if ether is sent to this address, send it back.
196     revert();
197     }
198 
199     //Name of the token
200     string public constant name = "TheWolfCoin";
201     //Symbol of WolfCoin
202     string public constant symbol = "TWC";
203     //Number of decimals of WolfCoin
204     uint8 public constant decimals = 2;
205 
206     //Funder Wolfpack Token Allocation
207 	//The first wolf is the creator of the contract
208 
209     //2nd Wolf wallet
210     address public constant WOLF2 = 0xDB9504AC2E451f8dbB8990564e44B83B7be29045;
211     //3rd Wolf wallet
212     address public constant WOLF3 = 0xe623bED2b3A4cE7ba286737C8A03Ae0b27e01d8A;
213     //4th Wolf wallet
214     address public constant WOLF4 = 0x7bB34Edb32024C7Ce01a1c2C9A02bf9d3B5BdEf1;
215 
216     //wolf2 wallet balance
217     uint256 public wolf2Balance;
218     //wolf3 wallet balance
219     uint256 public wolf3Balance;
220     //wolf4 wallet balance
221     uint256 public wolf4Balance;
222 
223     //25%
224     uint256 private constant WOLF1_THOUSANDTH = 250;
225     //25%
226     uint256 private constant WOLF2_THOUSANDTH = 250;
227     //25%
228     uint256 private constant WOLF3_THOUSANDTH = 250;
229     //25%
230     uint256 private constant WOLF4_THOUSANDTH = 250;
231     //100%
232     uint256 private constant DENOMINATOR = 1000;
233 
234     function TheWolfCoin() public {
235         //25% of _totalSupply
236         balances[msg.sender] = _totalSupply * WOLF1_THOUSANDTH / DENOMINATOR;
237         //25% of _totalSupply
238         wolf2Balance = _totalSupply * WOLF2_THOUSANDTH / DENOMINATOR;
239         //25%% of _totalSupply
240         wolf3Balance = _totalSupply * WOLF3_THOUSANDTH / DENOMINATOR;
241         //25%% of _totalSupply
242         wolf4Balance = _totalSupply * WOLF4_THOUSANDTH / DENOMINATOR;
243 
244         Transfer (this, msg.sender, balances[msg.sender]);
245 
246         balances[WOLF2] = wolf2Balance;
247         Transfer (this, WOLF2, balances[WOLF2]);
248 
249         balances[WOLF3] = wolf3Balance;
250         Transfer (this, WOLF3, balances[WOLF3]);
251 
252         balances[WOLF4] = wolf4Balance;
253         Transfer (this, WOLF4, balances[WOLF4]);
254 
255     }
256 }