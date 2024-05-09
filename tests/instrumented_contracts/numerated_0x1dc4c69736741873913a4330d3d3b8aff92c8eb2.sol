1 pragma solidity ^0.4.20;
2 
3 interface ERC20 {
4     function totalSupply() constant returns (uint _totalSupply);
5     function balanceOf(address _owner) constant returns (uint balance);
6     function transfer(address _to, uint _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) returns (bool success);
8     function approve(address _spender, uint _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 contract StandardToken is ERC20 {
58     
59     using SafeMath for uint256;
60     
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     
64     uint256 public totalSupply;
65 
66    function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(_value <= balances[msg.sender]);
69     
70         // SafeMath.sub will throw if there is not enough balance.
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[_from]);
80         require(_value <= allowed[_from][msg.sender]);
81     
82         balances[_from] = balances[_from].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
85         Transfer(_from, _to, _value);
86         return true;
87     }
88 
89     function balanceOf(address _owner) public constant returns (uint256 balance) {
90         return balances[_owner];
91     }
92 
93     function approve(address _spender, uint256 _value) public returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
100         return allowed[_owner][_spender];
101     }
102     
103     function totalSupply() public constant returns (uint _totalSupply) {
104         _totalSupply = totalSupply;
105     }
106 
107  
108 }
109 
110 
111 contract MYC is StandardToken {
112 
113     string public name ="1MalaysiaCoin";                   
114     uint8 public decimals = 8;                
115     string public symbol = "MYC";                
116     uint256 public initialSupply = 100000000;
117   
118 
119     function MYC() public {
120         totalSupply = initialSupply * 10 ** uint256(decimals);
121         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
122       
123     }
124     
125 
126 }