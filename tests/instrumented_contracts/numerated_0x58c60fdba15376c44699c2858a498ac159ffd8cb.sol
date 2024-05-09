1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11         return c;
12     }  
13 
14     function div(uint256 a, uint256 b) internal returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20   
21     function mul(uint256 a, uint256 b) internal returns (uint256) {
22         uint256 c = a * b;
23         assert(a == 0 || c / a == b);
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 }
32 
33 contract GigsToken {
34     
35     using SafeMath for uint256;
36     
37     /**For unlimited supply set _totalSupply to 0, delete the word "constant", 
38      *and uncomment "_totalSupply" in createTokens()
39      */
40     uint public constant _totalSupply = 16000000; 
41     
42     string public constant symbol = "GIX";
43     string public constant name = "Blockchain Gigs";
44     uint8 public constant decimals = 18;
45 	uint256 public constant totalSupply = _totalSupply * 10 ** uint256(decimals);
46     
47     // 1 ether = 500 gigs
48     uint256 public constant RATE = 500;
49     
50     address public owner; 
51     
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54     
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57     
58     function () public payable {
59         createTokens();
60     }
61     
62     function GigsToken() {
63         balances[msg.sender] = totalSupply;
64         owner = msg.sender;
65     }
66     
67     function createTokens() payable {
68         require(msg.value > 0);
69         uint256 tokens = msg.value.mul(RATE);
70         balances[msg.sender] = balances[msg.sender].add(tokens);
71         
72         //_totalSupply = _totalSupply.add(tokens);
73         
74         owner.transfer(msg.value);
75     }
76     
77     function balanceOf(address _owner) constant returns (uint256 balance){
78         return balances[_owner];
79     }
80     function transfer(address _to, uint256 _value) returns (bool success) {
81         require(balances[msg.sender] >= _value && _value > 0);
82         balances[msg.sender] = balances[msg.sender].sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         Transfer(msg.sender, _to, _value);
85         return true;
86     }
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
88         require(allowed [_from][msg.sender] >= 0 && balances[_from] >= _value && _value > 0);
89         balances[_from] = balances[_from].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92         Transfer(_from, _to, _value);
93         return true;
94         
95     }
96     function approve(address _spender, uint256 _value) returns (bool success){
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
102         return allowed[_owner][_spender];
103     }
104     
105 
106 }