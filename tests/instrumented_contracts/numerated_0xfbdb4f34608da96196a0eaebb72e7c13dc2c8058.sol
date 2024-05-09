1 pragma solidity ^0.4.16;
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
26 contract owned {
27     address public owner;
28     constructor() public {
29         owner = msg.sender;
30     }
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35     function transferOwnership(address newOwner) onlyOwner public {
36         owner = newOwner;
37     }
38 }
39 contract ERNToken is owned {
40     using SafeMath for uint256;
41     string public constant name = "ERNToken";
42     string public constant symbol = "ERN";
43     uint public constant decimals = 8;
44     uint constant ONETOKEN = 10 ** uint256(decimals);
45     uint constant MILLION = 1000000; 
46     uint public constant Total_TokenSupply = 1000 * MILLION * ONETOKEN; //1B Final Token Supply
47     uint public totalSupply;
48     uint public Dev_Supply;
49     uint public GrowthPool_Supply;
50     uint public Rewards_Supply;                                //to be added 45% Rewards 
51     bool public DevSupply_Released = false;                     //Locked 3% Dev Supply
52     bool public GrowthPool_Released = false;                    //Locked 2% Growth Pool Supply
53     bool public ICO_Finished = false;                           //ICO Status
54     uint public ICO_Tier = 0;                                   //ICO Tier (1,2,3,4)
55     uint public ICO_Supply = 0;                                 //ICO Supply will change per Tier
56     uint public ICO_TokenValue = 0;                             //Token Value will change per ICO Tier
57     bool public ICO_AllowPayment;                               //Control Ether Payment when ICO is On
58     bool public Token_AllowTransfer = false;                    //Locked Token Holder for transferring ERN
59     uint public Collected_Ether;
60     uint public Total_SoldToken;
61     uint public Total_ICOSupply;
62     address public etherWallet = 0x90C5Daf1Ca815aF29b3a79f72565D02bdB706126;
63     
64     constructor() public {
65         totalSupply = 1000 * MILLION * ONETOKEN;                        //1 Billion Total Supply
66         Dev_Supply = totalSupply.mul(3).div(100);                       //3% of Supply -> locked until 01/01/2020
67         GrowthPool_Supply = totalSupply.mul(2).div(100);                //2% of Supply -> locked until 01/01/2019
68         Rewards_Supply = totalSupply.mul(45).div(100);                  //45% of Supply -> use for rewards, bounty, mining, etc
69         totalSupply -= Dev_Supply + GrowthPool_Supply + Rewards_Supply; //50% less for initial token supply 
70         Total_ICOSupply = totalSupply;                                  //500M ICO supply
71         balanceOf[msg.sender] = totalSupply;                            
72     }
73     
74     mapping (address => uint256) public balanceOf;
75     mapping (address => bool) public whitelist;
76     mapping (address => uint256) public PrivateSale_Cap;
77     mapping (address => uint256) public PreIco_Cap;
78     mapping (address => uint256) public MainIco_Cap;
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Burn(address indexed from, uint256 value);
82     event Whitelisted(address indexed target, bool whitelist);
83     event IcoFinished(bool finish);
84     
85     modifier notLocked{
86         require(Token_AllowTransfer == true || msg.sender == owner);
87         _;
88     }
89     modifier buyingToken{
90         require(ICO_AllowPayment == true);
91         require(msg.sender != owner);
92         
93         if(ICO_Tier == 1)
94         {
95             require(whitelist[msg.sender]);
96         }
97         if(ICO_Tier == 2)                                       
98         {
99             require(whitelist[msg.sender]);
100             require(PrivateSale_Cap[msg.sender] + msg.value <= 5 ether); //private sale -> 5 Eth Limit
101         }
102         if(ICO_Tier == 3)                                       
103         {
104             require(whitelist[msg.sender]);
105             require(PreIco_Cap[msg.sender] + msg.value <= 15 ether);    //pre-ico -> 15 Eth Limit
106         }
107         if(ICO_Tier == 4)                                       
108         {
109             require(whitelist[msg.sender]);
110             require(MainIco_Cap[msg.sender] + msg.value <= 15 ether);   //main-ico -> 15 Eth Limit
111         }
112         _;
113     }
114     function unlockDevTokenSupply() onlyOwner public {
115         require(now > 1577836800);                              //can be unlocked only on 1/1/2020
116         require(DevSupply_Released == false);       
117         balanceOf[owner] += Dev_Supply;
118         totalSupply += Dev_Supply;          
119         emit Transfer(0, this, Dev_Supply);
120         emit Transfer(this, owner, Dev_Supply);
121         Dev_Supply = 0;                                         //clear dev supply -> 0
122         DevSupply_Released = true;                              //to avoid next execution
123     }
124     function unlockGrowthPoolTokenSupply() onlyOwner public {
125         require(now > 1546300800);                              //can be unlocked only on 1/1/2019
126         require(GrowthPool_Released == false);      
127         balanceOf[owner] += GrowthPool_Supply;
128         totalSupply += GrowthPool_Supply;
129         emit Transfer(0, this, GrowthPool_Supply);
130         emit Transfer(this, owner, GrowthPool_Supply);
131         GrowthPool_Supply = 0;                                  //clear growthpool supply -> 0
132         GrowthPool_Released = true;                             //to avoid next execution
133     }
134     function sendUnsoldTokenToRewardSupply() onlyOwner public {
135         require(ICO_Finished == true);    
136         uint totalUnsold = Total_ICOSupply - Total_SoldToken;   //get total unsold token on ICO
137         Rewards_Supply += totalUnsold;                          //add to rewards / mineable supply
138         Total_SoldToken += totalUnsold;
139     }
140     function giveReward(address target, uint256 reward) onlyOwner public {
141         require(Rewards_Supply >= reward);
142         balanceOf[target] += reward;
143         totalSupply += reward;
144         emit Transfer(0, this, reward);
145         emit Transfer(this, target, reward);
146         Rewards_Supply -= reward;
147     }
148     function _transferToken(address _from, address _to, uint _value) internal {
149         require(_to != 0x0);
150         require(balanceOf[_from] >= _value);
151         require(balanceOf[_to] + _value > balanceOf[_to]);
152         uint previousBalances = balanceOf[_from] + balanceOf[_to];
153         balanceOf[_from] -= _value;
154         balanceOf[_to] += _value;
155         emit Transfer(_from, _to, _value);
156         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
157     }
158     function transfer(address _to, uint256 _value) notLocked public {
159         _transferToken(msg.sender, _to, _value);
160     }
161     function burn(uint256 _value) public returns (bool success) {
162         require(balanceOf[msg.sender] >= _value);   
163         balanceOf[msg.sender] -= _value;            
164         totalSupply -= _value;                 
165         emit Burn(msg.sender, _value);
166         return true;
167     }
168     function _transfer(address _from, address _to, uint _value) internal {
169         require (_to != 0x0);                               
170         require (balanceOf[_from] >= _value); 
171         require (balanceOf[_to] + _value >= balanceOf[_to]);
172         balanceOf[_from] -= _value;
173         balanceOf[_to] += _value;
174         emit Transfer(_from, _to, _value);
175     }
176     function() payable buyingToken public {
177         uint totalToken = (msg.value.mul(ICO_TokenValue)).div(10 ** 18);
178         totalToken = totalToken.mul(ONETOKEN);
179         require(ICO_Supply >= totalToken);
180         if(ICO_Tier == 2)
181         {
182             PrivateSale_Cap[msg.sender] += msg.value;
183         }
184         if(ICO_Tier == 3)
185         {
186             PreIco_Cap[msg.sender] += msg.value;
187         }
188         if(ICO_Tier == 4)
189         {
190             MainIco_Cap[msg.sender] += msg.value;
191         }
192         ICO_Supply -= totalToken;
193         _transfer(owner, msg.sender, totalToken);
194         uint256 sendBonus = icoReturnBonus(msg.value);
195         if(sendBonus != 0)
196         {
197             msg.sender.transfer(sendBonus);
198         }
199         etherWallet.transfer(this.balance);
200         Collected_Ether += msg.value - sendBonus;               //divide 18 decimals
201         Total_SoldToken += totalToken;                          //divide 8 decimals
202     }
203     function icoReturnBonus(uint256 amount) internal constant returns (uint256) {
204         uint256 bonus = 0;
205         if(ICO_Tier == 1)
206         {
207             bonus = amount.mul(15).div(100);
208         }
209         if(ICO_Tier == 2)
210         {
211             bonus = amount.mul(12).div(100);
212         }
213         if(ICO_Tier == 3)
214         {
215             bonus = amount.mul(10).div(100);
216         }
217         if(ICO_Tier == 4)
218         {
219             bonus = amount.mul(8).div(100);
220         }
221         return bonus;
222     }
223     function withdrawEther() onlyOwner public{
224         owner.transfer(this.balance);
225     }
226     function setIcoTier(uint256 newTokenValue) onlyOwner public {
227         require(ICO_Finished == false && ICO_Tier < 4);
228         ICO_Tier += 1;
229         ICO_AllowPayment = true;
230         ICO_TokenValue = newTokenValue;
231         if(ICO_Tier == 1){
232             ICO_Supply = 62500000 * ONETOKEN;               //62.5M supply -> x private sale 
233         }
234         if(ICO_Tier == 2){
235             ICO_Supply = 100 * MILLION * ONETOKEN;          //100M supply -> private sale
236         }
237         if(ICO_Tier == 3){
238             ICO_Supply = 150 * MILLION * ONETOKEN;          //150M supply -> pre-ico
239         }
240         if(ICO_Tier == 4){
241             ICO_Supply = 187500000 * ONETOKEN;              //187.5M supply -> main-ico
242         }
243     }
244     function FinishIco() onlyOwner public {
245         require(ICO_Tier >= 4);
246         ICO_Supply = 0;
247         ICO_Tier = 0;
248         ICO_TokenValue = 0;
249         ICO_Finished = true;
250         ICO_AllowPayment = false;
251         emit IcoFinished(true);
252     }
253     function setWhitelistAddress(address addr, bool status) onlyOwner public {
254         whitelist[addr] = status;
255         emit Whitelisted(addr, status);
256     }
257     function setIcoPaymentStatus(bool status) onlyOwner public {
258         require(ICO_Finished == false);
259         ICO_AllowPayment = status;
260     }
261     function setTokenTransferStatus(bool status) onlyOwner public {
262         require(ICO_Finished == true);
263         Token_AllowTransfer = status;
264     }
265     
266 }