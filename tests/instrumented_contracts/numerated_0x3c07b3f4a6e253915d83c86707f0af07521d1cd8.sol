1 pragma solidity ^0.4.14;
2 
3  contract ERC20Interface {
4      function totalSupply() constant returns (uint256 totalSupply);
5      function balanceOf(address _owner) constant returns (uint256 balance);
6      function transfer(address _to, uint256 _value) returns (bool success);
7      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8      function approve(address _spender, uint256 _value) returns (bool success);
9      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12  }
13   
14  contract APIHeaven is ERC20Interface {
15      string public constant symbol = "☁";
16      string public constant name = "API Heaven clouds";
17      uint8 public constant decimals = 0;
18      uint256 _totalSupply = 1000000000000000; 
19      
20      uint256 public cloudsPerEth = 300000;
21      
22      address public owner;
23 
24      bool public selling = false;
25   
26      mapping(address => uint256) balances;
27   
28      mapping(address => mapping (address => uint256)) allowed;
29   
30      modifier onlyOwner() {
31          if (msg.sender != owner) {
32              revert();
33          }
34          _;
35      }
36 
37     
38      function transferOwnership(address newOwner) onlyOwner {
39         balances[newOwner] = balances[owner];
40         balances[owner] = 0;
41         owner = newOwner;
42     }
43 
44     
45      function changeCloudsPerEth(uint256 newcloudworth) onlyOwner {
46         cloudsPerEth = newcloudworth;
47     }
48 
49     
50     function changeSale(bool _sale) onlyOwner {
51         selling = _sale;
52     }
53   
54      function APIHeaven() {
55          owner = msg.sender;
56          balances[owner] = _totalSupply;
57      }
58   
59      function totalSupply() constant returns (uint256 totalSupply) {
60          totalSupply = _totalSupply;
61      }
62   
63      function balanceOf(address _owner) constant returns (uint256 balance) {
64          return balances[_owner];
65      }
66     function transfer(address _to, uint256 _amount) returns (bool success) {
67         
68         if (balances[msg.sender] >= _amount 
69             && _amount > 0
70             && balances[_to] + _amount > balances[_to]) {
71             balances[msg.sender] -= _amount;
72             balances[_to] += _amount;
73             Transfer(msg.sender, _to, _amount);
74             
75             return true;
76         } else {
77             return false;
78         }
79     }
80     function sale() payable {
81         if(selling == false) revert();     
82         uint256 amount = (msg.value / 1000000000000000) * cloudsPerEth;              
83         if (balances[owner] < amount) revert();            
84         balances[msg.sender] += amount;                
85         balances[owner] -= amount;                      
86         Transfer(owner, msg.sender, amount);             
87     }
88   
89      function transferFrom(
90          address _from,
91          address _to,
92          uint256 _amount
93     ) returns (bool success) {
94         if (balances[_from] >= _amount
95             && allowed[_from][msg.sender] >= _amount
96             && _amount > 0
97             && balances[_to] + _amount > balances[_to]) {
98             balances[_from] -= _amount;
99             allowed[_from][msg.sender] -= _amount;
100             balances[_to] += _amount;
101             Transfer(_from, _to, _amount);
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     function approve(address _spender, uint256 _amount) returns (bool success) {
109         allowed[msg.sender][_spender] = _amount;
110         Approval(msg.sender, _spender, _amount);
111         return true;
112     }
113  
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }
117 }