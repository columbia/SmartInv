1 pragma solidity ^0.4.19;
2 
3 /*
4 This is MAUCOIN the Official Cryptocurrency of MU Crypto.
5 Made during a very boring evening by @Hoytico
6 
7 (\(\
8 ( – -)
9 ((‘) (’)
10 
11 Join us on Telegram https://t.me/joinchat/Hg3PmBMGZ7Wrt6jJD77D5Q
12 */
13 
14 contract MAUToken {
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     event Burn(address indexed from, uint256 value);
21     
22     string public constant symbol = "MAU";
23     string public constant name = "Maucoin";
24     uint8 public constant decimals = 18;
25     uint256 _totalSupply = 88888888000000000000000000;
26     uint256 _totalBurned = 0;
27      
28     address public owner;
29   
30     mapping(address => uint256) balances;
31   
32     mapping(address => mapping (address => uint256)) allowed;
33   
34     modifier onlyOwner() 
35      {
36          if (msg.sender != owner) 
37          {
38              throw;
39          }
40          _;
41      }
42   
43      function MAUToken() 
44      {
45         owner = msg.sender;
46         balances[owner] = _totalSupply;
47      }
48   
49      function totalSupply() constant returns (uint256 l_totalSupply) 
50      {
51         l_totalSupply = _totalSupply;
52      }
53 
54      function totalBurned() constant returns (uint256 l_totalBurned)
55      {
56         l_totalBurned = _totalBurned;
57      }
58   
59      function balanceOf(address _owner) constant returns (uint256 balance) 
60      {
61         return balances[_owner];
62      }
63   
64      function transfer(address _to, uint256 _amount) returns (bool success) 
65      {
66         if (_to == 0x0) throw;
67 
68         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
69         {
70             balances[msg.sender] -= _amount;
71             balances[_to] += _amount;
72             Transfer(msg.sender, _to, _amount);
73             return true;
74          } 
75          else 
76          {
77             return false;
78          }
79      }
80 
81      function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) 
82      {
83         if (_to == 0x0) throw;
84 
85         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
86         {
87             balances[_from] -= _amount;
88             allowed[_from][msg.sender] -= _amount;
89             balances[_to] += _amount;
90             Transfer(_from, _to, _amount);
91             return true;
92          } 
93          else 
94          {
95             return false;
96          }
97      }
98   
99      function approve(address _spender, uint256 _amount) returns (bool success) 
100      {
101         allowed[msg.sender][_spender] = _amount;
102         Approval(msg.sender, _spender, _amount);
103         return true;
104      }
105   
106      function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
107      {
108         return allowed[_owner][_spender];
109      }
110 
111     function burn(uint256 _value) returns (bool success) 
112     {
113         if (balances[msg.sender] < _value) throw;
114         balances[msg.sender] -= _value;
115         _totalSupply -= _value;          
116         _totalBurned += _value;                             
117         Burn(msg.sender, _value);
118         return true;
119     }
120 
121     function burnFrom(address _from, uint256 _value) returns (bool success) 
122     {
123         if (balances[_from] < _value) throw;
124         if (_value > allowed[_from][msg.sender]) throw;
125         balances[_from] -= _value;
126         _totalSupply -= _value;                           
127         _totalBurned += _value;
128         Burn(_from, _value);
129         return true;
130     }
131  }