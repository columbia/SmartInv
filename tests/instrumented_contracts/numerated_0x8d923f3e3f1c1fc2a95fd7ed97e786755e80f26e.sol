1 pragma solidity ^0.4.10;
2 
3 contract SafeMath {
4 
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12       assert(x >= y);
13       uint256 z = x - y;
14       return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18       uint256 z = x * y;
19       assert((x == 0)||(z/x == y));
20       return z;
21     }
22 
23 }
24 
25 contract ERC20Interface is SafeMath {
26 
27     uint256 public decimals = 0;
28     uint256 public _totalSupply = 5;
29     bool public constant isToken = true;
30 
31     address public owner;
32     
33     // Store the token balance for each user
34     mapping(address => uint256) balances;
35 
36     mapping(address => mapping(address => uint256)) allowed;
37 
38     function ERC20Interface()
39     {
40         owner = msg.sender;
41         balances[owner] = _totalSupply;
42     }
43 
44     function transfer(address _to, uint256 _value)
45         returns (bool success)
46     {
47         assert(balances[msg.sender] >= _value);
48         balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
49         balances[_to] = safeAdd(balances[_to], _value);
50         Transfer(msg.sender, _to, _value);
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value)
55         returns (bool success)
56     {
57         assert(allowance(msg.sender, _from) >= _value);
58         balances[_from] = safeSubtract(balances[_from], _value);
59         balances[_to] = safeAdd(balances[_to], _value);
60         allowed[msg.sender][_from] = safeSubtract(allowed[msg.sender][_from], _value);
61         Transfer(_from, _to, _value);
62         return true;
63     }
64 
65     function balanceOf(address _owner) 
66         constant returns (uint256 balance)
67     {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) 
72         returns (bool success)
73     {
74         assert(balances[msg.sender] >= _value);
75         allowed[_spender][msg.sender] = safeAdd(allowed[_spender][msg.sender], _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender)
80         constant returns (uint256 allowance)
81     {
82         return allowed[_owner][_spender];
83     }
84   
85     // Triggered when tokens are transferred.
86     event Transfer(address indexed _from, address indexed _to, uint256 _value);
87   
88     // Triggered whenever approve(address _spender, uint256 _value) is called.
89     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 }
91 
92 contract Iou is ERC20Interface {
93     string public constant symbol = "IOU";
94     string public constant name = "I owe you";
95     string public constant longDescription = "Buy or trade IOUs from Connor";
96 
97     // Basically a decorator _; is were the main function will go
98     modifier onlyOwner() 
99     {
100         require(msg.sender == owner);
101         _;
102     }
103 
104     function Iou() ERC20Interface() {}
105 
106     function changeOwner(address _newOwner) 
107         onlyOwner()
108     {
109         owner = _newOwner;
110     }
111 }