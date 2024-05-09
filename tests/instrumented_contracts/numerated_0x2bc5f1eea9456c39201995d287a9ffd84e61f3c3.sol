1 pragma solidity ^0.4.19;
2 
3 //*************** SafeMath ***************
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
7       uint256 c = a * b;
8       assert(a == 0 || c / a == b);
9       return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure  returns (uint256) {
13       assert(b > 0);
14       uint256 c = a / b;
15       return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
19       assert(b <= a);
20       return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure  returns (uint256) {
24       uint256 c = a + b;
25       assert(c >= a);
26       return c;
27   }
28 }
29 
30 //*************** Ownable
31 
32 contract Ownable {
33   address public owner;
34 
35   function Ownable() public {
36       owner = msg.sender;
37   }
38 
39   modifier onlyOwner() {
40       require(msg.sender == owner);
41       _;
42   }
43 
44   function transferOwnership(address newOwner)public onlyOwner {
45       if (newOwner != address(0)) {
46         owner = newOwner;
47       }
48   }
49 
50 }
51 
52 //************* ERC20
53 
54 contract ERC20 {
55   uint256 public totalSupply;
56   function balanceOf(address who)public constant returns (uint256);
57   function transfer(address to, uint256 value)public returns (bool);
58   function transferFrom(address from, address to, uint256 value)public returns (bool);
59   function allowance(address owner, address spender)public constant returns (uint256);
60   function approve(address spender, uint256 value)public returns (bool);
61 
62   event Transfer(address indexed from, address indexed to, uint256 value);
63   event ExchangeTokenPushed(address indexed buyer, uint256 amount);
64   event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);  
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 //************* SOSRcoinToken
69 
70 contract SOSRcoinToken is ERC20,Ownable {
71  using SafeMath for uint256;
72 
73  // Token Info.
74  string public name;
75  string public symbol;
76 
77  uint8 public constant decimals = 18;
78 
79  address[] private walletArr;
80  uint walletIdx = 0;
81  uint256 public candyTotalSupply = 100000*(10**18);
82  uint256 public currentCandyTotalSupply = 0;
83  uint256 public candyBalance = 5*(10**18);
84  uint256 public date610 = 1528560000;
85  uint256 public totalSupply1 = 20000000*(10**18);
86  uint256 public totalSupply2 = 40000000*(10**18);
87  uint256 public minValue1 = 15 ether;
88  uint256 public minValue2 = 0.1 ether;
89  uint256 public rate1 = 1620;
90  uint256 public rate2 = 1500;
91  uint256 public rate3 = 1200;
92 
93  mapping (address => bool) touched;
94  mapping (address => uint256) public balanceOf;
95  mapping (address => mapping (address => uint256)) allowed;
96 
97  event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);
98  event FundTransfer(address fundWallet, uint256 amount);
99 
100  function SOSRcoinToken( ) public {
101    totalSupply = 50000000*(10**18);         
102    balanceOf[msg.sender] = totalSupply ; 
103    name = "SOSRcoin"; 
104    symbol ="SOSR"; 
105    walletArr.push(0x72BA86a847Ead7b69c3e92F88eb2Aa21C3Aa1C58); 
106    walletArr.push(0x39DE3fa8976572819b0012B11b506E100a765453);
107    touched[owner] = true;
108  }
109 
110  function balanceOf(address _who)public constant returns (uint256 balance) {
111     return getBalance(_who);
112  }
113  
114 function getBalance(address _who) internal constant returns(uint256){
115 	if( currentCandyTotalSupply < candyTotalSupply ){
116 	    if( touched[_who] )
117 		return balanceOf[_who];
118 	    else
119 		return balanceOf[_who].add( candyBalance );
120 	} else {
121 	    return balanceOf[_who];
122 	}
123 }
124     
125  function _transferFrom(address _from, address _to, uint256 _value)  internal {
126      require(_to != 0x0);
127      
128      if( currentCandyTotalSupply < candyTotalSupply && !touched[_from]  ){
129             balanceOf[_from] = balanceOf[_from].add( candyBalance );
130             touched[_from] = true;
131             currentCandyTotalSupply = currentCandyTotalSupply.add( candyBalance );
132      }     
133      require(balanceOf[_from] >= _value);
134      require(balanceOf[_to] + _value >= balanceOf[_to]);
135      balanceOf[_from] = balanceOf[_from].sub(_value);
136      balanceOf[_to] = balanceOf[_to].add(_value);
137      Transfer(_from, _to, _value);
138  }
139 
140  function transfer(address _to, uint256 _value) public returns (bool){     
141      _transferFrom(msg.sender,_to,_value);
142      return true;
143  }
144 
145  function push(address _buyer, uint256 _amount) public onlyOwner {
146      uint256 val=_amount*(10**18);
147      _transferFrom(msg.sender,_buyer,val);
148      ExchangeTokenPushed(_buyer, val);
149  }
150 
151  function ()public payable {
152      _tokenPurchase( );
153  }
154 
155  function _tokenPurchase( ) internal {   
156      require(saleActive(msg.value));     
157      uint256 weiAmount = msg.value;
158      uint256 actualRate = getActualRate(); 
159      uint256 amount = weiAmount.mul(actualRate);
160      _transferFrom(owner, msg.sender,amount);
161      TokenPurchase(msg.sender, weiAmount,amount);        
162      address wallet = walletArr[walletIdx];
163      walletIdx = (walletIdx+1) % walletArr.length;
164      wallet.transfer(msg.value);
165      FundTransfer(wallet, msg.value);
166  }
167 
168  function saleActive(uint256 _value) public constant returns (bool) {
169      bool res = false;
170      uint256 t = getCurrentTimestamp();
171      uint256 s = totalSupply - balanceOf[owner];
172      if(supply() > 0 && t < date610){
173        if(s < totalSupply2){
174            if( _value>=minValue1 ){
175               res = true;
176            }
177        }else{
178            if( _value>= minValue2 ){
179               res = true;
180            }
181        }
182      }
183      return res;
184  }
185 
186  function getActualRate() internal view returns (uint256){  
187     uint256 rate=0;      
188     uint256 s = totalSupply - balanceOf[owner];	
189     if(s < totalSupply1){
190 	 rate = rate1;
191     }else if(s < totalSupply2){
192 	 rate = rate2;
193     }else{
194          rate = rate3;
195     }    
196     return rate;
197  }
198  
199  function supply()  internal constant  returns (uint256) {
200      return balanceOf[owner];
201  }
202 
203  function getCurrentTimestamp() internal view returns (uint256){
204      return now;
205  }
206 
207  function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
208      return allowed[_owner][_spender];
209  }
210 
211  function approve(address _spender, uint256 _value)public returns (bool) {
212      require((_value == 0) || (allowed[msg.sender][_spender] == 0));
213      allowed[msg.sender][_spender] = _value;
214      Approval(msg.sender, _spender, _value);
215      return true;
216  }
217  
218  function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
219      var _allowance = allowed[_from][msg.sender];
220      require (_value <= _allowance);  
221       _transferFrom(_from,_to,_value);
222      allowed[_from][msg.sender] = _allowance.sub(_value);
223      Transfer(_from, _to, _value);
224      return true;
225    }
226  
227 }