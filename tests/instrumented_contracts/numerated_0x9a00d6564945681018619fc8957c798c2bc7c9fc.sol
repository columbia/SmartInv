1 /* Helex is a Ethereum Token property of Helex Corporation  */
2     
3     /* Helex will be used as a form of payment for services and goods*/
4  
5     pragma solidity ^0.4.9;
6 
7 
8     library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns(uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns(uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal constant returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30     }
31     contract  Helex{
32     
33 	
34 	string public standard = 'Helex 5.0';
35     using SafeMath for uint256;
36     mapping(address => mapping(address => uint256)) allowed;
37     mapping(address => uint256) balances;
38     uint256 public totalSupply;
39     uint256 public decimals;
40     address public owner;
41     bytes32 public symbol;
42     
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed _owner, address indexed spender, uint256 value);
45    
46     /* Public variables of the Helex Token. Total Supply 5 million */
47    
48     function  Helex() 
49     {
50         totalSupply = 50000000;
51         symbol = 'HLX';
52         owner = 0x753f309A8d9Aaed2fb92e54628043099d043180e;
53         balances[owner] = 50000000;
54         decimals = 1;
55     }
56     
57     function balanceOf(address _owner) constant returns(uint256 balance)
58     {
59         return balances[_owner];
60     }
61 
62     function allowance(address _owner, address _spender) constant returns(uint256 remaining)
63     {
64         return allowed[_owner][_spender];
65     }
66 
67     function transfer(address _to, uint256 _value) returns(bool)
68     {
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns(bool) 
76     {
77         var _allowance = allowed[_from][msg.sender];
78         balances[_to] = balances[_to].add(_value);
79         balances[_from] = balances[_from].sub(_value);
80         allowed[_from][msg.sender] = _allowance.sub(_value);
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function approve(address _spender, uint256 _value) returns(bool) 
86     {
87         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function() 
94     {
95         revert();
96     }
97 }