1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9  
10   function div(uint a, uint b) internal pure returns (uint) {
11     uint c = a / b;
12     return c;
13   }
14  
15   function sub(uint a, uint b) internal pure returns (uint) {
16     assert(b <= a); 
17     return a - b; 
18   } 
19   
20   function add(uint a, uint b) internal pure returns (uint) { 
21     uint c = a + b; assert(c >= a);
22     return c;
23   }
24  
25 }
26 
27 contract Own {
28     
29     address public owner;
30     
31     function Own() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         owner = newOwner;
42     }
43     
44 }
45 
46 contract Tangle is Own {
47     
48     using SafeMath for uint;
49     string public constant name = "Tangle";
50     string public constant symbol = "TNC";
51     uint32 public constant decimals = 7;
52     uint public totalSupply = 10000000;
53     mapping (address => uint) balances;
54     mapping (address => mapping(address => uint)) allowed;
55     
56     
57     function Tangle() public {
58         totalSupply = totalSupply * 10 ** uint(decimals);
59         balances[owner] = totalSupply;
60     }
61     
62     function balanceOf(address _owner) public constant returns (uint balance) {
63         return balances[_owner];
64     }
65     
66     function transfer(address _to, uint _value) public returns (bool success) {
67         if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
68             balances[msg.sender] = balances[msg.sender].sub(_value); 
69             balances[_to] = balances[_to].add(_value);
70             Transfer(msg.sender, _to, _value);
71             return true;
72         } 
73         return false;
74     }
75     
76     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
77         if( allowed[_from][msg.sender] >= _value &&
78             balances[_from] >= _value 
79             && balances[_to] + _value >= balances[_to]) {
80             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81             balances[_from] = balances[_from].sub(_value); 
82             balances[_to] = balances[_to].add(_value);
83             Transfer(_from, _to, _value);
84             return true;
85         } 
86        return false;
87     }
88     
89     function approve(address _spender, uint _value) public returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94     
95     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
96         return allowed[_owner][_spender];
97     }
98     
99     event Transfer(address indexed _from, address indexed _to, uint _value);
100     event Approval(address indexed _owner, address indexed _spender, uint _value);
101 }