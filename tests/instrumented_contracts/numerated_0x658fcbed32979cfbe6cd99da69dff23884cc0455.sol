1 pragma solidity ^0.4.25;
2 
3 contract CompanyToken {
4 
5     /* variables */
6     string public name; /* ERC20 Name */
7     string public symbol; /* ERC20 Symbol */
8     uint8 public decimals; /* ERC20 Decimals */
9     uint256 public totalSupply; /* ERC20 total Supply */
10     address public owner; /* Owner address */
11     uint256 public rate; /* Token Exchange Rate in Euro */
12 	bool public allow_buy; /* allow token payed with eth */
13     mapping(address => uint256) balances; /* Token Balances */
14 
15     /* events */    
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Mint(address indexed owner, uint256 value);
18     event SetOwner(address indexed owner);
19     event SetAllowBuy(bool allow_buy);
20     event SetRate(uint256 rate);
21     event CreateToken(address indexed sender, uint256 value);
22     
23     /* variables on contract create */
24     constructor() public {
25         totalSupply = 2500000; /* decimals * real value */
26         name = "BSOnders";
27         symbol = "BSO";
28         decimals = 2;
29         rate = 190;
30         balances[msg.sender] = totalSupply;
31         owner = msg.sender;
32         allow_buy = false;
33     }
34     
35     /* modifier */
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41 	modifier onlyPayloadSize(uint size) {
42 		assert(msg.data.length >= size + 4);
43 		_;
44 	}
45 	
46     /* default ERC20 functions */
47     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool success) {
48         require(balances[msg.sender] >= _value);
49         balances[msg.sender] -= _value;
50         balances[_to] += _value;
51         emit Transfer(msg.sender, _to, _value);
52         return true;
53     }
54     
55     function transferFrom(address _from, address _to, uint256 _value) private returns (bool success) {
56         require(balances[_from] >= _value);
57         balances[_to] += _value;
58         balances[_from] -= _value;
59         emit Transfer(_from, _to, _value);
60         return true;
61     }    
62 
63     function balanceOf(address _owner) public view returns (uint256 balance) {
64         return balances[_owner];
65     }
66 
67     /* set functions */ 
68     function setRate(uint256 _value) public onlyOwner returns(bool success) {
69         rate = _value;
70         emit SetRate(_value);
71         return true;
72     }        
73 
74     function setOwner(address _owner) public onlyOwner returns (bool success) {
75         owner = _owner;
76         emit SetOwner(_owner);
77         return true;
78     }    
79 
80     function setAllowBuy(bool _value) public onlyOwner returns(bool success) {
81         allow_buy = _value;
82         emit SetAllowBuy(_value);
83         return true;
84     }
85 
86     /* special functions */
87     function distribute(address[] recipients, uint256[] _value) public onlyOwner returns (bool success) {
88         for(uint i = 0; i < recipients.length; i++) {
89             transferFrom(owner, recipients[i], _value[i]);
90         }
91         return true;
92     }    
93    
94     function mint(uint256 _value) private returns (bool success) {
95         require(_value > 0);
96         balances[msg.sender] = balances[msg.sender] + _value;
97         totalSupply = totalSupply + _value;
98         emit Mint(msg.sender, _value);
99         return true;
100     }
101     
102     /*
103     function burn(uint256 _value) public onlyOwner returns (bool success) {
104         require(balances[msg.sender] >= _value);
105         balances[msg.sender] -= _value;
106         totalSupply -= _value;
107         emit Burn(msg.sender, _value);
108         return true;
109     }
110 
111     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
112         require(balances[_from] >= _value);
113         balances[_from] -= _value;
114         totalSupply -= _value;
115         emit Burn(_from, _value);
116         return true;
117     }    
118     */
119   
120     /* private functions */
121     function createToken(uint256 _value) private returns (bool success) {
122         // require(_value > 0);
123         // uint256 tokens = rate * _value * 10 ** uint(decimals) / (1 ether);
124         uint256 tokens = rate * _value * 100 / (1 ether);
125         mint(tokens);
126         emit CreateToken(msg.sender, _value);
127         return true;
128     }
129 
130      /* @notice Will receive any eth sent to the contract */
131     function() external payable {
132         if(allow_buy) {
133             createToken(msg.value);
134         } else {
135             revert(); // Reject any accidental Ether transfer
136         }
137     }
138 }