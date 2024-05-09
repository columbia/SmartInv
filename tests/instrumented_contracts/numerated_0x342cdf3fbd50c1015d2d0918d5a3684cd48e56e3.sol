1 pragma solidity ^0.4.8;
2 
3 
4   
5 contract Bitcoin_Biz {
6    
7     event Transfer(address indexed _from, address indexed _to, uint256 _value);
8     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
9     event Burn(address indexed from, uint256 value);
10     
11    
12     string public constant symbol = "BTCBIZ";
13     string public constant name = "Bitcoin Biz";
14     uint8 public constant decimals = 18;
15     uint256 _totalSupply = 21000000000000000000000000;    
16     uint256 _totalBurned = 0;                            
17      
18    
19     address public owner;
20     mapping(address => uint256) balances;
21     mapping(address => mapping (address => uint256)) allowed;
22   
23     function Bitcoin_Biz() 
24     {
25         owner = msg.sender;
26         balances[owner] = _totalSupply;
27     }
28   
29      function totalSupply() constant returns (uint256 l_totalSupply) 
30      {
31         l_totalSupply = _totalSupply;
32      }
33 
34      function totalBurned() constant returns (uint256 l_totalBurned)
35      {
36         l_totalBurned = _totalBurned;
37      }
38   
39      
40      function balanceOf(address _owner) constant returns (uint256 balance) 
41      {
42         return balances[_owner];
43      }
44   
45      
46      function transfer(address _to, uint256 _amount) returns (bool success) 
47      {
48         if (_to == 0x0) throw;      
49 
50         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
51         {
52             balances[msg.sender] -= _amount;
53             balances[_to] += _amount;
54             Transfer(msg.sender, _to, _amount);
55             return true;
56          } 
57          else 
58          {
59             return false;
60          }
61      }
62   
63      function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) 
64      {
65         if (_to == 0x0) throw;      
66 
67         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) 
68         {
69             balances[_from] -= _amount;
70             allowed[_from][msg.sender] -= _amount;
71             balances[_to] += _amount;
72             Transfer(_from, _to, _amount);
73             return true;
74          } 
75          else 
76          {
77             return false;
78          }
79      }
80   
81     
82      
83      
84      function approve(address _spender, uint256 _amount) returns (bool success) 
85      {
86         allowed[msg.sender][_spender] = _amount;
87         Approval(msg.sender, _spender, _amount);
88         return true;
89      }
90   
91      
92      function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
93      {
94         return allowed[_owner][_spender];
95      }
96 
97     function aidrop(address[] addresses) //onlyOwner 
98     { 
99         require (balances[msg.sender] >= (addresses.length * 1250000000000000000000));
100 
101         for (uint i = 0; i < addresses.length; i++) 
102         {
103              balances[msg.sender] -= 1250000000000000000000;
104              balances[addresses[i]] += 1250000000000000000000;
105              Transfer(msg.sender, addresses[i], 1250000000000000000000);
106          }
107      }
108     
109     
110     function burn(uint256 _value) returns (bool success) 
111     {
112         if (balances[msg.sender] < _value) throw;            
113         balances[msg.sender] -= _value;                      
114         
115         _totalSupply -= _value;          
116         _totalBurned += _value;                             
117         
118         Burn(msg.sender, _value);
119         return true;
120     }
121 
122     function burnFrom(address _from, uint256 _value) returns (bool success) 
123     {
124         if (balances[_from] < _value) throw;                
125         if (_value > allowed[_from][msg.sender]) throw;     
126         balances[_from] -= _value;                          
127         
128         _totalSupply -= _value;                           
129         _totalBurned += _value;
130      
131         Burn(_from, _value);
132         return true;
133     }
134  }