1 pragma solidity ^0.4.8;
2 
3 /**
4  * @title VNET Token - The Next Generation Value Transfering Network.
5  * @author Wang Yunxiao - <wyx96922@gmail.com>
6  */
7 
8 contract SafeMath {
9     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b > 0);
17         uint256 c = a / b;
18         assert(a == b * c + a % b);
19         return c;
20     }
21 
22     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a && c >= b);
30         return c;
31     }
32 }
33 
34 contract VNET is SafeMath {
35     string constant tokenName = 'VNET';
36     string constant tokenSymbol = 'VNET';
37     uint8 constant decimalUnits = 8;
38 
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42 
43     uint256 public totalSupply = 100 * (10**8) * (10**8); // 100 yi
44 
45     address public owner;
46     
47     mapping(address => bool) restrictedAddresses;
48     mapping(address => uint256) public balanceOf;
49     mapping(address => mapping(address => uint256)) public allowance;
50 
51     /* This generates a public event on the blockchain that will notify clients */
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56     modifier onlyOwner {
57         assert(owner == msg.sender);
58         _;
59     }
60 
61     /* Initializes contract with initial supply tokens to the creator of the contract */
62     function VNET() public {
63         balanceOf[msg.sender] = totalSupply;                // Give the creator all tokens
64         name = tokenName;                                   // Set the name for display purposes
65         symbol = tokenSymbol;                               // Set the symbol for display purposes
66         decimals = decimalUnits;                            // Amount of decimals for display purposes
67         owner = msg.sender;
68     }
69 
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         require(_value > 0);
72         require(balanceOf[msg.sender] >= _value);              // Check if the sender has enough
73         require(balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
74         require(!restrictedAddresses[msg.sender]);
75         require(!restrictedAddresses[_to]);
76         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);   // Subtract from the sender
77         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                 // Add the same to the recipient
78         Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place
79         return true;
80     }
81 
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83         allowance[msg.sender][_spender] = _value;            // Set allowance
84         Approval(msg.sender, _spender, _value);              // Raise Approval event
85         return true;
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(balanceOf[_from] >= _value);                  // Check if the sender has enough
90         require(balanceOf[_to] + _value >= balanceOf[_to]);   // Check for overflows
91         require(_value <= allowance[_from][msg.sender]);      // Check allowance
92         require(!restrictedAddresses[_from]);
93         require(!restrictedAddresses[msg.sender]);
94         require(!restrictedAddresses[_to]);
95         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);    // Subtract from the sender
96         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);        // Add the same to the recipient
97         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function totalSupply() constant public returns (uint256 Supply) {
103         return totalSupply;
104     }
105 
106     function balanceOf(address _owner) constant public returns (uint256 balance) {
107         return balanceOf[_owner];
108     }
109 
110     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
111       return allowance[_owner][_spender];
112     }
113 
114     function() public payable {
115         revert();
116     }
117 
118     /* Owner can add new restricted address or removes one */
119     function editRestrictedAddress(address _newRestrictedAddress) public onlyOwner {
120         restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
121     }
122 
123     function isRestrictedAddress(address _querryAddress) constant public returns (bool answer) {
124         return restrictedAddresses[_querryAddress];
125     }
126 }