1 pragma solidity ^0.4.23;
2 
3 interface token {
4     function promoCode() external returns (bytes16);
5     function specialSend(uint amount, address buyer) external;
6     function promoEthCommission() external returns (uint);
7     function owner() external returns (address);
8     function ethPromoHelpers(address input) external returns (address);
9     function balanceOf(address who) external returns (uint256);
10     function transfer(address receiver, uint amount) external;
11 }
12 
13 contract UppercaseCheck {
14     function areAllUppercase(bytes16 str) internal pure returns (bool) {
15     if(str == 0){return false;}
16     for (uint j = 0; j < 16; j++) {
17     byte char = byte(bytes16(uint(str) * 2 ** (8 * j)));
18     if (char != 0 && !((char >= 97) && (char <= 122))){return false;}}return true;}
19 }
20 library SafeMath {
21     function mul(uint256 a, uint256 b) internal pure returns (uint256){if(a == 0){return 0;}uint256 c = a * b;assert(c / a == b);return c;}
22     function div(uint256 a, uint256 b) internal pure returns (uint256){return a / b;}
23     function sub(uint256 a, uint256 b) internal pure returns (uint256){assert(b <= a);return a - b;}
24     function add(uint256 a, uint256 b) internal pure returns (uint256){uint256 c = a + b;assert(c >= a);return c;}
25 }
26 
27 contract ERC20Basic {
28     function totalSupply() public view returns (uint256);
29     function balanceOf(address who) public view returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract BasicToken is ERC20Basic {
35     using SafeMath for uint256;
36     
37     mapping(address => uint256) balances;
38     mapping(address => address) ethPromoHelpers_;
39     mapping(address => address) fishPromoHelpers_;
40     
41     uint256 totalSupply_;
42     function totalSupply() public view returns (uint256) {return totalSupply_;}
43     function ethPromoHelpers(address _input) public view returns (address) {return ethPromoHelpers_[_input];}
44     function fishPromoHelpers(address _input) public view returns (address) {return fishPromoHelpers_[_input];}
45     
46     function transfer(address _to, uint256 _value) public returns (bool) {
47         require(_to != address(0));
48         require(_to != address(this));
49         require(ethPromoHelpers(_to) == 0 && fishPromoHelpers(_to) == 0);
50         require(_value <= balances[msg.sender]);
51         balances[msg.sender] = balances[msg.sender].sub(_value);
52         balances[_to] = balances[_to].add(_value);
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56     
57     function balanceOf(address _owner) public view returns (uint256 balance) {return balances[_owner];}
58 }
59 contract ERC20 is ERC20Basic {
60     function allowance(address owner, address spender) public view returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract StandardToken is ERC20, BasicToken {
67 
68     mapping (address => mapping (address => uint256)) internal allowed;
69     
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
71         require(_to != address(0));
72         require(_to != address(this));
73         require(ethPromoHelpers(_to) == 0 && fishPromoHelpers(_to) == 0);
74         require(_value <= balances[_from]);
75         require(_value <= allowed[_from][msg.sender]);
76         balances[_from] = balances[_from].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
79         emit Transfer(_from, _to, _value);
80         return true;
81     }
82     
83     function approve(address _spender, uint256 _value) public returns (bool) {
84         allowed[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86         return true;
87     }
88     
89     function allowance(address _owner, address _spender) public view returns (uint256) {
90         return allowed[_owner][_spender];
91     }
92     
93     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
94         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
95         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
96         return true;
97     }
98     
99     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
100         uint oldValue = allowed[msg.sender][_spender];
101         if(_subtractedValue > oldValue) {
102         allowed[msg.sender][_spender] = 0;} 
103         else {allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);}
104         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105         return true;
106     }
107 
108 }
109 
110 contract Ownable {
111     address owner_;
112     constructor() public {owner_ = msg.sender;}
113     modifier onlyOwner() {require(msg.sender == owner_);_;}
114     function transferOwnership(address newOwner) public onlyOwner {require(newOwner != address(0));owner_ = newOwner;}
115     function owner() public view returns (address) {return owner_;}
116 }
117 
118 contract Factory is UppercaseCheck, StandardToken{
119     
120    uint contractCount = 0;
121    bytes16[2][] ethReceived;
122    mapping(bytes16 => address) promoCodeToContractAddress_;
123    mapping(address => uint) contractAddressToIndex;
124    
125    function returnEthReceived() public view returns (bytes16[2][]){return ethReceived;}
126    function promoCodeToContractAddress(bytes16 _input) public view returns (address){return promoCodeToContractAddress_[_input];}
127    
128    function getPromoCodeForEther(bytes16 PromoCode) external {
129        require(areAllUppercase(PromoCode));
130        require(promoCodeToContractAddress(PromoCode) == 0);
131        address myContract = new PromoContract(PromoCode);
132        promoCodeToContractAddress_[PromoCode] = myContract;
133        ethPromoHelpers_[myContract] = msg.sender;
134    }
135    function getPromoCodeForFish(bytes16 PromoCode) external {
136        require(areAllUppercase(PromoCode));
137        require(promoCodeToContractAddress(PromoCode) == 0);
138        address myContract = new PromoContract(PromoCode);
139        promoCodeToContractAddress_[PromoCode] = myContract;
140        fishPromoHelpers_[myContract] = msg.sender;
141    }
142 }
143 
144 contract Fish is Ownable, Factory{
145      
146     string public constant name = "Fish";
147     string public constant symbol = "FISH";
148     uint8 public constant decimals = 0;
149     
150     uint unitsOneEthCanBuy_ = 10000;
151     uint promoFishCommission_ = 100;
152     uint promoEthCommission_ = 40;
153     uint promoBonus_ = 20;
154     uint sizeBonus_ = 100;
155     
156     constructor() public{totalSupply_ = 0;}
157     function unitsOneEthCanBuy() public view returns (uint) {return unitsOneEthCanBuy_;}
158     function promoFishCommission() public view returns (uint) {return promoFishCommission_;}
159     function promoEthCommission() public view returns (uint) {return promoEthCommission_;}
160     function promoBonus() public view returns (uint) {return promoBonus_;}
161     function sizeBonus() public view returns (uint) {return sizeBonus_;}
162     function updateUnitsOneEthCanBuy(uint _unitsOneEthCanBuy) external onlyOwner {unitsOneEthCanBuy_ = _unitsOneEthCanBuy;}
163     function updatePromoFishCommission(uint _promoFishCommission) external onlyOwner {promoFishCommission_ = _promoFishCommission;}
164     function updatePromoEthCommission(uint _promoEthCommission) external onlyOwner {require(_promoEthCommission < 100);promoEthCommission_ = _promoEthCommission;}
165     function updatePromoBonus(uint _promoBonus) external onlyOwner{promoBonus_ = _promoBonus;}
166     function updateSizeBonus(uint _sizeBonus) external onlyOwner {sizeBonus_ = _sizeBonus;}
167 
168    function() payable public{
169         owner().transfer(msg.value);
170         if(unitsOneEthCanBuy() == 0){return;}
171         uint256 amount =  msg.value.mul(unitsOneEthCanBuy()).mul(msg.value.mul(sizeBonus()).add(10**22)).div(10**40);
172         balances[msg.sender] = balances[msg.sender].add(amount);
173         totalSupply_ = totalSupply_.add(amount);
174         emit Transfer(address(this), msg.sender, amount); 
175     }
176     
177    function getLostTokens(address _tokenContractAddress) public {
178         if(token(_tokenContractAddress).balanceOf(address(this)) != 0){
179         token(_tokenContractAddress).transfer(owner(), token(_tokenContractAddress).balanceOf(address(this)));}
180    }
181     
182    function sendToken(address _to, uint _value) external onlyOwner {
183         require(_to != address(0));
184         require(_to != address(this));
185         require(ethPromoHelpers(_to)==0 && fishPromoHelpers(_to)==0);
186         balances[_to] = balances[_to].add(_value);
187         totalSupply_ = totalSupply_.add(_value);
188         emit Transfer(address(this), _to, _value); 
189    }
190    
191    function delToken() external onlyOwner {
192         totalSupply_ = totalSupply_.sub(balances[msg.sender]);
193         emit Transfer(msg.sender, address(this), balances[msg.sender]); 
194         balances[msg.sender] = 0;
195    }
196  
197     function specialSend(uint amount, address buyer) external {
198         require(ethPromoHelpers(msg.sender) != 0 || fishPromoHelpers(msg.sender) != 0);
199         if(contractAddressToIndex[msg.sender] == 0){
200         ethReceived.push([token(msg.sender).promoCode(),bytes16(amount)]);
201         contractCount = contractCount.add(1);
202         contractAddressToIndex[msg.sender] = contractCount;}
203         else{ethReceived[contractAddressToIndex[msg.sender].sub(1)][1] = bytes16(  uint( ethReceived[contractAddressToIndex[msg.sender].sub(1)][1] ).add(amount));}
204         if(unitsOneEthCanBuy() == 0){return;}
205         uint amountFishToGive = amount.mul(unitsOneEthCanBuy()).mul(amount.mul(sizeBonus()).add(10**22)).mul(promoBonus().add(100)).div(10**42);
206         balances[buyer] = balances[buyer].add(amountFishToGive);
207         totalSupply_ = totalSupply_.add(amountFishToGive);
208         emit Transfer(address(this), buyer, amountFishToGive); 
209         if(fishPromoHelpers(msg.sender) != 0 && promoFishCommission() != 0){
210         uint256 helperAmount = promoFishCommission().mul(amountFishToGive).div(100);
211         balances[fishPromoHelpers_[msg.sender]] = balances[fishPromoHelpers(msg.sender)].add(helperAmount);
212         totalSupply_ = totalSupply_.add(helperAmount);
213         emit Transfer(address(this), fishPromoHelpers(msg.sender), helperAmount);}  
214    }
215 }
216 
217 contract PromoContract{
218     using SafeMath for uint256;
219     
220     address masterContract = msg.sender;
221     bytes16 promoCode_;
222     
223     constructor(bytes16 _promoCode) public{promoCode_ = _promoCode;}
224     function promoCode() public view returns (bytes16){return promoCode_;}
225     function() payable public{
226         if(token(masterContract).ethPromoHelpers(address(this)) != 0 && token(masterContract).promoEthCommission() != 0){
227         uint amountToGive = token(masterContract).promoEthCommission().mul(msg.value).div(100);
228         token(masterContract).owner().transfer(msg.value.sub(amountToGive)); 
229         token(masterContract).ethPromoHelpers(address(this)).transfer(amountToGive);}
230         else{token(masterContract).owner().transfer(msg.value);}
231         token(masterContract).specialSend(msg.value, msg.sender);
232     }
233 }