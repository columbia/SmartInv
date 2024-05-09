1 pragma solidity ^0.4.16;
2 
3 
4 contract owned {
5     address public owner;
6     constructor() public {
7         owner = msg.sender;
8     }
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 contract AlphaProjectToken is owned {
18     using SafeMath for uint256;
19     string public constant name = "Alpha Project Token";
20     string public constant symbol = "APT";
21     uint public constant decimals = 8;
22     uint constant ONETOKEN = 10 ** uint256(decimals);
23     uint constant MILLION = 1000000; 
24     uint public totalSupply;
25     uint public DevSupply;
26     uint public GrowthPool;
27     uint public AirDrop;
28     uint public Rewards;                                
29     bool public DevSupply_Released = false;                     
30     bool public Token_AllowTransfer = false;                    
31     uint public Collected_Ether;
32     uint public Total_SoldToken;
33     uint public DevSupplyReleaseDate = now + (730 days);
34 
35     constructor() public {  
36         totalSupply = (100 * MILLION).mul(ONETOKEN);                        
37         DevSupply = totalSupply.mul(5).div(100);
38         GrowthPool = totalSupply.mul(5).div(100);
39         AirDrop = totalSupply.mul(5).div(100);                  
40         balanceOf[msg.sender] = totalSupply.sub(DevSupply);                            
41     }
42     
43     mapping (address => uint256) public balanceOf;
44     mapping (address => bool) public airdropped;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Burn(address indexed from, uint256 value);
48     event Whitelisted(address indexed target, bool whitelist);
49     event IcoFinished(bool finish);
50     
51     modifier notLocked{
52         require(Token_AllowTransfer == true || msg.sender == owner);
53         _;
54     }
55     
56     function unlockDevTokenSupply() onlyOwner public {
57         require(now >= DevSupplyReleaseDate, "not yet time to release.");                              
58         require(DevSupply_Released == false, "tokens already released.");       
59         balanceOf[owner] += DevSupply;
60         emit Transfer(0, this, DevSupply);
61         emit Transfer(this, owner, DevSupply);
62         DevSupply = 0;                                         
63         DevSupply_Released = true;                          
64     }
65 
66     function _transfer(address _from, address _to, uint _value) internal {
67         require (_to != 0x0);     
68         
69         require (balanceOf[_from] >= _value); 
70         require (balanceOf[_to] + _value >= balanceOf[_to]);
71         balanceOf[_from] -= _value;
72         balanceOf[_to] += _value;
73         emit Transfer(_from, _to, _value);
74     }
75     function transfer(address _to, uint256 _value) public {
76         require(AirDrop <= 0, "AirDrop is not yet finished");
77         require(Token_AllowTransfer, "Token transfer is not yet allowed.");
78         _transferToken(msg.sender, _to, _value);
79     }
80     function _transferToken(address _from, address _to, uint _value) internal {
81         require(_to != 0x0);
82         require(balanceOf[_from] >= _value);
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84         uint previousBalances = balanceOf[_from] + balanceOf[_to];
85         balanceOf[_from] -= _value;
86         balanceOf[_to] += _value;
87         emit Transfer(_from, _to, _value);
88         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
89     }
90     function() payable public {
91         require(AirDrop > 0, "AirDrop is finished.");
92         require(airdropped[msg.sender] == false, "you already have claimed AirDrop Tokens.");
93         setAirDropAddress(msg.sender);
94         uint sendToken = 888 * ONETOKEN;
95         if(AirDrop < sendToken){
96             sendToken = AirDrop;
97             Token_AllowTransfer = true;
98         }
99         AirDrop -= sendToken;
100         _transfer(owner, msg.sender, sendToken);
101 
102         if(msg.value > 0){
103             owner.transfer(msg.value);
104         }
105     }
106 
107     function setAirDropAddress(address addr) internal {
108         airdropped[addr] = true;
109         emit Whitelisted(addr, true);
110     }
111     function setTokenTransferStatus(bool status) onlyOwner public {
112         Token_AllowTransfer = status;
113     }
114     
115 }
116 
117 library SafeMath {
118   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119     uint256 c = a * b;
120     assert(a == 0 || c / a == b);
121     return c;
122   }
123  
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a / b;
126     return c;
127   }
128  
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133  
134   function add(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a + b;
136     assert(c >= a);
137     return c;
138   }
139 }