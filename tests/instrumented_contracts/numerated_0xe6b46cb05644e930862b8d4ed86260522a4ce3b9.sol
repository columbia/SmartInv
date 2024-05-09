1 pragma solidity 0.4.19;
2 
3 
4 contract Street {
5 
6   // Public Variables of the token
7     string public constant NAME = "Street Credit";
8     string public constant SYMBOL = "STREET";
9     uint8 public constant DECIMALS = 18;
10     uint public constant TOTAL_SUPPLY = 100000000 * 10**uint(DECIMALS);
11     mapping(address => uint) public balances;
12     mapping(address => mapping (address => uint256)) internal allowed;
13     uint public constant TOKEN_PRICE = 10 szabo;
14 
15     //Private variables
16     address private constant BENEFICIARY = 0xff1A7c1037CDb35CD55E4Fe5B73a26F9C673c2bc;
17 
18     event Transfer(address indexed from, address indexed to, uint tokens);
19     event Purchase(address indexed purchaser, uint tokensBought, uint amountContributed);
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21 
22     function Street() public {
23 
24         balances[BENEFICIARY] = TOTAL_SUPPLY; // All tokens initially belong to me until they are purchased
25         Transfer(address(0), BENEFICIARY, TOTAL_SUPPLY);
26     }
27 
28     // Any transaction sent to the contract will trigger this anonymous function
29     // All ether will be sent to the purchase function
30     function () public payable {
31         purchaseTokens(msg.sender);
32     }
33 
34     function name() public pure returns (string) {
35         return NAME;
36     }
37 
38     function symbol() public pure returns (string) {
39         return SYMBOL;
40     }
41 
42     function balanceOf(address tokenOwner) public view returns (uint balance) {
43         return balances[tokenOwner];
44     }
45 
46     function transfer(address _to, uint256 _value) public returns (bool) {
47         require(_to != address(0));
48         require(_value <= balances[msg.sender]);
49         require(balances[msg.sender] + _value >= balances[msg.sender]);
50 
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     // Purchase tokens from my reserve
58     function purchaseTokens(address _buyer) public payable returns (bool) {
59         require(_buyer != address(0));
60         require(balances[BENEFICIARY] > 0);
61         require(msg.value != 0);
62 
63         uint amount = msg.value / TOKEN_PRICE;
64         BENEFICIARY.transfer(msg.value);
65         balances[BENEFICIARY] -= amount;
66         balances[_buyer] += amount;
67         Transfer(BENEFICIARY, _buyer, amount);
68         Purchase(_buyer, amount, msg.value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
73         require(_to != address(0));
74         require(_value <= balances[_from]);
75         require(_value <= allowed[_from][msg.sender]);
76 
77         balances[_from] -= _value;
78         balances[_to] += _value;
79         allowed[_from][msg.sender] -= _value;
80         Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     // ERC-20 Approval functions
85     function approve(address _spender, uint256 _value) public returns (bool) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public view returns (uint256) {
92         return allowed[_owner][_spender];
93     }
94 
95     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
96         allowed[msg.sender][_spender] += _addedValue;
97         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
98         return true;
99     }
100 
101     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
102         uint oldValue = allowed[msg.sender][_spender];
103         if (_subtractedValue > oldValue) {
104             allowed[msg.sender][_spender] = 0;
105         } else {
106             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
107         }
108         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109         return true;
110     }
111 }