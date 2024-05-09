1 pragma solidity ^0.4.15;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract DYLC_ERC20Token {
6 
7     address public owner;
8     string public name = "YLCHINA";
9     string public symbol = "DYLC";
10     uint8 public decimals = 18;
11 
12     uint256 public totalSupply = 5000000000 * (10**18);
13     uint256 public currentSupply = 0;
14 
15     uint256 public angelTime = 1522395000;
16     uint256 public privateTime = 1523777400;
17     uint256 public firstTime = 1525073400;
18     uint256 public secondTime = 1526369400;
19     uint256 public thirdTime = 1527665400;
20     uint256 public endTime = 1529047800;
21 
22     uint256 public constant earlyExchangeRate = 83054;  
23     uint256 public constant baseExchangeRate = 55369; 
24     
25     uint8 public constant rewardAngel = 20;
26     uint8 public constant rewardPrivate = 20;
27     uint8 public constant rewardOne = 15;
28     uint8 public constant rewardTwo = 10;
29     uint8 public constant rewardThree = 5;
30 
31     uint256 public constant CROWD_SUPPLY = 550000000 * (10**18);
32     uint256 public constant DEVELOPER_RESERVED = 4450000000 * (10**18);
33 
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     //event Approval(address indexed owner, address indexed spender, uint256 value);
39 
40     event Burn(address indexed from, uint256 value);
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     modifier onlyOwner() {
44       require(msg.sender == owner);
45       _;
46     }
47 
48     function DYLC_ERC20Token() public {
49         owner = 0xA9802C071dD0D9fC470A06a487a2DB3D938a7b02;
50         balanceOf[owner] = DEVELOPER_RESERVED;
51     }
52 
53     function transferOwnership(address newOwner) onlyOwner public {
54       require(newOwner != address(0));
55       OwnershipTransferred(owner, newOwner);
56       owner = newOwner;
57     }
58 
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     function transfer(address _to, uint256 _value) public {
78         _transfer(msg.sender, _to, _value);
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         require(_value <= allowance[_from][msg.sender]);     // Check allowance
83         allowance[_from][msg.sender] -= _value;
84         _transfer(_from, _to, _value);
85         return true;
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         //Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
95         tokenRecipient spender = tokenRecipient(_spender);
96         if (approve(_spender, _value)) {
97             spender.receiveApproval(msg.sender, _value, this, _extraData);
98             return true;
99         }
100     }
101 
102     function burn(uint256 _value) public returns (bool success) {
103         require(balanceOf[msg.sender] >= _value);   
104         balanceOf[msg.sender] -= _value;            
105         totalSupply -= _value;                      
106         Burn(msg.sender, _value);
107         return true;
108     }
109 
110     function burnFrom(address _from, uint256 _value) public returns (bool success) {
111         require(balanceOf[_from] >= _value);                
112         require(_value <= allowance[_from][msg.sender]);    
113         balanceOf[_from] -= _value;                         
114         allowance[_from][msg.sender] -= _value;             
115         totalSupply -= _value;                              
116         Burn(_from, _value);
117         return true;
118     }
119     
120     function () payable public{
121           buyTokens(msg.sender);
122     }
123     
124     function buyTokens(address beneficiary) public payable {
125       require(beneficiary != 0x0);
126       require(validPurchase());
127 
128       uint256 rRate = rewardRate();
129 
130       uint256 weiAmount = msg.value;
131       balanceOf[beneficiary] += weiAmount * rRate;
132       currentSupply += balanceOf[beneficiary];
133       forwardFunds();           
134     }
135 
136     function rewardRate() internal constant returns (uint256) {
137             require(validPurchase());
138             uint256 rate;
139             if (now >= angelTime && now < privateTime){
140               rate = earlyExchangeRate + earlyExchangeRate * rewardAngel / 100;
141             }else if(now >= privateTime && now < firstTime){
142               rate = baseExchangeRate + baseExchangeRate * rewardPrivate / 100;
143             }else if(now >= firstTime && now < secondTime){
144               rate = baseExchangeRate + baseExchangeRate * rewardOne / 100;
145             }else if(now >= secondTime && now < thirdTime){
146               rate = baseExchangeRate + baseExchangeRate * rewardTwo / 100;
147             }else if(now >= thirdTime && now < endTime){
148               rate = baseExchangeRate + baseExchangeRate * rewardThree / 100;
149             }
150             return rate;
151       }
152 
153       function forwardFunds() internal {
154             owner.transfer(msg.value);
155       }
156 
157       function validPurchase() internal constant returns (bool) {
158             bool nonZeroPurchase = msg.value != 0;
159             bool noEnd = !hasEnded();
160             bool noSoleout = !isSoleout();
161             return  nonZeroPurchase && noEnd && noSoleout;
162       }
163 
164       function afterCrowdSale() public onlyOwner {
165         require( hasEnded() && !isSoleout());
166         balanceOf[owner] = balanceOf[owner] + CROWD_SUPPLY - currentSupply;
167         currentSupply = CROWD_SUPPLY;
168       }
169 
170 
171       function hasEnded() public constant returns (bool) {
172             return (now > endTime); 
173       }
174 
175       function isSoleout() public constant returns (bool) {
176         return (currentSupply >= CROWD_SUPPLY);
177       }
178 }