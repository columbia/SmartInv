1 pragma solidity ^0.4.21;
2 contract owned {
3     address public owner;
4     event Log(string s);
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17     function isOwner()public{
18         if(msg.sender==owner)emit Log("Owner");
19         else{
20             emit Log("Not Owner");
21         }
22     }
23 }
24 contract SisterToken is owned{
25     string public name;
26     string public symbol;
27     uint8 public decimals = 4;
28     uint256 public totalSupply;
29     uint256 public buyPrice;
30     
31     uint256 private activeUsers;
32     
33     address[9] phonebook = [0x2c0cAC04A9Ffee0D496e45023c907b71049Ed0F0,
34                             0xcccC551e9701c2A5D07a3062a604972fa12226E8,
35                             0x97d1352b2A2E0175471Ca730Cb6510D0164bFb0B,
36                             0x80f395fd4E1dDE020d774faB983b8A9d0DCCA516,
37                             0xCeb646336bBA29A9E8106A44065561D495166230,
38                             0xDce66F4a697A88d00fBB3fDDC6D44FD757852394,
39                             0x8CCc39c1516EF25AC0E6bC1A6bb7cf159d28FD71,
40                             0xaF9cD61b3B5C4C07376141Ef8F718BB0893ab371,
41                             0x5A53D72E763b2D3e2f2f347ed774AAaE872861a4];
42     address bounty = 0xAB90CB176709558bA5D2DDA8aeb1F65e24f2409f;
43     address bank = owner;
44     mapping (address => uint256) public balanceOf;
45     mapping (address => uint256) public accountID;
46     mapping (uint256 => address) public accountFromID;
47     mapping (address => bool) public isRegistered;
48     mapping (address => bool) public isTrusted;
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event TransferNeo(address indexed from, address indexed to, uint256 value);
52     event Burn(address indexed from, uint256 value);
53     event Log(string t);
54     event Log32(bytes32);
55     event LogA(address);
56     event Multiplier(uint m);
57     event isSender(address user,bool confirm);
58     event isTrusted(address user,bool confirm);
59     event Value(uint v);
60 
61     modifier registered {
62         require(isRegistered[msg.sender]);
63         _;
64     }
65     modifier trusted {
66         require(isTrusted[msg.sender]);
67         _;
68     }
69     modifier isAfterRelease{
70         require(block.timestamp>1525550400);
71         _;
72     }
73     function SisterToken(
74         uint256 initialSupply,
75         string tokenName,
76         string tokenSymbol
77     ) public payable{
78         totalSupply = initialSupply * 10 ** uint256(decimals);
79         balanceOf[owner] = 85*totalSupply/100;
80         balanceOf[bounty] = 5*totalSupply/100;
81         uint i;
82         for(i=0;i<9;i++){
83             balanceOf[phonebook[i]] = totalSupply/90;
84             registerAccount(phonebook[i]);
85         }
86         name = tokenName;
87         symbol = tokenSymbol;
88     }
89 //----------------------------------------------------------------------ACCESSOR FUNCTIONS------------------------------------------------------------------------------//
90     function getbuyPrice()public view returns(uint256){
91         return(buyPrice);
92     }
93     function getMultiplier()public view returns(uint256){
94         uint256 multiplier;
95         if(block.timestamp>1525550400){
96             if(block.timestamp < 1525636800){
97                 multiplier = 150;
98             }else if(block.timestamp < 1526155200){
99                 multiplier = 140;
100             }else if(block.timestamp <1526760000){
101                 multiplier = 125;
102             }else if(block.timestamp <1527364800){
103                 multiplier = 115;
104             }else if(block.timestamp <1527969600){
105                 multiplier = 105;
106             }
107         }else{
108             multiplier=100;
109         }
110         return(multiplier);
111     }
112 //---------------------------------------------------------------------MUTATOR FUNCTIONS---------------------------------------------------------------------------//
113     function trustContract(address contract1)public onlyOwner{
114         isTrusted[contract1]=true;
115     }
116     function untrustContract(address contract1)public onlyOwner{
117         isTrusted[contract1]=false;
118     }
119     function setPrice(uint256 newBuyPrice) onlyOwner public {
120         buyPrice = newBuyPrice;
121     }
122     function changeBank(address newBank) onlyOwner public{
123         bank = newBank;
124     }
125 //-------------------------------------------------------------------INTERNAL FUNCTIONS--------------------------------------------------------------------------//
126     function _transfer(address _from, address _to, uint _value) internal {
127         require(_to != 0x0);
128         require(balanceOf[_from] >= _value);
129         require(balanceOf[_to] + _value > balanceOf[_to]);
130         uint previousBalances = balanceOf[_from] + balanceOf[_to];
131         balanceOf[_from] -= _value;
132         balanceOf[_to] += _value;
133         emit Transfer(_from, _to, _value);
134         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
135     }
136     function registerAccount(address user)internal{
137         if(!isRegistered[user]){
138             isRegistered[user] = true;
139             activeUsers+=1;
140             accountID[user] = activeUsers;
141             accountFromID[activeUsers] = user;
142         }
143     }
144     function burnFrom(address _from, uint256 _value) internal returns (bool success) {
145         require(balanceOf[_from] >= _value);
146         balanceOf[_from] -= _value;
147         totalSupply -= _value;
148         emit Burn(_from, _value);
149         return true;
150     }
151     function trasnferFromOwner(address to,uint value)internal {
152         _transfer(owner,to,value);
153     }
154     function _buy(address user)external payable trusted isAfterRelease{
155         require(owner.balance > 0);
156         emit isTrusted(user,isTrusted[msg.sender]||msg.sender==user);
157         uint256 amount = (getMultiplier()*2*msg.value/buyPrice)/100;
158         emit Value(amount);
159         trasnferFromOwner(user,amount);
160         bank.transfer(msg.value);
161     }
162 //------------------------------------------------------------------EXTERNAL FUNCTIONS-------------------------------------------------------------------------//
163     function registerExternal()external{
164         registerAccount(msg.sender);
165     }
166     function contractBurn(address _for,uint256 value)external trusted{
167         burnFrom(_for,value);
168     }
169 //----------------------------------------------------------------PUBLIC USER FUNCTIONS-----------------------------------------------------------------------//
170     function transfer(address to, uint256 val)public payable{
171         _transfer(msg.sender,to,val);
172     }
173     function burn(uint256 val)public{
174         burnFrom(msg.sender,val);
175     }
176     function register() public {
177         registerAccount(msg.sender);
178     }
179     function testConnection() external {
180         emit Log(name);
181     }
182 }