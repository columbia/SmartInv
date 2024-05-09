1 pragma solidity ^0.4.16;
2 
3  
4 
5 interface IERC20 {
6     function totalSupply() constant returns (uint256 totalSupply);
7     function balanceOf(address _owner) constant returns (uint256 balance);
8     function transfer(address _to, uint256 _value) returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
10     function approve(address _spender, uint256 _value) returns (bool success);
11     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 
17 
18 
19 contract StreampayToken is IERC20 {
20     // Public variables of the token
21     uint256 public constant _totalSupply = 20000000 * 10**18;
22     string public constant name = "StreamPay Token";
23     string public constant symbol = "STPY";
24     uint256 public constant decimals = 18;
25     // 18 decimals is the strongly suggested default, avoid changing it
26     
27 
28     // This creates an array with all balances
29     mapping (address => uint256) balances;
30     mapping (address => mapping (address => uint256)) allowed;
31     
32     function StreampayToken () public
33     {
34         balances[msg.sender] = _totalSupply;
35     }
36 
37     function totalSupply() constant returns (uint256 totalSupply)   
38     {
39         return _totalSupply;
40     }
41     function balanceOf(address _owner)  constant public returns (uint256 balance)
42     {
43         return balances[_owner];
44     }
45     
46     function transfer(address _to, uint256 _value)public returns (bool success)
47     {
48         require(
49             balances[msg.sender] >= _value && _value > 0
50             );
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55     }
56     
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
58     {
59         require(
60             allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0
61             );
62             balances[_from] -= _value;
63             balances[_to] += _value;
64             allowed[_from][msg.sender] -= _value;
65             Transfer(_from, _to, _value);
66             return true;
67     }
68     
69     
70     function approve(address _spender, uint256 _value) public returns (bool success)
71     {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76     
77     function allowance(address _owner, address _spender) constant public returns  (uint256 remaining)
78     {
79         return allowed[_owner][_spender];
80     }
81     
82      
83  event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 
86    
87  
88 
89      
90 }