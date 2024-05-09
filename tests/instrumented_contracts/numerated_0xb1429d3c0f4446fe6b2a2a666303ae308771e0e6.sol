1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract BETTCoin {
28     
29     using SafeMath for uint256;
30 
31     address public owner = msg.sender;
32     mapping (address => uint256) balances;
33     mapping (address => mapping (address => uint256)) allowed;
34 
35     string public constant name = "BETT";
36     string public constant symbol = "BETT";
37     uint public constant decimals = 8;
38     uint256 public totalSupply = 210000000e8;
39 
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Burn(address indexed burner, uint256 value);
43 
44     modifier onlyOwner() {
45         require(msg.sender == owner,"only owner allow");
46         _;
47     }
48 
49     // mitigates the ERC20 short address attack
50     modifier onlyPayloadSize(uint size) {
51         assert(msg.data.length >= size + 4);
52         _;
53     }
54 
55     constructor() public {
56         owner = msg.sender;
57         balances[msg.sender] = totalSupply;
58     }
59     
60     function transferOwnership(address newOwner) public onlyOwner {
61         if (newOwner != address(0)) {
62             owner = newOwner;
63         }
64     }
65 
66     function balanceOf(address _owner) public view returns (uint256) {
67 	    return balances[_owner];
68     }
69     
70     function transfer(address _to, uint256 _amount) public onlyPayloadSize(2 * 32) returns (bool success) {
71 
72         require(_to != address(0),"to address error");
73         require(_amount <= balances[msg.sender],"from token not enough");
74         
75         balances[msg.sender] = balances[msg.sender].sub(_amount);
76         balances[_to] = balances[_to].add(_amount);
77         emit Transfer(msg.sender, _to, _amount);
78         return true;
79     }
80     
81     function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3 * 32) returns (bool success) {
82 
83         require(_to != address(0),"to address error");
84         require(_amount <= balances[_from],"from token not enough");
85         require(_amount <= allowed[_from][msg.sender],"insufficient credit");
86         
87         balances[_from] = balances[_from].sub(_amount);
88         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
89         balances[_to] = balances[_to].add(_amount);
90         emit Transfer(_from, _to, _amount);
91         return true;
92     }
93     
94     function approve(address _spender, uint256 _value) public returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         emit Approval(msg.sender, _spender, _value);
97         return true;
98     }
99     
100     function allowance(address _owner, address _spender) public view returns (uint256) {
101         return allowed[_owner][_spender];
102     }
103     
104     function burn(uint256 _value) public onlyOwner {
105         require(_value <= balances[msg.sender],"token not enough");
106 
107         address burner = msg.sender;
108         balances[burner] = balances[burner].sub(_value);
109         totalSupply = totalSupply.sub(_value);
110         emit Burn(burner, _value);
111     }
112 
113     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
114         balances[target] += mintedAmount;
115         totalSupply += mintedAmount;
116         emit Transfer(address(0), owner, mintedAmount);
117         emit Transfer(owner, target, mintedAmount);
118     }
119 }