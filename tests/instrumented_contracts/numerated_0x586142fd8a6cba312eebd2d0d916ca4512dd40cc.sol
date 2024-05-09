1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Token {
30     
31     using SafeMath for uint256;
32      
33     string public symbol = "LPN";
34     string public name = "Litepool";
35     uint8 public constant decimals = 18;
36     uint256 _totalSupply = 35000000;
37     uint256 ratePerWei = 1300;
38     address owner = 0x5367B63897eDE5076cD7A970a0fd85750e27F745;
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41     event Debug(string message, uint number);
42     mapping(address => uint256) balances;
43  
44     mapping(address => mapping (address => uint256)) allowed;
45  
46     function Token() public {
47         balances[owner] = _totalSupply * 10 ** 18;
48     }
49    
50    function changeBuyPrice(uint price) public
51    {
52        if (msg.sender == owner){
53         ratePerWei = price;
54        }
55    }
56     
57     function totalSupply() public constant returns (uint256 supply) {        
58         return _totalSupply;
59     }
60  
61     function balanceOf(address _owner) public constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64  
65     function transfer(address _to, uint256 _amount) internal returns (bool success) {
66         if (balances[msg.sender] >= _amount
67             && _amount > 0
68             && balances[_to] + _amount > balances[_to]) {
69             balances[msg.sender] -= _amount;
70             balances[_to] += _amount;
71             Transfer(msg.sender, _to, _amount);
72             return true;
73         } else {
74             return false;
75         }
76     }
77  
78     function transferFrom(
79         address _from,
80         address _to,
81         uint256 _amount
82     ) internal returns (bool success) {
83         if (balances[_from] >= _amount
84             && allowed[_from][msg.sender] >= _amount
85             && _amount > 0
86             && balances[_to] + _amount > balances[_to]) {
87             balances[_from] -= _amount;
88             allowed[_from][msg.sender] -= _amount;
89             balances[_to] += _amount;
90             Transfer(_from, _to, _amount);
91             return true;
92         } else {
93             return false;
94         }
95     }
96  
97     function approve(address _spender, uint256 _amount) public returns (bool success) {
98         allowed[msg.sender][_spender] = _amount;
99         Approval(msg.sender, _spender, _amount);
100         return true;
101     }
102  
103     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
104         return allowed[_owner][_spender];
105     }
106      // fallback function can be used to buy tokens
107       function () public payable {
108        // require(msg.sender != owner);   //owner should not be buying any tokens
109         buy(msg.sender);
110     }
111     function buy(address beneficiary) payable public returns (uint tokenAmount) {
112         
113         uint weiAmount = msg.value;
114         tokenAmount = weiAmount.mul(ratePerWei);
115         require(balances[owner] >= tokenAmount);               // checks if it has enough to sell
116         balances[beneficiary] = balances[beneficiary].add(tokenAmount);  // adds the amount to buyer's balance
117         balances[owner] = balances[owner].sub(tokenAmount);     // subtracts amount from seller's balance
118         owner.transfer(msg.value);
119         Transfer(owner, msg.sender, tokenAmount);               // execute an event reflecting the change
120         return tokenAmount;                                    // ends function and returns
121     }
122 }