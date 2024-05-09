1 pragma solidity ^0.4.18;
2 
3 contract EIP20Interface {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public view returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     // uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return a / b;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 contract STTR is EIP20Interface {
65     
66     using SafeMath for uint;
67     using SafeMath for uint256;
68 
69     uint256 constant private MAX_UINT256 = 2**256 - 1;
70     mapping (address => uint256) public balances;
71     mapping (address => mapping (address => uint256)) public allowed;
72 
73     string public name;
74     uint8 public decimals;
75     string public symbol;
76     address public wallet;
77     address public contractOwner;
78     
79     uint public price = 0.0000000000995 ether;
80     
81     bool public isSalePaused = false;
82     bool public transfersPaused = false;
83     
84 
85     function STTR(
86         uint256 _initialAmount,
87         string _tokenName,
88         uint8 _decimalUnits,
89         string _tokenSymbol,
90         address _wallet,
91         address _contractOwner
92         
93     ) public {
94         balances[msg.sender] = _initialAmount;             
95         totalSupply = _initialAmount;                   
96         name = _tokenName;                                  
97         decimals = _decimalUnits;                           
98         symbol = _tokenSymbol;     
99         wallet = _wallet;
100         contractOwner = _contractOwner;
101         
102     }
103 
104     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
105         require(balances[msg.sender] >= _value);
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
113         uint256 allowance = allowed[_from][msg.sender];
114         require(balances[_from] >= _value && allowance >= _value);
115         
116         balances[_to] = balances[_to].add(_value);
117         balances[_from] = balances[_from].sub(_value);
118         if (allowance < MAX_UINT256) {
119             allowed[_from][msg.sender] =  allowed[_from][msg.sender].sub(_value);
120         }
121         Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     function balanceOf(address _owner) public view returns (uint256 balance) {
126         return balances[_owner];
127     }
128 
129     function approve(address _spender, uint256 _value) public returns (bool success) {
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }   
138     
139    
140 
141     
142       modifier onlyWhileOpen {
143         require(!isSalePaused);
144         _;
145     }
146        modifier onlyOwner() {
147         require(contractOwner == msg.sender);
148         _;
149     }
150     
151    
152     function () public payable onlyWhileOpen{
153         require(msg.value>0);
154         require(msg.value<=200 ether);
155         require(msg.sender != address(0));
156         
157         uint toMint = msg.value/price;
158         totalSupply += toMint;
159         balances[msg.sender] = balances[msg.sender].add(toMint);
160         wallet.transfer(msg.value);
161         Transfer(0, msg.sender, toMint);
162         
163     }
164     
165    
166     function pauseSale()
167         public
168         onlyOwner
169         returns (bool) {
170             isSalePaused = true;
171             return true;
172         }
173 
174     function restartSale()
175         public
176         onlyOwner
177         returns (bool) {
178             isSalePaused = false;
179             return true;
180         }
181         
182     function setPrice(uint newPrice)
183         public
184         onlyOwner {
185             price = newPrice;
186         }
187    
188       modifier whenNotPaused() {
189     require(!transfersPaused);
190     _;
191   }
192   
193   modifier whenPaused() {
194     require(transfersPaused);
195     _;
196   }
197 
198   function pauseTransfers() 
199     onlyOwner 
200     whenNotPaused 
201     public {
202     transfersPaused = true;
203   }
204 
205   function unPauseTransfers() 
206     onlyOwner 
207     whenPaused 
208     public {
209     transfersPaused = false;
210   }
211      function withdrawTokens(address where) onlyOwner public returns (bool) {
212         uint256 Amount = balances[address(this)];
213         balances[address(this)] = balances[address(this)].sub(Amount);
214         balances[where] = balances[where].add(Amount);
215         Transfer(address(this), where, Amount);
216     }
217 
218     
219 }