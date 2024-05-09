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
40     uint public constant _totalSupply = 21000000; 
41     
42     string public constant symbol = "BETH";
43     string public constant name = "Bitcoin Ether";
44     uint8 public constant decimals = 18;
45 	uint256 public constant totalSupply = _totalSupply * 10 ** uint256(decimals);
46     
47     // 1 ether = 500 gigs
48     uint256 public constant RATE = 500; 
49     
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52     
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     
56     function () public payable {
57         createTokens();
58     }
59     
60     function GigsToken() public {
61         balances[msg.sender] = totalSupply;
62     }
63     
64     function createTokens() public payable {
65         require(msg.value > 0);
66         uint256 tokens = msg.value.mul(RATE);
67         balances[msg.sender] = balances[msg.sender].add(tokens);
68         
69         //_totalSupply = _totalSupply.add(tokens);
70         
71         //owner.transfer(msg.value);
72     }
73     
74     function balanceOf(address _owner) public constant returns (uint256 balance){
75         return balances[_owner];
76     }
77     function transfer(address _to, uint256 _value) internal returns (bool success) {
78 		require(_to != 0x0);
79         require(balances[msg.sender] >= _value && _value > 0);
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
86 		 require(_to != 0x0);
87         require(allowed [_from][msg.sender] >= 0 && balances[_from] >= _value && _value > 0);
88         balances[_from] = balances[_from].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93         
94     }
95     function approve(address _spender, uint256 _value) public returns (bool success){
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
101         return allowed[_owner][_spender];
102     }
103     
104 }