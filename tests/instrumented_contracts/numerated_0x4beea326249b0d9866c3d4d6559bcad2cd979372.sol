1 pragma solidity ^0.4.15;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract SLPC_ERC20Token {
6 
7     address public owner;
8     string public name = "SLPC";
9     string public symbol = "SLPC";
10     uint8 public decimals = 8;
11 
12     uint256 public totalSupply = 1000000000 * (10**8);
13     uint256 public currentSupply = 0;
14 
15     uint256 public angelTime = 1528646400;//20180611
16     uint256 public firstTime = 1529942400;//20180626
17     uint256 public secondTime = 1531670400;//20180716
18     uint256 public thirdTime = 1534348800;//20180816
19     uint256 public endTime = 1550246400;//20190216
20 
21     uint256 public constant angelExchangeRate = 40000;
22     uint256 public constant firstExchangeRate = 13333;
23 	uint256 public constant secondExchangeRate = 10000;
24 	uint256 public constant thirdExchangeRate = 6154;
25 	
26     uint256 public constant CROWD_SUPPLY = 300000000 * (10**8);
27     uint256 public constant DEVELOPER_RESERVED = 700000000 * (10**8);
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     //event Approval(address indexed owner, address indexed spender, uint256 value);
34 
35     event Burn(address indexed from, uint256 value);
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     modifier onlyOwner() {
39       require(msg.sender == owner);
40       _;
41     }
42 
43     function SLPC_ERC20Token() public {
44         owner = 0x4411f49c5fa796893105Ba260e40445b709A8290;
45         balanceOf[owner] = DEVELOPER_RESERVED;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49       require(newOwner != address(0));
50       OwnershipTransferred(owner, newOwner);
51       owner = newOwner;
52     }
53 
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     function transfer(address _to, uint256 _value) public {
73         _transfer(msg.sender, _to, _value);
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     // Check allowance
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         allowance[msg.sender][_spender] = _value;
85         //Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
90         tokenRecipient spender = tokenRecipient(_spender);
91         if (approve(_spender, _value)) {
92             spender.receiveApproval(msg.sender, _value, this, _extraData);
93             return true;
94         }
95     }
96 
97     function burn(uint256 _value) public returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);   
99         balanceOf[msg.sender] -= _value;            
100         totalSupply -= _value;                      
101         Burn(msg.sender, _value);
102         return true;
103     }
104 
105     function burnFrom(address _from, uint256 _value) public returns (bool success) {
106         require(balanceOf[_from] >= _value);
107         require(_value <= allowance[_from][msg.sender]);
108         balanceOf[_from] -= _value;
109         allowance[_from][msg.sender] -= _value;             
110         totalSupply -= _value;
111         Burn(_from, _value);
112         return true;
113     }
114     
115     function () payable public{
116           buyTokens(msg.sender);
117     }
118     
119     function buyTokens(address beneficiary) public payable {
120       require(beneficiary != 0x0);
121       require(validPurchase());
122 
123       uint256 rRate = rewardRate();
124 
125       uint256 weiAmount = msg.value;
126       balanceOf[beneficiary] += weiAmount * rRate;
127       currentSupply += balanceOf[beneficiary];
128       forwardFunds();
129     }
130 
131     function rewardRate() internal constant returns (uint256) {
132             require(validPurchase());
133             uint256 rate;
134             if (now >= angelTime && now < firstTime){
135               rate = angelExchangeRate;
136             }else if(now >= firstTime && now < secondTime){
137               rate = firstExchangeRate;
138             }else if(now >= secondTime && now < thirdTime){
139               rate = secondExchangeRate;
140             }else if(now >= thirdTime && now < endTime){
141               rate = thirdExchangeRate;
142             }
143 			
144             return rate;
145       }
146 
147       function forwardFunds() internal {
148             owner.transfer(msg.value);
149       }
150 
151       function validPurchase() internal constant returns (bool) {
152             bool nonZeroPurchase = msg.value != 0;
153             bool noEnd = !hasEnded();
154             bool noSoleout = !isSoleout();
155             return  nonZeroPurchase && noEnd && noSoleout;
156       }
157 
158       function afterCrowdSale() public onlyOwner {
159         require( hasEnded() && !isSoleout());
160         balanceOf[owner] = balanceOf[owner] + CROWD_SUPPLY - currentSupply;
161         currentSupply = CROWD_SUPPLY;
162       }
163 
164 
165       function hasEnded() public constant returns (bool) {
166             return (now > endTime); 
167       }
168 
169       function isSoleout() public constant returns (bool) {
170         return (currentSupply >= CROWD_SUPPLY);
171       }
172 }